#define SPIDER_IDLE 0
#define SPINNING_WEB 1
#define LAYING_EGGS 2
#define MOVING_TO_TARGET 3
#define SPINNING_COCOON 4

/mob/living/simple_animal/hostile/poison
	mobchatspan = "researchdirector"
	var/poison_per_bite = 5
	var/poison_type = /datum/reagent/toxin

/mob/living/simple_animal/hostile/poison/AttackingTarget()
	. = ..()
	if(. && isliving(target))
		var/mob/living/L = target
		if(L.reagents)
			L.reagents.add_reagent(poison_type, poison_per_bite)

//basic spider mob, these generally guard nests
/mob/living/simple_animal/hostile/poison/giant_spider
	name = "giant spider"
	desc = "Furry and black, it makes you shudder to look at it. This one has deep red eyes."
	icon_state = "tarantula"
	icon_living = "tarantula"
	icon_dead = "tarantula_dead"
	mob_biotypes = list(MOB_ORGANIC, MOB_BUG)
	speak_emote = list("chitters")
	emote_hear = list("chitters")
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 10
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab/spider = 2, /obj/item/reagent_containers/food/snacks/spiderleg = 8)
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "hits"
<<<<<<< HEAD
	maxHealth = 200
	health = 200
	obj_damage = 60
	melee_damage = 15
=======
	initial_language_holder = /datum/language_holder/spider // Speaks buzzwords, understands buzzwords and common
	maxHealth = 85
	health = 85
	obj_damage = 25
	melee_damage = 15
	poison_per_bite = 3
	poison_type = /datum/reagent/toxin/spidervenom
