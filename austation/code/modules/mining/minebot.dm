#define MINEDRONE_COLLECT 1
#define MINEDRONE_ATTACK 2

/////////////////////////  INITIAL  STUFF  /////////////////////////
/mob/living/simple_animal/hostile/mining_drone
	var/beacons = 15  //maximum beacons that any one drone can drop
	var/emagged = FALSE  //lets minebot shoot sentient life
	var/obj/item/t_scanner/adv_mining_scanner/lesser/scanner //there is no code to turn this scanner off.
	weather_immunities = list("ash")

/mob/living/simple_animal/hostile/mining_drone/Initialize()
	. = ..()
	stored_gun.overheat_time = 10

	scanner = new(src)
	scanner.toggle_on()
	var/datum/action/innate/minedrone/marker_beacon/beacon_action = new()
	beacon_action.Grant(src)

	if(emagged)
		to_chat(src, "<span class='danger'>SYSTEM IRREGULARITIES DETECTED</span>")
		to_chat(src, "<span class='warning'>Automatic system directives unavailable.\nSeek additional instructions from the nearest <b>SYNDICATE</b> personnel.</span>")

/mob/living/simple_animal/hostile/mining_drone/emag_act()
	..()
	emagged = TRUE
	to_chat(src, "<span class='danger'>SYSTEM IRREGULARITIES DETECTED</span>")
	to_chat(src, "<span class='warning'>Directives offline \nSeek additional instructions from the nearest <b>SYNDICATE</b> personel.</span>")


/////////////////////////  EQUIPMENT  /////////////////////////


obj/item/gun/energy/kinetic_accelerator/minebot/afterattack(atom/target, mob/living/user, flag, params)
	if(istype(target, /mob/living) && istype(user, /mob/living/simple_animal/hostile/mining_drone))  //Are we a minebot, firing at a mob
		var/mob/living/M = target
		var/mob/living/simple_animal/hostile/mining_drone/H = user
		if((M.ckey) && (!H.emagged))  //Are we firing at sentient life without permission
			to_chat(user, "<span class='warning'>Invalid target.\nTarget is sentient.\nEngaging weapon lockdown.</span>")
			H.mode = MINEDRONE_COLLECT  //let's turn off the guns, just to be safe
			return
	..()

/datum/action/innate/minedrone/marker_beacon
	name = "Drop Marker"
	button_icon_state = "mech_zoom_off"

/datum/action/innate/minedrone/marker_beacon/Activate()
	if (!istype(owner, /mob/living/simple_animal/hostile/mining_drone))  //Are we a minebot
		return
	var/mob/living/simple_animal/hostile/mining_drone/M = owner
	if (!M.beacons)  //Got any beacons
		to_chat(M, "<span class='warning'>You have no marker beacons remaining.</span>")
		return
	var/turf/T = get_turf(M)
	if(!T)  //The turf exists, right?
		to_chat(M, "<span class='warning'>There's nowhere to place the marker beacon!</span>")
		return
	if(locate(/obj/structure/marker_beacon) in T)  //Is there room for another beacon
		to_chat(M, "<span class='warning'>There is already a marker beacon here.</span>")
		return
	M.beacons--
	var/obj/structure/marker_beacon/B = new(T)
	to_chat(M, "<span class='notice'>You place a [B].</span>")
	to_chat(M, "<span class='notice'>You have [M.beacons] [B]s remaining.</span>")

/obj/structure/marker_beacon/attack_animal(mob/living/simple_animal/M)
	if (istype(M, /mob/living/simple_animal/hostile/mining_drone))  //Are we a minebot
		var/mob/living/simple_animal/hostile/mining_drone/user = M
		if (user.mode == MINEDRONE_COLLECT)	  //Are we in collect mode (in attack mode, we'll just attack it)
			if (user.beacons < 15)  // Do we have room for more?
				user.beacons++  //Increase our inventory
				to_chat(user, "<span class='notice'>You pick up the [src].</span>")
				to_chat(user, "<span class='notice'>You have a total of [user.beacons] [src]s.</span>")
				qdel(src)  //Remove the beacon from the floor
				return
			else
				to_chat(user, "<span class='notice'>You already possess 15 [src]s!</span>")
	..()


