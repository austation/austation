#define MINEDRONE_COLLECT 1
#define MINEDRONE_ATTACK 2

/mob/living/simple_animal/hostile/mining_drone/Initialize()
	. = ..()
	weather_immunities += "ash" // no damage from ash storms
	stored_gun.overheat_time = 10


/obj/item/slimepotion/slime/sentience/mining
	name = "minebot AI upgrade"
	desc = "Can be used to grant sentience to minebots."
	icon_state = "door_electronics"
	icon = 'icons/obj/module.dmi'
	sentience_type = SENTIENCE_MINEBOT

/obj/item/slimepotion/slime/sentience/mining/after_success(mob/living/user, mob/living/simple_animal/SM)
	return // player drones are able to be upgraded with better HP and attack, unlike on Bee.  Removes all the code that nerfed player minebots

/mob/living/simple_animal/hostile/mining_drone/Move()
	. = ..()
	if(. && mode == MINEDRONE_COLLECT) // if we're collecting ore, we should do it automatically, not by clicking the ores
		CollectOre()

/mob/living/simple_animal/hostile/mining_drone/DropOre(message = 1)
	. = ..()
	mode = MINEDRONE_ATTACK // prevents the drone from picking up the ores again as it walks away
	to_chat(src, "<span class='notice'>You resume combat protocols.</span>")

/obj/item/drone_shell/minebot
	name = "drone shell"
	desc = "A shell of a mining drone, an expendable robot built to mine lavaland."
	icon = 'icons/mob/drone.dmi'
	icon_state = "drone_maint_hat"//yes reuse the _hat state.
	layer = BELOW_MOB_LAYER

	drone_type = /mob/living/simple_animal/hostile/mining_drone //Type of drone that will be spawned
	seasonal_hats = FALSE //If TRUE, and there are no default hats, different holidays will grant different hats

/obj/machinery/droneDispenser/minebot //Please forgive me
	name = "minebot shell dispenser"
	desc = "A machine that will create mining robots when supplied with iron and glass."
	dispense_type = /obj/item/drone_shell/minebot
	iron_cost = 500
	glass_cost = 500
	cooldownTime = 600 // 1 minute
	end_create_message = "dispenses a mining drone shell."
	starting_amount = 6000

/obj/item/drone_shell/minebot/attack_ghost(mob/user) // Can't use the drone sentience proc because minebots aren't a child of drone
	if(is_banned_from(user.ckey, ROLE_DRONE) || QDELETED(src) || QDELETED(user))
		return
	if(CONFIG_GET(flag/use_age_restriction_for_jobs))
		if(!isnum_safe(user.client.player_age)) //apparently what happens when there's no DB connected. just don't let anybody be a drone without admin intervention
			return
		if(user.client.player_age < DRONE_MINIMUM_AGE)
			to_chat(user, "<span class='danger'>You're too new to play as a drone! Please try again in [DRONE_MINIMUM_AGE - user.client.player_age] days.</span>")
			return
	if(!SSticker.mode)
		to_chat(user, "Can't become a drone before the game has started.")
		return
	var/be_drone = alert("Become a minebot? (Warning, You can no longer be cloned!)",,"Yes","No")
	if(be_drone == "No" || QDELETED(src) || !isobserver(user))
		return
	var/mob/living/simple_animal/hostile/mining_drone/D = new drone_type(get_turf(loc))
	D.key = user.key
	message_admins("[ADMIN_LOOKUPFLW(user)] has taken possession of \a [src] in [AREACOORD(src)].")
	log_game("[key_name(user)] has taken possession of \a [src] in [AREACOORD(src)].")
	qdel(src)
	var/obj/item/implant/radio/imp = new(src)
	imp.implant(D, user)

#undef MINEDRONE_COLLECT
#undef MINEDRONE_ATTACK
