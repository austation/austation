/mob/living/silicon/pai/proc/choose_chassis_austation()
    var/mob/living/silicon/pai/R = loc
    var/static/list/possible_chassis

    if(!possible_chassis)
        possible_chassis = list(
        "Repair" = image(icon = 'icon/mob/pai.dm', icon_state = "repairbot"),
        "Cat" = image(icon = 'icon/mob/pai.dm', icon_state = "cat"),
        "Mouse" = image(icon = 'icon/mob/pai.dm', icon_state = "mouse"),
        "Monkey" = image(icon = 'icon/mob/pai.dm', icon_state = "monkey"),
        "Corgi" = image(icon = 'icon/mob/pai.dm', icon_state = "corgi"),
        "Fox" = image(icon = 'icon/mob/pai.dm', icon_state = "fox"),
        "Rabbit" = image(icon = 'icon/mob/pai.dm', icon_state = "rabbit"),
        "Bat" = image(icon = 'icon/mob/pai.dm', icon_state = "bat"),
        "Butterfly" = image(icon = 'icon/mob/pai.dm', icon_state = "butterfly"),
        "Hawk" = image(icon = 'icon/mob/pai.dm', icon_state = "hawk"),
        "Lizard" = image(icon = 'icon/mob/pai.dm', icon_state = "lizard"),
        "Bag" = image(icon = 'icon/mob/pai.dm', icon_state = "duffel"))

    var/selected = show_radial_menu(R, R , possible_chassis, custom_check = CALLBACK(src, .proc/check_menu, R), radius = 42, require_near = TRUE)