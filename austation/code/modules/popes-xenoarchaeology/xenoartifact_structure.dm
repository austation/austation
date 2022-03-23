/obj/structure/xenoartifact //Most of these values are given to the structure when the structure initializes
    name = "Xenoartifact"
    icon = 'icons/obj/plushes.dmi'
    icon_state = "lizardplush"
    density = TRUE
    
    var/charge = 0 //How much input the artifact is getting from activator traits
    var/charge_req //How much input is required to start the activation
    var/datum/xenoartifact_trait/traits[5] //activation trait, minor 1, minor 2, minor 3, major
    var/datum/xenoartifact_trait/touch_desc
    var/atom/true_target = list() //last target.
    var/usedwhen //holder for worldtime
    var/cooldown = 8 SECONDS //Time between uses
    var/cooldownmod = 0 //Extra time traits can add to the cooldown.
    var/material //Associated traits & colour
    var/lit = FALSE//Specific to burn
    var/min_desc //Just a holder for examine desc from minor traits
    var/icon_slots[2] //Used for generating sprites
    var/mutable_appearance/icon_overlay

/obj/structure/xenoartifact/Initialize()
    . = ..()
    for(var/datum/xenoartifact_trait/T in traits)
        if(!istype(T, /datum/xenoartifact_trait/minor/dense))
            T.on_init(src)

/obj/structure/xenoartifact/attack_hand(mob/user)
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
    if(lit)
        lit = FALSE
        set_light(0)
    if(touch_desc)
        touch_desc.on_touch(src, user)
    ..()


/obj/structure/xenoartifact/throw_impact(atom/target, mob/user)
    if(!..()) //ignore if caught
        return
    true_target += target
    var/impact_activator
    for(var/datum/xenoartifact_trait/T in traits)
        if(charge += NORMAL*T.on_impact(src, target))
            impact_activator = TRUE
    if(impact_activator)
        check_charge(null)

/obj/structure/xenoartifact/attackby(obj/item/I, mob/living/user)
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
    if(burn_activator && !lit && manage_cooldown(TRUE))
        sleep(2 SECONDS)
        lit = TRUE
        START_PROCESSING(SSobj, src)
        set_light(2)
        visible_message("<span class='danger'>The [name] sparks on.</span>")
    ..()

/obj/structure/xenoartifact/proc/check_charge(mob/user, charge_mod) //Run traits. User is generally passed to use as a fail-safe.
    charge = charge + charge_mod
    if(manage_cooldown(TRUE))
        for(var/datum/xenoartifact_trait/minor/T in traits)
            T.activate(src, user, user)
        if(charge >= charge_req)
            for(var/mob/living/M in true_target)
                for(var/datum/xenoartifact_trait/major/T in traits)
                    T.activate(src, M, user)
            charge = 0
            true_target = null
            true_target = list() //Not reassigning it to a list-datum breaks it somehow
            manage_cooldown()
    else    
        charge = 0
        visible_message("<span class='notice'>The [name] echos emptily.</span>")
    if(!(get_trait(/datum/xenoartifact_trait/minor/capacitive)))
        charge = 0

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
    if(traits[5].on_touch(src, src))
        touch_desc = traits[5]
    
/obj/structure/xenoartifact/proc/get_proximity(range) //Will I really reuse this?
    for(var/mob/living/M in orange(range, get_turf(src)))
        return M

/obj/structure/xenoartifact/proc/get_trait(typepath)
    return (locate(typepath) in traits)

/obj/structure/xenoartifact/process(delta_time)
    if(lit) //possible revisit this
        true_target = null //Empty previous entries
        true_target = list(get_proximity(2))
        if(true_target && charge >= charge_req)
            lit = FALSE
            set_light(0)
            check_charge(true_target[1])
            visible_message("<span class='danger'>The [name] fizzles out.</span>")
            return PROCESS_KILL
        if(get_trait(/datum/xenoartifact_trait/minor/capacitive))
            charge += NORMAL*traits[1].on_burn(src, true_target)
        else //I could probably clean this. To:Do
            lit = FALSE
            visible_message("<span class='danger'>The [name] fizzles out.</span>")
            return PROCESS_KILL
    else    
        return PROCESS_KILL

/obj/structure/xenoartifact/Destroy()
    for(var/mob/living/carbon/C in contents) //People inside only have a 50/50 chance of surviving a collapse. Other mobs perish either way.
        if(pick(FALSE, TRUE))
            C.forceMove(get_turf(loc))
    qdel(src)
    ..()
