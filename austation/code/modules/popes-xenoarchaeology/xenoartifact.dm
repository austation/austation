//Activator modifiers. Used in context of the difficulty of a task.
#define EASY 0.8
#define NORMAL 1
#define HARD 1.8
#define COMBAT 2 //Players who engage in combat are given an extra reward for the consequences of doing so.

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
    var/atom/true_target //last target.
    var/usedwhen //holder for worldtime
    var/cooldown = 8 SECONDS //Time between uses
    var/cooldownmod = 0 //Extra time traits can add to the cooldown.
    var/material

    var/lit = FALSE//Specific to burn
    var/lit_count = 10

/obj/item/xenoartifact/Initialize()
    . = ..()

    material = pick(BLUESPACE, PLASMA, URANIUM, AUSTRALIUM)
    src.add_atom_colour(material, FIXED_COLOUR_PRIORITY)
    charge_req = 10*rand(1, 10)
    switch(material)
        if(BLUESPACE)
            generate_traits(list(/datum/xenoartifact_trait/activator/impact, /datum/xenoartifact_trait/activator/burn), 1)

            var/list/minors = list(/datum/xenoartifact_trait/minor/looped, /datum/xenoartifact_trait/minor/capacitive, /datum/xenoartifact_trait/minor/radioactive, /datum/xenoartifact_trait/minor/cooler)
            generate_traits(minors, 2)
            generate_traits(minors, 3)
            generate_traits(minors, 4)

            var/list/majors = list(/datum/xenoartifact_trait/major/capture, /datum/xenoartifact_trait/major/shock, /datum/xenoartifact_trait/major/timestop, /datum/xenoartifact_trait/major/corginator)
            generate_traits(majors, 5)

        if(PLASMA)
            generate_traits(list(/datum/xenoartifact_trait/activator/impact), 1)

            var/list/minors = list(/datum/xenoartifact_trait/minor/looped, /datum/xenoartifact_trait/minor/capacitive, /datum/xenoartifact_trait/minor/radioactive, /datum/xenoartifact_trait/minor/cooler, /datum/xenoartifact_trait/minor/sharp)
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

            var/list/minors = list(/datum/xenoartifact_trait/minor/looped, /datum/xenoartifact_trait/minor/capacitive, /datum/xenoartifact_trait/minor/radioactive, /datum/xenoartifact_trait/minor/cooler, /datum/xenoartifact_trait/minor/dense, /datum/xenoartifact_trait/minor/sentient)
            generate_traits(minors, 2)
            generate_traits(minors, 3)
            generate_traits(minors, 4)

            var/list/majors = list(/datum/xenoartifact_trait/major/capture, /datum/xenoartifact_trait/major/timestop, /datum/xenoartifact_trait/major/corginator)
            generate_traits(majors, 5)
    
    desc = "The Xenoartifact is made from a [traits[1].desc] [traits[pick(2,3,4)].desc] material."
    if(traits[5].desc)
        desc = "The Xenoartifact is made from a [traits[1].desc] [traits[pick(2,3,4)].desc] material. The shape is [traits[5].desc]."
    
    for(var/datum/xenoartifact_trait/T in traits) //More for-loop strangeness
        T.on_init(src)

/obj/item/xenoartifact/interact(mob/user)
    . = ..()
    for(var/datum/xenoartifact_trait/activator/T in traits)
        charge += EASY*T.on_impact(src, user)
    if(lit)
        lit = FALSE
        
    true_target = user
    check_charge(user)

/obj/item/xenoartifact/attack(atom/target, mob/user)
    . = ..()
    for(var/datum/xenoartifact_trait/activator/T in traits)
        if(istype(target, /mob/living/carbon))
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
    if(!..())
        return
    for(var/datum/xenoartifact_trait/activator/T in traits)
        charge += NORMAL*T.on_impact(src, target)

    true_target = target
    check_charge(user)

/obj/item/xenoartifact/attackby(obj/item/I, mob/living/user) //Check for certain items pertaining to activator traits
    if(istype(traits[1], /datum/xenoartifact_trait/activator/impact))
        charge += NORMAL*traits[1].on_impact(src, user)
        true_target = user
        check_charge(user)

    if(istype(traits[1], /datum/xenoartifact_trait/activator/burn))
        var/msg = I.ignition_effect(src, user)
        if(msg && !lit && manage_cooldown(TRUE))
            sleep(2 SECONDS)
            lit = TRUE
            charge += NORMAL*traits[1].on_burn(src, user)
            START_PROCESSING(SSobj, src)
            visible_message("<span class='danger'>The [name] sparks on.</span>")
        else if(!manage_cooldown(TRUE))
            visible_message("<span class='danger'>The [name] echos emptily.</span>")

/obj/item/xenoartifact/proc/check_charge(mob/user, var/charge_mod) //Run traits. User is generally passed to use as a fail-safe.
    if(manage_cooldown(TRUE))
        for(var/datum/xenoartifact_trait/minor/T in traits) //Run minor traits first. Since they don't require a charge 
            T.activate(src, true_target, user)

        charge += charge_mod
        if(charge >= charge_req) //Run major traits. Typically only one but, leave this for now otherwise
            for(var/datum/xenoartifact_trait/major/T in traits)
                T.activate(src, true_target, user)
            charge = 0
            manage_cooldown()

        for(var/datum/xenoartifact_trait/minor/capacitive/T in traits) //To:Do: Why does this only work as a loop? Find a way to make it an IF or something.
            return
    visible_message("<span class='danger'>The [name] echos emptily.</span>") //Got no gas in it   
    charge = 0

/obj/item/xenoartifact/proc/manage_cooldown(checking = FALSE)
    if(!usedwhen)
        if(!checking)
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
    
/obj/item/xenoartifact/proc/get_proximity() //Gets closest mob. Used for burn activator
    for(var/mob/living/M in orange(1, get_turf(src)))
        return M

/obj/item/xenoartifact/process(delta_time) //Used expressively for the burn activator
    if(!lit)
        return PROCESS_KILL
    true_target = get_proximity()
    if(true_target && charge >= charge_req) //Weird but tollerable
        check_charge(true_target)
        lit = FALSE
        visible_message("<span class='danger'>The [name] fizzles out.</span>")
    else if(!charge >= charge_req)
        charge += NORMAL*traits[1].on_burn(src) //This looks janky but, I haven't run into any issues with it yet
    