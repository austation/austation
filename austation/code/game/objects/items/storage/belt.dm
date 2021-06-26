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

/obj/item/storage/belt/utility
	icon = 'austation/icons/obj/clothing/belts.dmi'
	alternate_worn_icon = 'austation/icons/mob/clothing/belt.dmi'
	lefthand_file = 'austation/icons/mob/inhands/equipment/belts_lefthand.dmi'
	righthand_file = 'austation/icons/mob/inhands/equipment/belts_righthand.dmi'
