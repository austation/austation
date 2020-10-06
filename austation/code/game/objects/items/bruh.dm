// why

// why did I do this

// what did I do to do this

// Is it to late to stop

// Send help, I beg you

#define TRAIT_MILKY "milky"

/obj/item/milking_machine
	icon = 'austation/icons/obj/bruh.dmi'
	name = "milking machine"
	icon_state = "Off"
	item_state = "Off"
	desc = "A pocket sized pump and tubing assembly designed to collect and store products from mammary glands."

	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKET

	var/obj/item/reagent_containers/glass/inserted_item = null

	var/fluid_rate = 0.25 // How much fluid is made per cycle
	var/fluid_id  = "milk" // What fluid is made per cycle

	var/on = 0

/obj/item/milking_machine/examine(mob/user)
	. = ..()
	to_chat(user, "<span class='notice'>[src] is currently [on ? "on" : "off"].</span>")
	if (inserted_item)
		to_chat(user, "<span class='notice'>[inserted_item] contains [inserted_item.reagents.total_volume]/[inserted_item.reagents.maximum_volume] units</span>")
	if (on && loc == user)
		if (!HAS_TRAIT(user, TRAIT_MILKY))
			to_chat(user, "<span class='warning'>You don't lactate.</span>")

/obj/item/milking_machine/attackby(obj/item/W, mob/user, params)
	add_fingerprint(user)
	if(istype(W, /obj/item/reagent_containers/glass) && !inserted_item)
		if(!user.transferItemToLoc(W, src))
			return ..()
		inserted_item = W
		UpdateState()
	else
		return ..()

/obj/item/milking_machine/interact(mob/user)
	if(!isAI(user) && inserted_item)
		add_fingerprint(user)
		on = !on
		if (on)
			to_chat(user, "<span class='notice'>You turn [src] on.</span>")
		else
			to_chat(user, "<span class='notice'>You turn [src] off.</span>")
		UpdateState()
	else
		..()

/obj/item/milking_machine/proc/UpdateIcon()
	icon_state = "[on ? "On" : "Off"][inserted_item ? "Beaker" : ""]"
	item_state = icon_state

/obj/item/milking_machine/proc/UpdateState()
	if (on && inserted_item)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)
	UpdateIcon()

/obj/item/milking_machine/AltClick(mob/living/user)
	add_fingerprint(user)
	user.put_in_hands(inserted_item)
	inserted_item = null
	UpdateState()

/obj/item/milking_machine/process()
	var/mob/M = loc
	if (istype(M))
		if (HAS_TRAIT(M, TRAIT_MILKY))
			inserted_item.reagents.add_reagent(fluid_id, fluid_rate)

/mob/living/carbon/human/handle_traits()
	. = ..()
	if(real_name == "Alex Buttersworth") // Alex is milky (deep lore)
		ADD_TRAIT(src, TRAIT_MILKY, "coderbus")