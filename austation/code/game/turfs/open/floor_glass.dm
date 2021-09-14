/turf/open/floor/glass
	name = "glass floor"
	desc = "A floor made of reinforced glass, used for looking into the void."

	//icon = 'icons/turf/space.dmi'
	//icon_state = "0"

	//This is to make the glass actually visible in the map editor and not just a space tile
	icon = 'austation/icons/turf/overlays.dmi'
	icon_state = "glass_floor"

	heat_capacity = 3200
	plane = PLANE_SPACE
	dynamic_lighting = 0
	luminosity = 1
	intact = 0 // make pipes appear above space
	baseturfs = /turf/baseturf_bottom

	//var/health=80 // 2x that of an rwindow
	var/datum/armor/armor = list("melee" = 50, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 25, "bio" = 100, "rad" = 100, "fire" = 80, "acid" = 100)
	var/max_integrity = 400
	var/obj_integrity
	var/damage_deflection = 21
	var/sheetamount = 1 //Number of sheets needed to build this floor (determines how much shit is spawned via Destroy())
	var/cracked_base = "fcrack"
	var/shardtype = /obj/item/shard
	var/sheettype = /obj/item/stack/sheet/rglass //Used for deconstruction
	var/glass_state = "glass_floor" // State of the glass itself.
	var/reinforced = 0
	//var/construction_state = 2 // Fully constructed - no deconstructing
	var/static/list/floor_overlays = list()
	var/static/list/damage_overlays = list()
	var/image/current_damage_overlay
	var/breaksound = "shatter"
	var/very_clear_glass = FALSE

/turf/open/floor/glass/Initialize()
	. = ..()
	icon = 'icons/turf/space.dmi'
	icon_state = "0"
	if (islist(armor))
		armor = getArmor(arglist(armor))
	else if (!armor)
		armor = getArmor()
	else if (!istype(armor, /datum/armor))
		stack_trace("Invalid type [armor.type] found in .armor during /obj Initialize()")
	if(obj_integrity == null)
		obj_integrity = max_integrity

/turf/open/floor/glass/New(loc)
	..(loc)
	if(!very_clear_glass)
		icon_state = "[((x + y) ^ ~(x * y) + z) % 25]"
		if(!floor_overlays[glass_state])
			var/image/floor_overlay = image('austation/icons/turf/overlays.dmi', glass_state)
			floor_overlay.plane = GAME_PLANE
			floor_overlay.layer = CATWALK_LAYER
			floor_overlays[glass_state] = floor_overlay
		overlays += floor_overlays[glass_state]
	update_icon()

/turf/open/floor/glass/update_icon()
	if(obj_integrity >= max_integrity)
		if(current_damage_overlay)
			overlays -= current_damage_overlay
			current_damage_overlay = null
		return
	var/damage_fraction = clamp(round((max_integrity - obj_integrity) / max_integrity * 5) + 1, 1, 5) //gives a number, 1-5, based on damagedness
	var/icon_state = "[cracked_base][damage_fraction]"
	if(!damage_overlays[icon_state])
		var/image/_damage_overlay = image('austation/icons/obj/structures.dmi', icon_state)
		_damage_overlay.plane = GAME_PLANE
		_damage_overlay.layer = CATWALK_LAYER
		damage_overlays[icon_state] = _damage_overlay
	var/damage_overlay = damage_overlays[icon_state]
	if(current_damage_overlay == damage_overlay)
		return
	overlays -= current_damage_overlay
	current_damage_overlay = damage_overlay
	overlays += damage_overlay


/turf/open/floor/glass/examine()
	. = ..()
	if(obj_integrity >= max_integrity) //Sanity
		. += "<span class='notice'>It's in perfect shape without a single scratch.</span>"
	else if(obj_integrity >= 0.8*max_integrity)
		. += "<span class='notice'>It has a few scratches and a small impact.</span>"
	else if(obj_integrity >= 0.5*max_integrity)
		. += "<span class='notice'>It has a few impacts with some cracks running from them.</span>"
	else if(obj_integrity >= 0.2*max_integrity)
		. += "<span class='notice'>It's covered in impact marks and most of the outer layer is cracked.</span>"
	else
		. += "<span class='notice'>It's cracked over multiple layers and has many impact marks.</span>"

