/datum/breathing_class/proc/get_effective_pp(datum/gas_mixture/breath)
	var/mol = 0
	for(var/gas in gases)
		mol += breath.get_moles(gas) * gases[gas]
	return (mol/breath.total_moles()) * breath.return_pressure()

