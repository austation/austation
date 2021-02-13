/obj/machinery/mineral/equipment_vendor
	var/list/ignore_list = list(
		"Minebot Upgrade: A.I.",
		"Mining Bot Companion"
	)

/obj/machinery/mineral/equipment_vendor/Initialize()
	..()
	for(var/datum/data/mining_equipment/I in prize_list)
		if (I.name in ignore_list)
			prize_list.Cut(I)
