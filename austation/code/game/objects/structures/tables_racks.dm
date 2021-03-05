/*
 * Plasmaglass tables
 */
/obj/structure/table/plasmaglass
	name = "plasmaglass table"
	desc = "A glasstable, but it's pink and more sturdy. What will Nanotrasen design next with plasma?"
	icon = 'austation/icons/obj/smooth_structures/plasmaglass_table.dmi'
	icon_state = "plasmaglass_table"
	climbable = TRUE
	buildstack = /obj/item/stack/sheet/plasmaglass
	canSmoothWith = null
	max_integrity = 270
	resistance_flags = ACID_PROOF
	armor = list("melee" = 10, "bullet" = 5, "laser" = 0, "energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 80, "acid" = 100)
	var/list/debris = list()

/obj/structure/table/plasmaglass/New()
	. = ..()
	debris += new frame
	debris += new /obj/item/shard/plasma

/obj/structure/table/plasmaglass/Destroy()
	QDEL_LIST(debris)
	. = ..()

/obj/structure/table/plasmaglass/proc/check_break(mob/living/M)
	return

/obj/structure/table/plasmaglass/deconstruct(disassembled = TRUE, wrench_disassembly = 0)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(disassembled)
			..()
			return
		else
			var/turf/T = get_turf(src)
			playsound(T, "shatter", 50, 1)
			for(var/X in debris)
				var/atom/movable/AM = X
				AM.forceMove(T)
				debris -= AM
	qdel(src)

/obj/structure/table/plasmaglass/narsie_act()
	color = NARSIE_WINDOW_COLOUR
	for(var/obj/item/shard/S in debris)
		S.color = NARSIE_WINDOW_COLOUR

// Table Banging
/obj/structure/table/AltClick(mob/user)
	// Using click cooldowns for attacks and shit here to prevent spam
	if(user.next_move > world.time)
		return
	user.changeNext_move(CLICK_CD_MELEE)

	if(user && Adjacent(user) && !user.incapacitated())
		if(istype(user) && user.a_intent == INTENT_HARM)
			user.visible_message("<span class='warning'>[user] slams [user.p_their()] palms down on [src].</span>", "<span class='warning'>You slam your palms down on \the [src].</span>")
			playsound(src, 'austation/sound/misc/tableslap.ogg', 50, 1)
			if(prob(5) && istype(src, /obj/structure/table/glass) && isliving(user))
				var/mob/living/L = user
				var/obj/structure/table/glass/G = src
				G.table_shatter(L)
		else
			user.visible_message("<span class='notice'>[user] slaps [user.p_their()] hands on [src].</span>", "<span class='notice'>You slap your hands on \the [src].</span>")
			playsound(src, 'sound/weapons/tap.ogg', 50, 1)
		user.do_attack_animation(src)
		return TRUE
