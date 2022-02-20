#define MINEDRONE_COLLECT 1
#define MINEDRONE_ATTACK 2


/////////////////////////  INITIAL  STUFF  /////////////////////////


/mob/living/simple_animal/hostile/mining_drone
	var/beacons = 15  //  the minebot's personal inventory of marker beacons.  They must attack beacons in COLLECT mode to refill this
	var/emagged = FALSE  //  lets minebot shoot sentient life when set to TRUE
	var/obj/item/t_scanner/adv_mining_scanner/lesser/scanner  //  always on, the minebot has no way to turn this off
	weather_immunities = list("ash")

/mob/living/simple_animal/hostile/mining_drone/Initialize(mapload)
	..()
	stored_gun.overheat_time = 10
	scanner = new(src)
	scanner.toggle_on()
	var/datum/action/innate/minedrone/marker_beacon/beacon_action = new()
	beacon_action.Grant(src)


/////////////////////////  EMAG STUFF  /////////////////////////


/mob/living/simple_animal/hostile/mining_drone/emag_act()
	if(!emagged)
		emagged = TRUE
		visible_message("<span class='notice'>\The [src] whirrs loudly as critical safety functions are brought offline.</span>",
		"<span class='danger'>SYSTEM IRREGULARITIES DETECTED</span>\
		<span class='warning'>Automatic system directives unavailable.\
		Seek additional instructions from the nearest <b>SYNDICATE</b> personnel.</span>",
		"<span class='notice'>something whirrs loudly</span>")  //  first line goes to anyone who can see the minebot,  the 2nd-4th lines got to the minebot itself,  the 5th line goes to blind mobs
		icon_state = "mining_drone_offense"
	else
		to_chat(usr,"<span class='notice'>\the [src]'s safeties have already been removed.</span>")

/mob/living/simple_animal/hostile/mining_drone/SetCollectBehavior()
	..()
	if(emagged)
		icon_state = "mining_drone_offense"  //  emagged minebots can not disengage their aggressive sprite (but collecting ores works just fine)
		to_chat("<span class=warning>Your weapons are still visible, but not active</span>")  //  just incase the player is confused by their sprite remaining aggressive


/////////////////////////  EQUIPMENT  /////////////////////////


/obj/item/gun/energy/kinetic_accelerator/minebot/afterattack(atom/target, mob/living/user, flag, params)
	if(istype(target, /mob/living) && istype(user, /mob/living/simple_animal/hostile/mining_drone))  //  are we a minebot, firing at a mob?
		var/mob/living/M = target
		var/mob/living/simple_animal/hostile/mining_drone/H = user
		if(M.ckey && !H.emagged)  //  are we firing at sentient life without permission?
			to_chat(user, "<span class='warning'>Sentienct target detected; Engaging weapon lockdown.</span>")
			H.mode = MINEDRONE_COLLECT  //  let's turn off the guns, as the warning suggests
			return
	..()

/datum/action/innate/minedrone/marker_beacon
	name = "Drop Marker"
	button_icon_state = "mech_zoom_off"

/datum/action/innate/minedrone/marker_beacon/Activate()
	if (!istype(owner, /mob/living/simple_animal/hostile/mining_drone))  //  are we a minebot?
		return
	var/mob/living/simple_animal/hostile/mining_drone/M = owner
	if (!M.beacons)  //  got any beacons?
		to_chat(M, "<span class='warning'>You have no marker beacons remaining.</span>")
		return
	var/turf/T = get_turf(M)
	if(!T)  //  does the turf exist?
		to_chat(M, "<span class='warning'>There's nowhere to place the marker beacon!</span>")
		return
	if(locate(/obj/structure/marker_beacon) in T)  //  is there room for another beacon?
		to_chat(M, "<span class='warning'>There is already a marker beacon here.</span>")
		return
	M.beacons--
	var/obj/structure/marker_beacon/B = new(T)
	to_chat(M, "<span class='notice'>You place a [B].\
	You have [M.beacons] [B]s remaining.</span>")

