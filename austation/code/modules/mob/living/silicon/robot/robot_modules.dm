//Picking a custom borg sprite, called after a player picks their module
/obj/item/robot_module/medical/be_transformed_to(obj/item/robot_module/old_module) //medical
	var/mob/living/silicon/robot/R = loc
	var/static/list/robotstyles_med

	if(!robotstyles_med)
		robotstyles_med = list(
		"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "medical"),
		"Heavy" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "heavymed"),
		"Sleek" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "sleekmed"),
		"Marina" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "marinamed"),
		"Eyebot" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "eyebotmed"),
		"Droid" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "cmedical"),
		"Skirt" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "banangarang-Medical"))

	var/med_borg_icon = show_radial_menu(R, R , robotstyles_med, custom_check = CALLBACK(src, .proc/check_menu, R), radius = 42, require_near = TRUE)

	switch(med_borg_icon)
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
		else
			return FALSE
	return ..()

/obj/item/robot_module/engineering/be_transformed_to(obj/item/robot_module/old_module) //engineering
	var/mob/living/silicon/robot/R = loc
	var/static/list/robotstyles_eng

	if(!robotstyles_eng)
		robotstyles_eng = list(
		"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "engineer"),
		"Heavy" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "heavyeng"),
		"Sleek" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "sleekeng"),
		"Marina" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "marinaeng"),
		"Can" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "caneng"),
		"Spider" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "spidereng"),
		"Handy" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "handyeng"),
		"Skirt" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "banangarang-Engineering"))

	var/engi_borg_icon = show_radial_menu(R, R , robotstyles_eng, custom_check = CALLBACK(src, .proc/check_menu, R), radius = 42, require_near = TRUE)

	switch(engi_borg_icon)
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
			special_light_key = "banangarang-Standard"
			hat_offset = 0
		else
			return FALSE
	return ..()

/obj/item/robot_module/security/be_transformed_to(obj/item/robot_module/old_module) //security
	var/mob/living/silicon/robot/R = loc
	var/static/list/robotstyles_sec

	if(!robotstyles_sec)
		robotstyles_sec = list(
		"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "sec"),
		"Heavy" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "heavysec"),
		"Sleek" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "sleeksec"),
		"Marina" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "marinasec"),
		"Can" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "cansec"),
		"Spider" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "spidersec"),
		"Skirt" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "banangarang-Security"))

	var/sec_borg_icon = show_radial_menu(R, R , robotstyles_sec, custom_check = CALLBACK(src, .proc/check_menu, R), radius = 42, require_near = TRUE)

	switch(sec_borg_icon)
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
			special_light_key = "banangarang-Standard"
			hat_offset = 0
		else
			return FALSE
	return ..()

/obj/item/robot_module/peacekeeper/be_transformed_to(obj/item/robot_module/old_module) //peacekeeper
	var/mob/living/silicon/robot/R = loc
	var/static/list/robotstyles_peace

	if(!robotstyles_peace)
		robotstyles_peace = list(
		"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "peace"),
		"Spider" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "whitespider"),
		"Skirt" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "banangarang-Peacekeeper"),
		"Marina" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "marinapeace"))

	var/peace_borg_icon = show_radial_menu(R, R , robotstyles_peace, custom_check = CALLBACK(src, .proc/check_menu, R), radius = 42, require_near = TRUE)

	switch(peace_borg_icon)
		if("Default")
			cyborg_base_icon = "peace"
		if("Spider")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "whitespider"
		if("Marina")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "marinapeace"
			hat_offset = 2
		if("Skirt")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "banangarang-Peacekeeper"
			special_light_key = "banangarang-Peacekeeper"
			hat_offset = 0
		else
			return FALSE
	return ..()

/obj/item/robot_module/janitor/be_transformed_to() //janitor
	var/mob/living/silicon/robot/R = loc
	var/static/list/robotstyles_jan

	if(!robotstyles_jan)
		robotstyles_jan = list(
		"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "janitor"),
		"Sleek" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "sleekjan"),
		"Can" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "canjan"),
		"Marina" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "marinajan"),
		"Skirt" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "banangarang-Janitor"))

	var/jan_borg_icon = show_radial_menu(R, R , robotstyles_jan, custom_check = CALLBACK(src, .proc/check_menu, R), radius = 42, require_near = TRUE)

	switch(jan_borg_icon)
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
			special_light_key = "banangarang-Standard"
			hat_offset = 0
		else
			return FALSE
	return ..()

