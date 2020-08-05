//Science

/datum/supply_pack/science/slimemutagen
	name = "Xenobiology Mutagen crate"
	desc = "Hate that one slime who won't stop mutating? Desperately want a rainbow slime but you have no reds? Come on down to Mutagen incorporated for a mutation and stabilization potion all in one package!"
	cost = 3200
	access = ACCESS_TOX_STORAGE
	contains = list(/obj/item/slimepotion/slime/stabilizer,
    				/obj/item/slimepotion/slime/mutator)
	crate_name = "Xenobiology Mutagen crate"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/slimesteroid
	name = "Xenobiology Slime Steroid crate"
	desc = "Everything a new xenobiologist needs to be efficent in their work! Comes with 2 bottles of slime steroids"
	cost = 4500
	access = ACCESS_TOX_STORAGE
	contains = list(/obj/item/slimepotion/slime/steroid,
    				/obj/item/slimepotion/slime/steroid)
	crate_name = "Xenobiology Slime Steroid crate"
	crate_type = /obj/structure/closet/crate/secure/science
