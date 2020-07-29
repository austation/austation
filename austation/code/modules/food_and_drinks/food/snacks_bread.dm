
/obj/item/reagent_containers/food/snacks/synthetic_cake
	name = "Cake Foods Holder Obj"
	desc = "If you can see this description the code for the cake printer fucked up."
	icon = 'icons/obj/food/food.dmi'
	icon_state = ""
	bitesize = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = 4)
	tastes = list("sweetness" = 2,"cake" = 5)
	foodtype = GRAIN | DAIRY | SUGAR

/obj/item/reagent_containers/food/snacks/synthetic_cake/Initialize(mapload, obj/item/caked)
	. = ..()
	name = caked.name
	appearance = caked.appearance
	layer = initial(layer)
	plane = initial(plane)
	lefthand_file = caked.lefthand_file
	righthand_file = caked.righthand_file
	item_state = caked.item_state
	desc = caked.desc
	w_class = caked.w_class
	slowdown = caked.slowdown
	equip_delay_self = caked.equip_delay_self
	equip_delay_other = caked.equip_delay_other
	strip_delay = caked.strip_delay
	species_exception = caked.species_exception
	item_flags = caked.item_flags
	obj_flags = caked.obj_flags
