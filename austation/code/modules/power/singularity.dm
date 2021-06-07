/obj/singularity/hvp_act(obj/item/projectile/hvp/PJ)
	if(PJ.special & HVP_BLUESPACE)
		energy -= PJ.momentum
		qdel(PJ)
		return
	if(PJ.velocity >= 1000)
		consumedSupermatter = TRUE
	energy += PJ.momentum
	qdel(PJ)
