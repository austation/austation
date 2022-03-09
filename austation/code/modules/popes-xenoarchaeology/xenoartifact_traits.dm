/datum/xenoartifact_trait
    var/desc //Acts as a descriptor for when examining

/datum/xenoartifact_trait/activator
    var/charge //How much a trait can output - reserved for activation traits

/datum/xenoartifact_trait/minor

/datum/xenoartifact_trait/major

/datum/xenoartifact_trait/proc/activate(obj/item/xenoartifact/X, atom/target, atom/user)
    return

/datum/xenoartifact_trait/proc/on_impact(obj/item/xenoartifact/X)
    return

/datum/xenoartifact_trait/proc/on_init(obj/item/xenoartifact/X) //Used expressively for traits, typically minor, that transform the item's stats
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

/datum/xenoartifact_trait/minor/dense //Makes the artifact unable to be picked up. Pain in my asshole.
    desc = "Dense"

/datum/xenoartifact_trait/minor/sharp //Essentially makes the artifact a weapon
    desc = "Shaped" //Shaped glass 

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

/datum/xenoartifact_trait/major/capture //Capture naughty coders
    desc = "Hollow"

/datum/xenoartifact_trait/major/capture/activate(obj/item/xenoartifact/X, mob/target, mob/user) //ToDo: Optimize this to exlcude ghosts and other things that should be spared
    var/atom/movable/AM = target
    AM.anchored = TRUE
    X.anchored = TRUE
    AM.forceMove(src) //Go to the mega gay zone
    if(user)
        user.dropItemToGround(X, TRUE, TRUE)
    sleep(X.charge*6) //100 charge sits around 60 seconds
    AM.forceMove(X.loc) //Release this martyr
    AM.anchored = FALSE
    X.anchored = FALSE
    ..()

/datum/xenoartifact_trait/major/shock //Shocking https://www.youtube.com/watch?v=iYVO5bUFww0
    desc = "Conductive"

/datum/xenoartifact_trait/major/shock/activate(obj/item/xenoartifact/X, mob/living/carbon/target)
    var/damage = X.charge*0.4
    target.electrocute_act(damage, X, 1, 1)
    ..()

/datum/xenoartifact_trait/major/timestop //Stop time
    desc = "Melted" //https://en.wikipedia.org/wiki/The_Persistence_of_Memory

/datum/xenoartifact_trait/major/timestop/activate(obj/item/xenoartifact/X, mob/living/carbon/target)
    var/turf/T = get_turf(X.loc)
    if(!X)
        T = get_turf(target.loc)     
    new /obj/effect/timestop(T, 2, X.charge*6) //Same approach as capture. Generally use as a standard.
    ..()