>>>>>>> 4a9732c7f8 (Various spider tweaks (#8409))
	faction = list("spiders")
	var/busy = SPIDER_IDLE
	pass_flags = PASSTABLE
	move_to_delay = 6
	ventcrawler = VENTCRAWLER_ALWAYS
	attacktext = "bites"
	attack_sound = 'sound/weapons/bite.ogg'
	unique_name = 1
	gold_core_spawnable = HOSTILE_SPAWN
	see_in_dark = 4
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
<<<<<<< HEAD
	var/datum/action/innate/spider/lay_web/lay_web
	var/directive = "" //Message passed down to children, to relay the creator's orders
=======
	var/busy = SPIDER_IDLE // What a spider's doing
	var/datum/action/innate/spider/lay_web/lay_web // Web action
	var/obj/effect/proc_holder/wrap/lesser/lesserwrap // Wrap action
	var/web_speed = 1 // How quickly a spider lays down webs (percentage)
	var/mob/master // The spider's master, used by sentience
	var/onweb_speed
	var/atom/movable/cocoon_target
>>>>>>> 4a9732c7f8 (Various spider tweaks (#8409))

	//Special spider variables defined here to prevent duplicate procs
	var/mob/living/simple_animal/hostile/poison/giant_spider/heal_target //used by nurses for healing
	var/static/list/consumed_mobs = list() //the tags of mobs that have been consumed by broodmothers
	var/fed = 0 //used by broodmothers to track food
	var/enriched_fed = 0
	var/datum/action/innate/spider/lay_eggs/lay_eggs //the ability to lay eggs, granted to broodmothers
	var/datum/team/spiders/spider_team = null //utilized by AI controlled broodmothers to pass antag team info onto their eggs without a mind

	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	do_footstep = TRUE
	discovery_points = 1000
	gold_core_spawnable = NO_SPAWN  //Spiders are introduced to the rounds through two types of antagonists 

/mob/living/simple_animal/hostile/poison/giant_spider/Initialize(mapload)
	. = ..()
	lay_web = new
	lay_web.Grant(src)
	lesserwrap = new
	AddAbility(lesserwrap)

/mob/living/simple_animal/hostile/poison/giant_spider/Destroy()
	QDEL_NULL(lay_web)
	return ..()

/mob/living/simple_animal/hostile/poison/giant_spider/Login()
	..()
	if(directive)
		to_chat(src, "<span class='spiderlarge'>Your mother left you a directive! Follow it at all costs.</span>")
		to_chat(src, "<span class='spiderlarge'><b>Directive: [directive]</b></span>")
		if(mind)
			mind.store_memory("<span class='spiderlarge'><b>Directive: [directive]</b></span>")

/mob/living/simple_animal/hostile/poison/giant_spider/give_mind(mob/user)
	..()
	if(directive)
		log_game("[key_name(src)] took control of [name] with the objective: '[directive]'.")
	return TRUE

<<<<<<< HEAD
//nursemaids - these create webs and eggs
/mob/living/simple_animal/hostile/poison/giant_spider/nurse
	desc = "Furry and black, it makes you shudder to look at it. This one has brilliant green eyes."
	icon_state = "nurse"
	icon_living = "nurse"
	icon_dead = "nurse_dead"
	gender = FEMALE
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab/spider = 2, /obj/item/reagent_containers/food/snacks/spiderleg = 8, /obj/item/reagent_containers/food/snacks/spidereggs = 4)
	maxHealth = 40
	health = 40
	melee_damage = 10
	poison_per_bite = 3
	var/atom/movable/cocoon_target
	var/fed = 0
	var/obj/effect/proc_holder/wrap/wrap
	var/datum/action/innate/spider/lay_eggs/lay_eggs
	var/datum/action/innate/spider/set_directive/set_directive
	var/static/list/consumed_mobs = list() //the tags of mobs that have been consumed by nurse spiders to lay eggs
	gold_core_spawnable = NO_SPAWN

/mob/living/simple_animal/hostile/poison/giant_spider/nurse/Initialize(mapload)
	. = ..()
	wrap = new
	AddAbility(wrap)
	lay_eggs = new
	lay_eggs.Grant(src)
	set_directive = new
	set_directive.Grant(src)

/mob/living/simple_animal/hostile/poison/giant_spider/nurse/Destroy()
	RemoveAbility(wrap)
	QDEL_NULL(lay_eggs)
	QDEL_NULL(set_directive)
	return ..()

//midwives are the queen of the spiders, can send messages to all them and web faster. That rare round where you get a queen spider and turn your 'for honor' players into 'r6siege' players will be a fun one.
/mob/living/simple_animal/hostile/poison/giant_spider/nurse/midwife
	name = "midwife"
	desc = "Furry and black, it makes you shudder to look at it. This one has scintillating green eyes."
	icon_state = "midwife"
	icon_living = "midwife"
	icon_dead = "midwife_dead"
	maxHealth = 40
	health = 40
	var/datum/action/innate/spider/comm/letmetalkpls

/mob/living/simple_animal/hostile/poison/giant_spider/nurse/midwife/Initialize(mapload)
	. = ..()
	letmetalkpls = new
	letmetalkpls.Grant(src)

/mob/living/simple_animal/hostile/poison/giant_spider/nurse/midwife/Destroy()
	QDEL_NULL(letmetalkpls)
	return ..()

//hunters have the most poison and move the fastest, so they can find prey
/mob/living/simple_animal/hostile/poison/giant_spider/hunter
	desc = "Furry and black, it makes you shudder to look at it. This one has sparkling purple eyes."
	icon_state = "hunter"
	icon_living = "hunter"
	icon_dead = "hunter_dead"
	maxHealth = 120
	health = 120
	melee_damage = 20
	poison_per_bite = 5
	move_to_delay = 5

//vipers are the rare variant of the hunter, no IMMEDIATE damage but so much poison medical care will be needed fast.
/mob/living/simple_animal/hostile/poison/giant_spider/hunter/viper
	name = "viper"
	desc = "Furry and black, it makes you shudder to look at it. This one has effervescent purple eyes."
	icon_state = "viper"
	icon_living = "viper"
	icon_dead = "viper_dead"
	maxHealth = 40
	health = 40
	melee_damage = 1
	poison_per_bite = 12
	move_to_delay = 4
	poison_type = /datum/reagent/toxin/venom //all in venom, glass cannon. you bite 5 times and they are DEFINITELY dead, but 40 health and you are extremely obvious. Ambush, maybe?
	speed = 1
	gold_core_spawnable = NO_SPAWN

//tarantulas are really tanky, regenerating (maybe), hulky monster but are also extremely slow, so.
/mob/living/simple_animal/hostile/poison/giant_spider/tarantula
	name = "tarantula"
	desc = "Furry and black, it makes you shudder to look at it. This one has abyssal red eyes."
	icon_state = "tarantula"
	icon_living = "tarantula"
	icon_dead = "tarantula_dead"
	maxHealth = 300 // woah nelly
	health = 300
	melee_damage = 40
	poison_per_bite = 0
	move_to_delay = 8
	speed = 7
	status_flags = NONE
	mob_size = MOB_SIZE_LARGE
	gold_core_spawnable = NO_SPAWN

/mob/living/simple_animal/hostile/poison/giant_spider/tarantula/movement_delay()
	var/turf/T = get_turf(src)
	if(locate(/obj/structure/spider/stickyweb) in T)
		speed = 2
	else
		speed = 7
	. = ..()

/mob/living/simple_animal/hostile/poison/giant_spider/ice //spiders dont usually like tempatures of 140 kelvin who knew
	name = "giant ice spider"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	poison_type = /datum/reagent/consumable/frostoil
	color = rgb(114,228,250)
	gold_core_spawnable = NO_SPAWN

/mob/living/simple_animal/hostile/poison/giant_spider/nurse/ice
	name = "giant ice spider"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	poison_type = /datum/reagent/consumable/frostoil
	color = rgb(114,228,250)

/mob/living/simple_animal/hostile/poison/giant_spider/hunter/ice
	name = "giant ice spider"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	poison_type = /datum/reagent/consumable/frostoil
	color = rgb(114,228,250)
	gold_core_spawnable = NO_SPAWN

/mob/living/simple_animal/hostile/poison/giant_spider/handle_automated_action()
	if(!..()) //AIStatus is off
		return FALSE
	if(AIStatus == AI_IDLE)
		//1% chance to skitter madly away
		if(!busy && prob(1))
			stop_automated_movement = TRUE
			Goto(pick(urange(20, src, 1)), move_to_delay)
			addtimer(CALLBACK(src, .proc/do_action), 5 SECONDS)
		return TRUE

/mob/living/simple_animal/hostile/poison/giant_spider/proc/do_action()
	stop_automated_movement = FALSE
	SSmove_manager.stop_looping(src)

/mob/living/simple_animal/hostile/poison/giant_spider/nurse/proc/GiveUp(C)
	if(busy == MOVING_TO_TARGET)
		if(cocoon_target == C && get_dist(src,cocoon_target) > 1)
			cocoon_target = null
		busy = FALSE
		stop_automated_movement = FALSE

/mob/living/simple_animal/hostile/poison/giant_spider/nurse/handle_automated_action()
	if(..())
		var/list/can_see = view(10, src)
		if(!busy && prob(30))	//30% chance to stop wandering and do something
			//first, check for potential food nearby to cocoon
			for(var/mob/living/C in can_see)
				if(C.stat && !istype(C, /mob/living/simple_animal/hostile/poison/giant_spider) && !C.anchored)
					cocoon_target = C
					busy = MOVING_TO_TARGET
					Goto(C, move_to_delay)
					//give up if we can't reach them after 10 seconds
					addtimer(CALLBACK(src, .proc/GiveUp, C), 10 SECONDS)
					return

			//second, spin a sticky spiderweb on this tile
=======
/mob/living/simple_animal/hostile/poison/giant_spider/sentience_act(mob/user)
	. = ..()
	var/datum/team/spiders/spiders
	for(var/datum/team/spiders/team in GLOB.antagonist_teams)
		if(team.master == user)
			spiders = team
			break
	if(!spiders)
		if(spider_team)
			spiders = spider_team //Spider was AI controlled and then taken over by a ghost, so we apply the stored team datum
		else
			spiders = new(null, user)
	var/datum/antagonist/spider/spider_antag = mind.has_antag_datum(/datum/antagonist/spider)
	spider_antag.set_spider_team(spiders)

// Allows spiders to take damage slowdown. 2 max, but they don't start moving slower until under 75% health
/mob/living/simple_animal/hostile/poison/giant_spider/updatehealth()
	. = ..()
	if(HAS_TRAIT(src, TRAIT_IGNOREDAMAGESLOWDOWN))
		remove_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN)
		return
	var/health_percentage = round((health / maxHealth) * 100)
	if(health_percentage <= 75)
		add_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN, override = TRUE, multiplicative_slowdown = ((100 - health_percentage) / 50), blacklisted_movetypes = FLOATING|FLYING)
	else
		remove_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN)

