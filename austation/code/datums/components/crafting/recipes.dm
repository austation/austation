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

/datum/crafting_recipe/rossrifle
	name = "Makeshift Ross Rifle"
	result = /obj/item/gun/ballistic/rifle/ross
	reqs = list(/obj/item/weaponcrafting/receiver = 1,
				/obj/item/pipe = 1,
				/obj/item/weaponcrafting/stock = 1,
				/obj/item/stack/packageWrap = 10,
				/obj/item/stack/rods = 10,
				/obj/item/stack/sheet/iron = 5)
	tools = list(TOOL_SCREWDRIVER)
	time = 200
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/huotconvert
	name = "Huot Conversion"
	result = /obj/item/gun/ballistic/automatic/huot
	reqs = list(/obj/item/gun/ballistic/rifle/ross,
				/obj/item/pipe = 2,
				/obj/item/stack/packageWrap = 20,
				/obj/item/stack/rods = 15,
				/obj/item/stack/sheet/iron = 30,
				/obj/item/firing_pin/ = 1,
				/obj/item/stock_parts/manipulator = 2)
	tools = list(TOOL_SCREWDRIVER)
	time = 400
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

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

