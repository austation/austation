/obj/item/melee/darksabre
	name = "Kiara's Sabre"
	desc = "This blade looks as dangerous as its owner."
	icon = 'austation/icons/obj/clothing/custom.dmi'
	alternate_worn_icon = 'austation/icons/mob/clothing/custom_w.dmi'
	icon_state = "darksabre"
	item_state = "darksabre"
	lefthand_file = 'austation/icons/mob/inhands/weapons/darksabre_lefthand.dmi'
	righthand_file = 'austation/icons/mob/inhands/weapons/darksabre_righthand.dmi'
	attack_verb = list("attacked", "struck", "hit")
	flags_1 = CONDUCT_1
	obj_flags = UNIQUE_RENAME
	force = 15
	block_level = 1
	block_upgrade_walk = 1
	block_power = 50
	block_flags = BLOCKING_ACTIVE | BLOCKING_NASTY
	throwforce = 10
	w_class = WEIGHT_CLASS_BULKY
	armour_penetration = 75
	sharpness = IS_SHARP
	hitsound = 'sound/weapons/rapierhit.ogg'
	materials = list(/datum/material/iron = 1000)


/obj/item/melee/darksabre/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 30, 95, 5) //fast and effective, but as a sword, it might damage the results.

/obj/item/melee/darksabre/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(attack_type == PROJECTILE_ATTACK)
		final_block_chance = 0 //Don't bring a sword to a gunfight
	return ..()

/obj/item/melee/darksabre/on_exit_storage(datum/component/storage/concrete/S)
	var/obj/item/storage/belt/darksabre/B = S.real_location()
	if(istype(B))
		playsound(B, 'sound/items/unsheath.ogg', 25, TRUE)

/obj/item/melee/darksabre/on_enter_storage(datum/component/storage/concrete/S)
	var/obj/item/storage/belt/darksabre/B = S.real_location()
	if(istype(B))
		playsound(B, 'sound/items/sheath.ogg', 25, TRUE)

/obj/item/melee/darksabre/get_worn_belt_overlay(icon_file)
	return mutable_appearance(icon_file, "darksheath-darksabre")

/obj/item/melee/darksabre/get_belt_overlay()
	return mutable_appearance('austation/icons/obj/clothing/custom.dmi', "darksheath-darksabre")

/obj/item/melee/darksabre/suicide_act(mob/living/user)
	user.visible_message("<span class='suicide'>[user] is trying to cut off all [user.p_their()] limbs with [src]! it looks like [user.p_theyre()] trying to commit suicide!</span>")
	var/i = 0
	ADD_TRAIT(src, TRAIT_NODROP, SABRE_SUICIDE_TRAIT)
	if(iscarbon(user))
		var/mob/living/carbon/Cuser = user
		var/obj/item/bodypart/holding_bodypart = Cuser.get_holding_bodypart_of_item(src)
		var/list/limbs_to_dismember
		var/list/arms = list()
		var/list/legs = list()
		var/obj/item/bodypart/bodypart

		for(bodypart in Cuser.bodyparts)
			if(bodypart == holding_bodypart)
				continue
			if(bodypart.body_part & ARMS)
				arms += bodypart
			else if (bodypart.body_part & LEGS)
				legs += bodypart

		limbs_to_dismember = arms + legs
		if(holding_bodypart)
			limbs_to_dismember += holding_bodypart

		var/speedbase = abs((4 SECONDS) / limbs_to_dismember.len)
		for(bodypart in limbs_to_dismember)
			i++
			addtimer(CALLBACK(src, .proc/suicide_dismember, user, bodypart), speedbase * i)
	addtimer(CALLBACK(src, .proc/manual_suicide, user), (5 SECONDS) * i)
	return MANUAL_SUICIDE

/obj/item/melee/darksabre/proc/suicide_dismember(mob/living/user, obj/item/bodypart/affecting)
	if(!QDELETED(affecting) && affecting.dismemberable && affecting.owner == user && !QDELETED(user))
		playsound(user, hitsound, 25, 1)
		affecting.dismember(BRUTE)
		user.adjustBruteLoss(20)

/obj/item/melee/darksabre/proc/manual_suicide(mob/living/user, originally_nodropped)
	if(!QDELETED(user))
		user.adjustBruteLoss(200)
		user.death(FALSE)
	REMOVE_TRAIT(src, TRAIT_NODROP, SABRE_SUICIDE_TRAIT)
