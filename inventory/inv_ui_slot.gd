extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display
@onready var amount_label: Label = $CenterContainer/Panel/amountLabel  # 👈 NEU

func update(slot: InvSlot):
	if slot == null or slot.item == null:
		item_visual.visible = false
		amount_label.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture

		# 👇 Anzahl anzeigen
		if slot.amount > 1:
			amount_label.visible = true
			amount_label.text = str(slot.amount)
		else:
			amount_label.visible = false
