/*
AUStation Necro Chest Loot Table
Beeloot is the number of items in Bees loot table excluding disabled loot
*/

// Note: copied from original file. Original proc commented out in the original file.
/obj/structure/closet/crate/necropolis/tendril/PopulateContents(var/reroll = FALSE) //AUStation modification to reroll disabled loot
	var/loot = rand(1,30)

	// AUStation Code Start -- Beeloot is the number of non disabled bee tendril loot items
	// not updating bee loot amount will cause au tendril loot to have a higher spawn chance
	var/Beeloot_Amount = 28
	if(!reroll)
		if(AU_PopulateContents(Beeloot_Amount))
			return
	// AUStation Code End

	switch(loot)
		if(1)
			new /obj/item/shared_storage/red(src)
		if(2)
			new /obj/item/clothing/suit/space/hardsuit/cult(src)
		if(3)
			new /obj/item/soulstone/anybody(src)
		if(4)
			new /obj/item/katana/cursed(src)
		if(5)
			new /obj/item/clothing/glasses/godeye(src)
		if(6)
			new /obj/item/reagent_containers/glass/bottle/potion/flight(src)
		if(7)
			new /obj/item/pickaxe/diamond(src)
		if(8)
			// AUStation Code Start -- flab loot removal
			PopulateContents(TRUE)
			/*
			if(prob(50))
				new /obj/item/disk/design_disk/modkit_disc/resonator_blast(src)
			else
				new /obj/item/disk/design_disk/modkit_disc/rapid_repeater(src)
			*/// AUStation Code End
		if(9)
			new /obj/item/rod_of_asclepius(src)
		if(10)
			new /obj/item/organ/heart/cursed/wizard(src)
		if(11)
			new /obj/item/ship_in_a_bottle(src)
		if(12)
			new /obj/item/clothing/suit/space/hardsuit/ert/paranormal/lavaland/beserker(src)
		if(13)
			new /obj/item/jacobs_ladder(src)
		if(14)
			new /obj/item/nullrod/scythe/talking(src)
		if(15)
			new /obj/item/nullrod/armblade(src)
		if(16)
			new /obj/item/guardiancreator/hive(src)
		if(17)
			// AUStation Code Start -- flab loot removal
			PopulateContents(TRUE)
			/*
			if(prob(50))
				new /obj/item/disk/design_disk/modkit_disc/mob_and_turf_aoe(src)
			else
				new /obj/item/disk/design_disk/modkit_disc/bounty(src)
			*/// AUStation Code End
		if(18)
			new /obj/item/warp_cube/red(src)
		if(19)
			new /obj/item/wisp_lantern(src)
		if(20)
			new /obj/item/immortality_talisman(src)
		if(21)
			new /obj/item/gun/magic/hook(src)
		if(22)
			new /obj/item/voodoo(src)
		if(23)
			new /obj/item/grenade/clusterbuster/inferno(src)
		if(24)
			new /obj/item/reagent_containers/food/drinks/bottle/holywater/hell(src)
			new /obj/item/clothing/suit/space/hardsuit/ert/paranormal/lavaland/inquisitor(src)
		if(25)
			new /obj/item/book/granter/spell/summonitem(src)
		if(26)
			new /obj/item/book_of_babel(src)
		if(27)
			new /obj/item/borg/upgrade/modkit/lifesteal(src)
			new /obj/item/bedsheet/cult(src)
		if(28)
			new /obj/item/clothing/neck/necklace/memento_mori(src)
		if(29)
			new /obj/item/reagent_containers/glass/waterbottle/relic(src)
		if(30)
			new /obj/item/reagent_containers/glass/bottle/necropolis_seed(src)

/obj/structure/closet/crate/necropolis/tendril/proc/AU_PopulateContents(var/Beeloot_Amount = 0)
	var/AUloot_Amount = 1
	var/AUloot_Roll_Chance = (100 / (Beeloot_Amount + AUloot_Amount)) * AUloot_Amount

	if(prob(AUloot_Roll_Chance))
		var/AU_lootroll = rand(1,AUloot_Amount)
		switch(AU_lootroll)
			if(1)
				new /obj/item/tank/internals/occult(src)
		return TRUE
	else
		return FALSE

//Meat Hook
/obj/item/gun/magic/hook
	item_flags = NEEDS_PERMIT | NOBLUDGEON
	force = 18

/obj/item/projectile/hook
	damage = 25
	paralyze = 30
	knockdown = 0

// BDM
/obj/item/melee/transforming/cleaving_saw
	force = 12
	force_on = 20
	faction_bonus_force = 30

/obj/structure/closet/crate/necropolis/bdm
	name = "blood-drunk miner chest"

/obj/structure/closet/crate/necropolis/bdm/PopulateContents()
	new /obj/item/melee/transforming/cleaving_saw(src)
	new /obj/item/gun/energy/kinetic_accelerator(src)

// Ash Drake
/obj/structure/closet/crate/necropolis/dragon/PopulateContents()
	var/loot = rand(1,4)
	switch(loot)
		if(1)
			new /obj/item/melee/ghost_sword(src)
		if(2)
			new /obj/item/lava_staff(src)
		if(3)
			new /obj/item/book/granter/spell/sacredflame(src)
			new /obj/item/gun/magic/wand/fireball(src)
		if(4)
			new /obj/item/dragons_blood(src)

