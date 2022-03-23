/obj/item/xenoartifact_labeler
    name = "Xenoartifact Labeler"
    icon = 'icons/obj/library.dmi'
    icon_state = "scanner"
    desc = "A tool scientists use to label their alien bombs."
    throw_speed = 3
    throw_range = 5
    w_class = WEIGHT_CLASS_TINY

    var/list/activator = list(null) //Checked component.
    var/list/activator_traits = list() //Display names

    var/list/minor_trait = list(null, null, null)
    var/list/minor_traits = list()

    var/list/major_trait = list(null)
    var/list/major_traits = list() 

    var/list/info_list = list() 

    var/sticker_name
    var/list/sticker_traits = list()//passed down to sticker

/obj/item/xenoartifact_labeler/Initialize()
    . = ..()
    get_trait_list_desc(activator_traits, /datum/xenoartifact_trait/activator)

/obj/item/xenoartifact_labeler/interact(mob/user)
    //ui_interact(user, "XenoartifactLabeler")
    ..()

/obj/item/xenoartifact_labeler/ui_interact(mob/user, datum/tgui/ui)
    ui = SStgui.try_update_ui(user, src, ui)
    if(!ui)
        ui = new(user, src, "XenoartifactLabeler")
        ui.open()

/obj/item/xenoartifact_labeler/ui_data(mob/user)
    var/list/data = list()
    data["activator"] = activator
    data["activator_traits"] = get_trait_list_desc(activator_traits, /datum/xenoartifact_trait/activator)

    data["minor_trait"] = minor_trait
    data["minor_traits"] = get_trait_list_desc(minor_traits, /datum/xenoartifact_trait/minor)

    data["major_trait"] = major_trait
    data["major_traits"] = get_trait_list_desc(major_traits, /datum/xenoartifact_trait/major)

    data["info_list"] = info_list

    return data

/obj/item/xenoartifact_labeler/ui_act(action, params)
    if(..())
        return

    if(action == "print_traits")
        create_label(sticker_name)
        //reset all lists
        activator = list(null)
        minor_trait = list(null, null, null)
        major_trait = list(null)
        info_list = list()

    if(action == "change_print_name")
        sticker_name = params["name"]

    trait_toggle(action, "activator", activator_traits, activator)
    trait_toggle(action, "minor", minor_traits, minor_trait)
    trait_toggle(action, "major", major_traits, major_trait)

    . = TRUE
    update_icon()

/obj/item/xenoartifact_labeler/proc/get_trait_list_desc(list/traits, trait_type)//Get a list of all the specified trait types names, actually
    for(var/T in typesof(trait_type))
        var/datum/xenoartifact_trait/X = new T
        if(X.desc && !(X.desc in traits)) //Don't think checking for null is needed here?
            traits += list(X.desc)
        else if(X.label_name && !(X.label_name in traits)) //For cases where the trait doesn't have a desc
            traits += list(X.label_name)
    return traits

/obj/item/xenoartifact_labeler/proc/look_for(list/place, culprit) //This isn't really needed but, It's easier to use as a function
    for(var/X in place)
        if(X == culprit)
            return TRUE
    return FALSE

/obj/item/xenoartifact_labeler/afterattack(atom/target, mob/user)
    ..()
    var/obj/item/xenoartifact_label/P = create_label(sticker_name)
    if(!P.afterattack(target, user))
        del(P)

/obj/item/xenoartifact_labeler/proc/create_label(new_name)
    var/obj/item/xenoartifact_label/P = new /obj/item/xenoartifact_label/(get_turf(src))
    if(new_name)
        P.name = new_name
        P.set_name = TRUE
    P.trait_list = sticker_traits
    P.info = activator+minor_trait+major_trait
    return P

/obj/item/xenoartifact_labeler/proc/trait_toggle(action, toggle_type, var/list/trait_list, var/list/active_trait_list)
    var/datum/xenoartifact_trait/description_holder
    var/new_trait
    for(var/T in trait_list)
        new_trait = desc2datum(T)
        description_holder = new new_trait
        if(action == "assign_[toggle_type]_[T]")
            if(!look_for(active_trait_list, T))
                active_trait_list += list(T)
                info_list += description_holder.label_desc
                sticker_traits += new_trait
            else
                active_trait_list -= list(T)
                info_list -= description_holder.label_desc
                sticker_traits -= new_trait

/obj/item/xenoartifact_labeler/proc/desc2datum(udesc) //This is just a hacky way of getting the info from a datum using its desc becuase I wrote this last and it's not heartbreaking
    for(var/T in typesof(/datum/xenoartifact_trait))
        var/datum/xenoartifact_trait/X = new T
        if(udesc == X.desc) //using an || here makes it fucky
            return T
        else if(udesc == X.label_name)
            return T
    return "[udesc]: There's no known information on [udesc]!."
