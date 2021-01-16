// The base used for calculating projectile speed increase
// lower values make speed increases more diminishing
#define BASE 0.9975
// the smallest amount of power the charger can use to function in watts.
#define POWER_DIVIDER 100000
// The max speed capacitors can recharge
#define CAPACITOR_RECHARGE 50000


// Coilgun Charger

/obj/structure/disposalpipe/coilgun/charger
	name = "coilgun charger"
	desc = "A powered electromagnetic tube used to accelerate magnetive projectiles, requires the use of cooling units to prevent the projectile from overheating. Requires direct power connection to function"
	icon_state = "charger"
	coilgun = TRUE
	var/enabled = FALSE // is the charger turned on?
	var/can_charge = TRUE // can we speed up the projectile
	var/speed_increase = 10 // how much speed the charger will add to the projectile
	var/heat_increase = 10 // how much the charger will heat up the projectile
	var/target_power_usage = 0 // the set percentage of excess power to be used by the charger
	var/current_power_use = 0 // how much power it is currently drawing
	var/max_power_use = INFINITY // the maximum amount of power the charger can draw in watts
	var/obj/structure/cable/attached // attached cable
	var/cps = 0 // current projectile speed, stored in a var for examining the charger
	var/power_ticks = 0

/obj/structure/disposalpipe/coilgun/charger/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(enabled)
		if(target_power_usage >= 100)
			enabled = FALSE
			target_power_usage = 0
			to_chat(user, "<span class='notice'>You turn off \the [src].</span>")
		else
			target_power_usage += 20
			to_chat(user, "<span class='notice'>You increase \the [src]'s power throttle to [target_power_usage]%</span>")
	else
		enabled = TRUE
		to_chat(user, "<span class='notice'>You turn on \the [src].</span>")

/obj/structure/disposalpipe/coilgun/charger/process()
	power_ticks++
	if(current_power_use && target_power_usage && attached?.powernet)
		var/drained = min(current_power_use / (target_power_usage / 100), max_power_use) // set our power use
		visible_message("<span class='warning'>Drained reads [drained]!</span>") // DEBUG
		attached.add_delayedload(drained) // apply our power use to the connected wire
		if(attached.newavail() < drained) // are we using more power than we have connected?
			target_power_usage -= 20 // throttle it down
			if(target_power_usage > 0)
				visible_message("<span class='warning'>\The [src]'s power warning light flickers, lowering throttle to [target_power_usage]!</span>")
			else
				can_charge = FALSE
				visible_message("<span class='warning'>\The [src]'s power warning fades, shutting the charger down!</span>")
				STOP_PROCESSING(SSobj, src)
		else
			current_power_use = drained
			can_charge = TRUE
	else
		can_charge = FALSE
		STOP_PROCESSING(SSobj, src)
	if(power_ticks >= 10)
		power_ticks = 0
		STOP_PROCESSING(SSobj, src)

/obj/structure/disposalpipe/coilgun/charger/proc/can_transfer(obj/structure/disposalholder/H)
	if(!LAZYLEN(H.contents))
		qdel(H)
		return
	if(!attached)
		var/turf/T = loc
		attached = T.get_cable_node()
	if(!can_charge)
		current_power_use = 0
		process() // runs through the process proc once to see if there is sufficient power
	if(!(enabled && target_power_usage && can_charge && attached)) // is this enabled, do we have enough power?
		return
	return TRUE

/obj/structure/disposalpipe/coilgun/charger/transfer(obj/structure/disposalholder/H)
	if(!can_transfer(H))
		return ..()
	for(var/atom/movable/AM in H.contents) // run the loop below for every movable that passes through the charger
		if(istype(AM, /obj/effect/hvp)) // if it's a coilgun projectile, continue

			var/obj/effect/hvp/PJ = AM

			if(attached.powernet && target_power_usage)
				var/prelim = max(attached.delayed_surplus() / POWER_DIVIDER, 1)
				visible_message("<span class='danger'>debug: prelim reads [prelim]!</span>") // DEBUG
				speed_increase = prelim * BASE ** PJ.p_speed
				PJ.p_speed += speed_increase
				PJ.p_heat += heat_increase
				PJ.on_transfer()
				cps = round(PJ.p_speed / 3.6)
				playsound(get_turf(src), 'sound/weapons/emitter2.ogg', 50, 1)
				visible_message("<span class='danger'>debug: speed increased by [speed_increase]!</span>")
				current_power_use = max(PJ.p_speed * 25 * prelim, 1000)
				START_PROCESSING(SSobj, src)
				H.count = 1000 // resets the amount of moves the disposalholder has left
				continue
		else // no non-magnetic items allowed in the coilgun :(
			playsound(src.loc, 'sound/machines/buzz-two.ogg', 40, 1)
			visible_message("<span class='warning'>\The [src]'s safety mechanism engages, ejecting [AM] through the maintenance hatch!</span>")
			AM.forceMove(get_turf(src))
			continue

	return ..()

