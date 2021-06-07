// PORTED FROM PARADISE STATION

// all credits go to Kyet for the code and FullofSkittles (FoS) for the sprites
// original paradise PR: #10488

/mob/living/simple_animal/hostile/retaliate/kangaroo
	name = "kangaroo"
	desc = "A large marsupial herbivore. It has powerful hind legs, with nails that resemble long claws."
	icon = 'austation/icons/mob/kangaroos.dmi'
	icon_state = "kangaroo" // Credit: FoS
	icon_living = "kangaroo"
	icon_dead = "kangaroo_dead"
	icon_gib = "kangaroo_dead"
	turns_per_move = 8
	response_help = "pets"
	mob_biotypes = list(MOB_ORGANIC, MOB_BEAST)
	emote_hear = list("bark")
	speak_emote = list("barks")
	emote_taunt = list("leaps", "stomps")
	maxHealth = 150
	health = 150
	gold_core_spawnable = HOSTILE_SPAWN
	blood_volume = BLOOD_VOLUME_NORMAL
	harm_intent_damage = 3
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 6)
	melee_damage = 10
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "punches"
	attacktext = "slashes"
	attack_sound = 'sound/weapons/bladeslice.ogg' // they have nails that work like claws, so, slashing sound
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 2, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	move_to_delay = 4 // at 20ticks/sec, this is 5 tile/sec movespeed, about the same as a 'fast human'.
	speed = -1 // '-1' converts to 1.5 total move delay, or 6.6 tiles/sec movespeed
	var/attack_cycles = 0
	var/attack_cycles_max = 3
	var/kick_damage = 30

	do_footstep = TRUE

/mob/living/simple_animal/hostile/retaliate/kangaroo/Initialize()
	. = ..()
	// Leap spell, player-only usage
	AddSpell(new /obj/effect/proc_holder/spell/targeted/leap)

/mob/living/simple_animal/hostile/retaliate/kangaroo/AttackingTarget()
	var/mob/living/L = target
	if(!istype(L))
		return ..() // Do not do further checks if we somehow end up attacking something not alive (like a window).

	if(L.stat == DEAD)
		return ..() // Do not allow player-controlled roos to prime their kick by attacking corpses.

	attack_cycles++
	if(attack_cycles < attack_cycles_max)
		// Most of the time, do a standard attack...
		return ..()

	// ... but, every attack_cycles_max attacks on a living mob, do a powerful disemboweling kick instead
	attack_cycles = 0
	attacktext = "VICIOUSLY KICKS"
	melee_damage = kick_damage
	. = ..()

	var/rookick_dir = get_dir(src, L)
	var/turf/general_direction = get_edge_target_turf(L, rookick_dir)
	L.visible_message("<span class='danger'>[L] is kicked hard!</span>", "<span class='userdanger'>The kangaroo kick sends you flying mate!</span>")
	L.throw_at(general_direction, 10, 2)

	attacktext = initial(attacktext)
	melee_damage = initial(melee_damage)

/mob/living/simple_animal/hostile/retaliate/kangaroo/space
	name = "space kangaroo"
	desc = "A large marsupial herbivore. It has powerful hind legs, with nails that resemble long claws, oh god it's spaceproof."
	spacewalk = TRUE
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	icon_state = "space-kangaroo"
	icon_living = "space-kangaroo"
	icon_dead = "space-kangaroo_dead"
	icon_gib = "space-kangaroo_dead"

/mob/living/simple_animal/hostile/retaliate/kangaroo/boxing //admemes bullshit
	name = "boxing kangaroo"
	desc = "A large, beefy kangaroo with boxing gloves, you should probably run."
	spacewalk = TRUE
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	melee_damage = 30
	armour_penetration = 20
	health = 240
	maxHealth = 240
	kick_damage = 70
	gold_core_spawnable = NO_SPAWN
	icon_state = "boxing-kangaroo"
	icon_living = "boxing-kangaroo"
	icon_dead = "boxing-kangaroo_dead"
	icon_gib = "boxing-kangaroo_dead"
	guaranteed_butcher_results = list(/obj/item/clothing/gloves/boxing = 1)
