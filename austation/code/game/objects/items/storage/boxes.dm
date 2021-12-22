/obj/item/storage/box/stycups
	name = "box of styrofoam cups"
	desc = "It has pictures of styrofoam cups on the front."
	icon = 'austation/icons/obj/storage.dmi'
	illustration = "stycup"

/obj/item/storage/box/stycups/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/food/drinks/styrofoam_cup( src )
