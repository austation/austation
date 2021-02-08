/obj/item/stack/marker_beacon/attack_self(mob/user)
	if(GLOB.total_beacons >= GLOB.max_beacons) //check that  there are not 100 in the world already
		to_chat(user, "<span class='warning'>You can not place another beacon!</span>")
		return
	return ..()

/obj/structure/marker_beacon/Initialize(mapload, set_color)
	..()
	GLOB.total_beacons++

/obj/structure/marker_beacon/Destroy()
	..()
	GLOB.total_beacons--
