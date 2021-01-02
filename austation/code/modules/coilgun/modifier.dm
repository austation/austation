/obj/structure/disposalpipe/coilgun/modifier
	name = "coilgun projectile modifier"
	desc = "A machine made to morph the propeties of inserted items into moving projectiles, warrenty void if exposed to explosives"
	coilgun = TRUE

/obj/structure/disposalpipe/coilgun/modifier/transfer(obj/structure/disposalholder/H)
	if(H.contents.len)
		for(var/atom/movable/AM in H.contents)
			if(istype(AM, /obj/effect/hvp))
				combine(AM)
			else
				visible_message("<span class='warning'>\The [src]'s safety mechanism engages, ejecting \the [AM] through the maintenance hatch!</span>")
				AM.forceMove(get_turf(src))
	else
		qdel(H)
	return ..()

/obj/structure/disposalpipe/coilgun/modifier/combine(obj/effect/hvp/PJ)
	if(PJ.special.len <= 2)

	else
		visible_message("<span class='warning'> The [AM] can't be modified any further!")
