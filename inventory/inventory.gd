extends Resource
class_name Inv

signal updated

@export var items: Array[InvSlot] = []


func insert(item: InvItem):
	print("Insert OK:", item)

	# bereits vorhanden
	for slot in items:
		if slot.item == item:
			slot.amount += 1
			print("STACK +1")
			updated.emit()
			return

	# neuer Slot
	var new_slot = InvSlot.new()
	new_slot.item = item
	new_slot.amount = 1
	items.append(new_slot)

	print("SIZE:", items.size())

	updated.emit()


func get_item_count(item_name: String) -> int:
	var count = 0

	for slot in items:
		if slot.item != null and slot.item.name == item_name:
			count += slot.amount

	return count


func get_apple_count() -> int:
	var count = 0

	for slot in items:
		if slot.item != null and slot.item.name == "apple":
			count += slot.amount

	return count


func remove_items(item_name: String, amount: int):
	var removed = 0
	
	for slot in items:
		if slot.item != null and slot.item.name == item_name:

			while slot.amount > 0 and removed < amount:
				slot.amount -= 1
				removed += 1

			if removed >= amount:
				break

	# leere Slots entfernen
	items = items.filter(func(slot):
		return slot.amount > 0
	)

	updated.emit()
