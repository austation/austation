#define COMSIG_STORAGE_INSERTED "storage_inserted"				//from base of /datum/component/storage/handle_item_insertion(): (obj/item/I, mob/M)
#define COMSIG_STORAGE_REMOVED "storage_removed"				//from base of /datum/component/storage/remove_from_storage(): (atom/movable/AM, atom/new_location)

/// called by auxgm add_gas: (gas_id)
#define COMSIG_GLOB_NEW_GAS "!new_gas"

//Xenoartifact signals. These all have the same format in Xenoartifact.DM. It's for a good reason, don't lynch them.
#define XENOA_DEFAULT_SIGNAL "xenoa_default_signal" //Used for xenoartifact signal handlers
#define XENOA_INTERACT "xenoa_interact" //I don't believe there is currently a signal associated with item/interact() 29-4-22
#define XENOA_SIGNAL "xenoa_signal"
