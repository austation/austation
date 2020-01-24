#define SPIDER_IDLE 0
#define SPINNING_WEB 1
#define LAYING_EGGS 2
#define MOVING_TO_TARGET 3
#define SPINNING_COCOON 4

// Oh gods why did I make this and why does it have to be in hostile mobs oh boy
// Basically, deals no damage to mobs and injects a chemical that puts humanoids to sleep for self-defence
/mob/living/simple_animal/hostile/poison/giant_spider/friendly
	name = "friendly spider"
	desc = "Furry and black, it makes you want to pet it. This one has beautiful red eyes."
	maxHealth = 300
	health = 300
	obj_damage = 50
	melee_damage_lower = 10
	melee_damage_upper = 15
	faction = list("neutral", "spiders") // don't attack the crew while still NPC
	playable_spider = TRUE
	// stolen from ice spooders
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	var/flavortext = "You are a friendly spider. Don't go out of your way to harm the crew. Your attacks will stun for self-defence."
	var/nextwebspit
	var/webspitcooldown = 10 SECONDS
	var/datum/action/cooldown/spider/lay_eggs_friendly/lay_eggs
	var/datum/action/innate/spider/comm/friendly/comm

/mob/living/simple_animal/hostile/poison/giant_spider/friendly/Initialize()
	. = ..()
	lay_eggs = new
	lay_eggs.Grant(src)
	comm = new
	comm.Grant(src)
	nextwebspit = world.time

/mob/living/simple_animal/hostile/poison/giant_spider/friendly/Login()
	..()
	if(flavortext)
		var/message = "<span class='big bold'>Information:</span>"
		message += "\n<span class='bold'>[flavortext]</span>"
		to_chat(src, message)
		if(mind)
			mind.store_memory("<span class='bold'>[flavortext]</span>")

/mob/living/simple_animal/hostile/poison/giant_spider/friendly/AttackingTarget()
	if(istype(target, /mob/living/simple_animal/hostile/poison/giant_spider/friendly)) // if this is well recieved I might let friendly spooders tend injuries of other mobs too.
		var/mob/living/simple_animal/hostile/poison/giant_spider/friendly/F = target
		if(F.health >= F.maxHealth)
			to_chat(src, "<span class='notice'>[target] is already fully healed!")
		else
			visible_message("<span class='nicegreen'>[src] gently tends to [target]'s wounds.</span>", "<span class='nicegreen'>You gently tend to [target]'s wounds.", null, COMBAT_MESSAGE_RANGE, F)
			to_chat(F, "<span class='nicegreen'>[src] gently tends to your wounds.</span>")
			F.health += 5
	else if(isanimal(target) && target != src)
		..() // nothing sucks more than being chased by a space carp you can't actually take down
	else if(isliving(target) && target != src)
		if(world.time > nextwebspit)
			var/mob/living/L = target
			playsound(loc, 'sound/effects/spray2.ogg', 50, TRUE, TRUE)
			if(issilicon(target))
				visible_message("<span class='warning'>[src] spits web at [target]'s sensors!</span>'", "<span class='warning'>You spit web at [target]'s sensors!", null, COMBAT_MESSAGE_RANGE, L)
				to_chat(L, "<span class='userdanger'>[src] spits web at your sensors, stunning you!</span>")
				L.Stun(50)
			else
				visible_message("<span class='warning'>[src] spits web into [target]'s eyes!</span>", "<span class='warning'>You spit web into [target]'s eyes!", null, COMBAT_MESSAGE_RANGE, L)
				to_chat(L, "<span class='userdanger'>[src] spits web into your eyes, blinding you!")
				L.Paralyze(30)
				L.blind_eyes(2)
			nextwebspit = world.time + webspitcooldown
		else
			to_chat(src, "<span class='warning'>Your spinnerets have not had long enough to recover! Wait [(nextwebspit - world.time)/10] seconds!</span>")
	else
		..()

