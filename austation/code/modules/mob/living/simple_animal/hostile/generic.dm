/mob/living/simple_animal/hostile/generic

	name = "generic"
	desc = "a generic 'animal' for admemes to use, admemes should change the description. If you arent a admeme and you see this outside of a admin spawn then go yell at the admemes"
	icon = 'icons/mob/animal.dmi'
	icon_state = "old"
	icon_dead = "old"
	icon_living = "old"
	attacktext = "punches"
	attack_sound = 'sound/weapons/punch1.ogg'
	health = 140
	maxHealth = 140
	melee_damage = 5
	var/obj/item/head
	var/obj/item/internal_storage
	flip_on_death = TRUE
	dextrous = TRUE
	held_items = list(null, null)
	dextrous_hud_type = /datum/hud/dextrous/drone //so we can wear a mask and helmet
	do_footstep = TRUE
	possible_a_intents = list(INTENT_HELP, INTENT_HARM)
	speed = 0
//Basically we are just a mob that is dextrous that has the drone inventory system.
//Also admins who want to use this are expected to change the icon to whatever meme they want
//they need to change "icon" "icon_state" "icon_dead" and "icon_living" with the VV panel.

/mob/living/simple_animal/hostile/generic/doUnEquip(obj/item/I, force, newloc, no_move, invdrop = FALSE, was_thrown = FALSE) //inventory stuff from drone code
	if(..())
		update_inv_hands()
		if(I == head)
			head = null
			update_inv_head()
		if(I == internal_storage)
			internal_storage = null
			update_inv_internal_storage()
		return TRUE
	return FALSE


/mob/living/simple_animal/hostile/generic/can_equip(obj/item/I, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	switch(slot)
		if(SLOT_HEAD)
			if(head)
				return 0
			if(!((I.slot_flags & ITEM_SLOT_HEAD) || (I.slot_flags & ITEM_SLOT_MASK)))
				return 0
			return 1
		if(SLOT_GENERC_DEXTROUS_STORAGE)
			if(internal_storage)
				return 0
			return 1
	..()


/mob/living/simple_animal/hostile/generic/get_item_by_slot(slot_id)
	switch(slot_id)
		if(SLOT_HEAD)
			return head
		if(SLOT_GENERC_DEXTROUS_STORAGE)
			return internal_storage
	return ..()


/mob/living/simple_animal/hostile/generic/equip_to_slot(obj/item/I, slot)
	if(!slot)
		return
	if(!istype(I))
		return

	var/index = get_held_index_of_item(I)
	if(index)
		held_items[index] = null
	update_inv_hands()

	if(I.pulledby)
		I.pulledby.stop_pulling()

	I.screen_loc = null // will get moved if inventory is visible
	I.forceMove(src)
	I.layer = ABOVE_HUD_LAYER
	I.plane = ABOVE_HUD_PLANE

	switch(slot)
		if(SLOT_HEAD)
			head = I
			update_inv_head()
		if(SLOT_GENERC_DEXTROUS_STORAGE)
			internal_storage = I
			update_inv_internal_storage()
		else
			to_chat(src, "<span class='danger'>You are trying to equip this item to an unsupported inventory slot. Report this to a coder!</span>")
			return

	//Call back for item being equipped to drone
	I.equipped(src, slot)

/mob/living/simple_animal/hostile/generic/getBackSlot()
	return SLOT_GENERC_DEXTROUS_STORAGE

/mob/living/simple_animal/hostile/generic/getBeltSlot()
	return SLOT_GENERC_DEXTROUS_STORAGE

/mob/living/simple_animal/hostile/generic/proc/update_inv_internal_storage()
	if(internal_storage && client && hud_used && hud_used.hud_shown)
		internal_storage.screen_loc = ui_drone_storage
		client.screen += internal_storage

/mob/living/simple_animal/hostile/generic/update_inv_head()
	if(client && hud_used && hud_used.hud_shown)
		head.screen_loc = ui_drone_head
		client.screen += head

/mob/living/simple_animal/hostile/generic/examine(mob/user)
	. = list("<span class='info'>*---------*\nThis is [icon2html(src, user)] \a <b>[src]</b>!")

	//Hands
	for(var/obj/item/I in held_items)
		if(!(I.item_flags & ABSTRACT))
			. += "It has [I.get_examine_string(user)] in its [get_held_index_name(get_held_index_of_item(I))]."

	//Internal storage
	if(internal_storage && !(internal_storage.item_flags & ABSTRACT))
		. += "It is wearing a [internal_storage.get_examine_string(user)] on its back."

	//Cosmetic hat - provides no function other than looks
	if(head && !(head.item_flags & ABSTRACT))
		. += "It has a [head.get_examine_string(user)]."

	if(stat == DEAD)
		. += "<span class='deadsay'>It is dead.</span>"

/mob/living/simple_animal/hostile/generic/death(gibbed)
	..(gibbed)
	if(internal_storage)
		dropItemToGround(internal_storage)
	if(head)
		dropItemToGround(head)
