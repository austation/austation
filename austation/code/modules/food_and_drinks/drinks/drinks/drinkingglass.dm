/obj/item/reagent_containers/food/drinks/drinkingglass/on_reagent_change(changetype)
	. = ..()
	if(R.aus) // if modular drink
		icon = 'austation/icons/obj/drinks.dmi'
