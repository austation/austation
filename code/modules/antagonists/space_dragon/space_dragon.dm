/datum/antagonist/space_dragon
	name = "Space Dragon"
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = TRUE

/datum/antagonist/space_dragon/greet()
	to_chat(owner, "<b>I am Space Dragon, ex-space carp, and defender of the secrets of constellation, Draco.</b>")
	to_chat(owner, "<b>Fabulous secret powers were revealed to me the day I held aloft a wizard's staff of change and said 'By the power of Draco, I have the power!'</b>")
	to_chat(owner, "<b>The wizard was turned into the short-lived Pastry Cat while I became Space Dragon, the most powerful beast in the universe.</b>")
	to_chat(owner, "<b>Clicking a tile will shoot fire onto that tile.</b>")
	to_chat(owner, "<b>Using Tail Sweep will let me get the better of those who come too close.</b>")
	to_chat(owner, "<b>Attacking dead bodies will allow me to gib them to restore health.</b>")
	to_chat(owner, "<b>From the wizard's writings, he had been studying this station and its hierarchy.  From this, I know who leads the station, and will kill them so the station underlings see me as their new leader.</b>")
	owner.announce_objectives()
	SEND_SOUND(owner.current, sound('sound/magic/demon_attack1.ogg'))
	owner.current.client?.tgui_panel?.give_antagonist_popup("Space Dragon",
		"Once you were a space carp, until a powerful wizard transformed you. Use your new-found powers to complete your goals.")

/datum/antagonist/space_dragon/proc/forge_objectives()
	if(!give_objectives)
		return
	var/current_heads = SSjob.get_all_heads()
	var/datum/objective/assassinate/killchosen = new
	killchosen.owner = owner
	var/datum/mind/selected = pick(current_heads)
	killchosen.set_target(selected)
	killchosen.update_explanation_text()
	objectives += killchosen
	log_objective(owner, killchosen.explanation_text)
	var/datum/objective/survive/survival = new
	survival.owner = owner
	objectives += survival
	log_objective(owner, survival.explanation_text)

/datum/antagonist/space_dragon/on_gain()
	forge_objectives()
	. = ..()
<<<<<<< HEAD
=======
	rift_ability = new
	rift_ability.Grant(owner.current)
	wavespeak_ability = new
	wavespeak_ability.Grant(owner.current)
	owner.current.faction |= "carp"
	RegisterSignal(owner.current, COMSIG_LIVING_LIFE, .proc/rift_checks)
	RegisterSignal(owner.current, COMSIG_MOB_DEATH, .proc/destroy_rifts)
	start_rift_timer()

/datum/antagonist/space_dragon/on_removal()
	. = ..()
	rift_ability.Remove(owner.current)
	owner.current.faction -= "carp"
	UnregisterSignal(owner.current, COMSIG_LIVING_LIFE)
	UnregisterSignal(owner.current, COMSIG_MOB_DEATH)
	rift_list = null

/datum/antagonist/space_dragon/Destroy()
	rift_list = null
	return ..()

/**
  * Sets up Space Dragon's victory for completing the objectives.
  *
  * Triggers when Space Dragon completes his objective.
  * Calls the shuttle with a coefficient of 3, making it impossible to recall.
  * Sets all of his rifts to allow for infinite sentient carp spawns
  * Also plays appropiate sounds and CENTCOM messages.
  */
/datum/antagonist/space_dragon/proc/victory()
	objective_complete = TRUE
	permanent_empower()
	var/datum/objective/summon_carp/main_objective = locate() in objectives
	if(main_objective)
		main_objective.completed = TRUE
	priority_announce("A large amount of lifeforms have been detected approaching [station_name()] at extreme speeds. Remaining crew are advised to evacuate as soon as possible.", "Central Command Wildlife Observations")
	sound_to_playing_players('sound/creatures/space_dragon_roar.ogg')
	for(var/obj/structure/carp_rift/rift in rift_list)
		rift.carp_stored = 999999
		rift.time_charged = rift.max_charge

/datum/antagonist/space_dragon/proc/rift_checks()
	SIGNAL_HANDLER
	if((rifts_charged == 3 || (SSshuttle.emergency.mode == SHUTTLE_DOCKED && rifts_charged > 0)) && !objective_complete)
		victory()

/datum/antagonist/space_dragon/proc/start_rift_timer()
	rift_warning_timer_id = addtimer(CALLBACK(src, .proc/rift_warn_callback), max_time_to_rift_fail - 1 MINUTES, TIMER_STOPPABLE)
	rift_fail_timer_id = addtimer(CALLBACK(src, .proc/rift_fail_callback), max_time_to_rift_fail, TIMER_STOPPABLE)
	if(istype(owner.current, /mob/living/simple_animal/hostile/space_dragon))
		var/mob/living/simple_animal/hostile/space_dragon/S = owner.current
		S.can_summon_rifts = FALSE

/datum/antagonist/space_dragon/proc/stop_rift_timer()
	deltimer(rift_warning_timer_id)
	rift_warning_timer_id = TIMER_ID_NULL
	deltimer(rift_fail_timer_id)
	rift_fail_timer_id = TIMER_ID_NULL
	if(istype(owner.current, /mob/living/simple_animal/hostile/space_dragon))
		var/mob/living/simple_animal/hostile/space_dragon/S = owner.current
		S.can_summon_rifts = TRUE

/datum/antagonist/space_dragon/proc/rift_warn_callback()
	to_chat(owner.current, "<span class='boldwarning'>You have a minute left to summon a rift! Get to it!</span>")
	rift_warning_timer_id = TIMER_ID_NULL

