/obj/structure/closet/syndicate/parts
	desc = "ALL the parts"

/obj/structure/closet/syndicate/parts/PopulateContents()
	for(var/i in 1 to 30)
		new /obj/item/stock_parts/capacitor/quadratic( src )
		new /obj/item/stock_parts/manipulator/femto( src )
		new /obj/item/stock_parts/matter_bin/bluespace( src )
		new /obj/item/stock_parts/micro_laser/quadultra( src )
		new /obj/item/stock_parts/scanning_module/triphasic( src )
		new /obj/item/stock_parts/cell/bluespace( src )

/obj/structure/closet/syndicate/tools
	desc = "Equipment fit for an admin"

/obj/structure/closet/syndicate/tools/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/storage/belt/utility/chief/full( src )
		new /obj/item/construction/rcd/combat/admin( src )
		new /obj/item/storage/part_replacer/bluespace( src )
		new /obj/item/clothing/mask/gas/welding( src )
		new /obj/item/clothing/glasses/meson/night( src )
		new /obj/item/clothing/gloves/combat( src )
		new /obj/item/clothing/suit/space/hardsuit/syndi/elite( src )
