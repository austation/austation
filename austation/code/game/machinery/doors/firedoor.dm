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

/obj/machinery/door/firedoor/Destroy()
	. = ..()
	update_registration()

/obj/machinery/door/firedoor/power_change()
	. = ..()
	update_registration()

/obj/machinery/door/firedoor/obj_break(damage_flag)
	. = ..()
	update_registration()

//these are hooked by auxtools
/turf/proc/register_firelocks()
/turf/proc/unregister_firelocks()

//updates registration status for firelocks in auxtools
/obj/machinery/door/firedoor/proc/update_registration()
	var/turf/open/terf = get_turf(src)
	var/unregister = TRUE
	if(!istype(terf, /turf/open))
		return
	for(var/obj/machinery/door/firedoor/FD in terf)
		if(!((FD.stat & BROKEN) || (FD.stat & EMAGGED) || (FD.stat & NOPOWER)))
			unregister = FALSE
			break
	if(unregister)
		terf.unregister_firelocks()
	else
		terf.register_firelocks()
