/mob/living/silicon/robot/proc/pick_module_austation()
	if(module.type != /obj/item/robot_module)
		return

	if(wires.is_cut(WIRE_RESET_MODULE))
		to_chat(src,"<span class='userdanger'>ERROR: Module installer reply timeout. Please check internal connections.</span>")
		return

	var/list/modulelist = list(
		"Engineering" = image(icon = 'icons/mob/robots.dmi', icon_state = "engineer"),
		"Medical" = image(icon = 'icons/mob/robots.dmi', icon_state = "medical"),
		"Miner" = image(icon = 'icons/mob/robots.dmi', icon_state = "miner"),
		"Janitor" = image(icon = 'icons/mob/robots.dmi', icon_state = "janitor"),
		"Service" = image(icon = 'icons/mob/robots.dmi', icon_state = "service_m"))

	if(!CONFIG_GET(flag/disable_peaceborg))
		modulelist["Peacekeeper"] = image(icon = 'icons/mob/robots.dmi', icon_state = "peace")
	if(!CONFIG_GET(flag/disable_secborg))
		modulelist["Security"] = image(icon = 'icons/mob/robots.dmi', icon_state = "sec")

	var/input_module = show_radial_menu(src, src, modulelist, custom_check = CALLBACK(src, .proc/check_menu, user), radius = 38, require_near = TRUE)

	module.transform_to(modulelist[input_module])
