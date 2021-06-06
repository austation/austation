/obj/item/reagent_containers/hypospray/medipen/custompen
	name = "Disposable Autopen"
	desc = "A medipen designed to be filled with chemicals, single use item. Can be loaded directly with a beaker."
	icon = 'austation/icons/obj/syringe.dmi'
	icon_state = "custompen"
	item_state = "morphen"
	var/apply_type = INJECT
	var/self_delay = 0
	reagent_flags = OPENCONTAINER
	ignore_flags = 1 // it bypasses hardsuits
	volume = 25
	amount_per_transfer_from_this = 25

	list_reagents = list()

/obj/item/reagent_containers/hypospray/medipen/custompen/attack_self(mob/user)
	return
/obj/item/reagent_containers/hypospray/medipen/custompen/attack(mob/M, mob/user, def_zone)
	if(iscyborg(M)) // no more trying to inject cyborgs
		return
	if(reagents.total_volume == 0) // no more wasting empty pens
		to_chat(M, "<span class='notice'>Would be a waste to use an empty pen.</span>")
		return
	if(M == user)
		if(self_delay)
			if(!do_mob(user, M, self_delay))
				return FALSE
		to_chat(M, "<span class='notice'>You inject yourself with the [src].</span>")
		reagents.reaction(M, apply_type)
		reagents.trans_to(M, reagents.total_volume, transfered_by = user)
		reagents.maximum_volume = 0

	else
		M.visible_message("<span class='danger'>[user] attempts to inject [M] with the [src].</span>", \
							"<span class='userdanger'>[user] attempts to inject you with the [src].</span>")
		if(!do_mob(user, M))
			return FALSE
		M.visible_message("<span class='danger'>[user] injects [M] with the [src].</span>", \
							"<span class='userdanger'>[user] injects you with the [src].</span>")
		reagents.reaction(M, apply_type)
		reagents.trans_to(M, reagents.total_volume, transfered_by = user)
		reagents.maximum_volume = 0

/obj/item/reagent_containers/hypospray/medipen/custompen/bluespace
	name = "Bluespace Disposable Autopen"
	desc = "A bluespace version of the disposable medipen designed to be filled with chemicals, single use item. This one has a much larger capcity than the previous one."
	icon_state = "bscustompen"
	item_state = "morphen"
	reagent_flags = OPENCONTAINER
	ignore_flags = 1
	volume = 40
	amount_per_transfer_from_this = 40

	list_reagents = list()
