/obj/machinery/porta_turret/syndicate/pod/toolbox
	max_integrity = 100

/obj/machinery/porta_turret/syndicate/pod/toolbox/siege
	var/obj/item/syndPDA/parent_PDA
	faction = list(ROLE_SYNDICATE)
	shot_delay = 1
	scan_range = 9
	stun_projectile = /obj/item/projectile/bullet/p50/penetrator/shuttle
	lethal_projectile = /obj/item/projectile/bullet/p50/penetrator/shuttle

/obj/machinery/porta_turret/syndicate/pod/toolbox/siege/Destroy()
	parent_PDA.turret = FALSE
	. = ..()

/obj/machinery/porta_turret/syndicate/pod/toolbox/siege/attackby(obj/item/I, mob/living/user, params)
	..()
	if(user.a_intent == INTENT_HELP && (ROLE_SYNDICATE in user.faction))
		if(I.tool_behaviour == TOOL_WRENCH)
			obj_integrity = max_integrity
			playsound(src, "sound/items/drill_use.ogg", 80, TRUE, -1)
		else if(I.tool_behaviour == TOOL_CROWBAR)
			var/obj/item/storage/toolbox/emergency/turret/siege/a = new /obj/item/storage/toolbox/emergency/turret/siege(get_turf(src))
			a.parent_PDA = parent_PDA
			qdel(src)
			parent_PDA.turret = TRUE

/obj/machinery/porta_turret/syndicate/shuttle/Initialize(mapload)
	..()
	if(GLOB.master_mode == "siege")
		max_integrity = 2000
		obj_integrity = 2000