/obj/item/dragons_blood/attack_self(mob/living/carbon/human/user)
	if(!istype(user))
		return

	var/mob/living/carbon/human/H = user
	var/random = rand(1,4)

	switch(random)
		if(1)
			to_chat(user, "<span class='danger'>Your appearance morphs to that of a very small humanoid ash dragon! You get to look like a freak without the cool abilities.</span>")
			H.dna.features = list("mcolor" = "A02720", "tail_lizard" = "Dark Tiger", "tail_human" = "None", "snout" = "Sharp", "horns" = "Curled", "ears" = "None", "wings" = "None", "frills" = "None", "spines" = "Long", "body_markings" = "Dark Tiger Body", "legs" = "Digitigrade Legs")
			H.eye_color = "fee5a3"
			H.set_species(/datum/species/lizard)
		if(2)
			to_chat(user, "<span class='danger'>Your flesh begins to melt! Miraculously, you seem fine otherwise.</span>")
			H.set_species(/datum/species/skeleton)
		if(3)
			to_chat(user, "<span class='danger'>Power courses through you! You can now shift your form at will.</span>")
			if(user.mind)
				var/obj/effect/proc_holder/spell/targeted/shapeshift/dragon/D = new
				user.mind.AddSpell(D)
		if(4)
			to_chat(user, "<span class='danger'>You feel like you could walk straight through lava now.</span>")
			H.weather_immunities |= "lava"

	playsound(user.loc,'sound/items/drink.ogg', rand(10,50), 1)
	qdel(src)

// Bubblegum
/obj/structure/closet/crate/necropolis/bubblegum/PopulateContents()
	new /obj/item/clothing/suit/space/hostile_environment(src)
	new /obj/item/clothing/head/helmet/space/hostile_environment(src)
	new /obj/effect/spawner/lootdrop/megafaunaore(src)
	var/loot = rand(1,3)
	switch(loot)
		if(1)
			new /obj/item/mayhem(src)
		if(2)
			new /obj/item/blood_contract(src)
		if(3)
			new /obj/item/gun/magic/staff/spellblade(src)

// Colossus
/obj/structure/closet/crate/necropolis/colossus/PopulateContents()
	var/list/choices = subtypesof(/obj/machinery/anomalous_crystal)
	var/random_crystal = pick(choices)
	new random_crystal(src)
	new /obj/item/organ/vocal_cords/colossus(src)

// Legion
/obj/structure/closet/crate/necropolis/legion
	name = "legion chest"

/obj/structure/closet/crate/necropolis/legion/PopulateContents()
	new /obj/item/staff/storm(src)

// Hierophant
/obj/structure/closet/crate/necropolis/hierophant/PopulateContents()
	new /obj/item/hierophant_club(src)

/obj/item/hierophant_club
	force = 15

/* Terra: changes to afterattack() proc are in the main file, to avoid modularizing a massive proc for a oneline change. */

// Puzzle
/obj/structure/closet/crate/necropolis/puzzle/PopulateContents()
	var/loot = rand(1,3)
	switch(loot)
		if(1)
			new /obj/item/soulstone/anybody(src)
		if(2)
			new /obj/item/wisp_lantern(src)
		if(3)
			new /obj/item/prisoncube(src)

/obj/item/tank/internals/occult
  name = "occult tank"
  desc = "An un-natural experiment. Hyms with a musical tune, god knows what happens if it ruptures..."
  icon = 'austation/icons/obj/tank.dmi'
  icon_state = "occult"
  max_integrity = 10
  volume = 200000
  no_rupture = TRUE

  var/datum/gas/gas_type
  var/gas_temp

/obj/item/tank/internals/occult/Initialize()
	..()

	var/list/gas_list = list()

	switch(rand(1, 100))
		if(1 to 30) //cold
			gas_temp = rand(0, 280)
		if(31 to 60) //normal
			gas_temp = 293.15
		if(61 to 90) //hot
			gas_temp = rand(300, 1000)
		if(91 to 100) //S U P E R  H O T
			gas_temp = rand(1001, 100000)

	switch(rand(1, 100))
		if(1 to 10) //better luck next time
			gas_list = list(/datum/gas/nitrogen, /datum/gas/carbon_dioxide, /datum/gas/nitrous_oxide, /datum/gas/water_vapor)
		if(11 to 50) //usefull but boring
			gas_list = list(/datum/gas/oxygen)
			gas_temp = 293.15
		if(50 to 90) //we are getting somewhere
			gas_list = list(/datum/gas/plasma, /datum/gas/nitryl, /datum/gas/bz, /datum/gas/miasma, /datum/gas/pluoxium)
		if(91 to 100) //are you winning son?
			gas_list = list(/datum/gas/tritium, /datum/gas/stimulum, /datum/gas/hypernoblium)

	gas_type = pick(gas_list)

/obj/item/tank/internals/occult/process()
	..()

	air_contents.clear()
	air_contents.set_moles(gas_type, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))
	air_contents.set_temperature(gas_temp)

/obj/item/tank/internals/occult/deconstruct(disassembled = TRUE)
  explosion(src, 0, 0, 8)
  ..()
