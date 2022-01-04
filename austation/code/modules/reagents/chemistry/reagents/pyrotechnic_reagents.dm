
/datum/reagent/clf3
	/* no gaseous CLF3 until i can think of a good way to get it to burn that doesn't destroy matter in mysterious ways
	boiling_point = 289.4
	*/
	condensation_amount = 2

/datum/reagent/clf3/define_gas()
	var/datum/gas/G = ..()
	G.enthalpy = -163200
	G.oxidation_temperature = T0C - 50
	return G

/datum/reagent/phlogiston
	boiling_point = T20C-10

/datum/reagent/phlogiston/define_gas()
	var/datum/gas/G = ..()
	G.enthalpy = FIRE_PLASMA_ENERGY_RELEASED / 100
	G.fire_products = list(GAS_O2 = 0.25, GAS_METHANE = 0.75) // meanwhile this is just magic
	G.fire_burn_rate = 1
	G.fire_temperature = T20C+1
	return G

/datum/reagent/firefighting_foam/define_gas()
	return null

/datum/reagent/rdx
	name = "RDX"
	description = "Military grade explosive"
	reagent_state = SOLID
	color = "#FFFFFF"
	taste_description = "salt"
	random_unrestricted = FALSE

/datum/reagent/tatp
	name = "TaTP"
	description = "Suicide grade explosive"
	reagent_state = SOLID
	color = "#FFFFFF"
	taste_description = "death"
	random_unrestricted = FALSE

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

