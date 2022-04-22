/obj/machinery/computer/shuttle_flight/syndicate/ui_interact(mob/user, datum/tgui/ui)
	var/turf/current_turf = get_turf(src)
	var/z_level = current_turf.z
	message_admins("A: [z_level]")
	if(GLOB.master_mode == "siege")
		to_chat(M, "There is no recall or intervention in this place; there is no escape.")
		return
	..()
