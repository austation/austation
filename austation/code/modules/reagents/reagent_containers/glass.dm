/obj/item/reagent_containers/glass/beaker/jerry
	name = "plastic fuel can"
	desc = "A large plastic fuel can. Holds up to 150 units."
	icon = 'austation/icons/obj/chemical.dmi'
	icon_state = "jerry"
	spillable = FALSE
	materials = list(/datum/material/glass=3000, /datum/material/plastic=3000)
	volume = 150
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,20,25,30,50,100,150)
	list_reagents = list(/datum/reagent/gasoline = 150)
	w_class = WEIGHT_CLASS_BULKY
