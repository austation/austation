// Not to be confused with labeler
/obj/item/xenoartifact_label
    icon = 'austation/icons/obj/xenoartifact/xenoartifact_sticker.dmi'
    icon_state = "sticker_star"
    name = "Xenoartifact Label"
    desc = "An adhesive label describing the characteristics of a Xenoartifact."
    var/info = "" //Actual information 
    var/set_name = FALSE

    var/mutable_appearance/sticker_overlay

    var/list/trait_list = list() //List of traits used to compare and generate modifier.

/obj/item/xenoartifact_label/Initialize()
    var/sticker_state = "[icon_state]_small"
    sticker_overlay = mutable_appearance(icon, sticker_state)
    sticker_overlay.layer = FLOAT_LAYER
    sticker_overlay.appearance_flags = RESET_ALPHA
    sticker_overlay.appearance_flags = RESET_COLOR
    ..()
    
/obj/item/xenoartifact_label/afterattack(atom/target, mob/user)
    for(var/obj/item/xenoartifact_label/L in target.contents)
        target.name = name //You can update the name but, you should only really get one chance to slueth the traits
        return FALSE
    if(istype(target, /mob/living))
        to_chat(target, "<span class='notice'>[user] sticks a [src] to you.</span>")
        add_sticker(target)
        addtimer(CALLBACK(src, .proc/remove_sticker, target), 15 SECONDS)
        return TRUE
    else if(istype(target, /obj/item/xenoartifact)||istype(target, /obj/structure/xenoartifact))
        var/obj/item/xenoartifact/X = target
        calculate_modifier(X)
        add_sticker(target)
        if(set_name)
            target.name = name
        if(info)
            var/textinfo = list2text(info)
            target.desc = "[target.desc] There's a sticker attached, it says-\n[textinfo]" //To:Do: Clean this up, it outputs & symbols for some reason.
        return TRUE
    
/obj/item/xenoartifact_label/proc/add_sticker(mob/target)
    target.add_overlay(sticker_overlay)
    forceMove(target)

/obj/item/xenoartifact_label/proc/remove_sticker(mob/target) //Peels off
    target.cut_overlay(sticker_overlay)
    forceMove(get_turf(target))

/obj/item/xenoartifact_label/proc/calculate_modifier(obj/item/xenoartifact/X) //Modifier based off preformance of slueth
    var/datum/xenoartifact_trait/trait
    for(var/T in trait_list)
        trait = new T
        if(X.get_trait(trait))
            X.modifier += 0.15 
        else
            X.modifier -= 0.30

/obj/item/xenoartifact_label/proc/list2text(list/listo) //better than list2params for our purposes
    var/text = ""
    for(var/X in listo)
        if(X)
            text = "[text] [X]\n"
    return text       
