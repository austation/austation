/mob/living/simple_animal/hostile/gympie_gympie
	name = "Awakened Gympie Gympie"
	desc = "An awakened suicide-plant!"
	icon_state = "gympiegympie"
	icon_living = "gympiegympie"
	icon_dead = "gympiegympie_dead"
	gender = NEUTER
	speak_chance = 0
	turns_per_move = 5
	maxHealth = 30
	health = 30
	see_in_dark = 3
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab/killertomato = 2)
	response_help  = "rustles"
	response_disarm = "pushes aside"
	response_harm   = "smacks"
	melee_damage = 1
	attacktext = "Stings"
	attack_sound = 'sound/weapons/slash.ogg'
	faction = list("plants")
	var/gas_boy = 0
	var/sting_boy = 0
	var/type_count = 3
	var/gympie_poison_per_bite = 5
	var/list/gympie_poison = list(/datum/reagent/toxin/mindbreaker,/datum/reagent/water,/datum/reagent/potassium)

	mobchatspan = "headofsecurity"

	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 150
	maxbodytemp = 500

/mob/living/simple_animal/hostile/gympie_gympie/AttackingTarget()
	. = ..()
	if(. && isliving(target))
		var/mob/living/L = target
		if(L.reagents)
			for(var/i = 1, i != type_count+1, i++)
				L.reagents.add_reagent(gympie_poison[i], gympie_poison_per_bite*sting_boy)

/mob/living/simple_animal/hostile/gympie_gympie/death()
	if(gas_boy)
		var/datum/effect_system/smoke_spread/chem/S = new
		var/splat_location = get_turf(src)
		create_reagents(10)
		var/smoke_amount = 0.3
		S.attach(splat_location)
		for(var/j = 1, j != type_count+1, j++)
			S.set_up(gympie_poison[j], smoke_amount, splat_location, 0)
		S.start()

	..()