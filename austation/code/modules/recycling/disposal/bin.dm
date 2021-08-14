//  Lets us dump items straight into the bin from bags and other storage items.  If the storage item is empty then we'll just pass it to the normal bin behaviour.
/obj/machinery/disposal/bin/attackby(obj/item/I, mob/user, params)
	var/obj/item/storage/B
	var/static/list/obj/item/storage/store_list = list(
		/obj/item/storage/part_replacer,  //  RPEDs
		/obj/item/storage/bag,			  //  Botany bags and serving trays etc
		/obj/item/storage/backpack		  //  Backpacks
	)
	for(var/T in store_list)  //  T for Type, searching for types of storage item to whitelist, some like cardboard boxes are ignored.
		if(istype(I, T))
			B = I
	if(!B || !length(B.contents))  //  It's not whitelisted or perhaps simply empty, so dispose of it like normal
		return ..()
	user.visible_message("<span class='notice'>[user] empties \the [I] into \the [src].</span>", "<span class='warning'>You begin to empty \the [I] into \the [src].</span>")
	if(!do_after(user, 10, src))
		to_chat(user, "<span class='warning'>You stop emptying \the [I].</span>")
	else
		var/datum/component/storage/STR = B.GetComponent(/datum/component/storage)
		for(var/obj/item/O in B.contents)  //  O for Object(s)
			STR.remove_from_storage(O,src)
		B.update_icon()  //  We are overriding trash bags with this code, so we have to make sure they follow their routine.
