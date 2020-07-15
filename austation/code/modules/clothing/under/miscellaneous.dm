/obj/item/clothing/under/rank/prisoner/skirt
	name = "prison jumpskirt"
	desc = "It's standardised Nanotrasen prisoner-wear. Its suit sensors are stuck in the \"Fully On\" position."
	icon = 'austation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'austation/icons/mob/uniform.dmi'
	icon_state = "prisoner_skirt"
	item_state = "o_suit"
	item_color = "prisoner_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/gimmick/rank/captain/suit/skirt
	name = "green suitskirt"
	desc = "A green suitskirt and yellow necktie. Exemplifies authority."
	icon = 'austation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'austation/icons/mob/uniform.dmi'
	icon_state = "green_suit_skirt"
	item_state = "dg_suit"
	item_color = "green_suit_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/gimmick/rank/head_of_personnel/suit/skirt
	name = "teal suitskirt"
	desc = "A teal suitskirt and yellow necktie. An authoritative yet tacky ensemble."
	icon = 'austation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'austation/icons/mob/uniform.dmi'
	icon_state = "teal_suit_skirt"
	item_state = "g_suit"
	item_color = "teal_suit_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/syndicate/skirt
	name = "tactical skirtleneck"
	desc = "A non-descript and slightly suspicious looking skirtleneck."
	icon = 'austation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'austation/icons/mob/uniform.dmi'
	icon_state = "syndicate_skirt"
	item_state = "bl_suit"
	item_color = "syndicate_skirt"
	has_sensor = NO_SENSORS
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 40)
	alt_covers_chest = TRUE
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/syndicate/tacticool/skirt
	name = "tacticool skirtleneck"
	desc = "Just looking at it makes you want to buy an SKS, go into the woods, and -operate-."
	icon = 'austation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'austation/icons/mob/uniform.dmi'
	icon_state = "tactifool_skirt"
	item_state = "bl_suit"
	item_color = "tactifool_skirt"
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 40)
	fitted = FEMALE_UNIFORM_TOP
