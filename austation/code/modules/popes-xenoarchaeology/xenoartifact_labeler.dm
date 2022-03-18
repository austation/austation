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

    var/sticker_name

/obj/item/xenoartifact_labeler/Initialize()
    get_trait_list(activator_traits, /datum/xenoartifact_trait/activator)
    . = ..()

/obj/item/xenoartifact_labeler/interact(mob/user)
    ui_interact(user, "XenoartifactLabeler")
    ..()

/obj/item/xenoartifact_labeler/ui_interact(mob/user, datum/tgui/ui)
    ui = SStgui.try_update_ui(user, src, ui)
    if(!ui)
        ui = new(user, src, "XenoartifactLabeler")
        ui.open()

/obj/item/xenoartifact_labeler/ui_data(mob/user)
    var/list/data = list()
    data["activator"] = activator
    data["activator_traits"] = get_trait_list(activator_traits, /datum/xenoartifact_trait/activator)

    data["minor_trait"] = minor_trait
    data["minor_traits"] = get_trait_list(minor_traits, /datum/xenoartifact_trait/minor)

    data["major_trait"] = major_trait
    data["major_traits"] = get_trait_list(major_traits, /datum/xenoartifact_trait/major)

    return data

/obj/item/xenoartifact_labeler/ui_act(action, params)
    if(..())
        return

    if(action == "print_traits")
        create_label(sticker_name)

    if(action == "change_print_name")
        sticker_name = params["name"]

    for(var/T in activator_traits) //This section may require clean up. Make it a fucntion
        if(action == "assign_activator_[T]")
            if(!look_for(activator, T))
                activator += list(T)
            else
                activator -= list(T)

    for(var/T in minor_traits)
        if(action == "assign_minor_[T]")
            if(!look_for(minor_trait, T))
                minor_trait += list(T)
            else
                minor_trait -= list(T)

    for(var/T in major_traits)
        if(action == "assign_major_[T]")
            if(!look_for(major_trait, T))
                major_trait += list(T)
            else
                major_trait -= list(T)

    . = TRUE
    update_icon()

/obj/item/xenoartifact_labeler/proc/get_trait_list(list/traits, trait_type)//Get a list of all the specified trait type.
    for(var/T in typesof(trait_type))
        var/datum/xenoartifact_trait/X = new T
        if(X.desc && !(X.desc in traits)) //Don't think checking for null is needed here?
            traits += list(X.desc)
        else if(X.label_desc && !(X.label_desc in traits)) //For cases where the trait doesn't have a desc
            traits += list(X.label_desc)
    return traits

/obj/item/xenoartifact_labeler/proc/look_for(list/place, culprit)
    for(var/X in place)
        if(X == culprit)
            return TRUE
    return FALSE

/obj/item/xenoartifact_labeler/attack(atom/target, mob/user)
    ..()
    if(istype(target, /obj/item/xenoartifact))
        create_label(sticker_name)

/obj/item/xenoartifact_labeler/proc/create_label(new_name)
    var/obj/item/xenoartifact_label/P = new /obj/item/xenoartifact_label/(get_turf(src))
    if(new_name)
        P.name = new_name
    P.info = "It's a [activator[1]]"
    return P
