/*
    Pretty much a duplicate of the regular item.
    I just use this space to keep the weird off-shoots. - Pope Francis
*/

/obj/structure/xenoartifact //Most of these values are given to the structure when the structure initializes
    name = "Xenoartifact"
    icon = 'austation/icons/obj/xenoartifact/xenartifact.dmi'
    icon_state = "map_editor"
    density = TRUE
    
    var/charge = 0 //How much input the artifact is getting from activator traits
    var/charge_req //This isn't a requirement anymore. This just affects how effective the charge is

    var/material //Associated traits & colour
    var/datum/xenoartifact_trait/traits[6] //activation trait, minor 1, minor 2, minor 3, major, malfunction
    var/datum/xenoartifact_trait/touch_desc
    var/special_desc = "The Xenoartifact is made from a"
    var/process_type = ""
    var/min_desc //Just a holder for examine special_desc from minor traits

    var/max_range = 1
    var/atom/true_target = list()
    var/usedwhen //holder for worldtime
    var/cooldown = 8 SECONDS //Time between uses
    var/cooldownmod = 0 //Extra time traits can add to the cooldown

    var/icon_slots[2] //Used for generating sprites
    var/mutable_appearance/icon_overlay

    var/modifier = 0.70 //Buying and selling related
    var/price //default price gest generated if it isn't set by console. This only happens if the artifact spawns outside of that process. 

/obj/structure/xenoartifact/Initialize()
    . = ..()
    for(var/datum/xenoartifact_trait/T in traits)
        say(T)
        if(!istype(T, /datum/xenoartifact_trait/minor/dense))
            T.on_init(src)

    var/holdthisplease = pick(1, 2, 3, 4)
    icon_state = "SB[holdthisplease]"//Base
    generate_icon(icon, "SBL[holdthisplease]", material)
    if(pick(1, 0) || icon_slots[1])//Top
        if(!(icon_slots[1])) //Some traits can set this too, it will be set to a code that looks like 9XX
            icon_slots[1] = pick(1, 2)
        generate_icon(icon, "STP[icon_slots[1]]")
        generate_icon(icon, "STPL[icon_slots[1]]", material)
        
    if(pick(1, 0) || icon_slots[2])//Bottom
        if(!(icon_slots[2]))
            icon_slots[2] = pick(1, 2)
        generate_icon(icon, "SBTM[icon_slots[2]]")
        generate_icon(icon, "SBTML[icon_slots[2]]", material)

    if(pick(1, 0) || icon_slots[3])//Left
        if(!(icon_slots[3]))
            icon_slots[3] = pick(1, 2)
        generate_icon(icon, "SL[icon_slots[3]]")
        generate_icon(icon, "SLL[icon_slots[3]]", material)

    if(pick(1, 0) || icon_slots[4])//Right
        if(!(icon_slots[4]))
            icon_slots[4] = pick(1, 2)
        generate_icon(icon, "SR[icon_slots[4]]")
        generate_icon(icon, "SRL[icon_slots[4]]", material)

/obj/structure/xenoartifact/examine(mob/user)
    for(var/obj/item/clothing/glasses/science/S in user.contents)
        to_chat(user, "<span class='notice'>[special_desc]</span>")
    . = ..()

/obj/structure/xenoartifact/attack_hand(mob/user)
    . = ..()
    if(touch_desc && user.a_intent == INTENT_GRAB)
        touch_desc.on_touch(src, user)
        return
    if(!(manage_cooldown(TRUE)))
        return 
    if(user.pulling)
        true_target += user.pulling
    else
        true_target += user
    var/impact_activator
    for(var/datum/xenoartifact_trait/T in traits)
        if(charge += EASY*T.on_impact(src, user))
            impact_activator = TRUE
    if(impact_activator)
        check_charge(user)
    if(process_type == "lit")
        process_type = ""
        set_light(0)

/obj/structure/xenoartifact/attackby(obj/item/I, mob/living/user)
    var/slueth_item
    for(var/datum/xenoartifact_trait/T in traits)
        if(T.on_item(src, user, I))
            slueth_item = TRUE
    if(slueth_item||!(manage_cooldown(TRUE))||!(user.a_intent == INTENT_HARM)||istype(I, /obj/item/xenoartifact_label)||istype(I, /obj/item/xenoartifact_labeler))
        return
    true_target += user
    var/impact_activator
    var/burn_activator
    var/msg = I.ignition_effect(src, user)
    for(var/datum/xenoartifact_trait/T in traits)
        if(charge += NORMAL*T.on_impact(src, user, I.force))
            impact_activator = TRUE
        if(msg)
            if(charge += NORMAL*T.on_burn(src, user))
                burn_activator = TRUE   
                return    
    if(impact_activator && !burn_activator)
        check_charge(user)
    ..()

