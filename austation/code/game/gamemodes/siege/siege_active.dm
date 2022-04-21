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
				spawn_team_member(user.client, SSticker.mode.gamemode_status)
		else
			ops += list(user.ckey = world.time + 50)
			spawn_team_member(user.client, SSticker.mode.gamemode_status)
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

/obj/machinery/siege_spawner/proc/spawn_team_member(client/new_team_member, gamemode_status)

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
		if(gamemode_status == 2 && prob(10))
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

	var/role = askuser(new_team_member, "Which class will you choose?", "Class Selection", choice_1.name, choice_2.name, choice_3.name)
	switch(role)
		if(1)
			M.equipOutfit(choices[1])
		if(2)
			M.equipOutfit(choices[2])
		if(3)
			M.equipOutfit(choices[3])

//Outfits
/datum/outfit/siege
	name = "Operative - Template"
	var/role = "normal"
	suit = /obj/item/clothing/suit/space/syndicate
	head = /obj/item/clothing/head/helmet/space/syndicate
	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	back = /obj/item/storage/backpack/fireproof
	ears = /obj/item/radio/headset/syndicate/alt
	id = /obj/item/card/id/syndicate
	backpack_contents = list(/obj/item/storage/box/syndie=1,\
		/obj/item/kitchen/knife/combat/survival)

/datum/outfit/siege/specialist
	name = "Operative - Specialist"

/datum/outfit/siege/pirate
	name = "Operative - Pirate"
	uniform = /obj/item/clothing/under/costume/pirate
	shoes = /obj/item/clothing/shoes/sneakers/brown
	suit = /obj/item/clothing/suit/pirate
	head = /obj/item/clothing/head/bandana
	glasses = /obj/item/clothing/glasses/eyepatch
	belt = /obj/item/gun/energy/laser
	back = null
	l_hand = /obj/item/gun/energy/laser
	l_pocket = /obj/item/grenade/plastic/c4
	r_pocket = /obj/item/grenade/plastic/x4

/datum/outfit/siege/grunt
	name = "Operative - Grunt"
	belt = /obj/item/gun/ballistic/automatic/c20r
	r_pocket = /obj/item/ammo_box/magazine/smgm45
	l_pocket = /obj/item/ammo_box/magazine/smgm45
	backpack_contents = list(/obj/item/storage/box/syndie=1,\
		/obj/item/kitchen/knife/combat/survival,\
		/obj/item/ammo_box/magazine/smgm45 = 2)

/datum/outfit/siege/bomber
	name = "Operative - Bomber"
	l_pocket = /obj/item/grenade/plastic/x4
	r_pocket = /obj/item/grenade/plastic/x4
	suit = /obj/item/clothing/suit/space/syndicate/blue
	head = /obj/item/clothing/head/helmet/space/syndicate/blue

/datum/outfit/siege/infiltrator
	name = "Operative - Infiltrator"
	uniform = /obj/item/clothing/under/chameleon
	suit = /obj/item/clothing/suit/chameleon
	gloves = /obj/item/clothing/gloves/chameleon
	shoes = /obj/item/clothing/shoes/chameleon
	glasses = /obj/item/clothing/glasses/chameleon
	head = /obj/item/clothing/head/chameleon
	mask = /obj/item/clothing/mask/chameleon
	neck = /obj/item/clothing/neck/chameleon
	back = /obj/item/storage/backpack/chameleon
	ears = /obj/item/radio/headset/chameleon
	head = /obj/item/clothing/head/wig
	l_hand = /obj/item/clothing/suit/space/syndicate
	r_hand = /obj/item/clothing/head/helmet/space/syndicate
	backpack_contents = list(/obj/item/storage/box/syndie=1,\
		/obj/item/kitchen/knife/combat/survival,\
		/obj/item/razor=1,\
		/obj/item/handmirror=1,\
		/obj/item/card/emag)

