// screenshake
#define MAX_SHAKE 2.1

// The base/minimum amount of tiles a bluespace hvp can teleport to
#define BASE_SWITCH_RANGE 4

// the maximum amount of tiles a bluespace hvp can teleport to
#define MAX_SWITCH_RANGE 15

// max speed multiplier for movement
#define MAX_SPEED 5

/obj/item/projectile/hvp
	name = "high velocity projectile"
	desc = "hey! You shouldn't be reading this"
	icon = 'icons/obj/objects.dmi'
	icon_state = "immrod"
	density = TRUE
	move_force = INFINITY
	move_resist = INFINITY
	pull_force = INFINITY
	hitsound = null
	var/heat_capacity = 100 // how hot the object can get before melting
	var/mass = 0 // how heavy the object is
	var/special //special propeties
	var/spec_amt = 0 // how many times has this projectile been modified
	var/p_heat = 0 // projectile temp
	var/velocity = 0 // how fast the projectile is moving (not physically, due to byond limitations)
	var/infused = 0 // how much energy is infused with the projectile?
	var/list/initial_transforms = list()
	var/static/list/naughty_list = typecacheof(list(
		/obj/machinery/door/firedoor,
		/obj/structure/window
	))

	var/momentum = 0

/obj/item/projectile/hvp/proc/launch(_angle)
	momentum = mass * velocity // hey google
	setAngle(_angle)

	switch(momentum)
		if(-INFINITY to 0)
			gameover()
			return
		if(900 to 1299)
			var/turf/open/T = get_turf(src)
			if(T.air)
				for(var/mob/M in range(10, src))
					shake_camera(M, 10, clamp(momentum*0.001, 0, MAX_SHAKE)) // one million people?
		if(1300 to 10000)
			special |= HVP_SMILEY_FACE
			explosion_block = 1000
			return

	SSaugury.register_doom(src, momentum)
	log_game("Coilgun projectile fired in [get_area_name(src, TRUE)] with [momentum] momentum!")
	fire(Angle)

/obj/item/projectile/hvp/Topic(href, href_list)
	if(href_list["orbit"])
		var/mob/dead/observer/ghost = usr
		if(istype(ghost))
			ghost.ManualFollow(src)

/obj/item/projectile/hvp/Bump(atom/clong)

	if((special & HVP_SMILEY_FACE) && prob(5)) // << This twisted game needs to be reset >>
		var/E = log(momentum)
		explosion(loc, E, E+1 ,E+2 ,E+3 , FALSE) // << That's what the V2 is for >>
		return

	if(isturf(clong) || isobj(clong))
		if(momentum < 10)
			gameover()
			return
		if((special & HVP_BOUNCY) && prob(20))
			var/n_angle = calc_ricochet(clong)
			playsound(src, 'sound/vehicles/clowncar_crash2.ogg', 40, 0, 0)
			if(prob(5))
				n_angle = SIMPLIFY_DEGREES(Angle + rand(20, -20))
				audible_message("<span class='danger'>You hear a BOING!</span>")
			setAngle(n_angle)

		if(prob(5))
			playsound(src, 'sound/effects/bang.ogg', 50, 1)
			audible_message("<span class='danger'>You hear a CLANG!</span>")
				if((special & HVP_RADIOACTIVE) && prob(15))
				var/datum/component/radioactive/rads = GetComponent(/datum/component/radioactive)
				var/pulsepower = (rads.strength + 1) * (momentum / 250 + 1) // faster rods multiply rads because of.. reasons
				radiation_pulse(src, pulsepower)

		if(check_ricochet(clong))
			setAngle(calc_ricochet(clong))
			visible_message("<span class='warning'>\The [src] ricochets off \the [clong]!</span>")
		if(momentum > 10)
			if(naughty_list[clong.type])
				clong.hvp_act(momentum)
			else
				clong.hvp_act(momentum)
		else
			gameover()
		momentum -= 10
		return

	if(isliving(clong))
		penetrate(clong)


// mostly yoinked from wall ricochet code but made the calculations projectile side and adjusted return values
/obj/item/projectile/hvp/proc/calc_ricochet(atom/A, return_incidence = FALSE)
	var/face_direction = get_dir(A, get_turf(src))
	var/face_angle = dir2angle(face_direction)
	var/incidence = GET_ANGLE_OF_INCIDENCE(face_angle, (Angle + 180))
	return return_incidence ? incidence : SIMPLIFY_DEGREES(face_angle + incidence)

/*
	*   The following proc is a bit messy so here's the broken up version:
	*   =============================================================================
	*	var/incidence = calc_ricochet(clong, TRUE)
	*	var/chance = -((log(0.001 * (momentum - 90))) / 2)
	*	var/actual_chance = (incidence / 90) * chance		(the actual thing below)
	*   ==============================================================================
	*	Works properly if momentum is above 100, returns a decimal between 0-1.
*/
/obj/item/projectile/hvp/check_ricochet(atom/A)
	var/chance = (calc_ricochet(A, TRUE) / 90) * -((log(0.001 * (momentum - 90))) / 2)
	return prob(chance * 100)

/obj/item/projectile/hvp/proc/penetrate(mob/living/L)
	var/projdamage = max(momentum / 35, 15)
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(special & HVP_SHARP)
			projdamage *= 2
			var/Z = pick(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG, BODY_ZONE_HEAD)
			var/obj/item/bodypart/BP = H.get_bodypart(Z)
			var/unlucky = clamp(momentum * 0.03, 15, 100)
			if(prob(unlucky))
				BP.dismember()
		if(special & HVP_BOUNCY) // BOING
			projdamage /= 4 // bouncy things don't hurt as much
			H.adjustStaminaLoss(clamp(projdamage, 5, 120))
			playsound(src, 'sound/vehicles/clowncar_crash2.ogg', 50, 0, 5)
			setAngle(calc_ricochet(L))
			var/atom/target = get_edge_target_turf(L, dir)
			L.throw_at(target, 200, 4) // godspeed o7
	L.adjustBruteLoss(projdamage)
	L.visible_message("<span class='danger'>[L] is penetrated by \the [src]!</span>" , "<span class='userdanger'>\The [src] penetrates you!</span>" , "<span class ='danger'>You hear a CLANG!</span>")


