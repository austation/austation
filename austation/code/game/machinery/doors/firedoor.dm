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

/obj/machinery/door/firedoor/Destroy()
	SSair.firelocks -= src
	. = ..()

/turf/proc/ImmediateSetSleep(disable_adjacent = TRUE)
	if(SSair.thread_running())
		SSadjacent_air.sleep_queue[src] = 1
		return
	set_sleeping(TRUE)

/turf/proc/ImmediateDisableAdjacency(disable_adjacent = TRUE)
	if(SSair.thread_running())
		SSadjacent_air.disable_queue[src] = 1
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
