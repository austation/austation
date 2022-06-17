// normal pipes break when coilgun projectiles go through them

/obj/structure/disposalholder/try_expel(datum/move_loop/source, succeed, visual_delay)
	..()
	if(!current_pipe)
		return;
	var/obj/structure/disposalpipe/pipe = loc
	for(var/obj/item/projectile/hvp/H in src)
		if(!pipe.coilgun)
			pipe.take_damage(200)
			playsound(src.loc, 'sound/effects/clang.ogg', 50, 0, 0)

