/obj/screen/alert/give // information set when the give alert is made
	icon_state = "default"
	var/mob/living/carbon/giver
	var/obj/item/receiving

/**
  * Handles assigning most of the variables for the alert that pops up when an item is offered
  *
  * Handles setting the name, description and icon of the alert and tracking the person giving
  * and the item being offered, also registers a signal that removes the alert from anyone who moves away from the giver
  * Arguments:
  * * taker - The person receiving the alert
  * * giver - The person giving the alert and item
  * * receiving - The item being given by the giver
  */
/obj/screen/alert/give/proc/setup(mob/living/carbon/taker, mob/living/carbon/giver, obj/item/receiving)
	name = "[giver] is offering [receiving]"
	desc = "[giver] is offering [receiving]. Click this alert to take it."
	icon_state = "template"
	cut_overlays()
	add_overlay(receiving)
	src.receiving = receiving
	src.giver = giver
	RegisterSignal(taker, COMSIG_MOVABLE_MOVED, .proc/removeAlert)

/obj/screen/alert/give/proc/removeAlert()
	to_chat(usr, "<span class='warning'>You moved out of range of [giver]!</span>")
	usr.clear_alert("[giver]")

/obj/screen/alert/give/Click(location, control, params)
	. = ..()
	var/mob/living/carbon/C = usr
	C.take(giver, receiving)
