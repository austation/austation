
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
