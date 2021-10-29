
/datum/var/__auxtools_weakref_id

/obj/machinery/door/firedoor
	icon = 'austation/icons/obj/doors/doorfireglass.dmi'
	open_speed = 1

/obj/machinery/door/firedoor/border_only
	icon = 'austation/icons/obj/doors/edge_Doorfire.dmi'

/obj/machinery/door/firedoor/heavy
	icon = 'austation/icons/obj/doors/doorfire.dmi'

/obj/machinery/door/firedoor/window
	icon = 'austation/icons/obj/doors/doorfirewindow.dmi'

/obj/machinery/door/firedoor/Initialize()
	. = ..()
	SSair.firelocks += src
	SSair.firelocks_requires_updates = TRUE

/obj/machinery/door/firedoor/Destroy()
	SSair.firelocks -= src
	SSair.firelocks_requires_updates = TRUE
	. = ..()

/obj/machinery/door/firedoor/Moved(atom/OldLoc, Dir)
	. = ..()
	SSair.firelocks_requires_updates = TRUE

/obj/machinery/door/firedoor/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	. = ..()
	SSair.firelocks_requires_updates = TRUE

/obj/machinery/door/firedoor/emergency_pressure_stop(consider_timer = TRUE)
	if(density || operating || welded)
		return
	if(world.time >= emergency_close_timer || !consider_timer)
		emergency_pressure_close()

/obj/machinery/door/firedoor/proc/emergency_pressure_close()
	if(HAS_TRAIT(loc, TRAIT_FIREDOOR_STOP))
		return
	if(density)
		return
	if(operating || welded)
		return

	density = TRUE
	air_update_turf(1)

	operating = TRUE

	do_animate("closing")
	layer = closingLayer

	sleep(open_speed * 2)

	update_icon()
	if(visible && !glass)
		set_opacity(1)

	operating = FALSE

	update_freelook_sight()
	if(safe)
		CheckForMobs()
	else if(!(flags_1 & ON_BORDER_1))
		crush()
	latetoggle()

/proc/disable_airs_in_list(list/turfs)
