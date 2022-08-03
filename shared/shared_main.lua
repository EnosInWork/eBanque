Config = {
    
    Shared = "esx:getSharedObject",
    JobName = "banquier",
    SocietyName = "society_banquier",

    logs = {
		-------------------------	
		NameLogs = "Logs - Banque",
		-------------------------
        GiveCard = "https://discord.com/api/webhooks/1003884709501206589/jazeqCOZ1HXPFnHdX0QwkHZ0GmoDy0VnDlg2PT-Bi2euOtb_bCU48Nfa9a46VWb1vu_G",
        DepotBank = "https://discord.com/api/webhooks/1003884709501206589/jazeqCOZ1HXPFnHdX0QwkHZ0GmoDy0VnDlg2PT-Bi2euOtb_bCU48Nfa9a46VWb1vu_G",
        RetraitBank = "https://discord.com/api/webhooks/1003884709501206589/jazeqCOZ1HXPFnHdX0QwkHZ0GmoDy0VnDlg2PT-Bi2euOtb_bCU48Nfa9a46VWb1vu_G",
        TransferBank = "https://discord.com/api/webhooks/1003884709501206589/jazeqCOZ1HXPFnHdX0QwkHZ0GmoDy0VnDlg2PT-Bi2euOtb_bCU48Nfa9a46VWb1vu_G",
        CreditBank = "https://discord.com/api/webhooks/1003884709501206589/jazeqCOZ1HXPFnHdX0QwkHZ0GmoDy0VnDlg2PT-Bi2euOtb_bCU48Nfa9a46VWb1vu_G",
        LivretBank = "https://discord.com/api/webhooks/1003884709501206589/jazeqCOZ1HXPFnHdX0QwkHZ0GmoDy0VnDlg2PT-Bi2euOtb_bCU48Nfa9a46VWb1vu_G",
        Coffre = "https://discord.com/api/webhooks/1003884709501206589/jazeqCOZ1HXPFnHdX0QwkHZ0GmoDy0VnDlg2PT-Bi2euOtb_bCU48Nfa9a46VWb1vu_G",
        Boss = "https://discord.com/api/webhooks/1003884709501206589/jazeqCOZ1HXPFnHdX0QwkHZ0GmoDy0VnDlg2PT-Bi2euOtb_bCU48Nfa9a46VWb1vu_G",
        -------------------------

	},

    Marker = {
        Type = 6,
        Color = {R = 10, G = 240, B = 10, H = 255},
        Size =  {x = 1.0, y = 1.0, z = 1.0},
        DrawDistance = 10,
        DrawInteract = 1.5,
    },

    SavingsAccountRemove = true, 	-- true = money removed from bank society account | false = generated money
    SavingsDay = 5, 	-- Sunday = 1 | Monday = 2 .... Saturday = 7
    CRONSavingsTime	= {10, 52},
    CRONRiskedSavingsTime = {10, 53},
    CRONLoanDeadlineTime = {10, 54},
    CRONLoanTime = {10, 55},

    ShopForCard = {
		{pos = vector3(251.40660095215,221.0831451416,106.28678131104)},
        {pos = vector3(241.25062561035,225.17376708984,106.2868347168)},
        {pos = vector3(246.36820983887,223.13102722168,106.28678131104)},
    },

    Banque = {
    --    {x = 248.20770263672, y =222.5210723877, z =106.28677368164},
        {x = 253.33197021484, y =220.40940856934, z =106.2866897583},
    --    {x = 243.02923583984, y = 224.47332763672, z = 106.28690338135},
        {x = 150.266, y = -1040.203, z = 29.374},
        {x = -1212.980, y = -330.841, z = 37.787},
        {x = -2962.59, y = 482.5, z = 15.703},
        {x = -112.202, y = 6469.295, z = 31.626},
        {x = 314.187, y = -278.621, z = 54.170},
        {x = -351.534, y = -49.529, z = 49.042},
        {x = 1175.064, y = 2706.643, z = 38.094},
    },

    ATM = { 
        {x = -386.77, y = 6046.07, z = 31.50},
        {x = -133.05, y = 6366.53, z = 31.47},
        {x = -97.28, y = 6455.45, z = 31.46},
        {x = 174.14, y = 6637.94, z = 31.57},
        {x = 1703.00, y = 4933.59, z = 42.06},
        {x = 2564.50, y = 2584.77, z = 38.08},
        {x = 1138.23, y = -468.94, z = 66.73},
        {x = 380.76, y = 323.38, z = 103.56},
        {x = 237.03, y = 218.73, z = 106.28},
        {x = 237.89, y = 216.89, z = 106.28},
        {x = 265.48, y = 212.91, z = 106.28},
        {x = 285.46, y = 143.38, z = 104.17},
        {x = 158.59, y = 234.21, z = 106.62},
        {x = -165.06, y = 235.13, z = 94.92},
        {x = -165.13, y = 232.57, z = 94.92},
        {x = -2975.07, y = 380.12, z = 14.99},
        {x = -2956.63, y = 487.63, z = 15.46},
        {x = -2959.19, y = 487.74, z = 15.46},
        {x = -3043.99, y = 594.56, z = 7.73},
        {x = -3144.33, y = 1127.61, z = 20.85},
        {x = -3241.15, y = 997.58, z = 12.55},
        {x = -3240.58, y = 1008.64, z = 12.83},
        {x = -1305.40, y = -706.38, z = 25.32},
        {x = -537.81, y = -854.50, z = 29.29},
        {x = -710.02, y = -818.90, z = 23.72},
        {x = -712.90, y = -818.91, z = 23.72},
    },

    ListVeh = {
		{nom = "T20 du banquier", model = "t20"},
        {nom = "Sultan du Seigneur", model = "sultanrs"},

	},

    Boss = vector3(242.26037597656,230.46855163574,105.28690338135),
    Coffre = vector3(248.89643859863,230.42596435547,105.28691864014),
    Garage = vector3(228.50944519043,217.45230102539,104.54890441895),
    DeleteVeh = vector3(225.78126525879,224.42422485352,104.54872131348),
    SpawnVeh = vector3(219.68977355957,220.24279785156,105.51795959473),
    SpawnHeading = 338.41,
}