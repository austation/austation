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
	var/turf/terf = get_turf(src)
	terf.update_firelock_registration()

/obj/machinery/door/firedoor/afterShuttleMove(turf/oldT)
	var/turf/terf = get_turf(src)
	oldT.update_firelock_registration()
	terf.update_firelock_registration()
	. = ..()

/obj/machinery/door/firedoor/Moved(atom/OldLoc, Dir)
	. = ..()
	if(isopenturf(OldLoc))
		var/turf/open/terf = OldLoc
		terf.update_firelock_registration()
	var/turf/tarf = get_turf(src)
	tarf.update_firelock_registration()


/obj/machinery/door/firedoor/Destroy()
	var/turf/terf = get_turf(src)
	terf.update_firelock_registration()
	. = ..()

//these are hooked by auxtools
/turf/proc/register_firelocks()
/turf/proc/unregister_firelocks()

//updates registration status for firelocks in auxtools
/turf/proc/update_firelock_registration()
	if(SSair.thread_running())
		SSadjacent_air.firelock_queue[src] = 1
		return
	if(locate(/obj/machinery/door/firedoor) in src)
		register_firelocks()
	else
		unregister_firelocks()
