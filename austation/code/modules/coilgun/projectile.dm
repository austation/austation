// screenshake
#define MAX_SHAKE 1.5

// The base (and minimum) amount of tiles a bluespace hvp can teleport to
#define BASE_SWITCH_RANGE 4

// the maximum amount of tiles a bluespace hvp can teleport to
#define MAX_SWITCH_RANGE 15

/obj/item/projectile/hvp
	name = "high velocity projectile"
	desc = "Hey! You shouldn't be reading this"
	icon = 'icons/obj/objects.dmi'
	icon_state = "immrod"
	density = TRUE
	move_force = INFINITY
	movement_type = FLYING | UNSTOPPABLE
	move_resist = INFINITY
	pull_force = INFINITY
	hitsound = null
	appearance_flags = KEEP_TOGETHER
	nondirectional_sprite = TRUE // Well, it is directional but the parent way of handling it is messy and slow, overrided here.
	var/heat_capacity = 100 // how hot the object can get before melting
	var/mass = 0 // how heavy the object is
	var/special //special propeties
	var/rad_max = 0 // Highest rad strength from rad contents
	var/spec_amt = 0 // how many times has this projectile been modified
	var/max_spec = 3 // max amount of special effects we can have
	var/p_heat = 0 // projectile temp
	var/velocity = 0 // how fast the projectile is moving (not physically, due to byond limitations)
	var/lastAngle = 0
	var/lockAngle = FALSE // set to true to prevent the projectile from changing it's angle
	var/infused = 0 // how much energy is infused with the projectile?
	var/spin = 0 // spin animation speed, if any
	var/cangib = TRUE // can the projectile gib at high speeds
	var/list/assoc_overlays = list()

	var/momentum = 0

/obj/item/projectile/hvp/proc/launch(_angle, _inaccuracy, atom/firer, barrel_segments)
	if(barrel_segments)
		var/turf/T = get_turf_in_angle(Angle, get_turf(firer), barrel_segments)
		forceMove(T)
		velocity *= barrel_segments ** 0.175 // Velocity benefits from barrels have diminishing results
	momentum = mass * velocity
	if(_inaccuracy)
		_angle += rand(_inaccuracy, -_inaccuracy)
	setAngle(_angle)

	switch(momentum)
		if(-INFINITY to 0)
			gameover()
			return
		if(900 to 1299)
			var/turf/open/T = get_turf(src)
			if(T?.air)
				for(var/mob/M in range(10, src))
					shake_camera(M, 10, clamp(momentum / 1000, 0, MAX_SHAKE))
		if(1300 to 2000)
			special |= HVP_SMILEY_FACE
		else
			special |= HVP_FRAME_DRAG
	SSaugury.register_doom(src, momentum)
	log_game("Coilgun projectile fired in [get_area_name(src, TRUE)] with [momentum] momentum!")
	fire(Angle)

/obj/item/projectile/hvp/Topic(href, href_list)
	if(href_list["orbit"])
		var/mob/dead/observer/ghost = usr
		if(istype(ghost))
			ghost.ManualFollow(src)

/obj/item/projectile/hvp/setAngle(new_angle)
	if(lockAngle)
		return
	Angle = new_angle
	if(Angle != lastAngle)
		var/matrix/M = matrix()
		M.Turn(Angle)
		transform = M
	if(trajectory)
		trajectory.set_angle(new_angle)
	return TRUE

/obj/item/projectile/hvp/Bump(atom/clong)
	if(momentum < 10)
		gameover(TRUE)
		return

	if(special & HVP_STICKY)
		var/chance = 0
		if(isturf(clong))
			chance = 10
		else if(isobj(clong))
			chance = 35
		else // mob
			chance = 100
		if(prob(chance))
			add_object(clong, TRUE)
			return

	if((special & HVP_SMILEY_FACE) && prob(5)) // << This twisted game needs to be reset >>
		var/E = log(momentum)
		explosion(loc, E, E+1, E+2, E+3, FALSE) // << That's what the V2 is for >>
		return

	if(isturf(clong) || isobj(clong))
		if((special & HVP_BOUNCY) && prob(25))
			var/n_angle = calc_ricochet(clong)
			playsound(src, 'sound/vehicles/clowncar_crash2.ogg', 40, 0, 0)
			if(prob(5))
				n_angle = SIMPLIFY_DEGREES(Angle + rand(20, -20))
				audible_message("<span class='danger'>You hear a BOING!</span>")
			setAngle(n_angle)
			return

		if(prob(15))
			playsound(src, 'sound/effects/bang.ogg', 50, 1)
			audible_message("<span class='danger'>You hear a CLANG!</span>")
			if((special & HVP_RADIOACTIVE) && prob(40))
				var/datum/component/radioactive/rads = GetComponent(/datum/component/radioactive)
				var/pulsepower = (rads.strength + 1) * (momentum / 150 + 1) // faster rods multiply rads because.. reasons
				radiation_pulse(src, pulsepower)

		if(momentum > 100 && check_ricochet(clong))
			visible_message("<span class='warning'>\The [src] ricochets off [clong]!</span>")
			ricochet(clong)
		else
			clong.hvp_act(src)
		momentum -= 10
		return

	if(isliving(clong))
		penetrate(clong)

