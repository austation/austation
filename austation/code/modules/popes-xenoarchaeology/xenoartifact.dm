/obj/item/xenoartifact
    name = "Xenoartifact"
    icon = 'austation/icons/obj/xenoartifact/xenartifact.dmi'
    icon_state = "map_editor"
    w_class = WEIGHT_CLASS_TINY
    heat = 1000 //I think I set this for on_burn stuff?
    light_color = LIGHT_COLOR_FIRE
    desc = "A strange alien artifact. What could it possibly do?"

    
    var/charge = 0 //How much input the artifact is getting from activator traits
    var/charge_req //This isn't a requirement anymore. This just affects how effective the charge is

    var/material //Associated traits & colour
    var/datum/xenoartifact_trait/traits[5] //activation trait, minor 1, minor 2, minor 3, major
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

/obj/item/xenoartifact/Initialize(mapload, difficulty)
    . = ..()
    material = difficulty
    if(!difficulty)
        material = pick(BLUESPACE, PLASMA, URANIUM, AUSTRALIUM)
    add_atom_colour(material, FIXED_COLOUR_PRIORITY)

    switch(material)
        if(BLUESPACE)
            generate_traits(list(/datum/xenoartifact_trait/minor/sharp, /datum/xenoartifact_trait/minor/radioactive,
                            /datum/xenoartifact_trait/minor/sentient, /datum/xenoartifact_trait/major/sing, 
                            /datum/xenoartifact_trait/major/laser, /datum/xenoartifact_trait/major/bomb))
            if(!price)
                price = pick(100, 200, 300)

        if(PLASMA)
            generate_traits(list(/datum/xenoartifact_trait/major/sing, /datum/xenoartifact_trait/activator/burn,
                            /datum/xenoartifact_trait/minor/dense, /datum/xenoartifact_trait/minor/sentient, 
                            /datum/xenoartifact_trait/major/capture, /datum/xenoartifact_trait/major/timestop,
                            /datum/xenoartifact_trait/major/bomb, /datum/xenoartifact_trait/major/mirrored,
                            /datum/xenoartifact_trait/major/corginator,/datum/xenoartifact_trait/activator/clock,
                            /datum/xenoartifact_trait/major/invisible))
            if(!price)
                price = pick(200, 300, 500)

        if(URANIUM)
            generate_traits(list(/datum/xenoartifact_trait/major/sing, /datum/xenoartifact_trait/minor/sharp,
                            /datum/xenoartifact_trait/major/laser, /datum/xenoartifact_trait/major/corginator,
                            /datum/xenoartifact_trait/minor/sentient, /datum/xenoartifact_trait/minor/wearable)) 
            if(!price)
                price = pick(300, 500, 800) 

        if(AUSTRALIUM)
            generate_traits(list(/datum/xenoartifact_trait/major/sing)) //Wild card, exlcuding debug for obvious reasons
            if(!price)
                price = pick(500, 800, 1000) 

    for(var/datum/xenoartifact_trait/T in traits) //This is kinda weird but it stops certain runtime cases. I can probaly revisit this To:Do
        if(istype(T, /datum/xenoartifact_trait/minor/dense))
            T.on_init(src)
    for(var/datum/xenoartifact_trait/T in traits)
        T.on_init(src)

    //Generative art process, I'd like to maybe revisit this. To:Do
    icon_state = "lump_[pick(1, 2, 3, 4, 5)]"
    for(var/I in icon_slots)
        while(!(icon_slots[I])||icon_slots[I] == icon_state||icon_slots[I] == icon_slots[I-1]) //Still messy but better than before. I could probably revise this.
            icon_slots[I] = "lump_[pick(1, 2, 3, 4, 5)]"
            icon_overlay = mutable_appearance(icon, icon_slots[I])
            icon_overlay.layer = FLOAT_LAYER
            icon_overlay.appearance_flags = RESET_ALPHA// Not doing this fucks the alpha, something to do with it being cumulative
            icon_overlay.alpha = alpha
            src.add_overlay(icon_overlay)