// Handles faster movement on webs
// This is triggered after the first time a spider steps on/off a web, making web-peeking using this harder
/mob/living/simple_animal/hostile/poison/giant_spider/Moved(atom/oldloc, dir)
	. = ..()
	if(onweb_speed == null)
		return
	var/turf/T = get_turf(src)
	if(locate(/obj/structure/spider/stickyweb) in T)
		set_varspeed(onweb_speed)
		move_to_delay = max(2, initial(move_to_delay)-1) //Clamps AI at a maximum speed equivalent to that of vipers
	else
		set_varspeed(initial(speed))
		move_to_delay = initial(move_to_delay)

// Handles webspinning of all varieties for spiders
/mob/living/simple_animal/hostile/poison/giant_spider/handle_automated_movement()
	..()
	if(AIStatus == AI_IDLE)
		if(!busy)
>>>>>>> 4a9732c7f8 (Various spider tweaks (#8409))
			var/obj/structure/spider/stickyweb/W = locate() in get_turf(src)
			if(!W)
				lay_web.Activate()
			else
<<<<<<< HEAD
				//third, lay an egg cluster there
				if(fed)
					lay_eggs.Activate()
				else
					//fourthly, cocoon any nearby items so those pesky pinkskins can't use them
					for(var/obj/O in can_see)

						if(O.anchored)
							continue

						if(isitem(O) || isstructure(O) || ismachinery(O))
							cocoon_target = O
							busy = MOVING_TO_TARGET
							stop_automated_movement = 1
							Goto(O, move_to_delay)
							//give up if we can't reach them after 10 seconds
							addtimer(CALLBACK(src, .proc/GiveUp, O), 10 SECONDS)

		else if(busy == MOVING_TO_TARGET && cocoon_target)
			if(get_dist(src, cocoon_target) <= 1)
				cocoon()

	else
		busy = SPIDER_IDLE
		stop_automated_movement = FALSE

/mob/living/simple_animal/hostile/poison/giant_spider/nurse/proc/cocoon()
=======
				var/list/can_see = view(10, src)
				for(var/obj/O in can_see)
					if(O.anchored)
						continue //Can't wrap anchored objects
					if(isitem(O) || isstructure(O) || ismachinery(O))
						cocoon_target = O
						busy = MOVING_TO_TARGET
						Goto(O, move_to_delay)
						addtimer(CALLBACK(src, .proc/GiveUp, O), 20 SECONDS)
		if(cocoon_target && get_dist(src, cocoon_target) <= 1)
			cocoon()
			GiveUp() //if something interrupts the attempt to cocoon, there is probably an enemy entity nearby and we need to reset

// Handles cocooning items and food
/mob/living/simple_animal/hostile/poison/giant_spider/proc/cocoon()
>>>>>>> 4a9732c7f8 (Various spider tweaks (#8409))
	if(stat != DEAD && cocoon_target && !cocoon_target.anchored)
		if(cocoon_target == src)
			to_chat(src, "<span class='warning'>You can't wrap yourself!</span>")
			return
		if(istype(cocoon_target, /mob/living/simple_animal/hostile/poison/giant_spider))
			to_chat(src, "<span class='warning'>You can't wrap other spiders!</span>")
			return
		if(!Adjacent(cocoon_target))
			to_chat(src, "<span class='warning'>You can't reach [cocoon_target]!</span>")
			return
		if(busy == SPINNING_COCOON)
			to_chat(src, "<span class='warning'>You're already spinning a cocoon!</span>")
			return //we're already doing this, don't cancel out or anything
<<<<<<< HEAD
=======
		if(isliving(cocoon_target))
			if(!istype(src, /mob/living/simple_animal/hostile/poison/giant_spider/broodmother))
				to_chat(src, "<span class='warning'>You should bring food to your broodmother!</span>")
				return
			var/mob/living/M = cocoon_target
			M.attacked_by(null, src)
>>>>>>> 4a9732c7f8 (Various spider tweaks (#8409))
		busy = SPINNING_COCOON
		visible_message("<span class='notice'>[src] begins to secrete a sticky substance around [cocoon_target].</span>","<span class='notice'>You begin wrapping [cocoon_target] into a cocoon.</span>")
		stop_automated_movement = TRUE
		SSmove_manager.stop_looping(src)
		if(do_after(src, 50, target = cocoon_target))
			if(busy == SPINNING_COCOON)
				var/obj/structure/spider/cocoon/C = new(cocoon_target.loc)
				if(isliving(cocoon_target))
					var/mob/living/L = cocoon_target
					if(L.blood_volume && (L.stat != DEAD || !consumed_mobs[L.tag])) //if they're not dead, you can consume them anyway
						consumed_mobs[L.tag] = TRUE
						fed++
						health = maxHealth //heal up from feeding.
						if(lay_eggs)
							lay_eggs.UpdateButtonIcon(TRUE)
						visible_message("<span class='danger'>[src] sticks a proboscis into [L] and sucks a viscous substance out.</span>","<span class='notice'>You suck the nutriment out of [L], feeding you enough to lay a cluster of eggs.</span>")
						L.death() //you just ate them, they're dead.
					else
						to_chat(src, "<span class='warning'>[L] cannot sate your hunger!</span>")
				cocoon_target.forceMove(C)

				if(cocoon_target.density || ismob(cocoon_target))
					C.icon_state = pick("cocoon_large1","cocoon_large2","cocoon_large3")
	cocoon_target = null
	busy = SPIDER_IDLE
	stop_automated_movement = FALSE

<<<<<<< HEAD
=======
/mob/living/simple_animal/hostile/poison/giant_spider/proc/do_action()
	stop_automated_movement = FALSE
	SSmove_manager.stop_looping(src)

/mob/living/simple_animal/hostile/poison/giant_spider/AttackingTarget()
	if(is_busy)
		return
	var/mob/target_mob = target
	if(!istype(target_mob))
		return ..()
	// Spider IFF
	if(istype(target, /mob/living/simple_animal/hostile/poison/giant_spider))
		visible_message("<span class='notice'>[src] nuzzles [target_mob.name]!</span>", \
			"<span class='notice'>You nuzzle [target_mob.name]!</span>", null, COMBAT_MESSAGE_RANGE)
		return
	return ..()
s
/mob/living/simple_animal/hostile/poison/giant_spider/proc/GiveUp()
	if(busy == MOVING_TO_TARGET)
		cocoon_target = null
		heal_target = null
		busy = FALSE
		stop_automated_movement = FALSE
		SSmove_manager.stop_looping(src)

// Tarantulas are the balanced generalist of the spider family: Moderate stats all around.
/mob/living/simple_animal/hostile/poison/giant_spider/tarantula
	name = "tarantula"
	obj_damage = 35
	speed = 0.5
	onweb_speed = 0

// Nurses heal other spiders and maintain the core of the nest.
/mob/living/simple_animal/hostile/poison/giant_spider/nurse
	name = "nurse"
	desc = "Furry and black, it makes you shudder to look at it. This one has brilliant green eyes."
	icon_state = "nurse"
	icon_living = "nurse"
	icon_dead = "nurse_dead"
	gender = FEMALE
	maxHealth = 45
	health = 45
	melee_damage = 10
	poison_per_bite = 3
	speed = 1
	onweb_speed = 0
	web_speed = 0.33
	///The health HUD applied to the mob.
	var/health_hud = DATA_HUD_MEDICAL_ADVANCED

/mob/living/simple_animal/hostile/poison/giant_spider/nurse/Initialize(mapload)
	. = ..()
	var/datum/atom_hud/datahud = GLOB.huds[health_hud]
	datahud.add_hud_to(src)

// Allows nurses to heal other spiders if they're adjacent
/mob/living/simple_animal/hostile/poison/giant_spider/nurse/AttackingTarget()
	if(is_busy)
		return
	var/mob/target_mob = target
	if(!istype(target_mob))
		return ..()
	if(!istype(target, /mob/living/simple_animal/hostile/poison/giant_spider))
		return ..()
	var/mob/living/simple_animal/hostile/poison/giant_spider/hurt_spider = target
	if(hurt_spider == src)
		to_chat(src, "<span class='warning'>You don't have the dexerity to wrap your own wounds.</span>")
		return
	if(hurt_spider.health >= hurt_spider.maxHealth)
		to_chat(src, "<span class='warning'>You can't find any wounds to wrap up.</span>")
		return ..() // IFF is handled in parent
	visible_message("<span class='notice'>[src] begins wrapping the wounds of [hurt_spider].</span>","<span class='notice'>You begin wrapping the wounds of [hurt_spider].</span>")
	is_busy = TRUE
	if(do_after(src, 20, target = hurt_spider))
		hurt_spider.heal_overall_damage(20)
		new /obj/effect/temp_visual/heal(get_turf(hurt_spider), "#80F5FF")
		visible_message("<span class='notice'>[src] wraps the wounds of [hurt_spider].</span>","<span class='notice'>You wrap the wounds of [hurt_spider].</span>")
	is_busy = FALSE

//Handles AI nurse healing when spiders are idle
/mob/living/simple_animal/hostile/poison/giant_spider/nurse/handle_automated_movement()
	if(AIStatus == AI_IDLE)
		if(!busy)
			var/list/can_see = view(10, src)
			for(var/mob/living/C in can_see)
				if(istype(C, /mob/living/simple_animal/hostile/poison/giant_spider) && C.health < C.maxHealth)
					heal_target = C
					busy = MOVING_TO_TARGET
					Goto(C, move_to_delay)
					addtimer(CALLBACK(src, .proc/GiveUp), 20 SECONDS) //to prevent infinite chases
		if(heal_target && get_dist(src, heal_target) <= 1)
			UnarmedAttack(heal_target)
			if(heal_target.health >= heal_target.maxHealth)
				GiveUp(heal_target)
	..() //Do normal stuff after giving priority to healing attempts

//Broodmothers have well rounded stats and are able to lay eggs, but somewhat slow.
/mob/living/simple_animal/hostile/poison/giant_spider/broodmother
	name = "broodmother"
	desc = "Furry and black, it makes you shudder to look at it. This one has scintillating green eyes."
	icon_state = "broodmother"
	icon_living = "broodmother"
	icon_dead = "broodmother_dead"
	maxHealth = 90
	health = 90
	melee_damage = 15
	poison_per_bite = 5
	speed = 2
	onweb_speed = 1
	web_speed = 0.25

	gender = FEMALE
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab/spider = 2, /obj/item/reagent_containers/food/snacks/spiderleg = 8, /obj/item/reagent_containers/food/snacks/spidereggs = 4)
	var/obj/effect/proc_holder/wrap/wrap
	var/datum/action/innate/spider/set_directive/set_directive
	/// Allows the spider to use spider comms
	var/datum/action/innate/spider/comm/letmetalkpls

/mob/living/simple_animal/hostile/poison/giant_spider/broodmother/Initialize(mapload)
	. = ..()
	RemoveAbility(lesserwrap)
	wrap = new
	AddAbility(wrap)
	lay_eggs = new
	lay_eggs.Grant(src)
	set_directive = new
	set_directive.Grant(src)
	letmetalkpls = new
	letmetalkpls.Grant(src)

/mob/living/simple_animal/hostile/poison/giant_spider/broodmother/Destroy()
	RemoveAbility(wrap)
	QDEL_NULL(lay_eggs)
	QDEL_NULL(set_directive)
	QDEL_NULL(letmetalkpls)
	return ..()

//Handles Broodmother feeding and egglaying
/mob/living/simple_animal/hostile/poison/giant_spider/broodmother/handle_automated_movement()
	if(AIStatus == AI_IDLE && !busy)
		var/list/can_see = view(10, src)
		for(var/mob/living/C in can_see)
			if(istype(C, /mob/living/simple_animal/hostile/poison/giant_spider))
				continue //Not interested in other spiders for food
			else if(C.stat && !C.anchored)
				cocoon_target = C
				busy = MOVING_TO_TARGET
				Goto(C, move_to_delay)
				addtimer(CALLBACK(src, .proc/GiveUp, C), 20 SECONDS)
		if(prob(10) && lay_eggs.IsAvailable()) //so eggs aren't always placed immediately and directly by corpses
			lay_eggs.Activate()
	..()

// Hunters are the most independant of the spiders, not relying on web and having a bit more damage and venom at the cost of health.
// They are intended to bring prey back from outside of the web.
/mob/living/simple_animal/hostile/poison/giant_spider/hunter
	name = "hunter"
	desc = "Furry and black, it makes you shudder to look at it. This one has sparkling purple eyes."
	icon_state = "hunter"
	icon_living = "hunter"
	icon_dead = "hunter_dead"
	maxHealth = 65
	health = 65
	melee_damage = 18
	poison_per_bite = 5
	move_to_delay = 3
	speed = 0

// Vipers are physically very weak and fragile, but also very fast and inject a lot of venom. 
/mob/living/simple_animal/hostile/poison/giant_spider/hunter/viper
	name = "viper"
	desc = "Furry and black, it makes you shudder to look at it. This one has effervescent purple eyes."
	icon_state = "viper"
	icon_living = "viper"
	icon_dead = "viper_dead"
	maxHealth = 35
	health = 35
	melee_damage = 8
	poison_per_bite = 8
	web_speed = -1
	move_to_delay = 2
	poison_type = /datum/reagent/toxin/venom

//Guards are really tanky brutes that rely on force more than venom but perform very poorly away from webs. 
/mob/living/simple_animal/hostile/poison/giant_spider/guard
	name = "guard"
	desc = "Furry and black, it makes you shudder to look at it. This one has abyssal red eyes."
	icon_state = "guard"
	icon_living = "guard"
	icon_dead = "guard_dead"
	maxHealth = 125
	health = 125
	melee_damage = 22
	poison_per_bite = 1 //rely on brute force, but they're still spiders. 
	obj_damage = 50
	move_to_delay = 5
	speed = 3
	web_speed = 1
	onweb_speed = 0
	status_flags = NONE
	mob_size = MOB_SIZE_LARGE
	web_speed = 0.5

// Ice spiders - for when you want a spider that really doesn't care about atmos
/mob/living/simple_animal/hostile/poison/giant_spider/ice
	name = "ice spider"
	maxbodytemp = 1500
	poison_type = /datum/reagent/consumable/frostoil
	color = rgb(114,228,250)

/mob/living/simple_animal/hostile/poison/giant_spider/nurse/ice
	name = "ice nurse"
	maxbodytemp = 1500
	poison_type = /datum/reagent/consumable/frostoil
	color = rgb(114,228,250)

/mob/living/simple_animal/hostile/poison/giant_spider/hunter/ice
	name = "ice hunter"
	maxbodytemp = 1500
	poison_type = /datum/reagent/consumable/frostoil
	color = rgb(114,228,250)

// Buffed spider for wizards to use
/mob/living/simple_animal/hostile/poison/giant_spider/hunter/viper/wizard
	maxHealth = 100
	health = 100

// SPIDER ACTIONS/PROCS

>>>>>>> 4a9732c7f8 (Various spider tweaks (#8409))
/datum/action/innate/spider
	icon_icon = 'icons/mob/actions/actions_animal.dmi'
	background_icon_state = "bg_alien"
	check_flags = AB_CHECK_CONSCIOUS

/datum/action/innate/spider/lay_web
	name = "Spin Web"
	desc = "Spin a web to slow down potential prey."
	button_icon_state = "lay_web"

/datum/action/innate/spider/lay_web/Activate()
	if(!istype(owner, /mob/living/simple_animal/hostile/poison/giant_spider))
		return
	var/mob/living/simple_animal/hostile/poison/giant_spider/S = owner

	if(!isturf(S.loc))
		return
	var/turf/T = get_turf(S)

	var/obj/structure/spider/stickyweb/W = locate() in T
	if(W)
		to_chat(S, "<span class='warning'>There's already a web here!</span>")
		return

<<<<<<< HEAD
	if(S.busy != SPINNING_WEB)
		S.busy = SPINNING_WEB
		S.visible_message("<span class='notice'>[S] begins to secrete a sticky substance.</span>","<span class='notice'>You begin to lay a web.</span>")
		S.stop_automated_movement = TRUE
		if(do_after(S, 40, target = T))
			if(S.busy == SPINNING_WEB && S.loc == T)
				new /obj/structure/spider/stickyweb(T)
		S.busy = SPIDER_IDLE
		S.stop_automated_movement = FALSE
=======
	if(spider.busy != SPINNING_WEB)
		spider.busy = SPINNING_WEB
		spider.visible_message("<span class='notice'>[spider] begins to secrete a sticky substance.</span>","<span class='notice'>You begin to lay a web.</span>")
		spider.stop_automated_movement = TRUE
		if(do_after(spider, 40 * spider.web_speed, target = target_turf))
			new /obj/structure/spider/stickyweb(target_turf)
		spider.busy = SPIDER_IDLE
		spider.stop_automated_movement = FALSE
>>>>>>> 4a9732c7f8 (Various spider tweaks (#8409))
	else
		to_chat(S, "<span class='warning'>You're already spinning a web!</span>")

/obj/effect/proc_holder/wrap
	name = "Wrap"
	panel = "Spider"
	desc = "Wrap something or someone in a cocoon. If it's a living being, you'll also consume them, allowing you to lay eggs."
	ranged_mousepointer = 'icons/effects/wrap_target.dmi'
	action_icon = 'icons/mob/actions/actions_animal.dmi'
	action_icon_state = "wrap_0"
	action_background_icon_state = "bg_alien"

/obj/effect/proc_holder/wrap/lesser
	desc = "Wrap loose objects in a cocoon of silk to prevent them from being used"

/obj/effect/proc_holder/wrap/update_icon()
	action.button_icon_state = "wrap_[active]"
	action.UpdateButtonIcon()

/obj/effect/proc_holder/wrap/Click()
	if(!istype(usr, /mob/living/simple_animal/hostile/poison/giant_spider))
		return TRUE
	var/mob/living/simple_animal/hostile/poison/giant_spider/user = usr
	activate(user)
	return TRUE

/obj/effect/proc_holder/wrap/proc/activate(mob/living/user)
	var/message
	if(active)
		message = "<span class='notice'>You no longer prepare to wrap something in a cocoon.</span>"
		remove_ranged_ability(message)
	else
		message = "<span class='notice'>You prepare to wrap something in a cocoon. <B>Left-click your target to start wrapping!</B></span>"
		add_ranged_ability(user, message, TRUE)
		return TRUE

/obj/effect/proc_holder/wrap/InterceptClickOn(mob/living/caller, params, atom/target)
	if(..())
		return
	if(ranged_ability_user.incapacitated() || !istype(ranged_ability_user, /mob/living/simple_animal/hostile/poison/giant_spider))
		remove_ranged_ability()
		return

	var/mob/living/simple_animal/hostile/poison/giant_spider/user = ranged_ability_user

	if(user.Adjacent(target) && (ismob(target) || isobj(target)))
		var/atom/movable/target_atom = target
		if(target_atom.anchored)
			return
		user.cocoon_target = target_atom
		INVOKE_ASYNC(user, /mob/living/simple_animal/hostile/poison/giant_spider/.proc/cocoon)
		remove_ranged_ability()
		return TRUE

/obj/effect/proc_holder/wrap/on_lose(mob/living/carbon/user)
	remove_ranged_ability()

/datum/action/innate/spider/lay_eggs
	name = "Lay Eggs"
	desc = "Lay a cluster of eggs, which will soon grow into more spiders. You must have a directive set and wrap a living being to do this."
	button_icon_state = "lay_eggs"

/datum/action/innate/spider/lay_eggs/IsAvailable()
	if(..())
		if(!istype(owner, /mob/living/simple_animal/hostile/poison/giant_spider/broodmother))
			return FALSE
<<<<<<< HEAD
		var/mob/living/simple_animal/hostile/poison/giant_spider/nurse/S = owner
		if(S.fed && (S.directive || !S.ckey))
=======
		var/mob/living/simple_animal/hostile/poison/giant_spider/broodmother/S = owner
		var/datum/antagonist/spider/spider_antag = S.mind?.has_antag_datum(/datum/antagonist/spider)
		if((S.fed || S.enriched_fed) && (spider_antag?.spider_team.directive || !S.ckey))
>>>>>>> 4a9732c7f8 (Various spider tweaks (#8409))
			return TRUE
		return FALSE

/datum/action/innate/spider/lay_eggs/Activate()
	if(!istype(owner, /mob/living/simple_animal/hostile/poison/giant_spider/broodmother))
		return
<<<<<<< HEAD
	var/mob/living/simple_animal/hostile/poison/giant_spider/nurse/S = owner

	var/obj/structure/spider/eggcluster/E = locate() in get_turf(S)
	if(E)
		to_chat(S, "<span class='warning'>There is already a cluster of eggs here!</span>")
	else if(!S.fed)
		to_chat(S, "<span class='warning'>You are too hungry to do this!</span>")
	else if(!S.directive && S.ckey)
		to_chat(S, "<span class='warning'>You need to set a directive to do this!</span>")
	else if(S.busy != LAYING_EGGS)
		S.busy = LAYING_EGGS
		S.visible_message("<span class='notice'>[S] begins to lay a cluster of eggs.</span>","<span class='notice'>You begin to lay a cluster of eggs.</span>")
		S.stop_automated_movement = TRUE
		if(do_after(S, 50, target = get_turf(S)))
			if(S.busy == LAYING_EGGS)
				E = locate() in get_turf(S)
				if(!E || !isturf(S.loc))
					var/obj/structure/spider/eggcluster/C = new /obj/structure/spider/eggcluster(get_turf(S))
					if(S.ckey)
						C.player_spiders = TRUE
					C.directive = S.directive
					C.poison_type = S.poison_type
					C.poison_per_bite = S.poison_per_bite
					C.faction = S.faction.Copy()
					S.fed--
=======
	var/mob/living/simple_animal/hostile/poison/giant_spider/broodmother/spider = owner
	var/datum/antagonist/spider/spider_antag = spider.mind?.has_antag_datum(/datum/antagonist/spider)

	var/obj/structure/spider/eggcluster/cluster = locate() in get_turf(spider)
	if(cluster)
		to_chat(spider, "<span class='warning'>There is already a cluster of eggs here!</span>")
	else if(!(spider.fed || spider.enriched_fed))
		to_chat(spider, "<span class='warning'>You are too hungry to do this!</span>")
	else if(!spider_antag?.spider_team.directive && spider.ckey)
		to_chat(spider, "<span class='warning'>You need to set a directive to do this!</span>")
	else if(spider.busy != LAYING_EGGS)
		spider.busy = LAYING_EGGS
		spider.visible_message("<span class='notice'>[spider] begins to lay a cluster of eggs.</span>","<span class='notice'>You begin to lay a cluster of eggs.</span>")
		spider.stop_automated_movement = TRUE
		if(do_after(spider, 50, target = get_turf(spider)))
			if(spider.busy == LAYING_EGGS)
				cluster = locate() in get_turf(spider)
				if(!cluster || !isturf(spider.loc))
					var/obj/structure/spider/eggcluster/new_cluster = new /obj/structure/spider/eggcluster(get_turf(spider))
					if(spider.enriched_fed) // Adds an extra spawn and the potential for an enriched spawn if feeding on high quality food
						new_cluster.enriched_spawns++
						new_cluster.spawns_remaining++
						spider.enriched_fed--
					else
						spider.fed--
						new_cluster.grow_time *= 2
					if(spider_antag?.spider_team) //Is or was this broodmother sentient?
						new_cluster.spider_team = spider_antag?.spider_team //pass that team she has along to the children
					else if(spider.spider_team) //No? then it is probably a second generation broodmother that spawned for a lack of ghosts
						new_cluster.spider_team = spider.spider_team //so we pass the team inherited directly via the previous broodmother
					else //This is a first generation, non-sentient broodmother likely spawned by admins and laying eggs for the first time.
						var/datum/team/spiders/spiders = new() 
						spider.spider_team = spiders					//lets make sure her potentially sentient children are all on the same team
						new_cluster.spider_team = spider.spider_team
					new_cluster.faction = spider.faction.Copy()
>>>>>>> 4a9732c7f8 (Various spider tweaks (#8409))
					UpdateButtonIcon(TRUE)
		S.busy = SPIDER_IDLE
		S.stop_automated_movement = FALSE

/datum/action/innate/spider/set_directive
	name = "Set Directive"
	desc = "Set a directive for your children to follow."
	button_icon_state = "directive"

/datum/action/innate/spider/set_directive/IsAvailable()
	if(..())
		if(!istype(owner, /mob/living/simple_animal/hostile/poison/giant_spider/broodmother))
			return FALSE
		var/mob/living/simple_animal/hostile/poison/giant_spider/S = owner
<<<<<<< HEAD
		if(S.playable)
=======
		var/datum/antagonist/spider/spider_antag = S.mind?.has_antag_datum(/datum/antagonist/spider)
		if(spider_antag?.spider_team.directive)
			to_chat(owner, "<span class='notice'>You already have a directive, you cannot change it!</span>")
>>>>>>> 4a9732c7f8 (Various spider tweaks (#8409))
			return FALSE
		return TRUE

/datum/action/innate/spider/set_directive/Activate()
	if(!istype(owner, /mob/living/simple_animal/hostile/poison/giant_spider/broodmother))
		return
<<<<<<< HEAD
	var/mob/living/simple_animal/hostile/poison/giant_spider/nurse/S = owner
	if(!S.playable)
		var/new_directive = stripped_input(S, "Enter the new directive", "Create directive", "[S.directive]")
		if(new_directive)
			S.directive = new_directive
			message_admins("[ADMIN_LOOKUPFLW(owner)] set its directive to: '[S.directive]'.")
			log_game("[key_name(owner)] set its directive to: '[S.directive]'.")
			S.lay_eggs.UpdateButtonIcon(TRUE)

/mob/living/simple_animal/hostile/poison/giant_spider/Login()
	. = ..()
	GLOB.spidermobs[src] = TRUE

/mob/living/simple_animal/hostile/poison/giant_spider/Destroy()
	GLOB.spidermobs -= src
	return ..()
=======
	if(!owner.mind)
		return
	var/mob/living/simple_animal/hostile/poison/giant_spider/broodmother/S = owner
	var/datum/antagonist/spider/spider_antag = S.mind.has_antag_datum(/datum/antagonist/spider)
	if(!spider_antag)
		spider_antag = S.mind.add_antag_datum(/datum/antagonist/spider)
	var/new_directive = stripped_input(S, "Enter the new directive", "Create directive")
	if(new_directive)
		spider_antag.spider_team.update_directives(new_directive)
		message_admins("[ADMIN_LOOKUPFLW(owner)] set its directive to: '[new_directive]'.")
		log_game("[key_name(owner)][spider_antag.spider_team.master ? " (master: [spider_antag.spider_team.master]" : ""] set its directive to: '[new_directive]'.")
		S.lay_eggs.UpdateButtonIcon(TRUE)
>>>>>>> 4a9732c7f8 (Various spider tweaks (#8409))

/datum/action/innate/spider/comm
	name = "Command"
	desc = "Send a command to all living spiders."
	button_icon_state = "command"

/datum/action/innate/spider/comm/IsAvailable()
	return ..() && istype(owner, /mob/living/simple_animal/hostile/poison/giant_spider/broodmother)

/datum/action/innate/spider/comm/Trigger()
	var/input = stripped_input(owner, "Input a command for your legions to follow.", "Command", "")
	if(QDELETED(src) || !input || !IsAvailable())
		return FALSE
	spider_command(owner, input)
	return TRUE

/datum/action/innate/spider/comm/proc/spider_command(mob/living/user, message)
	if(!message)
		return
	var/my_message
	my_message = "<span class='spider'><b>Command from [user]:</b> [message]</span>"
	for(var/mob/living/simple_animal/hostile/poison/giant_spider/M in GLOB.spidermobs)
		to_chat(M, my_message)
	for(var/M in GLOB.dead_mob_list)
		var/link = FOLLOW_LINK(M, user)
		to_chat(M, "[link] [my_message]")
	usr.log_talk(message, LOG_SAY, tag="spider command")

/mob/living/simple_animal/hostile/poison/giant_spider/handle_temperature_damage()
	if(bodytemperature < minbodytemp)
		adjustBruteLoss(20)
		throw_alert("temp", /atom/movable/screen/alert/cold, 3)
	else if(bodytemperature > maxbodytemp)
		adjustBruteLoss(20)
		throw_alert("temp", /atom/movable/screen/alert/hot, 3)
	else
		clear_alert("temp")

#undef SPIDER_IDLE
#undef SPINNING_WEB
#undef LAYING_EGGS
#undef MOVING_TO_TARGET
#undef SPINNING_COCOON
