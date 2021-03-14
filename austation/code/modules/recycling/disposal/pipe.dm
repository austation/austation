/obj/structure/disposalpipe
	var/coilgun = FALSE // is this pipe part of a coilgun? Used for determining if a coilgun projectile is allowed inside it

/obj/structure/disposalpipe/expel(obj/structure/disposalholder/H, turf/T, direction, params)
	for(var/atom/movable/AM in H.contents)
		if(istype(AM, /obj/item/projectile/hvp))
			var/obj/item/projectile/hvp/speedy = AM
			if(speedy.velocity >= 1)
				speedy.launch(dir2angle(direction))
