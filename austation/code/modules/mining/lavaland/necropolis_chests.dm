/*
AUStation Necro Chest Loot Table
Beeloot is the number of items in Bees loot table excluding disabled loot
*/

// Note: copied from original file. Original proc commented out in the original file.
/obj/structure/closet/crate/necropolis/tendril/proc/try_spawn_loot(datum/source, obj/item/item, mob/user, params) ///proc that handles key checking and generating loot
	SIGNAL_HANDLER

	if(!istype(item, /obj/item/skeleton_key) || spawned_loot)
		return FALSE

	var/loot = rand(1,31)

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
			new /obj/item/rod_of_asclepius(src)
		if(9)
			new /obj/item/organ/heart/cursed/wizard(src)
		if(10)
			new /obj/item/ship_in_a_bottle(src)
		if(11)
			new /obj/item/clothing/suit/space/hardsuit/ert/paranormal/lavaland/beserker(src)
		if(12)
			new /obj/item/jacobs_ladder(src)
		if(13)
			new /obj/item/nullrod/scythe/talking(src)
		if(14)
			new /obj/item/nullrod/armblade(src)
		if(15)
			new /obj/item/guardiancreator/hive(src)
		if(16)
			new /obj/item/warp_cube/red(src)
		if(17)
			new /obj/item/wisp_lantern(src)
		if(18)
			new /obj/item/immortality_talisman(src)
		if(19)
			new /obj/item/gun/magic/hook(src)
		if(20)
			new /obj/item/voodoo(src)
		if(21)
			new /obj/item/grenade/clusterbuster/inferno(src)
		if(22)
			new /obj/item/reagent_containers/food/drinks/bottle/holywater/hell(src)
			new /obj/item/clothing/suit/space/hardsuit/ert/paranormal/lavaland/inquisitor(src)
		if(23)
			new /obj/item/book/granter/spell/summonitem(src)
		if(24)
			new /obj/item/book_of_babel(src)
		if(25)
			new /obj/item/borg/upgrade/modkit/lifesteal(src)
			new /obj/item/bedsheet/cult(src)
		if(26)
			new /obj/item/clothing/neck/necklace/memento_mori(src)
		if(27)
			new /obj/item/reagent_containers/glass/waterbottle/relic(src)
		if(28)
			new /obj/item/reagent_containers/glass/bottle/necropolis_seed(src)
		if(29)
			new /obj/item/tank/internals/combat(src)
		if(30)
			new /obj/item/tank/internals/occult(src)
		if(31)
			new /obj/item/clothing/suit/toggle/lawyer/extravagant(src)
	spawned_loot = TRUE
	qdel(item)
	to_chat(user, "<span class='notice'>You disable the magic lock, revealing the loot.</span>")
	return TRUE

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
