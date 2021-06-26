/obj/item/sharpener/bluespace
	name = "bluespace whetstone"
	desc = "A bluespace block that can enhance your weapon, allowing it to phase through space."
	icon = 'austation/icons/obj/kitchen.dmi'
	icon_state = "bsharpener"
	increment = 10
	max = 50
	prefix = "bluespace sharpened"
	requires_sharpness = 0
	var/range_increment = 1 // amount to increase range by

/obj/item/sharpener/bluespace/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(.)
		I.reach += range_increment
