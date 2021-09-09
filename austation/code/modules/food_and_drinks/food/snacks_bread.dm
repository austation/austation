/obj/item/reagent_containers/food/snacks/synthetic_cake
	name = "Cake Dough"
	desc = "Looks like an unfinished mess of dough."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "dough"
	bitesize = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = 4)
	tastes = list("sweetness" = 2,"cake" = 5)
	foodtype = GRAIN | DAIRY | SUGAR

/obj/item/reagent_containers/food/snacks/synthetic_cake/proc/cake_transform(obj/item/caked, poisoned = FALSE)
	if(poisoned)
		reagents.add_reagent(/datum/reagent/toxin/amanitin, 5)
	name = caked.name
	appearance = caked.appearance
	layer = initial(layer)
	plane = initial(plane)
	lefthand_file = caked.lefthand_file
	righthand_file = caked.righthand_file
	item_state = caked.item_state
	desc = "Wait, it's a cake?"
	w_class = caked.w_class
	slowdown = caked.slowdown
	equip_delay_self = caked.equip_delay_self
	equip_delay_other = caked.equip_delay_other
	strip_delay = caked.strip_delay
	species_exception = caked.species_exception
	item_flags = caked.item_flags
	obj_flags = caked.obj_flags

/obj/item/reagent_containers/food/snacks/synthetic_cake/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] rips off their own arm in a spray of crumbs and icing. They're made of cake!</span>")
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		var/obj/item/bodypart/l_arm = C.get_bodypart(BODY_ZONE_L_ARM)
		var/obj/item/bodypart/r_arm = C.get_bodypart(BODY_ZONE_R_ARM)
		C.blood_volume = 0
		if(prob(50))
			l_arm.dismember()
		else
			r_arm.dismember()
	playsound(user, get_sfx("desecration"), 50, TRUE, -1)
	return(OXYLOSS|BRUTELOSS)

/obj/item/reagent_containers/food/snacks/store/bread/recycled
	name = "recycled bread"
	desc = "Some bread made from god knows what trash."
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'austation/icons/obj/food/burgerbread.dmi'
	icon_state = "bread1"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 3)
	list_reagents = list(/datum/reagent/consumable/nutriment = 5)
	slices_num = null // fuck spriting this
	tastes = list("processed garbage" = 10)
	var/evolve_level = 10 // value "bread density" needs to reach for bread to evolve
	var/bread_density = 0 // progress to next type
	var/process = FALSE // does this move or something
	var/bread_slowdown = 0 // lets us slow people down when holding the more powerful breads
	var/obj/item/evolveto = /obj/item/reagent_containers/food/snacks/store/bread/recycled/compressed

/obj/item/reagent_containers/food/snacks/store/bread/recycled/New(loc, ...)
	force = clamp((bread_density*0.09) - 5, 0, 150)
	throwforce = force

	if(process)
		START_PROCESSING(SSobj, src)
	. = ..()

/obj/item/reagent_containers/food/snacks/store/bread/recycled/Destroy()
	if(process)
		STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/reagent_containers/food/snacks/store/bread/recycled/pickup(mob/user)
	. = ..()
	user.add_movespeed_modifier(MOVESPEED_ID_BREAD, update=TRUE, priority=100, multiplicative_slowdown=bread_slowdown)

/obj/item/reagent_containers/food/snacks/store/bread/recycled/dropped(mob/user)
	. = ..()
	user.remove_movespeed_modifier(MOVESPEED_ID_BREAD, TRUE)

// handle wall bashing
/obj/item/reagent_containers/food/snacks/store/bread/recycled/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(istype(hit_atom, /turf/closed/wall))
		var/turf/closed/wall/W = hit_atom
		if(force > 60)
			visible_message("\The [src] bashes through \the [W]!")
			playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
			W.dismantle_wall(1)
	else
		. = ..()

/obj/item/reagent_containers/food/snacks/store/bread/recycled/proc/check_evolve()
	if(evolveto && bread_density >= evolve_level)
		var/obj/item/reagent_containers/food/snacks/store/bread/recycled/bread = new evolveto(loc)
		bread.bread_density = bread_density
		bread.force = clamp((bread.bread_density*0.09) - 5, 0, 150)
		bread.throwforce = bread.force
		var/obj/item/reagent_containers/food/snacks/store/bread/recycled/recursive_bread = bread.check_evolve() // lol this shitcode
		qdel(src)
		if(recursive_bread)
			return recursive_bread
		return bread
	return FALSE

