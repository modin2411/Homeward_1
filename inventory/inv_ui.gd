extends Control

@onready var inv: Inv
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open = false 

func _ready():
	await get_tree().process_frame
	add_to_group("inventory_ui")
	var players = get_tree().get_nodes_in_group("player")
	if players.is_empty():
		push_error("No player in group!")
		return
	
	inv = players[0].inv
	
	update_slots()
	close()
	
func update_slots():
	print("UI UPDATE CALLED")
	for i in range(slots.size()):
		if i < inv.items.size():
			slots[i].update(inv.items[i])
		else:
			slots[i].update(null)
	for i in range(min(inv.items.size(), slots.size())):
		slots[i].update(inv.items[i])
		
func _process(delta):
	if Input.is_action_just_pressed("Inventory"):
		if is_open:
			close()
		else:
			open()

func open():
	self.visible = true
	is_open = true	
	
func close():
	visible = false
	is_open = false
