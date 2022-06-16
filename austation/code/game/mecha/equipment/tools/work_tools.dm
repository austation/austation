// Doesn't work right now due to everything being a clusterfuck of code. Dear god, what did I do to deserve this?
/obj/item/mecha_parts/mecha_equipment/equipment_remote
	name = "Equipment Remote. The be-all end-all of remote control technology."
	desc = "Equipment for engineering exosuits. Allows remote control of up to 3 engineering devices, such as pumps, APCs, air alarms, and so forth."
	icon_state = "mecha_clamp"
	equip_cooldown = 5
	energy_drain = 0.1
	harmful = FALSE
	var/list/connectedDevices = list()

/obj/item/mecha_parts/mecha_equipment/equipment_remote/can_attach(obj/mecha/M) // Worker mech only. No pansie coombat mechs allowed ):<
	if(..())
		if(istype(M, /obj/mecha/working))
			return 1
	return 0

/obj/item/mecha_parts/mecha_equipment/equipment_remote/action(atom/target)

/obj/item/mecha_parts/mecha_equipment/equipment_remote/get_equip_info()
	var/SB = "[..()]"
	for(var/I in connectedDevices) // Is now a good time to mention I have no idea how for loops work in BYOND?
		SB += "<a href='?src=[REF(src)];menu=[I];option=open'>[connectedDevices[I]]</a><a href='?src=[REF(src)];menu=[I];option=close'>\[X\]</a>"
	return SB

/* /obj/item/mecha_parts/mecha_equipment/equipment_remote/Topic(href,href_list)
	..()
	if(href_list["menu"])
		var/device = connectedDevices[href_list["menu"]]
		if(href_list["option"] == "close")
			connectedDevices[href_list["menu"]] = null
		else if(href_list["option"] == "open")
			// device.ui_interact(chassis.occupant)
	return*/


// Doesn't work right now due to the fact that everything uses a different system to check whether a tool is used on them or not. Feel free to come back and take another look at this if you think you have what it takes.
/obj/item/mecha_parts/mecha_equipment/toolset
	name = "mounted toolset"
	desc = "Equipment for engineering exosuits. Holds a variety of tools for construction."
	icon_state = "mecha_clamp"
	equip_cooldown = 5 // If you can use tools multiple times at the same time, why not here?
	energy_drain = 0.1 // Called every tick a tool is being used on, so keep it low
	usesound = 'sound/items/jaws_pry.ogg'
	toolspeed = 0.5
	harmful = FALSE
	var/list/available_modes = list(
		 TOOL_CROWBAR = list("name" = "Hydraulic Crowbar", "toolspeed" = 0.5, "energy_drain" = 1, "usesound" = 'sound/items/jaws_pry.ogg'),
		 TOOL_SCREWDRIVER = list("name" = "Powered Screwdriver", "toolspeed" = 0.5, "energy_drain" = 1, "usesound" = 'sound/items/drill_use.ogg'),
		 TOOL_WELDINGTOOL = list("name" = "Welding Tool ", "toolspeed" = 0.5, "energy_drain" = 1, "usesound" = 'sound/items/welder.ogg'),
		 TOOL_WIRECUTTERS = list("name" = "Cable Cutters", "toolspeed" = 0.5, "energy_drain" = 1, "usesound" = 'sound/items/wirecutter.ogg'),
		 TOOL_WRENCH = list("name" = "Powered Wrench", "toolspeed" = 0.5, "energy_drain" = 1, "usesound" = 'sound/items/ratchet.ogg')
	)

/obj/item/mecha_parts/mecha_equipment/toolset/attach(obj/mecha/M as obj)
	..()
	tool_behaviour = TOOL_CROWBAR
	return

/obj/item/mecha_parts/mecha_equipment/toolset/detach(atom/moveto = null)
	..()
	tool_behaviour = null

/obj/item/mecha_parts/mecha_equipment/toolset/can_attach(obj/mecha/M) // Worker mech only. No pansie coombat mechs allowed ):<
	if(..())
		if(istype(M, /obj/mecha/working))
			return 1
	return 0

/obj/item/mecha_parts/mecha_equipment/toolset/Topic(href,href_list)
	..()
	if(href_list["mode"]) // For a good while I was intending to use a switch case to have different modes, but this seems more natural and allows further development.
		var/list/mode = available_modes[href_list["mode"]]
		chassis.occupant.visible_message("<span class='notice'>You change the [src] to [mode["name"]]</span>", \
						"<span class='notice'>[chassis]'s [src] spins to reveal [mode["name"]]</span>")
		tool_behaviour = href_list["mode"]
		usesound = mode["usesound"]
		energy_drain = mode["energy_drain"]
		toolspeed = mode["toolspeed"]
	return

/obj/item/mecha_parts/mecha_equipment/toolset/get_equip_info()
	var/SB = "[..()]"
	for(var/K in available_modes) // Is now a good time to mention I have no idea how for loops work in BYOND?
		SB += "<br><a href='?src=[REF(src)];mode=[K]' style='color:[tool_behaviour == K ? "#0f0" : "#f00"];'>[available_modes[K]["name"]]</a>"
	return SB

/obj/item/mecha_parts/mecha_equipment/toolset/action(atom/target)
	if(target == chassis)
		occupant_message("<span class='notice'>[src] can't quite bend enough to reach the chassis of [chassis]!</span>")
		return
	log_message("Attempted [tool_behaviour] on [target]", LOG_MECHA)
	target.tool_act(chassis.occupant, src, tool_behaviour)

/obj/item/mecha_parts/mecha_equipment/toolset/use(used)
	chassis.use_power(energy_drain)

/obj/item/mecha_parts/mecha_equipment/toolset/tool_use_check(mob/living/user, amount)
	if(!chassis)
		return 0
	if(energy_drain && !chassis.has_charge(energy_drain))
		return 0
	if(chassis.is_currently_ejecting)
		return 0
	if(chassis.equipment_disabled)
		to_chat(chassis.occupant, "<span=warn>Error -- Equipment control unit is unresponsive.</span>")
		return 0
	return 1
