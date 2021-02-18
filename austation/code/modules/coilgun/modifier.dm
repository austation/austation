// Min speed required to merge an object into the projectile
#define MIN_SPEED 1000

/obj/structure/disposalpipe/coilgun/modifier
	name = "coilgun kinetic infuser"
	desc = "A heavy duty machine capable of kinetically infusing two different objects together at high speeds"
	coilgun = TRUE

/obj/structure/disposalpipe/coilgun/modifier/transfer(obj/structure/disposalholder/H)
	if(H.contents.len)
		for(var/atom/movable/AM in H.contents)
			if(istype(AM, /obj/effect/hvp))
				var/obj/effect/hvp/PJ = AM
				combine(PJ)
			else
				visible_message("<span class='warning'>\The [src]'s safety mechanism engages, ejecting \the [AM] through the maintenance hatch!</span>")
				AM.forceMove(get_turf(src))
	else
		qdel(H)
	return ..()

/obj/structure/disposalpipe/coilgun/modifier/proc/combine(obj/effect/hvp/PJ)
	if(!LAZYLEN(contents)) // If we have no object to combine the projectile with, return
		return
	for(var/obj/O in contents)
		if(contents.len > 1) // eject objects inside of us until there's only one, if there were somehow multiple
			O.forceMove(get_turf(src))
			continue
		var/req_speed = max(100 * PJ.w_class * 1.5, MIN_SPEED)
		if(PJ.p_speed < req_speed)
			continue
		if(PJ.apply_special(O))
			PJ.spec_amt++
		playsound(src, 'sound/effects/bang.ogg', 50, 0, 0)
		PJ.p_speed -= req_speed / 2
		PJ.overlay_atom(O, rotation = TRUE)
		if(isitem(O))
			var/item/I = O
			PJ.mass += I.w_class
		else
			PJ.mass += 1
		O.loc = PJ
		break


#undef MIN_SPEED
