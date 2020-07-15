
/datum/chemical_reaction/sarin
	name = "Sarin"
	id = /datum/reagent/toxin/sarin
	results = list(/datum/reagent/toxin/sarin = 5)
	required_reagents = list(/datum/reagent/toxin/lexorin = 2, /datum/reagent/oil = 2, /datum/reagent/acetone = 2, /datum/reagent/consumable/ethanol/neurotoxin = 2, /datum/reagent/hydrogen = 2, /datum/reagent/toxin/carpotoxin = 2)
	mix_message = "<span class='danger'>The mixure violently bubbles, releasing a considerable amount of vapour before calming down.</span>"
	// todo: add smoke effect on mix to punish (grief) people producing it without protection
