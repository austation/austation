/obj/item/clothing/under/CtrlClick(mob/user)
	. = ..()

	if (!(item_flags & PICKED_UP))
		return

	if(!isliving(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return

	if(has_sensor == LOCKED_SENSORS)
		to_chat(user, "The controls are locked.")
		return
	if(has_sensor == BROKEN_SENSORS)
		to_chat(user, "The sensors have shorted out!")
		return
	if(has_sensor <= NO_SENSORS)
		to_chat(user, "This suit does not have any sensors.")
		return

	switch(sensor_mode)
		if(SENSOR_OFF)
			sensor_mode = SENSOR_LIVING
			to_chat(usr, "<span class='notice'>Your suit will now only report whether you are alive or dead.</span>")
		if(SENSOR_LIVING)
			sensor_mode = SENSOR_VITALS
			to_chat(usr, "<span class='notice'>Your suit will now only report your exact vital lifesigns.</span>")
		if(SENSOR_VITALS)
			sensor_mode = SENSOR_COORDS
			to_chat(usr, "<span class='notice'>Your suit will now report your exact vital lifesigns as well as your coordinate position.</span>")
		if(SENSOR_COORDS)
			sensor_mode = SENSOR_OFF
			to_chat(usr, "<span class='notice'>You disable your suit's remote sensing equipment.</span>")

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.w_uniform == src)
			H.update_suit_sensors()

/obj/item/clothing/under/examine(mob/user)
	. = ..()
	if(has_sensor > NO_SENSORS)
		. += "Ctrl-click on [src] to cycle it's sensors."
