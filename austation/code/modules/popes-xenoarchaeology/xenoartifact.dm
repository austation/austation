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
    var/datum/xenoartifact_trait/traits[6] //activation trait, minor 1, minor 2, minor 3, major, malfunction To:Do I could probably make this a normal list
    var/datum/xenoartifact_trait/touch_desc
    var/special_desc = "The Xenoartifact is made from a" //used for special examine circumstance, science goggles
    var/process_type = ""
    var/min_desc //Just a holder for examine special_desc from minor traits

    var/max_range = 1
    var/list/true_target = list()
    var/usedwhen //holder for worldtime
    var/cooldown = 8 SECONDS //Time between uses
    var/cooldownmod = 0 //Extra time traits can add to the cooldown

    var/icon_slots[4] //Used for generating sprites 1:top 2:bottom 3:left 4:right To:Do I could probably make this a normal list
    var/mutable_appearance/icon_overlay

    var/modifier = 0.70 //Buying and selling related
    var/price //default price gets generated if it isn't set by console. This only happens if the artifact spawns outside of that process. 

    var/malfunction_chance //Everytime the artifact is used this increases. When this is successfully proc'd the artifact gains a malfunction and this is lowered. 
    var/malfunction_mod = 1 //How much the chance can increase in a sinlge itteration

/obj/item/xenoartifact/Initialize(mapload, difficulty)
    . = ..()
    material = difficulty
    if(!difficulty)
        material = pick(BLUESPACE, PLASMA, URANIUM, AUSTRALIUM)

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
            malfunction_mod = 2

        if(URANIUM)
            generate_traits(list(/datum/xenoartifact_trait/major/sing, /datum/xenoartifact_trait/minor/sharp,
                            /datum/xenoartifact_trait/major/laser, /datum/xenoartifact_trait/major/corginator,
                            /datum/xenoartifact_trait/minor/sentient, /datum/xenoartifact_trait/minor/wearable)) 
            if(!price)
                price = pick(300, 500, 800) 
            malfunction_mod = 5
            var/datum/xenoartifact_trait/T = pick(subtypesof(/datum/xenoartifact_trait/malfunction))
            traits[6] = new T

        if(AUSTRALIUM)
            generate_traits(list(/datum/xenoartifact_trait/major/sing)) //Wild card, exlcuding debug for obvious reasons
            if(!price)
                price = pick(500, 800, 1000) 
            malfunction_mod = 2

    for(var/datum/xenoartifact_trait/T in traits) //This is kinda weird but it stops certain runtime cases. I can probaly revisit this To:Do
        if(istype(T, /datum/xenoartifact_trait/minor/dense))
            T.on_init(src)
    for(var/datum/xenoartifact_trait/T in traits)
        T.on_init(src)

    //Random sprite process, I'd like to maybe revisit this, make it a function. To:Do
    var/holdthisplease = pick(1, 2, 3)
    icon_state = "IB[holdthisplease]"//base
    generate_icon(icon, "IBL[holdthisplease]", material)
    if(pick(1, 0) || icon_slots[1])//Top
        if(!(icon_slots[1])) //Some traits can set this too, it will be set to a code that looks like 901, 908, 905 ect.
            icon_slots[1] = pick(1, 2)
        generate_icon(icon, "ITP[icon_slots[1]]")
        generate_icon(icon, "ITPL[icon_slots[1]]", material)

    if(pick(1,0,0) || icon_slots[3])//Left
        if(!(icon_slots[3]))
            icon_slots[3] = pick(1, 2)
        generate_icon(icon, "IL[icon_slots[3]]")
        generate_icon(icon, "ILL[icon_slots[3]]", material)

    if(pick(1, 0) || icon_slots[4])//Right
        if(!(icon_slots[4]))
            icon_slots[4] = pick(1, 2)
        generate_icon(icon, "IR[icon_slots[4]]")
        generate_icon(icon, "IRL[icon_slots[4]]", material)

    if(pick(1,0,0) || icon_slots[2])//Bottom
        if(!(icon_slots[2]))
            icon_slots[2] = pick(1, 2)
        generate_icon(icon, "IBTM[icon_slots[2]]")
        generate_icon(icon, "IBTML[icon_slots[2]]", material)

