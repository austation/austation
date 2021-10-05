/datum/reagent/rdx
	name = "RDX"
	description = "Military grade explosive"
	reagent_state = SOLID
	color = "#FFFFFF"
	taste_description = "salt"

/datum/reagent/tatp
	name = "TaTP"
	description = "Suicide grade explosive"
	reagent_state = SOLID
	color = "#FFFFFF"
	taste_description = "death"

/datum/reagent/gasoline
	name = "Petrol"
	description = "Petroleum derived fuel. Highly flammable."
	reagent_state = LIQUID
	color = "#FFBF00e9"
	taste_description = "acrid"

/datum/reagent/gasoline/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	if(method == TOUCH || method == VAPOR)
		M.adjust_fire_stacks(reac_volume / 5)
		return
	..()

/datum/reagent/gasoline/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(3,0)
	..()
	return TRUE

