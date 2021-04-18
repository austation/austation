/////////////////////  CONSUMABLE BALLOON  /////////////////////


/obj/item/balloon
	name = "deflated balloon"
	desc = "A small, deflated balloon. You can use it in your hand to inflate it."
	icon = 'austation/icons/obj/structures/balloons.dmi'
	icon_state = "red"
	w_class = WEIGHT_CLASS_TINY
	var/inflate_time = 20
	var/static/list/colorslist = list(
		"red",
		"blue",
		"green",
		"yellow",
		"purple",
		"pink"
	)

/obj/item/balloon/Initialize()
	. = ..()
	icon_state = pick(colorslist)

/obj/item/balloon/attack_self(mob/living/user)
	. = ..()
	if(!istype(user))
		return
	if(HAS_TRAIT(user, TRAIT_NOBREATH) || !user.getorganslot(ORGAN_SLOT_LUNGS))
		user.show_message("<span class='warning'> You can not blow up the balloon because you do not breathe!</span>")
		return
	var/turf/T = get_turf(user)
	if(!T)
		user.show_message("<span class='warning'> There is no room to inflate the balloon.</span>")
		return
	user.visible_message("<span class='notice'> [user] begins to inflate the balloon.</span>", "<span class='notice'> You begin to inflate the balloon.</span>", "<span class='notice'> You can hear someone blowing up a balloon.</span>", 7)
	if(!do_mob(user, user, inflate_time))
		return
	user.adjustOxyLoss(20)
	var/obj/structure/balloon/B = new(T)
	B.icon_state = icon_state + "_i"

	qdel(src)


/////////////////////  STATIONARY BALLOON  /////////////////////


/obj/structure/balloon
	name = "inflated balloon"
	desc = "An inflated balloon.  Looks quite nice, considering."
	icon = 'austation/icons/obj/structures/balloons.dmi'
	icon_state = "red_i"
	density = FALSE
	layer = ABOVE_MOB_LAYER


/obj/structure/balloon/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(I.sharpness)
		Destroy()

/obj/structure/balloon/Destroy()
	playsound(src, 'sound/effects/bang.ogg', 100, FALSE)
	. = ..()

/obj/effect/spawner/bundle/balloons/ten
	name = "balloon bundle-10"
	icon = 'austation/icons/obj/structures/balloons.dmi'
	icon_state = "red"
	items = list(
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon
	)

/obj/effect/spawner/bundle/balloons/twenty
	name = "balloon bundle-20"
	icon = 'austation/icons/obj/structures/balloons.dmi'
	icon_state = "yellow"
	items = list(
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon,
		/obj/item/balloon
	)



/////////////////////  BALLOON DISPENSER  /////////////////////


/obj/machinery/food_cart/balloons
	name = "balloon cart"
	desc = "A mobile cart that dispenses balloons"

/obj/machinery/food_cart/balloons/attack_hand(mob/user)
	. = ..()
	var/turf/T = get_turf(src)
	if(!T)
		return
	var/obj/item/balloon/B = new(T)
	user.put_in_hands(B)

/obj/machinery/food_cart/balloons/ui_interact(mob/user)
	return //  No UI for this cart
