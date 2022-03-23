/obj/item/xenoartifact //Most of these values are generated on initialize
    name = "Xenoartifact"
    icon = 'austation/icons/obj/xenoartifact/xenartifact.dmi'
    icon_state = "map_editor"
    w_class = WEIGHT_CLASS_TINY
    heat = 1000
    light_color = LIGHT_COLOR_FIRE
    desc = "The Xenoartifact is made from a"
    
    var/charge = 0 //How much input the artifact is getting from activator traits
    var/charge_req //How much input is required to start the activation

    var/material //Associated traits & colour
    var/datum/xenoartifact_trait/traits[5] //activation trait, minor 1, minor 2, minor 3, major
    var/datum/xenoartifact_trait/touch_desc
    var/process_type = ""
    var/min_desc //Just a holder for examine desc from minor traits

    var/atom/true_target = list()
    var/usedwhen //holder for worldtime
    var/cooldown = 8 SECONDS //Time between uses
    var/cooldownmod = 0 //Extra time traits can add to the cooldown.

    var/icon_slots[2] //Used for generating sprites
    var/mutable_appearance/icon_overlay

    var/modifier = 0.70 //Buying and selling related
    var/price //default price get generated if it isn't set 

/obj/item/xenoartifact/Initialize(mapload, difficulty)
    . = ..()
    material = difficulty
    if(!difficulty)
        material = pick(BLUESPACE, PLASMA, URANIUM, AUSTRALIUM)
    if(!price)
        price = pick(100,300,500)
    add_atom_colour(material, FIXED_COLOUR_PRIORITY)

    switch(material)
        if(BLUESPACE)
            generate_traits(list(/datum/xenoartifact_trait/minor/sharp, /datum/xenoartifact_trait/minor/radioactive,
                            /datum/xenoartifact_trait/minor/sentient, /datum/xenoartifact_trait/major/sing, 
                            /datum/xenoartifact_trait/major/laser, /datum/xenoartifact_trait/major/bomb))

        if(PLASMA)
            generate_traits(list(/datum/xenoartifact_trait/major/sing, /datum/xenoartifact_trait/activator/burn,
                            /datum/xenoartifact_trait/minor/dense, /datum/xenoartifact_trait/minor/sentient, 
                            /datum/xenoartifact_trait/major/capture, /datum/xenoartifact_trait/major/timestop,
                            /datum/xenoartifact_trait/major/bomb, /datum/xenoartifact_trait/major/mirrored,
                            /datum/xenoartifact_trait/major/corginator))

        if(URANIUM)
            generate_traits(list(/datum/xenoartifact_trait/major/sing, /datum/xenoartifact_trait/minor/sharp,
                            /datum/xenoartifact_trait/major/laser, /datum/xenoartifact_trait/major/corginator,
                            /datum/xenoartifact_trait/minor/sentient))  

        if(AUSTRALIUM)
            generate_traits(list(/datum/xenoartifact_trait/major/sing)) //Wild card, exlcuding debug for obvious reasons

    for(var/datum/xenoartifact_trait/T in traits) //This is kinda weird but it stops certain runtime cases. I can probaly revisit this To:Do
        if(istype(T, /datum/xenoartifact_trait/minor/dense))
            T.on_init(src)
    for(var/datum/xenoartifact_trait/T in traits)
        T.on_init(src)

    icon_state = "lump_[pick(1, 2, 3, 4, 5)]" //This is gross, fix this. To:Do
    icon_slots[1] = "lump_[pick(1, 2, 3, 4, 5)]"
    icon_slots[2] = "lump_[pick(1, 2, 3, 4, 5)]"
    icon_overlay = mutable_appearance(icon, icon_slots[1])
    icon_overlay.layer = FLOAT_LAYER
    icon_overlay.alpha = alpha
    icon_overlay.appearance_flags = RESET_ALPHA
    src.add_overlay(icon_overlay)
    icon_overlay = mutable_appearance(icon, icon_slots[2])
    icon_overlay.layer = FLOAT_LAYER
    icon_overlay.alpha = alpha
    icon_overlay.appearance_flags = RESET_ALPHA
    src.add_overlay(icon_overlay)

/obj/item/xenoartifact/interact(mob/user)
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

/obj/item/xenoartifact/attack(atom/target, mob/user)
    . = ..()
    if(!(manage_cooldown(TRUE)))
        return
    true_target += target
    var/impact_activator
    for(var/datum/xenoartifact_trait/T in traits)
        if(istype(target, /mob/living) && (charge += COMBAT*T.on_impact(src, user)))
            impact_activator = TRUE
        else if(charge += NORMAL*T.on_impact(src, user) && !istype(target, /mob/living))
            impact_activator = TRUE
    if(impact_activator)
        check_charge(user)      

/obj/item/xenoartifact/afterattack(atom/target, mob/user, proximity)
    . = ..()
    if(!(manage_cooldown(TRUE)))
        return
    var/impact_activator
    for(var/datum/xenoartifact_trait/T in traits)
        if(!proximity && get_dist(target, user) > 1)
            if(charge += EASY*T.on_impact(src, user))
                true_target += target
                impact_activator = TRUE
    if(impact_activator)
        check_charge(user)

