import pandas as pd
import re
import os

def update_category(csv_path, gd_content, keys_to_update, category_label):
    """
    Updates the GDScript content with values from a specific CSV file.
    """
    if not os.path.exists(csv_path):
        print(f"[SKIP] {category_label} file not found: {csv_path}")
        return gd_content, []

    print(f"[PROCESS] Updating {category_label} from {csv_path}...")
    df = pd.read_csv(csv_path)
    name_col = df.columns[0]
    df = df.dropna(subset=[name_col])

    unused_items = []
    match_count = 0

    for _, row in df.iterrows():
        item_name = str(row[name_col]).strip()
        if not item_name:
            continue

        # Convert "Iron Shield" to "iron_shield"
        item_id = item_name.lower().replace(" ", "_").replace("-", "_")
        
        # Locate the block for this specific item ID
        start_pattern = rf'"{item_id}"\s*:\s*\{{'
        match = re.search(start_pattern, gd_content)
        
        if not match:
            unused_items.append(item_name)
            continue
            
        start_idx = match.start()
        
        # Balance braces to find the end of the item's dictionary
        brace_count = 0
        end_idx = -1
        for i in range(match.end() - 1, len(gd_content)):
            if gd_content[i] == '{':
                brace_count += 1
            elif gd_content[i] == '}':
                brace_count -= 1
                if brace_count == 0:
                    end_idx = i + 1
                    break
        
        if end_idx == -1:
            unused_items.append(item_name)
            continue

        # Modify the specific block for this item
        block = gd_content[start_idx:end_idx]
        for key in keys_to_update:
            if key in df.columns and not pd.isna(row[key]):
                val = row[key]
                # Format: remove .0 for integers, keep floats for others
                val_str = str(int(val)) if val == int(val) else str(val)
                
                # Replace only existing keys to maintain file structure integrity
                key_pattern = rf'("{key}"\s*:\s*)[^,}} \n\t]+'
                block = re.sub(key_pattern, rf'\g<1>{val_str}', block)
        
        # Stitch the updated block back into the main content
        gd_content = gd_content[:start_idx] + block + gd_content[end_idx:]
        match_count += 1

    print(f"        -> Successfully updated {match_count} items.")
    return gd_content, unused_items

def main():
    gd_input_path = 'Equipment.gd'
    gd_output_path = 'Equipment_updated.gd'
    
    if not os.path.exists(gd_input_path):
        print(f"Error: {gd_input_path} not found.")
        return

    with open(gd_input_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. Update Weapons
    weapon_keys = [
        'min_dmg', 'max_dmg', 'weight', 'speed', 'crit_chance', 
        'crit_multi', 'durability', 'str_req', 'skill_req', 'price'
    ]
    content, unused_w = update_category('weapons_base_stats.csv', content, weapon_keys, "Weapons")

    # 2. Update Shields
    shield_keys = [
        'absorb', 'weight', 'durability', 'str_req', 'skill_req', 'price', 'stock', 'level'
    ]
    content, unused_s = update_category('shield_base_stats.csv', content, shield_keys, "Shields")

    # 3. Update Armor
    armor_keys = [
        'absorb', 'weight', 'str_req', 'price', 'stock', 'level'
    ]
    content, unused_a = update_category('armor_base_stats.csv', content, armor_keys, "Armor")

    # Save the final consolidated file
    with open(gd_output_path, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"\nConsolidated update complete. Saved to: {gd_output_path}")

    # Final reporting for missed items
    for label, items in [("Weapons", unused_w), ("Shields", unused_s), ("Armor", unused_a)]:
        if items:
            print(f"\n[MISSING] Items in {label} CSV but not found in GDScript:")
            for itm in items:
                print(f" - {itm}")

if __name__ == "__main__":
    main()