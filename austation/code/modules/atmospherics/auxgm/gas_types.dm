/datum/gas/carbon_dioxide //what the fuck is this?
	enthalpy = -393500

/datum/gas/plasma
	fire_burn_rate = OXYGEN_BURN_RATE_BASE // named when plasma fires were the only fires, surely
	fire_temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST
	fire_products = "plasma_fire"
	enthalpy = FIRE_PLASMA_ENERGY_RELEASED // 3000000, 3 megajoules, 3000 kj

/datum/gas/water_vapor
	enthalpy = -241800 // FIRE_HYDROGEN_ENERGY_RELEASED is actually what this was supposed to be

/datum/gas/nitrous_oxide
	enthalpy = 81600

/datum/gas/nitryl
	enthalpy = 33200

/datum/gas/hydrogen
	id = GAS_HYDROGEN
	specific_heat = 10
	name = "Hydrogen"
	flags = GAS_FLAG_DANGEROUS
	fusion_power = 0
	fire_products = list(GAS_H2O = 2)
	fire_burn_rate = 2
	fire_temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST - 50

/datum/gas/tritium
	fire_products = list(GAS_H2O = 2)
	fire_burn_rate = 2
	fire_radiation_released = 50 // arbitrary number, basically 60 moles of trit burning will just barely start to harm you
	fire_temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST - 50

/datum/gas/bz
	enthalpy = FIRE_CARBON_ENERGY_RELEASED // it is a mystery

/datum/gas/pluoxium
	enthalpy = -50000 // but it reduces the heat output a bit

/datum/gas/methane
	id = GAS_METHANE
	specific_heat = 30
	name = "Methane"
	breath_results = GAS_METHYL_BROMIDE
	fire_products = list(GAS_CO2 = 1, GAS_H2O = 2)
	fire_burn_rate = 0.5
	breath_alert_info = list(
		not_enough_alert = list(
			alert_category = "not_enough_ch4",
			alert_type = /atom/movable/screen/alert/not_enough_ch4
		),
		too_much_alert = list(
			alert_category = "too_much_ch4",
			alert_type = /atom/movable/screen/alert/too_much_ch4
		)
	)
	enthalpy = -74600
	fire_temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST

/datum/gas/methyl_bromide
	id = GAS_METHYL_BROMIDE
	specific_heat = 42
	name = "Methyl Bromide"
	flags = GAS_FLAG_DANGEROUS
	breath_alert_info = list(
		not_enough_alert = list(
			alert_category = "not_enough_ch3br",
			alert_type = /atom/movable/screen/alert/not_enough_ch3br
		),
		too_much_alert = list(
			alert_category = "too_much_ch3br",
			alert_type = /atom/movable/screen/alert/too_much_ch3br
		)
	)
	fire_products = list(GAS_CO2 = 1, GAS_H2O = 1.5, GAS_BROMINE = 0.5)
	enthalpy = -35400
	fire_burn_rate = 4 / 7 // oh no
	fire_temperature = 808 // its autoignition, it apparently doesn't spark readily, so i don't put it lower

/datum/gas/bromine
	id = GAS_BROMINE
	specific_heat = 76
	name = "Bromine"
	flags = GAS_FLAG_DANGEROUS
	group = GAS_GROUP_CHEMICALS
	enthalpy = 193 // yeah it's small but it's good to include it
	breath_reagent = /datum/reagent/bromine

/datum/gas/ammonia
	id = GAS_AMMONIA
	specific_heat = 35
	name = "Ammonia"
	flags = GAS_FLAG_DANGEROUS
	group = GAS_GROUP_CHEMICALS
	enthalpy = -45900
	breath_reagent = /datum/reagent/ammonia
	fire_products = list(GAS_H2O = 1.5, GAS_N2 = 0.5)
	fire_burn_rate = 4/3
	fire_temperature = 924
