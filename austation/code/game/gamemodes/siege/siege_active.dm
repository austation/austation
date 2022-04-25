//Spawning
/obj/machinery/siege_spawner
	name = "Siege Controller"
	desc = "Used for summoning syndicate operatives for sieges."
	icon = 'icons/obj/device.dmi'
	icon_state = "syndbeacon"
	resistance_flags = INDESTRUCTIBLE

	var/static/datum/outfit/siege/roles = list(/datum/outfit/siege/pirate,
		/datum/outfit/siege/specialist,
		/datum/outfit/siege/grunt,
		/datum/outfit/siege/bomber,
		/datum/outfit/siege/infiltrator,
		/datum/outfit/siege/intruder,
		/datum/outfit/siege/intruder/brawler,
		/datum/outfit/siege/engineer,
		/datum/outfit/siege/zombie)
	var/static/datum/outfit/siege/elite_roles = list(/datum/outfit/syndicate, //nukie
		/datum/outfit/siege/wizard)//with less spell points

	var/list/ops = list()

/obj/machinery/siege_spawner/Initialize(mapload)
	. = ..()
	SSshuttle.registerHostileEnvironment(src)
	GLOB.poi_list += src

/obj/machinery/siege_spawner/attack_ghost(mob/user)
	if(SSticker.mode.gamemode_status > 1)
		if(user.ckey in ops)
			if(ops[user.ckey] > world.time)
				to_chat(user, "You have spawned too recently, wait.")
			else
				ops[user.ckey] = world.time
				spawn_team_member(user.client)
		else
			ops += list(user.ckey = world.time + 50)
			spawn_team_member(user.client)
			for(var/mob/M in GLOB.player_list)
				to_chat(M, "A player has joined the syndicate team.")
				SEND_SOUND(M, 'austation/sound/misc/Infected.ogg')
	else
		to_chat(user, "Please wait until spawning has opened.")

/obj/machinery/siege_spawner/Topic(href, href_list)
	if(href_list["join"])
		var/mob/dead/observer/ghost = usr
		if(istype(ghost))
			attack_ghost(ghost)

/obj/machinery/siege_spawner/proc/spawn_team_member(client/new_team_member)
	var/mob/living/carbon/human/M = new/mob/living/carbon/human(get_turf(src))
	new_team_member.prefs.copy_to(M)
	M.faction |= ROLE_SYNDICATE
	M.set_species(/datum/species/human)
	M.key = new_team_member.key
	M.name = syndicate_name() + " Operative"
	M.real_name = M.name

	var/list/datum/outfit/choices = list()
	while(choices.len != 3)
		var/datum/outfit/choice = pick(roles)
		if(SSticker.mode.gamemode_status == 2 && prob(5))//repeated 3 times, so chance is 3x higher
			choice = pick(elite_roles)
		if(choice in choices)
			continue
		choices += choice

	//Have mercy on my soul
	var/datum/outfit/choice_1 = choices[1]
	var/datum/outfit/choice_2 = choices[2]
	var/datum/outfit/choice_3 = choices[3]
	choice_1 = new choice_1
	choice_2 = new choice_2
	choice_3 = new choice_3

	var/role = askuser(new_team_member, "Which class will you choose?", "Class Selection", "<p>[choice_1.name]</p>", "<p>[choice_2.name]</p>", "<p>[choice_3.name]<p>")
	switch(role)
		if(1)
			M.equipOutfit(choices[1])
		if(2)
			M.equipOutfit(choices[2])
		if(3)
			M.equipOutfit(choices[3])

/obj/structure/trap/ctf/siegebarrier
	name = "Besieger Spawn Protection"

/obj/structure/trap/ctf/siegebarrier/trap_effect(mob/living/L)
	if(!(ROLE_SYNDICATE in L.faction))
		to_chat(L, "<span class='danger'><B>Stay out of the enemy spawn!</B></span>")
		L.dust()

//Engineer Items
/obj/item/syndPDA
	name = "Syndicate Constuction PDA"
	desc = "Syndicate Constuction PDA, used to built teleporters, dispensers and turrets."
	icon = 'icons/obj/tools.dmi'
	icon_state = "arcd"
	item_state = "oldrcd"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'

	var/teleporter_num = 0
	var/dispenser
	var/turret
	var/material = 0

/obj/machinery/quantumpad/syndicate
	use_power = NO_POWER_USE
	var/obj/item/syndPDA/parent_PDA

/obj/machinery/quantumpad/syndicate/attackby(obj/item/I, mob/living/user, params)
	..()
	if(user.a_intent == INTENT_HELP && (ROLE_SYNDICATE in user.faction))
		if(I.tool_behaviour == TOOL_WRENCH)
			obj_integrity = max_integrity
		else if(I.tool_behaviour == TOOL_CROWBAR)
			parent_PDA.material += 50
			qdel(src)

/obj/machinery/quantumpad/syndicate/Destroy()
	parent_PDA.teleporter_num -= 1
	contents = null
	..()

/obj/item/syndPDA/attack_self(mob/user)
	var/con = askuser(user, "What do you want to build?", "Building Selection", "<p>Teleporter</p>", "<p>Dispenser</p>", "<p>Turret</p>")
	switch(con)
		if(1)
			if(teleporter_num != 2)
				var/obj/machinery/quantumpad/syndicate/pad = new /obj/machinery/quantumpad/syndicate(get_turf(src))
				pad.parent_PDA = src
				teleporter_num++
			else
				to_chat(user, "<span class='warning'>You already have two teleporters.</span>")
		if(2)
			if(dispenser)
				to_chat(user, "<span class='warning'>You already have a dispenser.</span>")
			else
				new /obj/machinery/quantumpad/syndicate(get_turf(src))
		if(3)
			if(turret)
				to_chat(user, "<span class='warning'>You already have a turret.</span>")
			else
				var/obj/machinery/porta_turret/syndicate/pod/toolbox/siege/tur = new /obj/machinery/porta_turret/syndicate/pod/toolbox/siege(get_turf(src))
				tur.parent_PDA = src
				turret = TRUE
