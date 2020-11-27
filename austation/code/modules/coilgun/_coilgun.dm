
// TheFakeElon's funni projectile launcher

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

		icon_state = "amagnet"
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
				L.adjustBruteLoss(20)
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
					return

		icon_state = "magnet"

	return ..()

/obj/structure/disposalpipe/coilgun/charger
	name = "coilgun charger"
	desc = "A powered electromagnetic tube used to accelerate magnetive objects, requires the use of cooling units to prevent the projectile from overheating. Requires direct power connection to function"
	icon_state = "charger"

	var/enabled = FALSE // is the charger turned on?
	var/can_charge = FALSE // can we speed up the projectile
	var/speed_increase = 10 // how much speed the charger will add to the projectile
	var/heat_increase = 10 // how much the charger will heat up the projectile
	var/target_power_usage = 0 // the set percentage of excess power to be used by the charger
	var/current_power_use = 0 // how much power it is currently drawing
	var/min_power_use = 120000 // the lowest power it can use to function in watts
	var/max_power_use = INFINITY // the maximum amount of power the charger can draw in watts
	var/obj/structure/cable/attached // attached cable
	var/cps = 0 // current projectile speed, stored in a var fotr examining the charger

// because I don't want to make a GUI
/obj/structure/disposalpipe/coilgun/charger/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!enabled)
		var/turf/T = loc
		if(isturf(T) && !T.intact)
			attached = locate() in T
			if(!attached) // if we're not attached to a cable...
				to_chat(user, "<span class='warning'>\The [src] must be placed over an exposed, powered cable node!</span>")
			else
				START_PROCESSING(SSobj, src)
				enabled = TRUE
				to_chat(user, "<span class='notice'>You turn \the [src] on.</span>")
				return
		else
			to_chat(user, "<span class='warning'>\The [src] must be placed over an exposed, powered cable node!</span>")
	else // if we are!
		if(target_power_usage == 100) // if we are already using the max amount of power
			target_power_usage = 0
			STOP_PROCESSING(SSobj, src)
			set_light(0)
			to_chat(user, "<span class='notice'>You turn \the [src] off.</span>")
			enabled = FALSE
			return
		else // if we aren't, increase it by 20%
			target_power_usage += 20
			to_chat(user, "<span class='notice'>You set \the [src] to use [target_power_usage]% of the powergrid's excess energy.</span>")


/obj/structure/disposalpipe/coilgun/charger/process()
	if(!attached)
		STOP_PROCESSING(SSobj, src)
		set_light(0)

	var/datum/powernet/PN = attached.powernet
	if(PN)
		var/drained = clamp(min(current_power_use, attached.newavail()), min_power_use, max_power_use) // set our power use
		if(current_power_use > drained) // are we using more power than we have connected?
			visible_message("<span class='warning'>Insufficient power!</span>")
			can_charge = FALSE
		else
			attached.add_delayedload(drained) // apply our power use
			can_charge = TRUE
			set_light(2)

/obj/structure/disposalpipe/coilgun/charger/transfer(obj/structure/disposalholder/H)
	if(H.contents.len)
		if(can_charge) // do we have enough power?
			for(var/atom/movable/AM in H.contents) // run the loop below for every movable that passes through the charger
				if(istype(AM, /obj/effect/hvp)) // if it's a coilgun projectile, continue

					var/obj/effect/hvp/projectile = AM
					var/datum/powernet/PN = attached.powernet

					if(PN)
						var/prelim = (target_power_usage / 100) * (current_power_use / min_power_use) // (0-100 divided by 100) * (how much power we're using divided by the minimum power use)

						speed_increase = prelim * 0.5 ** projectile.p_speed
						projectile.p_speed += speed_increase // add speed to projectile
						projectile.p_heat += heat_increase // add heat to projectile
						projectile.on_transfer() // calls the "on_tranfer" proc for the projectile
						current_power_use = clamp(min_power_use + (projectile.p_speed * 500) * (projectile.p_heat * 0.5) * (target_power_usage / 100), min_power_use, max_power_use) //big scary line, determins power usage
						cps = round(projectile.p_speed)
						playsound(get_turf(src), 'sound/weapons/emitter2.ogg', 50, 1)
						visible_message("<span class='danger'>debug: speed increased by [speed_increase]!</span>")
						continue

				else if(isliving(AM)) // no non-magnetic hoomans
					var/mob/living/L = AM
					playsound(src.loc, 'sound/machines/buzz-two.ogg', 40, 1)
					visible_message("<span class='warning'>\The [src]'s safety mechanism engages, ejecting [L] through the maintenance hatch!</span>")
					L.forceMove(get_turf(src))
					continue

				else // eject the item if it's none of the above
					visible_message("<span class='warning'>\The [src]'s safety mechanism engages, ejecting \the [AM] through the maintenance hatch!</span>")
					AM.forceMove(get_turf(src))
					continue
	else
		qdel(H)

	return ..()

/obj/structure/disposalpipe/coilgun/charger/examine(mob/user)
	. = ..()
	if(cps)
		. += "<span class='info'>The projectile speed indicator reads: [cps]km/h.</span>"
	else
		. += "<span class='info'>No moving projectile detected.</span>"

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
			if(isliving(AM)) // no non-magnetic hoomans
				var/mob/living/L = AM
				playsound(src.loc, 'sound/machines/buzz-two.ogg', 40, 1)
				L.adjustBruteLoss(25)
				L.emote("scream")
				visible_message("<span class='warning'>\The [src]'s safety mechanism engages, ejecting [L] through the maintenance hatch!</span>")
				L.forceMove(get_turf(src))
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