/obj/structure/marker_beacon/attack_animal(mob/living/simple_animal/M)
	if (istype(M, /mob/living/simple_animal/hostile/mining_drone))  //  are we a minebot?
		var/mob/living/simple_animal/hostile/mining_drone/user = M
		if (user.mode == MINEDRONE_COLLECT)	  //  are we in collect mode? (in attack mode, we'll just attack it)
			if (user.beacons < 15)  //  do we have room for more?
				user.beacons++  //  increase our inventory
				to_chat(user, "<span class='notice'>You pick up the [src].\
				You have a total of [user.beacons] [src]s.</span>")
				qdel(src)  //  remove the beacon from the floor
				return
			else
				to_chat(user, "<span class='notice'>You already possess 15 [src]s!</span>")
	return ..()


/////////////////////////  ORES  STUFF  /////////////////////////


/mob/living/simple_animal/hostile/mining_drone/Move()
	. = ..()
	if (. && mode == MINEDRONE_COLLECT)  //  if we're collecting ore, we should do it automatically, not by clicking the ores
		CollectOre()

/mob/living/simple_animal/hostile/mining_drone/DropOre(message = 1)
	..()
	SetOffenseBehavior()  //  prevents the drone from picking up the ores again as it walks away
	to_chat(src, "<span class='notice'>You resume combat protocols.</span>")


/////////////////////////  TECHWEB  &  SPAWNING  /////////////////////////


/obj/effect/mob_spawn/minebot  //  what comes out of the minebot fab
	name = "unactivated minebot"
	desc = "A currently unactivated minebot. After activating, it may assist you in mining ores and fighting wildlife."
	icon = 'icons/mob/swarmer.dmi'
	icon_state = "swarmer_unactivated"
	density = FALSE  //  not already set, keep all this boring stuff in
	anchored = FALSE

	mob_type = /mob/living/simple_animal/hostile/mining_drone  //  what we're making
	mob_name = "a minebot"
	death = FALSE
	roundstart = FALSE
	short_desc = "You are a minebot, an expendable robot that supplies the station with ores."  //  printed in the spawner menu
	flavour_text = "You are a minebot, a cheap and expendable mining companion, the station's crew have activated you so that you will assist their mining operation.\
	Clicking while in combat mode will fire the PKA, a rock-breaking tool that will not target sentient creatures.\
	Moving while in collect mode will scoop up ores; release them by pressing the EJECT button.\
	Clicking marker beacons in collect mode will add them to your inventory.\
	You are immune to ash storms but be wary of lava pools.\
	Ask a nearby crewmember for upgrades to expand your potential.\
	\
	Directives:\
	1. Do not harm sentient life.  Your weapon is automatically disabled when targeting sentient life.\
	2. Follow instructions issued by Nanotrasen crewmembers, except where that would be injurious to sentient life.\
	3. Wherever possible, mine ores from the rock walls around you and deposit those ores into an Ore Redemption Machine."  //  printed when we spawn

/obj/effect/mob_spawn/minebot/attack_hand(mob/living/user)  //  you can't pick up a mob_spawn and at first this confused me;  leaving a warning for others
	. = ..()
	if(.)
		return
	to_chat(user, "<span class='notice'>it would be best to leave this alone while we wait for it to activate.</span>")

/obj/item/circuitboard/machine/minebot_fab  //  circuitboard for the minebot fab
	name = "Minebot shell dispenser (Machine Board)"
	icon_state = "supply"
	build_path = /obj/machinery/droneDispenser/minebot  //  our dispenser
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stack/sheet/glass = 5,
		/obj/item/stack/sheet/iron = 5)  //  5 glass and 5 iron is how much the machine starts with

/datum/design/board/minebot_fab  //  lets us print the circuitboard
	name = "Machine Design (Minebot Fabricator Board)"
	desc = "The circuit board for a Minebot Fabricator."
	id = "minebot_fab"
	build_path = /obj/item/circuitboard/machine/minebot_fab
	category = list ("Mining Designs")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_CARGO

/obj/machinery/droneDispenser/minebot  //  the fabricator to build our minebots;  builds up to 3 inert shells
	name = "minebot shell dispenser"
	desc = "A machine that will create mining robots when supplied with iron and glass."
	dispense_type = /obj/effect/mob_spawn/minebot
	iron_cost = 500  //  2.5 sheets of iron
	glass_cost = 500
	cooldownTime = 1800  //  3 minutes
	end_create_message = "dispenses a mining drone shell."
	starting_amount = 1000  //  we can make 2 minebots as soon as the machine is built, but a human will need to insert material to build more
	circuit = /obj/item/circuitboard/machine/minebot_fab

#undef MINEDRONE_COLLECT
#undef MINEDRONE_ATTACK