/obj/item/projectile/hvp/proc/ricochet(atom/target)
	setAngle(calc_ricochet(target))
	ricochets++

// mostly yoinked from wall ricochet code but made the calculations projectile side and adjusted returns
/obj/item/projectile/hvp/proc/calc_ricochet(atom/A, return_incidence = FALSE)
	var/face_direction = get_dir(A, get_turf(src))
	var/face_angle = dir2angle(face_direction)
	var/incidence = GET_ANGLE_OF_INCIDENCE(face_angle, (Angle + 180))
	return return_incidence ? incidence : SIMPLIFY_DEGREES(face_angle + incidence)

/*
	*   The following proc is a bit messy so here's the broken up version:
	*   =============================================================================
	*	incidence = calc_ricochet(clong, TRUE)
	*	incidence / 90 = linear value from 0-1
	*	-----
	*	var/exponent_decay = -((log(0.001 * (momentum - 90))) / 2)
	*	var/actual_chance = (incidence / 90) * exponent_decay		(the actual thing below)
	*   ==============================================================================
	*	Works properly if momentum is above 100, returns a decimal between 0-1.
*/
/obj/item/projectile/hvp/check_ricochet(atom/A)
	var/lin_incidence = calc_ricochet(A, TRUE) / 90
	if(momentum > 100)
		var/chance = lin_incidence * -((log(0.001 * (momentum - 90))) / 2)
		return prob(chance * 100)
	return prob(lin_incidence - 0.3)

// mmmm, bitshifting
/obj/item/projectile/hvp/proc/penetrate(mob/living/L)
	var/projdamage = max(momentum >> 2, 15)
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(special & HVP_SHARP)
			var/obj/item/bodypart/BP = pick(H.bodyparts)
			if(prob(max(momentum * 0.03, 15)))
				BP.dismember()
				if(prob(50))
					add_object(BP, add_special = FALSE) // Limb skewer!
		if(special & HVP_BOUNCY) // BOING!
			projdamage >>= 2 // bouncy things don't hurt as much
			H.adjustStaminaLoss(clamp(projdamage, 5, 120))
			var/throw_dir = angle2dir(Angle)
			playsound(src, 'sound/vehicles/clowncar_crash2.ogg', 50, 0, 5)
			ricochet(H)
			var/atom/target = get_edge_target_turf(H, throw_dir)
			H.throw_at(target, 200, round(2 + log(momentum))) // godspeed o7
	L.adjustBruteLoss(projdamage)
	L.visible_message("<span class='danger'>[L] is penetrated by \the [src]!</span>" , "<span class='userdanger'>\The [src] penetrates you!</span>" , "<span class ='danger'>You hear a CLANG!</span>")
	if(cangib && projdamage > 800 && !(special & HVP_STICKY))
		L.gib()

/obj/item/projectile/hvp/proc/add_object(atom/movable/AM, rotation = TRUE, pixel_offset = TRUE, add_special = TRUE, add_mass = TRUE)
	var/n_mass = mass
	if(isitem(AM))
		var/obj/item/I = AM
		n_mass += I.w_class
	else if(isliving(AM))
		var/mob/living/L = AM
		L.reset_perspective(AM)
		n_mass += (ishuman(L) ? 4 : 2)
	if(add_mass)
		mass += n_mass
		velocity = momentum / mass
	if(add_special && spec_amt > max_spec && apply_special(AM))
		spec_amt++
	if(contents.len)
		var/mutable_appearance/FA = mutable_appearance(AM.icon, AM.icon_state, layer)
		var/matrix/M = matrix()
		if(rotation)
			M.Turn(rand(1, 360))
		if(pixel_offset)
			var/amt = 1 + contents.len * 2
			M.Translate(amt * cos(Angle), amt * sin(Angle))
		FA.transform = M
		add_overlay(FA, TRUE)
		assoc_overlays[AM] = FA
	else // if this is the first item added, set it as the base.
		appearance = AM.appearance
	update_animations()
	if(isturf(AM)) // we can't put turfs inside objects ;-;
		var/turf/T = AM
		if(iswallturf(T))
			var/turf/closed/wall/W = T
			if(W.girder_type)
				AM = new W.girder_type
		T.ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
		return
	AM.forceMove(src)

