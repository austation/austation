/obj/item/reagent_containers/food/drinks/soda_cans/space_bitters
	name = "Space Bitters"
	desc = "Singlet and thongs not included!"
	icon = 'austation/icons/obj/drinks.dmi'
	icon_state = "space_bitters"
	list_reagents = list(/datum/reagent/consumable/ethanol/beer = 30)
	foodtype = GRAIN | ALCOHOL

/obj/item/reagent_containers/food/drinks/britcup
	name = "doctors mug"
	desc = "A cup with the british flag emblazoned on it. It has the words. Galaxy's best doctor 2530 engrained along the bottom"

/obj/item/reagent_containers/food/drinks/bottle/gingerbeer
	name = "Chundaberg Ginger Beer"
	desc = "Imported from the godless uninhabitable jungles of Space Queensland."
	icon = 'austation/icons/obj/drinks.dmi'
	icon_state = "gingerbottle"
	list_reagents = list(/datum/reagent/consumable/ginger_beer = 30)
	foodtype = SUGAR | JUNKFOOD

/obj/item/reagent_containers/food/drinks/bottle/bitters
	name = "Narrowing Bitters"
	desc = "A dash is always nice. A swig proves why they call it Narrowing Bitters."
	icon = 'austation/icons/obj/drinks.dmi'
	icon_state = "bitters"
	list_reagents = list(/datum/reagent/consumable/ethanol/bitters = 50)
	foodtype = GRAIN | ALCOHOL

/obj/item/reagent_containers/food/drinks/styrofoam_cup
	name = "styrofoam cup"
	desc = "A cup made from styrofoam."
	icon_state = "water_cup_e" //placeholder
	volume = 10
	spillable = TRUE
	isGlass = FALSE

/obj/item/reagent_containers/food/drinks/styrofoam_cup/proc/crush(mob/M, mob/user)
	if(M == user && !src.reagents.total_volume && user.a_intent == INTENT_HARM)
		user.visible_message("<span class='warning'>[user] crushes the styrofoam cup!</span>", "<span class='notice'>You crush the styrofoam cup.</span>")
		var/obj/item/trash/cup/crushed_cup = new /obj/item/trash/cup(user.loc)
		crushed_cup.icon_state = icon_state
		qdel(src)
