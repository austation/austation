/*
    Xenoartifact.

    Resoponsible shitter is Racc-Off#3845
*/

/obj/item/xenoartifact //Most of these values are generated on initialize
    name = "Xenoartifact"
    icon = 'icons/obj/plushes.dmi'
    icon_state = "lizardplush"
    
    var/material
    var/charge = 0 //How much input the artifact is getting from activation traits
    var/charge_req //How much input is required to start the activation
    var/traits[5] //activation trait, minor 1, minor 2, minor 3, major
    var/true_target //last target 


/obj/item/xenoartifact/Initialize()
    . = ..()

    charge_req = 1*rand(1, 10) //set 0 to 10 after debugging
    traits[1] = new /datum/xenoartifact_trait/activator/impact
    traits[2] = new /datum/xenoartifact_trait/minor/looped
    traits[3] = new /datum/xenoartifact_trait/minor/capacitive
    traits[4] = new /datum/xenoartifact_trait/major/sing
    traits[5] = new /datum/xenoartifact_trait/major/timestop

    for(var/datum/xenoartifact_trait/minor/dense/T in traits) //More for-loop strangeness
        var/obj/structure/xenoartifact/X = new /obj/structure/xenoartifact(get_turf(src.loc))
        X.traits = traits
        X.charge_req = charge_req*1.2 //Might change later on. LOOK AT THIS!!
        qdel(src)

/obj/item/xenoartifact/interact(mob/user)
    . = ..()
    for(var/datum/xenoartifact_trait/activator/T in traits)
        charge += T.on_impact(src, user)

    true_target = user
    check_charge(user)

/obj/item/xenoartifact/attack(atom/target, mob/user) //Attacking multiplies activation charge by a factor of 1.5
    . = ..()
    for(var/datum/xenoartifact_trait/activator/T in traits)
        charge += 1.5*T.on_impact(src, target)

    true_target = target
    check_charge(user)

/obj/item/xenoartifact/throw_impact(atom/target, mob/user) //Throwing multiplies activation charge by a factor of 2
    . = ..()
    for(var/datum/xenoartifact_trait/activator/T in traits)
        charge += 2*T.on_impact(src, target)

    true_target = target
    check_charge(null) //Don't pass this for the moment, just cuz it causes issue with capture-datum.

/obj/item/xenoartifact/attacked_by(obj/item/I, mob/living/user)
    . = ..()
    for(var/datum/xenoartifact_trait/activator/T in traits)
        charge += 2*T.on_impact(src, user)

    true_target = user
    check_charge(user)

/obj/item/xenoartifact/proc/check_charge(mob/user, var/charge_mod) //Run traits. User is generally passed to use as a fail safe for certain traits
    for(var/datum/xenoartifact_trait/minor/T in traits) //Run minor traits first. Since they don't require a charge 
        T.activate(src, true_target, user)

    if(charge+charge_mod >= charge_req) //Run major traits. Typically only one but, leave this for now otherwise
        for(var/datum/xenoartifact_trait/major/T in traits)
            T.activate(src, true_target, user)
        charge = 0
    
    for(var/datum/xenoartifact_trait/minor/capacitive/T in traits) //To:Do: Why does this only work as a loop? Find a way to make it an IF or something.
        return
    charge = 0
    