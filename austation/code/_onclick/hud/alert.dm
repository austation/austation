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