/turf/open/floor/glass/proc/break_turf(var/no_teleport=FALSE)
	if(loc)
		playsound(src, "shatter", 70, 1)
	//ReplaceWithLattice()
	// TODO: Break all pipes/wires? //Maybe not, N3X.

	spawnBrokenPieces(src)
	ChangeTurf(/turf/open/space)

/turf/open/floor/glass/proc/spawnBrokenPieces(var/turf/T)
	new shardtype(T, sheetamount)
	new /obj/item/stack/rods(T, sheetamount+1) // Includes lattic)

/turf/open/floor/glass/proc/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir, armour_penetration = 0)
	if(QDELETED(src))
		stack_trace("[src] taking damage after deletion")
		return
	if(sound_effect)
		playsound(src, 'sound/effects/Glasshit.ogg', 75, 1)
	if(obj_integrity > 0)
		damage_amount = run_obj_armor(damage_amount, damage_type, damage_flag, attack_dir, armour_penetration)
		if(damage_amount >= DAMAGE_PRECISION)
			. = damage_amount
			var/old_integ = obj_integrity
			obj_integrity = max(old_integ - damage_amount, 0)
			update_icon()
			if(obj_integrity <= 0)
				break_turf(TRUE)

/turf/open/floor/glass/proc/run_obj_armor(damage_amount, damage_type, damage_flag = 0, attack_dir, armour_penetration = 0)
	if(damage_flag == "melee" && damage_amount < damage_deflection)
		return 0
	switch(damage_type)
		if(BRUTE)
		if(BURN)
		else
			return 0
	var/armor_protection = 0
	if(damage_flag)
		armor_protection = armor.getRating(damage_flag)
	if(armor_protection)		//Only apply weak-against-armor/hollowpoint effects if there actually IS armor.
		armor_protection = CLAMP(armor_protection - armour_penetration, min(armor_protection, 0), 100)
	return round(damage_amount * (100 - armor_protection)*0.01, DAMAGE_PRECISION)

/turf/open/floor/glass/ex_act(severity, target)
	..() //contents explosion
	if(QDELETED(src))
		return
	switch(severity)
		if(1)
			take_damage(INFINITY, BRUTE, "bomb", 0)
		if(2)
			take_damage(rand(100, 250), BRUTE, "bomb", 0)
		if(3)
			take_damage(rand(10, 90), BRUTE, "bomb", 0)

/*/turf/open/floor/glass/proc/healthcheck(var/mob/M, var/sound = 1, var/method="unknown", var/no_teleport=TRUE)
	if(health <= 0)
		if(M)
			var/pressure = 0
			var/datum/gas_mixture/environment = src.return_air()
			if(environment)
				pressure = environment.return_pressure()
			if (pressure > 0)
				message_admins("Glass floor with pressure [pressure]kPa broken (method=[method]) by [M.real_name] ([ADMIN_PP(M)]) at [ADMIN_VERBOSEJMP(src)]!")
				log_admin("Window with pressure [pressure]kPa broken (method=[method]) by [M.real_name] ([M.ckey]) at [src]!")
			M.visible_message("<span class='danger'>[M] falls through the glass!</span>", "<span style='font-size:largest' class='danger'>\The [src] breaks!</span>", "You hear breaking glass.")
		playsound(src, breaksound, 70, 1)
		break_turf(no_teleport)
	else
		if(sound)
			playsound(src, 'sound/effects/Glasshit.ogg', 100, 1)
		update_icon()
*/

/turf/open/floor/glass/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1)
			O.hide(FALSE) // ALWAYS show subfloor stuff.

/turf/open/floor/glass/bullet_act(obj/item/projectile/P)
	. = ..()
	playsound(src, P.hitsound, 50, 1)
	visible_message("<span class='danger'>[src] is hit by \a [P]!</span>", null, null, COMBAT_MESSAGE_RANGE)
	if(!QDELETED(src)) //Bullet on_hit effect might have already destroyed this object
		take_damage(P.damage, P.damage_type, P.flag, 0, turn(P.dir, 180), P.armour_penetration)
