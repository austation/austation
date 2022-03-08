/*
    Structure version of xenoartifact.

*/

/obj/structure/xenoartifact //Most of these values are generated on initialize
    name = "Xenoartifact"
    icon = 'icons/obj/plushes.dmi'
    icon_state = "lizardplush"
    
    var/material
    var/charge = 0 //How much input the artifact is getting from activation traits
    var/charge_req //How much input is required to start the activation
    var/traits[5] //activation trait, minor 1, minor 2, minor 3, major
    var/true_target //last target 


/obj/structure/xenoartifact/Initialize()
    . = ..()

/obj/structure/xenoartifact/attacked_by(obj/item/I, mob/living/user) //Attacking multiplies activation charge by a factor of 2. Use this to check for certain activation types
    . = ..()
    for(var/datum/xenoartifact_trait/T in traits)
        charge += 2*T.on_impact(src, user)

    true_target = user
    check_charge(user)

/obj/structure/xenoartifact/attack_hand(mob/user) //Essentially rubbing, 0.5 charge mod
    . = ..()
    for(var/datum/xenoartifact_trait/T in traits)
        charge += 0.5*T.on_impact(src, user)

    true_target = user
    check_charge(user)

/obj/structure/xenoartifact/throw_impact(atom/target, mob/user) //Throwing multiplies activation charge by a factor of 2
    . = ..()
    for(var/datum/xenoartifact_trait/T in traits)
        charge += 2*T.on_impact(src, target)

    true_target = target
    check_charge(null) //Don't pass this for the moment, just cuz it causes issue with capture-datum.

/obj/structure/xenoartifact/proc/check_charge(mob/user, var/charge_mod) //Run traits. User is generally passed to use as a fail safe for certain traits
    for(var/datum/xenoartifact_trait/T in traits) //Run minor traits first. Since they don't require a charge 
        T.minor_activate(src, true_target, user)

    if(charge+charge_mod >= charge_req) //Run major traits. Typically only one but, leave this for now otherwise
        for(var/datum/xenoartifact_trait/T in traits)
            T.activate(src, true_target, user)
        charge = 0
    
    for(var/datum/xenoartifact_trait/capacitive/T in traits) //To:Do: Why does this only work as a loop? Find a way to make it an IF or something.
        return
    charge = 0

/obj/structure/xenoartifact/climb_structure(mob/living/user) //Don't run parent, you can't climb them anyway
    for(var/datum/xenoartifact_trait/capture/T in traits)
        charge += 2*T.on_impact(src, user)//Higher on average, for punish
        true_target = user
        check_charge(null, 100)//If it can capture, you are garunteed to be able to climb in. Might be funny idk
    