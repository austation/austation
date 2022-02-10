/obj/machinery/atmospherics/proc/change_piping_layer_multitool(mob/user, obj/item/I)
	if(I.tool_behaviour == TOOL_MULTITOOL)
		if(!panel_open)
			return 0
		switch(piping_layer)
			if(2)
				setPipingLayer(3)
				to_chat(user, "<span class='notice'>You change the piping layer of [src] to 3.</span>")
			if(3)
				setPipingLayer(1)
				to_chat(user, "<span class='notice'>You change the piping layer of [src] to 1.</span>")
			if(1)
				setPipingLayer(2)
				to_chat(user, "<span class='notice'>You change the piping layer of [src] to 2.</span>")
		return 1
