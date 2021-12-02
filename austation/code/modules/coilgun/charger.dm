// The base used for calculating charger projectile speed increase
// lower values make speed increases more diminishing
#define BASE 0.9975

// the smallest amount of power the charger can use to function in watts.
// Also serves as the base divider for projectile speed increase, lower values will increase speed gain
#define POWER_DIVIDER 10000

// divider for super chargers
#define SUPER_POWER_DIVIDER 1000

// Coilgun Charger

/obj/structure/disposalpipe/coilgun/charger
	name = "coilgun charger"
	desc = "A powered electromagnetic tube used to accelerate magnetive projectiles, requires the use of cooling units to prevent the projectile from overheating. Requires direct power connection to function"
	icon_state = "charger"
	coilgun = TRUE
	var/enabled = FALSE // is the charger turned on?
	var/modifier = 1 // Speed multiplier
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

/obj/structure/disposalpipe/coilgun/charger/proc/H_power_failure(force = FALSE)
	target_power_usage = max(target_power_usage - 20, 0)
	if(target_power_usage > 0)
		visible_message("<span class='warning'>\The [src]'s power warning light flickers, throttling to [target_power_usage]%!</span>")
	else
		visible_message("<span class='warning'>\The [src]'s power warning light fades, turning itself off.</span>")
		enabled = FALSE

/obj/structure/disposalpipe/coilgun/charger/transfer(obj/structure/disposalholder/H)
	if(!enabled)
		return ..()
	var/turf/T = get_turf(src)
	attached = T.get_cable_node()
	if(!attached)
		H_power_failure(TRUE)
		return ..()
	for(var/atom/movable/AM as() in H.contents) // run the loop below for every movable that passes through the charger
		if(istype(AM, /obj/item/projectile/hvp)) // if it's a coilgun projectile, continue
			var/obj/item/projectile/hvp/PJ = AM
			if(attached.powernet && target_power_usage)
				var/prelim = attached.delayed_surplus() / POWER_DIVIDER
				if(prelim < 1)
					H_power_failure()
					return ..()
				var/power_percent = target_power_usage * 0.01
				var/speed_increase = (prelim * BASE ** PJ.velocity) * power_percent
				PJ.velocity += round(speed_increase / PJ.mass * modifier, 1)
				PJ.p_heat += heat_increase * power_percent
				PJ.charger_act()
				cps = round(PJ.velocity * 3.6, 1) // m/s to km/h
				playsound(src, 'sound/effects/bamf.ogg', 50, 1)
				current_power_use = PJ.velocity * 25 * prelim
				attached.add_delayedload(current_power_use * power_percent)
				H.count = 1000
				continue
		else // no non-magnetic items allowed in the coilgun :(
			playsound(src, 'sound/machines/buzz-two.ogg', 100, 1)
			visible_message("<span classl='warning'>\The [src]'s safety mechanism engages, ejecting [AM] through the maintenance hatch!</span>")
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


// ----- Super Charger -----

// like normal base def, but for the supercharger
#define SUPER_BASE 0.999

/obj/structure/disposalpipe/coilgun/super_charger
	name = "coilgun super-charger"
	desc = "A powered electromagnetic tube used to accelerate magnetive projectiles, has a much larger speed increase but requires coilgun capacitors to function"
	icon_state = "supercharger"
	var/total_charge = 0

/obj/structure/disposalpipe/coilgun/super_charger/transfer(obj/structure/disposalholder/H)
	if(!length(H.contents))
		qdel(H)
		return
	for(var/obj/item/projectile/hvp/PJ in H.contents)
		for(var/D in GLOB.cardinals)
			var/obj/machinery/power/capacitor/C = locate() in get_step(src, D)
			total_charge += C.charge / GLOB.CELLRATE
			C.charge = 0
		if(total_charge)
			PJ.velocity += round(((total_charge / SUPER_POWER_DIVIDER) * (SUPER_BASE ** PJ.velocity)) / PJ.mass, 1)
			PJ.p_heat += 40
			H.count = 1000
			PJ.charger_act()
			total_charge = 0
			playsound(src, 'austation/sound/machines/coilgun_super.ogg', 100, 1)
	return ..()

