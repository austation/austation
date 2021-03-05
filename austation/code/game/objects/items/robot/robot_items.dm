/obj/item/borg/apparatus/food //basically beaker apparatus but for food items its janky but it works
	name = "food manipulator"
	desc = "A repurposed beaker apparatus for food items."
	icon_state = "borg_beaker_apparatus"
	storable = list(/obj/item/reagent_containers/food/snacks,
	/obj/item/reagent_containers/food/condiment/flour,
	/obj/item/reagent_containers/food/condiment/rice,
	/obj/item/reagent_containers/food/condiment/soymilk,
	/obj/item/reagent_containers/food/condiment/milk,
	/obj/item/reagent_containers/food/condiment/mayonnaise,
	/obj/item/reagent_containers/food/condiment/soysauce,
	/obj/item/reagent_containers/food/condiment/sugar,
	/obj/item/reagent_containers/food/condiment/peppermill,
	/obj/item/reagent_containers/food/condiment/saltshaker) //yes this means you can do bread and i had to exempt enzymes so you dont pickup your internal one, which causes problems.

/obj/item/borg/apparatus/food/Initialize()
	. = ..()
	RegisterSignal(stored, COMSIG_ATOM_UPDATE_ICON, /atom/.proc/update_icon)
	update_icon()

/obj/item/borg/apparatus/food/Destroy()
	if(stored)
		var/obj/item/reagent_containers/C = stored
		C.SplashReagents(get_turf(src))
		qdel(stored)
	. = ..()

/obj/item/borg/apparatus/beaker/examine()
	. = ..()
	if(stored)
		var/obj/item/reagent_containers/food/C = stored
		. += "The apparatus currently has [C] secured."
		if(length(C.reagents.reagent_list))
		else
			. += "Nothing."

/obj/item/borg/apparatus/food/update_icon(mob/living/silicon/robot/user)
	cut_overlays()
	if(stored)
		COMPILE_OVERLAYS(stored)
		stored.pixel_x = 0
		stored.pixel_y = 0
		var/image/img = image("icon"=stored, "layer"=FLOAT_LAYER)
		var/image/arm = image("icon"="borg_beaker_apparatus_arm", "layer"=FLOAT_LAYER)
		if(istype(stored, /obj/item/reagent_containers/food))
			arm.pixel_y = arm.pixel_y - 3
		img.plane = FLOAT_PLANE
		add_overlay(img)
		add_overlay(arm)
	else
		var/image/arm = image("icon"="borg_beaker_apparatus_arm", "layer"=FLOAT_LAYER)
		arm.pixel_y = arm.pixel_y - 5
		add_overlay(arm)

/obj/item/borg/apparatus/food/attack_self(mob/living/silicon/robot/user)
	if(stored && !user.client?.keys_held["Alt"] && user.a_intent != "help")
		var/obj/item/reagent_containers/C = stored
		C.SplashReagents(get_turf(user))
		loc.visible_message("<span class='notice'>[user] spills the contents of the [C] all over the floor.</span>")
		return
	. = ..()
