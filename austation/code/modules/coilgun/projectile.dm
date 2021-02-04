// screenshake
#define MAX_SHAKE 2.1

// The base/minimum amount of tiles a bluespace hvp can teleport to
#define BASE_SWITCH_RANGE 4

// the maximum amount of tiles a bluespace hvp can teleport to
#define MAX_SWITCH_RANGE 11

/obj/effect/hvp
	name = "coilgun projectile"
	desc = "hey! You shouldn't be reading this"
	icon = 'icons/obj/objects.dmi'
	icon_state = "immrod"
	density = TRUE
	anchored = TRUE
	move_force = INFINITY
	move_resist = INFINITY
	pull_force = INFINITY
	var/heat_capacity = 100 // how hot the object can get before melting
	var/mass = 0 // how heavy the object is
	var/special //special propeties
	var/spec_amt = 0 // how many times has this projectile been modified
	var/p_heat = 0 // projectile temp
	var/p_speed = 0 // how fast the projectile is moving
	var/charged = FALSE // has the projectile been overcharged
	var/momentum = 0

/obj/effect/hvp/proc/launch()
	momentum = mass * p_speed
	if(momentum >= 1000)
		var/turf/open/T = src.loc
		if(T.air)
			for(var/mob/M in range(10, src))
				shake_camera(M, 10, clamp(momentum*0.002, 0, MAX_SHAKE)) // is that you, pilot with the three stripes?
	if(momentum >= 1)
		addtimer(CALLBACK(src, .proc/move), 1)
	else
		gameover()
		return
	SSaugury.register_doom(src, momentum)

/obj/effect/hvp/Topic(href, href_list)
	if(href_list["orbit"])
		var/mob/dead/observer/ghost = usr
		if(istype(ghost))
			ghost.ManualFollow(src)

/obj/effect/hvp/Bump(atom/clong) // lots of rod code in here xd
	if(prob(80))
		playsound(src, 'sound/effects/bang.ogg', 50, 1)
		audible_message("<span class='danger'>You hear a CLANG!</span>")
	var/change_dir_chance = -max(1, momentum / 100) + 100 // chance to change to collided direction increases as momentum decreases
	if(clong && prob(change_dir_chance))
		x = clong.x
		y = clong.y
	if(isturf(clong) || isobj(clong))
		if(special & HVP_BOUNCY && prob(50))
			dir = invertDir(dir)
		if(momentum >= 100 || istype(clong, /obj/structure/window)) // stops windows from taking a tiny crack instead of a smash
			clong.ex_act(EXPLODE_DEVASTATE)
		else if(momentum > 10)
			clong.ex_act(EXPLODE_HEAVY)
		else
			gameover()
			return
		p_speed -= 10
	if(prob(15) && special & HVP_RADIOACTIVE)
		var/datum/component/radioactive/rads = GetComponent(/datum/component/radioactive)
		var/pulsepower = (rads.strength + 1) * min((momentum * 0.05), 1) // faster rods multiply rads, for some reason
		radiation_pulse(src, pulsepower)
	if(isliving(clong))
		penetrate(clong)

/obj/effect/hvp/proc/penetrate(mob/living/L)
	L.visible_message("<span class='danger'>[L] is penetrated by \the [src]!</span>" , "<span class='userdanger'>\The [src] penetrates you!</span>" , "<span class ='danger'>You hear a CLANG!</span>")
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/projdamage = max(10, momentum / 35)
		if(special & HVP_SHARP)
			projdamage *= 2
			var/Z = pick(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG, BODY_ZONE_HEAD)
			var/obj/item/bodypart/BP = H.get_bodypart(Z)
			var/unlucky = clamp(momentum * 0.03, 15, 100)
			if(prob(unlucky))
				BP.drop_limb()
		if(special & HVP_BOUNCY)
			projdamage /= 4 // bouncy things don't hurt as much
			L.adjustStaminaLoss(clamp(projdamage, 5, 120))
			var/atom/target = get_edge_target_turf(L, dir)
			L.throw_at(target, 200, 4) // godspeed o7
		else
			H.adjustBruteLoss(projdamage)

