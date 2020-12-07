/obj/effect/hvp
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

/obj/effect/hvp/proc/launch()

	momentum = mass*p_speed
	if(momentum >= 1)
		addtimer(CALLBACK(src, .proc/move), 1)
	else
		gameover()

/obj/effect/hvp/Bump(atom/clong) // lots of rod code in here
	if(prob(80))
		playsound(src, 'sound/effects/bang.ogg', 50, 1)
		audible_message("<span class='danger'>You hear a CLANG!</span>")
	var/change_dir_chance = -max(1, momentum / 100) + 100 // chance to change to collided direction increases as momentum decreases
	if(clong && prob(change_dir_chance))
		x = clong.x
		y = clong.y
	if(isturf(clong) || isobj(clong))
		if(clong.density)
			if(momentum >= 100 || istype(clong, /obj/structure/window))
				clong.ex_act(EXPLODE_DEVASTATE)
			else if(momentum > 10)
				clong.ex_act(EXPLODE_HEAVY)
			else
				gameover()
				return
			p_speed -= 10
	else if(isliving(clong))
		penetrate(clong)

/obj/effect/hvp/proc/penetrate(mob/living/L)
	L.visible_message("<span class='danger'>[L] is penetrated by \the [src]!</span>" , "<span class='userdanger'>\The [src] penetrates you!</span>" , "<span class ='danger'>You hear a CLANG!</span>")
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/projdamage = max(15, momentum / 3)
		H.adjustBruteLoss(projdamage)
//	if(L && (L.density || prob(10)))
//		L.ex_act(EXPLODE_HEAVY)

/obj/effect/hvp/proc/move()
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
/obj/effect/hvp/proc/on_transfer()
	if(p_heat >= heat_capacity)
		overspice()

/// melts the projectile when over heated
/obj/effect/hvp/proc/overspice()
	var/obj/effect/decal/cleanable/ash/melted = new(loc) // make an ash pile where we die ;-;
	playsound(loc, 'sound/items/welder.ogg', 150, 1)
	melted.name = "slagged [name]"
	melted.desc = "Ahahah that's hot, that's hot."
	qdel(src)

/// called when the projectile has expired, replaces hvp projectile with the original item used to make it.
/obj/effect/hvp/proc/gameover()
	var/atom/L = drop_location()
	for(var/atom/movable/AM in src)
		AM.forceMove(L)
		if(throwing) // you keep some momentum
			step(AM, dir)
	if(throwing)
		throwing.finalize(FALSE)
	qdel(src)

/obj/effect/hvp/relaymove(mob/living/user)
	if(istype(loc, /obj/structure/disposalholder))
		var/obj/structure/disposalholder/DH = loc
		DH.relaymove()

/obj/effect/hvp/debug
	p_speed = 700
	mass = 3
/obj/effect/hvp/debug/badmin
	p_speed = 10000
	mass = 55

/obj/effect/hvp/debug/New()
	..()
	launch()
