import pandas as pd
import re
import os

def update_equipment_gd(csv_path, gd_path, output_path):
    # Load CSV data
    if not os.path.exists(csv_path):
        print(f"Error: {csv_path} not found.")
        return
    
    df = pd.read_csv(csv_path)
    # The first column contains the weapon names
    name_col = df.columns[0]
    df = df.dropna(subset=[name_col])

    # Load GDScript content
    if not os.path.exists(gd_path):
        print(f"Error: {gd_path} not found.")
        return
        
    with open(gd_path, 'r', encoding='utf-8') as f:
        gd_content = f.read()

    # Columns to transfer from CSV to GDScript
    keys_to_update = [
        'min_dmg', 'max_dmg', 'weight', 'speed', 
        'crit_chance', 'crit_multi', 'durability', 
        'str_req', 'skill_req', 'price', 'stock', 'level'
    ]

    for _, row in df.iterrows():
        # Convert "Steel Sword" to "steel_sword"
        weapon_name = str(row[name_col])
        weapon_id = weapon_name.lower().replace(" ", "_").replace("-", "_")
        
        # Regex to find the start of the weapon dictionary block
        # Look for "weapon_id": {
        start_pattern = rf'"{weapon_id}"\s*:\s*\{{'
        match = re.search(start_pattern, gd_content)
        
        if not match:
            continue
            
        start_idx = match.start()
        
        # Find the end of this weapon's block by matching curly braces
        brace_count = 0
        end_idx = -1
        # Start scanning from where the opening brace was found
        for i in range(match.end() - 1, len(gd_content)):
            if gd_content[i] == '{':
                brace_count += 1
            elif gd_content[i] == '}':
                brace_count -= 1
                if brace_count == 0:
                    end_idx = i + 1
                    break
        
        if end_idx == -1:
            continue

        # Extract the specific weapon block substring
        block = gd_content[start_idx:end_idx]
        
        # Update each key within this block
        for key in keys_to_update:
            if key in df.columns and not pd.isna(row[key]):
                val = row[key]
                # Formatting: remove .0 if it's an integer
                if val == int(val):
                    val_str = str(int(val))
                else:
                    val_str = str(val)
                
                # Regex to replace "key": value with the new value
                # This ensures we only replace values within this specific weapon block
                key_pattern = rf'("{key}"\s*:\s*)[^,}} \n\t]+'
                block = re.sub(key_pattern, rf'\g<1>{val_str}', block)
        
        # Re-insert the modified block into the full file content
        gd_content = gd_content[:start_idx] + block + gd_content[end_idx:]

    # Write the updated content to the output file
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(gd_content)
    
    print(f"Update complete. File saved as {output_path}")

if __name__ == "__main__":
    update_equipment_gd('weapons_base_stats.csv', 'Equipment.gd', 'Equipment_updated.gd')