/obj/machinery/porta_turret/syndicate/pod/toolbox
	max_integrity = 100

/obj/machinery/porta_turret/syndicate/shuttle/Initialize(mapload)
	..()
	if(GLOB.master_mode == "siege")
		max_integrity = 2000
		obj_integrity = 2000
