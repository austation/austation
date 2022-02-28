/*
    XenoArchaeology

*/

/obj/item/xenoartifact//Most of these values are generated on initialize
    name = "Xenoartifact"
    var/material

    var/charge = 0 //How much input the artifact is getting from activation traits 
    var/charge_req //How much input is required to start the activation

    var/traits[5]// activation trait, minor 1, minor 2, minor 3, major

    var/true_target //last target 

/obj/item/xenoartifact/Initialize()
    . = ..()

    charge_req = 0*rand(1, 10)//set 0 to 10 after debugging
    traits[1] = new /datum/xenoartifact_trait/impact
    traits[5] = new /datum/xenoartifact_trait/capture
    traits[4] = new /datum/xenoartifact_trait/sing

/obj/item/xenoartifact/interact(mob/user)
    . = ..()
    for(var/datum/xenoartifact_trait/T in traits)
        charge += T.on_impact(src, user)

    true_target = user
    check_charge()

/obj/item/xenoartifact/attack(atom/target, mob/user)//Attacking multiplies activation charge by a factor of 1.5
    . = ..()
    for(var/datum/xenoartifact_trait/T in traits)
        charge += 1.5*T.on_impact(src, target)

    true_target = target
    check_charge()

/obj/item/xenoartifact/throw_impact(atom/target)//Throwing multiplies activation charge by a factor of 2
    . = ..()
    for(var/datum/xenoartifact_trait/T in traits)
        charge += 2*T.on_impact(src, target)

    true_target = target
    check_charge()

/obj/item/xenoartifact/proc/check_charge()
    if(charge >= charge_req)
        for(var/datum/xenoartifact_trait/T in traits)
            T.activate(src, true_target)
    
    charge = 0
    