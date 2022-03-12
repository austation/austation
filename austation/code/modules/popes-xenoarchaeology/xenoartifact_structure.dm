/*
    Structure version of xenoartifact. Used for dense trait.
    Look in xenoartifact_traits.dm for more information.
*/
//Activator modifiers. Used in context of the difficulty of a task. Generates better values.
#define EASY 1
#define NORMAL 1.8
#define HARD 2

/obj/structure/xenoartifact //Most of these values are generated on initialize
    name = "Xenoartifact"
    icon = 'icons/obj/plushes.dmi'
    icon_state = "lizardplush"
    density = TRUE
    drag_slowdown = 0.5 //A little heavy, a smidge
    
    var/material
    var/charge = 0 //How much input the artifact is getting from activation traits
    var/charge_req //How much input is required to start the activation
    var/traits[5] //activation trait, minor 1, minor 2, minor 3, major
    var/true_target //last target 
    var/usedwhen //holder for worldtime
    var/cooldown = 16 SECONDS //Time between uses
    var/cooldownmod = 1 //Extra time traits can add to the cooldown.


/obj/structure/xenoartifact/Initialize()
    . = ..()

/obj/structure/xenoartifact/attacked_by(obj/item/I, mob/living/user) //Use this to check for certain activator input types
    . = ..()
    for(var/datum/xenoartifact_trait/activator/T in traits)
        charge += HARD*T.on_impact(src, user)

    true_target = user
    check_charge(user)

/obj/structure/xenoartifact/attack_hand(mob/user)
    . = ..()
    for(var/datum/xenoartifact_trait/activator/T in traits)
        charge += EASY*T.on_impact(src, user)

    true_target = user
    check_charge(user)

/obj/structure/xenoartifact/throw_impact(atom/target, mob/user)
    . = ..()
    for(var/datum/xenoartifact_trait/activator/T in traits)
        charge += NORMAL*T.on_impact(src, target)

    true_target = target
    check_charge(null) //Don't pass this for the moment, just cuz it causes issue with capture-datum.

/obj/structure/xenoartifact/proc/check_charge(mob/user, var/charge_mod) //Run traits. User is generally passed to use as a fail-safe.
    if(manage_cooldown())
        for(var/datum/xenoartifact_trait/minor/T in traits) //Run minor traits first. Since they don't require a charge 
            T.activate(src, true_target, user)

        charge += charge_mod 
        if(charge >= charge_req) //Run major traits. Typically only one but, leave this for now otherwise
            for(var/datum/xenoartifact_trait/major/T in traits)
                T.activate(src, true_target, user)
            charge = 0
        
        for(var/datum/xenoartifact_trait/minor/capacitive/T in traits) //To:Do: Why does this only work as a loop? Find a way to make it an IF or something.
            return
        manage_cooldown()
    charge = 0

/obj/structure/xenoartifact/proc/manage_cooldown()
    if(!usedwhen)
        usedwhen = world.time
        return TRUE
    else if(usedwhen + cooldown + cooldownmod < world.time)
        return TRUE
    else    
        return FALSE

/obj/structure/xenoartifact/climb_structure(mob/living/user) //Don't run parent, you can't climb them anyway
    for(var/datum/xenoartifact_trait/major/capture/T in traits)
        charge += 2*T.on_impact(src, user) //Higher on average, causes longer jail time
        true_target = user
        check_charge(null, 100) //If it can capture, you are garunteed to be able to climb in. Might be funny idk
    