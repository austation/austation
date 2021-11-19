
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

/obj/machinery/door/firedoor/proc/allow_hand_open(mob/user)
	var/area/A = get_area(src)
	if(A && A.fire)
		return FALSE
	return !is_holding_pressure()

/obj/machinery/door/firedoor/try_to_activate_door(obj/item/I, mob/user)
	return

/obj/machinery/door/firedoor/try_to_crowbar(obj/item/I, mob/user)
	if(welded || operating)
		return
	if(density)
		if(is_holding_pressure())
			// tell the user that this is a bad idea, and have a do_after as well
			to_chat(user, "<span class='warning'>As you begin crowbarring \the [src] a gush of air blows in your face... maybe you should reconsider?</span>")
			if(!do_after(user, 10, TRUE, src)) // give them a few seconds to reconsider their decision.
				return
			log_game("[key_name(user)] has opened a firelock with a pressure difference at [AREACOORD(loc)]")
			user.log_message("has opened a firelock with a pressure difference at [AREACOORD(loc)]", LOG_ATTACK)
			// since we have high-pressure-ness, close all other firedoors on the tile
			whack_a_mole()
		if(welded || operating || !density)
			return // in case things changed during our do_after
		emergency_close_timer = world.time + RECLOSE_DELAY // prevent it from instaclosing again if in space
		open()
	else
		close()

/obj/machinery/door/firedoor/border_only/allow_hand_open(mob/user)
	var/area/A = get_area(src)
	if((!A || !A.fire) && !is_holding_pressure())
		return TRUE
	whack_a_mole(TRUE) // WOOP WOOP SIDE EFFECTS
	var/turf/T = loc
	var/turf/T2 = get_step(T, dir)
	if(!T || !T2)
		return
	var/status1 = check_door_side(T)
	var/status2 = check_door_side(T2)
	if((status1 == 1 && status2 == -1) || (status1 == -1 && status2 == 1))
		to_chat(user, "<span class='warning'>Access denied. Try closing another firedoor to minimize decompression, or using a crowbar.</span>")
		return FALSE
	return TRUE

/proc/disable_airs_in_list(list/turfs)
