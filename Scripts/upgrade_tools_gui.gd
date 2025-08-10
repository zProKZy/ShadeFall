extends Control

@onready var enchance_panel = $Enchance_panel
@onready var choice_panel = $choice_panel
@onready var upgrade_panel = $Upgrade_panel
# @onready var back_enchance = $Enchance_panel/back_enchance

@onready var coins_req_axe = $Enchance_panel/coins_label/coins_req_axe
@onready var coins_req_pickaxe = $Enchance_panel/coins_label/coins_req_pickaxe
@onready var coins_req_scythe = $Enchance_panel/coins_label/coins_req_scythe
@onready var coins_en_label = $Enchance_panel/coins
@onready var coins_up_label = $Upgrade_panel/coins
@onready var axe_lv = $Enchance_panel/level_label/axe_lvl
@onready var pickaxe_lv = $Enchance_panel/level_label/pickaxe_lvl
@onready var scythe_lv = $Enchance_panel/level_label/scythe_lvl
@onready var not_sound = $AudioStreamPlayer

@onready var axe_animate = $Upgrade_panel/button/axe_upgrade/axe
@onready var pick_animate = $Upgrade_panel/button/pick_upgrade/pickaxe
@onready var scythe_animate = $Upgrade_panel/button/scythe_upgrade/scythe

@onready var axebtt = $Upgrade_panel/button/axe_upgrade
@onready var pickbtt = $Upgrade_panel/button/pick_upgrade
@onready var scybtt = $Upgrade_panel/button/scythe_upgrade
@onready var axe_label = $Upgrade_panel/cost/axe_cost
@onready var pick_label = $Upgrade_panel/cost/pick_cost
@onready var scy_label = $Upgrade_panel/cost/scythe_cost

const MAX_LEVEL := 50
const TIER_COSTS = [1000, 5000, 10000, 15000, 20000, 50000, 75000, 90000, 100000]
var MAX_TIER := TIER_COSTS.size()

func _ready() -> void:
	enchance_panel.visible = false
	upgrade_panel.visible = false
	axe_animate.play("tier_1")
	pick_animate.play("tier_1")
	scythe_animate.play("tier_1")
	axebtt.modulate = Color(0.3, 0.3, 0.3, 1)
	pickbtt.modulate = Color(0.3, 0.3, 0.3, 1)
	scybtt.modulate = Color(0.3, 0.3, 0.3, 1)
	
	update_coins()
	update_upgrade_costs()

func format_number(value: int) -> String:
	if value >= 1_000_000_000:
		return "%.2fB" % (value / 1_000_000_000.0)
	elif value >= 1_000_000:
		return "%.2fM" % (value / 1_000_000.0)
	elif value >= 1_000:
		return "%.1fk" % (value / 1_000.0)
	else:
		return str(value)

func update_coins() -> void:
	coins_en_label.text = "%d" % GameState.coins
	coins_up_label.text = "%d" % GameState.coins

	# Update level labels
	axe_lv.text = "Lv.%d" % GameState.axe_lvl
	pickaxe_lv.text = "Lv.%d" % GameState.pickaxe_lvl
	scythe_lv.text = "Lv.%d" % GameState.scythe_lvl

	# Show next level cost or "MAX"
	if GameState.axe_lvl < MAX_LEVEL:
		coins_req_axe.text = "%d" % ((GameState.axe_lvl + 1) * 150)
	else:
		coins_req_axe.text = "MAX"

	if GameState.pickaxe_lvl < MAX_LEVEL:
		coins_req_pickaxe.text = "%d" % ((GameState.pickaxe_lvl + 1) * 150)
	else:
		coins_req_pickaxe.text = "MAX"

	if GameState.scythe_lvl < MAX_LEVEL:
		coins_req_scythe.text = "%d" % ((GameState.scythe_lvl + 1) * 150)
	else:
		coins_req_scythe.text = "MAX"

func _on_enchance_pressed() -> void:
	enchance_panel.visible = true
	choice_panel.visible = false


func _on_upgrade_pressed() -> void:
	choice_panel.visible = false
	upgrade_panel.visible = true

# back of enchance panel
func _on_back_button_pressed() -> void:
	enchance_panel.visible = false
	choice_panel.visible = true

