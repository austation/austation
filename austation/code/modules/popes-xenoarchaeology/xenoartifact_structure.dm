/*
    Structure version of xenoartifact. Used for dense trait.
    Look in xenoartifact_traits.dm for more information.
*/
//Activator modifiers. Used in context of the difficulty of a task. Generates better values.
#define EASY 1
#define NORMAL 1.8
#define HARD 2

/obj/structure/xenoartifact //Most of these values are given to the structure when the item initializes
    name = "Xenoartifact"
    icon = 'icons/obj/plushes.dmi'
    icon_state = "lizardplush"
    density = TRUE
    drag_slowdown = 0.5 //A little heavy, a smidge
    
    var/charge = 0 //How much input the artifact is getting from activation traits
    var/charge_req //How much input is required to start the activation
    var/datum/xenoartifact_trait/traits[5] //activation trait, minor 1, minor 2, minor 3, major
    var/atom/true_target //last target.
    var/usedwhen //holder for worldtime
    var/cooldown = 8 SECONDS //Time between uses
    var/cooldownmod = 0 //Extra time traits can add to the cooldown.
    var/material

    var/lit = FALSE//Specific to burn
    var/lit_count = 10

/obj/structure/xenoartifact/Initialize()
    . = ..()
    add_atom_colour(material, FIXED_COLOUR_PRIORITY)
    desc = "The Xenoartifact is made from a [traits[1].desc] [traits[pick(2,3,4)].desc] material."
    if(traits[5].desc)
        desc = "The Xenoartifact is made from a [traits[1].desc] [traits[pick(2,3,4)].desc] material. The shape is [traits[5].desc]."

/obj/structure/xenoartifact/attackby(obj/item/I, mob/living/user) //Use this to check for certain activator input types
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

/obj/structure/xenoartifact/attack_hand(mob/user)
    . = ..()
    for(var/datum/xenoartifact_trait/activator/T in traits)
        charge += EASY*T.on_impact(src, user)
    if(lit) //I don't know how you'd achieve this. Maybe TK or speed boosts?
        lit = FALSE
        set_light(0)

    true_target = user
    check_charge(user)

/obj/structure/xenoartifact/throw_impact(atom/target, mob/user)
    . = ..()
    for(var/datum/xenoartifact_trait/activator/T in traits)
        charge += NORMAL*T.on_impact(src, target)

    true_target = target
    check_charge(null) //Don't pass this for the moment, just cuz it causes issue with capture-datum.

/obj/structure/xenoartifact/proc/check_charge(mob/user, charge_mod) //Run traits. User is generally passed to use as a fail-safe.
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

/obj/structure/xenoartifact/proc/manage_cooldown(checking = FALSE)
    if(!usedwhen)
        if(!checking)
            usedwhen = world.time
        return TRUE
    else if(usedwhen + cooldown + cooldownmod < world.time)
        usedwhen = null
        return TRUE
    else 
        return FALSE

/obj/structure/xenoartifact/proc/generate_traits(list/possible_traits, var/index)
    var/new_trait = pick(possible_traits)
    possible_traits -= new_trait
    traits[index] = new new_trait
    
/obj/structure/xenoartifact/proc/get_proximity() //Gets closest mob. Used for burn activator
    for(var/mob/living/M in orange(1, get_turf(src)))
        return M

/obj/structure/xenoartifact/process(delta_time) //Used expressively for the burn activator
    if(!lit)
        return PROCESS_KILL
    true_target = get_proximity()
    if(true_target && charge >= charge_req) //Weird but tollerable
        check_charge(true_target)
        lit = FALSE
        visible_message("<span class='danger'>The [name] fizzles out.</span>")
    else if(true_target && charge >= charge_req)
        charge += NORMAL*traits[1].on_burn(src) 

/obj/structure/xenoartifact/climb_structure(mob/living/user) //Don't run parent, you can't climb them anyway
    for(var/datum/xenoartifact_trait/major/capture/T in traits)
        charge += 2*T.on_impact(src, user) //Higher on average, causes longer jail time
        true_target = user
        check_charge(null, 100) //If it can capture, you are garunteed to be able to climb in. Might be funny idk
    