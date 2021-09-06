GLOBAL_VAR_INIT(hsboxspawn, TRUE)

#define HSB_SPAWN_DELAY 10

/mob
	var/datum/hSB/sandbox = null

/mob/proc/CanBuild()
	sandbox = new/datum/hSB
	sandbox.owner = src.ckey
	if(src.client.holder)
		sandbox.admin = 1
	add_verb(/mob/proc/sandbox_panel)

/mob/proc/sandbox_panel()
	set name = "Sandbox Panel"
	set category = "Sandbox"
	if (sandbox)
		sandbox.ui_interact(usr)

/datum/hSB/ui_state(mob/user)
	return GLOB.always_state

/datum/hSB/ui_interact(mob/user, datum/tgui/ui)
	if(!check_rights(R_ADMIN, 0))
		admin = 0
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Snasboxpanel", "Sandbox Panel")
		ui.open()

/datum/hSB
	var/owner = null
	var/admin = 0

	var/last_spawn_time = 0

	var/static/list/clothitems
	var/static/list/reagentitems
	var/static/list/otheritems

	//items that shouldn't spawn on the floor because they would bug or act weird
	var/static/list/spawn_forbidden = list(
		/obj/item/tk_grab, /obj/item/implant, // not implanter, the actual thing that is inside you
		/obj/item/assembly, /obj/item/onetankbomb, /obj/item/pda/ai,
		/obj/item/smallDelivery, /obj/item/projectile,
		/obj/item/borg/sight, /obj/item/borg/stun, /obj/item/robot_module)

/datum/hSB/New()
	..()
	if(!clothitems)
		clothitems = subtypesof(/obj/item/clothing)
		for(var/typekey in spawn_forbidden)
			clothitems -= typesof(typekey)
	if(!reagentitems)
		reagentitems = subtypesof(/obj/item/reagent_containers)
		for(var/typekey in spawn_forbidden)
			reagentitems -= typesof(typekey)
	if(!otheritems)
		otheritems = subtypesof(/obj/item/) - typesof(/obj/item/clothing) - typesof(/obj/item/reagent_containers)
		for(var/typekey in spawn_forbidden)
			otheritems -= typesof(typekey)

/datum/hSB/ui_static_data(mob/user)
	var/list/data = list()
	data["Categories"] = list()

	data["Categories"]["Space Gear"] = list(
		list("Suit Up (Space Travel Gear)", "hsbsuit"),
		list("Spawn Gas Mask", "/obj/item/clothing/mask/gas]"),
		list("Spawn Emergency Air Tank", "/obj/item/tank/internals/emergency_oxygen/double")
		)

	data["Categories"]["Standard Tools"] = list(
		list("Spawn Flashlight", "/obj/item/flashlight"),
		list("Spawn Toolbox", "/obj/item/storage/toolbox/mechanical"),
		list("Spawn Tier 4 BSRPED", "/obj/item/storage/part_replacer/bluespace/tier4"),
		list("Spawn Toolbelt", "/obj/item/storage/belt/utility/chief/full"),
		list("Spawn Light Replacer", "/obj/item/lightreplacer"),
		list("Spawn Medical Kit", "/obj/item/storage/firstaid/regular"),
		list("Spawn All-Access ID", "hsbaaid")
		)

	data["Categories"]["Building Supplies"] = list(
		list("Spawn 50 Wood", "hsbwood"),
		list("Spawn 50 Iron", "hsbiron"),
		list("Spawn 50 Plasteel", "hsbplasteel"),
		list("Spawn 50 Reinforced Glass", "hsbrglass"),
		list("Spawn 50 Glass", "hsbglass"),
		list("Spawn Full Cable Coil", "/obj/item/stack/cable_coil"),
		list("Spawn Hyper Capacity Power Cell", "/obj/item/stock_parts/cell/hyper"),
		list("Spawn Inf. Capacity Power Cell", "/obj/item/stock_parts/cell/infinite"),
		list("Spawn Rapid Construction Device", "hsbrcd"),
		list("Spawn RCD Ammo", "/obj/item/rcd_ammo")
		)

	data["Categories"]["Miscellaneous"] = list(
		list("Spawn Air Scrubber", "hsbscrubber"),
		list("Spawn Debug Tech Disk", "/obj/item/disk/tech_disk/debug"),
		list("Spawn All Materials", "/obj/structure/closet/syndicate/resources/everything"),
		list("Spawn Water Tank", "/obj/structure/reagent_dispensers/watertank")
		)

	data["Categories"]["Bots"] = list(
		list("Spawn Cleanbot", "/mob/living/simple_animal/bot/cleanbot"),
		list("Spawn Floorbot", "/mob/living/simple_animal/bot/floorbot"),
		list("Spawn Medbot", "/mob/living/simple_animal/bot/medbot")
		)

	data["Categories"]["Canisters"] = list(
		list("Spawn O2 Canister", "/obj/machinery/portable_atmospherics/canister/oxygen"),
		list("Spawn Air Canister", "/obj/machinery/portable_atmospherics/canister/air")
		)

	data["Categories"]["Other"] = list(
		list("Spawn Clothings", "hsbcloth"),
		list("Spawn Reagent Container", "hsbreag"),
		list("Spawn Other Items", "hsbobj")
	)

	if(check_rights(R_ADMIN,0))
		data["Categories"]["Administration"] = list(
			list("Toggle Object Spawning", "/obj/machinery/portable_atmospherics/canister/oxygen"),
			list("Toggle Item Spawn Panel Auto-close", "/obj/machinery/portable_atmospherics/canister/air")
		)

	return data

