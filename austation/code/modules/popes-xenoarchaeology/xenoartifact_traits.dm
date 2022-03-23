/*
    Dev notes: 
        - Activator refers to a trait that generates charge to turn the artifact on. Not to be confused with the activaton proc.
        - Some more crpytic traits should be explained if the name isn't self explanitory. 
*/

/datum/xenoartifact_trait
    var/desc //Acts as a descriptor for when examining
    var/label_name //Used when labeler needs a name and trait is sneaky
    var/label_desc

/datum/xenoartifact_trait/activator
    var/charge //How much a trait can output to fufill the charge requirment

/datum/xenoartifact_trait/minor

/datum/xenoartifact_trait/major

/datum/xenoartifact_trait/proc/activate(obj/item/xenoartifact/X, atom/target, atom/user)
    return FALSE

/datum/xenoartifact_trait/proc/on_impact(obj/item/xenoartifact/X, atom/target, atom/user) //Activator expression.
    return

/datum/xenoartifact_trait/proc/on_burn(obj/item/xenoartifact/X, atom/user) //Activator expression.
    return

/datum/xenoartifact_trait/proc/on_init(obj/item/xenoartifact/X) //Used expressively for traits, typically minor, that transform the item's stats
    return

/datum/xenoartifact_trait/proc/on_touch(obj/item/xenoartifact/X, atom/user) //Used for hints. Distribute as you please.
    return FALSE

//Activation traits - only used to generate charge

/datum/xenoartifact_trait/activator/impact //Default impact activation trait. Trauma generates charge
    desc = "Sturdy"
    label_desc = "Sturdy: The material is sturdy, and the Artifact activates when experiencing physical trauma."
    charge = 25

/datum/xenoartifact_trait/activator/impact/on_impact(obj/item/xenoartifact/X, atom/user)
    return charge

/datum/xenoartifact_trait/activator/burn
    desc = "Flamable"
    label_desc = "Flamable: The material is flamable, and the Artifact activates when ignited."
    charge = 25

/datum/xenoartifact_trait/activator/burn/on_burn(obj/item/xenoartifact/X)
    if(X.process_type != "lit") //If it hasn't been activated yet
        sleep(2 SECONDS)
        X.set_light(2)
        X.visible_message("<span class='danger'>The [X.name] sparks on.</span>")
        X.process_type = "lit"
        START_PROCESSING(SSobj, X)
    return charge   

/datum/xenoartifact_trait/activator/clock
    label_name = "Tuned"
    label_desc = "Tuned: The material produces a resonance pattern similar to quartz, causing it to activate every so often."

/datum/xenoartifact_trait/activator/clock/on_init(obj/item/xenoartifact/X)
    charge = X.charge_req+11
    ..()

/datum/xenoartifact_trait/activator/clock/on_impact(obj/item/xenoartifact/X, atom/target) 
    X.process_type = "tick"
    START_PROCESSING(SSobj, X)
    return charge

//Minor traits

/datum/xenoartifact_trait/minor/looped //Increases charge towards 100
    desc = "Looped"
    label_desc = "Looped: The Artifact feeds into itself and amplifies its own charge."

/datum/xenoartifact_trait/minor/looped/activate(obj/item/xenoartifact/X)
    X.charge = ((100-X.charge)*0.2)+X.charge
    ..()

/datum/xenoartifact_trait/minor/capacitive //Assures charge is saved until activated instead of being lost on failed attempts
    desc = "Capacitive"
    label_desc = "Capacitive: The Artifact's structure is coiled and maintains charge until it activates."

/datum/xenoartifact_trait/minor/capacitive/on_touch(obj/item/xenoartifact/X, mob/user)
    to_chat(user, "<span class='notice'>The hairs on your neck stand up after touching the [X.name].</span>")
    return TRUE

/datum/xenoartifact_trait/minor/dense //Makes the artifact unable to be picked up. Associated with better charge modifers.
    desc = "Dense"
    label_desc = "Dense: The Artifact is dense and cannot be easily lifted but, the design amplifies any input it recieves."

/datum/xenoartifact_trait/minor/dense/on_init(obj/item/xenoartifact/X)
    var/obj/structure/xenoartifact/N = new(get_turf(X))
    N.traits = X.traits
    N.charge_req = X.charge_req*1.5
    N.desc = X.desc
    N.add_atom_colour(X.material, FIXED_COLOUR_PRIORITY)
    N.touch_desc = X.touch_desc
    N.alpha = X.alpha
    qdel(X)
    ..()

