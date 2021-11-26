// normal pipes break when coilgun projectiles go through them

/obj/structure/disposalholder/move(obj/structure/disposalholder/other)
	for(var/obj/item/projectile/hvp/H in other)
		var/obj/structure/disposalpipe/pipe = loc
		if(!pipe.coilgun)
			pipe.take_damage(200)
			playsound(src.loc, 'sound/effects/clang.ogg', 50, 0, 0)
	..()