/obj/structure/xenoartifact/proc/check_charge(mob/user, charge_mod) //Run traits. User is generally passed to use as a fail-safe.
    for(var/mob/M in true_target)
        say(M)
        if(get_dist(user, M) > max_range)   
            true_target -= M

    charge = charge + charge_mod
    if(manage_cooldown(TRUE))
        for(var/datum/xenoartifact_trait/minor/T in traits)
            T.activate(src, user, user)
        charge = (charge+charge_req)/1.9 //Not quite an average. Generally produces higher results.     
        say(charge) 
        for(var/atom/M in true_target)
            for(var/datum/xenoartifact_trait/major/T in traits)
                T.activate(src, M, user)
        if(!true_target)
            for(var/datum/xenoartifact_trait/major/T in traits)
                T.activate(src, null, user)
        true_target = list(null)
        charge = 0
        var/datum/xenoartifact_trait/minor/capacitive/C
        C = get_trait(/datum/xenoartifact_trait/minor/capacitive)
        if(C)
            if(C.charges)
                manage_cooldown()
            return
        manage_cooldown()
    else    
        charge = 0
        true_target = list(null)

/obj/structure/xenoartifact/proc/manage_cooldown(checking = FALSE)
    if(!usedwhen)
        if(!(checking))
            usedwhen = world.time
        return TRUE
    else if(usedwhen + cooldown + cooldownmod < world.time)
        cooldownmod = 0
        usedwhen = null
        return TRUE
    else 
        return FALSE

/obj/structure/xenoartifact/proc/generate_traits(list/blacklist_traits)
    var/list/activators = list()
    var/list/minors = list()
    var/list/majors = list()
    var/new_trait

    for(var/T in typesof(/datum/xenoartifact_trait/activator))
        if(!(T in blacklist_traits) && T != /datum/xenoartifact_trait/activator)
            activators += T
    new_trait = pick(activators)
    traits[1] = new new_trait
    if(traits[1].desc)
        special_desc = "[special_desc] [traits[1].desc]"

    for(var/T in typesof(/datum/xenoartifact_trait/minor))
        if(!(T in blacklist_traits) && T != /datum/xenoartifact_trait/minor)
            minors += T
    for(var/X in 2 to 4)
        new_trait = pick(minors)
        minors -= new_trait
        traits[X] = new new_trait
        if(traits[X].desc && !min_desc)
            min_desc = traits[X].desc
            special_desc = "[special_desc] [min_desc]"
        if(traits[X].on_touch(src, src))
            touch_desc = traits[X]
    special_desc = "[special_desc] material."

    for(var/T in typesof(/datum/xenoartifact_trait/major))
        if(!(T in blacklist_traits) && T != /datum/xenoartifact_trait/major)
            majors += T
    new_trait = pick(majors)
    traits[5] = new new_trait
    if(traits[5].desc)
        special_desc = "[special_desc] The shape is [traits[5].desc]."
    if(traits[5].on_touch(src, src) && !(touch_desc))
        touch_desc = traits[5]

    if(get_trait(/datum/xenoartifact_trait/minor/capacitive))
        charge_req = 10*rand(1, 10) //To:Do change how charge is picked to better match activator
    else
        charge_req = 10*rand(1, 7)
    
/obj/structure/xenoartifact/proc/get_proximity(range) //Will I really reuse this?
    for(var/mob/living/M in range(range, get_turf(loc)))
        return M

/obj/structure/xenoartifact/proc/get_trait(typepath)
    return (locate(typepath) in traits)

/obj/structure/xenoartifact/proc/generate_icon(var/icn, var/icnst = "") //Attack extra icons
    icon_overlay = mutable_appearance(icn, icnst)
    icon_overlay.layer = FLOAT_LAYER
    icon_overlay.appearance_flags = RESET_ALPHA// Not doing this fucks the alpha
    icon_overlay.alpha = alpha//
    src.add_overlay(icon_overlay)

/obj/structure/xenoartifact/process(delta_time)
    switch(process_type)
        if("lit")
            say("lit")
            true_target = list(get_proximity(max_range))
            charge = NORMAL*traits[1].on_burn(src) 
            if(manage_cooldown(TRUE) && true_target)
                set_light(0)
                visible_message("<span class='danger'>The [name] flicks out.</span>")
                check_charge(true_target[1])
                process_type = ""
                return PROCESS_KILL

        if("tick")
            say("tick")
            true_target = list(get_proximity(max_range))
            if(manage_cooldown(TRUE))
                charge += NORMAL*traits[1].on_impact(src) 
            if(manage_cooldown(TRUE))
                check_charge()
            charge = 0 //Don't really need to do this but, I am skeptical
        else    
            return PROCESS_KILL

/obj/structure/xenoartifact/Destroy()
    for(var/mob/living/C in contents) //mobs inside only have a 50/50 chance of surviving a collapse.
        if(pick(FALSE, TRUE))
            C.forceMove(get_turf(loc))
        else
            qdel(C)
    qdel(src)
    ..()