/datum/xenoartifact_trait/minor/sharp
    desc = "Sharp"
    label_desc = "Sharp: The Artifact is shaped into a fine edge at one side."

/datum/xenoartifact_trait/minor/sharp/on_touch(obj/item/xenoartifact/X, mob/user)
    to_chat(user, "<span class='notice'>The [X.name] feels sharp.</span>")
    return TRUE

/datum/xenoartifact_trait/minor/sharp/on_init(obj/item/xenoartifact/X)
    X.sharpness = IS_SHARP_ACCURATE
    X.force = X.charge_req*0.15
    X.throwforce = 10
    X.attack_verb = list("cleaved", "slashed", "stabbed", "sliced", "tore", "ripped", "diced", "cut")
    X.attack_weight = 2
    X.armour_penetration = 5
    X.throw_speed = 3
    X.throw_range = 6
    ..()

/datum/xenoartifact_trait/minor/radioactive
    label_name = "Roadiactive"
    label_desc = "Roadiactive: The Artifact Emmits harmful particles when activated."

/datum/xenoartifact_trait/minor/radioactive/on_touch(obj/item/xenoartifact/X, mob/user)
    to_chat(user, "<span class='notice'>You feel pins and needles after touching the [X.name].</span>")
    return TRUE

/datum/xenoartifact_trait/minor/radioactive/activate(obj/item/xenoartifact/X, mob/living/target)
    target.radiation += X.charge*1.5 //Might revisit the value.
    ..()

/datum/xenoartifact_trait/minor/cooler //Faster cooldowns
    desc = "Frosted"
    label_desc = "Frosted: The Artifact's internal mechanism actively keeps it cold, reducing time between uses."

/datum/xenoartifact_trait/minor/cooler/on_touch(obj/item/xenoartifact/X, mob/user)
    to_chat(user, "<span class='notice'>The [X.name] feels cold.</span>")
    return TRUE

/datum/xenoartifact_trait/minor/cooler/on_init(obj/item/xenoartifact/X)
    X.cooldown = 4 SECONDS //Might revisit the value.
    ..()

/datum/xenoartifact_trait/minor/cooler/activate(obj/item/xenoartifact/X)
    X.charge -= 10

/datum/xenoartifact_trait/minor/sentient //The attempt here is to make a one-ring type sentience
    label_name = "Sentient"
    label_desc = "Sentient: The Artifact seems to be alive, influencing events around it. The Artifact wants to return to its master..."

/datum/xenoartifact_trait/minor/sentient/on_touch(obj/item/xenoartifact/X, mob/user)
    to_chat(user, "<span class='warning'>The [X.name] whispers to you...</span>")
    return TRUE

/datum/xenoartifact_trait/minor/sentient/on_init(obj/item/xenoartifact/X)
    addtimer(CALLBACK(src, .proc/get_canidate, X), 5 SECONDS)
    ..()

/datum/xenoartifact_trait/minor/sentient/proc/get_canidate(obj/item/xenoartifact/X)
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

/obj/effect/proc_holder/spell/targeted/xeno_senitent_action
    name = "Activate"
    desc = "Select a target to activate your traits on."
    range = 1
    charge_max = 0 SECONDS
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
        if(X)
            X.true_target = M
            X.charge = 0
            X.check_charge(X, X.charge_req)
            charge_max = X.cooldown+X.cooldownmod

/datum/xenoartifact_trait/minor/delicate //Limited uses. Fun fact: You can get turned into a corgi forever if the artifact breaks during the transformation. Do not fix this.
    desc = "Fragile"
    label_desc = "Fragile: The Artifact is poorly made. Continuous use will destroy it."

/datum/xenoartifact_trait/minor/delicate/on_init(obj/item/xenoartifact/X)
    X.max_integrity = pick(200, 300, 500, 800, 1000)
    X.alpha = X.alpha * 0.5
    ..()

/datum/xenoartifact_trait/minor/delicate/activate(obj/item/xenoartifact/X, atom/target, atom/user)
    if(X.obj_integrity && X.charge >= X.charge_req)
        X.obj_integrity -= 100
    else if(X.obj_integrity <= 0)
        X.visible_message("<span class='danger'>The [X.name] shatters!</span>")
        to_chat(user, "<span class='danger'>The [X.name] shatters!</span>")
        qdel(X)
    ..()

/datum/xenoartifact_trait/minor/aura
    desc = "Expansive"
    label_desc = "Expansive: The Artifact's surface reaches towards every creature in the room. Even the empty space behind you..."

