/datum/wires/apc/on_pulse(wire)
	var/obj/machinery/power/apc/A = holder
	switch(wire)
		if(WIRE_POWER1) // Short for a long while.
			if(!A.shorted)
				A.shorted = TRUE
				addtimer(CALLBACK(A, /obj/machinery/power/apc.proc/reset, wire), 1200)
		if(WIRE_POWER2)
			if(!A.shorted)
				if(A.operating == TRUE)
					A.operating = FALSE
					A.update()
				else
					A.operating = TRUE
					A.update()
		if(WIRE_IDSCAN) // Unlock for a little while.
			A.locked = FALSE
			addtimer(CALLBACK(A, /obj/machinery/power/apc.proc/reset, wire), 300)
		if(WIRE_AI) // Disable AI control for a very short time.
			if(!A.aidisabled)
				A.aidisabled = TRUE
				addtimer(CALLBACK(A, /obj/machinery/power/apc.proc/reset, wire), 10)
