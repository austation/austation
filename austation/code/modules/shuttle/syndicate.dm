/obj/machinery/computer/shuttle_flight/syndicate/allowed(mob/M)
	if(GLOB.master_mode == "siege")
		to_chat(M, "There is no recall or intervention in this place; there is no escape.")
		return FALSE
	..()
