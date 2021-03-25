// ---------- Barrel ----------
#define BARREL_EXTRA_TURF_RANGE 10
/obj/effect/barrel
	anchored = TRUE
	appearance_flags = KEEP_TOGETHER | PIXEL_SCALE

/obj/effect/barrel/coilgun_barrel
	name = "coilgun barrel"
	icon = 'austation/icons/obj/atmospherics/pipes/disposal.dmi'
	icon_state = "barrel_ov"
//	mouse_opacity = MOUSE_OPACITY_ICON

// Builds a cosmetic overlay chain from a specified parent object
/datum/barrel_builder
	var/atom/movable/parent // The object we're going to build the barrel from
	var/angle = 0
	var/length
	var/increment = 32
	var/po_x
	var/po_y // pixel offsets applied after the barrel is built
	var/num_barrels = 0
	var/max_barrels = 1 // for multi barrel building
	var/list/parts = list()

/datum/barrel_builder/New(_parent, _angle, _length, _pox, _poy)
	parent = _parent
	angle = _angle
	length = _length
	po_x = _pox
	po_y= _poy

/datum/barrel_builder/proc/build()
	num_barrels++
	if(!parent || !length)
		return FALSE
	if(num_barrels > max_barrels)
		for(var/B in parts)
			qdel(B)
		num_barrels--
		parts.len = 0
		parent.cut_overlays()

	for(var/L in 0 to length)
		var/place_distance = (L+1) * increment
		// TODO: check for Z level borders
		var/mutable_appearance/bpart = mutable_appearance(parent.icon, parent.icon_state, MOB_LAYER + 1)
		bpart.appearance_flags = KEEP_TOGETHER
		var/matrix/M = matrix()
		switch(parent.dir)
			if(NORTH)
				bpart.pixel_y += place_distance
			if(SOUTH)
				bpart.pixel_y -= place_distance
				M.Turn(180)
			if(EAST)
				bpart.pixel_x += place_distance
				M.Turn(90)
			if(WEST)
				bpart.pixel_x -= place_distance
				M.Turn(270)
		bpart.transform = M
		parent.add_overlay(bpart, TRUE)
	parent.transform.Translate(po_x, po_y)

/datum/barrel_builder/proc/rotate(_angle, animate = FALSE)
	if(_angle == angle)
		return
	if(parent)
		var/diff = closer_angle_difference(angle, _angle)
		var/matrix/M = turn(parent.transform, diff)
		if(animate)
			animate(parent, transform = M, time = diff / 40)
		else
			parent.transform = turn(parent.transform, diff)
		return TRUE

/datum/barrel_builder/proc/remove()
	parent.cut_overlay(parts)
	qdel(src)

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

/obj/structure/disposalpipe/coilgun/barrel/transfer(obj/structure/disposalholder/H) // we need an angle relative to the world
	for(var/obj/item/projectile/hvp/PJ in H.contents)
		PJ.velocity *= 1.33
		PJ.forceMove(get_turf(src))
		PJ.launch(current_angle)
	if(LAZYLEN(H.contents)) // if there's anything else left in the barrel, throw it out
		expel(H, get_turf(src), angle2dir(current_angle))
	else
		qdel(H)
