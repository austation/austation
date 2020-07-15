/obj/item/robot_module/medical/be_transformed_to(obj/item/robot_module/old_module) //Pick a icon starts here

	var/mob/living/silicon/robot/R = loc
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in list("Default", "Heavy", "Sleek", "Marina", "Droid", "Eyebot", "Skirt")
	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Default")
			cyborg_base_icon = "medical"
		if("Droid")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "cmedical"
			hat_offset = 4
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
		if("Heavy")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "heavymed"
			hat_offset = -4
		if("Skirt")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "banangarang-Medical"
			hat_offset = 0
	if(R.ckey == "ZombiesVsPlants")
		borg_icon = "Skirt"
		return
	return ..()

/obj/item/robot_module/engineering/be_transformed_to(obj/item/robot_module/old_module) //Pick a icon starts here

	var/mob/living/silicon/robot/R = loc
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in list("Default", "Heavy", "Sleek", "Marina", "Can", "Spider", "Handy", "Skirt")
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
	if(R.ckey == "ZombiesVsPlants")
		borg_icon = "Skirt"
		return
	return ..()

/obj/item/robot_module/security/be_transformed_to(obj/item/robot_module/old_module) //Pick a icon starts here

	var/mob/living/silicon/robot/R = loc
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in list("Default", "Heavy", "Sleek", "Can", "Marina", "Spider", "Skirt")
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
		if("Can")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "cansec"
			hat_offset = 3
		if("Marina")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "marinasec"
			hat_offset = 2
		if("Spider")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "spidersec"
			hat_offset = -3
		if("Skirt")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "banangarang-Security"
			hat_offset = 0
	if(R.ckey == "ZombiesVsPlants")
		borg_icon = "Skirt"
		return
	return ..()

/obj/item/robot_module/peacekeeper/be_transformed_to(obj/item/robot_module/old_module) //Pick a icon starts here

	var/mob/living/silicon/robot/R = loc
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in list("Default", "Spider")
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
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in list("Default", "Can", "Marina", "Sleek", "Skirt")
	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Default")
			cyborg_base_icon = "janitor"
		if("Can")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "canjan"
			hat_offset = 3
		if("Marina")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "marinajan"
			hat_offset = 2
		if("Sleek")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "sleekjan"
			hat_offset = -1
		if("Skirt")
			R.icon = 'austation/icons/mob/robot.dmi'
			cyborg_base_icon = "banangarang-Janitor"
			hat_offset = 0
	if(R.ckey == "ZombiesVsPlants")
		borg_icon = "Skirt"
		return
	return ..()

