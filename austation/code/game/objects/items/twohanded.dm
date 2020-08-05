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

/obj/item/twohanded/spear/poleaxe
	icon_state = "austation/icons/obj/items_and_weapons/poleaxe0"
	lefthand_file = 'austation/icons/mob/inhands/weapons/polearms_lefthand.dmi'
	righthand_file = 'austation/icons/mob/inhands/weapons/polearms_righthand.dmi'
	name = "Poleaxe"
	desc = "A haphazardly-constructed yet still deadly weapon of ancient design."
	force_wielded = 24
	w_class = WEIGHT_CLASS_HUGE
	attack_verb = list("attacked", "poked", "jabbed", "chopped", "cleaved")
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 30)
	icon_prefix = "poleaxe"

/obj/item/twohanded/spear/poleaxe/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] axes [user.p_them()]self from head to toe! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return (BRUTELOSS)

/obj/item/twohanded/spear/poleaxe/afterattack(atom/A, mob/user, proximity)
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
