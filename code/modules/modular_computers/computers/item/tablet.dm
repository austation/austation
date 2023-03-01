/obj/item/modular_computer/tablet  //Its called tablet for theme of 90ies but actually its a "big smartphone" sized
	name = "tablet computer"
	icon = 'icons/obj/modular_tablet.dmi'
	icon_state = "tablet-red"
	icon_state_unpowered = "tablet"
	icon_state_powered = "tablet"
	icon_state_menu = "menu"
	hardware_flag = PROGRAM_TABLET
	max_hardware_size = 1
	w_class = WEIGHT_CLASS_SMALL
	steel_sheet_cost = 1
	slot_flags = ITEM_SLOT_ID | ITEM_SLOT_BELT
	has_light = TRUE //LED flashlight!
	comp_light_luminosity = 2.3 //Same as the PDA
	var/has_variants = TRUE
	var/finish_color = null

/obj/item/modular_computer/tablet/update_icon()
	..()
	if (has_variants)
		if(!finish_color)
			finish_color = pick("red","blue","brown","green","black")
		icon_state = "tablet-[finish_color]"
		icon_state_unpowered = "tablet-[finish_color]"
		icon_state_powered = "tablet-[finish_color]"

/obj/item/modular_computer/tablet/syndicate_contract_uplink
	name = "contractor tablet"
	icon = 'icons/obj/contractor_tablet.dmi'
	icon_state = "tablet"
	icon_state_unpowered = "tablet"
	icon_state_powered = "tablet"
	icon_state_menu = "assign"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_ID | ITEM_SLOT_BELT
	comp_light_luminosity = 6.3
	has_variants = FALSE

/// Given to Nuke Ops members.
/obj/item/modular_computer/tablet/nukeops
	icon_state = "tablet-syndicate"
	icon_state_powered = "tablet-syndicate"
	icon_state_unpowered = "tablet-syndicate"
	comp_light_luminosity = 6.3
	has_variants = FALSE
	device_theme = "syndicate"

/obj/item/modular_computer/tablet/nukeops/emag_act(mob/user)
	if(!enabled)
		to_chat(user, "<span class='warning'>You'd need to turn the [src] on first.</span>")
		return FALSE
<<<<<<< HEAD
	to_chat(user, "<span class='notice'>You swipe \the [src]. It's screen briefly shows a message reading \"MEMORY CODE INJECTION DETECTED AND SUCCESSFULLY QUARANTINED\".</span>")
	return FALSE
=======
	var/mob/living/silicon/robot/robo = borgo
	robo.toggle_headlamp()
	return TRUE

//Makes the flashlight color setting affect the borg rather than the tablet
/obj/item/modular_computer/tablet/integrated/set_flashlight_color(color)
	if(!borgo || QDELETED(borgo) || !color || !iscyborg(borgo))
		return FALSE
	var/mob/living/silicon/robot/robo = borgo
	robo.lamp_color = color
	robo.toggle_headlamp(FALSE, TRUE)
	return TRUE

/obj/item/modular_computer/tablet/integrated/alert_call(datum/computer_file/program/caller, alerttext, sound = 'sound/machines/twobeep_high.ogg')
	if(!caller || !caller.alert_able || caller.alert_silenced || !alerttext) //Yeah, we're checking alert_able. No, you don't get to make alerts that the user can't silence.
		return
	if(HAS_TRAIT(SSstation, STATION_TRAIT_PDA_GLITCHED))
		sound = pick('sound/machines/twobeep_voice1.ogg', 'sound/machines/twobeep_voice2.ogg')
	borgo.playsound_local(src, sound, 50, TRUE)
	to_chat(borgo, "<span class='notice'>The [src] displays a [caller.filedesc] notification: [alerttext]</span>")

/obj/item/modular_computer/tablet/integrated/ui_state(mob/user)
	return GLOB.reverse_contained_state

/obj/item/modular_computer/tablet/integrated/syndicate
	icon_state = "tablet-silicon-syndicate"
	icon_state_unpowered = "tablet-silicon-syndicate"
	icon_state_powered = "tablet-silicon-syndicate"
	icon_state_menu = "command-syndicate"
	device_theme = THEME_SYNDICATE
	theme_locked = TRUE


/obj/item/modular_computer/tablet/integrated/syndicate/Initialize()
	. = ..()
	if(iscyborg(borgo))
		var/mob/living/silicon/robot/robo = borgo
		robo.lamp_color = COLOR_RED //Syndicate likes it red

// Round start tablets

/obj/item/modular_computer/tablet/pda
	icon = 'icons/obj/pda.dmi'
	icon_state = "pda"
	worn_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'

	bypass_state = TRUE
	can_store_pai = TRUE

	var/default_disk = 0
	/// If the PDA has been picked up / equipped before. This is used to set the user's preference background color / theme.
	var/equipped = FALSE

/obj/item/modular_computer/tablet/pda/send_sound()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_PDA_GLITCHED))
		playsound(src, pick('sound/machines/twobeep_voice1.ogg', 'sound/machines/twobeep_voice2.ogg'), 15, TRUE)
	else
		..()

/obj/item/modular_computer/tablet/pda/send_select_sound()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_PDA_GLITCHED))
		playsound(src, pick('sound/machines/twobeep_voice1.ogg', 'sound/machines/twobeep_voice2.ogg'), 15, TRUE)
	else
		..()

/obj/item/modular_computer/tablet/pda/equipped(mob/user, slot)
	. = ..()
	if(equipped || !user.client)
		return
	equipped = TRUE
	if(!user.client.prefs)
		return
	var/pref_theme = user.client.prefs.pda_theme
	if(!theme_locked && !ignore_theme_pref)
		for(var/key in allowed_themes) // i am going to scream. DM lists stop sucking please
			if(allowed_themes[key] == pref_theme)
				device_theme = pref_theme
				break
	classic_color = user.client.prefs.pda_color

/obj/item/modular_computer/tablet/pda/update_icon()
	..()
	var/init_icon = initial(icon)
	if(!init_icon)
		return
	var/obj/item/computer_hardware/card_slot/card = all_components[MC_CARD]
	if(card)
		if(card.stored_card)
			add_overlay(mutable_appearance(init_icon, "id_overlay"))
	if(inserted_item)
		add_overlay(mutable_appearance(init_icon, "insert_overlay"))
	if(light_on)
		add_overlay(mutable_appearance(init_icon, "light_overlay"))


/obj/item/modular_computer/tablet/pda/attack_ai(mob/user)
	to_chat(user, "<span class='notice'>It doesn't feel right to snoop around like that...</span>")
	return // we don't want ais or cyborgs using a private role tablet

/obj/item/modular_computer/tablet/pda/Initialize(mapload)
	. = ..()
	install_component(new /obj/item/computer_hardware/hard_drive/small/pda)
	install_component(new /obj/item/computer_hardware/processor_unit/small)
	install_component(new /obj/item/computer_hardware/battery(src, /obj/item/stock_parts/cell/computer))
	install_component(new /obj/item/computer_hardware/network_card)
	install_component(new /obj/item/computer_hardware/card_slot)
	install_component(new /obj/item/computer_hardware/identifier)
	install_component(new /obj/item/computer_hardware/sensorpackage)

	if(default_disk)
		var/obj/item/computer_hardware/hard_drive/portable/disk = new default_disk(src)
		install_component(disk)

	if(insert_type)
		inserted_item = new insert_type(src)
		// show the inserted item
		update_icon()
>>>>>>> 8c83f65873 (PDA Theme Preference (#8552))
