// normal pipes break when coilgun projectiles go through them
/*
/obj/structure/disposalholder/move(obj/structure/disposalholder/other)
	for(var/A in other)
		var/atom/movable/AM = A
		var/obj/structure/disposalpipe/pipe = loc
		if(istype(AM, /obj/item/projectile/hvp) && !pipe.coilgun)
			pipe.take_damage(200)
			playsound(src.loc, 'sound/effects/clang.ogg', 50, 0, 0)
	..()
*/
