/obj/structure/cable/Initialize(mapload, param_color)
	. = ..()
	if(param_color)
		if(d1)
			update_stored(2,cable_color)
		else
			update_stored(1,cable_color)