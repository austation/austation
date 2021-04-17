/////////////////////  CONSUMABLE BALLOON  /////////////////////


/obj/item/balloon
	name = "deflated balloon"
	desc = "A small, deflated balloon.  You can use it in your hand to inflate it."
	icon = 'austation/icons/obj/structures/balloons.dmi'
	icon_state = "red"
	w_class = WEIGHT_CLASS_TINY
	var/coloring = "red"
	var/inflate_time = 20

/obj/item/balloon/Initialize()
	. = ..()
	var/list/colorslist = list(
		"red",
		"blue",
		"green",
		"yellow",
		"purple",
		"pink"
	)
	coloring = pick(colorslist)
	icon_state = coloring

/obj/item/balloon/attack_self(mob/living/user)
	. = ..()
	var/turf/T = get_turf(user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/U = user
	if(HAS_TRAIT(U, TRAIT_NOBREATH) || !U.getorganslot(ORGAN_SLOT_LUNGS))
		U.show_message("<span class='warning'> You can not blow up the balloon because you do not breathe!</span>")
		return
	if(!T)
		U.show_message("<span class='warning'> There is no room to inflate the balloon.</span>")
		return
	U.visible_message("<span class='notice'> [U] begins to inflate the balloon.</span>", "<span class='notice'> You begin to inflate the balloon.</span>", "", "<span class='notice'> You can hear someone blowing up a balloon.</span>", 7)
	if(!do_mob(U, U, inflate_time))
		return
	U.adjustOxyLoss(20)
	var/obj/structure/balloon/B = new(T)
	B.coloring = coloring + "_i"
	B.icon_state = B.coloring

	qdel(src)


/////////////////////  STATIONARY BALLOON  /////////////////////


/obj/structure/balloon
	name = "inflated balloon"
	desc = "An inflated balloon.  Looks quite nice, considering."
	icon = 'austation/icons/obj/structures/balloons.dmi'
	icon_state = "red_i"
	density = FALSE
	layer = ABOVE_MOB_LAYER
	var/coloring

/obj/structure/balloon/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(I.sharpness)
		Destroy()

/obj/structure/balloon/Destroy()
	. = ..()
	playsound(user, 'sound/effects/bang.ogg', 100, FALSE)


/////////////////////  BALLOON DISPENSER  /////////////////////


/obj/machinery/food_cart/balloons
	name = "Balloon Cart"
	desc = "A mobile cart that dispenses balloons"

/obj/machinery/food_cart/balloons/attack_hand(mob/living/carbon/human/user)
	. = ..()
	var/obj/item/balloon/B = new
	user.put_in_hands(B)

/obj/machinery/food_cart/balloons/ui_interact(mob/user)
	return //  No UI for this cart

