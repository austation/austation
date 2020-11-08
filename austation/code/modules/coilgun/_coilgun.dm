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
	var/speed_increase = 10 //how much speed the charger will add to the projectile
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
		if(!attached)
			to_chat(user, "<span class='warning'>\The [src] must be placed over an exposed, powered cable node!</span>")
		else
			START_PROCESSING(SSobj, src)
			to_chat(user, "<span class='notice'>You turn \the [src] on.</span>")
	else
		if(target_power_usage == 100)
			STOP_PROCESSING(SSobj, src)
			set_light(0)
			to_chat(user, "<span class='notice'>You turn \the [src] off.</span>")
		else
			target_power_usage += 20
			to_chat(user, "<span class='notice'>You set \the [src] to use [target_power_usage]% of the powernet's excess energy.</span>")


/obj/structure/disposalpipe/coilgun/charger/process()
	if(!attached)
		STOP_PROCESSING(SSobj, src)
		set_light(0)

	var/datum/powernet/PN = attached.powernet
	if(PN)
		if(current_power_use >= min_power_use)
			set_light(2)
			var/drained = min(current_power_use, attached.newavail()) // coilgun can't use any less than min_power_use
			attached.add_delayedload(drained)
		else
			set_light(1)

/obj/structure/disposalpipe/coilgun/charger/transfer()

