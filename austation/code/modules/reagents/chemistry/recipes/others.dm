// AuStation Reagents
/datum/chemical_reaction/australium
	name = "Australium"
	id = /datum/reagent/australium
	results = list(/datum/reagent/australium = 3)
	required_reagents = list(/datum/reagent/consumable/ethanol/beer = 1, /datum/reagent/gold = 1, /datum/reagent/pyrosium = 1)

/datum/chemical_reaction/luminol
	name = "Luminol"
	id = /datum/reagent/luminol
	results = list(/datum/reagent/luminol = 3)
	required_reagents = list(/datum/reagent/oxygen = 1, /datum/reagent/chlorine = 1, /datum/reagent/lye = 1)

/datum/chemical_reaction/energized_luminol
	name = "Energized Luminol"
	id = /datum/reagent/luminol/energized
	results = list(/datum/reagent/luminol/energized = 2)
	required_reagents = list(/datum/reagent/luminol = 2, /datum/reagent/toxin/plasma = 1, /datum/reagent/uranium = 1)
	required_temp = 400

/datum/chemical_reaction/synthetic_cake_batter
	name = "Synthetic cake batter"
	id = /datum/reagent/consumable/synthetic_cake_batter
	results = list(/datum/reagent/consumable/synthetic_cake_batter = 10)
	required_reagents = list(/datum/reagent/consumable/flour = 15, /datum/reagent/consumable/milk = 15, /datum/reagent/consumable/astrotame = 5)
/datum/chemical_reaction/hydrogen_peroxide
	results = list(/datum/reagent/hydrogen_peroxide = 3)
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/oxygen = 1, /datum/reagent/chlorine = 1)

/datum/chemical_reaction/exotic_stabilizer
	results = list(/datum/reagent/exotic_stabilizer = 2)
	required_reagents = list(/datum/reagent/plasma_oxide = 1,/datum/reagent/stabilizing_agent = 1)

/datum/chemical_reaction/acetone_oxide
	results = list(/datum/reagent/acetone_oxide = 2)
	required_reagents = list(/datum/reagent/acetone = 2, /datum/reagent/oxygen = 1, /datum/reagent/hydrogen_peroxide = 1)

/datum/chemical_reaction/pentaerythritol
	results = list(/datum/reagent/pentaerythritol = 2)
	required_reagents = list(/datum/reagent/acetaldehyde = 1, /datum/reagent/toxin/formaldehyde = 3, /datum/reagent/water = 1 )

/datum/chemical_reaction/acetaldehyde
	results = list(/datum/reagent/acetaldehyde = 3)
	required_reagents = list(/datum/reagent/acetone = 1, /datum/reagent/toxin/formaldehyde = 1, /datum/reagent/water = 1)
	required_temp = 450

/datum/chemical_reaction/concentrated_bz
	name = "Concentrated BZ"
	id = "Concentrated BZ"
	results = list(/datum/reagent/concentrated_bz = 10)
	required_reagents = list(/datum/reagent/toxin/plasma = 40, /datum/reagent/nitrous_oxide = 10)

/datum/chemical_reaction/fake_cbz
	name = "Fake CBZ"
	id = "Fake CBZ"
	results = list(/datum/reagent/fake_cbz = 1)
	required_reagents = list(/datum/reagent/concentrated_bz = 1, /datum/reagent/medicine/neurine = 3)
