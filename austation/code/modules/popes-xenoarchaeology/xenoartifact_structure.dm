/*
    Structure version of xenoartifact. Used for dense trait.
    Look in xenoartifact_traits.dm for more information.
*/
//Activator modifiers. Used in context of the difficulty of a task. Generates better values, compared to item.
#define EASY 1
#define NORMAL 2
#define HARD 2.8

/obj/structure/xenoartifact //Most of these values are given to the structure when the structure initializes
    name = "Xenoartifact"
    icon = 'icons/obj/plushes.dmi'
    icon_state = "lizardplush"
    density = TRUE
    drag_slowdown = 0.5 //A little heavy, a smidge
    
    var/charge = 0 //How much input the artifact is getting from activation traits
    var/charge_req //How much input is required to start the activation
    var/datum/xenoartifact_trait/traits[5] //activation trait, minor 1, minor 2, minor 3, major
    var/atom/true_target //last target.
    var/usedwhen //holder for worldtime
    var/cooldown = 8 SECONDS //Time between uses
    var/cooldownmod = 0 //Extra time traits can add to the cooldown.
    var/material

    var/lit = FALSE//Specific to burn
    var/lit_count = 10

/obj/structure/xenoartifact/Initialize()
    . = ..()

/obj/structure/xenoartifact/attack_hand(mob/user)
    if(get_trait(/datum/xenoartifact_trait/activator/impact))
        charge += NORMAL*traits[1].on_impact(src, user)
    true_target = user
    check_charge(user)
    ..()

/obj/structure/xenoartifact/throw_impact(atom/target, mob/user)
    if(!..())
        return
    if(get_trait(/datum/xenoartifact_trait/activator/impact))
        charge += NORMAL*traits[1].on_impact(src, target)
    true_target = target
    check_charge(user)

/obj/structure/xenoartifact/attackby(obj/item/I, mob/living/user) //Check for certain structures pertaining to activator traits
    if(get_trait(/datum/xenoartifact_trait/activator/impact))
        charge += NORMAL*traits[1].on_impact(src, user)
        true_target = user
        check_charge(user)

    if(get_trait(/datum/xenoartifact_trait/activator/burn))
        var/msg = I.ignition_effect(src, user)
        if(msg && !lit && manage_cooldown(TRUE))
            sleep(2 SECONDS)
            lit = TRUE
            charge += NORMAL*traits[1].on_burn(src, user)
            START_PROCESSING(SSobj, src)
            set_light(2)
            visible_message("<span class='danger'>The [name] sparks on.</span>")
        else if(!manage_cooldown(TRUE) && msg)
            visible_message("<span class='danger'>The [name] echos emptily.</span>")

/obj/structure/xenoartifact/proc/check_charge(mob/user, charge_mod) //Run traits. User is generally passed to use as a fail-safe.
    if(manage_cooldown(TRUE))
        for(var/datum/xenoartifact_trait/minor/T in traits) //Run minor traits first. Since they don't require a charge 
            T.activate(src, true_target, user)
        charge += charge_mod
        if(charge >= charge_req) //Run major traits. Typically only one but leave this for now
            for(var/datum/xenoartifact_trait/major/T in traits)
                T.activate(src, true_target, user)
            charge = 0
            manage_cooldown()
    if(get_trait(/datum/xenoartifact_trait/minor/capacitive))
        return
    visible_message("<span class='danger'>The [name] echos emptily.</span>") //Indicator of charging / not enough charge
    charge = 0

/obj/structure/xenoartifact/proc/manage_cooldown(checking = FALSE)
    if(!usedwhen)
        usedwhen = world.time * ((checking-1)*-1)
        return TRUE
    else if(usedwhen + cooldown + cooldownmod < world.time)
        usedwhen = null
        return TRUE
    else 
        return FALSE

/obj/structure/xenoartifact/proc/generate_traits(list/possible_traits, index)
    var/new_trait = pick(possible_traits)
    possible_traits -= new_trait
    traits[index] = new new_trait
    
/obj/structure/xenoartifact/proc/get_proximity() //Gets closest mob. Used for burn activator
    for(var/mob/living/M in orange(1, get_turf(src)))
        return M

/obj/structure/xenoartifact/proc/get_trait(typepath)
    return (locate(typepath) in traits)

/obj/item/xenoartifact/process(delta_time)
    if(lit)
        true_target = get_proximity()
        if(true_target && charge >= charge_req) //Weird but tollerable
            lit = FALSE
            set_light(0)
            check_charge(true_target)
            visible_message("<span class='danger'>The [name] fizzles out.</span>")
            return PROCESS_KILL
        charge += NORMAL*traits[1].on_burn(src, true_target) //This looks janky but, I haven't run into any issues with it yet
    else    
        return PROCESS_KILL
    