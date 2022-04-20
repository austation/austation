//Spawning
/obj/machinery/siege_spawner
	name = "Siege Controller"
	desc = "Used for summoning syndicate operatives for sieges."
	icon = 'icons/obj/device.dmi'
	icon_state = "syndbeacon"
	resistance_flags = INDESTRUCTIBLE
	processing_flags = START_PROCESSING_MANUALLY
	subsystem_type = /datum/controller/subsystem/processing/siege


	var/static/roles = list(/datum/outfit/siege/pirate,
		/datum/outfit/siege/specialist,
		/datum/outfit/siege/grunt,
		/datum/outfit/siege/bomber,
		/datum/outfit/siege/infiltrator,
		/datum/outfit/siege/intruder)
	var/static/elite_roles = list(/datum/outfit/syndicate, //nukie
		/datum/outfit/siege/wizard)//with less spell points

/obj/machinery/siege_spawner/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSsiege, src)
	GLOB.poi_list += src

/obj/machinery/siege_spawner/attack_ghost(mob/user)
	if(!SSticker.HasRoundStarted())
		to_chat(user, "Please wait until spawning has opened.")
	else if(SSticker.mode.gamemode_status > 0)
		spawn_team_member(user.client, SSticker.mode.gamemode_status)

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

	var/list/static/choices = list()
	while(choices.len != 3)
		var/choice = pick(roles)
		if(gamemode_status == 2 && prob(10))
			choice = pick(elite_roles)
		if(choice in choices)
			continue
		choices = choices + choice

	//askuser(new_team_member, "Which role would you like to select?", )
	var/spacesuit =	askuser(new_team_member, "Will you accept a spacesuit?", "With enthusiasm.", "With gratitude.", "No.")
	if(spacesuit == 1 || spacesuit == 2)
		new /obj/item/clothing/suit/space/syndicate(src)
		new /obj/item/clothing/head/helmet/space/syndicate(src)

	var/role =	askuser(new_team_member, "Which class will you choose?", choices[0].name, choices[1].name, choices[2].name)
	switch(role)
		if(1)
			M.equipOutfit(choices[0])
		if(2)
			M.equipOutfit(choices[1])
		if(3)
			M.equipOutfit(choices[2])

//Outfits
/datum/outfit/siege
	name = "Syndicate Siege Operative - Template"
	var/role = "normal"
	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	back = /obj/item/storage/backpack/fireproof
	ears = /obj/item/radio/headset/syndicate/alt
	id = /obj/item/card/id/syndicate
	backpack_contents = list(/obj/item/storage/box/syndie=1,\
		/obj/item/kitchen/knife/combat/survival)

/datum/outfit/siege/specialist
	name = "Syndicate Siege Operative - Specialist"
	role = "specialist"

/datum/outfit/siege/pirate
	name = "Syndicate Siege Operative - Pirate"
	role = "pirate"
	uniform = /obj/item/clothing/under/costume/pirate
	shoes = /obj/item/clothing/shoes/sneakers/brown
	suit = /obj/item/clothing/suit/pirate
	head = /obj/item/clothing/head/bandana
	glasses = /obj/item/clothing/glasses/eyepatch
	belt = /obj/item/gun/energy/laser
	back = /obj/item/gun/energy/laser
	l_pocket = /obj/item/grenade/plastic/c4
	r_pocket = /obj/item/grenade/plastic/x4

/datum/outfit/siege/grunt
	name = "Syndicate Siege Operative - Grunt"
	belt = /obj/item/gun/ballistic/automatic/c20r

/datum/outfit/siege/bomber
	name = "Syndicate Siege Operative - Bomber"
	role = "bomber"
	l_pocket = /obj/item/grenade/plastic/x4
	r_pocket = /obj/item/grenade/plastic/x4

/datum/outfit/siege/infiltrator
	name = "Syndicate Siege Operative - Infiltrator"
	role = "infiltrator"
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
	backpack_contents = list(/obj/item/razor=1,\
		/obj/item/handmirror=1,\
		/obj/item/card/emag)

/datum/outfit/siege/intruder
	name = "Syndicate Siege Operative - Intruder"
	role = "intruder"
	backpack_contents = list(/obj/item/card/emag=1,\
		/obj/item/melee/transforming/energy/sword/saber)

/datum/outfit/siege/wizard
	name = "Syndicate Siege Operative - Wizard"
	role = "wizard"
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

	var/obj/item/implant/i = new/obj/item/implant/explosive/siege(H)
	var/obj/item/implant/weapons_auth/W = new/obj/item/implant/weapons_auth(H)
	W.implant(H)
	H.faction |= ROLE_SYNDICATE
	ADD_TRAIT(H, TRAIT_NODROP, ANTI_DROP_IMPLANT_TRAIT)
	H.update_icons()
	switch(role)
		if("bomber")
			i = new/obj/item/implant/explosive/(H)
		if("pirate")
			H.set_species(/datum/species/skeleton)
		if("zombie")
			H.set_species(/datum/species/zombie)
			return
		if("specialist")
			var/obj/item/U = new /obj/item/uplink/nuclear(/obj/item/uplink/nuclear, H.key, 12)
			H.equip_to_slot_or_del(U, ITEM_SLOT_BACKPACK)
		if("infiltrator")
			var/obj/item/implant/s = new/obj/item/implant/freedom
			s.implant(H)
		if("intruder")
			var/obj/item/implant/s = new/obj/item/implant/stealth
			s.implant(H)
		if("wizard")
			var/obj/item/spellbook/S = locate() in H.held_items
			if(S)
				S.uses = 5
				S.owner = H
	i.implant(H)
	H.update_icons()

/obj/structure/trap/ctf/siegebarrier
	name = "Besieger Spawn Protection"

/obj/structure/trap/ctf/siegebarrier/trap_effect(mob/living/L)
	if(!(ROLE_SYNDICATE in L.faction))
		to_chat(L, "<span class='danger'><B>Stay out of the enemy spawn!</B></span>")
		L.dust()
