//Activator modifiers. Used in context of the difficulty of a task.
#define EASY 0.8
#define NORMAL 1.8
#define HARD 2.4
#define COMBAT 3 //Players who engage in combat are given an extra reward for the consequences of doing so.

//Material defines. Used for characteristic generation.
#define BLUESPACE "#3d8ad1c0"
#define PLASMA "#af14aff5"
#define URANIUM "#96be04"
#define AUSTRALIUM "#f7a800"

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
    var/cooldown = 8 SECONDS //Time between uses
    var/cooldownmod = 0 //Extra time traits can add to the cooldown.
    var/material //Associated traits & colour
    var/lit = FALSE//Specific to burn
    var/lit_count = 10

/obj/item/xenoartifact/Initialize()
    . = ..()

    material = pick(BLUESPACE, PLASMA, URANIUM, AUSTRALIUM)
    add_atom_colour(material, FIXED_COLOUR_PRIORITY)
    charge_req = 10*rand(1, 10)
    switch(material)
        if(BLUESPACE)
            generate_traits(list(/datum/xenoartifact_trait/activator/impact, /datum/xenoartifact_trait/activator/burn), 1)

            var/list/minors = list(/datum/xenoartifact_trait/minor/looped, /datum/xenoartifact_trait/minor/capacitive, /datum/xenoartifact_trait/minor/radioactive, /datum/xenoartifact_trait/minor/cooler, /datum/xenoartifact_trait/minor/delicate)
            generate_traits(minors, 2)
            generate_traits(minors, 3)
            generate_traits(minors, 4)

            var/list/majors = list(/datum/xenoartifact_trait/major/capture, /datum/xenoartifact_trait/major/shock, /datum/xenoartifact_trait/major/timestop, /datum/xenoartifact_trait/major/corginator, /datum/xenoartifact_trait/major/mirrored)
            generate_traits(majors, 5)

        if(PLASMA)
            generate_traits(list(/datum/xenoartifact_trait/activator/impact), 1)

            var/list/minors = list(/datum/xenoartifact_trait/minor/looped, /datum/xenoartifact_trait/minor/capacitive, /datum/xenoartifact_trait/minor/radioactive, /datum/xenoartifact_trait/minor/cooler, /datum/xenoartifact_trait/minor/sharp, /datum/xenoartifact_trait/minor/delicate)
            generate_traits(minors, 2)
            generate_traits(minors, 3)
            generate_traits(minors, 4)

            var/list/majors = list(/datum/xenoartifact_trait/major/shock, /datum/xenoartifact_trait/major/laser)
            generate_traits(majors, 5)

        if(URANIUM)
            generate_traits(list(/datum/xenoartifact_trait/activator/impact, /datum/xenoartifact_trait/activator/burn), 1)

            var/list/minors = list(/datum/xenoartifact_trait/minor/looped, /datum/xenoartifact_trait/minor/capacitive, /datum/xenoartifact_trait/minor/radioactive, /datum/xenoartifact_trait/minor/dense)
            generate_traits(minors, 2)
            generate_traits(minors, 3)
            generate_traits(minors, 4)

            var/list/majors = list(/datum/xenoartifact_trait/major/capture, /datum/xenoartifact_trait/major/shock, /datum/xenoartifact_trait/major/timestop, /datum/xenoartifact_trait/major/bomb)
            generate_traits(majors, 5)
        
        if(AUSTRALIUM)
            generate_traits(list(/datum/xenoartifact_trait/activator/impact, /datum/xenoartifact_trait/activator/burn), 1)

            var/list/minors = list(/datum/xenoartifact_trait/minor/looped, /datum/xenoartifact_trait/minor/capacitive, /datum/xenoartifact_trait/minor/radioactive, /datum/xenoartifact_trait/minor/cooler, /datum/xenoartifact_trait/minor/dense, /datum/xenoartifact_trait/minor/sentient, /datum/xenoartifact_trait/minor/delicate)
            generate_traits(minors, 2)
            generate_traits(minors, 3)
            generate_traits(minors, 4)

            var/list/majors = list(/datum/xenoartifact_trait/major/capture, /datum/xenoartifact_trait/major/timestop, /datum/xenoartifact_trait/major/corginator)
            generate_traits(majors, 5)
    //Please clean up this enite section, init
    var/datum/xenoartifact_trait/temp
    var/min_desc //Checking a while statement with a datum is fucky
    while(!min_desc)
        temp = traits[pick(2,3,4)]
        min_desc = temp.desc
    desc = "The Xenoartifact is made from a [traits[1].desc] [min_desc] material."
    if(traits[5].desc)
        desc = "The Xenoartifact is made from a [traits[1].desc] [min_desc] material. The shape is [traits[5].desc]."
    min_desc = null
    var/count = 5 //5 tries to find one. To:Do: Maybe make this check world.time instead.
    while(!min_desc && count)
        touch_desc = traits[pick(2,3,4)]
        if(touch_desc.on_touch(src, src) && touch_desc != temp)
            min_desc = TRUE
        count -= 1

    for(var/datum/xenoartifact_trait/T in traits)
        T.on_init(src)

/obj/item/xenoartifact/interact(mob/user)
    if(get_trait(/datum/xenoartifact_trait/activator/impact))
        charge += EASY*traits[1].on_impact(src, user) //We can assume it's the first trait, as for the rest too.
    if(lit) //I don't know how you'd achieve this IG. Maybe TK or speed boosts?
        lit = FALSE
        set_light(0)
    touch_desc.on_touch(src, user)
    true_target = user
    check_charge(user)
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
    if(istype(I, /obj/item/xenoartifact_label))
        I.forceMove(src)
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

/obj/item/xenoartifact/proc/check_charge(mob/user, charge_mod) //Run traits. User is generally passed to use as a fail-safe.
    if(manage_cooldown(TRUE))
        for(var/datum/xenoartifact_trait/minor/T in traits) //Run minor traits first. Since they don't require a charge 
            T.activate(src, true_target, user)
        charge += charge_mod
        if(charge >= charge_req) //Run major traits. Typically only one but leave this for now
            for(var/datum/xenoartifact_trait/major/T in traits)
                T.activate(src, true_target, user)
            charge = 0
            manage_cooldown()
        if(get_trait(/datum/xenoartifact_trait/minor/capacitive))
            return
    visible_message("<span class='danger'>The [name] echos emptily.</span>") //Indicator of charging / not enough charge
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

/obj/item/xenoartifact/proc/generate_traits(list/possible_traits, index)
    var/new_trait = pick(possible_traits)
    possible_traits -= new_trait
    traits[index] = new new_trait
    
/obj/item/xenoartifact/proc/get_proximity() //Gets closest mob. Used for burn activator
    for(var/mob/living/M in orange(1, get_turf(src)))
        return M

/obj/item/xenoartifact/proc/get_trait(typepath)
    return (locate(typepath) in traits)

/obj/item/xenoartifact/process(delta_time)
    if(lit)
        true_target = get_proximity()
        if(true_target && charge >= charge_req) //Weird but tollerable
            lit = FALSE
            set_light(0)
            check_charge(true_target)
            visible_message("<span class='danger'>The [name] fizzles out.</span>")
            return PROCESS_KILL
        charge += NORMAL*traits[1].on_burn(src, true_target) //This looks janky but, I haven't run into any issues with it yet
    else    
        return PROCESS_KILL

/obj/item/xenoartifact/Destroy()
    for(var/mob/C in contents) //Stop people inside being deleted. Any other case you're fucked.
        C.forceMove(get_turf(loc))
    . = ..()
    
