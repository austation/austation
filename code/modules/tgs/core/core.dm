/world/TgsNew(datum/tgs_event_handler/event_handler, minimum_required_security_level = TGS_SECURITY_ULTRASAFE)
	log_runtime("Now in TgsNew Proc")
	
	var/current_api = TGS_READ_GLOBAL(tgs)
	if(current_api)
		TGS_ERROR_LOG("TgsNew(): TGS API datum already set ([current_api])! Was TgsNew() called more than once?")
		log_runtime("API Already active")
		return

#ifdef TGS_V3_API
	minimum_required_security_level = TGS_SECURITY_TRUSTED
	log_runtime("Min security level set to trusted")
#endif
	var/raw_parameter = world.params[TGS_VERSION_PARAMETER]
	if(!raw_parameter)
		log_runtime("TGS version param not set")
		return

	var/datum/tgs_version/version = new(raw_parameter)

	log_runtime(raw_parameter)

	if(!version.Valid(FALSE))
		TGS_ERROR_LOG("Failed to validate TGS version parameter: [raw_parameter]!")
		log_runtime("Invalid TGS Version param")
		return

	var/api_datum
	switch(version.suite)
		if(3)
#ifndef TGS_V3_API
			TGS_ERROR_LOG("Detected V3 API but TGS_V3_API isn't defined!")
			log_runtime("TGS 3 detected but no V3 define set")
#else
			switch(version.major)
				if(2)
					api_datum = /datum/tgs_api/v3210
					log_runtime("Selecting V3 API")
#endif
		if(4)
			switch(version.major)
				if(0)
					api_datum = /datum/tgs_api/v4
					log_runtime("Selecting V4 API")

	var/datum/tgs_version/max_api_version = TgsMaximumAPIVersion();
	if(version.suite != null && version.major != null && version.minor != null && version.patch != null && version.deprefixed_parameter > max_api_version.deprefixed_parameter)
		TGS_ERROR_LOG("Detected unknown API version! Defaulting to latest. Update the DMAPI to fix this problem.")
		log_runtime("Unknown API version. Selecting latest")
		api_datum = /datum/tgs_api/latest

	if(!api_datum)
		TGS_ERROR_LOG("Found unsupported API version: [raw_parameter]. If this is a valid version please report this, backporting is done on demand.")
		return

	TGS_INFO_LOG("Activating API for version [version.deprefixed_parameter]")
	log_runtime("Activating API.")
	var/datum/tgs_api/new_api = new api_datum(version)

	log_runtime("Writing API to tgs global")
	TGS_WRITE_GLOBAL(tgs, new_api)

	var/result = new_api.OnWorldNew(event_handler, minimum_required_security_level)
	if(!result || result == TGS_UNIMPLEMENTED)
		TGS_WRITE_GLOBAL(tgs, null)
		TGS_ERROR_LOG("Failed to activate API!")
		log_runtime("API Failed to activate! Clearing TGS global")

/world/TgsMaximumAPIVersion()
	return new /datum/tgs_version("4.0.x.x")

/world/TgsMinimumAPIVersion()
	return new /datum/tgs_version("3.2.0.0")

/world/TgsInitializationComplete()
	var/datum/tgs_api/api = TGS_READ_GLOBAL(tgs)
	if(api)
		api.OnInitializationComplete()

/world/proc/TgsTopic(T)
	var/datum/tgs_api/api = TGS_READ_GLOBAL(tgs)
	if(api)
		var/result = api.OnTopic(T)
		if(result != TGS_UNIMPLEMENTED)
			return result

/world/TgsRevision()
	var/datum/tgs_api/api = TGS_READ_GLOBAL(tgs)
	if(api)
		var/result = api.Revision()
		if(result != TGS_UNIMPLEMENTED)
			return result

/world/TgsReboot()
	var/datum/tgs_api/api = TGS_READ_GLOBAL(tgs)
	if(api)
		api.OnReboot()

/world/TgsAvailable()
	return TGS_READ_GLOBAL(tgs) != null

/world/TgsVersion()
	var/datum/tgs_api/api = TGS_READ_GLOBAL(tgs)
	if(api)
		return api.version

/world/TgsInstanceName()
	var/datum/tgs_api/api = TGS_READ_GLOBAL(tgs)
	if(api)
		var/result = api.InstanceName()
		if(result != TGS_UNIMPLEMENTED)
			return result

/world/TgsTestMerges()
	var/datum/tgs_api/api = TGS_READ_GLOBAL(tgs)
	if(api)
		var/result = api.TestMerges()
		if(result != TGS_UNIMPLEMENTED)
			return result
	return list()

/world/TgsEndProcess()
	var/datum/tgs_api/api = TGS_READ_GLOBAL(tgs)
	if(api)
		api.EndProcess()

/world/TgsChatChannelInfo()
	var/datum/tgs_api/api = TGS_READ_GLOBAL(tgs)
	if(api)
		var/result = api.ChatChannelInfo()
		if(result != TGS_UNIMPLEMENTED)
			return result
	return list()

/world/TgsChatBroadcast(message, list/channels)
	var/datum/tgs_api/api = TGS_READ_GLOBAL(tgs)
	if(api)
		api.ChatBroadcast(message, channels)

/world/TgsTargetedChatBroadcast(message, admin_only)
	var/datum/tgs_api/api = TGS_READ_GLOBAL(tgs)
	if(api)
		api.ChatTargetedBroadcast(message, admin_only)

/world/TgsChatPrivateMessage(message, datum/tgs_chat_user/user)
	var/datum/tgs_api/api = TGS_READ_GLOBAL(tgs)
	if(api)
		api.ChatPrivateMessage(message, user)

/world/TgsSecurityLevel()
	var/datum/tgs_api/api = TGS_READ_GLOBAL(tgs)
	if(api)
		api.SecurityLevel()

/*
The MIT License

Copyright (c) 2017 Jordan Brown

Permission is hereby granted, free of charge,
to any person obtaining a copy of this software and
associated documentation files (the "Software"), to
deal in the Software without restriction, including
without limitation the rights to use, copy, modify,
merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom
the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice
shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
