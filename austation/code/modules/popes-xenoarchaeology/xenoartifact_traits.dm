/datum/xenoartifact_trait
    var/name //Acts as a descriptor for when examining
    var/charge //How much a trait can output - reserved for activation traits

/datum/xenoartifact_trait/proc/activate(obj/item/xenoartifact/X, atom/target)
    return

/datum/xenoartifact_trait/proc/on_impact(obj/item/xenoartifact/X, atom/target)
    return

/datum/xenoartifact_trait/proc/on_slip(obj/item/xenoartifact/X, atom/target)
    return

//Activation traits - only used to generate charge

/datum/xenoartifact_trait/impact
    name = "Dense"
    charge = 25

/datum/xenoartifact_trait/impact/on_impact(obj/item/xenoartifact/X, atom/target)
    return charge

//Minor traits



//Major traits

/datum/xenoartifact_trait/sing //Debug
    name = "Tubed"

/datum/xenoartifact_trait/sing/activate(obj/item/xenoartifact/X)
    X.say("DEBUG::XENOARTIFACT::SING")
    ..()

/datum/xenoartifact_trait/capture //Debug
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
