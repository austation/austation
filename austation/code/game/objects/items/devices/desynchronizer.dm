/obj/item/desynchronizer/desync(mob/living/user)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

/obj/item/desynchronizer/resync()
	. = ..()
	REMOVE_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)
