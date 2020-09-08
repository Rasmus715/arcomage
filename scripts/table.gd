extends Control

var rng = RandomNumberGenerator.new()

var player_name = "DarkPro1337"
var enemy_name = "COMPUTER"

enum players {red, blue}
var turn
var AI_ready = true

# DEFAULT TOWER AND WALL HP
var player_tower_hp = 50
var player_wall_hp = 50

var enemy_tower_hp = 50
var enemy_wall_hp = 50

# DEFAULT RESOURCES
var player_quarry = 5
var player_bricks = 20
var player_magic = 3
var player_gems = 10
var player_dungeon = 5
var player_recruits = 20

var enemy_quarry = 5
var enemy_bricks = 20
var enemy_magic = 3
var enemy_gems = 10
var enemy_dungeon = 5
var enemy_recruits = 20

func _input(event):
	if Input.is_action_just_pressed("ui_reset"):
		get_tree().reload_current_scene()

func _ready():
	global.table = self
	rng.randomize()
	turn = rng.randi_range(0, players.size() - 1)
	turn = 1
	
	$player_panel/player_name.text = player_name
	$enemy_panel/enemy_name.text = enemy_name
	
	# PLAYER START DECK GENERATION
	while $player_deck.get_child_count() != 6:
		var card = load("res://scenes/card.tscn")
		var card_inst = card.instance()
		card_inst.add_to_group("player_card")
		$player_deck.add_child(card_inst)
		card_inst.usable = true
	
	# ENEMY START DECK GENERATION
	while $enemy_deck.get_child_count() != 6:
		var card = load("res://scenes/card.tscn")
		var card_inst = card.instance()
		card_inst.add_to_group("enemy_card")
		$enemy_deck.add_child(card_inst)
		card_inst.card_back.show()
		card_inst.usable = false
		card_inst.discardable = false
		
	

func _physics_process(delta):
	update_stat_panels()
	if turn == 0:
		$player_deck.show()
		$enemy_deck.hide()
	elif turn == 1 and AI_ready == true:
		AI_ready = false
		var random_bot_card = $enemy_deck.get_child(rng.randi_range(0, $enemy_deck.get_child_count() - 1))
		$player_deck.hide()
		$enemy_deck.show()
		$enemy_deck.get_node(random_bot_card.name).bot_card_use()

