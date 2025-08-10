extends Control

@onready var coins_label = $Panel/coin_label
@onready var no_sfx = $AudioStreamPlayer
@onready var coin_label = $Panel/coin_label

"""
1x stone  = 10
1x branch = 5
1x grass  = 2
"""

func _ready() -> void:
	update_coins()

func update_coins() -> void:
	coin_label.text = "%d" % GameState.coins

func non_sfx() -> void:
	no_sfx.play()

func _on_sell_1_stone_pressed() -> void:
	if GameState.stone_count > 0:
		GameState.stone_count -= 1
		GameState.coins += 10
		update_coins()
	else:
		non_sfx()

func _on_sell_1_branch_pressed() -> void:
	if GameState.branch_count > 0:
		GameState.branch_count -= 1
		GameState.coins += 5
		update_coins()
	else:
		non_sfx()
		

func _on_sell_1_grass_pressed() -> void:
	if GameState.grass_count > 0:
		GameState.grass_count -= 1
		GameState.coins += 2
		update_coins()
	else:
		non_sfx()

func _on_sell_all_stone_pressed() -> void:
	if GameState.stone_count > 0:
		GameState.coins += GameState.stone_count * 10
		GameState.stone_count = 0
		update_coins()
	else:
		non_sfx()

func _on_sell_all_branch_pressed() -> void:
	if GameState.branch_count > 0:
		GameState.coins += GameState.branch_count * 5
		GameState.branch_count = 0
		update_coins()
	else:
		non_sfx()

func _on_sell_all_grass_pressed() -> void:
	if GameState.grass_count > 0:
		GameState.coins += GameState.grass_count * 2
		GameState.grass_count = 0
		update_coins()
	else:
		non_sfx()

func _on_sell_all_pressed() -> void:
	var sold = false

	if GameState.stone_count > 0:
		GameState.coins += GameState.stone_count * 10
		GameState.stone_count = 0
		sold = true

	if GameState.branch_count > 0:
		GameState.coins += GameState.branch_count * 5
		GameState.branch_count = 0
		sold = true

	if GameState.grass_count > 0:
		GameState.coins += GameState.grass_count * 2
		GameState.grass_count = 0
		sold = true

	if sold:
		update_coins()
	else:
		non_sfx()