/obj/item/xenoartifact/examine(mob/user)
    for(var/obj/item/clothing/glasses/science/S in user.contents) //This isn't done the best, To:Do
        to_chat(user, "<span class='notice'>[special_desc]</span>")
    . = ..()

/obj/item/xenoartifact/interact(mob/user)
    . = ..()
    if(process_type == "lit")
        process_type = ""
        set_light(0)
        return
    if(user.a_intent == INTENT_GRAB)
        if(touch_desc)
            touch_desc.on_touch(src, user)
        return
    if(!(manage_cooldown(TRUE)))
        return
    for(var/datum/xenoartifact_trait/T in traits)
        if(charge += EASY*T.on_impact(src, user))
            check_charge(user)
            if(user.pulling) //I could possibly standardize this To:Do
                true_target += user.pulling
            else
                true_target += user

/obj/item/xenoartifact/attack(atom/target, mob/user)
    . = ..()
    if(!(manage_cooldown(TRUE)))
        return
    var/intensity = istype(target, /mob/living) ? COMBAT : NORMAL
    for(var/datum/xenoartifact_trait/T in traits)
        if(charge += intensity*T.on_impact(src, user))
            if(user.pulling)
                true_target += user.pulling
            else
                true_target += user
            check_charge(user)      

/obj/item/xenoartifact/afterattack(atom/target, mob/user, proximity)
    . = ..()
    if(!(manage_cooldown(TRUE))||!proximity && get_dist(target, user) > 2) //The proximity check might be considered messy, it's the result of various bugs
        return
    for(var/datum/xenoartifact_trait/T in traits)
        if(charge += EASY*T.on_impact(src, user))
            if(istype(target, /mob/living))
                if(user.pulling)
                    true_target += user.pulling
                else
                    true_target += user
            check_charge(user)

/obj/item/xenoartifact/throw_impact(atom/target, mob/user)
    . = ..()
    if(!(manage_cooldown(TRUE))||!..())
        return
    for(var/datum/xenoartifact_trait/T in traits)
        if(charge += NORMAL*T.on_impact(src, user))
            if(user.pulling)
                true_target += user.pulling
            else
                true_target += user
            check_charge(user)

/obj/item/xenoartifact/attackby(obj/item/I, mob/living/user)
    if(!(manage_cooldown(TRUE))||!(user.a_intent == INTENT_HARM)||istype(I, /obj/item/xenoartifact_label)||istype(I, /obj/item/xenoartifact_labeler))
        return
    for(var/datum/xenoartifact_trait/T in traits)
        if(T.on_item(src, user, I))
            return
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
        if(user.pulling)
            true_target += user.pulling
        else
            true_target += user
        check_charge(user)
    ..()
