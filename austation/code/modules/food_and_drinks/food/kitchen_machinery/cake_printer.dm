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
		/obj/item/reagent_containers/food/condiment,
		/obj/item/storage,
		/obj/item/smallDelivery,
		/obj/item/his_grace))
	var/fuel = 0
	var/fuelcost = 0

/obj/machinery/cake_printer/update_icon()
	if(panel_open)
		icon_state = "kek-printer-o"
	else if(!src.processing)
		icon_state = "kek-printer-stand"
	else
		icon_state = "kek-printer-work"
	return

/obj/machinery/cake_printer/Initialize()
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

/obj/machinery/cake_printer/attackby(obj/item/I, mob/user)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(processing)
		to_chat(user, "<span class='warning'>[src] is printing!</span>")
		return
	if(default_deconstruction_screwdriver(user, "kek-printer-o", "kek-printer-o" ,I))
		update_icon()
		return
	if(default_deconstruction_crowbar(I))
		return
	if(panel_open)
		to_chat(user, "<span class='warning'>Close the maintenance panel first.</span>")
		return ..()
	if(istype(I, /obj/item/reagent_containers))
		if(I.reagents.has_reagent(/datum/reagent/consumable/synthetic_cake_batter))
			if(fuel >= max_fuel)
				fuel = max_fuel
				to_chat(user, "<span class='warning'>The machine's tank is full!</span>")
				return
			else
				fuel += (10 * (I.reagents.get_reagent_amount(/datum/reagent/consumable/synthetic_cake_batter)))
				to_chat(user, "<span class='notice'>You pour the cake batter in [src].</span>")
				I.reagents.remove_reagent(/datum/reagent/consumable/synthetic_cake_batter, I.reagents.get_reagent_amount(/datum/reagent/consumable/synthetic_cake_batter))
				return
	if(is_type_in_typecache(I, cake_blacklist) || HAS_TRAIT(I, TRAIT_NODROP) || (I.item_flags & (ABSTRACT | DROPDEL)))
		return ..()
	else if(!caked_item)
		caked_item = new/obj/item/reagent_containers/food/snacks/synthetic_cake(src, I)
		switch(caked_item.w_class)
			if(WEIGHT_CLASS_TINY)
				fuelcost = 10 / efficiency
			if(WEIGHT_CLASS_SMALL)
				fuelcost = 25 / efficiency
			if(WEIGHT_CLASS_NORMAL)
				fuelcost = 50 / efficiency
			if(WEIGHT_CLASS_HUGE)
				fuelcost = 100 / efficiency
			if(WEIGHT_CLASS_GIGANTIC)
				fuelcost = 200 / efficiency
		to_chat(user, "<span class='notice'>You scan [caked_item] on [src].</span>")
		return

/obj/machinery/cake_printer/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += "<span class='notice'>It has <b>[fuel]</b> fuel left.<span>"
		. += "<span class='notice'>The status display reads: Fuel consumption reduced by <b>[(efficiency*25)-25]</b>%.<br>Machine can hold up to <b>[max_fuel]</b> units of fuel.<br> Speed is increased by <b>[speed*100]%</b><span>"

/obj/machinery/cake_printer/Exited(atom/movable/AM)
	if(AM == caked_item)
		finish_cake()
		caked_item = null
	..()

/obj/machinery/cake_printer/Destroy()
	caked_item = null
	. = ..()

/obj/machinery/cake_printer/attack_ai(mob/user)
	return

/obj/machinery/cake_printer/proc/finish_cake()
	caked_item.desc = "Wait, it's a cake?"

/obj/machinery/cake_printer/attack_hand(mob/user)
	if(processing)
		to_chat(user, "<span class='warning'>[src] is printing!</span>")
		return
	if(panel_open)
		to_chat(user, "<span class='warning'>Close the maintenance panel first!</span>")
		return
	if(fuel == 0)
		to_chat(user, "<span class='warning'>No cake batter in the printer!</span>")
		return
	if(fuelcost > fuel)
		to_chat(user, "<span class='warning'>Not enough fuel, add more cake batter!</span>")
		return
	if(caked_item && !processing)
		to_chat(user, "<span class='notice'>You start [src]'s printing process.</span>")
		processing = TRUE
		update_icon()
		use_power(300)
		sleep(40 / speed)
		processing = FALSE
		fuel = fuel - fuelcost
		update_icon()
		finish_cake()
		caked_item.forceMove(drop_location())
		return
	return ..()

