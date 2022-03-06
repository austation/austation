/datum/xenoartifact_trait
    var/name //Acts as a descriptor for when examining
    var/charge //How much a trait can output - reserved for activation traits

/datum/xenoartifact_trait/proc/activate(obj/item/xenoartifact/X, atom/target, atom/user)
    X.charge = 0//it's hungry >:]
    return

/datum/xenoartifact_trait/proc/minor_activate(obj/item/xenoartifact/X)
    return

/datum/xenoartifact_trait/proc/on_impact(obj/item/xenoartifact/X)
    return

/datum/xenoartifact_trait/proc/on_slip(obj/item/xenoartifact/X, atom/target)
    return

//Activation traits - only used to generate charge

/datum/xenoartifact_trait/impact //Default impact activation trait. Trauma generates charge
    name = "Dense"
    charge = 25

/datum/xenoartifact_trait/impact/on_impact(obj/item/xenoartifact/X)
    return charge

//Minor traits

/datum/xenoartifact_trait/looped //Increases charge towards 100
    name = "Looped"

/datum/xenoartifact_trait/looped/minor_activate(obj/item/xenoartifact/X)
    X.charge = ((100-X.charge)*0.5)+X.charge
    ..()

/datum/xenoartifact_trait/capacitive //Assures charge is saved until activated instead of being lost on failed attempts
    name = "Capacitive"
    
//Major traits

/datum/xenoartifact_trait/sing //Debug
    name = "Tubed"

/datum/xenoartifact_trait/sing/activate(obj/item/xenoartifact/X)
    X.say("DEBUG::XENOARTIFACT::SING")
    X.say(X.charge)
    ..()

/datum/xenoartifact_trait/capture //Capture, self explanitory 
    name = "Hollow"

/datum/xenoartifact_trait/capture/activate(obj/item/xenoartifact/X, mob/target, mob/user) //ToDo: Optimize this to exlcude ghosts and others
    var/atom/movable/AM = target
    AM.anchored = TRUE
    X.anchored = TRUE
    AM.forceMove(src)//Go to the mega gay zone
    if(user)
        user.dropItemToGround(X, TRUE, TRUE)
    sleep(50)
    AM.forceMove(X.loc)//Release this martyr
    AM.anchored = FALSE
    X.anchored = FALSE
    ..()
