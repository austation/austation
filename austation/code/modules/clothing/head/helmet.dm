/obj/item/clothing/head/helmet/durathread
	name = "durathread helmet"
	desc = "A helmet made from durathread and leather."
	alternate_worn_icon = 'austation/icons/mob/head.dmi'
	icon = 'austation/icons/obj/clothing/hats.dmi'
	resistance_flags = FLAMMABLE
	armor = list("melee" = 20, "bullet" = 10, "laser" = 30, "energy" = 40, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 40, "acid" = 50, "stamina" = 30)
	strip_delay = 60

/obj/item/clothing/head/helmet/nedhelmet
	name = "bushranger's helmet"
	desc = "A rusty bucket with a small hole to see through."
	alternate_worn_icon = 'austation/icons/mob/head.dmi'
	icon = 'austation/icons/obj/clothing/hats.dmi'
	icon_state = "nkhelmet"
	item_state = "nkhelmet"
	armor = list("melee" = 15, "bullet" = 60, "laser" = 10, "energy" = 10, "bomb" = 40, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50, "stamina" = 40) // same as bulletproof helmet
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	flags_cover = HEADCOVERSMOUTH
	resistance_flags = FIRE_PROOF
	strip_delay = 10 // it's a bucket
	tint = 2 // blocks vision somewhat
	dog_fashion = null