/datum/antagonist/space_dragon/proc/rift_fail_callback()
	to_chat(owner.current, "<span class='boldwarning'>You've failed to summon a rift in a timely manner, and find yourself weakened.</span>")
	destroy_rifts()
	playsound(owner.current, 'sound/magic/demon_dies.ogg', 100, TRUE)
	rift_fail_timer_id = TIMER_ID_NULL

/**
 * Handles Space Dragon's temporary empowerment after boosting a rift.
 *
 * Empowers and depowers Space Dragon after a successful rift charge.
 * Empowered, Space Dragon regains all his health and becomes temporarily faster for 30 seconds, along with being tinted red.
 */
/datum/antagonist/space_dragon/proc/rift_empower(is_permanent)
	owner.current.fully_heal()
	owner.current.add_filter("anger_glow", 3, list("type" = "outline", "color" = "#ff330030", "size" = 5))
	owner.current.add_movespeed_modifier(MOVESPEED_ID_DRAGON_RAGE, multiplicative_slowdown = -0.5)
	addtimer(CALLBACK(src, .proc/rift_depower), 30 SECONDS)

/**
 * Gives Space Dragon their the rift speed buff permanently.
 *
 * Gives Space Dragon the enraged speed buff from charging rifts permanently.
 * Only happens in circumstances where Space Dragon completes their objective.
 */
/datum/antagonist/space_dragon/proc/permanent_empower()
	owner.current.fully_heal()
	owner.current.add_filter("anger_glow", 3, list("type" = "outline", "color" = "#ff330030", "size" = 5))
	owner.current.add_movespeed_modifier(MOVESPEED_ID_DRAGON_RAGE, multiplicative_slowdown = -0.5)

/**
 * Removes Space Dragon's rift speed buff.
 *
 * Removes Space Dragon's speed buff from charging a rift.  This is only called
 * in rift_empower, which uses a timer to call this after 30 seconds.  Also
 * removes the red glow from Space Dragon which is synonymous with the speed buff.
 */
/datum/antagonist/space_dragon/proc/rift_depower()
	owner.current.remove_filter("anger_glow")
	owner.current.remove_movespeed_modifier(MOVESPEED_ID_DRAGON_RAGE)

/**
 * Destroys all of Space Dragon's current rifts.
 *
 * QDeletes all the current rifts after removing their references to other objects.
 * Currently, the only reference they have is to the Dragon which created them, so we clear that before deleting them.
 * Currently used when Space Dragon dies or one of his rifts is destroyed.
 */
/datum/antagonist/space_dragon/proc/destroy_rifts()
	SIGNAL_HANDLER
	if(objective_complete) // this will always trigger on death, be sure that we didn't succeed already
		return
	rifts_charged = 0
	owner.current.add_movespeed_modifier(MOVESPEED_ID_DRAGON_DEPRESSION, multiplicative_slowdown = 5)
	stop_rift_timer()
	if(istype(owner.current, /mob/living/simple_animal/hostile/space_dragon))
		var/mob/living/simple_animal/hostile/space_dragon/S = owner.current
		S.tiredness_mult = 5
	playsound(owner.current, 'sound/vehicles/rocketlaunch.ogg', 100, TRUE)
	for(var/obj/structure/carp_rift/rift in rift_list)
		if(!QDELETED(rift))
			qdel(rift)
	rift_list.Cut()

/datum/objective/summon_carp
	var/datum/antagonist/space_dragon/dragon
	explanation_text = "Summon 3 rifts in order to flood the station with carp. Your possible rift locations are: (ERROR)."

/datum/antagonist/space_dragon/roundend_report()
	var/list/parts = list()
	var/datum/objective/summon_carp/S = locate() in objectives
	if(S.check_completion())
		parts += "<span class='redtext big'>The [name] has succeeded! Station space has been reclaimed by the space carp!</span>"
	parts += printplayer(owner)
	var/objectives_complete = TRUE
	if(length(objectives))
		parts += printobjectives(objectives)
		for(var/datum/objective/objective in objectives)
			if(!objective.check_completion())
				objectives_complete = FALSE
				break
	if(objectives_complete)
		parts += "<span class='greentext big'>The [name] was successful!</span>"
	else
		parts += "<span class='redtext big'>The [name] has failed!</span>"
	parts += "<span class='header'>The [name] was assisted by:</span>"
	if(length(carp))
		parts += "<span class='header'>The [name] was assisted by:</span>"
		parts += printplayerlist(carp)
	return "<div class='panel redborder'>[parts.Join("<br>")]</div>"

/datum/action/innate/wavespeak
	name = "Carp Wavespeak"
	desc = "Communicate through wavespeak."
	background_icon_state = "bg_default"
	icon_icon = 'icons/mob/actions/actions_space_dragon.dmi'
	button_icon_state = "wavespeak"
	check_flags = AB_CHECK_CONSCIOUS

/datum/action/innate/wavespeak/IsAvailable()
	if(!("carp" in owner.faction))
		return FALSE
	return ..()

/datum/action/innate/wavespeak/Activate()
	// This is filtered, treated, and logged in carp_talk
	var/input = stripped_input(usr, "Enter wavespeak message.", "Carp Wavespeak", "")
	if(!input || !IsAvailable() || !isliving(owner))
		return
	var/mob/living/L = owner
	L.carp_talk(input)
>>>>>>> 530077abdc (Fixes cultists being unable to use their spells (#8384))
