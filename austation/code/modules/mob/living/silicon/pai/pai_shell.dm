/mob/living/silicon/pai/proc/choose_chassis_austation()
    var/mob/living/silicon/pai/R = loc
    var/static/list/possible_chassis

    if(!possible_chassis)
        possible_chassis = list(
        "Repair" = image(icon = 'icons/mob/pai.dmi', icon_state = "repairbot"),
        "Cat" = image(icon = 'icons/mob/pai.dmi', icon_state = "cat"),
        "Mouse" = image(icon = 'icons/mob/pai.dmi', icon_state = "mouse"),
        "Monkey" = image(icon = 'icons/mob/pai.dmi', icon_state = "monkey"),
        "Corgi" = image(icon = 'icons/mob/pai.dmi', icon_state = "corgi"),
        "Fox" = image(icon = 'icons/mob/pai.dmi', icon_state = "fox"),
        "Rabbit" = image(icon = 'icons/mob/pai.dmi', icon_state = "rabbit"),
        "Bat" = image(icon = 'icons/mob/pai.dmi', icon_state = "bat"),
        "Butterfly" = image(icon = 'icons/mob/pai.dmi', icon_state = "butterfly"),
        "Hawk" = image(icon = 'icons/mob/pai.dmi', icon_state = "hawk"),
        "Lizard" = image(icon = 'icons/mob/pai.dmi', icon_state = "lizard"),
        "Bag" = image(icon = 'icons/mob/pai.dmi', icon_state = "duffel"))

    var/selected = show_radial_menu(R, R , possible_chassis, custom_check = CALLBACK(src, .proc/check_menu, R), radius = 42, require_near = TRUE)

/mob/living/silicon/pai/proc/check_menu(mob/living/user)
    if(!istype(user))
        return FALSE
    if(user.incapacitated())
        return FALSE
    if(!isturf(loc) && loc != card)
        to_chat(src, "<span class='boldwarning'>You can not change your holochassis composite while not on the ground or in your card!</span>")
        return FALSE
    return TRUE