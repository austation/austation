// The base used for calculating projectile speed increase
// lower values make speed increases more diminishing
#define BASE 0.9975

// the smallest amount of power the charger can use to function in watts.
#define POWER_DIVIDER 100000

/obj/structure/disposalpipe/coilgun/charger
	name = "coilgun charger"
	desc = "A powered electromagnetic tube used to accelerate magnetive projectiles, requires the use of cooling units to prevent the projectile from overheating. Requires direct power connection to function"
	icon_state = "charger"
	coilgun = TRUE
	var/enabled = FALSE // is the charger turned on?
	var/can_charge = FALSE // can we speed up the projectile
	var/speed_increase = 10 // how much speed the charger will add to the projectile
	var/heat_increase = 10 // how much the charger will heat up the projectile
	var/target_power_usage = 0 // the set percentage of excess power to be used by the charger
	var/current_power_use = 0 // how much power it is currently drawing
	var/max_power_use = INFINITY // the maximum amount of power the charger can draw in watts
	var/obj/structure/cable/attached // attached cable
	var/cps = 0 // current projectile speed, stored in a var for examining the charger

// needed for charger linking

// because I don't want to make a GUI
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


/obj/structure/disposalpipe/coilgun/charger/proc/power_process()
	power_processing = TRUE
	if(current_power_use && target_power_usage && attached?.powernet)
		for(var/i in 1 to 50)
			var/drained = min(current_power_use / (target_power_usage / 100), max_power_use) // set our power use
			visible_message("<span class='warning'>Drained reads [drained]!</span>") // DEBUG
			attached.add_delayedload(drained) // apply our power use to the connected wire
			if(attached.newavail() < drained) // are we using more power than we have connected?
				target_power_usage -= 20 // throttle it down
				if(target_power_usage > 0)
					visible_message("<span class='warning'>\The [src]'s power warning light flickers, lowering throttle to [target_power_usage]!</span>")
					continue
				else
					can_charge = FALSE
					visible_message("<span class='warning'>\The [src]'s power warning fades, shutting the charger down!</span>")
					break
			else
				current_power_use = drained
				continue
	power_processing = FALSE

/obj/structure/disposalpipe/coilgun/charger/transfer(obj/structure/disposalholder/H)
	if(H.contents.len)
		if(enabled && can_charge && attached) // is this enabled, do we have enough power?
			for(var/obj/effect/hvp/PJ in H.contents) // run the loop below for every movable that passes through the charger
				if(istype(AM, /obj/effect/hvp)) // if it's a coilgun projectile, continue

					var/obj/effect/hvp/PJ = AM
					if(attached.powernet && target_power_usage)
						var/prelim = (current_power_use + POWER_DIVIDER) / POWER_DIVIDER
						visible_message("<span class='danger'>debug: prelim reads [prelim]!</span>") // DEBUG
						speed_increase = prelim * BASE ** PJ.p_speed
						PJ.p_speed += speed_increase * members.len
						PJ.p_heat += heat_increase * members.len
						PJ.on_transfer()
						cps = round(PJ.p_speed * 10)
						playsound(get_turf(src), 'sound/weapons/emitter2.ogg', 50, 1)
						visible_message("<span class='danger'>debug: speed increased by [speed_increase]!</span>")
						current_power_use = max(PJ.p_speed * 5, 1000)
						if(!power_processing)
							INVOKE_ASYNC(src, .proc/power_process)
						H.count = 1000 // resets the amount of moves the disposalholder has left
						continue

				else // no non-magnetic items allowed in the coilgun :(
					playsound(src.loc, 'sound/machines/buzz-two.ogg', 40, 1)
					visible_message("<span class='warning'>\The [src]'s safety mechanism engages, ejecting [AM] through the maintenance hatch!</span>")
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
	if(current_power_use)
		. += "<span class='info'>The power indicator reads: [DisplayPower(current_power_use)].</span>"

#undef BASE
#undef POWER_DIVIDER
