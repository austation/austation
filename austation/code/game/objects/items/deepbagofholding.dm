//  Deep bag of holding. Still unsure as to how it will be made.

/obj/item/deepbackpack
	name = "deep bag of holding"
	desc = "A bluespace bag, with a pocket dimension large enough to live in. It's huge!"
	// Alternative descriptions: "Enslaved Tardis", "It's bigger on the inside", "Mobile ERP den", "Mobile dormitory", "Mini drug lab", e.t.c
	icon = 'austation/icons/obj/deepbagofholding.dmi'
	icon_state = "holdingpack"
	item_state = "holdingpack"
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	resistance_flags = NONE
	max_integrity = 300

	var/datum/map_template/deepbluespace/linkedDimTemp
	var/datum/turf_reservation/linkedDim

	var/turf/open/entry

/obj/item/deepbackpack/Initialize()
	. = ..()

	// Sets up the minidimension and spawns it
	linkedDimTemp = new()
	linkedDim = SSmapping.RequestBlockReservation(linkedDimTemp.width, linkedDimTemp.height)
	linkedDimTemp.load(locate(linkedDim.bottom_left_coords[1], linkedDim.bottom_left_coords[2], linkedDim.bottom_left_coords[3]))
	var/area/deepbluespace/currentArea = get_area(locate(linkedDim.bottom_left_coords[1], linkedDim.bottom_left_coords[2], linkedDim.bottom_left_coords[3]))

	// Links the minidimension to the bag and vis-versa
	for(var/turf/open/indestructible/deepBluespaceExit/exit in currentArea)
		exit.parent = src
	entry =	locate(linkedDim.bottom_left_coords[1] + linkedDimTemp.landingZoneRelativeX, \
				  linkedDim.bottom_left_coords[2] + linkedDimTemp.landingZoneRelativeY, \
		   		  linkedDim.bottom_left_coords[3])

	// Gonna leave this here for a latter date. This is for atmos interactions, but it doesn't work at the moment, so for now it's depricated.
	// START_PROCESSING(SSobj, src)

/obj/item/deepbackpack/Destroy()
	ejectContents()
	do_sparks(6, 0, src)
	qdel(linkedDim)
	qdel(linkedDimTemp)
	return ..()

// Called when we attack the bag with an item
/obj/item/deepbackpack/attackby(obj/item/I, mob/user, params)

	// Checks if this item has no drop, so you can't cheese it off your hand
	if(HAS_TRAIT(I, TRAIT_NODROP))
		to_chat(user, "<span class='warning'>\the [I] is stuck to your hand, you can't put it in \the [src]!</span>")
		return FALSE

	// Tells everyone about it
	for(var/mob/viewing in viewers(user, null))
		if(user == viewing)
			to_chat(user, "<span class='notice'>You put [I] into [src].</span>")
		else if(in_range(user, viewing)) //If someone is standing close enough, they can tell what it is
			viewing.show_message("<span class='notice'>[user] puts [I] into [src].</span>", 1)
		else if(I && I.w_class >= 3) //Otherwise they can only see large or normal items from a distance
			viewing.show_message("<span class='notice'>[user] puts [I] into [src].</span>", 1)

	// Inserting the item
	insert(I, user)

// Called when we attack something with the bag
/obj/item/deepbackpack/afterattack(atom/movable/A, mob/user, proximity)

	// If we are not next to the item, or the atom isn't a movable type, then let's forget this ever happened
	if(!(proximity) || !isatom(A))
		return

	if(!(A.can_be_z_moved) || A.anchored)
		return

	// If this is a mob, we'll have a progress bar to make sure you're not spamming this everywhere and stuffing them into the bag
	if (ismob(A))
		var/mob/M = A
		user.visible_message("<span class='warning'>[user] tries to stuff [M] into [src].</span>", \
				 	 		 "<span class='warning'>You try to stuff [M] into [src].</span>")
		if(!do_mob(user, M)) // If they don't succeed, fuck 'em and return from this proc
			return
		user.visible_message("<span class='notice'>[user] stuffs [M] into [src].</span>", \
				 	 		 "<span class='notice'>You stuff [M] into [src].</span>")

		// Oh, and if they're holding the bag, drop it. Because otherwise you essentially trap yoruself
		if(src in M.contents)
			src.forceMove(get_turf(M))

	// Inserting the item
	insert(A, user)

