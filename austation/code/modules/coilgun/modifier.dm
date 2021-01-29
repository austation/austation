#define MIN_SPEED 1000


/obj/structure/disposalpipe/coilgun/modifier
	name = "coilgun kinetic infuser"
	desc = "A heavy duty machine capable of kinetically infusing two different objects together at high speeds"
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

/obj/structure/disposalpipe/coilgun/modifier/proc/combine(obj/effect/hvp/PJ)
	if(!LAZYLEN(contents))
		return
	for(var/obj/O in contents)
		if(contents.len > 1)
			O.forceMove(get_turf(src))
			continue
		var/req_speed = max(100 * PJ.spec_amt * 10, MIN_SPEED)
		if(PJ.p_speed < req_speed)
			continue
		if(PJ.apply_special(O))
			PJ.p_speed -= req_speed
			PJ.spec_amt++
			O.loc = PJ

#undef MIN_SPEED
