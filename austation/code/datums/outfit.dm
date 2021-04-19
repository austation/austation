/// Copy most vars from another outfit to this one
/datum/outfit/proc/copy_from(datum/outfit/target)
	name = target.name
	uniform = target.uniform
	suit = target.suit
	toggle_helmet = target.toggle_helmet
	back = target.back
	belt = target.belt
	gloves = target.gloves
	shoes = target.shoes
	head = target.head
	mask = target.mask
	neck = target.neck
	ears = target.ears
	glasses = target.glasses
	id = target.id
	l_pocket = target.l_pocket
	r_pocket = target.r_pocket
	suit_store = target.suit_store
	r_hand = target.r_hand
	l_hand = target.l_hand
	internals_slot = target.internals_slot
	backpack_contents = target.backpack_contents
	box = target.box
	implants = target.implants
	accessory = target.accessory

/datum/outfit/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "---")
	VV_DROPDOWN_OPTION(VV_HK_TO_OUTFIT_EDITOR, "Outfit Editor")

/datum/outfit/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_TO_OUTFIT_EDITOR])
		usr.client.open_outfit_editor(src)
