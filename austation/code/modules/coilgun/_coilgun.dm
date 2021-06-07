// TheFakeElon's funni high-velocity-projectile coilgun. Keep away from master controller.

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
	if(LAZYLEN(H.contents))
		return ..()
	qdel(H)

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
			boolet.add_object(AM)
			boolet.velocity = 1
		playsound(src, 'sound/effects/spray.ogg', 40, 1)
		if(isliving(AM))
			var/mob/living/L = AM
			L.adjustBruteLoss(10)
			if(ishuman(L) && !isdead(L))
				L.Paralyze(amount = 50, ignore_canstun = TRUE)
				boolet.mass = 5 // The soul has weight. or something.
				for(var/i in 1 to rand(1, 3))
					playsound(src, 'sound/effects/spray.ogg', 40, 1)
					if(prob(50 - (i * 10)))
						INVOKE_ASYNC(L, /mob.proc/emote, "scream")
					sleep(rand(5, 10) - i)
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
	var/list/heatsinks = list()

/obj/structure/disposalpipe/coilgun/cooler/active
	name = "active coilgun cooler"
	desc = "Contains multiple small, high performance fans used for cooling anything that passes through it. Much more effective than a passive cooler but slows the projectile down more"
	icon_state = "a_cooler"
	base = 1.005
	heat_removal = 5

/obj/structure/disposalpipe/coilgun/cooler/transfer(obj/structure/disposalholder/H)
	for(var/atom/movable/AM in H.contents) // run the loop below for every movable that passes through the charger
		if(istype(AM, /obj/item/projectile/hvp)) // if it's a projectile, continue
			var/obj/item/projectile/hvp/PJ = AM
			PJ.p_heat = min(PJ.p_heat - (heat_removal * (heatsinks.len / 3)), -50)
			if(hugbox)
				continue
			PJ.velocity -= (base ** PJ.velocity) - 0.5
	return ..()


// ---------- Velocity Bypass ----------

/obj/structure/disposalpipe/coilgun/bypass
	name = "projectile velocity bypass"
	desc = "A junction with a configirable velocity at which to let a passing projectile through."
	icon_state = "bypass"
	initialize_dirs = DISP_DIR_LEFT | DISP_DIR_RIGHT
	var/speed_limit = 0

/obj/structure/disposalpipe/coilgun/bypass/AltClick(mob/user)
	if(!user.canUseTopic(src, !issilicon(user)))
		return
	speed_limit = max(input(user, "Enter the desired velocity requirement", "Bypass requirement", speed_limit) as num, 0)
	to_chat(user, "<span class='wnotice'>You set the bypass requirement to [speed_limit].")

/obj/structure/disposalpipe/coilgun/bypass/nextdir(obj/structure/disposalholder/H)
	var/flipdir = turn(H.dir, 180)
	if(dir == flipdir)
		return pick(turn(flipdir, 90), turn(flipdir, -90))
	for(var/atom/movable/AM in H)
		var/obj/item/projectile/hvp/PJ = AM
		if(!istype(PJ))
			continue
		if(speed_limit > PJ.velocity)
			break
		var/mask = dpdir & (~dir) // see disposal junctions for documentation (or lack there-of ;_;)
		for(var/D in GLOB.cardinals)
			if(D & mask)
				return D
	return dir
