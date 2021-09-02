/obj/machinery/vendor/mining
	var/static/list/ignore_list = list(
		/mob/living/simple_animal/hostile/mining_drone,
		/obj/item/slimepotion/slime/sentience/mining
		)  //  a list of paths that we may find among the prize_list elements

/obj/machinery/vendor/mining/Initialize()
	for(var/datum/data/vendor_equipment/I in prize_list)  //  prize_list is populated by elements, all of the exact same class; we can only tell them apart by checking their equimpent_path
		if (I.equipment_path in ignore_list)
			prize_list.Remove(I)
	..()  //  must remove the elements BEFORE the equimpent vendor builds its contents