/datum/outfit/siege/intruder
	name = "Operative - Intruder"
	l_hand = /obj/item/melee/transforming/energy/blade
	backpack_contents = list(/obj/item/storage/box/syndie=1,\
		/obj/item/card/emag=1)

/datum/outfit/siege/zombie
	name = "Operative - Zombie"
	back = null
	suit = /obj/item/clothing/suit/space/syndicate/black

/datum/outfit/siege/intruder/brawler
	name = "Operative - Brawler"
	suit = /obj/item/clothing/suit/space/syndicate
	head = null

/datum/outfit/siege/engineer
	name = "Operative - Engineer"
	belt = /obj/item/storage/belt/utility/full
	l_hand = /obj/item/gun/ballistic/shotgun/lethal
	uniform = /obj/item/clothing/under/misc/overalls
	suit = /obj/item/clothing/suit/space/syndicate/orange
	head = /obj/item/clothing/head/helmet/space/syndicate/orange
	backpack_contents = list(/obj/item/storage/box/syndie=1,\
		/obj/item/storage/box/lethalshot = 2)
	l_pocket = /obj/item/stack/sheet/iron/fifty


//Elite Roles
/datum/outfit/siege/wizard
	name = "Operative - Wizard"
	uniform = /obj/item/clothing/under/color/lightpurple
	suit = /obj/item/clothing/suit/wizrobe
	shoes = /obj/item/clothing/shoes/sandal/magic
	ears = /obj/item/radio/headset
	head = /obj/item/clothing/head/wizard
	r_pocket = /obj/item/teleportation_scroll
	r_hand = /obj/item/spellbook
	l_hand = /obj/item/staff

/datum/outfit/siege/post_equip(mob/living/carbon/human/H)
	var/obj/item/radio/R = H.ears
	R.set_frequency(FREQ_SYNDICATE)
	R.freqlock = TRUE

	var/obj/item/card/id/a = locate() in H.get_equipped_items()
	a.assignment = name

	var/obj/item/implant/i = new/obj/item/implant/explosive/siege(H)
	var/obj/item/implant/weapons_auth/W = new/obj/item/implant/weapons_auth(H)
	W.implant(H)
	H.faction |= ROLE_SYNDICATE
	ADD_TRAIT(H, TRAIT_NODROP, ANTI_DROP_IMPLANT_TRAIT)
	H.update_icons()
	switch(name)
		if("Operative - Bomber")
			i = new/obj/item/implant/explosive/(H)
		if("Operative - Pirate")
			H.set_species(/datum/species/skeleton)
		if("Operative - Zombie")
			H.set_species(/datum/species/zombie/infectious)
			return
		if("Operative - Specialist")
			var/obj/item/U = new /obj/item/uplink/nuclear(/obj/item/uplink/nuclear, H.key, 12)
			H.equip_to_slot_or_del(U, ITEM_SLOT_BACKPACK)
		if("Operative - Infiltrator")
			var/obj/item/implant/s = new/obj/item/implant/freedom
			s.implant(H)
		if("Operative - Intruder")
			var/obj/item/implant/s = new/obj/item/implant/stealth
			s.implant(H)
		if("Operative - Wizard")
			H.name = pick(GLOB.wizard_first) + " " + pick(GLOB.wizard_second)
			H.real_name = H.name
			H.dna.add_mutation(new /datum/mutation/human/space_adaptation)
			var/obj/item/spellbook/S = locate() in H.held_items
			if(S)
				S.uses = 5
				S.owner = H

	a.registered_name = H.name
	i.implant(H)
	H.update_icons()

/obj/structure/trap/ctf/siegebarrier
	name = "Besieger Spawn Protection"

/obj/structure/trap/ctf/siegebarrier/trap_effect(mob/living/L)
	if(!(ROLE_SYNDICATE in L.faction))
		to_chat(L, "<span class='danger'><B>Stay out of the enemy spawn!</B></span>")
		L.dust()
