extends Node2D

@onready var stone_label = $Camera2D/VBoxContainer_left/stone_text
@onready var branch_label = $Camera2D/VBoxContainer_left/branch_text
@onready var grass_label = $Camera2D/VBoxContainer_left/grass_text
@onready var coins_label = $Camera2D/VBoxContainer_right/coin_text
@onready var pickaxe_label = $Camera2D/VBoxContainer_right/pickaxe_text
@onready var axe_label = $Camera2D/VBoxContainer_right/axe_text
@onready var scythe_label = $Camera2D/VBoxContainer_right/scythe_text
@onready var xp_bar = $Camera2D/XP_bar
@onready var level_label = $Camera2D/level_text
@onready var ui_right = $Camera2D/VBoxContainer_right
@onready var ui_left = $Camera2D/VBoxContainer_left
@onready var sell_btn = $Camera2D/Sell
@onready var upgrade_btn = $Camera2D/Upgrade
@onready var sell_gui = $Camera2D/Sell_items
@onready var upgrade_tools_ui = $Camera2D/Upgrade_tools

func _on_leveled_up() -> void:
	$Level_up.play()

func _on_xp_changed() -> void:
	xp_bar.value = GameState.player_xp
	xp_bar.max_value = GameState.xp_next_lv

func _ready() -> void:
	GameState.leveled_up.connect(_on_leveled_up)
	GameState.xp_changed.connect(_on_xp_changed)
	upgrade_tools_ui.visible = false
	ui_left.visible = false
	ui_right.visible = false
	sell_btn.visible = false
	upgrade_btn.visible = false
	sell_gui.visible = false
	xp_bar.max_value = GameState.xp_next_lv
	xp_bar.value = GameState.player_xp
	level_label.text = "%d" % GameState.player_level

func _process(_delta):
	level_label.text = "%d" % GameState.player_level
	xp_bar.value = GameState.player_xp
	if ui_left.visible and ui_right.visible:
		stone_label.text = format_number(GameState.stone_count)
		branch_label.text = format_number(GameState.branch_count)
		grass_label.text = format_number(GameState.grass_count)
		coins_label.text = format_number(GameState.coins)
		pickaxe_label.text = format_number(GameState.pickaxe_dmg)
		axe_label.text = format_number(GameState.axe_dmg)
		scythe_label.text = format_number(GameState.scythe_dmg)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_ui"):
		ui_left.visible = not ui_left.visible
		ui_right.visible = not ui_right.visible
		sell_btn.visible = not sell_btn.visible
		upgrade_btn.visible = not upgrade_btn.visible
	

func format_number(value: int) -> String:
	if value >= 1_000_000_000:
		return "%.2fB" % (value / 1_000_000_000.0)
	elif value >= 1_000_000:
		return "%.2fM" % (value / 1_000_000.0)
	elif value >= 1_000:
		return "%.1fk" % (value / 1_000.0)
	else:
		return str(value)


func _on_sell_pressed() -> void:
	# If sell GUI is being opened, close upgrade GUI
	if not sell_gui.visible:
		upgrade_tools_ui.visible = false
	sell_gui.visible = not sell_gui.visible

func _on_upgrade_pressed() -> void:
	# If upgrade GUI is being opened, close sell GUI
	if not upgrade_tools_ui.visible:
		sell_gui.visible = false
	upgrade_tools_ui.visible = not upgrade_tools_ui.visible
