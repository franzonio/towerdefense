extends Panel

var current_page := 1
var max_pages := 0

func _ready():
	max_pages = $Pages.get_child_count()
	_update_pages()
	_update_page_label()


func _on_previous_page_pressed():
	if current_page > 1:
		current_page -= 1
		_update_pages()
		_update_page_label()


func _on_next_page_pressed():
	if current_page < max_pages:
		current_page += 1
		_update_pages()
		_update_page_label()


func _update_pages():
	for i in range(max_pages):
		var page = $Pages.get_child(i)
		page.visible = (i + 1) == current_page


func _update_page_label():
	$PageLabel.text = "%d/%d" % [current_page, max_pages]