/////////////////////////  ORES  STUFF  /////////////////////////


/mob/living/simple_animal/hostile/mining_drone/Move()
	..()
	if (. && mode == MINEDRONE_COLLECT) // if we're collecting ore, we should do it automatically, not by clicking the ores
		CollectOre()

/mob/living/simple_animal/hostile/mining_drone/DropOre(message = 1)
	..()
	SetOffenseBehavior() // prevents the drone from picking up the ores again as it walks away
	to_chat(src, "<span class='notice'>You resume combat protocols.</span>")


/////////////////////////  TECHWEB  &  SPAWNING  /////////////////////////


/obj/effect/mob_spawn/minebot  //what comes out of the minebot fab
	name = "unactivated minebot"
	desc = "A currently unactivated minebot. After activating, it may assist you in mining ores and fighting wildlife."
	icon = 'icons/mob/swarmer.dmi'
	icon_state = "swarmer_unactivated"
	density = FALSE  //not already set, keep all this boring stuff in
	anchored = FALSE

	mob_type = /mob/living/simple_animal/hostile/mining_drone  //what we're making
	mob_name = "a minebot"
	death = FALSE
	roundstart = FALSE
	short_desc = "You are a minebot, an expendable robot that supplies the station with ores."  //Printed in the spawner menu
	flavour_text = "You are a minebot, a cheap and expendable mining companion, the station's crew have activated you so that you will assist their mining operation. \
	Clicking while in combat mode will fire the PKA, a rock-breaking tool that will not target sentient creatures. \
	Moving while in collect mode will scoop up ores; release them by pressing the EJECT button. \
	Clicking marker beacons in collect mode will add them to your inventory. \
	You are immune to ash storms but be wary of lava pools. \
	Ask a nearby crewmember for upgrades to expand your potential. \
	 \
	Directives: \
	1. Do not harm sentient life.  Your weapon is automatically disabled when targeting sentient life. \
	2. Follow instructions issued by Nanotrasen crewmembers, except where that would be injurious to sentient life. \
	3. Wherever possible, mine ores from the rock walls around you and deposit those ores into an Ore Redemption Machine."  //Printed when we spawn

/obj/item/circuitboard/machine/minebot_fab  //Circuitboard for the minebot fab
	name = "Minebot shell dispenser (Machine Board)"
	icon_state = "supply"
	build_path = /obj/machinery/droneDispenser/minebot  //Our dispenser
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stack/sheet/glass = 5,
		/obj/item/stack/sheet/iron = 5)  //5 glass and 5 iron is how much the machine starts with

/datum/design/board/minebot_fab  //Lets us print the circuitboard
	name = "Machine Design (Minebot Fabricator Board)"
	desc = "The circuit board for a Minebot Fabricator."
	id = "minebot_fab"
	build_path = /obj/item/circuitboard/machine/minebot_fab
	category = list ("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_CARGO

/obj/machinery/droneDispenser/minebot  //The fabricator to build our minebots.  Builds up to 3 inert shells
	name = "minebot shell dispenser"
	desc = "A machine that will create mining robots when supplied with iron and glass."
	dispense_type = /obj/effect/mob_spawn/minebot
	iron_cost = 500  //2.5 sheets of iron
	glass_cost = 500
	cooldownTime = 600 // 1 minute
	end_create_message = "dispenses a mining drone shell."
	starting_amount = 1000  //We can make 2 minebots as soon as the machine is built, but we'll need more material to build more
	circuit = /obj/item/circuitboard/machine/minebot_fab

#undef MINEDRONE_COLLECT
#undef MINEDRONE_ATTACK
