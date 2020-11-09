#define MEGAWATTS /1e+6

// autism rod launching thingo mibob
/obj/structure/disposalpipe/coilgun
	name = "coilgun tube"
	desc = "A special tube that allows the safe transportation of high speed magnetic projectiles"
	icon = 'austation/icons/obj/railgun.dmi'
	icon_state = "coil"

/obj/structure/disposalpipe/coilgun/magnetizer
	name = "magnetizer"
	desc = "A machine that glazes inserted objects with neodymium, making the object magnetive"
	icon = 'austation/icons/obj/railgun.dmi'
	icon_state = "magnet"


/obj/structure/disposalpipe/coilgun/magnetizer/transfer(obj/structure/disposalholder/H) // what do you mean it looks like loafer code?

	if(H.contents.len) // is there an object in here?

		icon_state = "amagnet"
		update_icon()
		var/obj/item/projectile/coilshot/boolet =  new(H)

		for(var/atom/movable/AM in H.contents)
			if(AM == boolet)
				continue

			if(isliving(AM))
				var/mob/living/L = AM
				L.adjustBruteLoss(30)
				if(ishuman(L) && !isdead(L))
					L.Paralyze(amount = 50, ignore_canstun = TRUE)
					L.emote("scream")
					boolet.mass == 5
					sleep(30)
					continue

			if(isitem(AM))
				var/obj/item/I = AM
				if(I.w_class)
					boolet.mass == I.w_class
					playsound(src.loc, 'sound/machines/ping.ogg', 40, 1)
					continue
				else
					qdel(boolet)
					qdel(I)
					continue

			boolet.name = AM.name
			boolet.desc = AM.desc
			boolet.icon = AM.icon
			boolet.icon_state = AM.icon_state
			AM.loc = boolet //put the original inserted objected inside the coilgun projectile to drop on deletion



	return ..()

/obj/structure/disposalpipe/coilgun/charger
	name = "coilgun charger"
	desc = "A powered electromagnetic tube used to accelerate magnetive objects, use cooling units to prevent the projectile from overheating. Requires direct power connection to function"
	icon = 'austation/icons/obj/railgun.dmi'
	icon_state = "charger"
	var/enabled = FALSE // is the charger turned on?
	var/can_charge = FALSE // can we speed up the projectile
	var/speed_increase = 10 // how much speed the charger will add to the projectile
	var/heat_increase = 10 // how much the charger will heat up the projectile
	var/target_power_usage = 0 // the set percentage of excess power to be used by the charger
	var/current_power_use = 0 // how much power it is currently drawing
	var/min_power_use = 120 // the lowest power it can use to function in watts
	var/max_power_use = INFINITY // the maximum amount of power the charger can draw in watts
	var/obj/structure/cable/attached // attached cable

/obj/structure/disposalpipe/coilgun/charger/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!enabled)
		if(!attached) // if we're not attached to a cable...
			to_chat(user, "<span class='warning'>\The [src] must be placed over an exposed, powered cable node!</span>")
		else
			START_PROCESSING(SSobj, src)
			to_chat(user, "<span class='notice'>You turn \the [src] on.</span>")
	else // if we are!
		if(target_power_usage == 100) // if we are already using the max amount of power
			STOP_PROCESSING(SSobj, src)
			set_light(0)
			to_chat(user, "<span class='notice'>You turn \the [src] off.</span>")
		else // if we aren't, increase it by 20%
			target_power_usage += 20
			to_chat(user, "<span class='notice'>You set \the [src] to use [target_power_usage]% of the powernet's excess energy.</span>")


/obj/structure/disposalpipe/coilgun/charger/process()
	if(!attached)
		STOP_PROCESSING(SSobj, src)
		set_light(0)

	var/datum/powernet/PN = attached.powernet
	if(PN)
		if(current_power_use >= min_power_use) // coilgun can't use any less than min_power_use
			can_charge == TRUE
			set_light(2)
			var/drained = min(current_power_use, attached.newavail()) // set our power use
			if(current_power_use > drained)
				visible_message("<span class='warning'>Insufficient power!</span>")
				can_charge == FALSE
			attached.add_delayedload(drained) // apply our power use
		else
			can_charge == FALSE
			set_light(1) // dim the light if we don't have enough power to use the charger

/obj/structure/disposalpipe/coilgun/charger/transfer()

	if(H.contents.len)
		if(can_charge)
			var/obj/item/projectile/coilshot/projectile
			for(var/atom/movable/AM in H.contents) // run the loop below for every movable that passes through the charger
				if(AM == projectile) // if it's a projectile, continue
					var/datum/powernet/PN = attached.powernet
					if(PN)
						speed_increase == target_power_usage / 100 // what percentage of speed_increase to apply
						projectile.speed += speed_increase // add speed to projectile
						projectile.heat += heat_increase // add heat to projectile
						projectile.on_transfer() // calls the "on_tranfer" proc for the projectile
						current_power_use == clamp(min_power_use + (projectile.speed * 0.5) * (projectile.heat * 0.5) * (target_power_usage / 100), min_power_use, max_power_use) //big scary line, determins power usage
						continue
				if(isliving(AM)) // no non-magnetic hoomans
					var/mob/living/L = AM
					playsound(src.loc, 'sound/machines/buzz-two.ogg', 40, 1)
					visible_message("<span class='warning'>\The [src]'s safety mechanism engages, ejecting [L] through the maintenance hatch!</span>")
					L.forceMove(get_turf(src))
					continue

				else // eject the item if it's none of the above
					visible_message("<span class='warning'>\The [src]'s safety mechanism engages, ejecting \the [AM] through the maintenance hatch!</span>")
					AM.forceMove(get_turf(src))
					continue
			if(!H.contents)
				qdel(H)
				return
	return ..()

