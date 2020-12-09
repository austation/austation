
// The base used for calculating speed increase
// lower values make speed increases more diminishing
#define BASE 0.9975

// the smallest amount of power the charger can use to function in watts.
#define POWER_DIVIDER 100000

/obj/structure/disposalpipe/coilgun/charger
	name = "coilgun charger"
	desc = "A powered electromagnetic tube used to accelerate magnetive projectiles, requires the use of cooling units to prevent the projectile from overheating. Requires direct power connection to function"
	icon_state = "charger"

	var/enabled = FALSE // is the charger turned on?
	var/can_charge = FALSE // can we speed up the projectile
	var/speed_increase = 10 // how much speed the charger will add to the projectile
	var/heat_increase = 10 // how much the charger will heat up the projectile
	var/target_power_usage = 0 // the set percentage of excess power to be used by the charger
	var/current_power_use = 0 // how much power it is currently drawing
	var/max_power_use = INFINITY // the maximum amount of power the charger can draw in watts
	var/obj/structure/cable/attached // attached cable
	var/cps = 0 // current projectile speed, stored in a var for examining the charger
	var/list/members = list()
	var/parent = null // used for linking coilgun chargers, what charger is parent?
	var/is_child = FALSE // is this linked to a parent?
	var/laststep // used in charger chain building, stops infinite loops. did we just run the proc on this pipe?
	var/power_process = FALSE // are we currently processing power?

// because I don't want to make a GUI

/obj/structure/disposalpipe/coilgun/charger/New()
	parent = src
	members += src
/obj/structure/disposalpipe/coilgun/charger/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(enabled)
		if(check_power(parent))
			if(target_power_usage >= 100)
				enabled = FALSE
				target_power_usage = 0
				to_chat(user, "<span class='notice'>You turn off \the [src].</span>")
			else
				target_power_usage += 20
				to_chat(user, "<span class='notice'>You increase \the [src]'s power to [target_power_usage]%</span>")
		else
			to_chat(user, "<span class='warning'>No power!</span>")
	else
		enabled = TRUE
		to_chat(user, "<span class='notice'>You turn on \the [src].</span>")

	if(members.len <= 1 && parent == src) // if it's not a child or parent of another object, try to connect nearby chargers
		build_charger(parent)
	update_chargers(parent) //sync the connected charger's settings

/// updates the chargers connected to the parent
/obj/structure/disposalpipe/coilgun/charger/proc/update_chargers(obj/structure/disposalpipe/coilgun/charger/P)
	for(var/obj/structure/disposalpipe/coilgun/charger/C in P.members)
		C.target_power_usage = target_power_usage
		C.enabled = enabled
		C.attached = attached

// C for child, P for parent.
/// Finds all chargers connected to the parent and makes them members
/obj/structure/disposalpipe/coilgun/charger/proc/build_charger(obj/structure/disposalpipe/coilgun/charger/P)
	var/obj/structure/disposalpipe/coilgun/charger/C
	for(var/turf/T in range(1, loc)) // for every tile next to the charger
		C = locate() in T // checks said
		if(C && C.dpdir == dpdir && (!C.parent || C.parent == C) && C.laststep != laststep)
			if(laststep == C)
				continue
			laststep = src
			if(!(C in P.members))
				P.members += C
				C.parent = P
			C.visible_message("<span class='warning'>Debug: building charger...</span>")
			C.build_charger(P)
			C.visible_message("<span class='warning'>Debug: synced with parent!</span>")

/obj/structure/disposalpipe/coilgun/charger/proc/check_power(obj/structure/disposalpipe/coilgun/charger/P)
	for(var/obj/structure/disposalpipe/coilgun/charger/C in P.members)
		var/turf/T = loc
		if(isturf(T) && !T.intact)
			attached = locate() in T
			if(attached)
				return TRUE

	return FALSE

/obj/structure/disposalpipe/coilgun/charger/proc/power_process(ticks)
	power_process = TRUE
	for(, ticks > 0, ticks--)
		stoplag()
		if(current_power_use)
			if(attached)
				var/datum/powernet/PN = attached.powernet
				if(PN)
					var/drained = min(min(current_power_use, attached.newavail()), max_power_use) // set our power use
					visible_message("<span class='warning'>Drained reads [drained]!</span>")
					attached.add_delayedload(drained) // apply our power use
					if(current_power_use > drained) // are we using more power than we have connected?
						visible_message("<span class='warning'>Insufficient power!</span>")
						current_power_use = drained
						return
					else
						can_charge = TRUE
						continue
		else
			return
		// if we didn't return, disable the charger
		enabled = FALSE
		return
	power_process = FALSE // when the loop ends, allow the proc to be called again

/// called every time an object passes through the pipe
/obj/structure/disposalpipe/coilgun/charger/transfer(obj/structure/disposalholder/H)
	if(H.contents.len)
		if(can_charge) // do we have enough power?
			for(var/atom/movable/AM in H.contents) // run the loop below for every movable that passes through the charger
				if(istype(AM, /obj/effect/hvp)) // if it's a coilgun projectile, continue

					var/obj/effect/hvp/P = AM
					var/datum/powernet/PN = attached.powernet

					if(PN && target_power_usage)
						var/prelim = (target_power_usage / 100) * ((current_power_use + POWER_DIVIDER) / POWER_DIVIDER)
						visible_message("<span class='danger'>debug: prelim reads [prelim]!</span>")
						current_power_use = min((P.p_speed * 500) * (target_power_usage / 100), max_power_use) //determins power usage
						speed_increase = prelim * BASE ** P.p_speed
						P.p_speed += speed_increase // add speed to projectile
						P.p_heat += heat_increase // add heat to projectile
						P.on_transfer() // calls the "on_tranfer" proc for the projectile
						cps = round(P.p_speed * 10)
						playsound(get_turf(src), 'sound/weapons/emitter2.ogg', 50, 1)
						visible_message("<span class='danger'>debug: speed increased by [speed_increase]!</span>")
						if(!power_process)
							INVOKE_ASYNC(src, .proc/power_process, 100)
						H.count = 1000 // resets the amount of moves the disposalholder has
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
			can_charge = check_power(parent)
	else
		qdel(H)

	return ..()

/obj/structure/disposalpipe/coilgun/charger/examine(mob/user)
	. = ..()
	if(cps)
		. += "<span class='info'>The projectile speed indicator reads: [cps]km/h.</span>"
	else
		. += "<span class='info'>No moving projectile detected.</span>"

#undef BASE
#undef POWER_DIVIDER
