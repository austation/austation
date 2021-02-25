/obj/item/storage/belt
	var/overlay_AU = FALSE

/obj/item/storage/belt/utility
	overlay_AU = TRUE
	icon = 'austation/icons/obj/clothing/belts.dmi'
	lefthand_file = 'austation/icons/mob/inhands/backpack_lefthand.dmi'
	righthand_file = 'austation/icons/mob/inhands/backpack_righthand.dmi'

/obj/item/storage/belt/utility/chief
	overlay_AU = TRUE
	icon = 'austation/icons/obj/clothing/belts.dmi'
	lefthand_file = 'austation/icons/mob/inhands/backpack_lefthand.dmi'
	righthand_file = 'austation/icons/mob/inhands/backpack_righthand.dmi'

/obj/item/storage/belt/bluespace
	name = "Belt of Holding"
	desc = "The greatest in pants-supporting technology."
	icon = 'austation/icons/obj/clothing/belts.dmi'
	icon_state = "holdingbelt"
	item_state = "holding"

/obj/item/storage/belt/bluespace/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 14
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.can_hold = typecacheof(list())
