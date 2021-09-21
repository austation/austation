/obj/item/clothing/suit/armor/nedarmour
	name = "bushranger's armour"
	desc = "A dusty jacket with a rusty metal plate vest."
	icon = 'austation/icons/obj/clothing/suit.dmi'
	alternate_worn_icon = 'austation/icons/mob/clothing/suit.dmi'
	icon_state = "nkarmour"
	item_state = "nkarmour"
	armor = list("melee" = 15, "bullet" = 50, "laser" = 30, "energy" = 10, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 40, "acid" = 50, "stamina" = 30) // same as bulletproof helmet
	slowdown = 0.5 // heavy!

/obj/item/clothing/suit/toggle/lawyer/extravagant
	name = "extravagant suit"
	desc = "Only for special occasions. Offers zero protection."
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "suitjacket_blue"
	item_state = "suitjacket_blue"
	armor = list("melee" = -9999, "bullet" = -9999, "laser" = -9999, "energy" = -9999, "bomb" = -9999, "bio" = -9999, "rad" = -9999, "fire" = -9999, "acid" = -9999, "stamina" = -9999)

/obj/item/clothing/suit/toggle/lawyer/extravagant/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type)
	var/mob/living/carbon/human/H = owner
	H.gib()
