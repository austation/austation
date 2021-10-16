
/atom/var/__auxtools_weakref_id

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
	set waitfor = 0
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
	rebuild_adjacency_NOW()

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

/turf/proc/ImmediateDisableAdjacency(disable_adjacent = TRUE)
	if(SSair.thread_running())
		SSadjacent_air.disable_queue[src] = disable_adjacent
		return
	if(disable_adjacent)
		for(var/direction in GLOB.cardinals_multiz)
			var/turf/T = get_step_multiz(src, direction)
			if(!istype(T))
				continue
			if (T.atmos_adjacent_turfs)
				T.atmos_adjacent_turfs -= src
			UNSETEMPTY(T.atmos_adjacent_turfs)
			T.__update_auxtools_turf_adjacency_info(isspaceturf(T.get_z_base_turf()), -1)
	LAZYCLEARLIST(atmos_adjacent_turfs)
	__update_auxtools_turf_adjacency_info(isspaceturf(get_z_base_turf()))

/turf/proc/set_sleeping_NOW(should_sleep)

/atom/proc/rebuild_adjacency_NOW()
	if(!isturf(loc))
		return
	var/turf/T = get_turf(loc)
	T.rebuild_adjacency_NOW()

/turf/rebuild_adjacency_NOW()
	var/canpass = CANATMOSPASS(src, src)
	var/canvpass = CANVERTICALATMOSPASS(src, src)
	for(var/direction in GLOB.cardinals_multiz)
		var/turf/T = get_step_multiz(src, direction)
		if(!istype(T))
			continue
		var/opp_dir = REVERSE_DIR(direction)
		if(isopenturf(T) && !(blocks_air || T.blocks_air) && ((direction & (UP|DOWN))? (canvpass && CANVERTICALATMOSPASS(T, src)) : (canpass && CANATMOSPASS(T, src))) )
			LAZYINITLIST(atmos_adjacent_turfs)
			LAZYINITLIST(T.atmos_adjacent_turfs)
			atmos_adjacent_turfs[T] = direction
			T.atmos_adjacent_turfs[src] = opp_dir
		else
			if (atmos_adjacent_turfs)
				atmos_adjacent_turfs -= T
			if (T.atmos_adjacent_turfs)
				T.atmos_adjacent_turfs -= src
			UNSETEMPTY(T.atmos_adjacent_turfs)
			T.set_sleeping(T.blocks_air)
		T.__immmediately_update_auxtools_turf_adjacency_info(isspaceturf(T.get_z_base_turf()), -1)
	UNSETEMPTY(atmos_adjacent_turfs)
	src.atmos_adjacent_turfs = atmos_adjacent_turfs
	set_sleeping(blocks_air)
	__immmediately_update_auxtools_turf_adjacency_info(isspaceturf(get_z_base_turf()))

/turf/proc/__immmediately_update_auxtools_turf_adjacency_info()
