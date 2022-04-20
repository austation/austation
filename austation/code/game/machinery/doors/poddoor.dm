/obj/machinery/door/poddoor/Initialize(mapload)
	..()
	if(id == "smindicate")//syndicate shuttle door id
		new /obj/structure/trap/ctf/siegebarrier(src)
		qdel(src)
