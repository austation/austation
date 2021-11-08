/datum/gas_reaction/smoke_dissipation
	priority = -15
	name = "Smoke Dissipation"
	id = "smogdiss"

/datum/gas_reaction/smoke_dissipation/init_reqs()
	min_requirements = list(
		GAS_SMOKE = MINIMUM_MOLE_COUNT,
		"MAX_TEMP" = FIRE_MINIMUM_TEMPERATURE_TO_EXIST
	)

/datum/gas_reaction/smoke_dissipation/react(datum/gas_mixture/air, datum/holder)

	var/cleared_smok = min(air.get_moles(GAS_SMOKE), 0.5)
	air.adjust_moles(GAS_SMOKE, -cleared_smok)