/*
/turf/open/floor/glass/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck(Proj.firer, TRUE, "bullet_act")
	return
/turf/open/floor/glass/ex_act(severity)
	switch(severity)
		if(1.0)
			health -= rand(130, 160)
			healthcheck(method="ex_act", no_teleport=TRUE)
			return
		if(2.0)
			health -= rand(20, 50)
			healthcheck(method="ex_act", no_teleport=TRUE)
			return
		if(3.0)
			health -= rand(5, 15)
			healthcheck(method="ex_act", no_teleport=TRUE)
			return
*/
/turf/open/floor/glass/Entered(var/atom/movable/mover)
	if(!reinforced  && istype(mover,/obj/mecha)) //OSHA spec glass flooring, woohoo
		var/obj/mecha/M = mover
		M.visible_message("<span class='warning'>\The [M] damages \the [src] with its sheer weight!</span>",
		"<span class='warning'>You damage \the [src] with your sheer weight!</span>",
		"<span class='italics'>You hear glass cracking!</span>")
		take_damage(30, BRUTE, "melee", 0, get_dir(src, M))
	return 1

/turf/open/floor/glass/proc/hulk_damage()
	return 150 //the damage hulks do on punches to this object, is affected by melee armor

/turf/open/floor/glass/attack_hulk(mob/living/carbon/human/user, does_attack_animation = 0)
	if(user.a_intent == INTENT_HARM)
		..(user, 1)
		user.visible_message("<span class='danger'>[user] smashes [src]!</span>", "<span class='danger'>You smash [src]!</span>", null, COMBAT_MESSAGE_RANGE)
		playsound(src, 'sound/effects/Glasshit.ogg', 100, 1)
		user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ), forced="hulk")
		take_damage(hulk_damage(), BRUTE, "melee", 0, get_dir(src, user))
		return 1
	return 0

/turf/open/floor/glass/proc/attack_generic(mob/user, damage_amount = 0, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, armor_penetration = 0) //used by attack_alien, attack_animal, and attack_slime
	user.do_attack_animation(src)
	user.changeNext_move(CLICK_CD_MELEE)
	return take_damage(damage_amount, damage_type, damage_flag, sound_effect, get_dir(src, user), armor_penetration)

/turf/open/floor/glass/attack_slime(mob/living/simple_animal/slime/user)
	if(!user.is_adult)
		return
	attack_generic(user, rand(15), "melee", 1)

/turf/open/floor/glass/attack_alien(mob/living/carbon/alien/humanoid/user)
	if(attack_generic(user, 60, BRUTE, "melee", 0))
		playsound(src.loc, 'sound/weapons/slash.ogg', 100, 1)

/turf/open/floor/glass/attack_animal(mob/living/simple_animal/M)
	if(!M.melee_damage && !M.obj_damage)
		M.emote("custom", message = "[M.friendly] [src].")
		return 0
	else
		var/play_soundeffect = 1
		if(M.environment_smash)
			play_soundeffect = 0
		if(M.obj_damage)
			. = attack_generic(M, M.obj_damage, M.melee_damage_type, "melee", play_soundeffect, M.armour_penetration)
		else
			. = attack_generic(M, M.melee_damage, M.melee_damage_type, "melee", play_soundeffect, M.armour_penetration)
		if(. && !play_soundeffect)
			playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)

/turf/open/floor/glass/mech_melee_attack(obj/mecha/M)
	M.do_attack_animation(src)
	var/play_soundeffect = 0
	var/mech_damtype = M.damtype
	if(M.selected)
		mech_damtype = M.selected.damtype
		play_soundeffect = 1
	else
		switch(M.damtype)
			if(BRUTE)
				playsound(src, 'sound/weapons/punch4.ogg', 50, 1)
			if(BURN)
				playsound(src, 'sound/items/welder.ogg', 50, 1)
			if(TOX)
				playsound(src, 'sound/effects/spray2.ogg', 50, 1)
				return 0
			else
				return 0
	M.visible_message("<span class='danger'>[M.name] hits [src]!</span>", "<span class='danger'>You hit [src]!</span>", null, COMBAT_MESSAGE_RANGE)
	return take_damage(M.force*3, mech_damtype, "melee", play_soundeffect, get_dir(src, M)) // multiplied by 3 so we can hit objs hard but not be overpowered against mobs.

/turf/open/floor/glass/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	. = ..()
	if(.)
		return
	visible_message("<span class='danger'>\The [AM] slams into \the [src].</span>")
	take_damage(AM.throwforce, BRUTE, "melee", 1, get_dir(src, AM))
