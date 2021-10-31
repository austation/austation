/datum/plant_gene/trait/battery/on_attackby(obj/item/reagent_containers/food/snacks/grown/G, obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = I
		if(C.use(5))
			to_chat(user, "<span class='notice'>You add some cable to [G] and slide it inside the battery encasing.</span>")
			var/obj/item/stock_parts/cell/potato/pocell = new /obj/item/stock_parts/cell/potato(user.loc)
			pocell.icon_state = G.icon_state
			pocell.maxcharge = G.seed.potency * 20

			// The secret of potato supercells!
			var/datum/plant_gene/trait/cell_charge/CG = G.seed.get_gene(/datum/plant_gene/trait/cell_charge)
			if(CG) // 10x charge for deafult cell charge gene - 20 000 with 100 potency.
				pocell.maxcharge *= CG.rate*500
			pocell.charge = pocell.maxcharge
			pocell.name = "[G.name] battery"
			pocell.desc = "A rechargeable plant-based power cell. This one has a rating of [DisplayEnergy(pocell.maxcharge)], and you should not swallow it."

			if(G.reagents.has_reagent(/datum/reagent/toxin/plasma, 2))
				pocell.rigged = TRUE

			qdel(G)
		else
			to_chat(user, "<span class='warning'>You need five lengths of cable to make a [G] battery!</span>")

// Add sepchems back
/datum/plant_gene/trait/noreact
	// Makes plant reagents not react until squashed.
	name = "Separated Chemicals"

/datum/plant_gene/trait/noreact/on_new(obj/item/reagent_containers/food/snacks/grown/G, newloc)
	..()
	ENABLE_BITFIELD(G.reagents.flags, NO_REACT)

/datum/plant_gene/trait/noreact/on_squashreact(obj/item/reagent_containers/food/snacks/grown/G, atom/target)
	DISABLE_BITFIELD(G.reagents.flags, NO_REACT)
	G.reagents.handle_reactions()

/datum/plant_gene/trait/stinging/on_slip(obj/item/reagent_containers/food/snacks/grown/G, atom/target)
	if(!ishuman(target) || !G.reagents || !G.reagents.total_volume)
		return

	var/mob/living/carbon/human/H = target

	if(H.can_inject(target_zone=BODY_ZONE_R_LEG, show_alert=FALSE))
		if(prick(G, H, override=TRUE))
			if(H.ckey != G.fingerprintslast)
				var/turf/T = get_turf(H)
				H.investigate_log("has slipped on plant at [AREACOORD(T)] injecting him with [G.reagents.log_list()]. Last fingerprint: [G.fingerprintslast].", INVESTIGATE_BOTANY)
				log_combat(H, G, "slipped on the", null, "injecting him with [G.reagents.log_list()]. Last fingerprint: [G.fingerprintslast].")

/datum/plant_gene/trait/stinging/prick(obj/item/reagent_containers/food/snacks/grown/G, mob/living/carbon/human/H, mob/user, override = FALSE)
	if((!H.reagents || !H.can_inject(user, show_alert=FALSE)) && !override)
		return FALSE

	var/injecting_amount = max(1, G.seed.potency*0.2) // Minimum of 1, max of 20
	var/fraction = min(injecting_amount/G.reagents.total_volume, 1)
	G.reagents.reaction(H, INJECT, fraction)
	G.reagents.trans_to(H, injecting_amount)
	to_chat(H, "<span class='danger'>You are pricked by [G]!</span>")
	return TRUE