/datum/action/cooldown/spider/lay_eggs_friendly
	name = "Lay Eggs"
	desc = "Lay a cluster of eggs, which will soon grow into more friendly spiders."
	icon_icon = 'icons/mob/actions/actions_animal.dmi'
	background_icon_state = "bg_alien"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "lay_eggs"
	cooldown_time = 5 MINUTES

/datum/action/cooldown/spider/lay_eggs_friendly/IsAvailable()
	. = ..()
	if(!istype(owner, /mob/living/simple_animal/hostile/poison/giant_spider/friendly))
		return FALSE

/datum/action/cooldown/spider/lay_eggs_friendly/Trigger()
	if(!..())
		to_chat(owner, "<span class='warning'>You are too tired to lay more eggs at the moment. Try again in [(next_use_time - world.time)/10] seconds.</span>")
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/poison/giant_spider/friendly))
		return FALSE
	var/mob/living/simple_animal/hostile/poison/giant_spider/friendly/S = owner

	var/obj/structure/spider/eggcluster/E = locate() in get_turf(S)
	if(E)
		to_chat(S, "<span class='warning'>There is already a cluster of eggs here!</span>")
		return FALSE
	else if(S.busy != LAYING_EGGS)
		S.busy = LAYING_EGGS
		S.visible_message("<span class='notice'>[S] begins to lay a cluster of eggs.</span>","<span class='notice'>You begin to lay a cluster of eggs.</span>")
		S.stop_automated_movement = TRUE
		if(do_after(S, 50, target = get_turf(S)))
			if(S.busy == LAYING_EGGS)
				E = locate() in get_turf(S)
				if(!E || !isturf(S.loc))
					var/obj/structure/spider/eggcluster/friendly/C = new /obj/structure/spider/eggcluster/friendly(get_turf(S))
					if(S.ckey)
						C.player_spiders = TRUE
					C.directive = S.directive
					C.poison_type = S.poison_type
					C.poison_per_bite = S.poison_per_bite
					C.faction = S.faction.Copy()
					UpdateButtonIcon(TRUE)
		S.busy = SPIDER_IDLE
		S.stop_automated_movement = FALSE

/datum/action/innate/spider/comm/friendly
	name = "Communicate"
	desc = "Communicate telepathically with other friendly spiders."
	button_icon_state = "command"

/datum/action/innate/spider/comm/friendly/IsAvailable()
	if(!istype(owner, /mob/living/simple_animal/hostile/poison/giant_spider/friendly))
		return FALSE
	return TRUE

/datum/action/innate/spider/comm/friendly/Trigger()
	var/input = stripped_input(owner, "What would you like to broadcast to your friends.", "Communication", "")
	if(QDELETED(src) || !input || !IsAvailable())
		return FALSE
	spider_command(owner, input)
	return TRUE

/datum/action/innate/spider/comm/friendly/spider_command(mob/living/user, message)
	if(!message)
		return
	var/my_message
	my_message = "<span class='spider'><b>Spider communication from [user]:</b> [message]</span>"
	for(var/mob/living/simple_animal/hostile/poison/giant_spider/friendly/M in GLOB.spidermobs)
		if(istype(M))
			to_chat(M, my_message)
	for(var/M in GLOB.dead_mob_list)
		var/link = FOLLOW_LINK(M, user)
		to_chat(M, "[link] [my_message]")
	usr.log_talk(message, LOG_SAY, tag="friendly spider communication")

/obj/structure/spider/eggcluster/friendly
	name = "friendly egg cluster"

/obj/structure/spider/eggcluster/friendly/process()
	amount_grown += rand(0,2)
	if(amount_grown >= 100)
		var/num = rand(1,2)
		for(var/i=0, i<num, i++)
			var/mob/living/simple_animal/hostile/poison/giant_spider/friendly/S = new /mob/living/simple_animal/hostile/poison/giant_spider/friendly(src.loc)
			S.faction = faction.Copy()
			S.directive = directive
			offer_control(S)
		qdel(src)
