/*
    XenoArchaeology is gud?

*/

/obj/item/xenoartifact //Most of these values are generated on initialize
    name = "Xenoartifact"
    icon = 'icons/obj/cigarettes.dmi'
    icon_state = "match_unlit"
    
    var/material
    var/charge = 0 //How much input the artifact is getting from activation traits
    var/charge_req //How much input is required to start the activation
    var/traits[5] //activation trait, minor 1, minor 2, minor 3, major
    var/true_target //last target 


/obj/item/xenoartifact/Initialize()
    . = ..()

    charge_req = 1*rand(1, 10) //set 0 to 10 after debugging
    traits[1] = new /datum/xenoartifact_trait/impact
    traits[2] = new /datum/xenoartifact_trait/looped
    traits[3] = new /datum/xenoartifact_trait/capacitive
    traits[4] = new /datum/xenoartifact_trait/dense
    traits[5] = new /datum/xenoartifact_trait/sing

/obj/item/xenoartifact/interact(mob/user)
    . = ..()
    for(var/datum/xenoartifact_trait/T in traits)
        charge += T.on_impact(src, user)

    true_target = user
    check_charge(user)

/obj/item/xenoartifact/attack(atom/target, mob/user) //Attacking multiplies activation charge by a factor of 1.5
    . = ..()
    for(var/datum/xenoartifact_trait/T in traits)
        charge += 1.5*T.on_impact(src, target)

    true_target = target
    check_charge(user)

/obj/item/xenoartifact/throw_impact(atom/target, mob/user) //Throwing multiplies activation charge by a factor of 2
    . = ..()
    for(var/datum/xenoartifact_trait/T in traits)
        charge += 2*T.on_impact(src, target)

    true_target = target
    check_charge(null) //Don't pass this for the moment, just cuz it causes issue with capture-datum.

/obj/item/xenoartifact/proc/check_charge(mob/user) //Run traits. User is generally passed to use as a fail safe for certain traits
    for(var/datum/xenoartifact_trait/T in traits) //Run minor traits first. Since they don't require a charge 
        T.minor_activate(src, true_target, user)

    if(charge >= charge_req) //Run major traits. Typically only one but, leave this for now otherwise
        for(var/datum/xenoartifact_trait/T in traits)
            T.activate(src, true_target, user)
        charge = 0
    
    for(var/datum/xenoartifact_trait/capacitive/T in traits) //To:Do: Why does this only work as a loop? Find a way to make it an IF or something.
        return
    charge = 0

/obj/item/xenoartifact/pickup(mob/user) //Picking up multiplies activation charge by a factor of 0.5
    . = ..()
    for(var/datum/xenoartifact_trait/dense/D in traits) //To:Do: Why does this only work as a loop? Find a way to make it an IF or something.
        for(var/datum/xenoartifact_trait/T in traits)
            charge += 0.5*T.on_impact(src, user)
        check_charge(user)
        to_chat(user, "The [src] is too heavy to carry!")
        user.dropItemToGround(src, TRUE, TRUE)
    