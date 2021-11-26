
// very hacky but this means we don't need to override every disposalpipe segment, even if we have to use funky typepaths
/obj/structure/disposalpipe/segment/coilgun
	coilgun = TRUE
	icon = 'austation/icons/obj/atmospherics/pipes/disposal.dmi'
	var/max_corner_velocity = 30 // maximum projectile velocity on corner pipes before they'll start breaking the pipes

// corner pipes take damage when the projectile is moving too fast
/obj/structure/disposalpipe/segment/coilgun/transfer(obj/structure/disposalholder/H)
	if(dpdir & dir|turn(dir, 180))
		return ..()
	for(var/obj/item/projectile/hvp/PJ in H.contents)
		if(PJ.velocity > max_corner_velocity)
			take_damage(max(PJ.velocity - max_corner_velocity, 10))
			if(QDELETED(src))
				return
	return ..()

/obj/structure/disposalpipe/broken/coilgun
	coilgun = TRUE
	icon = 'austation/icons/obj/atmospherics/pipes/disposal.dmi'
