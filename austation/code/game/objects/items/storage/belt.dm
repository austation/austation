


// -------------------------------------
//     Bluespace Belt
// -------------------------------------
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

/obj/item/storage/belt/worn_overlays(isinhands, icon_file, used_state, style_flags = NONE)
	. = ..()
	if(!isinhands)
		for(var/obj/item/I in contents)
			. += I.get_worn_belt_overlay(icon_file)

/obj/item/storage/belt/darksabre
	name = "Ornate Sheathe"
	desc = "An ornate and rather sinister looking sabre sheathe."
	icon = 'austation/icons/obj/clothing/custom.dmi'
	alternate_worn_icon = 'austation/icons/mob/clothing/custom_w.dmi'
	icon_state = "darksheath"
	item_state = "darksheath"
	w_class = WEIGHT_CLASS_BULKY
	content_overlays = TRUE

/obj/item/storage/belt/darksabre/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1
	STR.rustle_sound = FALSE
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.can_hold = typecacheof(list(
		/obj/item/melee/darksabre
		))

/obj/item/storage/belt/darksabre/examine(mob/user)
	. = ..()
	if(length(contents))
		. += "<span class='notice'>Alt-click it to quickly draw the blade.</span>"

/obj/item/storage/belt/darksabre/AltClick(mob/user)
	if(!iscarbon(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	if(length(contents))
		var/obj/item/I = contents[1]
		user.visible_message("[user] takes [I] out of [src].", "<span class='notice'>You take [I] out of [src].</span>")
		user.put_in_hands(I)
		update_icon()
	else
		to_chat(user, "[src] is empty.")

/obj/item/storage/belt/darksabre/update_icon()
	cut_overlays()
	if(content_overlays)
		for(var/obj/item/I in contents)
			var/mutable_appearance/M = I.get_belt_overlay()
			add_overlay(M)
	if(loc && isliving(loc))
		var/mob/living/L = loc
		L.regenerate_icons()
	..()

/obj/item/storage/belt/darksabre/PopulateContents()
	new /obj/item/melee/darksabre(src)
	update_icon()