/obj/item/reagent_containers/food/snacks/store/bread/recycled/compressed
	name = "compressed recycled bread"
	desc = "Some bread comprised of highly compressed trash. It feels quite heavy."
	icon_state = "bread2"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 6)
	list_reagents = list(/datum/reagent/consumable/nutriment = 8)
	tastes = list("dense garbage" = 10)
	evolve_level = 50
	evolveto = /obj/item/reagent_containers/food/snacks/store/bread/recycled/supercompressed

/obj/item/reagent_containers/food/snacks/store/bread/recycled/supercompressed
	name = "super compressed recycled bread"
	desc = "Some bread compressed down to the point of being nearly rock hard. Difficult to chew."
	icon_state = "bread3"
	w_class = WEIGHT_CLASS_NORMAL
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 8)
	list_reagents = list(/datum/reagent/consumable/nutriment = 12)
	tastes = list("very dense garbage" = 10)
	evolve_level = 100
	evolveto = /obj/item/reagent_containers/food/snacks/store/bread/recycled/diamond

/obj/item/reagent_containers/food/snacks/store/bread/recycled/diamond
	name = "hyper compressed recycled bread"
	desc = "This bread has been compressed so much that the carbon atoms within have begun to form tiny diamond crystals. Actually quite nutritious."
	icon_state = "bread4"
	w_class = WEIGHT_CLASS_NORMAL

	throw_range = 6
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 10)
	list_reagents = list(/datum/reagent/consumable/nutriment = 15)
	tastes = list("diamond" = 10)
	evolve_level = 250
	evolveto = /obj/item/reagent_containers/food/snacks/store/bread/recycled/fissile

/obj/item/reagent_containers/food/snacks/store/bread/recycled/fissile
	name = "fissile recycled bread"
	desc = "The atoms in this bread have been compressed into such heavy isotopes that they've begun to split. Feels warm to the touch."
	icon_state = "bread5"
	w_class = WEIGHT_CLASS_NORMAL
	throw_range = 5
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 12)
	list_reagents = list(/datum/reagent/consumable/nutriment = 16, /datum/reagent/uranium = 10)
	tastes = list("cancer" = 10)
	evolve_level = 350
	evolveto = /obj/item/reagent_containers/food/snacks/store/bread/recycled/fusing

/obj/item/reagent_containers/food/snacks/store/bread/recycled/fusing
	name = "fusing recycled bread"
	desc = "This bread has been compressed to such a degree that the atoms are beginning to undergo nuclear fusion. Tasty."
	icon_state = "bread6"
	w_class = WEIGHT_CLASS_BULKY
	throw_range = 4
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 15)
	list_reagents = list(/datum/reagent/consumable/nutriment = 18, /datum/reagent/hydrogen = 10)
	tastes = list("compressed chili" = 10)
	bread_slowdown = 1
	evolve_level = 550
	evolveto = /obj/item/reagent_containers/food/snacks/store/bread/recycled/degen

/obj/item/reagent_containers/food/snacks/store/bread/recycled/degen
	name = "degenerate recycled bread"
	desc = "Bread so tightly compacted that the matter has burnt up all its fusion energy and turned into super-dense nuclear ash."
	icon_state = "bread8"
	w_class = WEIGHT_CLASS_BULKY
	throw_range = 3
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 18)
	list_reagents = list(/datum/reagent/consumable/nutriment = 20)
	tastes = list("nuclear ash" = 10)
	bread_slowdown = 1.5
	evolve_level = 800
	evolveto = /obj/item/reagent_containers/food/snacks/store/bread/recycled/neutron

/obj/item/reagent_containers/food/snacks/store/bread/recycled/neutron
	name = "neutron recycled bread"
	desc = "Beyond degenerate matter, the atoms in this bread are now so tightly packed that they've collapsed into neutrons. Unfathomably heavy."
	icon_state = "bread9"
	w_class = WEIGHT_CLASS_BULKY
	throw_range = 2
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 20)
	list_reagents = list(/datum/reagent/consumable/nutriment = 24, /datum/reagent/neutron_fluid = 20)
	tastes = list("density" = 10)
	bread_slowdown = 2
	evolve_level = 1500
	evolveto = /obj/item/reagent_containers/food/snacks/store/bread/recycled/subatomic

