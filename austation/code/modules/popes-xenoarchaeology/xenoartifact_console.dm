/obj/machinery/computer/xenoartifact_console
    name = "Research and Development Listing Console"
    
    var/datum/xenoartifactseller/sellers[8] //I think this will only create 7, leave it alone if it does
    var/list/tab_index = list("Listings", "Export", "Linking")
    var/current_tab = "Listings"
    var/current_tab_info = "Here you can find listings for various research samples, usually fresh from the field. These sources aren't usually affiliated with Nanotrasen, so instead listing data is sourced from stray bluespace-beacon signals."
    var/budget = 10000
    var/obj/machinery/xenoartifact_inbox/linked_inbox
    var/list/linked_machines = list()
    var/list/sold_artifacts = list()

/obj/machinery/computer/xenoartifact_console/Initialize()
    . = ..()
    for(var/I in 1 to 8)
        sellers[I] = new /datum/xenoartifactseller
        sellers[I].generate()

/obj/machinery/computer/xenoartifact_console/interact(mob/user)
    ui_interact(user, "XenoartifactConsole")
    ..()

/obj/machinery/computer/xenoartifact_console/ui_interact(mob/user, datum/tgui/ui)
    ui = SStgui.try_update_ui(user, src, ui)
    if(!ui)
        ui = new(user, src, "XenoartifactConsole")
        ui.open()

/obj/machinery/computer/xenoartifact_console/ui_data(mob/user)
    var/list/data = list()
    data["seller"] = list()
    for(var/datum/xenoartifactseller/S in sellers)
        data["seller"] += list(list(
            "name" = S.name,
            "dialogue" = S.dialogue,
            "price" = S.price,
            "id" = S.unique_id,
        ))
    data["budget"] = budget
    data["tab_index"] = tab_index
    data["current_tab"] = current_tab
    data["tab_info"] = current_tab_info
    data["linked_machines"] = linked_machines
    data["sold_artifacts"] = sold_artifacts
    return data

/obj/machinery/computer/xenoartifact_console/ui_act(action, params)
    if(..())
        return
    if(action == "sell")
        if(linked_inbox)
            if(!(linked_inbox.sell_artifact(sold_artifacts)))
                say("No item/s on pad")
                return
            say("item/s sold.")
        else if(!(linked_inbox))
            say("Error, no linked hardware.")
        return
    if(action == "link_nearby")
        say("Linking nearby hardware...")
        sleep(1)
        sync_devices()
        return

    for(var/T in tab_index)
        if(action == "set_tab_[T]" && current_tab != T)
            current_tab = T
            switch(T)
                if("Listings")
                    current_tab_info = "Here you can find listings for various research samples, usually fresh from the field. These sources aren't usually affiliated with Nanotrasen, so instead listing data is sourced from stray bluespace-beacon signals."
                if("Export")
                    current_tab_info = "Here you can find buyers for any export your department produces. Anonymously trade and sell explosive slime cores, ancient alien bombs, or just regular bombs."
                if("Linking")
                    current_tab_info = "Link machines to the Listing Console."

        else if(action == "set_tab_[T]" && current_tab == T)
            current_tab = ""
            current_tab_info = ""
    for(var/datum/xenoartifactseller/S in sellers)
        if(action == "purchase_[S.unique_id]" && linked_inbox && budget-S.price >= 0)
            var/obj/item/xenoartifact/X = new(get_turf(linked_inbox.loc), S.difficulty)
            X.price = S.price
            sellers -= S
            say("PURCHASE::COMPLETE\nDEPARTMENT FUNDS::REMAINING: [budget]")
            addtimer(CALLBACK(src, .proc/generate_new_seller), (rand(1,5)*60) SECONDS)
        else if(action == "purchase_[S.unique_id]" && !linked_inbox)
            say("Error. No linked hardware.")
        else if(action == "purchase_[S.unique_id]" && budget-S.price < 0)
            say("Error. Insufficient funds.")

    . = TRUE
    update_icon()

/obj/machinery/computer/xenoartifact_console/proc/generate_new_seller()
    var/datum/xenoartifactseller/S = new
    S.generate()
    sellers += S

/obj/machinery/computer/xenoartifact_console/proc/sync_devices()
    for(var/obj/machinery/xenoartifact_inbox/I in oview(3,src))
        if(I.linked_console != null || I.panel_open)
            return
        if(!(linked_inbox))
            linked_inbox = I
            linked_machines += list(I.name)
            I.linked_console = src
            say("Successfully linked [I].")
            return
    say("Unable to find linkable hadrware.")

/obj/machinery/xenoartifact_inbox
    name = "bluespace straythread pad" //Science words
    desc = "This machine takes advantage of bluespace thread manipulation to highjack in-coming and out-going bluespace signals." //All very sciencey
    icon = 'icons/obj/telescience.dmi'
    icon_state = "qpad-idle"
    var/linked_console

/obj/machinery/xenoartifact_inbox/proc/sell_artifact(list/reciept)
    var/info
    var/final_price = 100
    for(var/obj/I in oview(1,src))
        if(istype(I, /obj/item/xenoartifact)||istype(I, /obj/structure/xenoartifact))
            var/obj/item/xenoartifact/X = I
            final_price = X.modifier*X.price
            if(final_price < 0) //No modulate?
                final_price = 80
            info = "[X.name] sold at [station_time_timestamp()] for [final_price] credits, bought for [X.price]"
        qdel(I)
        if(info != null)
            reciept += list(info)
            return info
        else
            info  = "[I.name] sold at [station_time_timestamp()] for [final_price]. No further information available."
            reciept += list(info)
            return info

/datum/xenoartifactseller //Vendor
    var/name
    var/price
    var/dialogue
    var/unique_id //not really uniuqe
    var/difficulty //Xenoartifact shit, not exactly difficulty

/datum/xenoartifactseller/proc/generate()
    name = "Placeholder"
    price = rand(5,80) * 10
    switch(price)
        if(50 to 300)
            difficulty = BLUESPACE
        if(301 to 500)
            difficulty = PLASMA
        if(501 to 700)
            difficulty = URANIUM
        if(701 to 800)
            difficulty = AUSTRALIUM
    price = price * rand(1.0, 1.3, 1.5) //Measure of error for no particular reason
    dialogue = "lorem ipsum"
    unique_id = "[rand(1,100)][rand(1,100)][rand(1,100)]:[world.time]" //I feel like Ive missed an easier way to do this
