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
	update_registration()

/obj/machinery/door/firedoor/afterShuttleMove(turf/oldT)
	if(!locate(/obj/machinery/door/firedoor) in oldT)
		oldT.unregister_firelocks()
	update_registration()
	. = ..()

/obj/machinery/door/firedoor/Moved(atom/OldLoc, Dir)
	. = ..()
	if(isopenturf(OldLoc))
		var/turf/open/terf = OldLoc
		if(locate(/obj/machinery/door/firedoor) in terf)
			terf.register_firelocks()
		else
			terf.unregister_firelocks()
	update_registration()


/obj/machinery/door/firedoor/Destroy()
	update_registration()
	. = ..()

//these are hooked by auxtools
/turf/proc/register_firelocks()
/turf/proc/unregister_firelocks()

//updates registration status for firelocks in auxtools
/obj/machinery/door/firedoor/proc/update_registration()
	var/turf/open/terf = get_turf(src)
	if(locate(/obj/machinery/door/firedoor) in terf)
		terf.register_firelocks()
	else
		terf.unregister_firelocks()
