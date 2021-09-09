/datum/crafting_recipe/food/chef_only/supermatterbread
	name = "Supermatter bread (Chef only)"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/store/bread/plain = 5, // the supermatter aint small
		/obj/machinery/power/supermatter_crystal/engine = 0, // supermatter not an item, it is handled in the check_requirement proc
	)
	result = /obj/item/reagent_containers/food/snacks/store/bread/supermatter
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/chef_only/supermatterbread/check_requirements(mob/user, list/collected_requirements) //checks to see if the crafter is a chef
	var/mob/living/carbon/human/H = user
	var/obj/machinery/power/supermatter_crystal/engine/cyrsteel = locate() in range(1, user)
	if(H.mind.assigned_role == "Cook" && cyrsteel)
		return TRUE
	else
		return FALSE

/datum/crafting_recipe/food/chef_only/supermatterbread/post_craft(atom/A, obj/result)
    var/obj/machinery/power/supermatter_crystal/engine/cyrsteel = locate() in range(1, A)
    var/obj/item/reagent_containers/food/snacks/store/bread/supermatter/S = result
    if(!istype(S)) // check that the new variable is actually a supermatter bread object
        return
    if(cyrsteel)
        S.damage_power = cyrsteel.damage
		S.energy_power = crysteel.energy
        qdel(cyrsteel)
        return
    message_admins("Somebody got supermatter bread without deleting the supermatter crystal, somehow, at [ADMIN_JMP(a)]")
