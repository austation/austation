/datum/wires/apc/on_pulse(wire)
	var/obj/machinery/power/apc/AU_A = holder
	switch(wire)
		if(WIRE_POWER2)
			if(AU_A.operating == TRUE)
				AU_A.operating = FALSE
				AU_A.update()
			else
				AU_A.operating = TRUE
				AU_A.update()

			return
		else
			..()
