/obj/structure/marker_beacon/Initialize(mapload, set_color)
	..()
	GLOB.total_beacons++

/obj/structure/marker_beacon/Destroy()
	..()
	GLOB.total_beacons--

