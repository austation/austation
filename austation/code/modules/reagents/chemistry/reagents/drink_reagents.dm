// AUSTATION drinks

// make sure "aus" is set to true for any drinks that are added, or else modular icons will not work

/datum/reagent/consumable/ginger_beer
	name = "Ginger Beer"
	description = "A sweet and spicy fermented drink"
	color = "#876300"
	aus = TRUE
	taste_description = "ginger"
	glass_icon_state = "gingerfizzy"
	glass_name = "glass of ginger beer"
	glass_desc = "A non-alcoholic glass of fine Space Queenslandian gold."

/datum/reagent/consumable/pilk
	name = "Pilk"
	description = "An odd combination of milk and lemonade"
	color = "#776533"
	quality = DRINK_FANTASTIC
	taste_description = "milk and lemonade"
	glass_icon_state = "glass_brown"
	glass_name = "glass of pilk"
	glass_desc = "A glass of pilk, it probably has been drunk from 5 times already."

/datum/reagent/consumable/pilk/on_mob_life(mob/living/carbon/M)
	if(iscatperson(M))
		M.heal_bodypart_damage(0.5, 0.5, 0)
		. = 1
	..()

/datum/reagent/consumable/peggnog
	name = "Peggnog"
	description = "An odd combination of eggnog and lemonade"
	color = "#ceb266"
	quality = DRINK_FANTASTIC
	taste_description = "eggnog and lemonade"
	glass_icon_state = "glass_yellow"
	glass_name = "glass of peggnog"
	glass_desc = "A glass of peggnog, you feel weird looking at it."

/datum/reagent/consumable/peggnog/on_mob_life(mob/living/carbon/M)
	if(ishuman(M) && (M.gender == FEMALE))
		M.heal_bodypart_damage(0.5, 0.5, 0)
		. = 1
	..()