/*
//Someone threw something at us, please advise
// I don't think this shit works on turfs, but it's here just in case.
/turf/open/floor/glass/hitby(AM as mob|obj, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	. =  ..()
	if(.)
		return
	if(ismob(AM))
		var/mob/M = AM //Duh
		health -= 10 //We estimate just above a slam but under a crush, since mobs can't carry a throwforce variable
		healthcheck(M, TRUE, "hitby")
		visible_message("<span class='danger'>\The [M] slams into \the [src].</span>", \
		"<span class='danger'>You slam into \the [src].</span>")
	else if(isobj(AM))
		var/obj/item/I = AM
		health -= I.throwforce
		healthcheck()
		visible_message("<span class='danger'>\The [I] slams into \the [src].</span>")
		healthcheck(null, TRUE, "hitby obj")

/turf/open/floor/glass/attack_hand(mob/living/user as mob)
	//Bang against the window
	if(usr.a_intent == INTENT_HARM)
		var/mob/living/carbon/M = usr
		if(M.has_dna())
			if(M.dna.check_mutation(HULK))
				user.do_attack_animation(src, user)
				user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!"))
				user.visible_message("<span class='danger'>[user] smashes \the [src]!</span>")
				health -= 25
				healthcheck(user, TRUE, "attack_hand hulk")
				user.changeNext_move(CLICK_CD_MELEE)
				return
		user.do_attack_animation(src, user)
		user.changeNext_move(10)
		playsound(src, 'sound/effects/glassknock.ogg', 100, 1)
		user.visible_message("<span class='warning'>[user] bangs against \the [src]!</span>", \
		"<span class='warning'>You bang against \the [src]!</span>", \
		"You hear banging.")
		healthcheck(user, TRUE, "attack_hand hurt")

	return

/turf/open/floor/glass/attack_paw(mob/user as mob)
	return attack_hand(user)

/turf/open/floor/glass/proc/attack_generic(mob/living/user as mob, damage = 0)	//used by attack_alien, attack_animal, and attack_slime

	user.do_attack_animation(src, user)
	user.changeNext_move(10)
	health -= damage
	user.visible_message("<span class='danger'>\The [user] smashes into \the [src]!</span>", \
	"<span class='danger'>You smash into \the [src]!</span>")
	healthcheck(user, TRUE, "attack_generic")

/turf/open/floor/glass/attack_alien(mob/user as mob)
	if(islarva(user))
		return
	attack_generic(user, 15)

/turf/open/floor/glass/attack_animal(mob/user as mob)

	var/mob/living/simple_animal/M = user
	if(M.melee_damage <= 0)
		return
	attack_generic(M, M.melee_damage)

/turf/open/floor/glass/attack_slime(mob/user as mob)
	var/mob/living/simple_animal/slime/SL = user
	if(SL.is_adult == 0)
		return
	attack_generic(user, rand(10, 15))
*/
/turf/open/floor/glass/attackby(var/obj/item/W, var/mob/user, params)
	/* No deconstructing
	switch(construction_state)
		if(2) // intact
			if(W.tool_behaviour == TOOL_SCREWDRIVER)
				W.play_tool_sound(src, 75)
				user.visible_message("<span class='warning'>[user] unfastens \the [src] from its frame.</span>", \
				"<span class='notice'>You unfasten \the [src] from its frame.</span>")
				construction_state -= 1
				return
		if(1)
			if(W.tool_behaviour == TOOL_SCREWDRIVER)
				W.play_tool_sound(src, 75)
				user.visible_message("<span class='notice'>[user] fastens \the [src] to its frame.</span>", \
				"<span class='notice'>You fasten \the [src] to its frame.</span>")
				construction_state += 1
				return
			if(W.tool_behaviour == TOOL_CROWBAR)
				W.play_tool_sound(src, 75)
				user.visible_message("<span class='warning'>[user] pries \the [src] from its frame.</span>", \
				"<span class='notice'>You pry \the [src] from its frame.</span>")
				construction_state -= 1
				return
		if(0)
			if(W.tool_behaviour == TOOL_CROWBAR)
				W.play_tool_sound(src, 75)
				user.visible_message("<span class='notice'>[user] pries \the [src] into its frame.</span>", \
				"<span class='notice'>You pry \the [src] into its frame.</span>")
				construction_state += 1
				return

			if(W.tool_behaviour == TOOL_WELDER)
				if(!W.tool_start_check(user, amount=0))
					return
				if(W.use_tool(src, user, 60, volume=100) && construction_state == 0)
					var/pressure = 0
					var/datum/gas_mixture/environment = src.return_air()
					if(environment)
						pressure = environment.return_pressure()
					if (pressure > 0)
						message_admins("Glass floor with pressure [pressure]kPa deconstructed by [user.real_name] ([ADMIN_PP(user)]) at [ADMIN_VERBOSEJMP(src)]!")
						log_admin("Window with pressure [pressure]kPa deconstructed by [user.real_name] ([user.ckey]) at [src]!")
						user.visible_message("<span class='notice'>[user] removes \the [src].</span>", \
						"<span class='notice'>As you remove \the [src], there's hissing noises from the air getting sucked out, are you sure about this?</span>", \
						"<span class='warning'>You hear welding noises.</span>")
					else
						user.visible_message("<span class='notice'>[user] removes \the [src].</span>", \
						"<span class='notice'>You remove \the [src].</span>", \
						"<span class='warning'>You hear welding noises.</span>")
					new sheettype(src, sheetamount)
					src.ReplaceWithLattice()
	*/

	if(W.tool_behaviour == TOOL_WELDER && user.a_intent == INTENT_HELP)
		if(obj_integrity < max_integrity)
			if(!W.tool_start_check(user, amount=0))
				return

			to_chat(user, "<span class='notice'>You begin repairing [src]...</span>")
			if(W.use_tool(src, user, 40, volume=50))
				obj_integrity = max_integrity
				to_chat(user, "<span class='notice'>You repair [src].</span>")
		else
			to_chat(user, "<span class='warning'>[src] is already in good condition!</span>")
		return
	if(ishuman(user) && user.a_intent != INTENT_HARM)
		return
	attackby(W, user)

