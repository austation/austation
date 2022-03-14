/*
    Dev notes: 
        - Activator refers to a trait that generates charge to turn the artifact on. Not to be confused with the activaton proc.
        - Some more crpytic traits should be explained if the name isn't self explanitory. 
*/

/datum/xenoartifact_trait
    var/desc //Acts as a descriptor for when examining

/datum/xenoartifact_trait/activator
    var/charge //How much a trait can output to fufill the charge requirment

/datum/xenoartifact_trait/minor

/datum/xenoartifact_trait/major

/datum/xenoartifact_trait/proc/activate(obj/item/xenoartifact/X, atom/target, atom/user)
    return

/datum/xenoartifact_trait/proc/on_impact(obj/item/xenoartifact/X) //Activator expression.
    return

/datum/xenoartifact_trait/proc/on_burn(obj/item/xenoartifact/X) //Activator expression.
    return

/datum/xenoartifact_trait/proc/on_init(obj/item/xenoartifact/X) //Used expressively for traits, typically minor, that transform the item's stats
    return

/datum/xenoartifact_trait/proc/on_touch(obj/item/xenoartifact/X, atom/user) //Used for hints. Distribute as you please.
    return FALSE

//Activation traits - only used to generate charge

/datum/xenoartifact_trait/activator/impact //Default impact activation trait. Trauma generates charge
    desc = "Sturdy"
    charge = 25

/datum/xenoartifact_trait/activator/impact/on_impact(obj/item/xenoartifact/X)
    return charge

/datum/xenoartifact_trait/activator/burn
    desc = "Flamable"
    charge = 25

/datum/xenoartifact_trait/activator/burn/on_burn(obj/item/xenoartifact/X)
    return charge   

//Minor traits

/datum/xenoartifact_trait/minor/looped //Increases charge towards 100
    desc = "Looped"

/datum/xenoartifact_trait/looped/minor/activate(obj/item/xenoartifact/X)
    X.charge = ((100-X.charge)*0.2)+X.charge
    ..()

/datum/xenoartifact_trait/minor/capacitive //Assures charge is saved until activated instead of being lost on failed attempts
    desc = "Capacitive"

/datum/xenoartifact_trait/minor/capacitive/on_touch(obj/item/xenoartifact/X, mob/user)
    to_chat(user, "<span class='notice'>The hairs on your neck stand up after touching the [X.name].</span>")
    return TRUE

/datum/xenoartifact_trait/minor/dense //Makes the artifact unable to be picked up. Associated with better charge modifers.
    desc = "Dense"

/datum/xenoartifact_trait/minor/dense/on_init(obj/item/xenoartifact/X)
    var/obj/structure/xenoartifact/N = new(get_turf(X))
    N.traits = X.traits
    N.charge_req = X.charge_req*1.5
    N.desc = X.desc
    N.add_atom_colour(X.material, FIXED_COLOUR_PRIORITY)
    del(X)
    ..()

/datum/xenoartifact_trait/minor/sharp
    desc = "Shaped" //Shaped glass.

/datum/xenoartifact_trait/minor/sharp/on_touch(obj/item/xenoartifact/X, mob/user)
    to_chat(user, "<span class='notice'>The [X.name] feels sharp.</span>")
    return TRUE

/datum/xenoartifact_trait/sharp/minor/on_init(obj/item/xenoartifact/X)
    X.sharpness = IS_SHARP
    X.force = X.charge_req/15 //Change 15 to higher number if unbalanced
    X.attack_weight = 2
    X.armour_penetration = 5
    ..()

/datum/xenoartifact_trait/minor/radioactive
    //Sneaky

/datum/xenoartifact_trait/minor/radioactive/on_touch(obj/item/xenoartifact/X, mob/user)
    to_chat(user, "<span class='notice'>You feel pins and needles after touching the [X.name].</span>")
    return TRUE

/datum/xenoartifact_trait/minor/radioactive/activate(obj/item/xenoartifact/X, mob/living/target)
    target.radiation += X.charge/5 //Might revisit the value.
    ..()

/datum/xenoartifact_trait/minor/cooler //Faster cooldowns
    desc = "Frosted"

/datum/xenoartifact_trait/minor/cooler/on_touch(obj/item/xenoartifact/X, mob/user)
    to_chat(user, "<span class='notice'>The [X.name] feels cold.</span>")
    return TRUE

/datum/xenoartifact_trait/cooler/minor/on_init(obj/item/xenoartifact/X)
    X.cooldown = X.cooldown / 3 //Might revisit the value.
    ..()

/datum/xenoartifact_trait/minor/sentient //The attempt here is to make a one-ring type sentience
    //More sneaky stuff
    //I probably wont detract points for unsuccesfully guessing this one. 

/datum/xenoartifact_trait/minor/sentient/on_touch(obj/item/xenoartifact/X, mob/user)
    to_chat(user, "<span class='warning'>The [X.name] whispers to you...</span>")
    return TRUE

