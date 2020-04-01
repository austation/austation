// austation begin -- readds secret extended because we still have it in rotation. changes throughout file
/datum/game_mode/extended
	name = "secret extended"
	config_tag = "secret_extended"
	report_type = "extended"
	false_report_weight = 5
	required_players = 0

	announce_span = "notice"
	announce_text = "Just have fun and enjoy the game!"

	title_icon = "extended_white"

/datum/game_mode/extended/pre_setup()
	return 1

/datum/game_mode/extended/generate_report()
<<<<<<< HEAD
	return "The transmission mostly failed to mention your sector. It is possible that there is nothing in the Syndicate that could threaten your station during this shift."

/datum/game_mode/extended/announced
	name = "extended"
	config_tag = "extended"
	false_report_weight = 0

/datum/game_mode/extended/announced/generate_station_goals()
=======
	return "The transmission mostly failed to mention your sector. It is possible that there is nothing in Pizza Hut that could threaten your station during this shift."
/*
/datum/game_mode/extended/generate_station_goals()
	..()
	return
>>>>>>> b3960579fd... Corporate sponsorship (#1449)
	for(var/T in subtypesof(/datum/station_goal))
		var/datum/station_goal/G = new T
		station_goals += G
		G.on_report()
<<<<<<< HEAD

/datum/game_mode/extended/announced/send_intercept(report = 0)
=======
*/
/datum/game_mode/extended/send_intercept(report = 0)
>>>>>>> b3960579fd... Corporate sponsorship (#1449)
	priority_announce("Thanks to the tireless efforts of our security and intelligence divisions, there are currently no credible threats to [station_name()]. All station construction projects have been authorized. Have a secure shift!", "Security Report", 'sound/ai/commandreport.ogg')