/obj/effect/hvp/proc/move()
	if(!step(src,dir))
		Move(get_step(src,dir))
	if((special & HVP_BLUESPACE) && prob(5)) // good ol switcharoo
		var/switch_range = clamp(BASE_SWITCH_RANGE * (momentum / 120), BASE_SWITCH_RANGE, MAX_SWITCH_RANGE)
		var/list/choices = list()

		for(var/mob/living/L in range(switch_range, src))
			choices += L
		if(LAZYLEN(choices)) // target acquired!
			var/oldloc = get_turf(src)
			var/target = pick(choices)
			do_teleport(src, get_turf(target), asoundin = 'sound/effects/phasein.ogg', channel = TELEPORT_CHANNEL_BLUESPACE)
			do_teleport(target, oldloc, asoundin = 'sound/effects/phasein.ogg', channel = TELEPORT_CHANNEL_BLUESPACE)

	if(p_speed && mass)
		momentum = mass*p_speed
	else
		gameover()
		return
	if(istype(get_turf(src), /turf/open/floor)) // Much less expensive than atmos checks, no drag in space
		p_speed--
	if(momentum <= 1)
		gameover()
		return
	var/move_delay = clamp(round(0.9994 ** p_speed), 0.05, 0.2) // it just works
	addtimer(CALLBACK(src, .proc/move), move_delay)

/// called when we pass through a charger
/obj/effect/hvp/proc/on_transfer()
	if(p_heat >= heat_capacity)
		overspice()

/// melts the projectile when over heated
/obj/effect/hvp/proc/overspice()
	for(var/mob/living/M in contents)
		M.adjustFireLoss(20)
		forceMove(get_turf(src))
	var/obj/effect/decal/cleanable/ash/melted = new(get_turf(src)) // make an ash pile where we die ;-;
	playsound(loc, 'sound/items/welder.ogg', 150, 1)
	melted.name = "slagged [name]"
	melted.desc = "Aahahah that's hot, that's hot."
	qdel(src)

/// called when the projectile has expired, replaces hvp projectile with the original magnetized item.
/obj/effect/hvp/proc/gameover()
	var/atom/L = drop_location()
	for(var/atom/movable/AM in src)
		other_special(AM)
		if(AM)
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

/obj/effect/hvp/ex_act()
	return

/obj/effect/hvp/debug
	p_speed = 700
	mass = 3
/obj/effect/hvp/debug/badmin
	p_speed = 10000
	mass = 55

/obj/effect/hvp/debug/New()
	..()
	launch()

///Handles special projectile traits
/obj/effect/hvp/proc/apply_special(atom/movable/AM, initial = FALSE)
	. = FALSE
	if(isitem(AM))
		var/obj/item/I = AM
		var/datum/component/radioactive/rads = I.GetComponent(/datum/component/radioactive)
		if(rads)
			special |= HVP_RADIOACTIVE
			AddComponent(/datum/component/radioactive, rads.strength, src)
			. = TRUE
		if(I.is_sharp())
			special |= HVP_SHARP
			. = TRUE
		if(I in GLOB.hvp_bluespace)
			special |= HVP_BLUESPACE
			. = TRUE
		if(I in GLOB.hvp_bouncy)
			special |= HVP_BOUNCY
			. = TRUE

/obj/effect/hvp/proc/other_special(atom/movable/AM)
	if(istype(AM, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/RC = AM
		if(!istype(RC, /obj/item/reagent_containers/food))
			for(var/datum/reagent/R in RC.reagents.reagent_list)
				var/datum/reagents/H = R.holder
				H.expose_temperature(5000) // about 5 lighter hits to a beaker
				if(R) // and if that didn't do anything, smoke
					var/datum/effect_system/smoke_spread/chem/S
					S.set_up(R, 5, loc)
					S.start()
	if(istype(AM, /obj/item/grenade))
		var/obj/item/grenade/G = AM
		G.prime() // armour piercing high explosive rod ;)
