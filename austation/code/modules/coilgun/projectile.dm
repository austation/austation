/obj/effect/coilshot
	name = "coilgun projectile"
	desc = "oopsy woopsy, if you can read this, coder has messed up."
	icon = 'icons/obj/objects.dmi'
	icon_state = "immrod"
	throwforce = 5
	density = TRUE
	anchored = TRUE
	move_force = INFINITY
	move_resist = INFINITY
	pull_force = INFINITY
	var/heat_capacity = 80
	var/mass = 0 // how heavy the object is
	var/special = "none" //special propeties
	var/p_heat = 0 //how hot this projectile is
	var/p_speed = 0 //how fast the projectile will exit the barrel
	var/charged = FALSE //has the projectile been overcharged already
	var/momentum = 0

/obj/effect/coilshot/proc/launch()
	addtimer(CALLBACK(src, .proc/move), 1)

/obj/effect/coilshot/Bump(atom/clong) // lots of rod code in here
	if(prob(10))
		playsound(src, 'sound/effects/bang.ogg', 50, 1)
		audible_message("<span class='danger'>You hear a CLANG!</span>")
	var/change_dir_chance = -max(1, momentum / 100) + 100 // chance to change to collided direction increases as momentum decreases
	if(clong && prob(change_dir_chance))
		x = clong.x
		y = clong.y
	if(isturf(clong) || isobj(clong))
		if(momentum >= 100)
			if(clong.density)
				clong.ex_act(EXPLODE_HEAVY)
				p_speed -= 100
		else
			gameover()
			return
	else if(isliving(clong))
		penetrate(clong)

/obj/effect/coilshot/proc/penetrate(mob/living/L)
	L.visible_message("<span class='danger'>[L] is penetrated by \the [src]!</span>" , "<span class='userdanger'>\The [src] penetrates you!</span>" , "<span class ='danger'>You hear a CLANG!</span>")
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/projdamage = max(15, momentum / 100)
		H.adjustBruteLoss(projdamage)
	if(L && (L.density || prob(10)))
		L.ex_act(EXPLODE_HEAVY)

/obj/effect/coilshot/proc/move()
	if(!step(src,dir))
		forceMove(get_step(src,dir))
	p_speed--
	throwforce = momentum * 0.2

	if(p_speed && mass)
		momentum = mass*p_speed

	else
		gameover()
		return
	if(istype(loc, /turf/open/floor))
		p_speed -= 1
	if(momentum <= 1)
		gameover()
		return
	var/move_delay = clamp(round(0.9994 ** p_speed), 0.01, 0.2) // it just works
	addtimer(CALLBACK(src, .proc/move), move_delay)

/// called when we pass through a charger
/obj/effect/coilshot/proc/on_transfer()
	if(p_heat >= heat_capacity)
		overspice()

/// melts the projectile when over heated
/obj/effect/coilshot/proc/overspice()
	var/obj/effect/decal/cleanable/ash/melted = new(loc) // make an ash pile where we die ;-;
	playsound(loc, 'sound/items/welder.ogg', 150, 1)
	melted.name = "slagged [name]"
	melted.desc = "Ahahah that's hot, that's hot."
	qdel(src)

/// called when projectile has expired, replaces coilshot projectile with the original projectile.
/obj/effect/coilshot/proc/gameover()
	var/atom/L = drop_location()
	for(var/atom/movable/AM in src)
		AM.forceMove(L)
		if(throwing) // you keep some momentum when getting out of a thrown closet
			step(AM, dir)
	if(throwing)
		throwing.finalize(FALSE)
	qdel(src)


/obj/effect/coilshot/debug
	p_speed = 700
	mass = 3
/obj/effect/coilshot/debug/adminbus
	p_speed = 10000
	mass = 50

/obj/effect/coilshot/debug/New()
	. = ..()
	launch()
