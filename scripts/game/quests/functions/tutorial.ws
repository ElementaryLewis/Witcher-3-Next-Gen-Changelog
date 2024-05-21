/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/







quest function TutorialScript(scriptName : name, tutorialMessageName : name)
{
	var uitut : SUITutorial;
	var pos : Vector;
	var rot : EulerAngles;
	var template : CEntityTemplate;
	var ents : array<CEntity>;
	var ent : CEntity;
	var i : int;
	var configValue : string;
	var inGameConfigWrapper : CInGameConfigWrapper;

	
	if(scriptName == 'start')
	{
		
		if(!theGame.GetTutorialSystem() || !theGame.GetTutorialSystem().IsRunning())
			theGame.GetTutorialSystem().TutorialStart(true);
			
		return;
	}
	
	else if(scriptName == 'restart')
	{
		
		if(!theGame.GetTutorialSystem() || !theGame.GetTutorialSystem().IsRunning())
			theGame.GetTutorialSystem().TutorialRestart();
			
		return;
	}
	
	else if(!theGame.GetTutorialSystem() || !theGame.GetTutorialSystem().IsRunning())
	{
		return;
	}
	
	inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
	configValue = inGameConfigWrapper.GetVarValue('Gameplay', 'HudTutorialEnabled');
	TutorialMessagesEnable(configValue == "true");
	
	if(scriptName == 'meteorMarker_ON')
	{
		theGame.GetEntitiesByTag('q001_dummy_for_geralt', ents);
		
		template = (CEntityTemplate)LoadResource('TutorialDummyFx');
		for(i=0; i<ents.Size(); i+=1)
		{
			pos = ents[i].GetWorldPosition();
			rot = ents[i].GetWorldRotation();
			pos.Z -= 0.5;
			ent = theGame.CreateEntity(template, pos, rot, , , , PM_Persist);
			ent.AddTag('tutorial_train_dummy_marker');
			ent.PlayEffect('marker');
		}
	}
	else if(scriptName == 'meteorMarker_OFF')
	{
		theGame.GetEntitiesByTag('tutorial_train_dummy_marker', ents);
		
		for(i=ents.Size()-1; i>=0; i-=1)
		{
			ents[i].StopAllEffects();
			ents[i].Destroy();
		}
	}	
	else if(scriptName == 'silverSword')
	{
		thePlayer.AddTimer('TutorialSilverCombat', 1, true, , , true);
	}
	else if(scriptName == 'Betting')
	{
		uitut.menuName = 'BetMenu';
		uitut.tutorialStateName = 'Betting';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.abortOnMenuClose = true;
		uitut.priority = 70;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else if(scriptName == 'Haggling')
	{
		uitut.menuName = 'MonsterHuntNegotiationMenu';
		uitut.tutorialStateName = 'Haggling';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.abortOnMenuClose = true;
		uitut.priority = 70;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else if(scriptName == 'PotionsPreparation')
	{
		uitut.menuName = 'InventoryMenu';
		uitut.tutorialStateName = 'Potions';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.abortOnMenuClose = true;
		uitut.priority = 30;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else if(scriptName == 'MutagenPotion')
	{
		uitut.menuName = 'AlchemyMenu';
		uitut.tutorialStateName = 'AlchemyMutagens';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 70;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else if(scriptName == 'OilsPreparation')
	{
		uitut.menuName = 'InventoryMenu';
		uitut.tutorialStateName = 'Oils';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.abortOnMenuClose = true;
		uitut.priority = 35;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}	
	else if(scriptName == 'fast_travel')
	{
		uitut.menuName = 'MapMenu';
		uitut.tutorialStateName = 'FastTravel';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.abortOnMenuClose = true;
		uitut.requiredGameplayFactName = "tutorial_fast_travel_open";
		uitut.requiredGameplayFactValueInt = 1;
		uitut.requiredGameplayFactComparator = CO_GreaterEq;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	
	else if(scriptName == 'alchemy')
	{
		uitut.menuName = 'AlchemyMenu';
		uitut.tutorialStateName = 'Alchemy';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.requiredGameplayFactName = "tutorial_alch_has_ings";
		uitut.requiredGameplayFactValueInt = 1;
		uitut.requiredGameplayFactComparator = CO_GreaterEq;
		uitut.abortOnMenuClose = true;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else if(scriptName == 'alchemyRecipePin')
	{
		uitut.menuName = 'AlchemyMenu';
		uitut.tutorialStateName = 'RecipePinning';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 10;
		uitut.requiredGameplayFactName = "tutorial_alchemy_pin_done";
		uitut.requiredGameplayFactValueInt = 1;
		uitut.requiredGameplayFactComparator = CO_Lesser;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else if(scriptName == 'alchemyForced')
	{
		
		uitut.menuName = 'AlchemyMenu';
		uitut.tutorialStateName = 'Alchemy';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.abortOnMenuClose = true;
		uitut.sourceName = "forced";
				
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
		
		
		uitut.menuName = 'CommonMenu';
		uitut.tutorialStateName = 'ForcedAlchemy';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.abortOnMenuClose = true;
		uitut.priority = 3;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
		
		
		uitut.menuName = 'InventoryMenu';
		uitut.tutorialStateName = 'Potions';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.abortOnMenuClose = false;
		uitut.priority = 7;
		uitut.sourceName = "forced";
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else if(scriptName == 'worldMap')
	{
		
		uitut.menuName = 'CommonMenu';
		uitut.tutorialStateName = 'OpenWorldMap';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.abortOnMenuClose = true;
		uitut.priority = 5;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
		
		
		uitut.menuName = 'MapMenu';
		uitut.tutorialStateName = 'Map';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.abortOnMenuClose = true;
		uitut.priority = 5;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else if(scriptName == 'food')
	{
		
		uitut.menuName = 'CommonMenu';
		uitut.tutorialStateName = 'OpenInventory';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.abortOnMenuClose = true;
		uitut.priority = 8;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
		
		
		uitut.menuName = 'InventoryMenu';
		uitut.tutorialStateName = 'Food';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.abortOnMenuClose = true;
		uitut.priority = 8;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else if(scriptName == 'alchemyForcedCleanup')
	{
		theGame.GetTutorialSystem().ForcedAlchemyCleanup();
	}
	else if(scriptName == 'bestiary_ON')
	{
		
		uitut.menuName = 'CommonMenu';
		uitut.tutorialStateName = 'IngameMenuBestiary';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 20;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
		
		
		uitut.menuName = 'GlossaryParent';
		uitut.tutorialStateName = 'BestiaryGlossarySubmenu';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 1;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
		
		
		uitut.menuName = 'GlossaryBestiaryMenu';
		uitut.tutorialStateName = 'Bestiary';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else if(scriptName == 'bestiary_OFF')
	{
		theGame.GetTutorialSystem().uiHandler.UnregisterUIState('IngameMenuBestiary');
		
	}
	else if(scriptName == 'bestiaryQ103_ON')
	{
		
		uitut.menuName = 'CommonMenu';
		uitut.tutorialStateName = 'IngameMenuBestiary';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 15;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);		
	}
	else if(scriptName == 'bestiaryQ103_OFF')
	{
		theGame.GetTutorialSystem().uiHandler.UnregisterUIState('IngameMenuBestiary');
	}
	else if(scriptName == 'journal')
	{
		
		uitut.menuName = 'JournalQuestMenu';
		uitut.tutorialStateName = 'JournalQuest';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
		
		
	}	
	else if(scriptName == 'shop_ON')
	{
		uitut.menuName = 'ShopMenu';
		uitut.tutorialStateName = 'Shop';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 10;
		uitut.abortOnMenuClose = true;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else if(scriptName == 'shop_OFF')
	{
		theGame.GetTutorialSystem().uiHandler.GotoState('Tutorial_Idle');
	}
	else if(scriptName == 'characterDev')
	{
		uitut.menuName = 'CharacterMenu';
		uitut.tutorialStateName = 'CharacterDevelopment';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 10;
		uitut.abortOnMenuClose = true;
		uitut.requiredGameplayFactName = "in_combat";
		uitut.requiredGameplayFactValueInt = 1;
		uitut.requiredGameplayFactComparator = CO_Lesser;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
		
		uitut.menuName = 'CommonMenu';
		uitut.tutorialStateName = 'CharacterDevelopmentFastMenu';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 10;
		uitut.abortOnMenuClose = true;
		uitut.requiredGameplayFactName = "in_combat";
		uitut.requiredGameplayFactValueInt = 1;
		uitut.requiredGameplayFactComparator = CO_Lesser;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else
	{
		
		TutorialScript2(scriptName, tutorialMessageName);
	}
}

function TutorialScript2(scriptName : name, tutorialMessageName : name)	
{
	var uitut : SUITutorial;
	
	if(scriptName == 'charDevMutagens')
	{
		uitut.menuName = 'CharacterMenu';
		uitut.tutorialStateName = 'CharDevMutagens';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 20;
		uitut.abortOnMenuClose = true;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else if(scriptName == 'upgradesRemoval')
	{
		uitut.menuName = 'BlacksmithMenu';
		uitut.tutorialStateName = 'UpgradesRemoval';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 20;
		uitut.abortOnMenuClose = true;
		uitut.requiredGameplayFactName = "tutorial_upg_removal_cond";
		uitut.requiredGameplayFactValueInt = 1;
		uitut.requiredGameplayFactComparator = CO_GreaterEq;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else if(scriptName == 'dismantling')
	{
		uitut.menuName = 'BlacksmithMenu';
		uitut.tutorialStateName = 'Dismantling';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 20;
		uitut.abortOnMenuClose = true;
		uitut.requiredGameplayFactName = "tut_dismantle_cond";
		uitut.requiredGameplayFactValueInt = 1;
		uitut.requiredGameplayFactComparator = CO_GreaterEq;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else if(scriptName == 'meditationWait')
	{
		uitut.menuName = 'MeditationClockMenu';
		uitut.tutorialStateName = 'MeditationWait';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 20;
		uitut.abortOnMenuClose = true;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else if(scriptName == 'secondPotionEquip')
	{
		uitut.menuName = 'InventoryMenu';
		uitut.tutorialStateName = 'SecondPotionEquip';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 37;
		uitut.abortOnMenuClose = true;
		uitut.requiredGameplayFactName = "tutorial_equip_potion";
		uitut.requiredGameplayFactValueInt = 1;
		uitut.requiredGameplayFactComparator = CO_GreaterEq;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else if(scriptName == 'specialAttacks')
	{
		uitut.menuName = 'CharacterMenu';
		uitut.tutorialStateName = 'SpecialAttacks';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 30;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else if(scriptName == 'alternateSigns')
	{
		uitut.menuName = 'CharacterMenu';
		uitut.tutorialStateName = 'AlternateSigns';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 40;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}	
	else if(scriptName == 'inventory')
	{
		uitut.menuName = 'InventoryMenu';
		uitut.tutorialStateName = 'Inventory';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 20;
		uitut.abortOnMenuClose = true;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else if(scriptName == 'runes')
	{
		uitut.menuName = 'InventoryMenu';
		uitut.tutorialStateName = 'Runes';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.requiredGameplayFactName = "tut_runes_start";
		uitut.requiredGameplayFactValueInt = 1;
		uitut.requiredGameplayFactComparator = CO_GreaterEq;
		uitut.priority = 40;
		uitut.abortOnMenuClose = true;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else if(scriptName == 'crafting')
	{
		uitut.menuName = 'CraftingMenu';
		uitut.tutorialStateName = 'Crafting';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 20;
		uitut.abortOnMenuClose = true;
		uitut.requiredGameplayFactName = "tutorial_craft_has_ings";
		uitut.requiredGameplayFactValueInt = 1;
		uitut.requiredGameplayFactComparator = CO_GreaterEq;		
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else if(scriptName == 'craftingSet')
	{		
		uitut.menuName = 'CraftingMenu';
		uitut.tutorialStateName = 'CraftingSet';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 30;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else if(scriptName == 'craftingRecipePin')
	{
		uitut.menuName = 'CraftingMenu';
		uitut.tutorialStateName = 'RecipePinning';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 25;
		uitut.requiredGameplayFactName = "tutorial_craft_finished";
		uitut.requiredGameplayFactValueInt = 1;
		uitut.requiredGameplayFactComparator = CO_GreaterEq;
		uitut.requiredGameplayFactName2 = "tutorial_craft_pin_done";
		uitut.requiredGameplayFactValueInt2 = 1;
		uitut.requiredGameplayFactComparator2 = CO_Lesser;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	
	else if(scriptName == 'markSeen')
	{
		theGame.GetTutorialSystem().MarkMessageAsSeen(tutorialMessageName);
	}
	else if(scriptName == 'books')
	{
		
		
		
	}
	else if(scriptName == 'readingRecipe')
	{		
		uitut.menuName = 'InventoryMenu';
		uitut.tutorialStateName = 'RecipeReading';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 29;	
		uitut.abortOnMenuClose = true;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}	
	else if(scriptName == 'armorUpgrades')
	{
		uitut.menuName = 'InventoryMenu';
		uitut.tutorialStateName = 'ArmorUpgrades';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 45;
		uitut.abortOnMenuClose = true;
		uitut.requiredGameplayFactName = "tut_arm_upg_start";
		uitut.requiredGameplayFactValueInt = 1;
		uitut.requiredGameplayFactComparator = CO_GreaterEq;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}	
	else if(scriptName == 'hudMessageOn')
	{
		theGame.GetTutorialSystem().SetHudMessage(tutorialMessageName, true);
	}
	else if(scriptName == 'failsafe')
	{
		theGame.GetTutorialSystem().Failsafe();
	}	
	else if(scriptName == 'hudMessageOff')
	{
		theGame.GetTutorialSystem().SetHudMessage(tutorialMessageName, false);
	}
	else
	{
		
		TutorialScript3(scriptName, tutorialMessageName);
	}
}

function TutorialScript3(scriptName : name, tutorialMessageName : name)	
{
	var tutSystem : CR4TutorialSystem;
	var uitut : SUITutorial;
	
	if(scriptName == 'highLevelQuests')
	{
		uitut.menuName = 'JournalQuestMenu';
		uitut.tutorialStateName = 'HighLevelQuests';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 45;
		uitut.abortOnMenuClose = true;
		uitut.requiredGameplayFactName = "tut_high_level_quest";
		uitut.requiredGameplayFactValueInt = 1;
		uitut.requiredGameplayFactComparator = CO_GreaterEq;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else if( scriptName == 'UnmarkMessageAsSeen' )
	{
		theGame.GetTutorialSystem().UnmarkMessageAsSeen( tutorialMessageName );
	}
	else if(scriptName == 'ToxCloudPause')
	{
		theGame.Pause("TutorialToxicGas");
	}
	else if(scriptName == 'ToxCloudResume')
	{
		theGame.Unpause("TutorialToxicGas");
	}
	else if(scriptName == 'runewords')
	{
		uitut.menuName = 'EnchantingMenu';
		uitut.tutorialStateName = 'Runewords';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 20;
		uitut.abortOnMenuClose = true;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}	
	else if(scriptName == 'newInventory')
	{
		uitut.menuName = 'InventoryMenu';
		uitut.tutorialStateName = 'NewInventory';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 21;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else if(scriptName == 'newGeekpage')
	{
		uitut.menuName = 'InventoryMenu';
		uitut.tutorialStateName = 'NewGeekpage';
		uitut.triggerCondition = EUITTC_OnMenuOpen;
		uitut.priority = 100;
		theGame.GetTutorialSystem().uiHandler.RegisterUIHint(uitut);
	}
	else if(scriptName == 'finalizePrologue')
	{
		
		
		tutSystem = theGame.GetTutorialSystem();
		
		tutSystem.ActivateJournalEntry('TutorialCamera');
		tutSystem.ActivateJournalEntry('TutorialJournalShortTodo');
		tutSystem.ActivateJournalEntry('TutorialMinimap');
		tutSystem.ActivateJournalEntry('TutorialDialog');
		tutSystem.ActivateJournalEntry('TutorialDialogOptions');
		tutSystem.ActivateJournalEntry('TutorialDialogClose');
		tutSystem.ActivateJournalEntry('TutorialLadder');
		tutSystem.ActivateJournalEntry('TutorialLadderMove');
		tutSystem.ActivateJournalEntry('TutorialJournalJump');
		tutSystem.ActivateJournalEntry('TutorialJournalRun');
		tutSystem.ActivateJournalEntry('TutorialJournalDrawWeapon');
		tutSystem.ActivateJournalEntry('TutorialJournalLightAttacks');
		tutSystem.ActivateJournalEntry('TutorialJournalHeavyAttacks');
		tutSystem.ActivateJournalEntry('TutorialJournalDodge');
		tutSystem.ActivateJournalEntry('TutorialParry');
		tutSystem.ActivateJournalEntry('TutorialCounter');
		tutSystem.ActivateJournalEntry('TutorialJournalRadial');
		tutSystem.ActivateJournalEntry('TutorialJournalSignCast');
		tutSystem.ActivateJournalEntry('TutorialQuen');
		tutSystem.ActivateJournalEntry('TutorialIgni');
		tutSystem.ActivateJournalEntry('TutorialAard');
		tutSystem.ActivateJournalEntry('TutorialAxii');
		tutSystem.ActivateJournalEntry('TutorialYrden');
		tutSystem.ActivateJournalEntry('TutorialJournalPetards');
		tutSystem.ActivateJournalEntry('TutorialJournalSilverSword');
		tutSystem.ActivateJournalEntry('TutorialContainers');
		tutSystem.ActivateJournalEntry('TutorialJournalHorse');
		tutSystem.ActivateJournalEntry('TutorialHorseSpeed0');
		tutSystem.ActivateJournalEntry('TutorialHorseSpeed1');
		tutSystem.ActivateJournalEntry('TutorialHorseSpeed2');
		tutSystem.ActivateJournalEntry('TutorialJournalHorseStamina');
		tutSystem.ActivateJournalEntry('TutorialHorseRoad');
		tutSystem.ActivateJournalEntry('TutorialJournalDialogShop');
		tutSystem.ActivateJournalEntry('TutorialMinimapSpecialIcons');
		tutSystem.ActivateJournalEntry('TutorialJournalShopDescription');
		tutSystem.ActivateJournalEntry('TutorialStealing');
		tutSystem.ActivateJournalEntry('TutorialJournalDialogGwint');
		tutSystem.ActivateJournalEntry('TutorialAxiiDialog');
		tutSystem.ActivateJournalEntry('TutorialJournalQuestBoard');
		tutSystem.ActivateJournalEntry('TutorialFocus');
		tutSystem.ActivateJournalEntry('TutorialFocusClues');
		tutSystem.ActivateJournalEntry('TutorialSwimmingSpeed');
		tutSystem.ActivateJournalEntry('TutorialJournalDive');
		tutSystem.ActivateJournalEntry('TutorialOxygen');
		tutSystem.ActivateJournalEntry('TutorialJournalTargetting');
		tutSystem.ActivateJournalEntry('TutorialJournalCrossbow');
		tutSystem.ActivateJournalEntry('TutorialJournalStaminaExploration');
		tutSystem.ActivateJournalEntry('TutorialJournalQuestArea');
		tutSystem.ActivateJournalEntry('TutorialJournalMeditation');
		tutSystem.ActivateJournalEntry('TutorialJournalRepairObjects');
		tutSystem.ActivateJournalEntry('TutorialJournalAlchemyLoot');
		tutSystem.ActivateJournalEntry('TutorialJournalFocusRedObjects');
		tutSystem.ActivateJournalEntry('TutorialHorseSummon');
		tutSystem.ActivateJournalEntry('TutorialJournalPotions');
		tutSystem.ActivateJournalEntry('TutorialJournalCharDevLeveling');
		tutSystem.ActivateJournalEntry('TutorialJournalCharDevSkills');
		tutSystem.ActivateJournalEntry('TutorialJournalCharDevGroups');
		tutSystem.ActivateJournalEntry('TutorialJournalFastTravel');
		
		
		tutSystem.MarkMessageAsSeen('TutorialFocusClues');
	}
}

quest function TutorialRegisterUIHint(data : SUITutorial)
{
	
	if(!theGame.GetTutorialSystem() || !theGame.GetTutorialSystem().IsRunning())
		return;
		
	theGame.GetTutorialSystem().uiHandler.RegisterUIHint(data);
}



quest function HAX_Debug_TutorialStartInTheMiddle()
{
	
	if(!theGame.GetTutorialSystem() || !theGame.GetTutorialSystem().IsRunning())
		return;
		
	
	if(theGame.GetTutorialSystem().AreMessagesEnabled())
		return;
	
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialMovement', true);
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialCamera', true);
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialQuestTodo', true);
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialMinimap', true);
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialQuestLog', true);
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialDoor', true);
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialDialog', true);
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialDialogOptions', true);
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialDialogClose', true);
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialRun', true);
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialLadder', true);
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialExplorations', true);
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialSprintJump', true);
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialDrawWeapon', true);
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialLightAttacks', true);
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialHeavyAttacks', true);
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialDodge', true);
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialParry', true);
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialCounter', true);
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialRadial', true);
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialSelectQuen', true);
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialQuen', true);
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialIgni', true);
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialSignToggle', true);
	theGame.GetTutorialSystem().HAX_DEBUG_ForceTutorialMessageAsSeen('TutorialAard', true);
}

quest function TutorialHintHide(journalEntry : name)
{
	
	if(!theGame.GetTutorialSystem() || !theGame.GetTutorialSystem().IsRunning())
		return;
		
	theGame.GetTutorialSystem().HideTutorialHint(journalEntry);
}

quest function TutorialHintFeedback(tutorialMessageName : name, negative : bool)
{
	
	if(!theGame.GetTutorialSystem() || !theGame.GetTutorialSystem().IsRunning())
		return;
		
	if(theGame.GetTutorialSystem() && theGame.GetTutorialSystem().IsRunning())
		theGame.GetTutorialSystem().HintFeedback(tutorialMessageName, negative);
}

quest function TutorialMessage(message : STutorialMessage)
{
	
	if(!theGame.GetTutorialSystem())
		return;
	
	
	if(!theGame.GetTutorialSystem().IsRunning())
		return;
	
	theGame.GetTutorialSystem().DisplayTutorial(message);
}

quest function TutorialsSetGameplaySettings( enable : bool )
{
	
	if( theGame.IsFinalBuild() )
	{
		TutorialMessagesEnable( enable );
	}
}

struct SRadialDesaturation
{
	editable var value : bool;
	editable var fieldName : name;
};

quest function TutorialRadialDesaturation(data : array<SRadialDesaturation>)
{
	var i : int;
	var slots : array<name>;
	
	for(i=0; i<data.Size(); i+=1)
	{
		slots.PushBack(data[i].fieldName );
		
		thePlayer.EnableRadialSlotsWithSource ( !data[i].value, slots, 'tutorial' );
		slots.Clear();
	}
}

function TutorialMessagesEnable(optional enable : bool)
{
	var inGameConfigWrapper	: CInGameConfigWrapper;
	
	inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
	
	if(!enable)
	{
		inGameConfigWrapper.SetVarValue('Gameplay', 'HudTutorialEnabled', "false");
		theGame.GetTutorialSystem().SetHudMessage('', false);	
	}
	else
	{
		inGameConfigWrapper.SetVarValue('Gameplay', 'HudTutorialEnabled', "true");
	}
}

exec function tut_scr(scriptName : name)
{
	TutorialMessagesEnable(true);
	theGame.GetTutorialSystem().TutorialStart(false);
	TutorialScript(scriptName, '');
}


quest function TutorialForceSecondLevel(minExpToGive : int)
{
	var witcher : W3PlayerWitcher;
	var exp : int;
	
	witcher = GetWitcherPlayer();
	
	if(witcher.GetLevel() < 2)
	{		
		exp = witcher.levelManager.GetTotalExpForNextLevel() - witcher.levelManager.GetPointsTotal(EExperiencePoint);
		exp = Max(minExpToGive, exp);
	}
	else
	{
		exp = minExpToGive;
	}
	
	witcher.AddPoints(EExperiencePoint, exp, true );
}


function ShouldProcessTutorial(scriptName : name) : bool
{
	
	if(!theGame.GetTutorialSystem() || !theGame.GetTutorialSystem().IsRunning())
		return false;
		
	return !theGame.GetTutorialSystem().HasSeenTutorial(scriptName);
}

function ShouldProcessInteractionTutorials() : bool
{
	
	if(!theGame.GetTutorialSystem() || !theGame.GetTutorialSystem().IsRunning())
		return false;
		
	if(!theGame.GetTutorialSystem() || !theGame.GetTutorialSystem().IsRunning())
		return false;
		
	if(!theGame.GetTutorialSystem().HasSeenTutorial('TutorialContainers'))
		return true;
		
	if(!theGame.GetTutorialSystem().HasSeenTutorial('TutorialDialog'))
		return true;	
	
	if(!theGame.GetTutorialSystem().HasSeenTutorial('TutorialFocusClues'))
		return true;
		
	if(!theGame.GetTutorialSystem().HasSeenTutorial('TutorialRepairObjects'))
		return true;	
		
	if(!theGame.GetTutorialSystem().HasSeenTutorial('TutorialBoatMount'))
		return true;		
		
	if(!theGame.GetTutorialSystem().HasSeenTutorial('TutorialFastTravelInteraction'))
		return true;			
	
	if(!theGame.GetTutorialSystem().HasSeenTutorial('TutorialCampfire'))
		return true;
	
	if(!theGame.GetTutorialSystem().HasSeenTutorial('TutorialMonsterNest'))
		return true;
		
	if(!theGame.GetTutorialSystem().HasSeenTutorial('TutorialCraftsman'))
		return true;

	if(!theGame.GetTutorialSystem().HasSeenTutorial('TutorialRepairObjectArmor'))
		return true;
		
	if(!theGame.GetTutorialSystem().HasSeenTutorial('TutorialRepairObjectWeapon'))
		return true;
	
	if(!theGame.GetTutorialSystem().HasSeenTutorial('TutorialStash'))
		return true;
		
	return false;
}
