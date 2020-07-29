//Science


/datum/supply_pack/science/xenobiology_common
	name = "Xenobiology Crate (Common)"
	desc = "A crate filled with 10 common core extracts, for use by the science team"
	cost = 5500
	access = ACCESS_SCIENCE
	contains = list(
              /obj/item/slime_extract/metal,
              /obj/item/slime_extract/purple,
              /obj/item/slime_extract/blue,
              /obj/item/slime_extract/orange,
              /obj/item/slime_extract/grey,

              if (prob)(60))
                /obj/item/slime_extract/metal,
              else
                /obj/item/slime_extract/grey,

               if (prob)(60))
                /obj/item/slime_extract/purple,
              else
                /obj/item/slime_extract/grey,

               if (prob)(60))
                /obj/item/slime_extract/blue,
              else
                /obj/item/slime_extract/grey,

               if (prob)(60))
                /obj/item/slime_extract/orange,
              else
                /obj/item/slime_extract/grey,)

	crate_name = "xenobiology common crate"
	crate_type = /obj/structure/closet/crate/secure/science
