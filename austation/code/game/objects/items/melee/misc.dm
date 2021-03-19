/obj/item/melee/chainofcommand/attack(mob/living/target, mob/living/user)
    SEND_SIGNAL(target, COMSIG_ADD_MOOD_EVENT, "whipped", /datum/mood_event/whipped)
    return ..()
