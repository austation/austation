/obj/item/melee/cultblade/dagger
	throwforce = 25

/obj/item/melee/cultblade
	name = "eldritch longsword"
	desc = "A sword humming with unholy energy. It glows with a dim red light."
	icon_state = "cultblade"
	item_state = "cultblade"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	flags_1 = CONDUCT_1
	sharpness = IS_SHARP
	w_class = WEIGHT_CLASS_BULKY
	force = 30
	throwforce = 10
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "rended")
/obj/item/melee/cultblade/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 40, 100)

/obj/item/melee/cultblade/attack(mob/living/target, mob/living/carbon/human/user)
	if(!iscultist(user))
		user.Paralyze(100)
		user.dropItemToGround(src, TRUE)
		user.visible_message("<span class='warning'>A powerful force shoves [user] away from [target]!</span>", \
							 "<span class='cultlarge'>\"You shouldn't play with sharp things. You'll poke someone's eye out.\"</span>")
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(rand(force/2, force), BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		else
			user.adjustBruteLoss(rand(force/2,force))
		return
	..()

/obj/item/restraints/legcuffs/bola/cult/pickup(mob/living/user)
	if(!iscultist(user))
		to_chat(user, "<span class='warning'>The bola seems to take on a life of its own!</span>")
		ensnare(user)

/obj/item/clothing/head/culthood
	armor = list("melee" = 40, "bullet" = 30, "laser" = 40,"energy" = 20, "bomb" = 25, "bio" = 10, "rad" = 0, "fire" = 10, "acid" = 10)

/obj/item/clothing/suit/cultrobes
	armor = list("melee" = 40, "bullet" = 30, "laser" = 40,"energy" = 20, "bomb" = 25, "bio" = 10, "rad" = 0, "fire" = 10, "acid" = 10)

/obj/item/clothing/suit/hooded/cultrobes/cult_shield
	armor = list("melee" = 50, "bullet" = 40, "laser" = 50,"energy" = 30, "bomb" = 50, "bio" = 30, "rad" = 30, "fire" = 50, "acid" = 50)

/obj/item/twohanded/cult_spear/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/turf/T = get_turf(hit_atom)
	if(isliving(hit_atom))
		var/mob/living/L = hit_atom
		if(iscultist(L))
			playsound(src, 'sound/weapons/throwtap.ogg', 50)
			if(L.put_in_active_hand(src))
				L.visible_message("<span class='warning'>[L] catches [src] out of the air!</span>")
			else
				L.visible_message("<span class='warning'>[src] bounces off of [L], as if repelled by an unseen force!</span>")
		else if(!..())
			if(!L.anti_magic_check())
				if(is_servant_of_ratvar(L))
					L.Paralyze(100)
				else
					L.Paralyze(50)
			break_spear(T)
	else
		..()

/obj/item/shield/mirror
	icon_state = "mirror_shield" // eshield1 for expanded
	illusions = 2
	var/block_chance = 70

/obj/item/shield/mirror/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(iscultist(owner))
		if(istype(hitby, /obj/item/projectile))
			var/obj/item/projectile/P = hitby
			if(P.damage_type == BRUTE || P.damage_type == BURN)
				if(P.damage >= 30)
					var/turf/T = get_turf(owner)
					T.visible_message("<span class='warning'>The sheer force from [P] shatters the mirror shield!</span>")
					new /obj/effect/temp_visual/cult/sparks(T)
					playsound(T, 'sound/effects/glassbr3.ogg', 100)
					owner.Paralyze(25)
					qdel(src)
					return FALSE
			if(P.reflectable & REFLECT_NORMAL)
				. = ..()

		if(.)
			playsound(src, 'sound/weapons/parry.ogg', 100, 1)
			if(illusions > 0)
				illusions--
				addtimer(CALLBACK(src, /obj/item/shield/mirror.proc/readd), 450)
				if(prob(60))
					var/mob/living/simple_animal/hostile/illusion/M = new(owner.loc)
					M.faction = list("cult")
					M.Copy_Parent(owner, 70, 10, 5)
					M.move_to_delay = owner.movement_delay()
				else
					var/mob/living/simple_animal/hostile/illusion/escape/E = new(owner.loc)
					E.Copy_Parent(owner, 70, 10)
					E.GiveTarget(owner)
					E.Goto(owner, owner.movement_delay(), E.minimum_distance)
			return TRUE
	else
		if(prob(50))
			var/mob/living/simple_animal/hostile/illusion/H = new(owner.loc)
			H.Copy_Parent(owner, 100, 20, 5)
			H.faction = list("cult")
			H.GiveTarget(owner)
			H.move_to_delay = owner.movement_delay()
			to_chat(owner, "<span class='danger'><b>[src] betrays you!</b></span>")
		return FALSE

/obj/item/shield/mirror/proc/readd()
	illusions++
	if(illusions == initial(illusions) && isliving(loc))
		var/mob/living/holder = loc
		to_chat(holder, "<span class='cult italic'>The shield's illusions are back at full strength!</span>")

/obj/item/shield/mirror/IsReflect()
	if(prob(block_chance))
		return TRUE
	return FALSE

/obj/item/shield/mirror/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
    var/turf/T = get_turf(hit_atom)
    var/datum/thrownthing/D = throwingdatum
    if(isliving(hit_atom))
        var/mob/living/L = hit_atom
        if(iscultist(L))
            playsound(src, 'sound/weapons/throwtap.ogg', 50)
            if(L.put_in_active_hand(src))
                L.visible_message("<span class='warning'>[L] catches [src] out of the air!</span>")
            else
                L.visible_message("<span class='warning'>[src] bounces off of [L], as if repelled by an unseen force!</span>")
        else if(!..())
            if(!L.anti_magic_check())
                if(is_servant_of_ratvar(L))
                    L.Paralyze(60)
                else
                    L.Paralyze(30)
                if(D?.thrower)
                    for(var/mob/living/Next in orange(2, T))
                        if(!Next.density || iscultist(Next))
                            continue
                        throw_at(Next, 3, 1, D.thrower)
                        return
                    throw_at(D.thrower, 7, 1, null)
    else
        ..()
