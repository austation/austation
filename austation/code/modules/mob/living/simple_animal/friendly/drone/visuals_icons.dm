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
			visualAppearence = MAINTDRONE
			var/list/drone_colors = list(
				"blue" = image(icon = 'icons/mob/drone.dmi', icon_state = "[visualAppearence]_blue"),
				"green" = image(icon = 'icons/mob/drone.dmi', icon_state = "[visualAppearence]_green"),
				"grey" = image(icon = 'icons/mob/drone.dmi', icon_state = "[visualAppearence]_grey"),
				"orange" = image(icon = 'icons/mob/drone.dmi', icon_state = "[visualAppearence]_orange"),
				"pink" = image(icon = 'icons/mob/drone.dmi', icon_state = "[visualAppearence]_pink"),
				"red" = image(icon = 'icons/mob/drone.dmi', icon_state = "[visualAppearence]_red")
				)
			var/picked_color = show_radial_menu(src, src, drone_colors, custom_check = CALLBACK(src, .proc/check_menu), radius = 38, require_near = TRUE)
			if(picked_color)
				icon_state = "[visualAppearence]_[picked_color]"
				icon_living = "[visualAppearence]_[picked_color]"
			else
				icon_state = "[visualAppearence]_grey"
				icon_living = "[visualAppearence]_grey"

		if("Repair Drone")
			visualAppearence = REPAIRDRONE
			icon_state = visualAppearence
			icon_living = visualAppearence
			icon_dead = "[visualAppearence]_dead"

		if("Scout Drone")
			visualAppearence = SCOUTDRONE
			icon_state = visualAppearence
			icon_living = visualAppearence
			icon_dead = "[visualAppearence]_dead"

		else
			visualAppearence = MAINTDRONE
			icon_state = "[visualAppearence]_grey"
			icon_living = "[visualAppearence]_grey"
			icon_dead = "[visualAppearence]_dead"

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
