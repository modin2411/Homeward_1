extends Resource
class_name Inv

@export var items: Array[InvSlot] = []

func insert(item: InvItem):
	print("Insert OK:", item)

	# 1. prüfen ob schon existiert
	for slot in items:
		if slot.item == item:
			slot.amount += 1
			print("STACK +1")
			return

	# 2. neuer Slot
	var new_slot = InvSlot.new()
	new_slot.item = item
	new_slot.amount = 1
	items.append(new_slot)

	print("SIZE:", items.size())

func get_apple_count() -> int:
	var count = 0
	for slot in items:
		if slot.item.name == "apple":
			count += slot.amount
	return count


func remove_items(item_name: String, amount: int):
	var removed = 0

	for slot in items:
		if slot.item.name == item_name:
			while slot.amount > 0 and removed < amount:
				slot.amount -= 1
				removed += 1