/turf/open/floor/glass/attack_hand(mob/living/user) //Shamelessly copied from tableslam
	if(Adjacent(user) && user.pulling)
		if(isliving(user.pulling))
			var/mob/living/pushed_mob = user.pulling
			if(pushed_mob.buckled)
				to_chat(user, "<span class='warning'>[pushed_mob] is buckled to [pushed_mob.buckled]!</span>")
				return
			if(user.a_intent == INTENT_GRAB)
				if(user.grab_state == GRAB_PASSIVE)
					pushed_mob.apply_damage(5) //Meh, bit of pain, window is fine, just a shove
					visible_message("<span class='warning'>\The [user] shoves \the [pushed_mob] into \the [src]!</span>", \
					"<span class='warning'>You shove \the [pushed_mob] into \the [src]!</span>")
				if(user.grab_state == GRAB_AGGRESSIVE)
					pushed_mob.apply_damage(10) //Nasty, but dazed and concussed at worst
					visible_message("<span class='danger'>\The [user] slams \the [pushed_mob] into \the [src]!</span>", \
					"<span class='danger'>You slam \the [pushed_mob] into \the [src]!</span>")
				if(user.grab_state > GRAB_AGGRESSIVE)
					pushed_mob.Stun(3)
					pushed_mob.Knockdown(3) //Almost certainly shoved head or face-first, you're going to need a bit for the lights to come back on
					pushed_mob.apply_damage(20) //That got to fucking hurt, you were basically flung into a window, most likely a shattered one at that
					visible_message("<span class='danger'>\The [user] crushes \the [pushed_mob] into \the [src]!</span>", \
					"<span class='danger'>You crush \the [pushed_mob] into \the [src]!</span>")
			log_combat(user, pushed_mob, "floor slammed", null, "against [src]")

/turf/open/floor/glass/handle_decompression_floor_rip()
	take_damage(25, BRUTE, "melee", 0)

/turf/open/floor/glass/remove_tile(mob/user, silent = FALSE, make_tile = TRUE)
	to_chat(user, "<span class='notice'>You can't remove the glass tile, use an RCD!</span>")

/turf/open/floor/glass/singularity_pull(S, current_size)
	..()
	if(current_size == STAGE_THREE)
		if(prob(30))
			take_damage(25, BRUTE, "melee", 0)
	else if(current_size == STAGE_FOUR)
		if(prob(50))
			take_damage(50, BRUTE, "melee", 0)
	else if(current_size >= STAGE_FIVE)
		if(reinforced)
			if(prob(70))
				take_damage(60, BRUTE, "melee", 0)
		else if(prob(50))
			ReplaceWithLattice()
