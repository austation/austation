// TheFakeElon's funni high-velocity-projectile coilgun, warrenty void if projectiles supass lightspeed.

/obj/structure/disposalpipe/coilgun
	name = "coilgun tube"
	desc = "An electromagnetic tube that allows the safe transportation of high speed magnetic projectiles"
	icon = 'austation/icons/obj/atmospherics/pipes/disposal.dmi'
	layer = 2.45
	initialize_dirs = DISP_DIR_FLIP
	coilgun = TRUE
/obj/structure/disposalpipe/coilgun/transfer(obj/structure/disposalholder/H)
	if(!LAZYLEN(H.contents))
		qdel(H)
		return
	return ..()

// ---------- Magnetizer ----------

/obj/structure/disposalpipe/coilgun/magnetizer
	name = "magnetizer"
	desc = "A machine that glazes inserted objects with neodymium, making the object magnetic"
	icon_state = "magnet"

/obj/structure/disposalpipe/coilgun/magnetizer/transfer(obj/structure/disposalholder/H)
	if(LAZYLEN(H.contents) > 1)
		visible_message("<span class='warning'>\The [src] can't magnetize more than one object at a time!</span>")
		for(var/atom/movable/AM in H.contents)
			AM.forceMove(get_turf(src))
		playsound(src, 'sound/machines/buzz-two.ogg', 40, 1)
		qdel(H)
		return

	for(var/atom/movable/AM in H.contents)
		var/obj/effect/hvp/boolet
		if(istype(AM, /obj/effect/hvp))
			continue

		else
			boolet = new(H)
			boolet.name = AM.name
			boolet.desc = AM.desc
			boolet.icon = AM.icon
			boolet.icon_state = AM.icon_state
			boolet.p_speed = 1
			AM.loc = boolet //put the original inserted objected inside the coilgun projectile
			boolet.apply_special(AM, TRUE)
		if(isliving(AM))
			var/mob/living/L = AM
			L.adjustBruteLoss(10)
			L.reset_perspective(boolet)
			if(ishuman(L) && !isdead(L))
				L.Paralyze(amount = 50, ignore_canstun = TRUE)
				L.emote("scream")
				boolet.mass = 5 // The soul has weight.. or something..
				sleep(30)
			else
				boolet.mass = 4
			continue
		if(isitem(AM))
			var/obj/item/I = AM
			if(I.w_class)
				boolet.mass = I.w_class
				playsound(src.loc, 'sound/machines/ping.ogg', 40, 1)
				continue
			else
				qdel(boolet)
				qdel(I)
				return

	return ..()

// ---------- Cooler(s) ----------

/obj/structure/disposalpipe/coilgun/cooler
	name = "passive coilgun cooler"
	desc = "A densely packed array of radiator fins designed to passively remove heat from a magnetic projectile, slightly slows down the projectile"
	icon_state = "p_cooler"
	var/heat_removal = 2.5 // how much heat we will remove from the projectile
	var/linear_penalty = TRUE // do we multiply or negate speed_penalty from projectile speed?
	var/speed_penalty = 2 // multiplies/negates projectile speed by this
	var/hugbox = FALSE // debug/admin abuse

/obj/structure/disposalpipe/coilgun/cooler/active
	name = "active coilgun cooler"
	desc = "A tube with multiple small, fast fans used for cooling any projectile that passes through it. Much more effective than a passive cooler but slows the projectile down more"
	icon_state = "a_cooler"
	heat_removal = 3
	linear_penalty = FALSE
	speed_penalty = 0.97

/obj/structure/disposalpipe/coilgun/cooler/transfer(obj/structure/disposalholder/H)
	for(var/atom/movable/AM in H.contents) // run the loop below for every movable that passes through the charger
		if(istype(AM, /obj/effect/hvp)) // if it's a projectile, continue
			var/obj/effect/hvp/projectile = AM
			projectile.p_heat = max(projectile.p_heat - heat_removal, -50) // projectile's temp can't go below -50
			if(!hugbox)
				if(linear_penalty)
					projectile.p_speed -= speed_penalty
				else
					projectile.p_speed *= speed_penalty
		else // eject the item if it's none of the above
			visible_message("<span class='warning'>\The [src]'s safety mechanism engages, ejecting \the [AM] through the maintenance hatch!</span>")
			AM.forceMove(get_turf(src))
	return ..()

// ---------- Barrel ----------

/obj/structure/disposalpipe/coilgun/barrel
	name = "coilgun barrel"
	desc = "A sturdy pivotable barrel used to \"safely\" aim magnetic projectiles."
	icon_state = "barrel"
	var/current_angle = 0
	var/max_angle = 40 // max pivoting angle from it's pointed direction
	var/locked = FALSE // is this barrel free to move?
	var/image/barrel // Visual for barrel rotation
	var/barrel_icon_state = "barrel_vo"

/obj/structure/disposalpipe/coilgun/barrel/Initialize()
	. = ..()
	barrel = image(icon, barrel_icon_state)
	add_overlay(barrel)

/obj/structure/disposalpipe/coilgun/barrel/New()
	..()
	current_angle = dir2angle(dir)

/obj/structure/disposalpipe/coilgun/barrel/proc/ApplyAngle(new_angle)
	if(locked)
		return
	var/diff = new_angle - current_angle
	var/rotation_time = closer_angle_difference(current_angle, new_angle) / 2
	animate(barrel, transform = turn(matrix(), diff), time = rotation_time)
	current_angle = new_angle

/obj/structure/disposalpipe/coilgun/barrel/AltClick(mob/user)
	if(!user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	if(locked)
		to_chat(user, "<span class ='warning>\The [src]'s angle controls are locked!")
		return
	var/n_angle = input(user, "Enter desired barrel angle", "Barrel Angle", current_angle) as null|num
	if(n_angle)
		ApplyAngle(SIMPLIFY_DEGREES(n_angle), user)

/obj/structure/disposalpipe/coilgun/barrel/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click to change the current angle.</span>"
	var/offset = closer_angle_difference(current_angle, dir2angle(dir))
	if(offset)
		. += "The barrel's angle is currently offset by [offset] degrees."

/obj/structure/disposalpipe/coilgun/barrel/transfer(obj/structure/disposalholder/H)
	for(var/obj/effect/hvp/PJ in H.contents)
		PJ.p_speed *= 1.3
		PJ.dir = dir
		PJ.angle = dir2angle(dir) + current_angle
		PJ.forceMove(get_turf(src))
		PJ.launch()
	if(LAZYLEN(H.contents))
		expel(H, get_step(src, dir))
	else
		qdel(H)


// ---------- Bypass ----------
