// AUSTATION drinks

// make sure "aus" is set to true for any drinks that are added, or else modular icons will not work

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
	boozepwr = 50
	metabolization_rate = 2.5 * REAGENTS_METABOLISM
	quality = DRINK_FANTASTIC
	taste_description = "explosives"
	glass_icon_state = "jagerbomb"
	glass_name = "jägerbomb"
	glass_desc = "energy drinks and alcohol, uh oh"

/datum/reagent/consumable/ethanol/jagerbomb/on_mob_life(mob/living/carbon/M)
	if(prob(10))
	to_chat(M,"<span class='notice'>Your stomach rumbles.</span>")

/datum/reagent/consumable/ethanol/jagerbomb/on_mob_end_metabolize(mob/living/M)
	var/explosion_power = round(clamp(current_cycle / 50 * REM, 0, 5),1.25) // to stop monkey nuclear bombs
	var/turf/T = get_turf(M)
	M.log_message("has detonated with [explosion_power] explosion power from jagerbomb", LOG_ATTACK)
	if(explosion_power >= 1)
		explosion(T,explosion_power,explosion_power*2,explosion_power*4)

	else if(explosion_power >= 0.75)
		explosion(T,0,1,2,3)

	else if(explosion_power >= 0.5)
		explosion(T,0,0,2,3)

	else
		explosion(T,0,0,1,2)
	..()
