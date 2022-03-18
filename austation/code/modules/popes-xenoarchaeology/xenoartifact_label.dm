// Not to be confused with labeler

/obj/item/xenoartifact_label
    icon = 'austation/icons/obj/xenoartifact.dmi'
    icon_state = "star"
    var/sticker_state = "star_small"
    name = "Xenoartifact Label"
    desc = "An adhesive label describing the characteristics of a Xenoartifact."
    var/info = "" //Actual information 
    var/mutable_appearance/sticker_overlay

/obj/item/xenoartifact_label/Initialize()
    sticker_overlay = mutable_appearance(icon, sticker_state)
    sticker_overlay.layer = FLOAT_LAYER
    ..()
    
/obj/item/xenoartifact_label/attack(atom/target, mob/user)
    if(istype(target, /mob/living))
        target.add_overlay(sticker_overlay)
        addtimer(CALLBACK(src, .proc/remove_sticker, target), 15 SECONDS)
    ..()

/obj/item/xenoartifact_label/proc/remove_sticker(mob/target) //Peels off, I guess
    target.cut_overlay(sticker_overlay)
