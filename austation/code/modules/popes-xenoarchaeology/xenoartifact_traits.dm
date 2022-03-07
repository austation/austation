/datum/xenoartifact_trait
    var/desc //Acts as a descriptor for when examining
    var/charge //How much a trait can output - reserved for activation traits

/datum/xenoartifact_trait/proc/activate(obj/item/xenoartifact/X, atom/target, atom/user)
    return

/datum/xenoartifact_trait/proc/minor_activate(obj/item/xenoartifact/X)
    return

/datum/xenoartifact_trait/proc/on_impact(obj/item/xenoartifact/X)
    return

/datum/xenoartifact_trait/proc/on_slip(obj/item/xenoartifact/X, atom/target)
    return

//Activation traits - only used to generate charge

/datum/xenoartifact_trait/impact //Default impact activation trait. Trauma generates charge
    desc = "Dense"
    charge = 25

/datum/xenoartifact_trait/impact/on_impact(obj/item/xenoartifact/X)
    return charge

//Minor traits

/datum/xenoartifact_trait/looped //Increases charge towards 100
    desc = "Looped"

/datum/xenoartifact_trait/looped/minor_activate(obj/item/xenoartifact/X)
    X.charge = ((100-X.charge)*0.5)+X.charge
    ..()

/datum/xenoartifact_trait/capacitive //Assures charge is saved until activated instead of being lost on failed attempts
    desc = "Capacitive"

//Major traits

/datum/xenoartifact_trait/sing //Debug
    desc = "Tubed"

/datum/xenoartifact_trait/sing/activate(obj/item/xenoartifact/X)
    X.say("DEBUG::XENOARTIFACT::SING")
    X.say(X.charge)
    ..()

/datum/xenoartifact_trait/capture //Capture, self explanitory 
    desc = "Hollow"

/datum/xenoartifact_trait/capture/activate(obj/item/xenoartifact/X, mob/target, mob/user) //ToDo: Optimize this to exlcude ghosts and other things that should be spared
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

/datum/xenoartifact_trait/shock //Shocking https://www.youtube.com/watch?v=iYVO5bUFww0
    desc = "Conductive"

/datum/xenoartifact_trait/shock/activate(obj/item/xenoartifact/X, mob/living/carbon/target)
    var/damage = X.charge*0.4
    target.electrocute_act(damage, X, 1, 1)
    ..()
