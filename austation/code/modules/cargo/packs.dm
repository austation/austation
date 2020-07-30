//Science


/datum/supply_pack/science/xenobiology_common
	name = "Xenobiology Crate (Common)"
	desc = "A crate filled with 10 common core extracts, for use by the science team"
	cost = 6000
	access = ACCESS_TOX_STORAGE
	contains = list(
              /obj/item/slime_extract/metal,
              /obj/item/slime_extract/metal,
              /obj/item/slime_extract/purple,
              /obj/item/slime_extract/purple,
              /obj/item/slime_extract/blue,
              /obj/item/slime_extract/blue,
              /obj/item/slime_extract/orange,
              /obj/item/slime_extract/orange,
              /obj/item/slime_extract/grey,
              /obj/item/slime_extract/grey)

	crate_name = "xenobiology common crate"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/xenobiology_intermediate
	name = "Xenobiology Crate (Intermidiate)"
	desc = "A crate filled with 8 intermediate core extracts, for use by the science team"
	cost = 10700
	access = ACCESS_TOX_STORAGE
	contains = list(
              /obj/item/slime_extract/yellow,
              /obj/item/slime_extract/darkpurple,
              /obj/item/slime_extract/darkblue,
              /obj/item/slime_extract/green,
              /obj/item/slime_extract/pink,
			  /obj/item/slime_extract/silver,
			  /obj/item/slime_extract/gold,
			  /obj/item/slime_extract/red)

	crate_name = "xenobiology intermediate crate"
	crate_type = /obj/structure/closet/crate/secure/science


/datum/supply_pack/science/xenobiology_advanced
	name = "Xenobiology Crate (Advanced)"
	desc = "A crate filled with 8 advanced core extracts, for use by the science team"
	cost = 25000
	access = ACCESS_TOX_STORAGE
	contains = list(
              /obj/item/slime_extract/bluespace,
              /obj/item/slime_extract/oil,
              /obj/item/slime_extract/sepia,
              /obj/item/slime_extract/black,
              /obj/item/slime_extract/cerulean,
			  /obj/item/slime_extract/lightpink,
			  /obj/item/slime_extract/pyrite,
			  /obj/item/slime_extract/adamantine)

	crate_name = "xenobiology advanced crate"
	crate_type = /obj/structure/closet/crate/secure/science
