/obj/structure/disposalpipe
	var/coilgun = FALSE // is this pipe part of a coilgun? Used for determining if a coilgun projectile is allowed inside it

// override for the normal expel proc, allows launching of coilgun projectiles via disposal tube exit
/obj/structure/disposalpipe/expel(obj/structure/disposalholder/H, turf/T, direction, params) // atom/target,
	var/turf/target
	var/eject_range = 5
	var/turf/open/floor/floorturf

	if(isfloorturf(T)) //intact floor, pop the tile
		floorturf = T
		if(floorturf.floor_tile)
			new floorturf.floor_tile(T)
		floorturf.make_plating()

	if(direction)		// direction is specified
		if(isspaceturf(T)) // if ended in space, then range is unlimited
			target = get_edge_target_turf(T, direction)
		else						// otherwise limit to 10 tiles
			target = get_ranged_target_turf(T, direction, 10)

		eject_range = 10

	else if(floorturf)
		target = get_offset_target_turf(T, rand(5)-rand(5), rand(5)-rand(5))

	playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
	for(var/A in H)
		var/atom/movable/AM = A
		AM.forceMove(get_turf(src))
		if(istype(AM, /obj/effect/hvp))
			var/obj/effect/hvp/speedy = AM
			if(speedy.p_speed >= 1)
				speedy.dir = dir
				speedy.launch()
		else
			AM.pipe_eject(direction)
			if(target)
				AM.throw_at(target, eject_range, 1)
	H.vent_gas(T)
	qdel(H)
