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

func update_trash_text(trash_type: TrashCardStats.types) -> void:
	match trash_type:
		TrashCardStats.types.paper:
			return
		TrashCardStats.types.plastic:
			return
		TrashCardStats.types.metal:
			return
		TrashCardStats.types.glass:
			return
		TrashCardStats.types.organic:
			return
