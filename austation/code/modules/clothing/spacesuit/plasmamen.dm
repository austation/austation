// added in Plasmeme command helmets buff
/obj/item/clothing/head/helmet/space/plasmaman/security
	armor = list("melee" = 35, "bullet" = 15, "laser" = 30, "energy" = 40, "bomb" = 10, "bio" = 100, "rad" = 50, "fire" = 100, "acid" = 75, "stamina" = 30)

/obj/item/clothing/head/helmet/space/plasmaman/atmospherics
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT

/obj/item/clothing/head/helmet/space/plasmaman/command
	armor = list("melee" = 40, "bullet" = 50, "laser" = 50, "energy" = 60, "bomb" = 50, "bio" = 100, "rad" = 50, "fire" = 100, "acid" = 100, "stamina" = 30)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT

/obj/item/clothing/head/helmet/space/plasmaman/engineering/ce
	armor = list("melee" = 40, "bullet" = 5, "laser" = 10, "energy" = 15, "bomb" = 50, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 90, "stamina" = 30)
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT

/obj/item/clothing/head/helmet/space/plasmaman/cmo
	armor = list("melee" = 30, "bullet" = 5, "laser" = 10, "energy" = 15, "bomb" = 10, "bio" = 100, "rad" = 60, "fire" = 60, "acid" = 75, "stamina" = 0)
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL | SHOWEROKAY | SNUG_FIT | SCAN_REAGENTS

/obj/item/clothing/head/helmet/space/plasmaman/security/hos
	armor = list("melee" = 45, "bullet" = 25, "laser" = 30, "energy" = 40, "bomb" = 25, "bio" = 100, "rad" = 50, "fire" = 95, "acid" = 95, "stamina" = 60)

/obj/item/clothing/head/helmet/space/plasmaman/rd
	resistance_flags = ACID_PROOF | FIRE_PROOF
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	var/obj/machinery/doppler_array/integrated/bomb_radar
	armor = list("melee" = 30, "bullet" = 5, "laser" = 10, "energy" = 15, "bomb" = 100, "bio" = 100, "rad" = 60, "fire" = 60, "acid" = 80, "stamina" = 30)
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL | SHOWEROKAY | SNUG_FIT | SCAN_REAGENTS
	actions_types = list(/datum/action/item_action/toggle_helmet_light, /datum/action/item_action/toggle_welding_screen/plasmaman, /datum/action/item_action/toggle_research_scanner)

	//Rd bomb scanner
/obj/item/clothing/head/helmet/space/plasmaman/rd/Initialize()
	. = ..()
	bomb_radar = new /obj/machinery/doppler_array/integrated(src)