/datum/xenoartifact_trait/minor/sentient/on_init(obj/item/xenoartifact/X)
    var/list/mob/dead/observer/candidates = pollGhostCandidates("Do you want to play as the maleviolent force inside the [X.name]?", ROLE_SENTIENCE, null, FALSE, 5 SECONDS, POLL_IGNORE_SENTIENCE_POTION)
    if(LAZYLEN(candidates))
        var/mob/dead/observer/C = pick(candidates)
        var/mob/living/simple_animal/H = new /mob/living/simple_animal(get_turf(X))
        H.key = C.key
        ADD_TRAIT(H, TRAIT_NOBREATH, TRAIT_SIXTHSENSE)
        H.forceMove(X)
        H.anchored = TRUE
        var/obj/effect/proc_holder/spell/targeted/xeno_senitent_action/P = new /obj/effect/proc_holder/spell/targeted/xeno_senitent_action
        H.AddSpell(P)
        P.stupid(X)
    ..()

/obj/effect/proc_holder/spell/targeted/xeno_senitent_action
    name = "Activate"
    desc = "Select a target to activate your traits on."
    range = 1
    charge_max = 0 SECONDS //To:Do: Consider adding major trait delay to this too
    clothes_req = 0
    include_user = 0
    action_icon = 'icons/mob/actions/actions_revenant.dmi'
    action_icon_state = "r_transmit"
    action_background_icon_state = "bg_spell"
    var/obj/item/xenoartifact/X

/obj/effect/proc_holder/spell/targeted/xeno_senitent_action/proc/stupid(obj/item/xenoartifact/Z) //To:Do: Fucking get rid of this
    X = Z

/obj/effect/proc_holder/spell/targeted/xeno_senitent_action/cast(list/targets, mob/living/simple_animal/revenant/user = usr)
    for(var/mob/M in targets)
        X.attack(M, usr)

/datum/xenoartifact_trait/minor/delicate //Limited uses. Fun fact: You can get turned into a corgi forever if the artifact breaks during the transformation. Do not fix this.
    desc = "Fragile"

/datum/xenoartifact_trait/minor/delicate/on_init(obj/item/xenoartifact/X)
    X.max_integrity = pick(100, 300, 500, 800, 1000)
    ..()

/datum/xenoartifact_trait/minor/delicate/on_init(obj/item/xenoartifact/X)
    X.obj_integrity -= 100
    ..()

//Major traits

/datum/xenoartifact_trait/major/sing //Debug
    desc = "Bugged"

/datum/xenoartifact_trait/major/sing/activate(obj/item/xenoartifact/X)
    X.say("DEBUG::XENOARTIFACT::SING")
    X.say(X.charge)
    ..()

/datum/xenoartifact_trait/major/capture
    desc = "Hollow"

/datum/xenoartifact_trait/major/capture/activate(obj/item/xenoartifact/X, mob/target, mob/user)
    var/atom/movable/AM = arrest(X, target, user)
    addtimer(CALLBACK(src, .proc/release, X, AM), X.charge*0.6 SECONDS)
    X.cooldownmod = X.charge*0.6 SECONDS
    ..()

/datum/xenoartifact_trait/major/capture/proc/arrest(obj/item/xenoartifact/X, mob/target, mob/user)
    if(istype(target, /mob/living/carbon))
        if(user||target == user)
            user.dropItemToGround(X, TRUE, TRUE)
        var/atom/movable/AM = target
        AM.anchored = TRUE
        AM.forceMove(X) //Go to the mega gay zone
        return AM
    else    
        return

/datum/xenoartifact_trait/major/capture/proc/release(obj/item/xenoartifact/X, atom/movable/AM)
    var/turf/T = get_turf(X)
    AM.anchored = FALSE
    AM.forceMove(T)

/datum/xenoartifact_trait/major/shock
    desc = "Conductive"

/datum/xenoartifact_trait/major/shock/on_touch(obj/item/xenoartifact/X, mob/user)
    to_chat(user, "<span class='notice'>You feel a slight static after touching the [X.name].</span>")
    return TRUE

/datum/xenoartifact_trait/major/shock/activate(obj/item/xenoartifact/X, mob/living/carbon/target, mob/user)
    var/damage = X.charge*0.4
    do_sparks(pick(1, 2), 0, X)
    target.electrocute_act(damage, X, 1, 1)
    ..()

/datum/xenoartifact_trait/major/timestop
    desc = "Melted" //The Persistence of Memory

/datum/xenoartifact_trait/major/timestop/on_touch(obj/item/xenoartifact/X, mob/user)
    to_chat(user, "<span class='notice'>Your hand feels slow while stroking the [X.name].</span>")
    return TRUE

/datum/xenoartifact_trait/major/timestop/activate(obj/item/xenoartifact/X, mob/living/carbon/target)
    var/turf/T = get_turf(X.loc)
    if(!X)
        T = get_turf(target.loc)     
    new /obj/effect/timestop(T, 2, X.charge*6)
    X.cooldownmod = X.charge*0.6 SECONDS
    ..()

/datum/xenoartifact_trait/major/laser
    desc = "Scoped"

