/obj/machinery/atmospherics/components/unary/thermomachine/change_piping_layer_multitool(mob/user, obj/item/I)
	if(!..())
		return FALSE
	SetInitDirections()
	var/obj/machinery/atmospherics/node = nodes[1]
	if(node)
		node.disconnect(src)
		nodes[1] = null
	nullifyPipenet(parents[1])

	atmosinit()
	node = nodes[1]
	if(node)
		node.atmosinit()
		node.addMember(src)
	build_network()
	return TRUE
