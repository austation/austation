
// TheFakeElon's funni high-velocity-projectile launcher

/obj/structure/disposalpipe/coilgun
	name = "coilgun tube"
	desc = "An electromagnetic tube that allows the safe transportation of high speed magnetic projectiles"
	icon = 'austation/icons/obj/atmospherics/pipes/disposal.dmi'
	layer = 2.45
	initialize_dirs = DISP_DIR_FLIP
	coilgun = TRUE

/obj/structure/disposalpipe/coilgun/magnetizer
	name = "magnetizer"
	desc = "A machine that glazes inserted objects with neodymium, making the object magnetive"
	icon_state = "magnet"

/obj/structure/disposalpipe/coilgun/magnetizer/transfer(obj/structure/disposalholder/H) // what do you mean it looks like loafer code?

	if(H.contents.len) // is there an object in here?

		update_icon()
		var/obj/effect/hvp/boolet

		for(var/atom/movable/AM in H.contents)
			if(AM == boolet)
				continue
			else
				boolet = new(H)
				boolet.name = AM.name
				boolet.desc = AM.desc
				boolet.icon = AM.icon
				boolet.icon_state = AM.icon_state
				boolet.p_speed = 1
				AM.loc = boolet //put the original inserted objected inside the coilgun projectile

			if(isliving(AM))
				var/mob/living/L = AM
				L.adjustBruteLoss(10)
				if(ishuman(L) && !isdead(L))
					L.Paralyze(amount = 50, ignore_canstun = TRUE)
					L.emote("scream")
					boolet.mass = 5
					sleep(30)
					continue
				else
					boolet.mass = 3
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
					qdel(H)
					return

	else
		qdel(H)

	return ..()

// passive cooler
/obj/structure/disposalpipe/coilgun/cooler
	name = "passive coilgun cooler"
	desc = "A densely packed array of radiator fins designed to passively remove heat from a magnetic projectile, slightly slows down the projectile"
	icon_state = "p_cooler"
	var/heat_removal = 2.5 // how much heat we will remove from the projectile
	var/speed_penalty = 0.985 // multiplies projectile speed by this
	var/hugbox = FALSE

/obj/structure/disposalpipe/coilgun/cooler/transfer(obj/structure/disposalholder/H)
	if(H.contents.len)
		for(var/atom/movable/AM in H.contents) // run the loop below for every movable that passes through the charger
			if(istype(AM, /obj/effect/hvp)) // if it's a projectile, continue
				var/obj/effect/hvp/projectile = AM
				projectile.p_heat -= heat_removal
				if(!hugbox)
					projectile.p_speed = projectile.p_speed * speed_penalty
				continue
			else // eject the item if it's none of the above
				visible_message("<span class='warning'>\The [src]'s safety mechanism engages, ejecting \the [AM] through the maintenance hatch!</span>")
				AM.forceMove(get_turf(src))
				continue
	return ..()

/obj/structure/disposalpipe/coilgun/cooler/active
	name = "active coilgun cooler"
	desc = "A tube with multiple small, fast fans used for cooling any projectile that passes through it. Much more effective than a passive cooler but slows the projectile down more"
	icon = 'austation/icons/obj/atmospherics/pipes/disposal.dmi'
	icon_state = "a_cooler"
	heat_removal = 5
	speed_penalty = 0.95