/*
    check_charge() is essentially what runs all the minor & major trait activations. 
    This process also culls and irrelivent targets in reference to max_range and calculates the true charge.
    True charge is simply, almost, the average of the charge and charge_req. This allows for a unique varience of 
    output from artifacts, generally producing some funny results too.
    
*/
/obj/item/xenoartifact/proc/check_charge(mob/user, charge_mod)
    if(prob(malfunction_chance))
        var/datum/xenoartifact_trait/T = pick(subtypesof(/datum/xenoartifact_trait/malfunction))
        traits[6] = new T
        malfunction_chance = malfunction_chance*0.2
    else    
        malfunction_chance += malfunction_mod

    for(var/atom/M in true_target)
        say(M)
        if(get_dist(src, M) > max_range)   
            true_target -= M
            say("[M] was removed, [get_dist(user, M)] away")
    charge = charge + charge_mod
    if(manage_cooldown(TRUE))
        for(var/datum/xenoartifact_trait/minor/T in traits)
            T.activate(src, user, user)
        charge = (charge+charge_req)/1.9 //Not quite an average. Generally produces slightly higher results.     
        for(var/atom/M in true_target)
            for(var/datum/xenoartifact_trait/malfunction/T in traits)
                T.activate(src, M, user)
            for(var/datum/xenoartifact_trait/major/T in traits)
                T.activate(src, M, user)
            if(!(get_trait(/datum/xenoartifact_trait/minor/aura))) //Quick fix for bug that selects multiple targets for noraisin
                break
        manage_cooldown()   
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
    generate_traits() is used to, as you'd guess, generate traits for the artifact. 
    The argument passed is a list of blacklisted traits you don't your artifact to have, allowing
    for a defenition of artifact types.
    The process also generates some partial hints, like a touch description and science-glasses desrection(special_desc)
    THis is probably unoptimized, To:Do
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
    blacklist_traits += list(traits[1].blacklist_traits)
    if(traits[1].desc)
        special_desc = "[special_desc] [traits[1].desc]"

    for(var/T in typesof(/datum/xenoartifact_trait/minor))
        if(!(T in blacklist_traits) && T != /datum/xenoartifact_trait/minor)
            minors += T
    for(var/X in 2 to 4)
        new_trait = pick(minors)
        minors -= new_trait
        traits[X] = new new_trait
        blacklist_traits += list(traits[X].blacklist_traits)
        if(traits[X].desc && !min_desc)
            min_desc = traits[X].desc
            special_desc = "[special_desc] [min_desc]"
        if(traits[X].on_touch(src, src))
            touch_desc = traits[X]
        minors = list(null)
        for(var/T in typesof(/datum/xenoartifact_trait/minor))
            if(!(T in blacklist_traits) && T != /datum/xenoartifact_trait/minor)
                minors += T
    special_desc = "[special_desc] material."
    for(var/T in typesof(/datum/xenoartifact_trait/major))
        if(!(T in blacklist_traits) && T != /datum/xenoartifact_trait/major)
            majors += T
    new_trait = pick(majors)
    traits[5] = new new_trait
    blacklist_traits += list(traits[5].blacklist_traits)
    if(traits[5].desc)
        special_desc = "[special_desc] The shape is [traits[5].desc]."
    if(traits[5].on_touch(src, src) && !(touch_desc))
        touch_desc = traits[5]

    charge_req = 10*rand(1, 10) //This is here just in-case I decide to change how this works.
    
/obj/item/xenoartifact/proc/get_proximity(range)
    for(var/mob/living/M in range(range, get_turf(src)))
        if(M.pulling && isliving(M.pulling))
            M = M.pulling
        return M
    return null

/obj/item/xenoartifact/proc/get_trait(typepath) //Returns the desired trait and it's values if it's in the artifact's
    //return (locate(typepath) in traits)
    for(var/datum/xenoartifact_trait/T in traits)
        if(istype(T, typepath))
            return T
    return FALSE

/obj/item/xenoartifact/proc/generate_icon(var/icn, var/icnst = "", colour) //Add extra icon components
    icon_overlay = mutable_appearance(icn, icnst)
    icon_overlay.layer = FLOAT_LAYER
    icon_overlay.appearance_flags = RESET_ALPHA// Not doing this fucks the alpha
    icon_overlay.alpha = alpha//
    if(colour)
        icon_overlay.color = colour
    src.add_overlay(icon_overlay)

/obj/item/xenoartifact/process(delta_time)
    switch(process_type)
        if("lit")
            true_target = list(get_proximity(max_range))
            charge = NORMAL*traits[1].on_burn(src) 
            if(manage_cooldown(TRUE) && true_target.len >= 1 && get_proximity(max_range))
                set_light(0)
                visible_message("<span class='danger'>The [name] flicks out.</span>")
                check_charge()
                process_type = ""
                return PROCESS_KILL
        if("tick")
            true_target = list(get_proximity(max_range))
            if(manage_cooldown(TRUE))
                charge += NORMAL*traits[1].on_impact(src) 
            if(manage_cooldown(TRUE))
                visible_message("<span class='notice'>The [name] ticks.</span>")
                check_charge()
                if(prob(15))
                    process_type = ""
            charge = 0 //Don't really need to do this but, I am skeptical
        else    
            return PROCESS_KILL

/obj/item/xenoartifact/Destroy()
    for(var/mob/living/C in contents) //mobs inside only have a 50/50 chance of surviving a collapse.
        if(pick(FALSE, TRUE))
            C.forceMove(get_turf(loc))
        else
            qdel(C)
    qdel(src)
    ..()