/datum/xenoartifact_trait/minor/aura/activate(obj/item/xenoartifact/X) //bug with adding target twice
    for(var/mob/living/M in orange(X.charge*0.03, get_turf(X.loc)))
        if(!(M in X.true_target))
            X.true_target += M
    ..()
    
//Major traits

/datum/xenoartifact_trait/major/sing //Debug
    desc = "Bugged"
    label_desc = "Bugged: The shape resembles nothing. You are Godless."

/datum/xenoartifact_trait/major/sing/activate(obj/item/xenoartifact/X)
    X.say("DEBUG::XENOARTIFACT::SING")
    X.say(X.charge)
    ..()

/datum/xenoartifact_trait/major/capture //To:do bug with not being able to find mob loc
    desc = "Hollow"
    label_desc = "Hollow: The shape is hollow but, exhibits traits of a bluespace matrix."

/datum/xenoartifact_trait/major/capture/on_init(obj/item/xenoartifact/X)
    if(prob(5)) //5% chance for a surprise friend :)
        var/mob/living/simple_animal/hostile/russian/R = new //Сталкер Я знайшов артефакт!
        R.forceMove(X)
        R.anchored = TRUE
    ..()

/datum/xenoartifact_trait/major/capture/activate(obj/item/xenoartifact/X, mob/target, mob/user)
    arrest(X, target, user)
    addtimer(CALLBACK(src, .proc/release, X), X.charge*0.3 SECONDS)
    X.cooldownmod = X.charge*0.6 SECONDS
    ..()

/datum/xenoartifact_trait/major/capture/proc/arrest(obj/item/xenoartifact/X, mob/target, mob/user)
    if(istype(target, /mob/living))
        if(user||target == user)
            user.dropItemToGround(X, TRUE, TRUE)
        var/atom/movable/AM = target
        AM.anchored = TRUE
        AM.forceMove(X) //Go to the mega gay zone
        return AM
    else    
        return

/datum/xenoartifact_trait/major/capture/proc/release(obj/item/xenoartifact/X)
    var/atom/movable/AM
    for(var/mob/living/M in X.contents)
        AM = M
        var/turf/T = get_turf(X.loc)
        AM.anchored = FALSE
        AM.forceMove(T)

/datum/xenoartifact_trait/major/shock
    desc = "Conductive"
    label_desc = "Conductive: The shape resembles two lighting forks. Subtle arcs seem to leaps across them."

/datum/xenoartifact_trait/major/shock/on_touch(obj/item/xenoartifact/X, mob/user)
    to_chat(user, "<span class='notice'>You feel a slight static after touching the [X.name].</span>")
    return TRUE

/datum/xenoartifact_trait/major/shock/activate(obj/item/xenoartifact/X, mob/living/target, mob/user)
    var/damage = X.charge*0.1
    do_sparks(pick(1, 2), 0, X)
    var/mob/living/carbon/victim = target //Have to type convert to work with other traits
    victim.electrocute_act(damage, X, 1, 1)
    X.cooldownmod = (X.charge*0.1) SECONDS
    ..()

/datum/xenoartifact_trait/major/timestop
    desc = "Melted" //The Persistence of Memory
    label_desc = "Melted: The shape is drooling and sluggish. Light around it seems to invert."

/datum/xenoartifact_trait/major/timestop/on_touch(obj/item/xenoartifact/X, mob/user)
    to_chat(user, "<span class='notice'>Your hand feels slow while stroking the [X.name].</span>")
    return TRUE

/datum/xenoartifact_trait/major/timestop/activate(obj/item/xenoartifact/X, atom/target)
    var/turf/T = get_turf(X.loc)
    if(!X)
        T = get_turf(target.loc)     
    new /obj/effect/timestop(T, 2, (X.charge*0.1) SECONDS)
    X.cooldownmod = (X.charge*0.1) SECONDS
    ..()

/datum/xenoartifact_trait/major/laser //To:Do - make laser work on turfs
    desc = "Scoped"
    label_desc = "Scoped: The shape resembles the barrel of a gun. It's possible that it might dispense candy."

/datum/xenoartifact_trait/major/laser/activate(obj/item/xenoartifact/X, atom/target, mob/living/user)
    if(get_dist(target, user) <= 1)
        var/mob/living/victim = target
        victim.adjust_fire_stacks(1)
        victim.IgniteMob()
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
            A = new /obj/item/projectile/beam/emitter
    A.preparePixelProjectile(target.loc, X)
    A.fire()
    ..()

