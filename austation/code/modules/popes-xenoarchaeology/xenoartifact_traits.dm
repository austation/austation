/*
    Dev notes: 
        - src and X are interchangably used to describe the artifact. 
        - Not every artifact has a hint but, every artifact must have a descriptor.
        - Activator refers to a trait that generates charge to turn the artifact on. An activate proc is used for major traits, not activators.
        - Some more crpytic traits should be explained if the name isn;t self explanitory. 
*/

/datum/xenoartifact_trait
    var/desc //Acts as a descriptor for when examining

/datum/xenoartifact_trait/activator
    var/charge //How much a trait can output - reserved for activation traits

/datum/xenoartifact_trait/minor

/datum/xenoartifact_trait/major

/datum/xenoartifact_trait/proc/activate(obj/item/xenoartifact/X, atom/target, atom/user) //Used for major traits.
    return

/datum/xenoartifact_trait/proc/on_impact(obj/item/xenoartifact/X) //Activator expression.
    return

/datum/xenoartifact_trait/proc/on_init(obj/item/xenoartifact/X) //Used expressively for traits, typically minor, that transform the item's stats
    return

/datum/xenoartifact_trait/proc/on_touch(obj/item/xenoartifact/X, atom/user) //Used for hints. Distribute as you please.
    return

//Activation traits - only used to generate charge

/datum/xenoartifact_trait/activator/impact //Default impact activation trait. Trauma generates charge
    desc = "Sturdy"
    charge = 25

/datum/xenoartifact_trait/activator/impact/on_impact(obj/item/xenoartifact/X)
    return charge

//Minor traits

/datum/xenoartifact_trait/minor/looped //Increases charge towards 100
    desc = "Looped"

/datum/xenoartifact_trait/looped/minor/activate(obj/item/xenoartifact/X)
    X.charge = ((100-X.charge)*0.2)+X.charge
    ..()

/datum/xenoartifact_trait/minor/capacitive //Assures charge is saved until activated instead of being lost on failed attempts
    desc = "Capacitive"

/datum/xenoartifact_trait/major/capacitive/on_touch(obj/item/xenoartifact/X, mob/user)
    to_chat(user, "<span class='notice'>The hairs on your neck stand up after touching the [src].</span>")
    ..()

/datum/xenoartifact_trait/minor/dense //Makes the artifact unable to be picked up.
    desc = "Dense"

/datum/xenoartifact_trait/minor/sharp
    desc = "Shaped" //Shaped glass.

/datum/xenoartifact_trait/major/shock/on_touch(obj/item/xenoartifact/X, mob/user)
    to_chat(user, "<span class='notice'>The [src] feels sharp.</span>")
    ..()

/datum/xenoartifact_trait/sharp/minor/on_init(obj/item/xenoartifact/X)
    X.sharpness = IS_SHARP
    X.force = X.charge_req/15 //Change 15 to higher number if unbalanced
    X.attack_weight = 2
    X.armour_penetration = 5
    ..()

//Major traits

/datum/xenoartifact_trait/major/sing //Debug
    desc = "Tubed"

/datum/xenoartifact_trait/major/sing/activate(obj/item/xenoartifact/X)
    X.say("DEBUG::XENOARTIFACT::SING")
    X.say(X.charge)
    ..()

/datum/xenoartifact_trait/major/capture
    desc = "Hollow"

/datum/xenoartifact_trait/major/capture/activate(obj/item/xenoartifact/X, mob/target, mob/user) //ToDo: Optimize this to exlcude ghosts and other things that should be spared
    var/atom/movable/AM = target
    AM.anchored = TRUE
    X.anchored = TRUE
    AM.forceMove(X) //Go to the mega gay zone
    if(user)
        user.dropItemToGround(X, TRUE, TRUE)
    sleep(X.charge*6) //100 charge sits around 60 seconds
    AM.forceMove(X.loc)
    AM.anchored = FALSE
    X.anchored = FALSE
    ..()

/datum/xenoartifact_trait/major/shock
    desc = "Conductive"

/datum/xenoartifact_trait/major/shock/on_touch(obj/item/xenoartifact/X, mob/user)
    to_chat(user, "<span class='notice'>You feel a slight static touching the [src].</span>")
    ..()

/datum/xenoartifact_trait/major/shock/activate(obj/item/xenoartifact/X, mob/living/carbon/target)
    var/damage = X.charge*0.4
    target.electrocute_act(damage, X, 1, 1)
    ..()

/datum/xenoartifact_trait/major/timestop
    desc = "Melted" //The Persistence of Memory

/datum/xenoartifact_trait/major/timestop/on_touch(obj/item/xenoartifact/X, mob/user)
    to_chat(user, "<span class='notice'>Your hand feels slow, touching the [src].</span>")
    ..()

/datum/xenoartifact_trait/major/timestop/activate(obj/item/xenoartifact/X, mob/living/carbon/target)
    var/turf/T = get_turf(X.loc)
    if(!X)
        T = get_turf(target.loc)     
    new /obj/effect/timestop(T, 2, X.charge*6) //Same time-formula approach as capture. Generally use as a standard.
    ..()

/datum/xenoartifact_trait/major/laser
    desc = "Scoped"

/datum/xenoartifact_trait/major/laser/activate(obj/item/xenoartifact/X, mob/living/carbon/target, mob/user)
    var/obj/item/projectile/A
    switch(X.charge)
        if(0 to 24)
            A = new /obj/item/projectile/beam/disabler
        if(25 to 79)
            A = new /obj/item/projectile/beam/laser
        if(80 to 200) //I hope to god 200 is enough to stop you autistic faggots breaking this
            A = new /obj/item/ammo_casing/energy/laser/heavy
        else //If you somehow manage a number less than 0 or greater than 200, you deserve this  
            A = new /obj/item/projectile/beam/mindflayer
    A.preparePixelProjectile(target, X)
    A.fire()
    ..()