// Use this if you just want to put an item into the bag. This is the mechanical part.
/obj/item/deepbackpack/proc/insert(atom/movable/A, mob/user)
	if (safety_check(A, user))
		return

	playsound(src, "rustle", 50, 1, -5)

	if(ismob(user))
		add_fingerprint(user)

	 // If this is in a mobs inventory, drop it.
	var/mob/M
	var/obj/item/I

	if(ismob(A.loc) && isitem(A))
		M = A.loc
		I = A

	// Move it to the dimension
	A.forceMove(entry)

	if(ismob(M) && isitem(A))
		I.dropped(M)

/obj/item/deepbackpack/proc/safety_check(atom/movable/A, mob/living/user)
	var/list/obj/item/matching = typecache_filter_list(A.GetAllContents(), typecacheof(/obj/item/storage/backpack/holding))
	matching += typecache_filter_list(A.GetAllContents(), typecacheof(/obj/item/deepbackpack))
	matching -= src
	if(istype(A, /obj/item/storage/backpack/holding) || istype(A, /obj/item/deepbackpack) || matching.len)
		var/safety = ""
		if(matching.len)
			safety = alert(user, "You are trying to insert [A.name], which contains [matching[1].name]. This can have dire consequences for the station and it's crew.", "Put in [A.name]?", "Abort", "Proceed")
		else
			safety = alert(user, "You are trying to insert [A.name]. This can have dire consequences for the station and it's crew.", "Put in [A.name]?", "Abort", "Proceed")
		if(safety != "Proceed")
			return TRUE
		safety = alert(user, "Are you absolutely sure? Be absolutely certain you want to do this.", "Put in [A.name]?", "Abort", "Proceed")
		if(safety != "Proceed")
			return TRUE
		safety = alert(user, "Last warning. Are you positive there is no other option for you?", "Put in [A.name]?", "Abort", "Proceed")
		if(safety != "Proceed" || QDELETED(A) || QDELETED(src) || QDELETED(user) || !user.canUseTopic(A, BE_CLOSE, iscarbon(user))) // need to be holding the bag you're "inserting"
			return TRUE
		var/turf/loccheck = get_turf(A)
		if(is_reebe(loccheck.z))
			user.visible_message("<span class='warning'>An unseen force knocks [user] to the ground!</span>", "<span class='big_brass'>\"I think not!\"</span>")
			user.Paralyze(60)
			return TRUE
		failure(A, user)
		return TRUE
	return FALSE

/obj/item/deepbackpack/proc/failure(atom/movable/A, mob/user, failure_state = 0)
	if(failure_state == 0)
		failure_state = rand(1,4)

	message_admins("[ADMIN_LOOKUPFLW(user)] detonated a DEEP bag of holding at [ADMIN_VERBOSEJMP(loc)]. Failure state: [failure_state]")
	log_game("[key_name(user)] detonated a DEEP bag of holding at [loc_name(loc)]. Failure state: [failure_state]")

	switch (failure_state)
		if (1) // Nothing happens
			user.visible_message("<span class='warning'>[user] inserts [A.name] into [src], causing it to fizzle out of existence!</span>", "<span class='warning'>[src] fizzles out of existence! What a waste!</span>")
		if (2) // The user is destroyed with the bags
			user.visible_message("<span class='danger'>[user] inserts [A.name] into [src], causing them to fizzle out of existence!</span>", "<span class='userdanger'>You feel your body being dragged out of space and time!</span>")
			user.dust(force = TRUE)
		if (3) // Maxcap.exe
			user.visible_message("<span class='danger'>[user] inserts [A.name] into [src], causing them to violently explode!</span>", "<span class='userdanger'>[src] explodes violently!</span>")
			playsound(get_turf(src), 'sound/effects/supermatter.ogg', 50, 1) // BZZZZT!!
			explosion(src, 3, 7, 12, 0)
		if (4) // Lord singulo
			user.visible_message("<span class='danger'>[user] inserts [A.name] into [src], causing space time to collapse!</span>", "<span class='userdanger'>[src] collapses in on itself!</span>")
			playsound(get_turf(src), 'sound/effects/supermatter.ogg', 50, 1) // BZZZZT!!
			new /obj/singularity(loc)

	qdel(A) // Hide the evidence
	qdel(src)

