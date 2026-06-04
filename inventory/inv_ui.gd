extends Control

@onready var inv: Inv
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open = false 

func _ready():
	await get_tree().process_frame
	add_to_group("inventory_ui")

	var player_node = get_player_node()
	if player_node == null:
		push_error("No player in group 'player' or 'Player'!")
		return

	inv = player_node.inv

	update_slots()
	close()


func get_player_node():
	var players_lower = get_tree().get_nodes_in_group("player")
	if not players_lower.is_empty():
		return players_lower[0]

	var players_upper = get_tree().get_nodes_in_group("Player")
	if not players_upper.is_empty():
		return players_upper[0]

	return null
	
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
