/obj/item/multitool
	icon = 'austation/icons/obj/device.dmi'
	lefthand_file = 'austation/icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'austation/icons/mob/inhands/equipment/tools_righthand.dmi'

/obj/item/multitool/ai_detect/process()
	if(track_cooldown > world.time)
		return
	detect_state = PROXIMITY_NONE
	if(eye.eye_user)
		eye.setLoc(get_turf(src))
	multitool_detect()
	icon_state = "multitool" + detect_state
	update_icon()
	track_cooldown = world.time + track_delay
