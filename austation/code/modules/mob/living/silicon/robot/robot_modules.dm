/obj/item/robot_module/medical/be_transformed_to(obj/item/robot_module/old_module) //Pick a icon starts here

	var/mob/living/silicon/robot/R = loc
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in list("Default", "Heavy", "Sleek", "Marina", "Droid", "Eyebot")
	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Default")
			cyborg_base_icon = "medical"
		if("Droid")
			cyborg_base_icon = "cmedical"
			hat_offset = 4
		if("Sleek")
			cyborg_base_icon = "sleekmed"
		if("Marina")
			cyborg_base_icon = "marinamed"
		if("Eyebot")
			cyborg_base_icon = "eyebotmed"
		if("Heavy")
			cyborg_base_icon = "heavymed"
	return ..()

/obj/item/robot_module/engineering/be_transformed_to(obj/item/robot_module/old_module) //Pick a icon starts here

	var/mob/living/silicon/robot/R = loc
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in list("Default", "Heavy", "Sleek", "Marina", "Can", "Spider", "Handy")
	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Default")
			cyborg_base_icon = "engineer"
		if("Heavy")
			cyborg_base_icon = "heavyeng"
		if("Sleek")
			cyborg_base_icon = "sleekeng"
		if("Marina")
			cyborg_base_icon = "marinaeng"
		if("Can")
			cyborg_base_icon = "caneng"
		if("Spider")
			cyborg_base_icon = "spidereng"
		if("Handy")
			cyborg_base_icon = "handyeng"
	return ..()

/obj/item/robot_module/security/be_transformed_to(obj/item/robot_module/old_module) //Pick a icon starts here

	var/mob/living/silicon/robot/R = loc
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in list("Default", "Heavy", "Sleek", "Can", "Marina", "Spider")
	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Default")
			cyborg_base_icon = "sec"
		if("Heavy")
			cyborg_base_icon = "heavysec"
		if("Sleek")
			cyborg_base_icon = "sleeksec"
		if("Can")
			cyborg_base_icon = "cansec"
		if("Marina")
			cyborg_base_icon = "marinasec"
		if("Spider")
			cyborg_base_icon = "spidersec"
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
			cyborg_base_icon = "whitespider"
	return ..()

/obj/item/robot_module/janitor/be_transformed_to(obj/item/robot_module/old_module) //Pick a icon starts here

	var/mob/living/silicon/robot/R = loc
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in list("Default", "Can", "Marina", "Sleek")
	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Default")
			cyborg_base_icon = "janitor"
		if("Can")
			cyborg_base_icon = "canjan"
		if("Marina")
			cyborg_base_icon = "marinajan"
		if("Sleek")
			cyborg_base_icon = "sleekjan"
	return ..()