/obj/item/projectile/hvp/proc/update_animations()
	if(spin)
		animate(src) // clears any active animations
		SpinAnimation(spin)

/obj/item/projectile/hvp/proc/remove_object(atom/movable/AM, move_loc)
	cut_overlay(assoc_overlays[AM], TRUE)
	if(move_loc)
		AM.forceMove(move_loc)

/obj/item/projectile/hvp/proc/remove_object_type(_type, move_loc)
	for(var/atom/movable/AM in contents)
		if(istype(AM, _type))
			remove_object(AM, move_loc)

/obj/item/projectile/hvp/Range()
	velocity = momentum / mass
	if(velocity < 1)
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
	// this is basically as fast as we can go without async memes.
	speed = max(-(1.0008 ** velocity) + 2.1, 0.1)

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
		melted.desc = "AH that's hot, that's hot."
		qdel(AM)
	qdel(src)

/// called when the projectile has expired, replaces hvp projectile with the original magnetized item.
/obj/item/projectile/hvp/proc/gameover(collision = FALSE)
	if(QDELETED(src))
		return
	var/turf/T = get_turf(src)
	for(var/atom/movable/AM in contents)
		AM.forceMove(T)
		death_special(AM)
		if(collision && !QDELETED(AM))
			var/range = rand(1, 4)
			AM.throw_at(get_ranged_target_turf(src, pick(GLOB.cardinals), range), range, 1)
	qdel(src)

/obj/item/projectile/hvp/relaymove(mob/living/user)
	var/obj/structure/disposalholder/DH = loc
	if(istype(DH))
		DH.relaymove()

/obj/item/projectile/hvp/ex_act()
	return

/// Handles the addition of projectile interaction flags.
/obj/item/projectile/hvp/proc/apply_special(atom/movable/AM, initial = FALSE)
	var/original_spec = special
	if(isitem(AM))
		var/obj/item/I = AM
		var/datum/component/radioactive/rads = I.GetComponent(/datum/component/radioactive)
		if(rads && rads.can_contaminate && rads.strength > rad_max)
			special |= HVP_RADIOACTIVE
			AddComponent(/datum/component/radioactive, rads.strength, src)

		if(I.is_sharp())
			special |= HVP_SHARP

		if(GLOB.hvp_bluespace[I.type])
			special |= HVP_BLUESPACE

		if(GLOB.hvp_bouncy[I.type])
			special |= HVP_BOUNCY

		if(GLOB.hvp_void[I.type])
			special |= HVP_VOID

		if(GLOB.hvp_sticky[I.type])
			special |= HVP_STICKY
			spin = 1
			update_animations()

	if(special != original_spec)
		return TRUE

/// Called when projectile runs out of momentum
/obj/item/projectile/hvp/proc/death_special(atom/movable/AM)
	if(istype(AM, /obj/item/reagent_containers) && !istype(AM, /obj/item/reagent_containers/food))
		var/datum/reagents/RH = locate() in AM
		if(RH?.total_volume)
			RH.expose_temperature(1000 * (p_heat / 10 + 1))
		return

	if(istype(AM, /obj/item/grenade))
		var/obj/item/grenade/G = AM
		G.prime() // Armour piercing high explosives :flushed:
		return

	if(istype(AM, /obj/item/transfer_valve))
		var/obj/item/transfer_valve/TV = AM
		TV.toggle_valve()

/obj/item/projectile/hvp/process_hit()
	return

/obj/item/projectile/hvp/on_hit()
	return

/obj/item/projectile/hvp/singularity_act()
	if(momentum) // moving projectiles have their own singulo interactions
		return
	..()

/obj/item/projectile/hvp/Exited(atom/movable/AM)
	. = ..()
	if(!contents.len)
		qdel(src)

/obj/item/projectile/hvp/pipe_eject(direction)
	if(velocity >= 1)
		launch(dir2angle(direction), 15) // not accurate

// --- debugs/adminbuse shots ---

/obj/item/projectile/hvp/debug
	desc = "Someone has probably angered the gods."
	velocity = 500
	mass = 5
	cangib = FALSE

/obj/item/projectile/hvp/debug/badmin
	velocity = 10000
	mass = 55
	cangib = TRUE

/obj/item/projectile/hvp/debug/badmin/chaos
	special = HVP_SHARP | HVP_BLUESPACE | HVP_BOUNCY

/obj/item/projectile/hvp/debug/sticky
	special = HVP_STICKY
	spin = 1

/obj/item/projectile/hvp/debug/New()
	..()
	launch(dir2angle(dir))

/obj/item/projectile/hvp/debug/sticky/New()
	..()
	update_animations()

#undef MAX_SHAKE
#undef BASE_SWITCH_RANGE
#undef MAX_SWITCH_RANGE
