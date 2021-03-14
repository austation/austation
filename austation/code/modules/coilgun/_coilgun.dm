// TheFakeElon's funni high-velocity-projectile coilgun, warrenty void if projectiles supass lightspeed.

/obj/structure/disposalpipe/coilgun
	name = "coilgun tube"
	desc = "An electromagnetic tube that allows the safe transportation of high speed magnetic projectiles"
	icon = 'austation/icons/obj/atmospherics/pipes/disposal.dmi'
	layer = 2.45
	initialize_dirs = DISP_DIR_FLIP
	coilgun = TRUE

	FASTDMM_PROP(\
		pipe_interference_group = list("disposal"),\
		pipe_group = "disposal",\
		pipe_type = PIPE_TYPE_SIMPLE\
	)

/obj/structure/disposalpipe/coilgun/transfer(obj/structure/disposalholder/H)
	if(!LAZYLEN(H.contents))
		qdel(H)
		return
	return ..()

// ---------- Magnetizer ----------

/obj/structure/disposalpipe/coilgun/magnetizer
	name = "magnetizer"
	desc = "A complicated machine that glazes inserted objects with neodymium, making it magnetically conductive. Used for the production of coilgun projectiles"
	icon_state = "magnet"

/obj/structure/disposalpipe/coilgun/magnetizer/transfer(obj/structure/disposalholder/H)
	if(LAZYLEN(H.contents) > 1)
		visible_message("<span class='warning'>\The [src] can't magnetize more than one object at a time!</span>")
		for(var/atom/movable/AM in H.contents)
			AM.forceMove(get_turf(src))
			AM.throw_at(get_step(src, dir), 1, 1)
		playsound(src, 'sound/machines/buzz-two.ogg', 40, 1)
		qdel(H)
		return

	for(var/atom/movable/AM in H.contents)
		var/obj/item/projectile/hvp/boolet
		if(istype(AM, /obj/item/projectile/hvp))
			continue

		else
			boolet = new(H)
			boolet.name = AM.name
			boolet.desc = AM.desc
			boolet.icon = AM.icon
			boolet.icon_state = AM.icon_state
			boolet.velocity = 1
			AM.forceMove(boolet) //put the original inserted objected inside the coilgun projectile
			boolet.apply_special(AM, TRUE)
		if(isliving(AM))
			var/mob/living/L = AM
			L.adjustBruteLoss(10)
			L.reset_perspective(boolet)
			if(ishuman(L) && !isdead(L))
				L.Paralyze(amount = 50, ignore_canstun = TRUE)
				L.emote("scream")
				boolet.mass = 5 // The soul has weight. or something.
				sleep(20)
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
	var/base = 1.003
	var/hugbox = FALSE // enabling will disable the velocity loss

/obj/structure/disposalpipe/coilgun/cooler/active
	name = "active coilgun cooler"
	desc = "Contains multiple small, high performance fans used for cooling anything that passes through it. Much more effective than a passive cooler but slows the projectile down more"
	icon_state = "a_cooler"
	heat_removal = 5

/obj/structure/disposalpipe/coilgun/cooler/transfer(obj/structure/disposalholder/H)
	for(var/atom/movable/AM in H.contents) // run the loop below for every movable that passes through the charger
		if(istype(AM, /obj/item/projectile/hvp)) // if it's a projectile, continue
			var/obj/item/projectile/hvp/PJ = AM
			PJ.p_heat = min(PJ.p_heat - heat_removal, -50)
			if(hugbox)
				continue
			PJ.velocity -= (base ** PJ.velocity) - 0.5
	return ..()


// ---------- Barrel ----------
#define BARREL_EXTRA_TURF_RANGE 10

/obj/effect/ebeam/coilgun_barrel
	name = "coilgun barrel"
	icon_state = "barrel_vo"
	anchored = TRUE

/datum/beam/barrel
	var/barrel_len = 0

/datum/beam/barrel/afterDraw()
	mouse_opacity = origin.mouse_opacity // modular override for parent mouse opacity
	while(elements.len > barrel_len)
		qdel(pop(elements))

/obj/structure/disposalpipe/coilgun/barrel
	name = "coilgun barrel"
	desc = "A sturdy pivotable barrel used to \"safely\" aim magnetic projectiles."
	icon_state = "barrel"
	var/current_angle = 0
	var/max_angle = 40 // max pivoting angle from it's pointed direction
	var/locked = FALSE // is this barrel free to move?
	var/datum/beam/barrel/barrel // Visual for barrel and it's rotation
	var/barrel_length = 1
	var/barrel_icon_state = "barrel_ov"
	var/barrel_type = /obj/effect/ebeam/coilgun_barrel
	var/cooldown = 0

/obj/structure/disposalpipe/coilgun/barrel/Initialize()
	. = ..()
	update_barrel()

// It looks dumb but I promise it's needed for readability ;_;
#define GET_ANGLE_TURF(M) ( get_turf_in_angle(_angle, T, barrel_length + M ))

/obj/structure/disposalpipe/coilgun/barrel/proc/update_barrel(_angle, check_overlap = TRUE)
	var/turf/T = get_turf(src)
	if(check_overlap)
		var/path = getline(src, GET_ANGLE_TURF(0))
		for(var/atom/A in path)
			if(A.density)
				return FALSE
	if(barrel)
		barrel.End()
	barrel = new(src, GET_ANGLE_TURF(10), icon, barrel_icon_state, null, barrel_length + 10, barrel_type)
	barrel.Draw()
	return TRUE

#undef GET_ANGLE_TURF

/obj/structure/disposalpipe/coilgun/barrel/New()
	..()
	current_angle = dir2angle(dir)

/obj/structure/disposalpipe/coilgun/barrel/Destroy()
	. = ..()
	QDEL_NULL(barrel)

/obj/structure/disposalpipe/coilgun/barrel/proc/ApplyAngle(new_angle)
	cooldown = closer_angle_difference(current_angle, new_angle) * 10
	if(update_barrel(new_angle))
		current_angle = new_angle
	else
		visible_message("<span class='warning'>Rotation failed: Desired angle is obstructed.</span>")
		playsound(src, 'sound/machines/buzz-two.ogg', 40, 1)

/obj/structure/disposalpipe/coilgun/barrel/AltClick(mob/user)
	if(!user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	if(locked)
		to_chat(user, "<span class ='warning>\The [src]'s angle controls are locked!")
		return
	var/relative_angle = closer_angle_difference(current_angle - dir2angle(dir))
	var/n_angle = (input(user, "Enter the desired barrel angle", "Barrel Angle", relative_angle) as null|num)
	if(abs(n_angle) >= 40)
		to_chat(user, "<span class ='warning>\The [src] can't pivot more than [max_angle] degrees!")
	else
		ApplyAngle(SIMPLIFY_DEGREES(n_angle + current_angle), user)

/obj/structure/disposalpipe/coilgun/barrel/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click to change the current angle.</span>"
	var/offset = closer_angle_difference(current_angle, dir2angle(dir))
	if(offset)
		. += "The barrel's angle is currently offset by [offset] degrees."

/obj/structure/disposalpipe/coilgun/barrel/transfer(obj/structure/disposalholder/H) // we need an angle relative to the world
	for(var/obj/item/projectile/hvp/PJ in H.contents)
		PJ.velocity *= 1.33
		PJ.forceMove(get_turf(src))
		PJ.launch(current_angle)
	if(LAZYLEN(H.contents)) // if there's anything else left in the barrel, throw it out
		expel(H, get_turf(src), angle2dir(current_angle))
	else
		qdel(H)

// ---------- Speed Bypass ----------
