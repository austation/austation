PROCESSING_SUBSYSTEM_DEF(networks)
	name = "Networks"
	priority = FIRE_PRIORITY_NETWORKS
	wait = 1
	stat_tag = "NET"
	flags = SS_KEEP_TIMING
	init_order = INIT_ORDER_NETWORKS
	var/datum/ntnet/station/station_network
	var/assignment_hardware_id = HID_RESTRICTED_END
	var/list/networks_by_id = list()				//id = network
	var/list/interfaces_by_id = list()				//hardware id = component interface
	var/resolve_collisions = TRUE

/datum/controller/subsystem/processing/networks/Initialize()
	station_network = new
	station_network.register_map_supremecy()
	. = ..()

<<<<<<< HEAD
/datum/controller/subsystem/processing/networks/proc/register_network(datum/ntnet/network)
	if(!networks_by_id[network.network_id])
		networks_by_id[network.network_id] = network
		return TRUE
=======
	/// List of networks using their fully qualified network name.  Used for quick lookups
	/// of networks for sending packets
	var/list/networks = list()
	/// List of the root networks starting at their root names.  Used to find and/or build
	/// network tress
	var/list/root_networks = list()



	// Why not list?  Because its a Copy() every time we add a packet, and thats stupid.
	var/datum/netdata/first = null // start of the queue.  Pulled off in fire.
	var/datum/netdata/last = null	// end of the queue.  pushed on by transmit
	var/packet_count = 0
	// packet stats
	var/count_broadcasts_packets = 0 // count of broadcast packets sent
	var/count_failed_packets = 0 	// count of message fails
	var/count_good_packets = 0
	// Logs moved here
	// Amount of logs the system tries to keep in memory. Keep below 999 to prevent byond from acting weirdly.
	// High values make displaying logs much laggier.
	var/setting_maxlogcount = 100
	var/list/logs = list()

	/// Random name search to make sure we have unique names.
	/// DO NOT REMOVE NAMES HERE UNLESS YOU KNOW WHAT YOURE DOING
	var/list/used_names = list()


/// You shouldn't need to do this.  But mapping is async and there is no guarantee that Initialize
/// will run before these networks are dynamically created.  So its here.
/datum/controller/subsystem/networks/PreInit()
	/// Limbo network needs to be made at boot up for all error devices
	new/datum/ntnet(LIMBO_NETWORK_ROOT)
	station_network = new(STATION_NETWORK_ROOT)
	syndie_network = new(SYNDICATE_NETWORK_ROOT)
	/// As well as the station network incase something funny goes during startup
	new/datum/ntnet(CENTCOM_NETWORK_ROOT)


/datum/controller/subsystem/networks/stat_entry(msg)
	msg = "NET: QUEUE([packet_count]) FAILS([count_failed_packets]) BROADCAST([count_broadcasts_packets])"
	return ..()

/datum/controller/subsystem/networks/Initialize()
	station_network.register_map_supremecy() // sigh
	assign_areas_root_ids(GLOB.sortedAreas) // setup area names before Initialize
	station_network.build_software_lists()
	syndie_network.build_software_lists()

	// At round start, fix the network_id's so the station root is on them
	initialized = TRUE
	// Now when the objects Initialize they will join the right network
	return ..()

/*
 * Process incoming queued packet and return NAK/ACK signals
 *
 * This should only be called when you want the target object to process the NAK/ACK signal, usually
 * during fire.  At this point data.receiver_id has already been converted if it was a broadcast but
 * is undefined in this function.
 * Arguments:
 * * receiver_id - text hardware id for the target device
 * * data - packet to be sent
 */

/datum/controller/subsystem/networks/proc/_process_packet(receiver_id, datum/netdata/data)
	/// Used only for sending NAK/ACK and error reply's
	var/datum/component/ntnet_interface/sending_interface = interfaces_by_hardware_id[data.sender_id]

	/// Check if the network_id is valid and if not send an error and return
	var/datum/ntnet/target_network = networks[data.network_id]
	if(!target_network)
		count_failed_packets++
		add_log("Bad target network '[data.network_id]'", null, data.sender_id)
		if(!QDELETED(sending_interface))
			SEND_SIGNAL(sending_interface.parent, COMSIG_COMPONENT_NTNET_NAK, data , NETWORK_ERROR_BAD_NETWORK)
		return

	/// Check if the receiver_id is in the network.  If not send an error and return
	var/datum/component/ntnet_interface/target_interface = target_network.root_devices[receiver_id]
	if(QDELETED(target_interface))
		count_failed_packets++
		add_log("Bad target device '[receiver_id]'", target_network, data.sender_id)
		if(!QDELETED(sending_interface))
			SEND_SIGNAL(sending_interface.parent, COMSIG_COMPONENT_NTNET_NAK, data,  NETWORK_ERROR_BAD_RECEIVER_ID)
		return

	// Check if we care about permissions.  If we do check if we are allowed the message to be processed
	if(data.passkey) // got to check permissions
		var/obj/O = target_interface.parent
		if(O)
			if(!O.check_access_ntnet(data.passkey))
				count_failed_packets++
				add_log("Access denied to ([receiver_id]) from ([data.network_id])", target_network, data.sender_id)
				if(!QDELETED(sending_interface))
					SEND_SIGNAL(sending_interface.parent, COMSIG_COMPONENT_NTNET_NAK, data, NETWORK_ERROR_UNAUTHORIZED)
				return
		else
			add_log("A access key message was sent to a non-device", target_network, data.sender_id)
			if(!QDELETED(sending_interface))
				SEND_SIGNAL(sending_interface.parent, COMSIG_COMPONENT_NTNET_NAK, data, NETWORK_ERROR_UNAUTHORIZED)


	SEND_SIGNAL(target_interface.parent, COMSIG_COMPONENT_NTNET_RECEIVE, data)
	// All is good, send the packet then send an ACK to the sender
	if(!QDELETED(sending_interface))
		SEND_SIGNAL(sending_interface.parent, COMSIG_COMPONENT_NTNET_ACK, data)
	count_good_packets++

