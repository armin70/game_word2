extends Node2D
var potion_effect
var effected
var type
var spread = false

func _ready() -> void:
	if effected:
		get_effect(effected,false)

func play_break_animation(is_potion_break):
	#var siblings = get_parent().get_parent().spread_effect(placeholder)
	#for item in siblings:
		#item.get_effect(potion_effect)
	if is_potion_break:
		var neighbors =  get_parent().get_neighbors(self)
		print("neighbors: ",neighbors )
		for neighbor in neighbors:
			if neighbor:
				neighbor.get_effect(potion_effect,false)
	$Multiplier.text = "2x"
	await get_tree().create_timer(1).timeout
	$animation.play("break")
	await $animation.animation_finished
	$Multiplier.text = ""
	get_parent().items.erase(self)
	queue_free()


func get_debuff(debuff):
	print("debuff value: ", debuff)
	$debuff.text = debuff
	await get_tree().create_timer(2).timeout
	$debuff.text = ""

func play_potion_animation(item):
	potion_effect = item[1]
	type = item[0]
	print("type: ", type)
	if  item[1] == "":
		$potion.play("empty")
	
	elif  item[1] == "fire":
		$potion.play("fire")
		
	elif  item[1] == "water":
		$potion.play("water")
		
	elif  item[1] == "thunder":
		$potion.play("thunder")
		
func get_effect(effect,is_spread):
	print("potion effect: ", effect)
	if is_spread:
		print("spreaded")
		play_thunder_animation()
	elif effected:
		if effected == "fire":
			if effect == "water":
				$animation.play("idle")
				effected=""
			elif effect == "fire":
				play_fire_animation()
				effected="fire"
			elif effect == "thunder":
				play_break_animation(false)
		elif effected == "water":
			if effect == "fire":
				$animation.play("idle")
				effected=""
				
			elif effect == "water":
				play_water_animation()
				effected="water"
				
			elif effect == "thunder":
				play_thunder_animation()
				effected="thunder"
				
		elif effected == "thunder":
			if effect == "water":
				play_thunder_animation()
				effected="thunder"
				
			elif effect == "fire":
				play_break_animation(false)
			elif effect == "thunder":
				$animation.play("idle")
				effected="thunder"
				

	else:
		effected = effect
		$potion_effect.text = effected
		if effected:
			if effected == "fire":
				play_fire_animation()
			elif effected == "water":
				play_water_animation()
			elif effected == "thunder":
				play_thunder_animation()

func play_fire_animation():
	$animation.play("fire")
	effected="fire"
	
	await $animation.animation_finished
	if type == 'Paper':
		queue_free()
 
func play_water_animation():
	$animation.play("water")
	effected="water"
	
	await $animation.animation_finished
	if type == 'Scissors':
		queue_free()
 
func play_thunder_animation():
	$animation.play("thunder")
	effected="thunder"
	
	await $animation.animation_finished
	if type == 'Rock':
		queue_free()


func spread_thunder():
	var siblings = get_parent().get_children()
	siblings.erase(self)
	for sibling in siblings:
		sibling.get_effect("thunder", true)
