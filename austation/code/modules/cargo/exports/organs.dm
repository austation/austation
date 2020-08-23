//Monkey crates contain 7 monkeys for 2000 credits
//rougly 285 credits per monkey
//all organs of a monkey that can be sold will sell for 260 credits
//that is a loss of 25 credits per monkey
//you can turn a profit by selling the crate and stamping the manifest but the amount of effort to turn the monkey cubes to monkeys, kill the monkeys, butcher the monkeys is not worth your time compared to crate hunting in maint.
//haven't included brain or stomach as they are not bounty items and I worry something might be destroyed or break if I add them

/datum/export/appendix
	cost = 10
	unit_name = "appendix"
	export_types = list(/obj/item/organ/appendix)

/datum/export/lungs
	cost = 50
	unit_name = "lung"
	export_types = list(/obj/item/organ/lungs)

/datum/export/heart
	cost = 100
	unit_name = "heart"
	export_types = list(/obj/item/organ/heart)


/datum/export/tongue
	cost = 25
	unit_name = "tongue"
	export_types = list(/obj/item/organ/tongue)


/datum/export/eyes
	cost = 20
	unit_name = "eye"
	export_types = list(/obj/item/organ/eyes)


/datum/export/ears
	cost = 20
	unit_name = "ear"
	export_types = list(/obj/item/organ/ears)


/datum/export/liver	
	cost = 35
	unit_name = "liver"
	export_types = list(/obj/item/organ/liver)
