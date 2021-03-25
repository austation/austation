/obj/structure/disposalpipe/coilgun/barrel
	name = "coilgun barrel"
	desc = "A sturdy pivotable barrel used to \"safely\" aim magnetic projectiles."
	icon_state = "barrel_base"
	var/current_angle = 0
	var/max_angle = 40 // max pivoting angle from it's pointed direction
	var/locked = FALSE // is this barrel free to move?
	var/obj/effect/barrel/coilgun_barrel/master_barrel // the barrel piece the barrel effect it cast from
	var/datum/barrel_builder/barrel
	var/barrel_length = 1
	var/cooldown = 0

/obj/structure/disposalpipe/coilgun/barrel/proc/update_barrel(mob/user, _angle, check_overlap = TRUE)
	var/turf/T = get_turf(src)
	var/turf/target = get_turf_in_angle(_angle, T, barrel_length)
	if(target.x == world.maxx || target.y == world.maxy) // barrels shouldn't be able to touch or get clamped to/by border turfs
		return FALSE
	if(check_overlap)
		var/path = getline(src, target)
		for(var/atom/A in path)
			if(A.density)
				return FALSE
	if(!barrel)
		if(!master_barrel)
			master_barrel = new(get_turf(src))
		barrel = new(master_barrel, _angle, barrel_length)
		barrel.build()
	return TRUE

/obj/structure/disposalpipe/coilgun/barrel/New()
	..()
	current_angle = dir2angle(dir)
	update_barrel(current_angle, FALSE)

/obj/structure/disposalpipe/coilgun/barrel/Destroy()
	QDEL_NULL(master_barrel)
	return ..()

/obj/structure/disposalpipe/coilgun/barrel/proc/ApplyAngle(mob/user, new_angle)
//	if(cooldown > world.time)
//		return
	cooldown = world.time + closer_angle_difference(current_angle, new_angle) * 10
	if(update_barrel(user, new_angle))
		current_angle = new_angle
	else
		visible_message("<span class='warning'>Rotation failed: Desired angle is obstructed.</span>")
		playsound(src, 'sound/machines/buzz-two.ogg', 40, 1)

/obj/structure/disposalpipe/coilgun/barrel/AltClick(mob/user)
	if(!user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	if(locked)
		to_chat(user, "<span class ='warning'>\The [src]'s angle controls are locked!.</span>")
		return
	var/relative_angle = closer_angle_difference(current_angle - dir2angle(dir))
	var/n_angle = (input(user, "Enter the desired barrel angle", "Barrel Angle", relative_angle) as null|num)
	if(abs(n_angle) >= 40)
		to_chat(user, "<span class ='warning'>\The [src] can't pivot more than [max_angle] degrees!</span>")
	else
		ApplyAngle(user, SIMPLIFY_DEGREES(n_angle + dir2angle(dir)))

/obj/structure/disposalpipe/coilgun/barrel/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click to change the current angle.</span>"
	var/offset = closer_angle_difference(current_angle, dir2angle(dir))
	if(offset)
		. += "The barrel is currently angled by [offset] degrees."

/// Barrel length has diminishing returns. Would not reccomend changing.
#define BASE_INACCURACY 11
#define DECAY_FACTOR 0.5

/obj/structure/disposalpipe/coilgun/barrel/transfer(obj/structure/disposalholder/H) // we need an angle relative to the world
	var/inaccuracy = round(EXP_DECAY(BASE_INACCURACY, DECAY_FACTOR, barrel_length), 0.05)
	for(var/obj/item/projectile/hvp/PJ in H.contents)
		PJ.velocity *= 1.33
		PJ.forceMove(get_turf(src))
		PJ.launch(current_angle, inaccuracy)
	if(LAZYLEN(H.contents)) // if there's anything else left in the barrel, throw it out
		expel(H, get_turf(src), angle2dir(current_angle))
	else
		qdel(H)

#undef BASE_INACCURACY
#undef DECAY_FACTOR

// ---- Barrel Overlay Visuals ----

/obj/effect/barrel
	anchored = TRUE
	appearance_flags = KEEP_TOGETHER | PIXEL_SCALE

/obj/effect/barrel/coilgun_barrel
	name = "coilgun barrel"
	icon = 'austation/icons/obj/atmospherics/pipes/disposal.dmi'
	icon_state = "barrel_ov"
