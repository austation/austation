/mob/living/carbon/human/verb/toggle_rings()
	set name = "Toggle rings"
	set category = "IC"
	var/datum/preferences/prefs = client.prefs

	if(ismecha(loc))
		return

	if(incapacitated())
		return

	if(prefs.ring_type != RING_DISABLED)
		if(src.ringsoff == FALSE)
			ringsoff = TRUE
			to_chat(src, "<span class='notice'>You take off your ring.</span>")
		else
			ringsoff = FALSE
			to_chat(src, "<span class='notice'>You put your rings back on.</span>")
	else
		to_chat(src, "<span class='warning'>You don't have any rings.</span>")

/mob/living/carbon/human/verb/lick()
	set name = "Lick Someone"
	set category = "IC"
	set desc = "Lick someone nearby!"

	if(incapacitated(ignore_restraints = TRUE))
		to_chat(src, "<span class='warning'>You can't do that while incapacitated.</span>")
		return

	var/list/lickable = list()
	for(var/mob/living/L in view(1))
		if(L != src && Adjacent(L))
			LAZYADD(lickable, L)
	for(var/mob/living/listed in lickable)
		lickable[listed] = new /mutable_appearance(listed)

	if(!lickable)
		return

	var/mob/living/tasted = show_radial_menu(src, src, lickable, radius = 40, require_near = TRUE)

	if(QDELETED(tasted) || !Adjacent(tasted) || incapacitated(ignore_restraints = TRUE))
		return

	visible_message("<span class='warning'>[src] licks [tasted]!</span>","<span class='notice'>You lick [tasted].</span>","<b>Slurp!</b>")
