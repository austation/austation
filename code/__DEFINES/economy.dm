#define STARTING_PAYCHECKS 5

#define PAYCHECK_ASSISTANT 10
#define PAYCHECK_MINIMAL 10
#define PAYCHECK_EASY 15
#define PAYCHECK_MEDIUM 40
#define PAYCHECK_HARD 70
#define PAYCHECK_COMMAND 100
#define PAYCHECK_VIP 250

#define PAYCHECK_WELFARE 20 //NEETbucks

#define ACCOUNT_CIV "CIV"
#define ACCOUNT_CIV_NAME "Civil Budget"
#define ACCOUNT_ENG "ENG"
#define ACCOUNT_ENG_NAME "Engineering Budget"
#define ACCOUNT_SCI "SCI"
#define ACCOUNT_SCI_NAME "Scientific Budget"
#define ACCOUNT_MED "MED"
#define ACCOUNT_MED_NAME "Medical Budget"
#define ACCOUNT_SRV "SRV"
#define ACCOUNT_SRV_NAME "Service Budget"
#define ACCOUNT_CAR "CAR"
#define ACCOUNT_CAR_NAME "Cargo Budget"
#define ACCOUNT_SEC "SEC"
#define ACCOUNT_SEC_NAME "Defense Budget"
<<<<<<< HEAD

#define NO_FREEBIES "commies go home"
=======
#define ACCOUNT_COM_ID "Command"
#define ACCOUNT_COM_NAME "Nanotrasen Commands' Quality ＆ Appearance Maintenance Budget"
#define ACCOUNT_VIP_ID "VIP"
#define ACCOUNT_VIP_NAME "Nanotrasen VIP Expense Account Budget"
#define ACCOUNT_NEET_ID "Welfare"
#define ACCOUNT_NEET_NAME "Space Nations Welfare"
#define ACCOUNT_GOLEM_ID "Golem"
#define ACCOUNT_GOLEM_NAME "Shared Mining Account"


#define ACCOUNT_ALL_NAME "United Station Budget" // for negative station trait - united budget

// If a vending machine matches its department flag with your bank account's, it gets free.
#define NO_FREEBIES 0 // used for a vendor selling nothing for free
#define ACCOUNT_COM_BITFLAG (1<<0) // for Commander only vendor items (i.e. HoP cartridge vendor)
#define ACCOUNT_CIV_BITFLAG (1<<1)
#define ACCOUNT_SRV_BITFLAG (1<<2)
#define ACCOUNT_CAR_BITFLAG (1<<3)
#define ACCOUNT_SCI_BITFLAG (1<<4)
#define ACCOUNT_ENG_BITFLAG (1<<5)
#define ACCOUNT_MED_BITFLAG (1<<6)
#define ACCOUNT_SEC_BITFLAG (1<<7)
#define ACCOUNT_VIP_BITFLAG (1<<8) // for VIP only vendor items. currently not used.
// this should use the same bitflag values in `\_DEFINES\jobs.dm` to match.
// It's true that bitflags shouldn't be separated in two DEFINES if these are same, but just in case the system can be devided, it's remained separated.

/// How much mail the Economy SS will create per minute, regardless of firing time.
#define MAX_MAIL_PER_MINUTE 3
/// Probability of using letters of envelope sprites on all letters.
#define FULL_CRATE_LETTER_ODDS 70


/// used for custom_currency
#define ACCOUNT_CURRENCY_MINING "mining points"
#define ACCOUNT_CURRENCY_EXPLO "exploration points"
>>>>>>> 8554076fda (Moving Mining points / Exploration points to bank account (#8370))
