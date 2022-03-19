//Activator modifiers. Used in context of the difficulty of a task.
#define EASY 1
#define NORMAL 1.8
#define HARD 2.4
#define COMBAT 2.8 //Players who engage in combat are given an extra reward for the consequences of doing so.

//Material defines. Used for characteristic generation.
#define BLUESPACE "#027fc7de"
#define PLASMA "#aa29aad8"
#define URANIUM "#6c8515"
#define AUSTRALIUM "#ffbb00"

/obj/item/xenoartifact //Most of these values are generated on initialize
    name = "Xenoartifact"
    icon = 'icons/obj/plushes.dmi'
    icon_state = "lizardplush"
    w_class = WEIGHT_CLASS_TINY
    heat = 1000
    light_color = LIGHT_COLOR_FIRE
    
    var/charge = 0 //How much input the artifact is getting from activator traits
    var/charge_req //How much input is required to start the activation
    var/datum/xenoartifact_trait/traits[5] //activation trait, minor 1, minor 2, minor 3, major
    var/datum/xenoartifact_trait/touch_desc
    var/atom/true_target //last target.
    var/usedwhen //holder for worldtime
    var/cooldown = 14 SECONDS //Time between uses
    var/cooldownmod = 0 //Extra time traits can add to the cooldown.
    var/material //Associated traits & colour
    var/lit = FALSE//Specific to burn
    var/min_desc

/obj/item/xenoartifact/Initialize()
    . = ..()

    material = pick(BLUESPACE, PLASMA, URANIUM, AUSTRALIUM)
    add_atom_colour(material, FIXED_COLOUR_PRIORITY)
    charge_req = 10*rand(1, 10)
    switch(material)
        if(BLUESPACE)
            generate_traits(list(/datum/xenoartifact_trait/minor/sharp, /datum/xenoartifact_trait/minor/radioactive,
                            /datum/xenoartifact_trait/minor/sentient, /datum/xenoartifact_trait/major/sing, 
                            /datum/xenoartifact_trait/major/laser, /datum/xenoartifact_trait/major/bomb))

        if(PLASMA)
            generate_traits(list(/datum/xenoartifact_trait/major/sing, /datum/xenoartifact_trait/activator/burn,
                            /datum/xenoartifact_trait/minor/dense, /datum/xenoartifact_trait/minor/sentient, 
                            /datum/xenoartifact_trait/major/capture, /datum/xenoartifact_trait/major/timestop,
                            /datum/xenoartifact_trait/major/bomb, /datum/xenoartifact_trait/major/mirrored,
                            /datum/xenoartifact_trait/major/corginator))

        if(URANIUM)
            generate_traits(list(/datum/xenoartifact_trait/major/sing, /datum/xenoartifact_trait/minor/sharp,
                            /datum/xenoartifact_trait/major/laser, /datum/xenoartifact_trait/major/corginator))  

        if(AUSTRALIUM)
            generate_traits(list(/datum/xenoartifact_trait/major/sing)) //Wild card, exlcuding debug for obvious reasons

    for(var/datum/xenoartifact_trait/T in traits)
        T.on_init(src)

/obj/item/xenoartifact/interact(mob/user)
    if(get_trait(/datum/xenoartifact_trait/activator/impact))
        charge += EASY*traits[1].on_impact(src, user) //We can assume it's the first trait, as for the rest too.
        true_target = user
        check_charge(user)
    if(lit) //If you can reach it.
        lit = FALSE
        set_light(0)
    if(touch_desc)
        touch_desc.on_touch(src, user)
    ..()

/obj/item/xenoartifact/attack(atom/target, mob/user)
    if(get_trait(/datum/xenoartifact_trait/activator/impact))
        if(istype(target, /mob/living/carbon))
            charge += COMBAT*traits[1].on_impact(src, target)
        else
            charge += HARD*traits[1].on_impact(src, target)
    true_target = target
    check_charge(user)
    ..()

/obj/item/xenoartifact/afterattack(atom/target, mob/user, proximity)
    if(get_trait(/datum/xenoartifact_trait/activator/impact) && !proximity)
        charge += EASY*traits[1].on_impact(src, target)
    true_target = target
    check_charge(user)
    ..()

/obj/item/xenoartifact/throw_impact(atom/target, mob/user)
    if(!..())
        return
    if(get_trait(/datum/xenoartifact_trait/activator/impact))
        charge += NORMAL*traits[1].on_impact(src, target)
    true_target = target
    check_charge(user)

