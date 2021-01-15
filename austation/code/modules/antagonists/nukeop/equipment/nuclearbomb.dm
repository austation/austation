/obj/item/disk/nuclear
	var/process_tick = 0

/obj/item/disk/nuclear/process()
	++process_tick
	var/turf/newturf = get_turf(src)
	if(newturf && lastlocation == newturf)
		// How comfy is disky?
		var/disk_comfort_level = 0
		// Checking for items that make disky comfy
		for(var/obj/comfort_item in loc)
			if(istype(comfort_item, /obj/item/bedsheet) || istype(comfort_item, /obj/structure/bed))
				disk_comfort_level++
		if(disk_comfort_level >= 2) //Sleep tight, disky.
			if((process_tick % 30) == 0)
				visible_message("<span class='notice'>[src] sleeps soundly. Sleep tight, disky.</span>")
	.=..()
