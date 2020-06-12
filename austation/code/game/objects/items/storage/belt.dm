


// -------------------------------------
//     Bluespace Belt
// -------------------------------------
/obj/item/storage/belt/bluespace
	name = "Belt of Holding"
	desc = "The greatest in pants-supporting technology."
	icon = 'austation/icons/obj/clothing/belts.dmi'
	icon_state = "holdingbelt"
	item_state = "holding"

/obj/item/storage/belt/holding/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 14
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.can_hold = typecacheof(list())