// ----- Capacitor -----
// The max speed capacitors can recharge (watts) per second
#define CAPACITOR_RECHARGE 50000

/obj/machinery/power/capacitor
	name = "coilgun capacitor"
	desc = "A high current capacitor capable of rapidly discharging power to adjacent coilgun <b>super-chargers</b>."
	icon = 'austation/icons/obj/power.dmi'
	icon_state = "capacitor"
	circuit = /obj/item/circuitboard/machine/coilgun_capacitor
	density = TRUE
	var/charge = 0 // joules
	var/capacity = 1e6
	var/obj/structure/cable/attached

/obj/machinery/power/capacitor/Initialize()
	. = ..()
	STOP_PROCESSING(SSmachines, src)
	connect_to_network()

/obj/machinery/power/capacitor/connect_to_network()
	var/turf/T = get_turf(src)
	attached = T.get_cable_node()
	return attached

/obj/machinery/power/capacitor/interact(mob/user)
	add_fingerprint(user)
	if(!attached.powernet)
		to_chat(user, "<span class='warning'>\The [src] must be placed over an exposed, powered cable node!</span>")
		return
	if(!check_use())
		return
	var/processing = datum_flags & DF_ISPROCESSING
	if(processing)
		to_chat(user, "<span class='notice'>\The [src] is no longer charging.</span>")
		STOP_PROCESSING(SSmachines, src)
	else
		to_chat(user, "<span class='notice'>You set [src]'s power setting to charge.</span>")
		playsound(src, 'austation/sound/machines/AC_hum.ogg', 100, TRUE)
		START_PROCESSING(SSmachines, src)
	log_game("Capacitor turned [processing ? "OFF" : "ON"] by [key_name(user)] in [AREACOORD(src)]")
	playsound(src, 'sound/machines/click.ogg', 100, TRUE)

/obj/machinery/power/capacitor/proc/check_use()
	return !(stat & BROKEN) && anchored

/obj/machinery/power/capacitor/process(delta_time)
	if(charge >= capacity || !check_use())
		return
	if(!attached || attached.loc != loc)
		connect_to_network()
		if(!attached)
			return
	var/input = clamp(attached.surplus() * 0.05, 0, CAPACITOR_RECHARGE * delta_time)
	if(input)
		charge = min(input * GLOB.CELLRATE + charge, capacity)
		attached.add_load(input)

// TODO: this is bad but I can't remember why, fix it >:(
/obj/machinery/power/capacitor/wrench_act(mob/user, obj/item/I)
	if(anchored)
		if(default_unfasten_wrench(user, I))
			disconnect_from_network()
	else
		if(!connect_to_network())
			to_chat(user, "<span class='warning'>\The [src] must be placed over an exposed, powered cable node!</span>")
			return
		setAnchored(TRUE)
		to_chat(user, "<span class='notice'>You bolt [src] to the floor and attach it to the cable.</span>")
	return TRUE

/obj/machinery/power/capacitor/can_be_unfasten_wrench(mob/user, silent)
	if(datum_flags & DF_ISPROCESSING)
		if(!silent)
			to_chat(user, "<span class='warning'>You need to disable \the [src] first!</span>")
		return FAILED_UNFASTEN
	return ..()

/obj/machinery/power/capacitor/examine(mob/user)
	. = ..()
	. += "<span class='notice'>The charge meter reads: <b>[DisplayJoules(charge)]/[DisplayJoules(capacity)]</b>.</span>"
	. += "<span class='notice'><i>[round(charge/capacity*100, 0.5)]% charged.</i></span>"

#undef BASE
#undef POWER_DIVIDER
#undef SUPER_POWER_DIVIDER
#undef SUPER_BASE
#undef CAPACITOR_RECHARGE
