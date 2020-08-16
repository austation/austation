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

/datum/crafting_recipe/ross
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

	/datum/crafting_recipe/huot
	name = "Huot Conversion"
	result = /obj/item/gun/ballistic/automatic/huot
	reqs = list(/obj/item/gun/ballistic/rifle/ross,
				/obj/item/pipe = 1,
				/obj/item/stack/packageWrap = 10,
				/obj/item/stack/rods = 10,
				/obj/item/stack/sheet/iron = 20,
				/obj/item/firing_pin/ = 1)
	tools = list(TOOL_SCREWDRIVER)
	time = 400
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