/obj/item/projectile/hvp/Range()
	if(momentum < 1)
		gameover()
		return
	if((special & HVP_BLUESPACE) && prob(5)) // good ol switcharoo
		var/switch_range = clamp(BASE_SWITCH_RANGE * (momentum / 120), BASE_SWITCH_RANGE, MAX_SWITCH_RANGE)
		var/list/choices = list()
		for(var/mob/living/L in range(switch_range, src))
			choices += L
		if(LAZYLEN(choices)) // target acquired!
			var/atom/movable/target = pick(choices)
			var/oldloc = loc
			do_teleport(src, get_turf(target), asoundin = 'sound/effects/phasein.ogg', channel = TELEPORT_CHANNEL_BLUESPACE)
			do_teleport(target, oldloc, asoundin = 'sound/effects/phasein.ogg', channel = TELEPORT_CHANNEL_BLUESPACE)
			target.throw_at(get_edge_target_turf( target, angle2dir(Angle) ), 200, max( round(log(momentum)), 1))

	if(isfloorturf(get_turf(src)))
		momentum--

	velocity = momentum / mass
	// 0.1 deciseconds is already pushing byond too it's limits, any faster and it either runtimes or breaks reality.
	// Going faster requires hacky visual effects and projected path deletion.
	speed = max(-(1.001 ** velocity) + 2.1, 0.1)

/// called when we pass through a charger
/obj/item/projectile/hvp/proc/on_transfer()
	if(p_heat >= heat_capacity)
		overspice()

/// melts the projectile when overheated
/obj/item/projectile/hvp/proc/overspice()
	if(!LAZYLEN(contents))
		qdel(src)
		return
	var/turf/T = get_turf(src)
	for(var/atom/movable/AM in contents)
		if(isliving(AM))
			var/mob/living/L = AM
			L.adjustFireLoss(20)
			INVOKE_ASYNC(L, /mob.proc/emote, "scream")
			L.forceMove(T)
			L.Stun(40)
			continue
		if(isitem(AM))
			var/obj/item/I = AM
			if(I.resistance_flags & INDESTRUCTIBLE)
				I.forceMove(T)
				continue
		var/obj/effect/decal/cleanable/ash/melted = new(T) // make an ash pile where we die ;-;
		playsound(loc, 'sound/items/welder.ogg', 150, 1)
		melted.name = "slagged [AM.name]"
		melted.desc = "Aahahah that's hot, that's hot."
		qdel(AM)
	qdel(src)

/// called when the projectile has expired, replaces hvp projectile with the original magnetized item.
/obj/item/projectile/hvp/proc/gameover()
	for(var/atom/movable/AM in src)
		other_special(AM)
		if(AM)
			if(initial_transforms[AM])
				AM.transform = initial_transforms[AM]
			AM.forceMove(get_turf(src))
			if(throwing)
				step(AM, angle2dir(Angle))
	throwing?.finalize(FALSE)
	qdel(src)

/obj/item/projectile/hvp/relaymove(mob/living/user)
	var/obj/structure/disposalholder/DH = loc
	if(istype(DH))
		DH.relaymove()

/obj/item/projectile/hvp/ex_act()
	return

/obj/item/projectile/hvp/debug
	velocity = 700
	mass = 3

/obj/item/projectile/hvp/debug/badmin
	velocity = 10000
	mass = 55

/obj/item/projectile/hvp/debug/badmin/chaos
	special = HVP_SHARP | HVP_BLUESPACE | HVP_BOUNCY

/obj/item/projectile/hvp/debug/New()
	..()
	launch(dir2angle(dir))

/// Handles the addition of projectile interaction flags.
/obj/item/projectile/hvp/proc/apply_special(atom/movable/AM, initial = FALSE)
	. = FALSE
	if(isitem(AM))
		var/obj/item/I = AM
		var/datum/component/radioactive/rads = I.GetComponent(/datum/component/radioactive)
		if(rads?.can_contaminate)
			special |= HVP_RADIOACTIVE
			AddComponent(/datum/component/radioactive, rads.strength, src)
			. = TRUE
		if(I.is_sharp())
			special |= HVP_SHARP
			. = TRUE
		if(GLOB.hvp_bluespace[I.type])
			special |= HVP_BLUESPACE
			. = TRUE
		if(GLOB.hvp_bouncy[I.type])
			special |= HVP_BOUNCY
			. = TRUE
		if(GLOB.hvp_void[I.type])
			special |= HVP_VOID
			. = TRUE

/// Called b
/obj/item/projectile/hvp/proc/other_special(atom/movable/AM)
	if(istype(AM, /obj/item/reagent_containers) && !istype(AM, /obj/item/reagent_containers/food))
		var/datum/reagents/RH = locate() in AM
		if(RH?.total_volume)
			RH.expose_temperature(1000 * (p_heat / 10 + 1))
	if(istype(AM, /obj/item/grenade))
		var/obj/item/grenade/G = AM
		G.prime() // armour piercing high explosive crate ;)

/obj/item/projectile/hvp/process_hit()
	return

/obj/item/projectile/hvp/on_hit()
	return
