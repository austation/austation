// screenshake
#define MAX_SHAKE 2.1

// The base/minimum amount of tiles a bluespace hvp can teleport to
#define BASE_SWITCH_RANGE 4

// the maximum amount of tiles a bluespace hvp can teleport to
#define MAX_SWITCH_RANGE 11

/obj/effect/hvp
	name = "high velocity projectile"
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
	// projectile temp
	var/p_heat = 0
	var/p_speed = 0 // how fast the projectile is moving (not physically, due to byond limitations)
	var/infused = 0 // how much energy is infused with the projectile?
	var/momentum = 0

/obj/effect/hvp/proc/launch()
	momentum = mass * p_speed // hey google
	if(momentum >= 1000) // how can I kill
		var/turf/open/T = get_turf(src)
		if(T.air)
			for(var/mob/M in range(10, src))
				shake_camera(M, 10, clamp(momentum*0.002, 0, MAX_SHAKE)) // one million people?
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
		if((special & HVP_BOUNCY) && prob(50))
			dir = invertDir(dir)
			playsound(src, 'sound/vehicles/clowncar_crash2.ogg', 40, 0, 0)
			if(prob(5))
				dir = turn(dir, pick(-90, 90))
				audible_message("<span class='danger'>You hear a BOING!</span>")
		if(momentum >= 1000 || istype(clong, /obj/structure/window)) // Windows always break when getting hit by HVPs
			clong.ex_act(EXPLODE_DEVASTATE)
		else if(momentum > 100)
			clong.ex_act(EXPLODE_HEAVY)
		else
			gameover()
			return
		p_speed -= 10
	if(prob(15) && (special & HVP_RADIOACTIVE))
		var/datum/component/radioactive/rads = GetComponent(/datum/component/radioactive)
		var/pulsepower = (rads.strength + 1) * max(momentum * 0.05, 1) // faster rods multiply rads, for.. reasons
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
			playsound(src, 'sound/vehicles/clowncar_crash2.ogg', 50, 0, 5)
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

	if(isfloorturf(get_turf(src))) // Less expensive than atmos checks so it just checks for floor turfs for "drag"
		p_speed--
	if(p_speed && mass && momentum > 1)
		momentum = mass*p_speed
	else
		gameover()
		return
	// 0.05 is already pushing it too it's limits, any faster and it either runtimes or breaks reality.
	// Going faster would require hacky visual effects and/or projected proc calling.
	var/move_delay = clamp(round(0.9994 ** p_speed), 0.05, 0.2)
	addtimer(CALLBACK(src, .proc/move), move_delay)

/// called when we pass through a charger
/obj/effect/hvp/proc/on_transfer()
	if(p_heat >= heat_capacity)
		overspice()

/// melts the projectile when over heated
/obj/effect/hvp/proc/overspice()
	if(!LAZYLEN(contents))
		qdel(src)
		return
	for(var/atom/movable/AM in contents)
		if(isliving(AM))
			var/mob/living/L = AM
			L.adjustFireLoss(20)
			L.forceMove(get_turf(src))
			continue
		if(isitem(AM))
			var/obj/item/I = AM
			if(I.resistance_flags & INDESTRUCTIBLE)
				I.forceMove(get_turf(src))
				continue
		var/obj/effect/decal/cleanable/ash/melted = new(get_turf(src)) // make an ash pile where we die ;-;
		playsound(loc, 'sound/items/welder.ogg', 150, 1)
		melted.name = "slagged [AM.name]"
		melted.desc = "Aahahah that's hot, that's hot."
		qdel(AM)
	qdel(src)

/// called when the projectile has expired, replaces hvp projectile with the original magnetized item.
/obj/effect/hvp/proc/gameover()
	var/atom/L = drop_location()
	for(var/atom/movable/AM in src)
		other_special(AM)
		if(AM)
			AM.transform = matrix() // clears any rotation applied by items combined in the modifier
			AM.forceMove(L)
			if(throwing) // you keep some momentum, weee
				step(AM, dir)
	throwing?.finalize(FALSE)

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
		if(I.type in GLOB.hvp_bluespace)
			special |= HVP_BLUESPACE
			. = TRUE
		if(I.type in GLOB.hvp_bouncy)
			special |= HVP_BOUNCY
			. = TRUE

/obj/effect/hvp/proc/other_special(atom/movable/AM)
	if(istype(AM, /obj/item/reagent_containers) && !istype(AM, /obj/item/reagent_containers/food))
		var/datum/reagents/RH = locate() in AM
		if(RH?.total_volume)
			RH.expose_temperature(5000) // about 5 lighter hits to a beaker
			var/radius = RH?.total_volume / 10 // this also acts as a check to see if the holder still exists (wasn't blown up)
			if(radius) // and if that didn't do anything, turn it to smoke
				var/datum/effect_system/smoke_spread/chem/S = new
				S.set_up(RH, max(radius, 2), loc)
				S.start()
	if(istype(AM, /obj/item/grenade))
		var/obj/item/grenade/G = AM
		G.prime() // armour piercing high explosive crate ;)
