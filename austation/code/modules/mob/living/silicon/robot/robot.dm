/mob/living/silicon/robot/proc/pick_module_austation()
	if(module.type != /obj/item/robot_module)
		return

	if(wires.is_cut(WIRE_RESET_MODULE))
		to_chat(src,"<span class='userdanger'>ERROR: Module installer reply timeout. Please check internal connections.</span>")
		return

	var/list/modulelist = list(
		"Standard" = image(icon = 'icons/mob/robots.dmi', icon_state = "robot"),
		"Engineering" = image(icon = 'icons/mob/robots.dmi', icon_state = "engineer"),
		"Medical" = image(icon = 'icons/mob/robots.dmi', icon_state = "medical"),
		"Miner" = image(icon = 'icons/mob/robots.dmi', icon_state = "miner"),
		"Janitor" = image(icon = 'icons/mob/robots.dmi', icon_state = "janitor"),
		"Service" = image(icon = 'icons/mob/robots.dmi', icon_state = "service_m"),
		"Peacekeeper" = image(icon = 'icons/mob/robots.dmi', icon_state = "peace"))
	
	var/input_module = show_radial_menu(src, src, modulelist, custom_check = CALLBACK(src, .proc/check_menu), radius = 38, require_near = TRUE, tooltips = TRUE)

	usr.visible_message("","<span class='userdanger'>Input_module: [input_module]</span>")
	var/selected_module = ""
	switch(input_module)
		if("Standard")
			selected_module = /obj/item/robot_module/standard
		if("Engineering")
			selected_module = /obj/item/robot_module/engineering
		if("Medical")
			selected_module = /obj/item/robot_module/medical
		if("Miner")
			selected_module = /obj/item/robot_module/miner
		if("Janitor")
			selected_module = /obj/item/robot_module/janitor
		if("Service")
			selected_module = /obj/item/robot_module/butler
		if("Peacekeeper")
			selected_module = /obj/item/robot_module/peacekeeper

	usr.visible_message("","<span class='userdanger'>Selected_module: [selected_module] </span>")

	usr.module.transform_to(selected_module)

	return ..()

/mob/living/silicon/robot/proc/check_menu()
	if(!istype(src))
		return FALSE
	if(incapacitated())
		return FALSE
	return TRUE