/obj/item/xenoartifact/throw_impact(atom/target, mob/user)
    . = ..()
    if(!(manage_cooldown(TRUE)))
        return
    if(!..()) //ignore if caught
        return
    true_target += target
    var/impact_activator
    for(var/datum/xenoartifact_trait/T in traits)
        if(charge += NORMAL*T.on_impact(src, user))
            impact_activator = TRUE
    if(impact_activator)
        check_charge(null)

/obj/item/xenoartifact/attackby(obj/item/I, mob/living/user)
    ..()
    if(!(manage_cooldown(TRUE)))
        return
    true_target += user
    var/impact_activator
    var/burn_activator
    var/msg = I.ignition_effect(src, user)
    if(istype(I, /obj/item/xenoartifact_label)||istype(I, /obj/item/xenoartifact_labeler))
        return

    for(var/datum/xenoartifact_trait/T in traits)
        if(charge += NORMAL*T.on_impact(src, user))
            impact_activator = TRUE
        if(msg) //Check this first, otherwise on_burn gets proc'd by anything.
            if(charge += NORMAL*T.on_burn(src, user))
                burn_activator = TRUE
    if(impact_activator && !burn_activator)
        check_charge(null)

/obj/item/xenoartifact/proc/check_charge(mob/user, charge_mod) //Run traits. User is generally passed to use as a fail-safe.
    charge = charge + charge_mod
    if(manage_cooldown(TRUE))
        for(var/datum/xenoartifact_trait/minor/T in traits)
            T.activate(src, user, user)
        if(charge >= charge_req)              
            for(var/mob/living/M in true_target)
                for(var/datum/xenoartifact_trait/major/T in traits)
                    T.activate(src, M, user)
            if(!true_target)
                for(var/datum/xenoartifact_trait/major/T in traits)
                    T.activate(src, null, user)
            charge = 0
            manage_cooldown()
            true_target = null
            true_target = list() //Not reassigning it to a list-datum breaks it somehow
    else    
        charge = 0
        true_target = null
        true_target = list()
    if(!(get_trait(/datum/xenoartifact_trait/minor/capacitive)))
        charge = 0 //You can probably optimize these three lines
    true_target = null
    true_target = list() //Not reassigning it to a list-datum breaks it somehow

/obj/item/xenoartifact/proc/manage_cooldown(checking = FALSE)
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

/obj/item/xenoartifact/proc/generate_traits(list/blacklist_traits)
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
        desc = "[desc] [traits[1].desc]"

    for(var/T in typesof(/datum/xenoartifact_trait/minor))
        if(!(T in blacklist_traits) && T != /datum/xenoartifact_trait/minor)
            minors += T
    for(var/X in 2 to 4)
        new_trait = pick(minors)
        minors -= new_trait
        traits[X] = new new_trait
        if(traits[X].desc && !min_desc)
            min_desc = traits[X].desc
            desc = "[desc] [min_desc]"
        if(traits[X].on_touch(src, src))
            touch_desc = traits[X]
    desc = "[desc] material."

    for(var/T in typesof(/datum/xenoartifact_trait/major))
        if(!(T in blacklist_traits) && T != /datum/xenoartifact_trait/major)
            majors += T
    new_trait = pick(majors)
    traits[5] = new new_trait
    if(traits[5].desc)
        desc = "[desc] The shape is [traits[5].desc]."
    if(traits[5].on_touch(src, src) && !(touch_desc))
        touch_desc = traits[5]

    if(get_trait(/datum/xenoartifact_trait/minor/capacitive))
        charge_req = 10*rand(1, 10) //To:Do change how charge is picked to better match activator
    else
        charge_req = 10*rand(1, 7)
    
/obj/item/xenoartifact/proc/get_proximity(range) //Will I really reuse this?
    for(var/mob/living/M in range(range, get_turf(loc)))
        return M

/obj/item/xenoartifact/proc/get_trait(typepath)
    return (locate(typepath) in traits)

/obj/item/xenoartifact/process(delta_time)
    switch(process_type)
        if("lit") //possible revisit this To:Do this is broken
            say("lit")
            true_target = null
            true_target = list(get_proximity(3))
            if(get_trait(/datum/xenoartifact_trait/minor/capacitive))
                charge += NORMAL*traits[1].on_burn(src) //Clean this To:Do
            else
                charge = NORMAL*traits[1].on_burn(src) 
            if(charge >= charge_req && manage_cooldown(TRUE) && true_target)
                set_light(0)
                visible_message("<span class='danger'>The [name] flicks out.</span>")
                check_charge()
                return PROCESS_KILL
            else if(charge < charge_req && manage_cooldown(TRUE) && true_target && !(get_trait(/datum/xenoartifact_trait/minor/capacitive))) //you'll never reach charge in this case
                set_light(0)
                visible_message("<span class='danger'>The [name] flicks out.</span>")
                check_charge()
                return PROCESS_KILL
        if("tick")
            say("tick")
            true_target = list(get_proximity(2))
            if(manage_cooldown(TRUE))
                charge += NORMAL*traits[1].on_impact(src) 
            if(charge >= charge_req && manage_cooldown(TRUE))
                check_charge()
            charge = 0 //Don't really need to do this but, I am fearfull
        else    
            return PROCESS_KILL

/obj/item/xenoartifact/Destroy()
    for(var/mob/living/C in contents) //People inside only have a 50/50 chance of surviving a collapse.
        if(pick(FALSE, TRUE))
            C.forceMove(get_turf(loc))
    qdel(src)
    ..()
