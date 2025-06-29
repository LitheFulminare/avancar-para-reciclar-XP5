class_name PlayerStatsHud
extends TextureRect

@export_group("Game scene nodes")
@export var player: Player

@export_group("Node components")
@export var total_points_label: Label
@export var paper_label: Label
@export var metal_label: Label
@export var glass_label: Label
@export var plastic_label: Label
@export var organic_label: Label

#region trash type name reference
#enum types 
#{ 
	#paper,
	#plastic,
	#metal,
	#glass,
	#organic
#}
#endregion

func _ready() -> void:
	update_trash_text(TrashCardStats.types.paper)
	update_trash_text(TrashCardStats.types.plastic)
	update_trash_text(TrashCardStats.types.metal)
	update_trash_text(TrashCardStats.types.glass)
	update_trash_text(TrashCardStats.types.organic)
	
	update_total_points()
	
	player.trash_inventory_changed.connect(update_trash_text)
	player.points_changed.connect(update_total_points)

# updates the text based on what type of trash count need to be updated
func update_trash_text(trash_type: TrashCardStats.types) -> void:
	match trash_type:
		TrashCardStats.types.paper:
			paper_label.text = str(player.paper_trash_cards.size())
		TrashCardStats.types.plastic:
			plastic_label.text = str(player.plastic_trash_cards.size())
		TrashCardStats.types.metal:
			metal_label.text = str(player.metal_trash_cards.size())
		TrashCardStats.types.glass:
			glass_label.text = str(player.glass_trash_cards.size())
		TrashCardStats.types.organic:
			organic_label.text = str(player.organic_trash_cards.size())

func update_total_points() -> void:
	total_points_label.text = str(player.points)
