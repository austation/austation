//WARNING, SPAGHETTI OVERHEAD
/obj/machinery/cake_printer
	name = "cake printer"
	desc = "Wait, it's all cake?"
	icon = 'austation/icons/obj/machines/cake_printer.dmi'
	icon_state = "kek-printer-stand"
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 40
	circuit = /obj/item/circuitboard/machine/cake_printer
	var/obj/item/reagent_containers/food/snacks/synthetic_cake/caked_item
	var/obj/item/item_scanned
	var/processing = FALSE
	var/efficiency = 1
	var/speed = 1
	var/max_fuel = 100
	var/static/list/cake_blacklist = typecacheof(list(
		/obj/item/screwdriver,
		/obj/item/crowbar,
		/obj/item/wrench,
		/obj/item/wirecutters,
		/obj/item/multitool,
		/obj/item/weldingtool,
		/obj/item/reagent_containers/glass,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/food/condiment))
	var/fuel = 0
	var/fuelcost = 0

/obj/machinery/cake_printer/update_icon()
	if(panel_open)
		icon_state = "kek-printer-o"
	else if(!processing)
		icon_state = "kek-printer-stand"
	else
		icon_state = "kek-printer-work"

/obj/machinery/cake_printer/Initialize(mapload)
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/cake_printer(null)
	component_parts += new /obj/item/stock_parts/manipulator(null)
	component_parts += new /obj/item/stock_parts/matter_bin(null)
	component_parts += new /obj/item/reagent_containers/glass/beaker/large(null)
	RefreshParts()

/obj/machinery/cake_printer/RefreshParts()
	var/max_storage = 100
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		efficiency = M.rating
	for(var/obj/item/stock_parts/manipulator/P in component_parts)
		speed = P.rating
	for(var/obj/item/stock_parts/matter_bin/B in component_parts)
		max_storage = 100 * B.rating
	max_fuel = max_storage

/obj/machinery/cake_printer/emag_act(mob/user)
	. = ..()
	if(!(obj_flags & EMAGGED)) //If it is not already emagged, emag it.
		to_chat(user, "<span class='warning'>You disable \the [src]'s safety features, allowing it's cakes to be toxic.</span>")
		do_sparks(5, TRUE, src)
		obj_flags |= EMAGGED
		log_game("[key_name(user)] emagged [src]")
		message_admins("[key_name_admin(user)] emagged [src]")
	else
		to_chat(user, "<span class='warning'>The status display on \the [src] is already too damaged to short it again.</span>")

/obj/machinery/cake_printer/attackby(obj/item/I, mob/user)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(processing)
		to_chat(user, "<span class='warning'>\The [src] is printing!</span>")
		return
	if(default_deconstruction_screwdriver(user, "kek-printer-o", "kek-printer-o" ,I))
		update_icon()
		return ..()
	if(default_deconstruction_crowbar(I))
		return ..()
	if(panel_open)
		to_chat(user, "<span class='warning'>Close the maintenance panel first.</span>")
		return ..()
	if(istype(I, /obj/item/reagent_containers))
		if(I.reagents.has_reagent(/datum/reagent/consumable/synthetic_cake_batter))
			if(fuel >= max_fuel)
				to_chat(user, "<span class='warning'>The machine's tank is full!</span>")
				return ..()
			fuel += (10 * (I.reagents.get_reagent_amount(/datum/reagent/consumable/synthetic_cake_batter)))
			to_chat(user, "<span class='notice'>You pour the cake batter in [src].</span>")
			I.reagents.remove_reagent(/datum/reagent/consumable/synthetic_cake_batter, I.reagents.get_reagent_amount(/datum/reagent/consumable/synthetic_cake_batter))
			if(fuel > max_fuel)
				fuel = max_fuel
			return ..()
	if(cake_blacklist[I.type] || HAS_TRAIT(I, TRAIT_NODROP) || (I.item_flags & (ABSTRACT | DROPDEL)))
		return ..()
	item_scanned = I
	switch(item_scanned.w_class)
		if(WEIGHT_CLASS_TINY)
			fuelcost = 15 / efficiency
		if(WEIGHT_CLASS_SMALL)
			fuelcost = 30 / efficiency
		if(WEIGHT_CLASS_NORMAL)
			fuelcost = 50 / efficiency
		if(WEIGHT_CLASS_HUGE)
			fuelcost = 100 / efficiency
		if(WEIGHT_CLASS_GIGANTIC)
			fuelcost = 200 / efficiency
	to_chat(user, "<span class='notice'>You scan [item_scanned] on [src].</span>")

/obj/machinery/cake_printer/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += "<span class='notice'>It has <b>[fuel]</b> fuel left.</span>"
		if(item_scanned)
			. += "<span class='notice'>Alt-click to reset the scanner, current scanned item is [item_scanned].</span>"
		else
			. += "<span class='notice'>Alt-click to reset the scanner, no items are scanned.</span>"
		. += "<span class='notice'>The status display reads: Fuel consumption reduced by <b>[(efficiency*25)-25]</b>%.<br>Machine can hold up to <b>[max_fuel]</b> units of fuel.<br> Speed is increased by <b>[(speed*100)-100]%</b></span>"
		if(obj_flags & EMAGGED)
			. += "<span class='warning'>It's status display looks a bit burnt!</span>"
		. += "<span class='notice'>The machine takes synthetic cake batter as fuel, which is some flour, some milk and a bit of astrotame.</span>"

/obj/machinery/cake_printer/Destroy()
	if(caked_item)
		caked_item.forceMove(drop_location())
		caked_item = null
	item_scanned = null
	return ..()

/obj/machinery/cake_printer/attack_ai(mob/user)
	return

/obj/machinery/cake_printer/attack_hand(mob/user)
	if(processing)
		to_chat(user, "<span class='warning'>\The [src] is printing!</span>")
		return
	if(panel_open)
		to_chat(user, "<span class='warning'>Close the maintenance panel first!</span>")
		return
	if(fuel <= 0)
		to_chat(user, "<span class='warning'>No cake batter in the printer!</span>")
		return
	if(fuelcost > fuel)
		to_chat(user, "<span class='warning'>Not enough fuel, add more cake batter!</span>")
		return
	if(!item_scanned)
		to_chat(user, "<span class='warning'>Scan an item first!</span>")
		return
	if(!processing)
		to_chat(user, "<span class='notice'>You start \the [src]'s printing process.</span>")
		visible_message("<span class='notice'>[user] starts \the [src]'s printing process.</span>")
		fuel -= fuelcost
		caked_item = new(src)
		processing = TRUE
		update_icon()
		use_power(300)
		sleep(40 / speed)
		processing = FALSE
		update_icon()
		if(obj_flags & EMAGGED)
			caked_item.cake_transform(item_scanned, TRUE)
		else
			caked_item.cake_transform(item_scanned, FALSE)
		caked_item.forceMove(drop_location())
		return
	return ..()

/obj/machinery/cake_printer/AltClick(mob/living/user)
	. = ..()
	if(processing)
		to_chat(user, "<span class='warning'>\The [src] is printing!</span>")
		return
	visible_message("<span class='notice'>[user] clears [src]'s scanner.</span>")
	to_chat(user, "<span class='notice'>You clear [src]'s scanner.</span>")
	caked_item = null
	item_scanned = null


