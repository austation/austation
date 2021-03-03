// screenshake
#define MAX_SHAKE 2.1

// The base/minimum amount of tiles a bluespace hvp can teleport to
#define BASE_SWITCH_RANGE 4

// the maximum amount of tiles a bluespace hvp can teleport to
#define MAX_SWITCH_RANGE 11

// max speed multiplier for movement
#define MAX_SPEED 5

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
	var/p_heat = 0 // projectile temp
	var/p_speed = 0 // how fast the projectile is moving (not physically, due to byond limitations)
	var/infused = 0 // how much energy is infused with the projectile?

	var/angle = 0
	var/datum/point/vector/trajectory
	var/last_angle = 0
	var/momentum = 0

/obj/effect/hvp/proc/launch(p_angle, p_dir)
	momentum = mass * p_speed // hey google
	if(momentum >= 1000) // how can I kill
		var/turf/open/T = get_turf(src)
		if(T.air)
			for(var/mob/M in range(10, src))
				shake_camera(M, 10, clamp(momentum*0.002, 0, MAX_SHAKE)) // one million people?
	forceMove(get_turf(src)) // make sure we're not inside something
	if(momentum >= 1)
		dir = p_dir
		angle = p_angle
		if(!angle)
			angle = dir2angle(dir)
		calc_trajectory()
		addtimer(CALLBACK(src, .proc/t_move), 1)
	else
		gameover()
		return
	SSaugury.register_doom(src, momentum)

//TODO: use getline() for magic delete line at high speeds. Projectile can only go so fast before it phases through turfs/mobs
/obj/effect/hvp/proc/get_line_of_death()

/obj/effect/hvp/Topic(href, href_list)
	if(href_list["orbit"])
		var/mob/dead/observer/ghost = usr
		if(istype(ghost))
			ghost.ManualFollow(src)

/obj/effect/hvp/Bump(atom/clong)
	if(prob(35))
		playsound(src, 'sound/effects/bang.ogg', 50, 1)
		audible_message("<span class='danger'>You hear a CLANG!</span>")
	var/change_dir_chance = 100 - max(1, momentum / 25) // chance to change to collided direction increases as momentum decreases
	if(clong && prob(change_dir_chance))
		x = clong.x
		y = clong.y
	if(isturf(clong) || isobj(clong))
		if((special & HVP_BOUNCY) && prob(50))
			angle = calc_ricochet(clong)
			update_trajectory()
			playsound(src, 'sound/vehicles/clowncar_crash2.ogg', 40, 0, 0)
			if(prob(5))
				angle += rand(20, -20)
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

// shield.dm and maths.dm for figuring out how the fucking fuck to math this BULLSHIT
/obj/effect/hvp/proc/calc_ricochet(atom/A) // mostly yoinked from wall ricochet code but made the calculations projectile side
	var/face_direction = get_dir(A, get_turf(src))
	var/face_angle = dir2angle(face_direction)
	var/incidence = GET_ANGLE_OF_INCIDENCE(face_angle, (angle + 180))
	return SIMPLIFY_DEGREES(face_angle + incidence)

/obj/effect/hvp/proc/calc_trajectory()
	var/turf/start = get_turf(src)
	var/speed_multiplier = min(log(p_speed) / 2, MAX_SPEED)
	trajectory = new(start.x, start.y, start.z, pixel_x, pixel_y, angle)

/obj/effect/hvp/proc/update_trajectory()
	if(trajectory)
		trajectory.set_angle(angle)
		trajectory.set_speed( clamp((log(p_speed) / 2), 0.6, MAX_SPEED) )

/obj/effect/hvp/proc/penetrate(mob/living/L)
	var/projdamage = max(15, momentum / 35)
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(special & HVP_SHARP)
			projdamage *= 2
			var/Z = pick(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG, BODY_ZONE_HEAD)
			var/obj/item/bodypart/BP = H.get_bodypart(Z)
			var/unlucky = clamp(momentum * 0.03, 15, 100)
			if(prob(unlucky))
				BP.dismember()
		if(special & HVP_BOUNCY)
			projdamage /= 4 // bouncy things don't hurt as much
			H.adjustStaminaLoss(clamp(projdamage, 5, 120))
			playsound(src, 'sound/vehicles/clowncar_crash2.ogg', 50, 0, 5)
			angle = calc_ricochet(L)
	L.adjustBruteLoss(projdamage)
	L.visible_message("<span class='danger'>[L] is penetrated by \the [src]!</span>" , "<span class='userdanger'>\The [src] penetrates you!</span>" , "<span class ='danger'>You hear a CLANG!</span>")


/obj/effect/hvp/proc/t_move()
	trajectory.increment()
	var/turf/T = trajectory.return_turf()
	Move(T)
	if(angle != last_angle)
		var/matrix/M = new
		M.Turn(angle)
		transform = M
	if((special & HVP_BLUESPACE) && prob(5)) // good ol switcharoo
		var/switch_range = clamp(BASE_SWITCH_RANGE * (momentum / 120), BASE_SWITCH_RANGE, MAX_SWITCH_RANGE)
		var/list/choices = list()

		for(var/mob/living/L in range(switch_range, src))
			choices += L
		if(LAZYLEN(choices)) // target acquired!
			var/oldloc = get_turf(src)
			var/atom/movable/target = pick(choices)
			do_teleport(src, get_turf(target), asoundin = 'sound/effects/phasein.ogg', channel = TELEPORT_CHANNEL_BLUESPACE)
			do_teleport(target, oldloc, asoundin = 'sound/effects/phasein.ogg', channel = TELEPORT_CHANNEL_BLUESPACE)
			target.throw_at(get_edge_target_turf( target, angle2dir(angle) ), 200, max( round(log(momentum)), 1))

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
	addtimer(CALLBACK(src, .proc/t_move), move_delay)

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
			INVOKE_ASYNC(L, /mob.proc/emote, "scream")
			L.forceMove(get_turf(src))
			L.Stun(40)
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
			RH.expose_temperature(1000 * (p_heat / 10 + 1))
	if(istype(AM, /obj/item/grenade))
		var/obj/item/grenade/G = AM
		G.prime() // armour piercing high explosive crate ;)
