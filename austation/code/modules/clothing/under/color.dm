
/obj/item/clothing/under/skirt/color
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/skirt/color/random
	icon_state = "random_jumpsuit"		//Skirt variant needed

/obj/item/clothing/under/skirt/color/random/Initialize()
	..()
	var/obj/item/clothing/under/skirt/color/C = pick(subtypesof(/obj/item/clothing/under/skirt/color) - /obj/item/clothing/under/skirt/color/random)
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.equip_to_slot_or_del(new C(H), ITEM_SLOT_ICLOTHING)
	else
		new C(loc)
	return INITIALIZE_HINT_QDEL

/obj/item/clothing/under/skirt/color/black
	name = "black jumpskirt"
	icon = 'austation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'austation/icons/mob/uniform.dmi'
	icon_state = "black_skirt"
	item_state = "bl_suit"
	item_color = "black_skirt"

/obj/item/clothing/under/skirt/color/grey
	name = "grey jumpskirt"
	desc = "A tasteful grey jumpskirt that reminds you of the good old days."
	icon = 'austation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'austation/icons/mob/uniform.dmi'
	icon_state = "grey_skirt"
	item_state = "gy_suit"
	item_color = "grey_skirt"

/obj/item/clothing/under/skirt/color/blue
	name = "blue jumpskirt"
	icon = 'austation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'austation/icons/mob/uniform.dmi'
	icon_state = "blue_skirt"
	item_state = "b_suit"
	item_color = "blue_skirt"

/obj/item/clothing/under/skirt/color/green
	name = "green jumpskirt"
	icon = 'austation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'austation/icons/mob/uniform.dmi'
	icon_state = "green_skirt"
	item_state = "g_suit"
	item_color = "green_skirt"

/obj/item/clothing/under/skirt/color/orange
	name = "orange jumpskirt"
	icon = 'austation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'austation/icons/mob/uniform.dmi'
	icon_state = "orange_skirt"
	item_state = "o_suit"
	item_color = "orange_skirt"

/obj/item/clothing/under/skirt/color/pink
	name = "pink jumpskirt"
	icon = 'austation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'austation/icons/mob/uniform.dmi'
	icon_state = "pink_skirt"
	item_state = "p_suit"
	item_color = "pink_skirt"

/obj/item/clothing/under/skirt/color/red
	name = "red jumpskirt"
	icon = 'austation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'austation/icons/mob/uniform.dmi'
	icon_state = "red_skirt"
	item_state = "r_suit"
	item_color = "red_skirt"

/obj/item/clothing/under/skirt/color/white
	name = "white jumpskirt"
	icon = 'austation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'austation/icons/mob/uniform.dmi'
	icon_state = "white_skirt"
	item_state = "w_suit"
	item_color = "white_skirt"

/obj/item/clothing/under/skirt/color/yellow
	name = "yellow jumpskirt"
	icon = 'austation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'austation/icons/mob/uniform.dmi'
	icon_state = "yellow_skirt"
	item_state = "y_suit"
	item_color = "yellow_skirt"

/obj/item/clothing/under/skirt/color/yellow
	name = "yellow jumpskirt"
	icon = 'austation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'austation/icons/mob/uniform.dmi'
	icon_state = "yellow_skirt"
	item_state = "y_suit"
	item_color = "yellow_skirt"

/obj/item/clothing/under/skirt/color/darkblue
	name = "darkblue jumpskirt"
	icon = 'austation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'austation/icons/mob/uniform.dmi'
	icon_state = "darkblue_skirt"
	item_state = "b_suit"
	item_color = "darkblue_skirt"

/obj/item/clothing/under/skirt/color/teal
	name = "teal jumpskirt"
	icon = 'austation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'austation/icons/mob/uniform.dmi'
	icon_state = "teal_skirt"
	item_state = "b_suit"
	item_color = "teal_skirt"

/obj/item/clothing/under/skirt/color/lightpurple
	name = "lightpurple jumpskirt"
	icon = 'austation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'austation/icons/mob/uniform.dmi'
	icon_state = "lightpurple_skirt"
	item_state = "p_suit"
	item_color = "lightpurple_skirt"

/obj/item/clothing/under/skirt/color/darkgreen
	name = "darkgreen jumpskirt"
	icon = 'austation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'austation/icons/mob/uniform.dmi'
	icon_state = "darkgreen_skirt"
	item_state = "g_suit"
	item_color = "darkgreen_skirt"

/obj/item/clothing/under/skirt/color/lightbrown
	name = "lightbrown jumpskirt"
	icon = 'austation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'austation/icons/mob/uniform.dmi'
	icon_state = "lightbrown_skirt"
	item_state = "lb_suit"
	item_color = "lightbrown_skirt"

/obj/item/clothing/under/skirt/color/brown
	name = "brown jumpskirt"
	icon = 'austation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'austation/icons/mob/uniform.dmi'
	icon_state = "brown_skirt"
	item_state = "lb_suit"
	item_color = "brown_skirt"

/obj/item/clothing/under/skirt/color/maroon
	name = "maroon jumpskirt"
	icon = 'austation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'austation/icons/mob/uniform.dmi'
	icon_state = "maroon_skirt"
	item_state = "r_suit"
	item_color = "maroon_skirt"

/obj/item/clothing/under/skirt/color/rainbow
	name = "rainbow jumpskirt"
	icon = 'austation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'austation/icons/mob/uniform.dmi'
	desc = "A multi-colored jumpskirt!"
	icon_state = "rainbow_skirt"
	item_state = "rainbow"
	item_color = "rainbow_skirt"
	can_adjust = FALSE
