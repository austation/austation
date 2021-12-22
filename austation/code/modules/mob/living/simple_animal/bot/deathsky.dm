/mob/living/simple_animal/bot/secbot/deathsky //I hope you brought EMP grenades..
	name = "Admiral Deathsky"
	desc = "Is that a secbot with four eswords AND pulse rifles in its arms...?"
	icon = 'austation/icons/mob/aibots.dmi'
	icon_state = "deathsky"
	health = 300
	maxHealth = 300
	baton_type = /obj/item/melee/transforming/energy/sword/saber
	base_speed = 10 //he's a REALLY fast fucker
	obj_damage = 60
	environment_smash = ENVIRONMENT_SMASH_WALLS //goodbye walls (maybe)
	emagged = 2
	noloot = TRUE
	var/obj/item/weapon
	var/block_chance = 70

	//gun shit
	var/lastfired = 0
	var/shot_delay = 0 //it fires  f a s t
	var/lasercolor = ""
	var/projectile = /obj/item/projectile/beam/pulse //default projectile is now main so toy beepsky doesn't fire real pulse rounds
	var/shoot_sound = 'sound/weapons/pulse.ogg'

/mob/living/simple_animal/bot/secbot/deathsky/toy //A toy version of Admiral Deathsky!
	name = "Admiral Deathsky"
	desc = "An adorable looking secbot with four toy swords taped to its arms"
	health = 50
	maxHealth = 50
	baton_type = /obj/item/toy/sword
	projectile = /obj/item/projectile/beam/lasertag/bluetag

/mob/living/simple_animal/bot/secbot/deathsky/bullet_act(obj/item/projectile/P)
	visible_message("[src] deflects [P] with its energy swords!")
	playsound(src, 'sound/weapons/blade1.ogg', 50, TRUE)
	return BULLET_ACT_BLOCK

/mob/living/simple_animal/bot/secbot/deathsky/on_entered(datum/source, atom/movable/AM)
	if(ismob(AM) && AM == target)
		visible_message("[src] flails his swords and cuts [AM]!")
		playsound(src,'sound/effects/beepskyspinsabre.ogg',100,TRUE,-1)
		stun_attack(AM)

/mob/living/simple_animal/bot/secbot/deathsky/Initialize()
	. = ..()
	weapon = new baton_type(src)
	weapon.attack_self(src)

/mob/living/simple_animal/bot/secbot/deathsky/Destroy()
	QDEL_NULL(weapon)
	return ..()

/mob/living/simple_animal/bot/secbot/deathsky/special_retaliate_after_attack(mob/user)
	if(mode != BOT_HUNT)
		return
	if(prob(block_chance))
		visible_message("[src] deflects [user]'s attack with his energy swords!")
		playsound(src, 'sound/weapons/blade1.ogg', 50, TRUE, -1)
		return TRUE

/mob/living/simple_animal/bot/secbot/deathsky/stun_attack(mob/living/carbon/C) //Criminals don't deserve to live
	weapon.attack(C, src)
	playsound(src, 'sound/weapons/blade1.ogg', 50, TRUE, -1)
	if(C.stat == DEAD)
		addtimer(CALLBACK(src, /atom/.proc/update_icon), 2)
		back_to_idle()


/mob/living/simple_animal/bot/secbot/deathsky/handle_automated_action()
	if(!on)
		return

	var/list/targets = list()
	for(var/mob/living/carbon/C in view(7,src)) //finds a target
		targets += C
	if(targets.len>0)
		var/mob/living/carbon/t = pick(targets)
		if(t.stat != DEAD) //we don't shoot people who are dead
			shootAt(t)

	switch(mode)
		if(BOT_IDLE)		// idle
			update_icon()
			walk_to(src,0)
			look_for_perp()	// see if any criminals are in range
			if(!mode && auto_patrol)	// still idle, and set to patrol
				mode = BOT_START_PATROL	// switch to patrol mode
		if(BOT_HUNT)		// hunting for perp
			update_icon()
			playsound(src,'sound/effects/beepskyspinsabre.ogg',100,TRUE,-1)
			// general beepsky doesn't give up so easily, jedi scum
			if(frustration >= 20)
				walk_to(src,0)
				back_to_idle()
				return
			if(target)		// make sure target exists
				if(Adjacent(target) && isturf(target.loc))	// if right next to perp
					target_lastloc = target.loc //stun_attack() can clear the target if they're dead, so this needs to be set first
					stun_attack(target)
					anchored = TRUE
					return
				else								// not next to perp
					var/turf/olddist = get_dist(src, target)
					walk_to(src, target,1,4)
					//shootAt(target)
					if((get_dist(src, target)) >= (olddist))
						frustration++
					else
						frustration = 0
			else
				back_to_idle()

		if(BOT_START_PATROL)
			look_for_perp()
			start_patrol()

		if(BOT_PATROL)
			look_for_perp()
			bot_patrol()

/mob/living/simple_animal/bot/secbot/deathsky/look_for_perp()
	anchored = FALSE
	var/judgement_criteria = judgment_criteria()
	for (var/mob/living/carbon/C in view(7,src)) //Let's find us a criminal
		if((C.stat) || (C.handcuffed))
			continue

		if((C.name == oldtarget_name) && (world.time < last_found + 100))
			continue

		threatlevel = C.assess_threat(judgement_criteria, weaponcheck=CALLBACK(src, .proc/check_for_weapons))

		if(!threatlevel)
			continue

		else if(threatlevel >= 4)
			target = C
			oldtarget_name = C.name
			speak("Level [threatlevel] infraction alert!")
			playsound(src, pick('sound/voice/beepsky/criminal.ogg', 'sound/voice/beepsky/justice.ogg', 'sound/voice/beepsky/freeze.ogg'), 50, FALSE)
			playsound(src,'sound/weapons/saberon.ogg',50,TRUE,-1)
			visible_message("[src] ignites his energy swords!")
			icon_state = "deathsky-c"
			visible_message("<b>[src]</b> points at [C.name]!")
			mode = BOT_HUNT
			INVOKE_ASYNC(src, .proc/handle_automated_action)
			break
		else
			continue


/mob/living/simple_animal/bot/secbot/deathsky/explode()

	walk_to(src,0)
	visible_message("<span class='boldannounce'>[src] lets out a huge cough as it blows apart!</span>")
	var/atom/Tsec = drop_location()

	var/obj/item/bot_assembly/secbot/Sa = new (Tsec)
	Sa.build_step = 1
	Sa.add_overlay("hs_hole")
	Sa.created_name = name
	new /obj/item/assembly/prox_sensor(Tsec)

	if(prob(50))
		drop_part(robot_arm, Tsec)

	do_sparks(3, TRUE, src)
	if(!noloot)
		for(var/IS = 0 to 4)
			drop_part(baton_type, Tsec)
	new /obj/effect/decal/cleanable/oil(Tsec)
	qdel(src)



/mob/living/simple_animal/bot/secbot/deathsky/proc/shootAt(mob/target)
	if(world.time <= lastfired + shot_delay) //shot delay is zero atm so it fires once every second
		return
	lastfired = world.time
	var/turf/T = loc
	var/turf/U = get_turf(target)
	if(!U)
		return
	if(!isturf(T))
		return

	if(!projectile)
		return

	var/obj/item/projectile/A = new projectile (loc)
	playsound(src, shoot_sound, 50, TRUE)
	A.preparePixelProjectile(target, src)
	A.fire()

/mob/living/simple_animal/bot/secbot/deathsky/RangedAttack(atom/A)
	if(!on)
		return
	shootAt(A)
