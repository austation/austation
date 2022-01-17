GLOBAL_REAL_VAR(server_inactive) // we can't wait for global subsystem init, we need this NOW, since it needs to be handled in subsystem pre-init
GLOBAL_LIST_INIT(ringlist, list(RING_DISABLED_NAME, RING_CASUAL_NAME, RING_ENGAGEMENT_NAME, RING_WEDDING_NAME, RING_AUSTRALIUM_NAME))