/*
/turf/open/floor/glass/proc/unhandled_attackby(var/obj/item/W, var/mob/user)
	user.do_attack_animation(src, W)
	if(W.damtype == BRUTE || W.damtype == BURN)
		user.changeNext_move(10)
		health -= W.force
		user.visible_message("<span class='warning'>\The [user] hits \the [src] with \the [W].</span>", \
		"<span class='warning'>You hit \the [src] with \the [W].</span>")
		healthcheck(user, TRUE, "attackby [W]")
		return TRUE
	return FALSE
*/
/*
/turf/open/floor/glass/proc/handle_grabslam(var/mob/user)
	if(istype(G.affecting, /mob/living))
		var/mob/living/M = G.affecting
		var/gstate = G.state
		qdel(G)	//Gotta delete it here because if window breaks, it won't get deleted
		user.do_attack_animation(src, G)
		switch(gstate)
			if(GRAB_PASSIVE)
				M.apply_damage(5) //Meh, bit of pain, window is fine, just a shove
				visible_message("<span class='warning'>\The [user] shoves \the [M] into \the [src]!</span>", \
				"<span class='warning'>You shove \the [M] into \the [src]!</span>")
			if(GRAB_AGGRESSIVE)
				M.apply_damage(10) //Nasty, but dazed and concussed at worst
				health -= 5
				visible_message("<span class='danger'>\The [user] slams \the [M] into \the [src]!</span>", \
				"<span class='danger'>You slam \the [M] into \the [src]!</span>")
			if(GRAB_NECK to GRAB_KILL)
				M.Stun(3)
				M.Knockdown(3) //Almost certainly shoved head or face-first, you're going to need a bit for the lights to come back on
				M.apply_damage(20) //That got to fucking hurt, you were basically flung into a window, most likely a shattered one at that
				health -= 20 //Window won't like that
				visible_message("<span class='danger'>\The [user] crushes \the [M] into \the [src]!</span>", \
				"<span class='danger'>You crush \the [M] into \the [src]!</span>")
		healthcheck(user, TRUE, "grabslam [user] -> [M]")
		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been window slammed by [user.name] ([user.ckey]) ([gstate]).</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Window slammed [M.name] ([gstate]).</font>")
		msg_admin_attack("[user.name] ([user.ckey]) window slammed [M.name] ([M.ckey]) ([gstate]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
		log_attack("[user.name] ([user.ckey]) window slammed [M.name] ([M.ckey]) ([gstate]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
		return TRUE
	return FALSE
*/
/turf/open/floor/glass/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/glass/ultraclear
	name = "ultraclear glass floor"
	desc = "A transparent glass floor, used for looking into the void. Jesus christ it's way too clear to be glass."
	very_clear_glass = TRUE

/turf/open/floor/glass/plasma
	name = "plasma glass floor"
	desc = "A floor made of reinforced plasma glass, used for looking into the void."
	icon = 'austation/icons/turf/overlays.dmi'
	icon_state = "plasma_glass_floor"
	heat_capacity = 50000
	shardtype = /obj/item/shard/plasma
	sheettype = /obj/item/stack/sheet/plasmarglass
	glass_state = "plasma_glass_floor"
	max_integrity = 2000
	armor = list("melee" = 85, "bullet" = 20, "laser" = 0, "energy" = 0, "bomb" = 60, "bio" = 100, "rad" = 100, "fire" = 99, "acid" = 100)
	reinforced=TRUE
	damage_deflection = 30

/turf/open/floor/glass/plasma/airless
	initial_gas_mix = AIRLESS_ATMOS

/obj/item/stack/tile/plasmarglass
	name = "plasma glass tile"
	singular_name = "plasma glass tile"
	desc = "A relatively clear reinforced plasma glass tile."
	icon = 'austation/icons/obj/items.dmi'
	icon_state = "tile_plasmarglass"
	turf_type = /turf/open/floor/glass/plasma
	merge_type = /obj/item/stack/tile/plasmarglass

/obj/item/stack/tile/rglass
	name = "glass tile"
	singular_name = "glass tile"
	desc = "A relatively clear reinforced glass tile."
	icon = 'austation/icons/obj/items.dmi'
	icon_state = "tile_rglass"
	turf_type = /turf/open/floor/glass
	merge_type = /obj/item/stack/tile/rglass
