/mob/living/carbon/human/verb/surrender()
	set name = "Surrender"
	set category = "IC"
	var/mob/living/L = src
	var/t = 8
	var/image/I
	if(surrender_time > world.time)
		return
	if(has_status_effect(STATUS_EFFECT_SURRENDERED))
		I = image('icons/obj/closet.dmi', L, "cardboard_special", L.layer+1)
		addtimer(CALLBACK(src, remove_status_effect(STATUS_EFFECT_SURRENDERED)), 5 SECONDS)
		visible_message("[get_examine_name()] suddenly removes their hands from their head and attempts to launch to their feet.")
		clear_alert("surrendered")
		log_combat(L, L, "Unsurrendering")
	else
		I = image('austation/icons/mob/actions/actions.dmi', L, "surrender", L.layer+1)
		apply_status_effect(STATUS_EFFECT_SURRENDERED)
		visible_message("[get_examine_name()] puts their hands on their head and falls to the ground, surrendering.")
		t += 4
		throw_alert("surrendered", /atom/movable/screen/alert/restrained/surrendered)
		surrender_time = world.time + 5 SECONDS
		log_combat(L, L, "Surrendering")
	flick_overlay_view(I, L, t)
	I.alpha = 0
	animate(I, pixel_z = 32, alpha = 255, time = 5, easing = ELASTIC_EASING)

/mob/living/carbon/human/resist()
	if(has_status_effect(STATUS_EFFECT_SURRENDERED))
		surrender()
	..()
