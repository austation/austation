/mob/living/silicon/pai/proc/choose_chassis_austation()
    var/static/list/chassis_icon

    if(!chassis_icon)
        chassis_icon = list(
        "repairbot" = image(icon = 'icons/mob/pai.dmi', icon_state = "repairbot"),
        "cat" = image(icon = 'icons/mob/pai.dmi', icon_state = "cat"),
        "mouse" = image(icon = 'icons/mob/pai.dmi', icon_state = "mouse"),
        "monkey" = image(icon = 'icons/mob/pai.dmi', icon_state = "monkey"),
        "corgi" = image(icon = 'icons/mob/pai.dmi', icon_state = "corgi"),
        "fox" = image(icon = 'icons/mob/pai.dmi', icon_state = "fox"),
        "rabbit" = image(icon = 'icons/mob/pai.dmi', icon_state = "rabbit"),
        "bat" = image(icon = 'icons/mob/pai.dmi', icon_state = "bat"),
        "butterfly" = image(icon = 'icons/mob/pai.dmi', icon_state = "butterfly"),
        "hawk" = image(icon = 'icons/mob/pai.dmi', icon_state = "hawk"),
        "lizard" = image(icon = 'icons/mob/pai.dmi', icon_state = "lizard"),
        "duffel" = image(icon = 'icons/mob/pai.dmi', icon_state = "duffel"),
		"snake" = image(icon = 'icons/mob/pai.dmi', icon_state = "snake"),
		"spider" = image(icon = 'icons/mob/pai.dmi', icon_state = "spider"),
		"frog" = image(icon = 'icons/mob/pai.dmi', icon_state = "frog"))

    var/choice = show_radial_menu(usr, usr , chassis_icon, custom_check = CALLBACK(src, .proc/check_menu, usr), radius = 42, require_near = TRUE)

    if(!choice)
        return FALSE
    chassis = choice
    update_resting()
    to_chat(src, "<span class='boldnotice'>You switch your holochassis projection composite to [chassis]</span>")

/mob/living/silicon/pai/proc/check_menu(mob/living/user)
    if(!istype(user))
        return FALSE
    if(user.incapacitated())
        return FALSE
    if(!isturf(loc) && loc != card)
        to_chat(src, "<span class='boldwarning'>You can not change your holochassis composite while not on the ground or in your card!</span>")
        return FALSE
    return TRUE
