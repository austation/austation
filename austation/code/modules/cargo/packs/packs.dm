//Science

/datum/supply_pack/science/slimesteroid
	name = "Xenobiology Slime Steroid crate"
	desc = "Everything a new xenobiologist needs to be efficent in their work! Comes with 2 bottles of slime steroids"
	cost = 5500
	access = ACCESS_TOX_STORAGE
	contains = list(/obj/item/slimepotion/slime/steroid,
    				/obj/item/slimepotion/slime/steroid)
	crate_name = "Xenobiology Slime Steroid crate"
	crate_type = /obj/structure/closet/crate/secure/science

//Engineering

/datum/supply_pack/engine/fuel_rod
	name = "Uranium Fuel Rod crate"
	desc = "Two additional fuel rods for use in a reactor, requires CE access to open. Caution: Radioactive"
	cost = 4000
	access = ACCESS_CE
	contains = list(/obj/item/twohanded/required/fuel_rod,
					/obj/item/twohanded/required/fuel_rod)
	crate_name = "Uranium-235 Fuel Rod crate"
	crate_type = /obj/structure/closet/crate/secure/engineering
	dangerous = TRUE

/datum/supply_pack/engine/bananium_fuel_rod
	name = "Bluespace Crystal Fuel Rod Core crate"
	desc = "Two Fuel Rod Cores designed to utilize and multiply bananium in a reactor, requires CE access to open. Caution: Mildly Radioactive"
	cost = 4000
	access = ACCESS_CE // Nag your local CE
	contains = list(/obj/item/twohanded/required/fuel_rod/material/bananium,
					/obj/item/twohanded/required/fuel_rod/material/bananium)
	crate_name = "Bluespace Crystal Fuel Rod crate"
	crate_type = /obj/structure/closet/crate/secure/engineering
	dangerous = TRUE
	contraband = TRUE
