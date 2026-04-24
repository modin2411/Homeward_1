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
