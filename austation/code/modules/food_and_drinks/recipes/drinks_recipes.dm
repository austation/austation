// kinda LAME that this isn't in reagents.. bee.

/datum/chemical_reaction/jagerbomb
	name = "Jägerbomb"
	id = /datum/reagent/consumable/ethanol/jagerbomb
	results = list(/datum/reagent/consumable/ethanol/jagerbomb = 1)
	required_reagents = list(/datum/reagent/consumable/grey_bull = 1, /datum/reagent/ash = 2, /datum/reagent/consumable/ethanol/jagermeister = 3)

/datum/chemical_reaction/jagerbomb/stabilized
	name = "Stabilized Jägerbomb"
	id = /datum/reagent/consumable/ethanol/jagerbomb/stabilized
	results = list(/datum/reagent/consumable/ethanol/jagerbomb = 1)
	required_reagents = list(/datum/reagent/consumable/ethanol/jagerbomb = 1, /datum/reagent/stabilizing_agent = 1)

/datum/chemical_reaction/jagermeister
	name = "Jägmeister"
	id = /datum/reagent/consumable/ethanol/jagermeister
	results = list(/datum/reagent/consumable/ethanol/jagermeister = 3)
	required_reagents = list(/datum/reagent/consumable/ginger_beer = 1, /datum/reagent/consumable/limejuice = 1, /datum/reagent/consumable/berryjuice = 1)

/datum/chemical_reaction/bushranger
	name = "Bushranger"
	id = /datum/reagent/consumable/ethanol/bushranger
	results = list(/datum/reagent/consumable/ethanol/bushranger = 2)
	required_reagents = list(/datum/reagent/consumable/ethanol/bahama_mama = 1, /datum/reagent/consumable/ethanol/rum = 1, /datum/reagent/consumable/ginger_beer = 1, /datum/reagent/consumable/ethanol/quadruple_sec = 1)

/datum/chemical_reaction/moscowmule
	name = "Moscow Mule"
	id = /datum/reagent/consumable/ethanol/moscowmule
	results = list(/datum/reagent/consumable/ethanol/moscowmule = 4)
	required_reagents = list(/datum/reagent/consumable/ginger_beer = 2, /datum/reagent/consumable/limejuice = 1, /datum/reagent/consumable/ice = 1, /datum/reagent/consumable/ethanol/vodka = 1)

/datum/chemical_reaction/lemonlimebitters
	name = "Lemon Lime Bitters"
	id = /datum/reagent/consumable/ethanol/lemomlimebitters
	results = list(/datum/reagent/consumable/ethanol/lemomlimebitters = 2)
	required_reagents = list(/datum/reagent/consumable/ethanol/bitters = 1, /datum/reagent/consumable/lemon_lime = 5)

/datum/chemical_reaction/vampirekiss
	name = "Vampire's Kiss"
	id = /datum/reagent/consumable/ethanol/vampirekiss
	results = list(/datum/reagent/consumable/ethanol/vampirekiss = 2)
	required_reagents = list(/datum/reagent/blood = 2, /datum/reagent/consumable/ethanol/vodka = 1, /datum/reagent/consumable/ethanol/champagne = 1)

/datum/chemical_reaction/peggnog
	name = "Peggnog"
	id = /datum/reagent/consumable/peggnog
	results = list(/datum/reagent/consumable/peggnog = 2)
	required_reagents = list(/datum/reagent/consumable/ethanol/eggnog = 1, /datum/reagent/consumable/lemonade = 3)

/datum/chemical_reaction/pilk
	name = "Pilk"
	id = /datum/reagent/consumable/pilk
	results = list(/datum/reagent/consumable/pilk = 3)
	required_reagents = list(/datum/reagent/consumable/milk = 2, /datum/reagent/consumable/lemonade = 2)
