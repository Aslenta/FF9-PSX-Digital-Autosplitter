state ("duckstation-qt-x64-ReleaseLTCG", "any") { }
state ("duckstation-nogui-x64-ReleaseLTCG", "any") { }

startup 
{
    settings.Add("1", false, "Disc 1");
        settings.Add("1.1", false, "Mage Masher", "1");
        settings.Add("1.2", false, "King Leo", "1");
        settings.Add("1.3", false, "Steiner 1", "1");
        settings.Add("1.4", false, "Steiner 2", "1");
        settings.Add("1.5", false, "Steiner 3", "1");
        settings.Add("1.6", false, "Prison Cage", "1");
        settings.Add("1.7", false, "Baku", "1");
        settings.Add("1.8", false, "Plant Brain", "1");
        settings.Add("1.9", false, "Evil Forest Done", "1");
        settings.Add("1.10", false, "Sealion", "1");
        settings.Add("1.11", false, "Enter Dali", "1");
        settings.Add("1.12", false, "Black Waltz 2", "1");
        settings.Add("1.13", false, "Black Waltz 3", "1");
        settings.Add("1.14", false, "Mu", "1");
        settings.Add("1.15", false, "Enter Gizamaluke's", "1");
        settings.Add("1.16", false, "Gizamaluke", "1");
        settings.Add("1.17", false, "Enter Burmecia", "1");
        settings.Add("1.18", false, "Beatrix 1", "1");
        settings.Add("1.19", false, "End of Disc 1", "1");
        
    settings.Add("2", false, "Disc 2");
        settings.Add("2.1", false, "Black Waltz 3 2", "2");
        settings.Add("2.2", false, "Ralvurahva", "2");
        settings.Add("2.3", false, "Cleyra Settlement", "2");
        settings.Add("2.4", false, "Antlion", "2");
        settings.Add("2.5", false, "Beatrix 2", "2");
        settings.Add("2.6", false, "Guards", "2");
        settings.Add("2.7", false, "Tantarian", "2");
        settings.Add("2.8", false, "Zorn & Thorn", "2");
        settings.Add("2.9", false, "Beatrix 3", "2");
        settings.Add("2.10", false, "Ralvuimago", "2");
        settings.Add("2.11", false, "Lani", "2");
        settings.Add("2.12", false, "Exit Fossil Roo", "2");
        settings.Add("2.13", false, "Exit Black Mage Village", "2");
        settings.Add("2.14", false, "Hilgigars", "2");
        settings.Add("2.15", false, "Enter Iifa Tree", "2");
        settings.Add("2.16", false, "Soulcage", "2");
        settings.Add("2.17", false, "Amarant", "2");
        settings.Add("2.18", false, "Iifa Tree Done", "2");
        settings.Add("2.19", false, "End of Disc 2", "2");

    settings.Add("3", false, "Disc 3");
        settings.Add("3.1", false, "Card Tournament", "3");
        settings.Add("3.2", false, "Mistodons", "3");
        settings.Add("3.3", false, "Late Tantarian", "3");
        settings.Add("3.4", false, "Blue Narciss", "3");
        settings.Add("3.5", false, "Sand", "3");
        settings.Add("3.6", false, "Enter Oeilvert", "3");
        settings.Add("3.7", false, "Ark", "3");
        settings.Add("3.8", false, "Desert Palace Start", "3");
        settings.Add("3.9", false, "Valia Pira", "3");
        settings.Add("3.10", false, "Enter Esto Gaza", "3");
        settings.Add("3.11", false, "Red Dragons", "3");
        settings.Add("3.12", false, "Meltigemini", "3");
        settings.Add("3.13", false, "Enter Ipsen's Castle", "3");
        settings.Add("3.14", false, "Taharka", "3");
        settings.Add("3.15", false, "Enter Earth Shrine", "3");
        settings.Add("3.16", false, "Earth Guardian", "3");
        settings.Add("3.17", false, "Enter Bran Bal", "3");
        settings.Add("3.18", false, "Amdusias", "3");
        settings.Add("3.19", false, "Abadon", "3");
        settings.Add("3.20", false, "Shell Dragon", "3");
        settings.Add("3.21", false, "Silver Dragon", "3");
        settings.Add("3.22", false, "Garland", "3");
        settings.Add("3.23", false, "Kuja", "3");
        settings.Add("3.24", false, "End of Disc 3", "3");

    settings.Add("4", false, "Disc 4");
        settings.Add("4.1", false, "Nova Dragon", "4");
        settings.Add("4.2", false, "Maliris", "4");
        settings.Add("4.3", false, "Tiamat", "4");
        settings.Add("4.4", false, "Kraken", "4");
        settings.Add("4.5", false, "Lich", "4");
        settings.Add("4.6", false, "Deathguise", "4");
        settings.Add("4.7", false, "Trance Kuja", "4");
        settings.Add("4.8", false, "Necron", "4");

    
    vars.duckstationProcessNames = new List<string> {
        "duckstation-qt-x64-ReleaseLTCG",
        "duckstation-nogui-x64-ReleaseLTCG",
    };
    vars.duckstation = false;
    vars.duckstationBaseRAMAddressFound  = false;
    
    vars.baseRAMAddress = IntPtr.Zero;

    vars.Splits = new HashSet<string>();
    vars.Stopwatch = new Stopwatch();
}

