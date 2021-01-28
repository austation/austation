/**
  * Proc called when giving an item to another player
  *
  * This handles creating an alert and adding an overlay to it
  */
/mob/living/carbon/proc/give()
	var/obj/item/receiving = get_active_held_item()
	if(!receiving)
		to_chat(src, "<span class='warning'>You're not holding anything to give!</span>")
		return
	visible_message("<span class='notice'>[src] is offering [receiving]</span>", \
					"<span class='notice'>You offer [receiving]</span>", null, 2)
	for(var/mob/living/carbon/C in orange(1, src))
		if(!CanReach(C))
			return
		var/obj/screen/alert/give/G = C.throw_alert("[src]", /obj/screen/alert/give)
		if(!G)
			return
		G.setup(C, src, receiving)

/**
  * Proc called when the player clicks the give alert
  *
  * Handles checking if the player taking the item has open slots and is in range of the giver
  * Also deals with the actual transferring of the item to the players hands
  * Arguments:
  * * giver - The person giving the original item
  * * I - The item being given by the giver
  */
/mob/living/carbon/proc/take(mob/living/carbon/giver, obj/item/I)
	clear_alert("[giver]")
	if(get_dist(src, giver) > 1)
		to_chat(src, "<span class='warning'>[giver] is out of range! </span>")
		return
	if(!I || giver.get_active_held_item() != I)
		to_chat(src, "<span class='warning'>[giver] is no longer holding the item they were offering! </span>")
		return
	if(!get_empty_held_indexes())
		to_chat(src, "<span class='warning'>You have no empty hands!</span>")
		return
	if(!giver.temporarilyRemoveItemFromInventory(I))
		visible_message("<span class='notice'>[src] tries to hand over [I] but it's stuck to them....", \
						"<span class'notice'> You make a fool of yourself trying to give away an item stuck to your hands")
		return
	put_in_hands(I)
