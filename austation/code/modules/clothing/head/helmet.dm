/obj/item/clothing/head/helmet/durathread
	name = "durathread helmet"
	desc = "A helmet made from durathread and leather."
	alternate_worn_icon = 'austation/icons/mob/clothing/head.dmi'
	icon = 'austation/icons/obj/clothing/head.dmi'
	resistance_flags = FLAMMABLE
	armor = list("melee" = 20, "bullet" = 10, "laser" = 30, "energy" = 40, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 40, "acid" = 50, "stamina" = 30)
	strip_delay = 60

/obj/item/clothing/head/helmet/nedhelmet
	name = "bushranger's helmet"
	desc = "A rusty bucket with a small hole to see through."
	alternate_worn_icon = 'austation/icons/mob/clothing/head.dmi'
	icon = 'austation/icons/obj/clothing/head.dmi'
	icon_state = "nkhelmet"
	item_state = "nkhelmet"
	armor = list("melee" = 15, "bullet" = 50, "laser" = 30, "energy" = 10, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 40, "acid" = 50, "stamina" = 30)
	flags_inv = HIDEMASK|HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	flags_cover = HEADCOVERSMOUTH
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	strip_delay = 10 // it's a bucket
	tint = 2 // blocks vision somewhat
	dog_fashion = null