init 
{
	refreshRate = 60;

    var mainModule = modules.First();
    switch (mainModule.ModuleMemorySize) {
        default:
            break;
    }

    if (vars.duckstationProcessNames.Contains(game.ProcessName)) {
        vars.duckstation = true;
        version = "any";
        vars.baseRAMAddress = IntPtr.Zero;
    }
}

update 
{
    if (version == "") {
        return false;
    }

    if (vars.duckstation) {
    foreach (var page in game.MemoryPages(true)) {
        if (page.Type == MemPageType.MEM_MAPPED && page.RegionSize == (UIntPtr)0x200000) {
            vars.baseRAMAddress = page.BaseAddress;
            vars.duckstationBaseRAMAddressFound = true;
            break;
        }
    }
    if (!vars.duckstationBaseRAMAddressFound) {
        return false;
    }

    IntPtr temp1 = vars.baseRAMAddress;
    IntPtr temp2 = IntPtr.Zero;
    if (!game.ReadPointer(temp1, out temp2)) {
        vars.duckstationBaseRAMAddressFound = false;
        vars.baseRAMAddress = IntPtr.Zero;
        return false;
    }
    }

    vars.ScenarioCounterAddress = vars.baseRAMAddress + 0x7A3C0;
    vars.fieldIdAddress = vars.baseRAMAddress + 0x8FA5C;
    vars.fieldEntranceAddress = vars.baseRAMAddress + 0x7A3C2;
    vars.battleIdAddress = vars.baseRAMAddress + 0x8FA5E;
    vars.stateFlagAddress = vars.baseRAMAddress + 0x8F808;
    vars.currentHPchar1Address = vars.baseRAMAddress + 0x9CE68;
    vars.currentHPenemy1Address = vars.baseRAMAddress + 0x108A64;
    vars.pauseFlagAddress = vars.baseRAMAddress + 0x8FA50;
    vars.NGscreenAddress = vars.baseRAMAddress + 0x7E2C0;

    current.ScenarioCounter = memory.ReadValue<short>((IntPtr)vars.ScenarioCounterAddress);
    current.fieldId = memory.ReadValue<short>((IntPtr)vars.fieldIdAddress);
    current.fieldEntrance = memory.ReadValue<short>((IntPtr)vars.fieldEntranceAddress);
    current.battleId = memory.ReadValue<short>((IntPtr)vars.battleIdAddress);
    current.stateFlag = memory.ReadValue<short>((IntPtr)vars.stateFlagAddress);
    current.currentHPchar1 = memory.ReadValue<short>((IntPtr)vars.currentHPchar1Address);
    current.currentHPenemy1 = memory.ReadValue<short>((IntPtr)vars.currentHPenemy1Address);
    current.pauseFlag = memory.ReadValue<short>((IntPtr)vars.pauseFlagAddress);
    current.NGscreen = memory.ReadValue<byte>((IntPtr)vars.NGscreenAddress);

}