/obj/item/reagent_containers/food/snacks/store/bread/recycled/subatomic
	name = "subatomic recycled bread"
	desc = "Thanks to pure density and decay heat, the protons and neutrons in this bread have dissociated into quarks."
	icon_state = "bread10"
	w_class = WEIGHT_CLASS_HUGE
	throw_range = 2
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 22)
	list_reagents = list(/datum/reagent/consumable/nutriment = 26, /datum/reagent/neutron_fluid = 22)
	tastes = list("quarks" = 10)
	bread_slowdown = 3
	evolve_level = 2000
	evolveto = /obj/item/reagent_containers/food/snacks/store/bread/recycled/strange

/obj/item/reagent_containers/food/snacks/store/bread/recycled/strange
	name = "strange recycled bread"
	desc = "This bread has somehow achieved an internal pressure and temperature high enough to form strange quarks. The epitome of bread recycling technology."
	icon_state = "bread11"
	w_class = WEIGHT_CLASS_HUGE
	throw_range = 2
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 22)
	list_reagents = list(/datum/reagent/consumable/nutriment = 26, /datum/reagent/strange_matter = 10)
	tastes = list("gluons" = 10)
	bread_slowdown = 3.5
	process = TRUE
	evolve_level = 3000 // make sure to change the anti matter explosion scaling var if you change this
	evolveto = /obj/item/reagent_containers/food/snacks/store/bread/recycled/antimatter

/obj/item/reagent_containers/food/snacks/store/bread/recycled/strange/process()
	if(isturf(loc) && prob(33))
		throw_at(get_edge_target_turf(src, pick(GLOB.alldirs)), 1, 2)
		visible_message("<span class='danger'>[src] shakes violently!</span>")

/obj/item/reagent_containers/food/snacks/store/bread/recycled/antimatter
	name = "anti recycled bread"
	desc = "Bread comprised of pure antimatter. How you can hold this without vaporizing is a mystery."
	icon_state = "bread12"
	w_class = WEIGHT_CLASS_HUGE
	throw_range = 2
	bonus_reagents = list()
	list_reagents = list(/datum/reagent/antimatter = 10)
	tastes = list("your mouth vaporizing" = 10)
	bread_slowdown = 4
	process = TRUE
	evolve_level = 0
	evolveto = null

/obj/item/reagent_containers/food/snacks/store/bread/recycled/antimatter/New(loc, ...)
	. = ..()
	playsound(src, 'sound/magic/charge.ogg', 50, 1)

/obj/item/reagent_containers/food/snacks/store/bread/recycled/antimatter/process() // holding anti bread has a chance to delete your arm
	if(isturf(loc))
		if(prob(45))
			throw_at(get_edge_target_turf(src, pick(GLOB.alldirs)), 2, 5)
			visible_message("<span class='danger'>[src] flickers violently!</span>")
			playsound(src, 'sound/magic/charge.ogg', 10, 1)
		return

	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		var/obj/item/bodypart/B = H.get_holding_bodypart_of_item(src)
		if(prob(10))
			H.visible_message("<span class='warning'>\The [src] suddenly vaporizes \the [H]'s [B] in a flash of light!</span>", "<span class='userdanger'>\The [src] suddenly completely vaporizes your [B] in a blinding flash of light!</span>")
			H.emote("scream")
			H.flash_act(2) // sunnies won't save you from this
			playsound(src, 'sound/effects/supermatter.ogg', 50, 1)
			B.drop_limb()
			qdel(B)
			return
	else if(prob(10) && !istype(loc, /obj/structure/disposalholder)) // goodbye lockers/crates, but not diposal pipes
		visible_message("<span class='warning'>\The [src] melts through \the [loc] in a flash of light!</span>")
		playsound(src, 'sound/effects/supermatter.ogg', 50, 1)
		var/atom/A = loc
		forceMove(get_turf(src))
		qdel(A)

