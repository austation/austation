SUBSYSTEM_DEF(economy)
	name = "Economy"
	wait = 5 MINUTES
	init_order = INIT_ORDER_ECONOMY
	runlevels = RUNLEVEL_GAME
	var/roundstart_paychecks = 5
	var/budget_pool = 25000
	var/list/department_accounts = list(ACCOUNT_CIV = ACCOUNT_CIV_NAME,
										ACCOUNT_ENG = ACCOUNT_ENG_NAME,
										ACCOUNT_SCI = ACCOUNT_SCI_NAME,
										ACCOUNT_MED = ACCOUNT_MED_NAME,
										ACCOUNT_SRV = ACCOUNT_SRV_NAME,
										ACCOUNT_CAR = ACCOUNT_CAR_NAME,
										ACCOUNT_SEC = ACCOUNT_SEC_NAME)
	var/list/generated_accounts = list()
	var/full_ancap = FALSE // Enables extra money charges for things that normally would be free, such as sleepers/cryo/cloning.
							//Take care when enabling, as players will NOT respond well if the economy is set up for low cash flows.
	var/list/bank_accounts = list() //List of normal accounts (not department accounts)
	var/list/dep_cards = list()
	///The modifier multiplied to the value of bounties paid out.
	///Multiplied as they go to all department accounts rather than just cargo.
	var/bounty_modifier = 3

/datum/controller/subsystem/economy/Initialize(timeofday)
	var/budget_to_hand_out = round(budget_pool / department_accounts.len)
	for(var/A in department_accounts)
		new /datum/bank_account/department(A, budget_to_hand_out)
	return ..()

/datum/controller/subsystem/economy/Recover()
	generated_accounts = SSeconomy.generated_accounts
	dep_cards = SSeconomy.dep_cards

/datum/controller/subsystem/economy/fire(resumed = 0)
	for(var/A in bank_accounts)
		var/datum/bank_account/B = A
		B.payday(1)


<<<<<<< HEAD
/datum/controller/subsystem/economy/proc/get_dep_account(dep_id)
	for(var/datum/bank_account/department/D in generated_accounts)
		if(D.department_id == dep_id)
			return D
=======
/// Returns a budget account type, but it will return the united budget account(cargo one) if united budget is active
/datum/controller/subsystem/economy/proc/get_budget_account(dept_id, force=FALSE)
	var/static/datum/bank_account/department/united_budget
	if(!united_budget)
		for(var/datum/bank_account/department/D in budget_accounts)
			if(D.department_id == ACCOUNT_CAR_ID)
				united_budget = D
				break

	var/static/list/budget_id_list = list()
	if(!length(budget_id_list))
		for(var/datum/bank_account/department/D in budget_accounts)
			budget_id_list += list("[D.department_id]" = D)

	var/datum/bank_account/department/target_budget = budget_id_list[dept_id]

	if(!target_budget)
		stack_trace("failed to get a budget account with the given parameter: [dept_id]")
		return budget_id_list[ACCOUNT_CAR_ID] // this will prevent the game being broken

	if(force || target_budget.is_nonstation_account())  // Warning: do not replace this into `is_nonstation_account(target_budget)` or it will loop. We have 2 types of the procs that have the same name for conveniet purpose.
		return target_budget // 'force' is used to grab a correct budget regardless of united budget.
	else if(HAS_TRAIT(SSstation, STATION_TRAIT_UNITED_BUDGET))
		return united_budget
	else
		return target_budget

/// Returns a budget account's bitflag
/datum/controller/subsystem/economy/proc/get_budget_acc_bitflag(dept_id)
	for(var/datum/bank_account/department/each in budget_accounts)
		if(each.department_id == dept_id)
			return each.department_bitflag
	CRASH("the proc has taken wrong dept id or admin did something worse: [dept_id]")

/// Returns multiple budget accounts based on the given bitflag.
/datum/controller/subsystem/economy/proc/get_dept_id_by_bitflag(target_bitflag)
	if(!target_bitflag) // 0 is not valid bitflag
		return FALSE
	target_bitflag = text2num(target_bitflag) // failsafe to replace the string into number
	if(!isnum(target_bitflag))
		CRASH("the proc has taken non-numeral parameter: [target_bitflag]")

	. = list()
	for(var/datum/bank_account/department/D in budget_accounts)
		if(D.department_bitflag & target_bitflag)
			. += D

	if(!length(.))
		CRASH("none of budget accounts has the bitflag: [target_bitflag]")

/// returns if a budget is not bound to the station. a parameter can accept two types: department account object, or budget DEFINE. The proc can accept both.
/datum/controller/subsystem/economy/proc/is_nonstation_account(datum/bank_account/department/D) // takes a bank account type or dep_ID define
	if(!D) // null check first
		return FALSE
	if(!istype(D, /datum/bank_account/department)) // if parameter was given as a dept id, replace it into better type
		D = SSeconomy.get_budget_account(D) // tricky
	if(!istype(D, /datum/bank_account/department)) // if it failed to replacing, return false.
		return FALSE
	return D.nonstation_account
	// this proc is useful when you don't want to declare a variable

/// Check `subsystem\economy.dm`
/datum/bank_account/department/proc/is_nonstation_account() // It's better to read than if(D.nonstation_account)
	return nonstation_account
>>>>>>> 8554076fda (Moving Mining points / Exploration points to bank account (#8370))

/datum/controller/subsystem/economy/proc/distribute_funds(amount)
	var/datum/bank_account/eng = get_dep_account(ACCOUNT_ENG)
	var/datum/bank_account/sec = get_dep_account(ACCOUNT_SEC)
	var/datum/bank_account/med = get_dep_account(ACCOUNT_MED)
	var/datum/bank_account/srv = get_dep_account(ACCOUNT_SRV)
	var/datum/bank_account/sci = get_dep_account(ACCOUNT_SCI)
	var/datum/bank_account/civ = get_dep_account(ACCOUNT_CIV)
	var/datum/bank_account/car = get_dep_account(ACCOUNT_CAR)

	var/departments = 0

	if(eng)
		departments += 2
	if(sec)
		departments += 2
	if(med)
		departments += 2
	if(srv)
		departments += 1
	if(sci)
		departments += 2
	if(civ)
		departments += 1
	if(car)
		departments += 2

	var/parts = round(amount / departments)

	var/engineering_cash = parts * 2
	var/security_cash = parts * 2
	var/medical_cash = parts * 2
	var/service_cash = parts
	var/science_cash = parts * 2
	var/civilian_cash = parts
	var/cargo_cash = parts * 2

	eng?.adjust_money(engineering_cash)
	sec?.adjust_money(security_cash)
	med?.adjust_money(medical_cash)
	srv?.adjust_money(service_cash)
	sci?.adjust_money(science_cash)
	civ?.adjust_money(civilian_cash)
	car?.adjust_money(cargo_cash)