/obj/item/xenoartifact/attackby(obj/item/I, mob/living/user)
    if(istype(I, /obj/item/xenoartifact_label)||istype(I, /obj/item/xenoartifact_labeler)) //It'd be fustrating otherwise
        return

    if(get_trait(/datum/xenoartifact_trait/activator/impact))
        charge += NORMAL*traits[1].on_impact(src, user)
        true_target = user
        check_charge(user)

    if(get_trait(/datum/xenoartifact_trait/activator/burn))
        var/msg = I.ignition_effect(src, user)
        if(msg && !lit && manage_cooldown(TRUE))
            sleep(2 SECONDS)
            lit = TRUE
            charge += NORMAL*traits[1].on_burn(src, user)
            START_PROCESSING(SSobj, src)
            set_light(2)
            visible_message("<span class='danger'>The [name] sparks on.</span>")
        else if(!manage_cooldown(TRUE) && msg)
            visible_message("<span class='danger'>The [name] echos emptily.</span>")

/obj/item/xenoartifact/proc/check_charge(mob/user, charge_mod, empty_charge = TRUE) //Run traits. User is generally passed to use as a fail-safe.
    if(manage_cooldown(TRUE))
        for(var/datum/xenoartifact_trait/minor/T in traits) //Run minor traits first. Since they don't require a charge 
            T.activate(src, true_target, user)
        charge += charge_mod
        if(charge >= charge_req) //Run major traits. Typically only one but leave this for now
            for(var/datum/xenoartifact_trait/major/T in traits)
                T.activate(src, true_target, user)
            manage_cooldown()
            if(empty_charge)
                charge = 0
    else
        visible_message("<span class='danger'>The [name] echos emptily.</span>") //Indicator of charging
    if(empty_charge && !(get_trait(/datum/xenoartifact_trait/minor/capacitive)))
        charge = 0

/obj/item/xenoartifact/proc/manage_cooldown(checking = FALSE)
    if(!usedwhen)
        usedwhen = world.time * ((checking-1)*-1)
        return TRUE
    else if(usedwhen + cooldown + cooldownmod < world.time)
        usedwhen = null
        return TRUE
    else 
        return FALSE

/obj/item/xenoartifact/proc/generate_traits(list/blacklist_traits)
    var/list/activators = list()
    var/list/minors = list()
    var/list/majors = list()
    var/new_trait

    for(var/T in typesof(/datum/xenoartifact_trait/activator))
        if(!(T in blacklist_traits) && T != /datum/xenoartifact_trait/activator)
            activators += T
    new_trait = pick(activators)
    traits[1] = new new_trait
    desc = "The Xenoartifact is made from a [traits[1].desc]"

    for(var/T in typesof(/datum/xenoartifact_trait/minor))
        if(!(T in blacklist_traits) && T != /datum/xenoartifact_trait/minor)
            minors += T
    for(var/X in 2 to 4)
        new_trait = pick(minors)
        minors -= new_trait
        traits[X] = new new_trait
        if(traits[X].desc && !min_desc)
            min_desc = traits[X].desc
            desc = "[desc] [min_desc]"
        if(traits[X].on_touch(src, src))
            touch_desc = traits[X]
    desc = "[desc] material."

    for(var/T in typesof(/datum/xenoartifact_trait/major))
        if(!(T in blacklist_traits) && T != /datum/xenoartifact_trait/major)
            majors += T
    new_trait = pick(majors)
    traits[5] = new new_trait
    if(traits[5].desc)
        desc = "[desc] The shape is [traits[5].desc]."
    if(traits[5].on_touch(src, src))
        touch_desc = traits[5]
    
/obj/item/xenoartifact/proc/get_proximity() //Will I really reuse this?
    for(var/mob/living/M in orange(2, get_turf(src)))
        return M

/obj/item/xenoartifact/proc/get_trait(typepath)
    return (locate(typepath) in traits)

/obj/item/xenoartifact/process(delta_time)
    if(lit) //possible revisit this
        true_target = get_proximity()
        if(true_target && charge >= charge_req)
            lit = FALSE
            set_light(0)
            check_charge(true_target)
            visible_message("<span class='danger'>The [name] fizzles out.</span>")
            return PROCESS_KILL
        charge += NORMAL*traits[1].on_burn(src, true_target)
    else    
        return PROCESS_KILL

/obj/item/xenoartifact/Destroy()
    for(var/mob/living/carbon/C in contents) //People inside only have a 50/50 chance of surviving a collapse. Other mobs perish either way.
        if(pick(FALSE, TRUE))
            C.forceMove(get_turf(loc))
    ..()