/datum/xenoartifact_trait/major/laser/activate(obj/item/xenoartifact/X, mob/living/carbon/target, mob/living/user)
    if(get_dist(target, user) <= 1)
        target.adjust_fire_stacks(1)
        target.IgniteMob()
        return
    var/obj/item/projectile/A
    switch(X.charge)
        if(0 to 24)
            A = new /obj/item/projectile/beam/disabler
        if(25 to 79)
            A = new /obj/item/projectile/beam/laser
        if(80 to 200)
            A = new /obj/item/ammo_casing/energy/laser/heavy
        else //If you somehow manage a number less than 0 or greater than 200
            A = new /obj/item/projectile/beam/mindflayer
    A.preparePixelProjectile(target, X)
    A.fire()
    ..()

/datum/xenoartifact_trait/major/bomb
    //Sneaky

/datum/xenoartifact_trait/major/bomb/on_touch(obj/item/xenoartifact/X, mob/user)
    to_chat(user, "<span class='notice'>You feel a ticking deep within the [X.name].</span>")
    return TRUE

/datum/xenoartifact_trait/major/bomb/activate(obj/item/xenoartifact/X, mob/living/carbon/target)
    X.visible_message("<span class='danger'>The [X.name] begins to tick loudly...</span>")
    addtimer(CALLBACK(src, .proc/explode, X), 70-(X.charge*0.6))
    X.cooldownmod = 70-(X.charge*0.6)
    ..()

/datum/xenoartifact_trait/major/bomb/proc/explode(obj/item/xenoartifact/X)
    var/turf/T = get_turf(X)
    if(!T)
        return
    explosion(T,X.charge/3,X.charge,X/2,X.charge)
    del(X) //Bon voyage. If you remove this, keep in mind there's a callback bug regarding a looping issue.

/datum/xenoartifact_trait/major/corginator //All of this is stolen from corgium.
    desc = "Fuzzy" //Weirdchamp
    var/mob/living/simple_animal/pet/dog/corgi/new_corgi

/datum/xenoartifact_trait/major/corginator/activate(obj/item/xenoartifact/X, mob/living/carbon/target)
    if(istype(target, /mob/living/carbon))
        transform(X, target)
        addtimer(CALLBACK(src, .proc/transform_back, X, target), X.charge*0.6 SECONDS)
        X.cooldownmod = X.charge*0.6 SECONDS
    ..()

/datum/xenoartifact_trait/major/corginator/proc/transform(obj/item/xenoartifact/X, mob/living/carbon/target)
    new_corgi = new(get_turf(target))
    new_corgi.key = target.key
    new_corgi.name = target.real_name
    new_corgi.real_name = target.real_name
    ADD_TRAIT(target, TRAIT_NOBREATH, CORGIUM_TRAIT)
    var/mob/living/carbon/C = target
    if(istype(C))
        var/obj/item/hat = C.get_item_by_slot(ITEM_SLOT_HEAD)
        if(hat)
            new_corgi.place_on_head(hat,null,FALSE)
    target.forceMove(new_corgi)

/datum/xenoartifact_trait/major/corginator/proc/transform_back(obj/item/xenoartifact/X, mob/living/carbon/target)
    REMOVE_TRAIT(target, TRAIT_NOBREATH, CORGIUM_TRAIT)
    if(QDELETED(new_corgi))
        if(!QDELETED(target))
            qdel(target)
        return
    target.key = new_corgi.key
    target.adjustBruteLoss(new_corgi.getBruteLoss())
    target.adjustFireLoss(new_corgi.getFireLoss())
    target.forceMove(get_turf(new_corgi))
    var/turf/T = get_turf(new_corgi)
    if (new_corgi.inventory_head)
        if(!target.equip_to_slot_if_possible(new_corgi.inventory_head, ITEM_SLOT_HEAD,disable_warning = TRUE, bypass_equip_delay_self=TRUE))
            new_corgi.inventory_head.forceMove(T)
    new_corgi.inventory_back?.forceMove(T)
    new_corgi.inventory_head = null
    new_corgi.inventory_back = null
    qdel(new_corgi)

/datum/xenoartifact_trait/major/mirrored //Swaps the last to target's body's locations, or minds if the charge is higher
    desc = "Mirrored"
    var/mob/first_sub //Subjects
    var/mob/second_sub

/datum/xenoartifact_trait/major/mirrored/on_touch(obj/item/xenoartifact/X, mob/user)
    if(first_sub.key != user.key)
        to_chat(user, "<span class='warning'>You see a reflection in the [X.name], it isn't yours...</span>")
    else    
        to_chat(user, "<span class='notice'>You see your reflection in the [X.name].</span>")
    return TRUE

/datum/xenoartifact_trait/major/mirrored/activate(obj/item/xenoartifact/X, mob/living/carbon/target)
    if(!first_sub)
        first_sub = target
    else    
        second_sub = target.key//This code might need a rework
        first_sub.key = target.key
        second_sub = first_sub.key
        first_sub = null
        second_sub = null
    ..()
