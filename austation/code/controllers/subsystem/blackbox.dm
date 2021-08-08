/datum/controller/subsystem/blackbox/proc/LogAhelp(ticket, action, message, recipient, sender)
	if(!SSdbcore.Connect())
		return

	var/datum/DBQuery/query_log_ahelp = SSdbcore.NewQuery({"
		INSERT INTO [format_table_name("ticket")] (ticket, action, message, recipient, sender, server_ip, server_port, round_id, timestamp)
		VALUES (:ticket, :action, :message, :recipient, :sender, INET_ATON(:server_ip), :server_port, :round_id, :time)
	"}, list("ticket" = ticket, "action" = action, "message" = message, "recipient" = recipient, "sender" = sender, "server_ip" = world.internet_address || "0", "server_port" = world.port, "round_id" = GLOB.round_id, "time" = SQLtime()))
	query_log_ahelp.Execute()
	qdel(query_log_ahelp)
