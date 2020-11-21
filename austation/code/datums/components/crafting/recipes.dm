/**
  * Run some code once crafting completes
  *
  * user: the /mob that initiated crafting
  */
/datum/crafting_recipe/proc/post_craft(mob/user)
	return

/datum/crafting_recipe/femur_breaker
	name = "Femur Breaker"
	result = /obj/structure/femur_breaker
	time = 150
	reqs = list(/obj/item/stack/sheet/iron = 25,
				/obj/item/stack/sheet/plasteel = 10,
		        /obj/item/stack/cable_coil = 60)
	tools = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)
	category = CAT_MISC

/datum/crafting_recipe/makeshift_gun
	name = "Makeshift pistol"
	result = /obj/item/gun/ballistic/automatic/pistol/aumakeshift
	reqs = list(/obj/item/weaponcrafting/receiver = 1,
				/obj/item/pipe = 1,
				/obj/item/weaponcrafting/stock = 1,
				/obj/item/stack/packageWrap = 5,
				/obj/item/stack/rods = 6)
	tools = list(TOOL_SCREWDRIVER)
	time = 100
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/crossbow
	name = "Makeshift Crossbow"
	result = /obj/item/gun/ballistic/crossbow
	reqs = list(/obj/item/weaponcrafting/receiver = 1,
				/obj/item/pipe = 1,
				/obj/item/weaponcrafting/stock = 1,
				/obj/item/stack/packageWrap = 5,
				/obj/item/stack/cable_coil = 15,
				/obj/item/stack/rods = 5)
	tools = list(TOOL_WELDER, TOOL_WRENCH)
	time = 400
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
