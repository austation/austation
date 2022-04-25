/obj/machinery/computer/shuttle_flight/syndicate/ui_interact(mob/user, datum/tgui/ui)
	if(!user.client?.holder)
		var/turf/current_turf = get_turf(src)
		var/z_level = current_turf.z
		if(GLOB.master_mode == "siege" && z_level == 1)
			to_chat(user, "There is no recall or intervention in this place; there is no escape.")
			return
	..()
