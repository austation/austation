// Prompt for usr to pick [/mob/living/simple_animal/drone/var/visualAppearance] using a radial menu

/mob/living/simple_animal/drone/proc/pickVisualAppearenceAustation()
	picked = FALSE
    // Picking base type
	var/list/drone_icons = list(
		"Maintenance Drone" = image(icon = 'icons/mob/drone.dmi', icon_state = "[MAINTDRONE]_grey"),
		"Repair Drone" = image(icon = 'icons/mob/drone.dmi', icon_state = REPAIRDRONE),
		"Scout Drone" = image(icon = 'icons/mob/drone.dmi', icon_state = SCOUTDRONE)
		)
	var/picked_icon = show_radial_menu(src, src, drone_icons, custom_check = CALLBACK(src, .proc/check_menu), radius = 38, require_near = TRUE)
	switch(picked_icon)
		if("Maintenance Drone")
            // Picking Maintdrone colour
			appearance = MAINTDRONE
			var/list/drone_colors = list(
				"blue" = image(icon = 'icons/mob/drone.dmi', icon_state = "[appearance]_blue"),
				"green" = image(icon = 'icons/mob/drone.dmi', icon_state = "[appearance]_green"),
				"grey" = image(icon = 'icons/mob/drone.dmi', icon_state = "[appearance]_grey"),
				"orange" = image(icon = 'icons/mob/drone.dmi', icon_state = "[appearance]_orange"),
				"pink" = image(icon = 'icons/mob/drone.dmi', icon_state = "[appearance]_pink"),
				"red" = image(icon = 'icons/mob/drone.dmi', icon_state = "[appearance]_red")
				)
			var/picked_color = show_radial_menu(src, src, drone_colors, custom_check = CALLBACK(src, .proc/check_menu), radius = 38, require_near = TRUE)
			if(picked_color)
				icon_state = "[appearance]_[picked_color]"
				icon_living = "[appearance]_[picked_color]"
			else
				icon_state = "[appearance]_grey"
				icon_living = "[appearance]_grey"
		if("Repair Drone")
			appearance = REPAIRDRONE
			icon_state = appearance
			icon_living = appearance
		if("Scout Drone")
			appearance = SCOUTDRONE
			icon_state = appearance
			icon_living = appearance
		else
			appearance = MAINTDRONE
			icon_state = "[appearance]_grey"
			icon_living = "[appearance]_grey"
	icon_dead = "[appearance]_dead"
	picked = TRUE

/**
  * check_menu: Checks if we are allowed to interact with a radial menu
  */

/mob/living/simple_animal/drone/proc/check_menu()
	if(!istype(src))
		return FALSE
	if(incapacitated())
		return FALSE
	return TRUE