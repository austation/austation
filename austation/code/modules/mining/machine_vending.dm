/obj/machinery/mineral/equipment_vendor
	var/static/list/ignore_list = list(
		/mob/living/simple_animal/hostile/mining_drone,
		/obj/item/slimepotion/slime/sentience/mining
		)  // a list of names that we may find among the prize_list elements

/obj/machinery/mineral/equipment_vendor/Initialize()
	for(var/datum/data/mining_equipment/I in prize_list)  // prize_list is populated by elements, all of the exact same class; we can only tell them apart by checking their name
		if (I.equipment_path in ignore_list)  // ignore_list strings should match a few of the mining_equipment.equiment_name
			prize_list.Remove(I)
	..()  // must remove the elements BEFORE the equimpent vendor builds its contents
