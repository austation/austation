/obj/item/modular_computer/proc/can_install_component(obj/item/computer_hardware/H, mob/living/user = null)
	if(!H.can_install(src, user))
		return FALSE

	if(H.w_class > max_hardware_size)
		to_chat(user, "<span class='warning'>This component is too large for \the [src]!</span>")
		return FALSE

<<<<<<< HEAD
	if(all_components[H.device_type])
		to_chat(user, "<span class='warning'>This computer's hardware slot is already occupied by \the [all_components[H.device_type]].</span>")
=======
	if(try_install.expansion_hw)
		if(LAZYLEN(expansion_bays) >= max_bays)
			to_chat(user, "<span class='warning'>All of the computer's expansion bays are filled.</span>")
			return FALSE
		if(LAZYACCESS(expansion_bays, try_install.device_type))
			to_chat(user, "<span class='warning'>The computer immediately ejects /the [try_install] and flashes an error: \"Hardware Address Conflict\".</span>")
			return FALSE
	var/obj/item/computer_hardware/existing = all_components[try_install.device_type]
	if(existing && (!istype(existing) || !existing.hotswap))
		to_chat(user, "<span class='warning'>This computer's hardware slot is already occupied by \the [existing].</span>")
>>>>>>> 0bf96243c1 ([MDB IGNORE] Replace PDAs with tablets (#7550))
		return FALSE
	return TRUE


// Installs component.
/obj/item/modular_computer/proc/install_component(obj/item/computer_hardware/H, mob/living/user = null)
	if(!can_install_component(H, user))
		return FALSE

	if(user && !user.transferItemToLoc(H, src))
		return FALSE

<<<<<<< HEAD
	all_components[H.device_type] = H

	to_chat(user, "<span class='notice'>You install \the [H] into \the [src].</span>")
	H.holder = src
	H.forceMove(src)
	H.on_install(src, user)


// Uninstalls component.
/obj/item/modular_computer/proc/uninstall_component(obj/item/computer_hardware/H, mob/living/user = null)
	if(H.holder != src) // Not our component at all.
=======
	var/obj/item/computer_hardware/existing = all_components[install.device_type]
	if(istype(existing) && existing.hotswap)
		if(!uninstall_component(existing, user, TRUE))
			// ABORT!!
			install.forceMove(get_turf(user))
			return FALSE

	if(install.expansion_hw)
		LAZYSET(expansion_bays, install.device_type, install)
	all_components[install.device_type] = install

	to_chat(user, "<span class='notice'>You install \the [install] into \the [src].</span>")
	install.holder = src
	install.forceMove(src)
	install.on_install(src, user)
	return TRUE

/// Uninstalls component.
/obj/item/modular_computer/proc/uninstall_component(obj/item/computer_hardware/yeet, mob/living/user = null, put_in_hands)
	if(yeet.holder != src) // Not our component at all.
>>>>>>> 0bf96243c1 ([MDB IGNORE] Replace PDAs with tablets (#7550))
		return FALSE

	all_components.Remove(H.device_type)

<<<<<<< HEAD
	to_chat(user, "<span class='notice'>You remove \the [H] from \the [src].</span>")

	H.forceMove(get_turf(src))
	H.holder = null
	H.on_remove(src, user)
=======
	if(put_in_hands)
		user.put_in_hands(yeet)
	else
		yeet.forceMove(get_turf(src))
	forget_component(yeet)
	yeet.on_remove(src, user)
>>>>>>> 0bf96243c1 ([MDB IGNORE] Replace PDAs with tablets (#7550))
	if(enabled && !use_power())
		shutdown_computer()
	update_icon()


// Checks all hardware pieces to determine if name matches, if yes, returns the hardware piece, otherwise returns null
/obj/item/modular_computer/proc/find_hardware_by_name(name)
	for(var/i in all_components)
		var/obj/O = all_components[i]
		if(O.name == name)
			return O
	return null
