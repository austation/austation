
/datum/uplink_item/dangerous/deathsky
	name = "Admiral Deathsky"
	desc = "Provides a delivery beacon for a highly advanced model of a griefsky. \
			This deadly bot is equipped with 2 pulse rifles, advanced projectile deflection AI and much stronger armour. \
			Will attack anyone, including operatives, STAY AWAY ONCE DEPLOYED!"
	item = /obj/item/sbeacondrop/deathsky
	cost = 18
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/role_restricted/bluespace_sharpener
	name = "Bluespace Whetstone"
	desc = "A bluespace block that will increase the effective range of most sharp weapons, one use only."
	cost = 7
	item = /obj/item/sharpener/bluespace
	restricted_roles = list("Cook")

/datum/uplink_item/device_tools/tc_rod
	name = "Telecrystal Fuel Rod"
	desc = "This special fuel rod has eight material slots that can be inserted with telecrystals, \
			once the rod has been fully depleted, you will be able to harvest the extra telecrystals. \
			Please note: This Rod fissiles much faster than it's nanotrasen counterpart, it doesn't take \
			much to overload the reactor with these..."
	item = /obj/item/fuel_rod/material/telecrystal
	cost = 7

/datum/uplink_item/role_restricted/turretbox
	name = "Disposable Sentry Gun"
	desc = "A disposable sentry gun deployment system cleverly disguised as a toolbox, apply wrench for functionality."
	item = /obj/item/storage/toolbox/emergency/turret
	cost = 11
	restricted_roles = list("Station Engineer", "Chief Engineer")

/datum/uplink_item/role_restricted/gympie_gympie_seeds
	name = "Gympie Gympie Seeds"
	desc = "A packet of troublesome gympie seeds! Be careful, you only get one."
	item = /obj/item/seeds/gympie_gympie
	cost = 4
	restricted_roles = list("Botanist")