/obj/item/robot_module/butler/be_transformed_to(obj/item/robot_module/old_module) //service
	var/mob/living/silicon/robot/R = loc
	var/static/list/robotstyles_serv

	if(!robotstyles_serv)
		robotstyles_serv = list(
		"Waiter" = image(icon = 'icons/mob/robots.dmi', icon_state = "service_m"),
		"Waitress" = image(icon = 'icons/mob/robots.dmi', icon_state = "service_f"),
		"Heavy" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "heavyserv"),
		"Bro" = image(icon = 'icons/mob/robots.dmi', icon_state = "brobot"),
		"Kent" = image(icon = 'icons/mob/robots.dmi', icon_state = "kent"),
		"Tophat" = image(icon = 'icons/mob/robots.dmi', icon_state = "tophat"),
		"Skirt" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "banangarang-Service"))

	var/serv_borg_icon = show_radial_menu(R, R , robotstyles_serv, custom_check = CALLBACK(src, .proc/check_menu, R), radius = 42, require_near = TRUE)

	switch(serv_borg_icon)
		if("Waiter")
			cyborg_base_icon = "service_m"
		if("Waitress")
			cyborg_base_icon = "service_f"
		if("Heavy")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "heavyserv"
			special_light_key = "heavyserv"
		if("Bro")
			cyborg_base_icon = "brobot"
		if("Kent")
			cyborg_base_icon = "kent"
			special_light_key = "medical"
			hat_offset = 3
		if("Tophat")
			cyborg_base_icon = "tophat"
			special_light_key = null
			hat_offset = INFINITY //He is already wearing a hat
		if("Skirt")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "banangarang-Service"
			special_light_key = "banangarang-Standard"
			hat_offset = 0
		else
			return FALSE
	return ..()

/obj/item/robot_module/miner/be_transformed_to(obj/item/robot_module/old_module) //miner
	var/mob/living/silicon/robot/R = loc
	var/static/list/robotstyles_mine

	if(!robotstyles_mine)
		robotstyles_mine = list(
		"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "miner"),
		"Heavy" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "heavymin"),
		"Sleek" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "sleekmin"),
		"Marina" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "marinamin"),
		"Asteroid" = image(icon = 'icons/mob/robots.dmi', icon_state = "minerOLD"),
		"Can" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "canmin"),
		"Spider" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "spidermin"),
		"Droid" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "cminer"),
		"Skirt" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "banangarang-Miner"))

	var/mine_borg_icon = show_radial_menu(R, R , robotstyles_mine, custom_check = CALLBACK(src, .proc/check_menu, R), radius = 42, require_near = TRUE)

	switch(mine_borg_icon)
		if("Default")
			cyborg_base_icon = "miner"
		if("Heavy")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "heavymin"
			hat_offset = -3
		if("Sleek")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "sleekmin"
			hat_offset = -1
		if("Marina")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "marinamin"
			hat_offset = 2
		if("Asteroid")
			cyborg_base_icon = "minerOLD"
			special_light_key = "miner"
		if("Can")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "canmin"
			hat_offset = 3
		if("Spider")
			cyborg_base_icon = "spidermin"
			hat_offset = -3
		if("Droid")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "cminer"
			hat_offset = 4
		if("Skirt")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "banangarang-Miner"
			special_light_key = "banangarang-Standard"
			hat_offset = 0
		else
			return FALSE
	return ..()

/obj/item/robot_module/standard/be_transformed_to(obj/item/robot_module/old_module) //standard
	var/mob/living/silicon/robot/R = loc
	var/static/list/robotstyles_standard

	if(!robotstyles_standard)
		robotstyles_standard = list(
		"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "robot"),
		"Marina" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "marinasd"),
		"Heavy" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "heavysd"),
		"Skirt" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "banangarang-skirtsd"))

	var/standard_borg_icon = show_radial_menu(R, R , robotstyles_standard, custom_check = CALLBACK(src, .proc/check_menu, R), radius = 42, require_near = TRUE)

	switch(standard_borg_icon)
		if("Default")
			cyborg_base_icon = "robot"
		if("Marina")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "marinasd"
			hat_offset = 2
		if("Heavy")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "heavysd"
			hat_offset = -3
		if("Skirt")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "banangarang-skirtsd"
			hat_offset = 0
		else
			return FALSE
	return ..()

/obj/item/robot_module/syndicate/do_transform_animation() //asks the player to pick a sprite AFTER they spawn in and transform
	..()
	var/mob/living/silicon/robot/R = loc
	var/static/list/robotstyles_syndicate

	if(!robotstyles_syndicate)
		robotstyles_syndicate = list(
		"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "synd_sec"),
		"Spider" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "spidersyndi"),
		"Heavy" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "syndieheavy"),
		"Skirt" = image(icon = 'austation/icons/mob/robot.dmi', icon_state = "banangarang-synd"))

	var/syndicate_borg_icon = show_radial_menu(R, R , robotstyles_syndicate, custom_check = CALLBACK(src, .proc/check_menu, R), radius = 42, require_near = TRUE)

	switch(syndicate_borg_icon)
		if("Default")
			cyborg_base_icon = "synd_sec"
		if("Spider")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "spidersyndi"
			hat_offset = -3
		if("Heavy")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "syndieheavy"
			hat_offset = -3
		if("Skirt")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "banangarang-synd"
			hat_offset = 0
		else
			return FALSE
	return ..()

/obj/item/robot_module/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated() || !user.Adjacent(src))
		return FALSE
	return TRUE
