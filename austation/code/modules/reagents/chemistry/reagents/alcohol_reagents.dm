// AUSTATION drinks

/datum/reagent/consumable/ethanol/jagermeister
	name = "jägermeister"
	description = "56 different herbs and spices!"
	color = "#666300" // rgb: 102, 99, 0
	aus = TRUE
	boozepwr = 60
	quality = DRINK_FANTASTIC
	taste_description = "german"
	glass_icon_state = "jagermeister"
	glass_name = "jägermeister"
	glass_desc = "56 different herbs and spices!"

/datum/reagent/consumable/ethanol/jagerbomb
	name = "jägerbomb"
	description = "herbal energy drink?"
	color = "#666300" // rgb: 102, 99, 0
	aus = TRUE
	boozepwr = 20
	quality = DRINK_FANTASTIC
	taste_description = "explosive"
	glass_icon_state = "jagermeister"
	glass_name = "jägerbomb"
	glass_desc = "energy drinks and alcohol, uh oh"

/datum/reagent/consumable/ethanol/jagerbomb/on_mob_end_metabolize(mob/living/M)
	var/explosion_power = clamp(current_cycle*3*REM, 0, 5) // to stop monkey nuclear bombs
	var/turf/T = get_turf(M)
	M.log_message("has detonated with [explosion_power] explosion power from jagerbomb", LOG_ATTACK)
	explosion(T,explosion_power,explosion_power*2,explosion_power*4)
	..()
