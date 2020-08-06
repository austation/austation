//THIS MIGHT BE UNBALANCED SO I DUNNO // it totally is.
/obj/item/twohanded/spear/explosive
	var/throw_hit_chance = 35

/obj/item/twohanded/spear/explosive/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(prob(throw_hit_chance) && iscarbon(hit_atom))
		if(!.) //not caught
			explosive.forceMove(get_turf(src))
			explosive.prime()
			qdel(src)

/obj/item/twohanded/required/poleaxe
	icon = 'austation/icons/obj/items_and_weapons.dmi'
	icon_state = "poleaxe0"
	lefthand_file = 'austation/icons/mob/inhands/weapons/polearms_lefthand.dmi'
	righthand_file = 'austation/icons/mob/inhands/weapons/polearms_righthand.dmi'
	name = "Poleaxe"
	desc = "A makeshift spear with an axe head attached to it"
	force = 5
	slot_flags = ITEM_SLOT_BACK
	attack_weight = 3
	force_unwielded = 5
	force_wielded = 24
	block_power_wielded = 25
	block_upgrade_walk = 1
	throwforce = 20
	throw_speed = 4
	embedding = list("embedded_impact_pain_multiplier" = 3)
	armour_penetration = 10
	attack_verb = list("attacked", "chopped", "cleaved", "tore", "jabbed")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = IS_SHARP
	max_integrity = 200
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 30)
	resistance_flags = FIRE_PROOF

/obj/item/twohanded/required/poleaxe/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 100, 70) //decent in a pinch, but pretty bad.

/obj/item/twohanded/required/poleaxe/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] begins to sword-swallow \the [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return BRUTELOSS

/obj/item/twohanded/required/poleaxe/afterattack(atom/A, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(wielded) //destroys windows and grilles in one hit
		if(istype(A, /obj/structure/window))
			var/obj/structure/window/W = A
			W.take_damage(200, BRUTE, "melee", 0)
		else if(istype(A, /obj/structure/grille))
			var/obj/structure/grille/G = A
			G.take_damage(40, BRUTE, "melee", 0)

/obj/item/twohanded/required/poleaxe/update_icon()
	icon_state = "poleaxe[wielded]"