func use_card(card_name):
	var card_prev = $player_deck.get_node(card_name)
	var table = get_node(".")
	var prev_pos = card_prev.get_position_in_parent()
	var card_prev_pos = card_prev.rect_global_position
	card_prev.usable = false
	card_prev.used = true
	card_prev.set_as_toplevel(true)
	#reparent(card_prev, table)
	#card_prev = get_node(card_name)
	#card_prev.usable = false
	#card_prev.used = true
	
	# CARD ANIMATION WITH TWEEN
	var card_anim = get_node("card_anim")
	card_anim.start()
	card_anim.interpolate_property(card_prev, "rect_position",
		card_prev_pos, (get_viewport_rect().size / 2) - (card_prev.rect_size / 2) + Vector2(0, -50), 1,
		Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	yield(card_anim, "tween_completed")
	
	card_anim.interpolate_property(card_prev, "modulate",
		Color(1,1,1,1), Color(1,1,1,0), 1,
		Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	yield(card_anim, "tween_completed")
	
	card_prev.queue_free()
	add_resources(turn)
	turn = 1
	if $player_deck.get_child_count() <= 6:
		var card_next = load("res://scenes/card.tscn")
		var card_inst = card_next.instance()
		card_inst.add_to_group("player_card")
		$player_deck.add_child(card_inst)
		$player_deck.move_child(card_inst, prev_pos)

func remove_card(card_name):
	var card_prev = $player_deck.get_node(card_name)
	var table = get_node(".")
	var prev_pos = card_prev.get_position_in_parent()
	var card_prev_pos = card_prev.rect_position
	card_prev.usable = false
	card_prev.used = true
	
	var card_anim = get_node("card_anim")
	card_anim.start()
	card_anim.interpolate_property(card_prev, "modulate",
		Color(1,1,1,1), Color(1,1,1,0), 1,
		Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	yield(card_anim, "tween_completed")
	
	card_prev.queue_free()
	if $player_deck.get_child_count() <= 6:
		var card_next = load("res://scenes/card.tscn")
		var card_inst = card_next.instance()
		$player_deck.add_child(card_inst)
		$player_deck.move_child(card_inst, prev_pos)
		card_inst.add_to_group("player_card")

func bot_use_card(card_name):
	var card_prev = $enemy_deck.get_node(card_name)
	var table = get_node(".")
	var prev_pos = card_prev.get_position_in_parent()
	var card_prev_pos = card_prev.rect_global_position
	card_prev.usable = false
	card_prev.used = true
	card_prev.card_back.hide()
	card_prev.set_as_toplevel(true)
	#reparent(card_prev, table)
	#card_prev = get_node(card_name)
	#card_prev.rect_position = (get_viewport_rect().size / 2) - (card_prev.rect_size / 2) + Vector2(0, -50)
	#card_prev.selector.hide()
	
	# CARD ANIMATION WITH TWEEN
	var card_anim = get_node("card_anim")
	card_anim.start()
	card_anim.interpolate_property(card_prev, "rect_position",
		card_prev_pos, (get_viewport_rect().size / 2) - (card_prev.rect_size / 2) + Vector2(0, -50), 1,
		Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	yield(card_anim, "tween_completed")
	
	card_anim.interpolate_property(card_prev, "modulate",
		Color(1,1,1,1), Color(1,1,1,0), 1,
		Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	yield(card_anim, "tween_completed")
	
	turn = 0
	AI_ready = true
	card_prev.queue_free()
	if $enemy_deck.get_child_count() <= 6:
		var card_next = load("res://scenes/card.tscn")
		var card_inst = card_next.instance()
		card_inst.add_to_group("enemy_card")
		$enemy_deck.add_child(card_inst)
		$enemy_deck.move_child(card_inst, prev_pos)
		card_inst.card_back.show()
		card_inst.usable = false
		card_inst.discardable = false

func bot_remove_card(card_name):
	var card_prev = $enemy_deck.get_node(card_name)
	var table = get_node(".")
	var prev_pos = card_prev.get_position_in_parent()
	var card_prev_pos = card_prev.rect_position
	card_prev.usable = false
	card_prev.used = true
	card_prev.selector.hide()
	card_prev.queue_free()
	if $enemy_deck.get_child_count() <= 6:
		var card_next = load("res://scenes/card.tscn")
		var card_inst = card_next.instance()
		$enemy_deck.add_child(card_inst)
		$enemy_deck.move_child(card_inst, prev_pos)

func update_stat_panels():
	# PLAYER STATS
	$player_bricks_panel/per_turn.text = str(player_quarry)
	$player_bricks_panel/total.text = str(player_bricks)
	$player_gems_panel/per_turn.text = str(player_magic)
	$player_gems_panel/total.text = str(player_gems)
	$player_recruits_panel/per_turn.text = str(player_dungeon)
	$player_recruits_panel/total.text = str(player_recruits)
	# ENEMY STATS
	$enemy_bricks_panel/per_turn.text = str(enemy_quarry)
	$enemy_bricks_panel/total.text = str(enemy_bricks)
	$enemy_gems_panel/per_turn.text = str(enemy_magic)
	$enemy_gems_panel/total.text = str(enemy_gems)
	$enemy_recruits_panel/per_turn.text = str(enemy_dungeon)
	$enemy_recruits_panel/total.text = str(enemy_recruits)
	# PLAYER TOWER AND WALL
	$player_tower_panel/tower_hp.text = str(player_tower_hp)
	$player_wall_panel/wall_hp.text = str(player_wall_hp)
	$player_tower.set_size(Vector2(45, player_tower_hp))
	$player_wall.set_size(Vector2(24, player_wall_hp))
	# ENEMY TOWER AND WALL
	$enemy_tower_panel/tower_hp.text = str(enemy_tower_hp)
	$enemy_wall_panel/wall_hp.text = str(enemy_wall_hp)
	$enemy_tower.set_size(Vector2(45, enemy_tower_hp))
	$enemy_wall.set_size(Vector2(24, enemy_wall_hp))

func reparent(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.add_child(child)

func add_resources(turn):
	if turn == 0:
		player_bricks += player_quarry
		player_gems += player_magic
		player_recruits += player_dungeon
	if turn == 1:
		enemy_bricks += enemy_quarry
		enemy_gems += enemy_magic
		enemy_recruits += enemy_dungeon