/datum/hSB/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!admin)
		if(world.time < spawn_timer)
			to_chat(usr, "Spawning is on cooldown, please wait a bit!")
			return

	spawn_timer = world.time + HSB_SPAWN_DELAY

	var/typepath = text2path(action)
	if(ispath(typepath))
		. = TRUE
		new typepath(usr.loc)

		if(CONFIG_GET(flag/sandbox_autoclose))
			ui.close()
		return

	switch(action)
		//
		// Admin: toggle spawning
		//
		if("hsbtobj")
			. = TRUE
			if(!admin) return
			if(GLOB.hsboxspawn)
				to_chat(world, "<span class='boldannounce'>Sandbox:</span> <b>\black[usr.key] has disabled object spawning!</b>")
				GLOB.hsboxspawn = FALSE
				return
			else
				to_chat(world, "<span class='boldnotice'>Sandbox:</span> <b>\black[usr.key] has enabled object spawning!</b>")
				GLOB.hsboxspawn = TRUE
				return

		//
		// Admin: Toggle auto-close
		//
		if("hsbtac")
			. = TRUE
			if(!admin) return
			var/sbac = CONFIG_GET(flag/sandbox_autoclose)
			if(sbac)
				to_chat(world, "<span class='boldnotice'>Sandbox:</span> <b>\black [usr.key] has removed the object spawn limiter.</b>")
			else
				to_chat(world, "<span class='danger'>Sandbox:</span> <b>\black [usr.key] has added a limiter to object spawning.  The window will now auto-close after use.</b>")
			CONFIG_SET(flag/sandbox_autoclose, !sbac)
			return
		//
		// Spacesuit with full air jetpack set as internals
		//
		if("hsbsuit")
			. = TRUE
			var/mob/living/carbon/human/P = usr
			if(!istype(P)) return
			if(P.wear_suit)
				P.wear_suit.forceMove(P.drop_location())
				P.wear_suit.layer = initial(P.wear_suit.layer)
				P.wear_suit.plane = initial(P.wear_suit.plane)
				P.wear_suit = null
			P.wear_suit = new/obj/item/clothing/suit/space(P)
			P.wear_suit.layer = ABOVE_HUD_LAYER
			P.wear_suit.plane = ABOVE_HUD_PLANE
			P.update_inv_wear_suit()
			if(P.head)
				P.head.forceMove(P.drop_location())
				P.head.layer = initial(P.head.layer)
				P.head.plane = initial(P.head.plane)
				P.head = null
			P.head = new/obj/item/clothing/head/helmet/space(P)
			P.head.layer = ABOVE_HUD_LAYER
			P.head.plane = ABOVE_HUD_PLANE
			P.update_inv_head()
			if(P.wear_mask)
				P.wear_mask.forceMove(P.drop_location())
				P.wear_mask.layer = initial(P.wear_mask.layer)
				P.wear_mask.plane = initial(P.wear_mask.plane)
				P.wear_mask = null
			P.wear_mask = new/obj/item/clothing/mask/gas(P)
			P.wear_mask.layer = ABOVE_HUD_LAYER
			P.wear_mask.plane = ABOVE_HUD_PLANE
			P.update_inv_wear_mask()
			if(P.back)
				P.back.forceMove(P.drop_location())
				P.back.layer = initial(P.back.layer)
				P.back.plane = initial(P.back.plane)
				P.back = null
			P.back = new/obj/item/tank/jetpack/oxygen(P)
			P.back.layer = ABOVE_HUD_LAYER
			P.back.plane = ABOVE_HUD_PLANE
			P.update_inv_back()
			P.internal = P.back
			P.update_internals_hud_icon(1)

		if("hsbscrubber") // This is beyond its normal capability but this is sandbox and you spawned one, I assume you need it
			. = TRUE
			var/obj/hsb = new/obj/machinery/portable_atmospherics/scrubber{volume_rate=50*ONE_ATMOSPHERE;on=1}(usr.loc)
			hsb.update_icon() // hackish but it wasn't meant to be spawned I guess?

		//
		// Stacked Materials
		//

		if("hsbrglass")
			. = TRUE
			new/obj/item/stack/sheet/rglass{amount=50}(usr.loc)

		if("hsbiron")
			. = TRUE
			new/obj/item/stack/sheet/iron{amount=50}(usr.loc)

		if("hsbplasteel")
			. = TRUE
			new/obj/item/stack/sheet/plasteel{amount=50}(usr.loc)

		if("hsbglass")
			. = TRUE
			new/obj/item/stack/sheet/glass{amount=50}(usr.loc)

		if("hsbwood")
			. = TRUE
			new/obj/item/stack/sheet/mineral/wood{amount=50}(usr.loc)

		//
		// All access ID
		//
		if("hsbaaid")
			. = TRUE
			var/obj/item/card/id/gold/ID = new(usr.loc)
			ID.registered_name = usr.real_name
			ID.assignment = "Sandbox"
			ID.access = get_all_accesses()
			ID.update_label()

		//
		// RCD - starts with full clip
		// Spawn check due to grief potential (destroying floors, walls, etc)
		//
		if("hsbrcd")
			. = TRUE
			if(!GLOB.hsboxspawn) return

			new/obj/item/construction/rcd/combat(usr.loc)

		//
		// Object spawn window
		//

		// Clothing
		if("hsbcloth")
			. = TRUE
			if(!GLOB.hsboxspawn) return
			var/spawning_item = tgui_input_list(usr, "Pick a clothing item to spawn", "Clothing", clothitems)
			if(spawning_item)
				if(ispath(spawning_item))
					new spawning_item(usr.loc)
				else
					to_chat(usr, "Bad path: \"[spawning_item]\"")

		// Reagent containers
		if("hsbreag")
			. = TRUE
			if(!GLOB.hsboxspawn) return
			var/spawning_item = tgui_input_list(usr, "Pick a Reagent container to spawn", "Reagent Containers", reagentitems)
			if(spawning_item)
				if(ispath(spawning_item))
					new spawning_item(usr.loc)
				else
					to_chat(usr, "Bad path: \"[spawning_item]\"")

		// Other items
		if("hsbobj")
			. = TRUE
			if(!GLOB.hsboxspawn) return
			var/spawning_item = tgui_input_list(usr, "Pick an item to spawn", "Items", otheritems)
			if(spawning_item)
				if(ispath(spawning_item))
					new spawning_item(usr.loc)
				else
					to_chat(usr, "Bad path: \"[spawning_item]\"")