/datum/xenoartifact_trait/major/bomb //To:Do Fix this
    label_name = "Explosive"
    label_desc = "Explosive: The shape is perfectly spherical. You think you might be able to see the words ACME on the bottom."

/datum/xenoartifact_trait/major/bomb/on_touch(obj/item/xenoartifact/X, mob/user)
    to_chat(user, "<span class='notice'>You feel a ticking deep within the [X.name].</span>")
    return TRUE

/datum/xenoartifact_trait/major/bomb/activate(obj/item/xenoartifact/X, atom/target, mob/user)
    X.visible_message("<span class='danger'>The [X.name] begins to tick loudly...</span>")
    to_chat(user,"<span class='danger'>The [X.name] begins to tick loudly...</span>")
    addtimer(CALLBACK(src, .proc/explode, X), (70-(X.charge*0.6)) SECONDS)
    X.cooldownmod = (70-(X.charge*0.6)) SECONDS
    ..()

/datum/xenoartifact_trait/major/bomb/proc/explode(obj/item/xenoartifact/X)
    var/turf/T = get_turf(X.loc)
    if(!T)
        return
    explosion(T,X.charge/3,X.charge,X/2,X.charge)
    qdel(X) //Bon voyage. If you remove this, keep in mind there's a callback bug regarding a looping issue.

/datum/xenoartifact_trait/major/corginator //All of this is stolen from corgium. 
    desc = "Fuzzy" //Weirdchamp
    label_desc = "Fuzzy: The shape is hard to discern under all the hair sprouting out from the surface. You swear you've heard it bark before."

/datum/xenoartifact_trait/major/corginator/activate(obj/item/xenoartifact/X, mob/living/target)
    if(istype(target, /mob/living))
        var/mob/living/simple_animal/pet/dog/corgi/new_corgi = transform(X, target)
        addtimer(CALLBACK(src, .proc/transform_back, X, target, new_corgi), (X.charge*0.6) SECONDS)
        X.cooldownmod = (X.charge*0.6) SECONDS
    ..()

/datum/xenoartifact_trait/major/corginator/proc/transform(obj/item/xenoartifact/X, mob/living/target)
    var/mob/living/simple_animal/pet/dog/corgi/new_corgi
    new_corgi = new(get_turf(target))
    new_corgi.key = target.key
    new_corgi.name = target.real_name
    new_corgi.real_name = target.real_name
    ADD_TRAIT(target, TRAIT_NOBREATH, CORGIUM_TRAIT)
    var/mob/living/C = target
    if(istype(C))
        var/obj/item/hat = C.get_item_by_slot(ITEM_SLOT_HEAD)
        if(hat)
            new_corgi.place_on_head(hat,null,FALSE)
    target.forceMove(new_corgi)
    return new_corgi

/datum/xenoartifact_trait/major/corginator/proc/transform_back(obj/item/xenoartifact/X, mob/living/target, mob/living/simple_animal/pet/dog/corgi/new_corgi)
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

/datum/xenoartifact_trait/major/mirrored //Swaps the last to target's body's locations, or minds if the charge is higher. To:Do fix this
    desc = "Mirrored"
    label_desc = "Mirrored: The shape resembles a fractal. The surface almost seems to march to the centre and out again."
    var/mob/first_body
    var/mob/second_body
    var/first_ckey
    var/second_ckey

/datum/xenoartifact_trait/major/mirrored/on_touch(obj/item/xenoartifact/X, mob/user)
    if(first_body.key != user.key)
        to_chat(user, "<span class='warning'>You see a reflection in the [X.name], it isn't yours...</span>")
    else    
        to_chat(user, "<span class='notice'>You see your reflection in the [X.name].</span>")
    return TRUE

/datum/xenoartifact_trait/major/mirrored/activate(obj/item/xenoartifact/X, mob/living/target)
    if(!first_body)
        first_body = target
        first_ckey = target.key
        return
    else if(target != first_body)
        second_body = target
        second_ckey = target.key
    else
        return
    first_ckey = second_body
    second_ckey = first_body
    first_body = null
    second_body = null
    first_ckey = null
    second_ckey = null
    
    ..()

/datum/xenoartifact_trait/major/emp //To:Do fix this
    label_name = "EMP"
    label_desc = "EMP: The shape of the Artifact doesn't resemble anything particularly interesting. Technology around the Artifact seems to malfunction."

/datum/xenoartifact_trait/major/emp/activate(obj/item/xenoartifact/X)
    X.say("Buzzy bee")
    ..()