start 
{	
	if(old.NGscreen == 0 && current.NGscreen >= 1 && current.battleId == 565 && current.fieldId == 0){
            vars.Splits.Clear();
        return true;
    }
}

split
{
    if(settings["1"])
    {
        if(current.ScenarioCounter < 1190)
        {
            if(settings["1.1"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 336 && !vars.Splits.Contains("magemasher"))
            {
                vars.Splits.Add("magemasher");
                return true;
            }
            if(settings["1.2"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 338 && !vars.Splits.Contains("kingleo"))
            {
                vars.Splits.Add("kingleo");
                return true;
            }
        }
        else if(current.ScenarioCounter >= 1500 && current.ScenarioCounter < 2005)
        {
            if(settings["1.3"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 337 && !vars.Splits.Contains("steiner1"))
            {
                vars.Splits.Add("steiner1");
                return true;
            }
            if(settings["1.4"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 335 && !vars.Splits.Contains("steiner2"))
            {
                vars.Splits.Add("steiner2");
                return true;
            }
            if(settings["1.5"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 334 && !vars.Splits.Contains("steiner3"))
            {
                vars.Splits.Add("steiner3");
                return true;
            }
        }
        else if(current.ScenarioCounter >= 2005 && current.ScenarioCounter < 2410)
        {
            if(settings["1.6"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 301 && !vars.Splits.Contains("prisoncage"))
            {
                vars.Splits.Add("prisoncage");
                return true;
            }
            if(settings["1.7"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 295 && !vars.Splits.Contains("baku"))
            {
                vars.Splits.Add("baku");
                return true;
            }
            if(settings["1.8"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 303 && !vars.Splits.Contains("plantbrain"))
            {
                vars.Splits.Add("plantbrain");
                return true;
            }
            if(settings["1.9"] && old.fieldId == 259 && current.fieldId == 260 && !vars.Splits.Contains("evilforest"))
            {
                vars.Splits.Add("evilforest");
                return true;
            }
        }
        else if(current.ScenarioCounter >= 2410 && current.ScenarioCounter < 2540)
        {
            if(settings["1.10"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 21 && !vars.Splits.Contains("sealion"))
            {
                vars.Splits.Add("sealion");
                return true;
            }
        }
        else if(current.ScenarioCounter >= 2540 && current.ScenarioCounter < 3000)
        {
            if(settings["1.11"] && old.stateFlag != 513 && current.stateFlag == 513 && current.fieldId == 359 && !vars.Splits.Contains("dali"))
            {
                vars.Splits.Add("dali");
                return true;
            }
            if(settings["1.12"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 294 && !vars.Splits.Contains("blackwaltz2"))
            {
                vars.Splits.Add("blackwaltz2");
                return true;
            }
            if(settings["1.13"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 296 && !vars.Splits.Contains("blackwaltz3"))
            {
                vars.Splits.Add("blackwaltz3");
                return true;
            }
        }
        else if(current.ScenarioCounter >= 3000 && current.ScenarioCounter < 3760)
        {
            if(settings["1.14"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 13 && current.currentHPchar1 == 0 && !vars.Splits.Contains("mu"))
            {
                vars.Splits.Add("mu");
                return true;
            }
            if(settings["1.15"] && old.stateFlag != 513 && current.stateFlag == 513 && current.fieldId == 701 && current.ScenarioCounter == 3700 && !vars.Splits.Contains("entergizamaluke"))
            {
                vars.Splits.Add("entergizamaluke");
                return true;
            }
            if(settings["1.16"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 326 && !vars.Splits.Contains("gizamaluke"))
            {
                vars.Splits.Add("gizamaluke");
                return true;
            }
        }
        else if(current.ScenarioCounter >= 3760 && current.ScenarioCounter <= 3900)
        {
            if(settings["1.17"] && old.stateFlag != 513 && current.stateFlag == 513 && current.fieldId == 750 && current.ScenarioCounter == 3760 && !vars.Splits.Contains("burmecia"))
            {
                vars.Splits.Add("burmecia");
                return true;
            }
            if(settings["1.18"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 4 && !vars.Splits.Contains("beatrix1"))
            {
                vars.Splits.Add("beatrix1");
                return true;
            }
            if(settings["1.19"] && old.fieldId == 70 && current.fieldId == 800 && current.ScenarioCounter == 3900 && !vars.Splits.Contains("eod1"))
            {
                vars.Splits.Add("eod1");
                return true;
            }
        }
    }
    if(settings["2"])
    {
        if(current.ScenarioCounter > 3900 && current.ScenarioCounter < 4650)
        {
            if(settings["2.1"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 52 && !vars.Splits.Contains("blackwaltz32"))
            {
                vars.Splits.Add("blackwaltz32");
                return true;
            }
            if(settings["2.2"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 76 && !vars.Splits.Contains("ralvurahva"))
            {
                vars.Splits.Add("ralvurahva");
                return true;
            }
        }
        else if(current.ScenarioCounter >= 4650 && current.ScenarioCounter < 5030)
        {
            if(settings["2.3"] && old.ScenarioCounter < 4700 && current.ScenarioCounter == 4700 && current.fieldId == 1051 && !vars.Splits.Contains("cleyra"))
            {
                vars.Splits.Add("cleyra");
                return true;
            }
            if(settings["2.4"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 300 && !vars.Splits.Contains("antlion"))
            {
                vars.Splits.Add("antlion");
                return true;
            }
            if(settings["2.5"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 299 && !vars.Splits.Contains("beatrix2"))
            {
                vars.Splits.Add("beatrix2");
                return true;
            }
        }
        else if(current.ScenarioCounter >= 5030 && current.ScenarioCounter < 5400)
        {
            if(settings["2.6"] && old.fieldId == 1209 && current.fieldId == 1211 && !vars.Splits.Contains("guards"))
            {
                vars.Splits.Add("guards");
                return true;
            }
            if(settings["2.7"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 930  && !vars.Splits.Contains("tantarian"))
            {
                vars.Splits.Add("tantarian");
                return true;
            }
            if(settings["2.8"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 74 && !vars.Splits.Contains("zornandthorn"))
            {
                vars.Splits.Add("zornandthorn");
                return true;
            }
            if(settings["2.9"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 73 && !vars.Splits.Contains("beatrix3"))
            {
                vars.Splits.Add("beatrix3");
                return true;
            }
            if(settings["2.10"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 75 && !vars.Splits.Contains("ralvuimago"))
            {
                vars.Splits.Add("ralvuimago");
                return true;
            }      
        }
        else if(current.ScenarioCounter >= 5400 && current.ScenarioCounter < 6000)
        {
            if(settings["2.11"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 83 && !vars.Splits.Contains("lani"))
            {
                vars.Splits.Add("lani");
                return true;
            }
            if(settings["2.12"] && old.stateFlag == 513 && current.stateFlag != 513 && current.fieldId == 1425 && current.ScenarioCounter == 5990 && !vars.Splits.Contains("fossilroo"))
            {
                vars.Splits.Add("fossilroo");
                return true;
            }
        }
        else if(current.ScenarioCounter >= 6000 && current.ScenarioCounter < 6240)
        {
            if(settings["2.13"] && old.stateFlag == 513 && current.stateFlag != 513 && current.fieldId == 1450 && current.ScenarioCounter == 6212 && !vars.Splits.Contains("blackmagevillage"))
            {
                vars.Splits.Add("blackmagevillage");
                return true;
            }
        }
        else if(current.ScenarioCounter >= 6240 && current.ScenarioCounter < 6800)
        {
            if(settings["2.14"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 107 && !vars.Splits.Contains("hilgigars"))
            {
                vars.Splits.Add("hilgigars");
                return true;
            }
            if(settings["2.15"] && old.stateFlag != 513 && current.stateFlag == 513 && current.fieldId == 1650 && current.ScenarioCounter == 6690 && !vars.Splits.Contains("enteriifatree"))
            {
                vars.Splits.Add("enteriifatree");
                return true;
            }
            if(settings["2.16"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 116 && !vars.Splits.Contains("soulcage"))
            {
                vars.Splits.Add("soulcage");
                return true;
            }
        }
        else if(current.ScenarioCounter >= 6800 && current.ScenarioCounter < 7010)
        {
            if(settings["2.17"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 132 && !vars.Splits.Contains("amarant"))
            {
                vars.Splits.Add("amarant");
                return true;
            }
            if(settings["2.18"] && old.fieldId == 1655 && current.fieldId == 1656 && current.ScenarioCounter == 6960 && !vars.Splits.Contains("iifatreedone"))
            {
                vars.Splits.Add("iifatreedone");
                return true;
            }
            if(settings["2.19"] && old.fieldId == 1800 && current.fieldId == 1812 && current.ScenarioCounter == 6990 && !vars.Splits.Contains("eod2"))
            {
                vars.Splits.Add("eod2");
                return true;
            }
        }
    }
    if(settings["3"])
    {
        if(current.ScenarioCounter >= 7010 && current.ScenarioCounter < 9410)
        {
            if(settings["3.1"] && current.ScenarioCounter >= 7700 && old.fieldId == 1903 && current.fieldId == 2054 && !vars.Splits.Contains("cards"))
            {
                vars.Splits.Add("cards");
                return true;
            }
            if(settings["3.2"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 915 && current.ScenarioCounter == 8340 && !vars.Splits.Contains("mistodons"))
            {
                vars.Splits.Add("mistodons");
                return true;
            }
            if(settings["3.3"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 930 && !vars.Splits.Contains("latetantarian"))
            {
                vars.Splits.Add("latetantarian");
                return true;
            }
            if(settings["3.4"] && old.ScenarioCounter == 9370 && current.ScenarioCounter == 9400 && current.fieldId == 2855 && !vars.Splits.Contains("bluenarciss"))
            {
                vars.Splits.Add("bluenarciss");
                return true;
            }
        }
        else if(current.ScenarioCounter >= 9410 && current.ScenarioCounter < 9790)
        {
            if(settings["3.5"] && old.stateFlag != 513 && current.stateFlag == 513 && current.fieldId == 2200 && !vars.Splits.Contains("sand"))
            {
                vars.Splits.Add("sand");
                return true;
            }
            if(settings["3.6"] && old.stateFlag != 513 && current.stateFlag == 513 && current.fieldId == 2250 && !vars.Splits.Contains("oeilvert"))
            {
                vars.Splits.Add("oeilvert");
                return true;
            }
            if(settings["3.7"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 0 && !vars.Splits.Contains("ark"))
            {
                vars.Splits.Add("ark");
                return true;
            }
        }
        else if(current.ScenarioCounter >= 9790 && current.ScenarioCounter < 9900)
        {
            if(settings["3.8"] && current.ScenarioCounter == 9820 && old.fieldId == 2206 && current.fieldId == 2213 && !vars.Splits.Contains("dpstart"))
            {
                vars.Splits.Add("dpstart");
                return true;
            }
            if(settings["3.9"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 525 && !vars.Splits.Contains("valiapira"))
            {
                vars.Splits.Add("valiapira");
                return true;
            }
        }
        else if(current.ScenarioCounter >= 9900 && current.ScenarioCounter < 10000)
        {
            if(settings["3.10"] && old.stateFlag != 513 && current.stateFlag == 513 && current.fieldId == 2300 && current.ScenarioCounter == 9910 && !vars.Splits.Contains("estogaza"))
            {
                vars.Splits.Add("estogaza");
                return true;
            }
            if(settings["3.11"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 195 && !vars.Splits.Contains("reddragons"))
            {
                vars.Splits.Add("reddragons");
                return true;
            }
            if(settings["3.12"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 200 && !vars.Splits.Contains("meltigemini"))
            {
                vars.Splits.Add("meltigemini");
                return true;
            }
        }
        else if(current.ScenarioCounter >= 10000 && current.ScenarioCounter < 10600)
        {
            if(settings["3.13"] && old.stateFlag != 513 && current.stateFlag == 513 && current.fieldId == 2500 && current.ScenarioCounter == 10400 && !vars.Splits.Contains("ipsencastle"))
            {
                vars.Splits.Add("ipsencastle");
                return true;
            }
            if(settings["3.14"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 871 && !vars.Splits.Contains("taharka"))
            {
                vars.Splits.Add("taharka");
                return true;
            }
        }
        else if(current.ScenarioCounter >= 10600 && current.ScenarioCounter < 10830)
        {
            if(settings["3.15"] && old.stateFlag != 513 && current.stateFlag == 513 && current.fieldId == 2550 && current.ScenarioCounter == 10660 && !vars.Splits.Contains("earthshrine"))
            {
                vars.Splits.Add("earthshrine");
                return true;
            }
            if(settings["3.16"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 2 && !vars.Splits.Contains("earthguardian"))
            {
                vars.Splits.Add("earthguardian");
                return true;
            }
        }
        else if(current.ScenarioCounter >= 10830 && current.ScenarioCounter < 11200)
        {
            if(settings["3.17"] && old.fieldId == 2650 && current.fieldId == 2651 && current.ScenarioCounter == 10890 && !vars.Splits.Contains("branbal"))
            {
                vars.Splits.Add("branbal");
                return true;
            }
            if(settings["3.18"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 155 && !vars.Splits.Contains("amdusias"))
            {
                vars.Splits.Add("amdusias");
                return true;
            }
            if(settings["3.19"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 160 && !vars.Splits.Contains("abadon"))
            {
                vars.Splits.Add("abadon");
                return true;
            }
            if(settings["3.20"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 163 && !vars.Splits.Contains("shelldragon"))
            {
                vars.Splits.Add("shelldragon");
                return true;
            }
            if(settings["3.21"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 889 && !vars.Splits.Contains("silverdragon"))
            {
                vars.Splits.Add("silverdragon");
                return true;
            }
            if(settings["3.22"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 890 && !vars.Splits.Contains("garland"))
            {
                vars.Splits.Add("garland");
                return true;
            }
            if(settings["3.23"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 891 && !vars.Splits.Contains("kuja"))
            {
                vars.Splits.Add("kuja");
                return true;
            }
            if(settings["3.24"] && old.fieldId == 2750 && current.fieldId == 3052  && current.ScenarioCounter >= 10995 && !vars.Splits.Contains("eod3"))
            {
                vars.Splits.Add("eod3");
                return true;
            }
        }
    }
    if(settings["4"])
    {
        if(current.ScenarioCounter >= 11200 && current.ScenarioCounter < 12000)
        {
            if(settings["4.1"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 931 && !vars.Splits.Contains("novadragon"))
            {
                vars.Splits.Add("novadragon");
                return true;
            }
            if(settings["4.2"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 932 && !vars.Splits.Contains("maliris"))
            {
                vars.Splits.Add("maliris");
                return true;
            }
            if(settings["4.3"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 933 && !vars.Splits.Contains("tiamat"))
            {
                vars.Splits.Add("tiamat");
                return true;
            }
            if(settings["4.4"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 934 && !vars.Splits.Contains("kraken"))
            {
                vars.Splits.Add("kraken");
                return true;
            }
            if(settings["4.5"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 935 && !vars.Splits.Contains("lich"))
            {
                vars.Splits.Add("lich");
                return true;
            }
            if(settings["4.6"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 936 && !vars.Splits.Contains("deathguise"))
            {
                vars.Splits.Add("deathguise");
                return true;
            }
            if(settings["4.7"] && old.stateFlag != 513 && current.stateFlag == 513 && current.battleId == 937 && !vars.Splits.Contains("trancekuja"))
            {
                vars.Splits.Add("trancekuja");
                return true;
            }
            if(settings["4.8"] && current.stateFlag != 513 && current.battleId == 938 && old.currentHPenemy1 >= 10001 && current.currentHPenemy1 <= 10000 && !vars.Splits.Contains("necron"))
            {
                vars.Stopwatch.Start();
                if (vars.Stopwatch.ElapsedMilliseconds >= 2000){
                    vars.Stopwatch.Reset();
                    vars.Splits.Add("necron");
                    return true;
                }
            }
        }
    }
}

isLoading
{
    return (current.ScenarioCounter == 7010 && current.fieldEntrance == 202 && current.fieldId == 1851);
}
