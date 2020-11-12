/obj/effect/coilshot
	name = "coilgun projectile"
	desc = "oopsy woopsy, if you can read this, coder has messed up."
	icon = 'icons/obj/objects.dmi'
	icon_state = "immrod"
	throwforce = 5
	move_force = INFINITY
	move_resist = INFINITY
	pull_force = INFINITY
	density = TRUE
	anchored = TRUE
	var/heat_capacity = 80
	var/mass = 0
	var/special = "none" //special propeties
	var/p_heat = 0 //how hot this projectile is
	var/p_speed = 0 //how fast the projectile will exit the barrel
	var/charged = FALSE //has the projectile been overcharged already
	var/momentum = 0

/obj/effect/coilshot/launch()
	addtimer(CALLBACK(src, .proc/move), max(1, 1 / (p_speed / 100)) //projectile can't go any slower than 1

/obj/effect/coilshot/Bump(atom/A)
	if(A)
		if(istype(loc, /turf/closed/wall))
			var/turf/closed/wall/W = loc
			if(momentum >= 100) // uses 100 momentum to destroy a wall
				W.dismantle_wall(TRUE, TRUE)
				speed -= 100
			else
				gameover()
				return

		if(istype(loc, /turf/open/floor))
			var/turf/open/floor/W = loc
			if(momentum <= 1)
				gameover()
				return


/obj/effect/coilshot/proc/move()
	if(!step(src,dir))
		forceMove(get_step(src,dir))
	speed--
	throwforce = momentum * 0.2

	if(speed && mass)
		momentum = mass*speed
	else
		gameover()
		return

	if(momentum <= 1)
		gameover()


/// called when we pass through a charger
/obj/effect/coilshot/on_transfer()
	if(p_heat >= heat_capacity)
		overspice()

/// melts the projectile when over heated
/obj/effect/coilshot/overspice()
	var/obj/effect/decal/cleanable/ash/melted = new(loc) // make an ash pile where we die ;-;
	playsound(loc, 'sound/items/welder.ogg', 150, 1)
	melted.name = "slagged [name]"
	melted.desc = "Ahahah that's hot, that's hot."
	qdel(src)

/// called when projectile has expired, replaces coilshot projectile with the original projectile.
/obj/effect/coilshot/gameover()
	var/atom/L = drop_location()
	for(var/atom/movable/AM in src)
		AM.forceMove(L)
		if(throwing) // you keep some momentum when getting out of a thrown closet
			step(AM, dir)
	if(throwing)
		throwing.finalize(FALSE)
	qdel(src)
