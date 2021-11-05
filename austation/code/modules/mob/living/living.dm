/mob/living/verb/surrender()
	set name = "Surrender"
	set category = "IC"
	var/mob/living/L = src
	var/t = 8
	var/image/I
	throw_alert("surrendered", /atom/movable/screen/alert/restrained/surrendered, new_master = L.surrendered)
	surrendered = !surrendered

	if(surrendered)
		I = image('austation/icons/mob/actions/actions.dmi', L, "surrender", L.layer+1)
		L.apply_status_effect(STATUS_EFFECT_PARALYZED)
		L.visible_message("[L.get_examine_name()] puts their hands on their head and falls to the ground, surrendering.")
		t += 4
	else
		I = image('icons/obj/closet.dmi', L, "cardboard_special", L.layer+1)
		addtimer(CALLBACK(src, L.remove_status_effect(STATUS_EFFECT_PARALYZED)), 50)
		L.visible_message("[L.get_examine_name()] suddenly removes their hands from their head and attempts to launch to their feet.")
	flick_overlay_view(I, L, t)
	I.alpha = 0
	animate(I, pixel_z = 32, alpha = 255, time = 5, easing = ELASTIC_EASING)

/mob/living/resist()
	if(surrendered)
		surrender()
	..()