func _on_enchance_axe_pressed() -> void:
	if GameState.axe_lvl >= MAX_LEVEL:
		print("Axe is at max level!")
		not_sound.play()
		return

	var axe_cost = (GameState.axe_lvl + 1) * 150
	if GameState.coins >= axe_cost:
		GameState.coins -= axe_cost
		GameState.axe_dmg += 2
		GameState.axe_lvl += 1
		update_coins()
	else:
		print("Not enough coins! Need", axe_cost)
		not_sound.play()

func _on_enchance_pickaxe_pressed() -> void:
	if GameState.pickaxe_lvl >= MAX_LEVEL:
		print("Pickaxe is at max level!")
		not_sound.play()
		return

	var pickaxe_cost = (GameState.pickaxe_lvl + 1) * 150
	if GameState.coins >= pickaxe_cost:
		GameState.coins -= pickaxe_cost
		GameState.pickaxe_dmg += 2
		GameState.pickaxe_lvl += 1
		update_coins()
	else:
		print("Not enough coins! Need", pickaxe_cost)
		not_sound.play()

func _on_enchance_scythe_pressed() -> void:
	if GameState.scythe_lvl >= MAX_LEVEL:
		print("Scythe is at max level!")
		not_sound.play()
		return

	var scythe_cost = (GameState.scythe_lvl + 1) * 150
	if GameState.coins >= scythe_cost:
		GameState.coins -= scythe_cost
		GameState.scythe_dmg += 2
		GameState.scythe_lvl += 1
		update_coins()
	else:
		print("Not enough coins! Need", scythe_cost)
		not_sound.play()

# UPGRADE PANEL

func _on_back_upgrade_pressed() -> void:
	upgrade_panel.visible = false
	choice_panel.visible = true

func update_upgrade_costs() -> void:
	if GameState.axe_tier < MAX_TIER:
		axe_label.text = format_number(TIER_COSTS[GameState.axe_tier])
	else:
		axe_label.text = "MAX"

	if GameState.pickaxe_tier < MAX_TIER:
		pick_label.text = format_number(TIER_COSTS[GameState.pickaxe_tier])
	else:
		pick_label.text = "MAX"

	if GameState.scythe_tier < MAX_TIER:
		scy_label.text = format_number(TIER_COSTS[GameState.scythe_tier])
	else:
		scy_label.text = "MAX"

func _on_axe_upgrade_pressed() -> void:
	if GameState.axe_tier >= MAX_TIER:
		print("Axe is at max tier!")
		not_sound.play()
		return

	var cost = TIER_COSTS[GameState.axe_tier]
	if GameState.coins >= cost:
		GameState.coins -= cost
		axebtt.modulate = Color(1, 1, 1, 1)
		GameState.axe_tier += 1
		GameState.axe_dmg += 5
		GameState.add_xp(10)
		update_coins()
		update_upgrade_costs()
		print("Axe upgraded to tier", GameState.axe_tier)
		axe_animate.play("tier_%d" % GameState.axe_tier)
	else:
		print("Not enough coins! Need", cost)
		not_sound.play()


func _on_pick_upgrade_pressed() -> void:
	if GameState.pickaxe_tier >= MAX_TIER:
		print("Pickaxe is at max tier!")
		not_sound.play()
		return

	var cost = TIER_COSTS[GameState.pickaxe_tier]
	if GameState.coins >= cost:
		GameState.coins -= cost
		pickbtt.modulate = Color(1, 1, 1, 1)
		GameState.pickaxe_tier += 1
		GameState.pickaxe_dmg += 5
		GameState.add_xp(10)
		update_coins()
		update_upgrade_costs()
		print("Pickaxe upgraded to tier", GameState.pickaxe_tier)
		pick_animate.play("tier_%d" % GameState.pickaxe_tier)
	else:
		print("Not enough coins! Need", cost)
		not_sound.play()


func _on_scythe_upgrade_pressed() -> void:
	if GameState.scythe_tier >= MAX_TIER:
		print("Scythe is at max tier!")
		not_sound.play()
		return

	var cost = TIER_COSTS[GameState.scythe_tier]
	if GameState.coins >= cost:
		GameState.coins -= cost
		scybtt.modulate = Color(1, 1, 1, 1)
		GameState.scythe_tier += 1
		GameState.scythe_dmg += 5
		GameState.add_xp(10)
		update_coins()
		update_upgrade_costs()
		print("Scythe upgraded to tier", GameState.scythe_tier)
		scythe_animate.play("tier_%d" % GameState.scythe_tier)
	else:
		print("Not enough coins! Need", cost)
		not_sound.play()
