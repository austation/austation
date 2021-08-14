//  Lets us dump items straight into the bin from bags (botany bags were the main inspiration for this), saving the user a lot of time.
/obj/machinery/disposal/bin/attackby(obj/item/I, mob/user, params)
	var/obj/item/storage/B
	if(istype(I, /obj/item/storage/bag) || istype(I, /obj/item/storage/backpack))
		B = I
	if(!B)
		return ..()
	var/datum/component/storage/STR = B.GetComponent(/datum/component/storage)
	if(!length(B.contents))
		return ..()  //  Bins usually return like this if the item is not a trash bag.  We would still like to be able to throw out our bags if they are empty.
	else
		user.visible_message("<span class='notice'>[user] empties \the [I] into \the [src].</span>", "<span class='warning'>You empty \the [I].</span>")
		for(var/obj/item/O in B.contents)
			STR.remove_from_storage(O,src)
		B.update_icon()  //  We are overriding trash bags with this code, so we have to make sure they follow their routine.
