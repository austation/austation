// AUSTATION drinks

// make sure "aus" is set to true for any drinks that are added, or else modular icons will not work

/datum/reagent/consumable/ethanol/jagermeister
	name = "jägermeister"
	description = "56 different herbs and spices!"
	color = "#666300" // rgb: 135, 99, 0
	aus = TRUE
	boozepwr = 60
	quality = DRINK_FANTASTIC
	taste_description = "german"
	glass_icon_state = "jagermeister"
	glass_name = "jägermeister"
	glass_desc = "56 different herbs and spices!"

// Maybe this should be in pyrotechnics
/datum/reagent/consumable/ethanol/jagerbomb
	name = "jägerbomb"
	description = "herbal energy drink?"
	color = "#6ec46f" // rgb: 110, 196, 111
	aus = TRUE
	boozepwr = 50
	metabolization_rate = 2.5 * REAGENTS_METABOLISM
	quality = DRINK_FANTASTIC
	taste_description = "explosives"
	glass_icon_state = "jagerbomb"
	glass_name = "jägerbomb"
	glass_desc = "energy drinks and alcohol, uh oh"
	var/ex_multiplier = 1

/datum/reagent/consumable/ethanol/jagerbomb/on_mob_life(mob/living/carbon/M)
	if(current_cycle >= 12 && prob(5))
		var/warning_message = pick("You feel your chest clench.", "Your stomach rumbles.","You feel you need to catch your breath.","You feel a painful prickle in your chest.")
		to_chat(M, "<span class='warning'>[warning_message]</span>")
	return ..()

/datum/reagent/consumable/ethanol/jagerbomb/on_mob_end_metabolize(mob/living/M)
	// var/explosion_power = round(current_cycle ** 0.95 / 40) * ex_multiplier // custom scaling in case dyn_explosion changes for whatever reason
	var/explosion_power = round(current_cycle / 2, 0.1)
	M.log_message("has detonated with [explosion_power] explosion power from jagerbomb", LOG_ATTACK)
	if(explosion_power > 0.4)
		dyn_explosion(M, explosion_power)
	..()

/datum/reagent/consumable/ethanol/jagerbomb/stabilized
	name = "stabilized jägerbomb"
	description = "almost completely ethanol free!"
	boozepwr = 1
	ex_multiplier = 0.75

/datum/reagent/consumable/ethanol/bushranger
	name = "Bushranger"
	description = "Crikey!" // I'm sorry
	color = "#d19900" // rgb: 209, 153, 0
	aus = TRUE
	boozepwr = 50
	quality = DRINK_FANTASTIC
	metabolization_rate = REAGENTS_METABOLISM
	taste_description = "the bush"
	glass_icon_state = "bushranger"
	glass_name = "Bushranger"
	glass_desc = "A slightly sweet, complex, australian cocktail."
	var/datum/brain_trauma/special/psychotic_brawling/bath_salts/rage

/datum/reagent/consumable/ethanol/bushranger/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_SLEEPIMMUNE, type)
	ADD_TRAIT(L, TRAIT_IGNOREDAMAGESLOWDOWN, type)
	ADD_TRAIT(L, TRAIT_NOSTAMCRIT, type)
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		rage = new()
		C.gain_trauma(rage, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/reagent/consumable/ethanol/bushranger/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_SLEEPIMMUNE, type)
	REMOVE_TRAIT(L, TRAIT_IGNOREDAMAGESLOWDOWN, type)
	REMOVE_TRAIT(L, TRAIT_NOSTAMCRIT, type)
	if(rage)
		QDEL_NULL(rage)
	..()

/datum/reagent/consumable/ethanol/moscowmule
	name = "Moscow Mule"
	description = "Made of neither Muscovites or Mules, unfortunately."
	color = "#ffd666" // rgb: 255, 214, 102
	aus = TRUE
	boozepwr = 50
	quality = DRINK_FANTASTIC
	taste_description = "ginger and lime"
	glass_icon_state = "moscowmule"
	glass_name = "Moscow Mule"
	glass_desc = "Experts say the copper mug is dangerous. Dangerously cool!"

/datum/reagent/consumable/ethanol/lemomlimebitters
	name = "Lemon Lime Bitters"
	description = "Made of neither Muscovites or Mules, unfortunately."
	color = "#ff704d" // rgb: 255, 112, 77
	aus = TRUE
	boozepwr = 5
	quality = DRINK_FANTASTIC
	taste_description = "Lemonade, lime cordial and bitters."
	glass_icon_state = "llbitters"
	glass_name = "Lemon-Lime Bitters"
	glass_desc = "Tastes like last summer."

/datum/reagent/consumable/ethanol/bitters
	name = "Narrowing Bitters"
	description = "A dash is always nice. A swig proves why they call it Narrowing Bitters."
	color = "#4d0f00" // rgb: 77, 15, 0
	aus = TRUE
	boozepwr = 50
	quality = DRINK_NICE
	taste_description = "sharp herbal liqour"
	glass_icon_state = "llbitters"
	glass_name = "Bitters"
	glass_desc = "You get the feeling this is more than a dash."

/datum/reagent/consumable/ethanol/vampirekiss
	name = "Vampire's Kiss"
	description = "An alchoholic cocktail, with something wrong..."
	color = "#da5841"
	aus = TRUE
	boozepwr = 50
	quality = DRINK_FANTASTIC
	taste_description = "Tart and creamy, with a bitter aftertaste"
	glass_icon_state = "vampirekiss"
	glass_name = "glass of vampire's kiss"
	glass_desc = "A blood-red glass of vampire's kiss, it makes you want to skulk in the shadows."

/datum/reagent/consumable/ethanol/vampirekiss/on_mob_life(mob/living/carbon/M)
	var/turf/T = M.loc
	if(istype(T))
		var/light_amount = T.get_lumcount()
		if(ishuman(M) && light_amount < 0.2) //The light amount freshold is the same as a shadowperson's
			M.heal_bodypart_damage(1, 1, 0)
			. = 1
	..()
