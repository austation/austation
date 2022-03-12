//Activator modifiers. Used in context of the difficulty of a task.
#define EASY 0.8
#define NORMAL 1
#define HARD 1.5
#define COMBAT 1.8 //Players who engage in combat are given an extra reward for the consequences of doing so.

//Material defines. Used for characteristic generation.
#define BLUESPACE "#3d89d1cc"
#define PLASMA "#af14af"
#define URANIUM "#96be04"

/obj/item/xenoartifact //Most of these values are generated on initialize
    name = "Xenoartifact"
    icon = 'icons/obj/plushes.dmi'
    icon_state = "lizardplush"
    
    var/charge = 0 //How much input the artifact is getting from activator traits
    var/charge_req //How much input is required to start the activation
    var/traits[5] //activation trait, minor 1, minor 2, minor 3, major
    var/true_target //last target.
    var/usedwhen //holder for worldtime
    var/cooldown = 16 SECONDS //Time between uses
    var/cooldownmod = 0 //Extra time traits can add to the cooldown.
    var/material

/obj/item/xenoartifact/Initialize()
    . = ..()

    material = pick(BLUESPACE, PLASMA, URANIUM)
    add_atom_colour(material)
    charge_req = 10*rand(1, 10)
    switch(material)
        if(BLUESPACE||PLASMA||URANIUM)
            generate_traits(list(/datum/xenoartifact_trait/activator/impact, /datum/xenoartifact_trait/activator/burn), 1)

            var/list/minors = list(/datum/xenoartifact_trait/minor/looped, /datum/xenoartifact_trait/minor/capacitive, /datum/xenoartifact_trait/minor/radioactive, /datum/xenoartifact_trait/minor/cooler, /datum/xenoartifact_trait/minor/sentient)
            generate_traits(minors, 2)
            generate_traits(minors, 3)
            generate_traits(minors, 4)

            var/list/majors = list(/datum/xenoartifact_trait/major/capture, /datum/xenoartifact_trait/major/shock, /datum/xenoartifact_trait/major/timestop, /datum/xenoartifact_trait/major/corginator)
            generate_traits(majors, 5)

    for(var/datum/xenoartifact_trait/T in traits) //More for-loop strangeness
        T.on_init(src)

/obj/item/xenoartifact/interact(mob/user)
    . = ..()
    for(var/datum/xenoartifact_trait/activator/T in traits)
        charge += EASY*T.on_impact(src, user)
        
    true_target = user
    check_charge(user)

/obj/item/xenoartifact/attack(atom/target, mob/user)
    . = ..()
    for(var/datum/xenoartifact_trait/activator/T in traits)
        if(istype(user, /mob/living/carbon))
            charge += COMBAT*T.on_impact(src, target)
        else
            charge += HARD*T.on_impact(src, target)

    true_target = target
    check_charge(user)

/obj/item/xenoartifact/afterattack(atom/target, mob/user, proximity)
    . = ..()
    for(var/datum/xenoartifact_trait/activator/T in traits)
        if(!proximity)//Only if we're far away, don't want to trigger right after attack
            charge += EASY*T.on_impact(src, target) //Just swining it in the air is easy, right?

    true_target = target
    check_charge(user)

/obj/item/xenoartifact/throw_impact(atom/target, mob/user)
    . = ..()
    for(var/datum/xenoartifact_trait/activator/T in traits)
        charge += NORMAL*T.on_impact(src, target)

    true_target = target
    check_charge(null) //Don't pass this for the moment, just cuz it causes issue with capture-datum. Fix capture.

/obj/item/xenoartifact/attacked_by(obj/item/I, mob/living/user) //Check for certain items pertaining to activator traits
    . = ..()
    for(var/datum/xenoartifact_trait/activator/T in traits)
        charge += NORMAL*T.on_impact(src, user)

    for(var/datum/xenoartifact_trait/activator/T in traits)
        charge += attacked_by_fire(I, user)*NORMAL*T.on_burn(src, user) //To:Do: Make different sources adjust the difficulty reward

    true_target = user
    check_charge(user)

/obj/item/xenoartifact/proc/attacked_by_fire/(obj/item/I, mob/living/user) //To:Do: Make it so being clumsy gives you a chance of catching on fire. Also consider TK.
    var/ignition_message = I.ignition_effect(src, user)
    if(ignition_message)
        return 1
    else
        return 0

/obj/item/xenoartifact/proc/check_charge(mob/user, var/charge_mod) //Run traits. User is generally passed to use as a fail-safe.
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

/obj/item/xenoartifact/proc/manage_cooldown()
    if(!usedwhen)
        usedwhen = world.time
        return TRUE
    else if(usedwhen + cooldown + cooldownmod < world.time)
        usedwhen = null
        return TRUE
    else    
        return FALSE

/obj/item/xenoartifact/proc/generate_traits(list/possible_traits, var/index)
    var/new_trait = pick(possible_traits)
    possible_traits -= new_trait
    traits[index] = new new_trait
    