/obj/structure/disposalpipe/coilgun/charger/examine(mob/user)
	. = ..()
	if(cps)
		. += "<span class='info'>The projectile speed indicator reads: [cps]km/h.</span>"
	else
		. += "<span class='info'>No moving projectile detected.</span>"
	if(current_power_use)
		. += "<span class='info'>The power indicator reads: [DisplayPower(current_power_use)].</span>"

// Coilgun Super Charger

/obj/structure/disposalpipe/coilgun/super_charger
	name = "coilgun super-charger"
	desc = "A powered electromagnetic tube used to accelerate magnetive projectiles, has a much larger speed increase but requires coilgun capacitors to function"
	icon_state = "supercharger"
	var/total_charge = 0

/obj/structure/disposalpipe/coilgun/super_charger/transfer(obj/structure/disposalholder/H)
	if(!can_transfer)
		return ..()
	for(var/atom/movable/AM in H.contents)
		if(istype(AM, /obj/effect/hvp))
			var/obj/effect/hvp/PJ = AM
			for(var/obj/machinery/power/coilgun/capacitor/C in range(1, src))
				total_charge += C.charge
				C.charge = 0
			if(total_charge)
				var/prelim = min(total_charge / 10000, 1) // 10KW increases the speed by 1.
				var/speed_increase = prelim * BASE ** PJ.p_speed
				PJ.p_speed += speed_increase
				PJ.p_heat += 10
				visible_message("<span class='danger'>debug: speed increased by [speed_increase]!</span>")
				H.count = 1000
				total_charge = 0

// Coilgun capacitor

/obj/machinery/power/coilgun/capacitor
	name = "coilgun capacitor"
	desc = "A high current capacitor capable of discharging sufficient power to adjacent coilgun super-chargers"
	icon = 'austation/icons/obj/power.dmi'
	icon_state = "capicitor"
	var/charge = 0
	var/capacity = 2e6

/obj/machinery/power/coilgun/capacitor/interact(mob/user)
	. = ..()
	if(datum_flags & DF_ISPROCESSING)
		to_chat(user, "<span class='notice'>You disable \the [src].</span>")
		STOP_PROCESSING(SSobj, src)
	else
		to_chat(user, "<span class='notice'>You set \the [src] to charge mode.</span>")
		START_PROCESSING(SSobj, src)

/obj/machinery/power/coilgun/capacitor/process()
	if(charge >= capacity || !powernet || stat & BROKEN || !anchored)
		return
	var/input = clamp(surplus(), 0, CAPACITOR_RECHARGE)
	if(input)
		charge = min(input+charge, capacity)
		add_load(input)

/obj/machinery/power/coilgun/capacitor/attackby(obj/item/I, mob/user)
	if(I.tool_behaviour == TOOL_WRENCH)
/*		if(active)
			to_chat(user, "<span class='warning'>You need to deactivate \the [src] first!</span>")
			return */
		if(anchored)
			if(default_unfasten_wrench(user, I))
				disconnect_from_network()
				return
		else
			if(!connect_to_network())
				to_chat(user, "<span class='warning'>\The [src] must be placed over an exposed, powered cable node!</span>")
				return
			setAnchored(TRUE)
			to_chat(user, "<span class='notice'>You bolt \the [src] to the floor and attach it to the cable.</span>")
	else
		return ..()

/obj/machinery/power/coilgun/capacitor/can_be_unfasten_wrench(mob/user, silent)
	if(datum_flags & DF_ISPROCESSING)
		if(!silent)
			to_chat(user, "<span class='warning'>Turn \the [src] off first!</span>")
		return FAILED_UNFASTEN
	return ..()

/obj/machinery/power/coilgun/capacitor/examine(mob/user)
	. = ..()
	. += "<span class='notice'>The charge meter reads: [DisplayPower(charge)].</span>"

#undef BASE
#undef POWER_DIVIDER
