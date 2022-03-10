/atom/movable/screen/alert/restrained/surrendered
	name = "Surrender"
	desc = "You've surrendered yourself. Click the alert or click resist to stop."
	icon = 'austation/icons/mob/actions/actions.dmi'
	icon_state = "surrender"

/atom/movable/screen/alert/restrained/surrendered/Click()
	var/mob/living/carbon/human/L = usr
	if(!istype(L) || L != owner)
		return
	L.surrender()

/atom/movable/screen/alert/not_enough_ch4
	name = "Choking (No CH4)"
	desc = "You're not getting enough methane. Find some good air before you pass out!"
	icon_state = "not_enough_ch4"
	icon = 'austation/icons/mob/screen_alert.dmi'

/atom/movable/screen/alert/too_much_ch4
	name = "Choking (CH4)"
	desc = "There's too much methane in the air, and you're breathing it in! Find some good air before you pass out!"
	icon_state = "too_much_ch4"
	icon = 'austation/icons/mob/screen_alert.dmi'

/atom/movable/screen/alert/not_enough_ch3br
	name = "Choking (No CH3Br)"
	desc = "You're not getting enough methyl bromide. Find some good air before you pass out!"
	icon_state = "not_enough_tox"

/atom/movable/screen/alert/too_much_ch3br
	name = "Choking (CH3Br)"
	desc = "There's highly toxic methyl bromide in the air and you're breathing it in. Find some fresh air. The box in your backpack has an oxygen tank and gas mask in it."
	icon_state = "too_much_tox"
