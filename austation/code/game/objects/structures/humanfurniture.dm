/obj/structure/chair/comfy/human
	name = "Human leather chair"
	desc = "Looks like a war crime."
	icon = 'austation/icons/obj/chairs.dmi'
	icon_state = "humanskinchair"
	color = rgb(255,255,153)
	resistance_flags = FLAMMABLE
	max_integrity = 70
	buildstackamount = 1
	item_chair = null
	buildstacktype = /obj/item/stack/sheet/animalhide/human

/obj/structure/table/human
	name = "Human leather table"
	desc = "Now you can hold up your war crimes on this war crime."
	icon = 'austation/icons/obj/tables.dmi'
	icon_state = "humanskintable"
	color = rgb(255,255,153)
	resistance_flags = FLAMMABLE
	max_integrity = 60 // weaker than iron table, duh
	buildstack = /obj/item/stack/sheet/animalhide/human
