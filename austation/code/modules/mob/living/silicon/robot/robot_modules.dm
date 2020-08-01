/obj/item/robot_module/medical/be_transformed_to(obj/item/robot_module/old_module) //Pick a icon starts here

	var/mob/living/silicon/robot/R = loc
	var/list/robotstyles_med = list(
		"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "medical"),
		"Heavy" = image(icon = 'austation/icons/mob/robots.dmi', icon_state = "heavymed"),
		"Sleek" = image(icon = 'austation/icons/mob/robots.dmi', icon_state = "sleekmed"),
		"Marina" = image(icon = 'austation/icons/mob/robots.dmi', icon_state = "marinamed"),
		"Eyebot" = image(icon = 'austation/icons/mob/robots.dmi', icon_state = "eyebotmed"),
		"Droid" = image(icon = 'austation/icons/mob/robots.dmi', icon_state = "cmedical"),
		"Skirt" = image(icon = 'austation/icons/mob/robots.dmi', icon_state = "banangarang-Medical"))
	
	var/borg_icon = show_radial_menu(src, src, robotstyles_med, custom_check = CALLBACK(src, .proc/check_menu), radius = 38, require_near = TRUE)

	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Default")
			cyborg_base_icon = "medical"
		if("Heavy")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "heavymed"
			hat_offset = -4
		if("Sleek")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "sleekmed"
			hat_offset = -1
		if("Marina")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "marinamed"
			hat_offset = 2
		if("Eyebot")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "eyebotmed"
			hat_offset = -3
		if("Droid")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "cmedical"
			hat_offset = 4
		if("Skirt")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "banangarang-Medical"
			hat_offset = 0
	return ..()

/obj/item/robot_module/engineering/be_transformed_to(obj/item/robot_module/old_module) //Pick a icon starts here

	var/mob/living/silicon/robot/R = loc
	var/list/robotstyles_eng = list(
		"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "engineer"),
		"Heavy" = image(icon = 'austation/icons/mob/robots.dmi', icon_state = "heavyeng"),
		"Sleek" = image(icon = 'austation/icons/mob/robots.dmi', icon_state = "sleekeng"),
		"Marina" = image(icon = 'austation/icons/mob/robots.dmi', icon_state = "marinaeng"),
		"Can" = image(icon = 'austation/icons/mob/robots.dmi', icon_state = "caneng"),
		"Spider" = image(icon = 'austation/icons/mob/robots.dmi', icon_state = "spidereng"),
		"Skirt" = image(icon = 'austation/icons/mob/robots.dmi', icon_state = "banangarang-Engineering"))
	
	var/borg_icon = show_radial_menu(src, src, robotstyles_eng, custom_check = CALLBACK(src, .proc/check_menu), radius = 38, require_near = TRUE)

	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Default")
			cyborg_base_icon = "engineer"
		if("Heavy")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "heavyeng"
			hat_offset = -4
		if("Sleek")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "sleekeng"
			hat_offset = -1
		if("Marina")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "marinaeng"
			hat_offset = 2
		if("Can")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "caneng"
			hat_offset = 3
		if("Spider")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "spidereng"
			hat_offset = -3
		if("Handy")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "handyeng"
		if("Skirt")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "banangarang-Engineering"
			hat_offset = 0
	return ..()

/obj/item/robot_module/security/be_transformed_to(obj/item/robot_module/old_module) //Pick a icon starts here

	var/mob/living/silicon/robot/R = loc
	var/list/robotstyles_sec = list(
		"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "sec"),
		"Heavy" = image(icon = 'austation/icons/mob/robots.dmi', icon_state = "heavysec"),
		"Sleek" = image(icon = 'austation/icons/mob/robots.dmi', icon_state = "sleeksec"),
		"Marina" = image(icon = 'austation/icons/mob/robots.dmi', icon_state = "marinasec"),
		"Can" = image(icon = 'austation/icons/mob/robots.dmi', icon_state = "cansec"),
		"Spider" = image(icon = 'austation/icons/mob/robots.dmi', icon_state = "spidersec"),
		"Skirt" = image(icon = 'austation/icons/mob/robots.dmi', icon_state = "banangarang-Security"))
	
	var/borg_icon = show_radial_menu(src, src, robotstyles_sec, custom_check = CALLBACK(src, .proc/check_menu), radius = 38, require_near = TRUE)

	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Default")
			cyborg_base_icon = "sec"
		if("Heavy")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "heavysec"
			hat_offset = -4
		if("Sleek")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "sleeksec"
			hat_offset = -1
		if("Marina")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "marinasec"
			hat_offset = 2
		if("Can")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "cansec"
			hat_offset = 3
		if("Spider")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "spidersec"
			hat_offset = -3
		if("Skirt")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "banangarang-Security"
			hat_offset = 0
	return ..()

/obj/item/robot_module/peacekeeper/be_transformed_to(obj/item/robot_module/old_module) //Pick a icon starts here

	var/mob/living/silicon/robot/R = loc
	var/list/robotstyles_sec = list(
		"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "peace"),
		"Spider" = image(icon = 'austation/icons/mob/robots.dmi', icon_state = "whitespider"))
	
	var/borg_icon = show_radial_menu(src, src, robotstyles_peace, custom_check = CALLBACK(src, .proc/check_menu), radius = 38, require_near = TRUE)

	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Default")
			cyborg_base_icon = "peace"
		if("Spider")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "whitespider"
	return ..()

/obj/item/robot_module/janitor/be_transformed_to(obj/item/robot_module/old_module) //Pick a icon starts here

	var/mob/living/silicon/robot/R = loc
	var/list/robotstyles_jan = list(
		"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "janitor"),
		"Sleek" = image(icon = 'austation/icons/mob/robots.dmi', icon_state = "sleekjan"),
		"Can" = image(icon = 'austation/icons/mob/robots.dmi', icon_state = "canjan"),
		"Marina" = image(icon = 'austation/icons/mob/robots.dmi', icon_state = "marinajan"),
		"Skirt" = image(icon = 'austation/icons/mob/robots.dmi', icon_state = "banangarang-Janitor"))
	
	var/borg_icon = show_radial_menu(src, src, robotstyles_jan, custom_check = CALLBACK(src, .proc/check_menu), radius = 38, require_near = TRUE)

	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Default")
			cyborg_base_icon = "janitor"
		if("Sleek")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "sleekjan"
			hat_offset = -1
		if("Can")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "canjan"
			hat_offset = 3
		if("Marina")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "marinajan"
			hat_offset = 2
		if("Skirt")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "banangarang-Janitor"
			hat_offset = 0
	return ..()

