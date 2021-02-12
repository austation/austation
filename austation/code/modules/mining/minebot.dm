#define MINEDRONE_COLLECT 1
#define MINEDRONE_ATTACK 2

/mob/living/simple_animal/hostile/mining_drone
	var/beacons = 15
	var/default_hatmask
	var/obj/item/t_scanner/adv_mining_scanner/lesser/scanner //there is no code to turn this scanner off.

/mob/living/simple_animal/hostile/mining_drone/Initialize()
	. = ..()
	weather_immunities += "ash" // no damage from ash storms
	stored_gun.overheat_time = 10

	scanner = new(src)
	scanner.toggle_on()
	var/datum/action/innate/minedrone/marker_beacon/beacon_action = new()
	beacon_action.Grant(src)

/datum/action/innate/minedrone/marker_beacon
	name = "Drop Marker"
	button_icon_state = "mech_zoom_off"

/datum/action/innate/minedrone/marker_beacon/Activate()
	var/mob/living/simple_animal/hostile/mining_drone/M = owner
	if((!M.beacons) || (GLOB.total_beacons >= GLOB.max_beacons)) //check that we have marker beacons left, but also that there are not 100 in the world already
		to_chat(M, "<span class='warning'>You can not place another beacon!</span>")
		return
	M.beacons--
	var/obj/structure/marker_beacon/B = new(get_turf(owner))
	to_chat(M, "<span class='notice'>You place a [B].</span>")
	to_chat(M, "<span class='notice'>You have [M.beacons] beacons remaining.</span>")

/obj/item/slimepotion/slime/sentience/mining
	name = "minebot AI upgrade"
	desc = "Can be used to grant sentience to minebots."
	icon_state = "door_electronics"
	icon = 'icons/obj/module.dmi'
	sentience_type = SENTIENCE_MINEBOT

/obj/item/slimepotion/slime/sentience/mining/after_success(mob/living/user, mob/living/simple_animal/SM)
	return // Overrides the beecode that prevents player minebots from being upgraded.

/mob/living/simple_animal/hostile/mining_drone/Move()
	. = ..()
	if(. && mode == MINEDRONE_COLLECT) // if we're collecting ore, we should do it automatically, not by clicking the ores
		CollectOre()

/mob/living/simple_animal/hostile/mining_drone/DropOre(message = 1)
	..()
	SetOffenseBehavior() // prevents the drone from picking up the ores again as it walks away
	to_chat(src, "<span class='notice'>You resume combat protocols.</span>")

/obj/item/drone_shell/minebot
	name = "mining drone shell"
	desc = "The shell of a mining drone; an expendable robot built to mine on lavaland."

	drone_type = /mob/living/simple_animal/hostile/mining_drone //Type of drone that will be spawned
	seasonal_hats = FALSE //If TRUE, and there are no default hats, different holidays will grant different hats

/obj/item/circuitboard/machine/minebot_fab
	name = "Minebot shell dispenser (Machine Board)"
	icon_state = "supply"
	build_path = /obj/machinery/droneDispenser/minebot
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stack/sheet/glass = 5,
		/obj/item/stack/sheet/iron = 5)

/datum/design/board/minebot_fab
	name = "Machine Design (Minebot Fabricator Board)"
	desc = "The circuit board for a Minebot Fabricator."
	id = "minebot_fab"
	build_path = /obj/item/circuitboard/machine/minebot_fab
	category = list ("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_CARGO

/obj/machinery/droneDispenser/minebot
	name = "minebot shell dispenser"
	desc = "A machine that will create mining robots when supplied with iron and glass."
	dispense_type = /obj/item/drone_shell/minebot
	iron_cost = 500
	glass_cost = 500
	cooldownTime = 600 // 1 minute
	end_create_message = "dispenses a mining drone shell."
	starting_amount = 1000
	circuit = /obj/item/circuitboard/machine/minebot_fab


/obj/item/drone_shell/minebot/attack_ghost(mob/user)
	to_chat(user,"<span class='userdanger'>Minebots are mining assistants. \nYou are subservient to all intelligent life except other minebots. \nGather ores and defend miners.</span>")
	..()

#undef MINEDRONE_COLLECT
#undef MINEDRONE_ATTACK
