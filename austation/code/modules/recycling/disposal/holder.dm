// normal pipes break when coilgun projectiles go through them
/obj/structure/disposalholder/move()
	..()
	var/obj/structure/disposalpipe/pipe = loc
	if(istype(AM, /obj/item/projectile/coilshot) && !pipe.coilgun)
		pipe.take_damage(200)
		playsound(src.loc, 'sound/effects/clang.ogg', 50, 0, 0)
