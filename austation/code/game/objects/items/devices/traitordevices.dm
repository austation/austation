/obj/item/storage/toolbox/emergency/turret
	desc = "You feel a strange urge to hit this with a wrench."

/obj/item/storage/toolbox/emergency/turret/PopulateContents()
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/analyzer(src)
	new /obj/item/wirecutters(src)

/obj/item/storage/toolbox/emergency/turret/attackby(obj/item/I, mob/living/user, params)
    if(I.tool_behaviour == TOOL_WRENCH && user.a_intent == INTENT_HARM)
        user.visible_message("<span class='danger'>[user] bashes [src] with [I]!</span>", \
            "<span class='danger'>You bash [src] with [I]!</span>", null, COMBAT_MESSAGE_RANGE)
        playsound(src, "sound/items/drill_use.ogg", 80, TRUE, -1)
        user.say("Sentry goin' up!")
        var/obj/machinery/porta_turret/syndicate/pod/toolbox/turret = new(get_turf(loc))
        turret.faction = list("[REF(user)]")
        qdel(src)

    ..()
