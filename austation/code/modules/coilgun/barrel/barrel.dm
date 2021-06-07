/obj/structure/disposalpipe/coilgun/barrel
	name = "coilgun barrel"
	desc = "A sturdy pivotable barrel used to \"safely\" aim magnetic projectiles."
	icon_state = "barrel_base"
	var/current_angle = 0
	var/max_traverse = 40 // maxinum deviation from original direction
	var/locked = FALSE // is this barrel free to move?
	var/moving = FALSE
	var/obj/effect/barrel/coilgun_barrel/master_barrel // the barrel piece the barrel effect it cast from
	var/datum/barrel_builder/barrel
	var/barrel_length = 1
	var/cooldown = 0

/obj/structure/disposalpipe/coilgun/barrel/New()
	..()
	current_angle = dir2angle(dir)
	update_barrel(current_angle, 0)

/obj/structure/disposalpipe/coilgun/barrel/proc/update_barrel(_angle, animate_duration, check_collision = TRUE, initial = FALSE)
	var/turf/T = get_turf(src)
	var/turf/target = get_turf_in_angle(_angle, T, barrel_length)
	if(target.x == world.maxx || target.y == world.maxy) // barrels shouldn't be able to touch or get clamped by border turfs
		return FALSE
	if(check_collision && !check_overlap(target))
		return FALSE
	if(!barrel)
		if(!master_barrel)
			master_barrel = new(get_turf(src))
			master_barrel.parent = src
		barrel = new(master_barrel, _angle, barrel_length)
		barrel.build()
	else
		moving = TRUE
		barrel.rotate(_angle, animate_duration)
		sleep(animate_duration)
		moving = FALSE
	return TRUE

/obj/structure/disposalpipe/coilgun/barrel/proc/check_overlap(_angle, target)
	if(!target)
		target = get_turf_in_angle(_angle, get_turf(src), barrel_length)
	var/path = getline(get_turf(src), target)
	for(var/atom/A in path)
		if(A.density)
			return FALSE
	return TRUE

/obj/structure/disposalpipe/coilgun/barrel/Destroy()
	QDEL_NULL(barrel)
	QDEL_NULL(master_barrel)
	return ..()

/obj/structure/disposalpipe/coilgun/barrel/proc/ApplyAngle(mob/user, new_angle)
	var/delay = abs(closer_angle_difference(current_angle, new_angle) * 2) * barrel_length // used for cooldown & animation time
	if(cooldown > world.time || moving)
		to_chat(user, "<span class ='warning'>\The [src] can't be rotated right now!</span>")
		return
	if(update_barrel(new_angle, delay))
		current_angle = new_angle
		cooldown = world.time + delay
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
	var/n_angle = round(input(user, "Enter the desired barrel angle", "Barrel Angle", relative_angle) as null|num, 0.5)
	if(abs(n_angle) > max_traverse)
		to_chat(user, "<span class ='warning'>\The [src] can't pivot more than [max_traverse] degrees!</span>")
	else
		ApplyAngle(user, SIMPLIFY_DEGREES(n_angle + dir2angle(dir)))

/obj/structure/disposalpipe/coilgun/barrel/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click to change the current angle.</span>"
	var/offset = closer_angle_difference(current_angle, dir2angle(dir))
	if(offset)
		. += "The barrel is currently offset by [offset] degree\s."

/// Barrel length has diminishing returns. Would not reccomend changing.
#define BASE_INACCURACY 10
#define DECAY_FACTOR 0.5

/obj/structure/disposalpipe/coilgun/barrel/transfer(obj/structure/disposalholder/H)
	var/inaccuracy = round(EXP_DECAY(BASE_INACCURACY, DECAY_FACTOR, barrel_length), 0.05)
	for(var/obj/item/projectile/hvp/PJ in H.contents)
		if(moving)
			visible_message("<span class='danger'>\The [src]'s barrel piece breaks as it tries to fire a projectile while rotating!</span>")
			playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
			inaccuracy += 10
			PJ.launch(current_angle, inaccuracy)
			qdel(src)
			return
		if(!barrel)
			playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
			PJ.launch(current_angle, inaccuracy)
			return
		PJ.launch(current_angle, inaccuracy, src, barrel_length)
		playsound(src, 'sound/magic/disable_tech.ogg', 100, 1, 5) // imagine using audacity
		playsound(src, 'sound/magic/wandodeath.ogg', 50, 1, 2)
		playsound(src, 'sound/effects/seedling_chargeup.ogg', 50, 1)
	if(LAZYLEN(H.contents)) // if there's anything else left in the barrel, throw it out
		expel(H, get_turf(src), angle2dir(current_angle))
	else
		qdel(H)

/obj/structure/disposalpipe/coilgun/barrel/deconstruct(disassembled = TRUE)
	..()
	barrel_length = initial(barrel_length)

#undef BASE_INACCURACY
#undef DECAY_FACTOR

// ---- Barrel Overlay Effect ----

/obj/effect/barrel
	anchored = TRUE
	appearance_flags = KEEP_TOGETHER | PIXEL_SCALE
	var/atom/parent // the object we're connected to
	var/break_parent_on_death = TRUE // do we destroy the connected object if we're destroyed?

/obj/effect/barrel/coilgun_barrel
	name = "coilgun barrel"
	icon = 'austation/icons/obj/atmospherics/pipes/disposal.dmi'
	icon_state = "barrel_ov"

// so you don't need to click the tiny pixels inbetween the overlay and the base connection
/obj/effect/barrel/coilgun_barrel/AltClick(mob/user)
	parent?.AltClick(user)

/obj/effect/barrel/coilgun_barrel/Destroy()
	if(parent && break_parent_on_death)
		QDEL_NULL(parent)
	return ..()
