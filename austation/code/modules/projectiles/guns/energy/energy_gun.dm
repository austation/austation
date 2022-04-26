/obj/item/gun/energy/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/energycore))
		cell.charge = cell.maxcharge
		recharge_newshot()
		qdel(I)