/obj/item/reagent_containers/food/snacks/store/bread/recycled/antimatter/attack(mob/living/M, mob/living/user, def_zone)
	if(user.a_intent == INTENT_HARM)
		M.visible_message("<span class='danger'>\the [user] slams \the [src] into \the [M], vaporizing themselves, \the [M] and \the [src] in a brilliant flash of light and flour!</span>",\
		"<span class='userdanger'>\the [user] slams \the [src] into you, vaporizing themselves, you and \the [src] in a brilliant flash of light and flour!</span>")
		playsound(src, 'sound/effects/supermatter.ogg', 50, 1)
		user.dust(force = TRUE)
		M.dust(force = TRUE)
		qdel(src)
		return TRUE
	else
		return ..()

/obj/item/reagent_containers/food/snacks/store/bread/recycled/antimatter/attack_obj(obj/O, mob/living/user)
	if(user.a_intent == INTENT_HARM)
		O.visible_message("<span class='danger'>\The [user] slams [src] into [O], vaporizing themselves, [O] and [src] in a brilliant flash of light and flour!</span>")
		playsound(src, 'sound/effects/supermatter.ogg', 50, 1)
		user.dust(force = TRUE)
		qdel(O)
		qdel(src)
		return TRUE
	else
		return ..()

/obj/item/reagent_containers/food/snacks/store/bread/recycled/antimatter/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum) // throwing doesn't game the bread
	. = ..()
	if(isopenturf(hit_atom))
		return
	visible_message("<span class='danger'>\The [src] collides with \the [hit_atom], annihilating it in a blinding flash of pure energy and flour!</span>")
	playsound(src, 'sound/effects/supermatter.ogg', 50, 1)
	var/mob/thrower = thrownby.resolve()
	var/force_delete = TRUE
	if(isclosedturf(hit_atom))
		var/turf/closed/T = hit_atom
		T.ScrapeAway()
		force_delete = FALSE
	else if(isliving(hit_atom))
		var/mob/living/L = hit_atom
		L.dust(force = TRUE)
		force_delete = FALSE
	var/static/stabilizer = pick(/datum/reagent/stable_plasma, /datum/reagent/stabilizing_agent, /datum/reagent/consumable/milk)
	if(!(locate(stabilizer) in reagents.reagent_list))
		if(thrownby)
			to_chat(thrower, "<span class='userdanger'>You realize too late that \the [src] was quantum-entangled with your body, as your atoms dissociate into pure energy, taking the bread with them!</span>")
			thrower.dust(force = TRUE)
			qdel(src)
		var/modif = bread_density / 3000 + 1
		explosion(hit_atom.loc, 5*modif, 7*modif, 10*modif, ignorecap = TRUE)
	if(force_delete)
		qdel(hit_atom)

// damage inheritance for mutant bread
/obj/item/reagent_containers/food/snacks/store/bread/recycled/teleport_act()
	mutated++
	reagents.add_reagent(/datum/reagent/toxin/mutagen = 1)
	if(mutated == 5)
		var/mob/living/simple_animal/hostile/breadloaf/brad = new(src.loc)
		brad.melee_damage = force
		qdel(src)

/obj/item/reagent_containers/food/snacks/store/bread/supermatter
	name = "supermatter bread"
	desc = "Someone managed to wrap the supermatter crystal in.. bread!?"
	icon = 'austation/icons/obj/food/burgerbread.dmi'
	icon_state = "smbread"
	force = 15
	throwforce = 15
	list_reagents = list(/datum/reagent/antimatter = 10)
	w_class = WEIGHT_CLASS_HUGE
	slice_path = /obj/machinery/power/supermatter_crystal // yes, you can use this to transport the supermatter crystal
	slices_num = 1
	var/bread_power = 50 // power to add on top of supermatter stats
	var/energy_power = 0 // power from SM energy
	var/damage_power = 0 // power from SM damage

/obj/item/reagent_containers/food/snacks/store/bread/supermatter/New(loc, ...)
	..()
	START_PROCESSING(SSobj, src)

/obj/item/reagent_containers/food/snacks/store/bread/supermatter/Destroy()
	explosion(get_turf(src),2,4,6)
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/reagent_containers/food/snacks/store/bread/supermatter/process()
	if(prob(20) && !(locate(/datum/reagent/stabilizing_agent) in reagents.reagent_list))
		radiation_pulse(src, bread_power + energy_power / 50 + damage_power, 3)

/obj/item/reagent_containers/food/snacks/store/bread/supermatter/initialize_slice(/obj/machinery/power/supermatter_crystal/SM, reagents_per_slice)
	SM.damage = damage_power
	SM.energy = energy_power