/// Helper define to make sure we pop the packet and qdel it
#define POP_PACKET(CURRENT) first = CURRENT.next;  packet_count--; if(!first) { last = null; packet_count = 0; }; qdel(CURRENT);

/datum/controller/subsystem/networks/fire(resumed = 0)
	var/datum/netdata/current
	var/datum/component/ntnet_interface/target_interface
	while(first)
		current = first
		/// Check if we are a list.  If so process the list
		if(islist(current.receiver_id)) // are we a broadcast list
			var/list/receivers = current.receiver_id
			var/receiver_id = receivers[receivers.len--] // pop it
			_process_packet(receiver_id, current)
			if(receivers.len == 0) // pop it if done
				count_broadcasts_packets++
				POP_PACKET(current)
		else // else set up a broadcast or send a single targete
			// check if we are sending to a network or to a single target
			target_interface = interfaces_by_hardware_id[current.receiver_id]
			if(target_interface) // a single sender id
				_process_packet(current.receiver_id, current) // single target
				POP_PACKET(current)
			else // ok so lets find the network to send it too
				var/datum/ntnet/net = networks[current.network_id]		// get the sending network
				net = net?.networks[current.receiver_id]				// find the target network to broadcast
				if(net)		// we found it
					current.receiver_id = net.collect_interfaces()		// make a list of all the sending targets
				else
					// We got an error, the network is bad so send a NAK
					target_interface = interfaces_by_hardware_id[current.sender_id]
					if(!QDELETED(target_interface))
						SEND_SIGNAL(target_interface.parent, COMSIG_COMPONENT_NTNET_NAK, current , NETWORK_ERROR_BAD_NETWORK)
					POP_PACKET(current) // and get rid of it
		if (MC_TICK_CHECK)
			return

#undef POP_PACKET

/*
 * Main function to queue a packet.  As long as we have valid receiver_id and network_id we will take it
 *
 * Main queuing function for any message sent.  if the data.receiver_id is null, then it will be broadcasted
 * error checking is only done during the process this just throws it on the queue.
 * Arguments:
 * * data - packet to be sent
 */
/datum/controller/subsystem/networks/proc/transmit(datum/netdata/data)
	data.next = null // sanity check

	if(!last)
		first = last = data
	else
		last.next = data
		last = data
	packet_count++
	// We do error checking when the packet is sent
	return NETWORK_ERROR_OK


/datum/controller/subsystem/networks/proc/check_relay_operation(zlevel=0)	//can be expanded later but right now it's true/false.
	for(var/i in relays)
		var/obj/machinery/ntnet_relay/n = i
		if(zlevel && n.get_virtual_z_level() != zlevel)
			continue
		if(n.is_operational)
			return TRUE
>>>>>>> b3ccea2443 ([Port] Refactors machine_stat and is_processing() to process on demand + Changes obj_break on machines to use parent calls (#7617))
	return FALSE

/datum/controller/subsystem/processing/networks/proc/unregister_network(datum/ntnet/network)
	networks_by_id -= network.network_id
	return TRUE

/datum/controller/subsystem/processing/networks/proc/register_interface(datum/component/ntnet_interface/D)
	if(!interfaces_by_id[D.hardware_id])
		interfaces_by_id[D.hardware_id] = D
		return TRUE
	return FALSE

/datum/controller/subsystem/processing/networks/proc/unregister_interface(datum/component/ntnet_interface/D)
	interfaces_by_id -= D.hardware_id
	return TRUE

/datum/controller/subsystem/processing/networks/proc/get_next_HID()
	var/string = "[num2text(assignment_hardware_id++, 12)]"
	return make_address(string)

/datum/controller/subsystem/processing/networks/proc/make_address(string)
	if(!string)
		return resolve_collisions? make_address("[num2text(rand(HID_RESTRICTED_END, 999999999), 12)]"):null
	var/hex = rustg_hash_string(RUSTG_HASH_MD5, string)
	if(!hex)
		return		//errored
	. = "[copytext_char(hex, 1, 9)]"		//16 ^ 8 possibilities I think.
	if(interfaces_by_id[.])
		return resolve_collisions? make_address("[num2text(rand(HID_RESTRICTED_END, 999999999), 12)]"):null