// Ejects everyone in the room
/obj/item/deepbackpack/proc/ejectContents()
	for(var/i=0, i<linkedDimTemp.width, i++)
		for(var/j=0, j<linkedDimTemp.height, j++)
			for(var/atom/movable/A in locate(linkedDim.bottom_left_coords[1] + i, linkedDim.bottom_left_coords[2] + j, linkedDim.bottom_left_coords[3]))
				if(ismob(A)) // Everything that isn't a mob or item is lost!
					A.forceMove(src.loc)
					var/mob/M = A
					if(M.mind)
						to_chat(M, "<span class='warning'>As reality itself seems torn apart you are suddenly ejected from the pocket dimension!</span>")
				if(isitem(A))
					A.forceMove(src.loc)

// Adds extra code to the "shock act" that checks if there's a bag of holding with a bluespace anomally core in it, and if so, turn it into a deep BoH
/mob/living/carbon/electrocute_act(shock_damage, source, siemens_coeff = 1, safety = 0, tesla_shock = 0, illusion = 0, stun = TRUE)
	. = ..()
	if (illusion)
		return .
	if (shock_damage >= 100) // oof
		var/list/obj/item/bags = typecache_filter_list(src.GetAllContents(), typecacheof(/obj/item/storage/backpack/holding))
		for (var/obj/item/storage/backpack/holding/I in bags) // Check each bag for a core
			var/list/obj/item/cores = typecache_filter_list(I.GetAllContents(), typecacheof(/obj/item/assembly/signaler/anomaly/bluespace))
			if(cores.len) // If there are cores
				src.visible_message("<span class='danger'>[I] reacts with [cores[1]], collapsing into a deep bag of holding!</span>", "<span class='danger'>[I] reacts with [cores[1]], collapsing into collapsing into a deep bag of holding!</span>")

				I.emptyStorage() // Dump the contents so you don't loose your shit

				qdel(I) // Delete the old bag
				qdel(cores[1]) // Delete the core used in the reaction

				new /obj/item/deepbackpack(get_turf(src)) // Create the new backpack
				playsound(get_turf(src), 'sound/effects/supermatter.ogg', 50, 1) // BZZZZT!!

				message_admins("[ADMIN_LOOKUPFLW(src)] created a deep bag of holding at [ADMIN_VERBOSEJMP(loc)].")
				log_game("[key_name(src)] created a deep bag of holding at [loc_name(loc)].")
	return .

// Extra code to prevent you from putting a DBoH in a BoH, letting our code do the work
/datum/component/storage/concrete/bluespace/bag_of_holding/handle_item_insertion(obj/item/W, prevent_warning = FALSE, mob/living/user)
	if(istype(W, /obj/item/deepbackpack))
		W.attackby(src.parent, user)
		return
	return ..()

/turf/open/indestructible/deepBluespaceExit
	name = "Bluespace Tunnel"
	icon_state = "plating"
	explosion_block = INFINITY
	blocks_air = TRUE
	opacity = TRUE
	var/parent

/turf/open/indestructible/deepBluespaceExit/Entered(atom/movable/A)
	. = ..()
	A.forceMove(get_turf(parent))

/datum/map_template/deepbluespace
	name = "Deep Bluespace"
	mappath = '_maps/templates/deepbluespace.dmm'
	var/landingZoneRelativeX = 4
	var/landingZoneRelativeY = 7

/area/deepbluespace
	name = "Deep Bluespace"
	icon_state = "hilbertshotel"
	requires_power = TRUE
	has_gravity = TRUE
	teleport_restriction = TELEPORT_ALLOW_NONE
	area_flags = HIDDEN_AREA
