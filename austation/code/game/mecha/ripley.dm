/obj/mecha/working/ripley/collect_ore()
	..()  //  this overload is almost identical to the parent, but it MUST check for and recreate all of the local vars or it wont work
	if(locate(/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp) in equipment)
		var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in cargo
		if(ore_box)
			for(var/obj/item/stack/ore/ore in range(1, src))
				if(ore.Adjacent(src) || ore.loc == loc) // Removed the necessity for the ores to be in front of the mech.   This line checks if ores are in range to be picked up (previously they had to be in front as well)
					ore.forceMove(ore_box)