/obj/item/xenoartifact/examine(mob/user)
    for(var/obj/item/clothing/glasses/science/S in user.contents)
        to_chat(user, "<span class='notice'>[special_desc]</span>")
    . = ..()

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
        if(!proximity && get_dist(target, user) > 2)
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
    var/slueth_item //Items used in trait's on_item clues
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
            if(charge += NORMAL*T.on_burn(src, user, I.heat))
                burn_activator = TRUE   
                return    
    if(impact_activator && !burn_activator)
        check_charge(user)
    ..()
/*
    check_charge() is essentially what runs all the minor & major trait activations. 
    This process also culls and irrelivent targets in reference to max_range and calculates the true charge.
    True charge is simply, almost, the average of the charge and charge_req. This allows for a unique varience of 
    output from artifacts, generally producing some funny results too.
    
*/
/obj/item/xenoartifact/proc/check_charge(mob/user, charge_mod)
    for(var/mob/M in true_target)
        if(get_dist(user, M) > max_range)   
            true_target -= M

    charge = charge + charge_mod
    if(manage_cooldown(TRUE))
        for(var/datum/xenoartifact_trait/minor/T in traits)
            T.activate(src, user, user)
        charge = (charge+charge_req)/1.9 //Not quite an average. Generally produces higher results.      
        for(var/mob/living/M in true_target)
            for(var/datum/xenoartifact_trait/major/T in traits)
                T.activate(src, M, user)
        if(!true_target)
            for(var/datum/xenoartifact_trait/major/T in traits)
                T.activate(src, null, user)
        true_target = list(null)
        charge = 0
        var/datum/xenoartifact_trait/minor/capacitive/C
        C = get_trait(/datum/xenoartifact_trait/minor/capacitive)
        if(C.charges)
            manage_cooldown()
    else    
        charge = 0
        true_target = list(null)

/obj/item/xenoartifact/proc/manage_cooldown(checking = FALSE)
    if(!usedwhen)
        if(!(checking))
            usedwhen = world.time //Should I be using a different measure here?
        return TRUE
    else if(usedwhen + cooldown + cooldownmod < world.time)
        cooldownmod = 0
        usedwhen = null
        return TRUE
    else 
        return FALSE

/*
    generate_traits() is used to, as you'd guess, generate traits. 
    The argument passed is a list of blacklisted traits you don't your artifact to have, allowing
    for a defenition of artifact types.
    The process also generates some partial hints, like a touch description and science-glasses desrection(special_desc)
*/
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

    charge_req = 10*rand(1, 10) //This is here just in-case I decide to change how this works.
    
/obj/item/xenoartifact/proc/get_proximity(range) //Will I really reuse this?
    for(var/mob/living/M in range(range, get_turf(loc)))
        return M
    return null

/obj/item/xenoartifact/proc/get_trait(typepath) //Returns the desired trait and it's values
    //return (locate(typepath) in traits)
    for(var/datum/xenoartifact_trait/T in traits)
        if(istype(T, typepath))
            return T
    return FALSE
/*
    Stuff in here is generally things I didn't want to use callbacks for. 
    Getto timers and such.
*/
/obj/item/xenoartifact/process(delta_time)
    switch(process_type)
        if("lit")
            //say("lit")
            true_target = list(get_proximity(3))
            charge = NORMAL*traits[1].on_burn(src) 
            if(manage_cooldown(TRUE) && true_target)
                set_light(0)
                visible_message("<span class='danger'>The [name] flicks out.</span>")
                check_charge(true_target[1])
                process_type = ""
                return PROCESS_KILL

        if("tick")
            //say("tick")
            true_target = list(get_proximity(2))
            if(manage_cooldown(TRUE))
                charge += NORMAL*traits[1].on_impact(src) 
            if(manage_cooldown(TRUE))
                check_charge()
            charge = 0 //Don't really need to do this but, I am skeptical
        else    
            return PROCESS_KILL

/obj/item/xenoartifact/Destroy() //To:Do should all contents be allowed a second chance?
    for(var/mob/living/C in contents) //People inside only have a 50/50 chance of surviving a collapse.
        if(pick(FALSE, TRUE))
            C.forceMove(get_turf(loc))
    qdel(src)
    ..()
