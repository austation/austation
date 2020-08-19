/obj/structure/closet/crate/necropolis/tendril/PopulateContents()
  var/loot = rand(1,29)
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
      new /obj/item/clothing/suit/space/hardsuit/ert/paranormal/beserker(src)
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
      new /obj/item/clothing/suit/space/hardsuit/ert/paranormal/inquisitor(src)
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
      new /obj/item/tank/internals/occult(src)

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
			gas_list = list(/datum/gas/tritium, /datum/gas/stimulum, /datum/gas/)

	gas_type = pick(gas_list)

/obj/item/tank/internals/occult/process()
	..()

	air_contents.clear()
	air_contents.set_moles(gas_type, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))
	air_contents.set_temperature(gas_temp)

/obj/item/tank/internals/occult/deconstruct(disassembled = TRUE)
  explosion(src, 0, 0, 8)
  ..()
