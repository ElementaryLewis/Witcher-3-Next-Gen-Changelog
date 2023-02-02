/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/
quest function EnableNewGamePlus( enable : bool )
{
	theGame.EnableNewGamePlus( enable );
}

quest function SetTimeScaleQuest(timeScale : float)
{
	theGame.SetTimeScale(timeScale, 'SetTimeScaleQuest', 100, false, true );
}

quest function LaunchCredits()
{
	theGame.GetGuiManager().RequestCreditsMenu(CreditsIndex_Wither3);
}

quest function LaunchCreditsEP1()
{
	theGame.GetGuiManager().RequestCreditsMenu(CreditsIndex_Ep1);
}

quest function LaunchCreditsEP2()
{
	theGame.GetGuiManager().RequestCreditsMenu(CreditsIndex_Ep2);
}

quest function MessageDialogPopup( locMessage : string )
{
	theGame.GetGuiManager().ShowUserDialog(UMID_QuestBlockMessage, "", locMessage, UDB_Ok);
}

enum EFactValueChangeMethod
{
	FVCM_Add,
	FVCM_Substract,
	FVCM_Multiply,
	FVCM_Divide,
}



latent function OpenContainerQuest( npcTag : CName, optional tagsFilter : array<name> )
{
	var containerOwner    : CGameplayEntity;
	
	if ( npcTag == ''  )
	{
		return;
	}
	containerOwner = (CGameplayEntity)theGame.GetEntityByTag( npcTag );
	if ( !containerOwner )
	{
		return;
	}
	
	OpenInventoryForScene(containerOwner, tagsFilter);
	
}

latent quest function CollectItemsQuest ( collectorTag : name, items : array<name>, uniqueTransactionId : string, keepItemsInContainer : bool, optional filterTagsList : array<name>, optional singleItemContainer : bool ) : bool
{
	var popupData : W3ItemSelectionPopupData;
	var itemSelectionPopup : CR4ItemSelectionPopup;
	var inventory : CInventoryComponent;
	var received, alreadyCollected : bool;
	var factId : string;
	var i, collectedCount : int = 0;	
	var result : bool;
	var ent : CGameplayEntity;
	var itemsBeforeChange : array<name>;
	var itemsAfterChange : array<name>;
	
	ent = (CGameplayEntity)theGame.GetEntityByTag( collectorTag );
	if( !ent )
	{
		return false;
	}
	
	inventory = ent.GetInventory();		
	itemsBeforeChange = inventory.GetItemsNames();
	theGame.GetGuiManager().SetLastOpenedCommonMenuName( 'None' ); 		
	
	if (singleItemContainer)
	{
		popupData = new W3ItemSelectionPopupData in theGame.GetGuiManager();
		popupData.targetInventory = inventory;
		popupData.collectorTag = collectorTag;
		popupData.filterTagsList = filterTagsList;
		popupData.targetItems = items;
		
		theGame.RequestPopup('ItemSelectionPopup', popupData);
		
		while (popupData)
		{
			SleepOneFrame();
		}
	}
	else
	{
		OpenContainerQuest( collectorTag, filterTagsList);		
		
		while( theGame.GetGuiManager().GetLastOpenedCommonMenuName() == 'None' ) 
		{ 
			SleepOneFrame();
		}
    }
    
	itemsAfterChange = inventory.GetItemsNames();
	for( i = itemsAfterChange.Size() - 1; i >= 0 ; i-=1  )
	{
		if( itemsBeforeChange.Contains( itemsAfterChange[ i ] ) )
		{
			itemsAfterChange.Erase( i );
		}
	}
	
	if( itemsAfterChange.Size() == 0 )
	{
		return false;
	}

	for( i = 0; i < items.Size(); i+=1  )
	{
		factId = uniqueTransactionId + "_" + items[i];
		received = itemsAfterChange.Contains( items[i] );
		alreadyCollected = FactsQuerySum( factId ) > 0;
		
		if( alreadyCollected )
			collectedCount += 1;
		
		if( received )
		{
			if( !alreadyCollected )
			{				
				FactsAdd( factId );
				if (!keepItemsInContainer)
				{
					inventory.RemoveItemByName( items[i] );
				}
				collectedCount += 1;
				result = true;
			}
			else if( result != true )		
			{			
				result = false;
			}					
		}
	}
	
	
		
	return result;
}



quest function ModifyFactValueQuest( fact : string, action : EFactValueChangeMethod, value : float )
{
	var factValue : int;
	factValue = FactsQuerySum( fact );
	
	switch ( action )
	{
		case FVCM_Add :
		{
			factValue = RoundF(factValue + value);
		}
		break;
		
		case FVCM_Substract :
		{
			factValue = RoundF(factValue - value);
		}
		break;
		
		case FVCM_Multiply :
		{
			factValue = RoundF(factValue * value);
		}
		break;		
		
		case FVCM_Divide :
		{
			factValue = RoundF(factValue / value);
		}
		break;		
	}

	FactsSet( fact, factValue, -1 );

} 


quest function RemoveItemAmmoQuest( itemName : name, amount : int )
{
	var ids : array<SItemUniqueId>;
	var inv : CInventoryComponent;
	
	inv = thePlayer.inv;
	ids = inv.GetItemsByName( itemName );
	inv.SingletonItemRemoveAmmo( ids[0], amount );
}


quest function EnableGlossaryImageOverrideQuest( uniqueEntryTag : name, imageFileName : string, enable : bool )
{
	thePlayer.EnableGlossaryImageOverride( uniqueEntryTag, imageFileName, enable );
}

quest function MonsterHuntInvestigationAreaManager( tag : name, enable: bool )
{
	var entitesList : array<CEntity>;
	var area		: W3MonsterHuntInvestigationArea;
	var i 			: int;
	
	theGame.GetEntitiesByTag( tag, entitesList );
	
	for(i=0; i<entitesList.Size(); i+=1)
	{
		area = ( W3MonsterHuntInvestigationArea ) entitesList[i];
		
		if( area )
		{
			area.SetInvestigationAreaEnabled( enable );
		}
	}
}


quest function Q202GiantDisableHitAnim( tag : name, enable : bool )
{
	var actors : array<CActor>;
	var i 			: int;
	
	theGame.GetActorsByTag( tag, actors );
	
	for(i=0; i<actors.Size(); i+=1)
	{
		actors[i].SetCanPlayHitAnim( enable );
	}
}

quest function ActorBreakQuen(actorTag : name, skipVisuals : bool)
{
	var actor : CActor;
	
	if(actorTag == '' || actorTag == 'PLAYER')
	{
		actor = thePlayer;
	}
	else
	{
		actor = theGame.GetNPCByTag(actorTag);
	}
	
	if(actor)
		actor.FinishQuen(skipVisuals);
}


quest function DisableHerbsOnMinimapQuest ( disableHerbs : bool )
{
	if(!disableHerbs)
	{
		FactsRemove( "disable_herbs_on_minimap" );
	}
	else
	{
		FactsAdd( "disable_herbs_on_minimap", 1 );
	}
}

enum EMapPinStatus
{
	EMPS_Undefined,
	EMPS_Known,
	EMPS_Discovered,
	EMPS_Disabled
}





quest function SetMapPinStatus( type : EMapPinStatus, tag : name, set : bool, dontChangeIfKnown : bool, dontChangeIfDiscovered : bool )
{
	var i 			: int;
	var mapManager 	: CCommonMapManager = theGame.GetCommonMapManager();
	
	if ( !mapManager )
	{
		return;
	}
	
	if( dontChangeIfKnown )
	{
		if ( mapManager.IsEntityMapPinKnown( tag ) )
		{
			return;
		}
	}
	
	if( dontChangeIfDiscovered )
	{
		if ( mapManager.IsEntityMapPinDiscovered( tag ) )
		{
			return;
		}
	}	
	
	switch ( type )
	{
		case EMPS_Undefined:
			break;
		case EMPS_Known:
			mapManager.SetEntityMapPinKnown( tag, set );
			break;
		case EMPS_Discovered:
			mapManager.SetEntityMapPinDiscovered( tag, set );
			break;
		case EMPS_Disabled:
			mapManager.SetEntityMapPinDisabled( tag, set );
			break;
	}
}







quest function SetMapPinStatusEx( type : EMapPinStatus, tag : name, set : bool, dontChangeIfKnown : bool, dontChangeIfDiscovered : bool )
{
	var i 			: int;
	var mapManager 	: CCommonMapManager = theGame.GetCommonMapManager();
	
	if ( !mapManager )
	{
		return;
	}
	
	if( dontChangeIfKnown )
	{
		if ( mapManager.IsEntityMapPinKnown( tag ) )
		{
			return;
		}
	}
	
	if( dontChangeIfDiscovered )
	{
		if ( mapManager.IsEntityMapPinDiscovered( tag ) )
		{
			return;
		}
	}	
	
	switch ( type )
	{
		case EMPS_Undefined:
			break;
		case EMPS_Known:
			mapManager.SetEntityMapPinKnown( tag, set );
			break;
		case EMPS_Discovered:
			mapManager.SetEntityMapPinDiscoveredScript( false, tag, set );
			break;
		case EMPS_Disabled:
			mapManager.SetEntityMapPinDisabled( tag, set );
			break;
	}
}

latent quest function SetupTrophySceneQuest( monsterTag : name, offset : float)
{
	var witcher : W3PlayerWitcher;
	var monster : CNewNPC;
	var newPosition	 : Vector;
	var playerPosition	 : Vector;
	var Position : Vector;
	var Rotation : EulerAngles;	
	var placementNode  : CNode;
	var placementNodes  : array<CNode>;
	var z : float;
	var curDistance : float;
	var minDistance : float;
	
	var i : int;

	witcher = GetWitcherPlayer();

	if( witcher )
	{
		playerPosition = thePlayer.GetWorldPosition();
		
		theGame.GetNodesByTag( 'mh_trophy_safe_placement_point', placementNodes );
		
		if( placementNodes.Size() > 0 )
		{
			for(i=0; i < placementNodes.Size(); i += 1 ) 
			{
				curDistance = VecDistance2D( placementNodes[i].GetWorldPosition(), playerPosition );
				
				if( minDistance == 0.0f || curDistance  <= minDistance )
				{
					minDistance = curDistance;
					placementNode = placementNodes[i];
				}
			}
			
			
			newPosition = placementNode.GetWorldPosition();
			
			if( theGame.GetWorld().NavigationFindSafeSpot( newPosition, 1.0, 6.0, newPosition ) )
			{
				if ( theGame.GetWorld().NavigationComputeZ(newPosition, newPosition.Z - 5.0, newPosition.Z + 5.0, z) )
				{
					newPosition.Z = z;
					if ( !theGame.GetWorld().NavigationFindSafeSpot( newPosition, 1.0, 6.0, newPosition ) )
						return;
				}
				
				witcher.TeleportWithRotation(newPosition, placementNode.GetWorldRotation() );
				
				Sleep(0.3f);
				
				monster = (CNewNPC) theGame.GetEntityByTag( monsterTag );
				
				if( monster )
				{
					if( offset == 0.0 )
						offset = 2.0;
					
					Position = witcher.GetWorldPosition();
					Rotation = witcher.GetWorldRotation();
					
					newPosition = Vector(Position.X, Position.Y, Position.Z) + witcher.GetHeadingVector() * offset;
					
					if ( theGame.GetWorld().NavigationComputeZ(newPosition, newPosition.Z - 5.0, newPosition.Z + 5.0, z) )
					{
						newPosition.Z = z;
						if ( !theGame.GetWorld().NavigationFindSafeSpot( newPosition, 1.0, 6.0, newPosition ) )
							return;
					}
					
					monster.TeleportWithRotation(newPosition, EulerNeg(Rotation, EulerAngles(0.0,-90.0,0.0) ) );
					Sleep(0.3f);
				}	
				
			}
			
		}
	}
}


latent quest function ProcessMonsterHuntTrophyQuest( trophyName : name, dontTeleportHorse : bool)
{
	var playerHorse			 : CNewNPC;
	var playerPosition 		 : Vector;
	var newPosition			 : Vector;
	var playerRotation 		 : EulerAngles;
	var witcher 			 : W3PlayerWitcher;
	var ids    				 : array<SItemUniqueId>;
	var eqId	 			 : SItemUniqueId;
	var horseManager		 : W3HorseManager;
	var horse				 : CNewNPC;
	
	witcher = GetWitcherPlayer();	
	playerHorse = (CNewNPC) witcher.GetHorseWithInventory();
	
	if( !dontTeleportHorse )
	{
		if(playerHorse)
		{
			playerPosition = witcher.GetWorldPosition();
			playerRotation = witcher.GetWorldRotation();
			
			newPosition = Vector(playerPosition.X, playerPosition.Y, playerPosition.Z + 0.1);
			
			if( theGame.GetWorld().NavigationFindSafeSpot( newPosition, 2.0, 6.0, newPosition ) )
			{
				playerHorse.TeleportWithRotation(playerPosition + witcher.GetHeadingVector() * 1.5, EulerNeg(playerRotation, EulerAngles(0.0,-90.0,0.0) ) );
			}
		}
	}
	
	ids = witcher.inv.GetItemsByName( trophyName );
	
	if( ids.Size() > 0 )
	{
		horseManager = witcher.GetHorseManager();
		
		if(horseManager)
		{
			eqId = witcher.GetHorseManager().MoveItemToHorse(ids[0]);
			horseManager.EquipItem(eqId);
		}
		else
		{
			
			horse = (CNewNPC)theGame.GetNodeByTag('playerHorse');
			ids = horse.GetInventory().AddAnItem( trophyName , 1);
			horse.GetInventory().MountItem( ids[0] );
		}
	}
	
	Sleep(0.5f);
}

quest function AlwaysDisplayWolfHead( display : bool )
{
	var hud : CR4ScriptedHud;	
	var wolfHeadModule : CR4HudModuleWolfHead;

	hud = (CR4ScriptedHud)theGame.GetHud();	
	
	if(hud)
	{
		wolfHeadModule = (CR4HudModuleWolfHead)hud.GetHudModule("WolfHeadModule");
		
		if(wolfHeadModule)
		{
			wolfHeadModule.SetAlwaysDisplayed( display );
		}
	}
}

quest function AlwaysDisplayItemInfo( display : bool )
{
	var hud : CR4ScriptedHud;	
	var itemInfoModule : CR4HudModuleItemInfo;

	hud = (CR4ScriptedHud)theGame.GetHud();	
	
	if(hud)
	{
		itemInfoModule = (CR4HudModuleItemInfo)hud.GetHudModule("ItemInfoModule");
		
		if(itemInfoModule)
		{
			itemInfoModule.SetAlwaysDisplayed( display );
		}
	}
}

latent quest function DisplayPortalConfirmationPopup( pauseGame : bool ) : bool
{
	var guiManager : CR4GuiManager;
	
	guiManager = theGame.GetGuiManager();
	guiManager.SetUsePortal( false, false );
	guiManager.DisplayPortalConfirmationPopup(pauseGame, false);
	
	while( !guiManager.GetUsePortalAnswered() )
	{
		Sleep(0.1f);
	}
	
	return guiManager.GetUsePortal();
}

quest function DisplaySimplePopup( title : string, text : string, pauseGame : bool )
{
	var guiManager : CR4GuiManager;
	
	guiManager = theGame.GetGuiManager();
	if ( !guiManager )
	{
		return;
	}
	
	theGame.GetGuiManager().ShowUserDialog( UMID_NoFeedbackRequired, title, text, UDB_Ok );
}

quest function BankCollectBillOfExchangeQuest( baseBillPrice : int )
{
	var 	   witcher : W3PlayerWitcher;
	var 	   inv     : CInventoryComponent;
	var 	  horseInv : CInventoryComponent;
	var 	billsCount : int;
	
	witcher = GetWitcherPlayer();
	
	inv = witcher.inv;
	horseInv = witcher.GetHorseManager().GetInventoryComponent();
	
	billsCount = inv.GetItemQuantityByName('vivaldis_bill_of_exchange') + horseInv.GetItemQuantityByName('vivaldis_bill_of_exchange');
	
	if( billsCount > 0)
	{
		inv.RemoveItemByName( 'vivaldis_bill_of_exchange', -1);
		witcher.HorseRemoveItemByName( 'vivaldis_bill_of_exchange', -1);
		
		
		thePlayer.DisplayItemRewardNotification('Crowns', (int)( billsCount * baseBillPrice ) );
		inv.AddAnItem( 'Crowns', billsCount * baseBillPrice, true, true );
		
	}
	
}

quest function BankCurrencyExchangeQuest( orensExchangeModifier : float, florensExchangeModifier : float )
{
	var 	   witcher : W3PlayerWitcher;
	var 	   inv     : CInventoryComponent;
	var 	  horseInv : CInventoryComponent;
	var 		     i : int;
	var 	  sumValue :  float;

	
	witcher = GetWitcherPlayer();
	inv = witcher.inv;
	horseInv = witcher.GetHorseManager().GetInventoryComponent();
		
	sumValue += inv.GetItemQuantityByName('Orens') * orensExchangeModifier;
	sumValue += inv.GetItemQuantityByName('Florens') * florensExchangeModifier;

	sumValue += horseInv.GetItemQuantityByName('Orens') * orensExchangeModifier;
	sumValue += horseInv.GetItemQuantityByName('Florens') * florensExchangeModifier;
	
	inv.RemoveItemByName( 'Orens', -1);
	inv.RemoveItemByName( 'Florens', -1);
	
	witcher.HorseRemoveItemByName( 'Orens', -1);
	witcher.HorseRemoveItemByName( 'Florens', -1);
	
	if(sumValue < 1.0) sumValue = 1.0;

	thePlayer.DisplayItemRewardNotification('Crowns', (int) sumValue );
	inv.AddAnItem( 'Crowns', (int) sumValue, true, true );
	

}

quest function FactBasedRewardQuest( baseRewardValue : int, factMultiplier : string )
{
    var 	   	   witcher : W3PlayerWitcher;
	var 		   inv : CInventoryComponent;
	var 		   finalReward : int;

	witcher = GetWitcherPlayer();
	inv = witcher.inv;
	if( FactsQuerySum( factMultiplier ) )
	{
		finalReward = FactsQuerySum( factMultiplier ) * baseRewardValue;
		thePlayer.DisplayItemRewardNotification( 'Crowns', finalReward );
		inv.AddAnItem( 'Crowns', finalReward, true, true );
	}
}



quest function SetGeraltHairQuest( hairstyleName : name )
{
	var inv : CInventoryComponent;
	var witcher : W3PlayerWitcher;
	var ids : array<SItemUniqueId>;
	var size : int;
	var i : int;

	witcher = GetWitcherPlayer();
	inv = witcher.GetInventory();

	ids = inv.GetItemsByCategory( 'hair' );
	size = ids.Size();
	
	if( size > 0 )
	{
		
		for( i = 0; i < size; i+=1 )
		{
			inv.RemoveItem(ids[i], 1);	
		}
		
	}
	ids = inv.AddAnItem( hairstyleName );
	inv.MountItem(ids[0]);
}

quest function SetGeraltTorsoQuest( torsoName : name )
{
	var inv : CInventoryComponent;
	var witcher : W3PlayerWitcher;
	var ids : array<SItemUniqueId>;
	var size : int;
	var i : int;

	witcher = GetWitcherPlayer();
	inv = witcher.GetInventory();

	ids = inv.GetItemsByCategory( 'armor' );
	size = ids.Size();
	
	if( size > 0 )
	{
		for( i = 0; i < size; i+=1 )
		{
			if(inv.ItemHasTag( ids[i], 'Body' ) )
			{
				inv.RemoveItem(ids[i], 1);	
			}
		}
		
	}

	ids = inv.AddAnItem( torsoName );
	inv.MountItem(ids[0]);
}

quest function SetGeraltPalmsQuest( palmsName : name )
{
	var inv : CInventoryComponent;
	var witcher : W3PlayerWitcher;
	var ids : array<SItemUniqueId>;
	var size : int;
	var i : int;

	witcher = GetWitcherPlayer();
	inv = witcher.GetInventory();

	ids = inv.GetItemsByCategory( 'gloves' );
	size = ids.Size();
	
	if( size > 0 )
	{
		
		for( i = 0; i < size; i+=1 )
		{
			if(inv.ItemHasTag( ids[i], 'Body' ) )
			{
				inv.RemoveItem(ids[i], 1);	
			}
		}
		
	}
	ids = inv.AddAnItem( palmsName );
	inv.MountItem(ids[0]);
}



quest function E3TurnOffDebugPagesFromFastMenu( turnOn: bool ) 
{
	if (turnOn)
		FactsAdd("DebugPagesOff", 1);
	else
		FactsRemove("DebugPagesOff");
}

quest function HealthBarVisiblityQuest( npcTag : name, show : bool )
{
	var npc : CNewNPC;		
	var npcs : array <CNewNPC>;
	var tags : array<name>;
	var i      : int;
	
	theGame.GetNPCsByTag(npcTag,npcs);
	if ( npcs.Size() <= 0 ) 
	{
		LogQuest("AddTagToNPCsQuest_questFunction: no NPC with tag " + npcTag + " found!!!");
		return;
	}
	
	for ( i=0 ; i < npcs.Size() ; i+=1 )
	{
		npc = npcs[i];
		tags =  npc.GetTags();
		
		if ( !show )
		{
			tags.PushBack('HideHealthBarModule');
		}
		else
		{
			if ( !tags.Remove('HideHealthBarModule') )
			{
				LogQuest("AddTagToNPCsQuest_questFunction: npc doesn't have " + npcTag + " tag!!! ");
				continue;
			}
		}
		npc.SetTags(tags);
	}
}

quest function EnableBuffedMonsterDisplay( value : bool )
{
	var hud : CR4ScriptedHud;
	hud = (CR4ScriptedHud)theGame.GetHud();
	if( hud )
	{
		hud.EnableBuffedMonsterDisplay(value);
	}
}


quest function DetonatePetardQuest ( targetTag : name, detonationDelay : float )
{

	var petards	: array< CNode >;
	var petard	: W3Petard;
	var i, size 	: int;
	
	if ( targetTag == '' )
	{
		LogQuest( "Quest function <<DetonatePetardQuest>>: empty tag!");	
		return;
	}
	
	theGame.GetNodesByTag( targetTag, petards );
	size = petards.Size();	
	for ( i = 0; i < size; i += 1 )
	{
		petard = (W3Petard)petards[i];		
		if ( petard )
		{
			if( detonationDelay == 0.0)
			{
				petard.ProcessEffect();
			}
			else
			{
				petard.AddTimer( 'DetonationTimer', detonationDelay, , , , true );
			}
		}
	}
}




quest function SetMorphBlendQuest( targetTag: name, morphRatio : float, blendTime : float )
{
	var entity : CEntity;
	var manager : CMorphedMeshManagerComponent;

	entity = theGame.GetEntityByTag( targetTag );

	if(entity)
	{
		manager = (CMorphedMeshManagerComponent) entity.GetComponentByClassName('CMorphedMeshManagerComponent');
		
		if(manager)
		{
			manager.SetMorphBlend( morphRatio, blendTime );
		}
		
	}
}

quest function ForceShowUpdateInfo(locKeyText : string, locKeyTitle : string  )
{
	var hud : CR4ScriptedHud;	
	var journalUpdateModule : CR4HudModuleJournalUpdate;

	hud = (CR4ScriptedHud)theGame.GetHud();	
	
	if(hud)
	{
		journalUpdateModule = (CR4HudModuleJournalUpdate)hud.GetHudModule("JournalUpdateModule");
		
		if(journalUpdateModule)
		{
			journalUpdateModule.ForceAddJournalUpdateInfo(locKeyText, locKeyTitle );
		}
	}
}

latent quest function ShowStartScreen(fadeOutTime : float, fadeInTime : float, endWithBlackscreen : bool, isStageDemo : bool)
{
	thePlayer.SetStartScreenFadeDuration(fadeOutTime);
	thePlayer.SetStartScreenEndWithBlackScreen(endWithBlackscreen);
	thePlayer.SetStartScreenFadeInDuration(fadeInTime);
	thePlayer.SetStartScreenIsOpened(true);
	
	
	theGame.RequestMenu('StartScreenMenu');
	
	while(thePlayer.GetStartScreenIsOpened())
	{
		Sleep(0.1);
	}
}

latent quest function ShowEndScreen(fadeOutTime : float, fadeInTime : float, isStageDemo : bool)
{
	thePlayer.SetStartScreenFadeDuration(fadeOutTime);
	thePlayer.SetStartScreenFadeInDuration(fadeInTime);
	thePlayer.SetEndScreenIsOpened(true);
	
	
	theGame.RequestMenu('EndScreenMenu');
	
	while(thePlayer.GetEndScreenIsOpened())
	{
		Sleep(0.1);
	}
}

quest function ShowCompanionIndicator( enable:bool, npcTag : name, optional iconPath : string, optional npcTag2 : name, optional iconPath2 : string )
{
	var hud : CR4ScriptedHud;	
	var companionModule : CR4HudModuleCompanion;
	var npc : CNewNPC;
	var npc2 : CNewNPC;

	npc = theGame.GetNPCByTag( npcTag );
	if ( !npc )
	{
		enable = false; 
	}
	if ( !enable )
	{
		npc = NULL;
	}
		
	
	hud = (CR4ScriptedHud)theGame.GetHud();	
	if ( hud )
	{
		companionModule = (CR4HudModuleCompanion)hud.GetHudModule("CompanionModule");
		if ( companionModule )
		{
			companionModule.ShowCompanion( enable, npcTag, iconPath );
			
			if ( enable ) 
			{
				if ( npc.GetStat( BCS_Essence, true ) < 0 )
				{
					if ( theGame.GetDifficultyMode() == EDM_Hard && !npc.HasAbility('_combatFollowerHardV') ) npc.AddAbility('_combatFollowerHardV', false);
					else if ( theGame.GetDifficultyMode() == EDM_Hardcore && !npc.HasAbility('_combatFollowerHardcoreV') ) npc.AddAbility('_combatFollowerHardcoreV', false);
				} else
				if ( npc.GetStat( BCS_Vitality, true ) < 0 )
				{
					if ( theGame.GetDifficultyMode() == EDM_Hard && !npc.HasAbility('_combatFollowerHardE') ) npc.AddAbility('_combatFollowerHardE', false);
					else if ( theGame.GetDifficultyMode() == EDM_Hardcore && !npc.HasAbility('_combatFollowerHardcoreE') ) npc.AddAbility('_combatFollowerHardcoreE', false);
				} 
			}
			
			npc2 = theGame.GetNPCByTag( npcTag2 );
			if( npc2 )
			{
				companionModule.ShowCompanionSecond( npcTag2, iconPath2 );
				
				if ( npc2.GetStat( BCS_Essence, true ) < 0 )
				{
					if ( theGame.GetDifficultyMode() == EDM_Hard && !npc2.HasAbility('_combatFollowerHardV') ) npc2.AddAbility('_combatFollowerHardV', false);
					else if ( theGame.GetDifficultyMode() == EDM_Hardcore && !npc2.HasAbility('_combatFollowerHardcoreV') ) npc2.AddAbility('_combatFollowerHardcoreV', false);
				} else
				if ( npc2.GetStat( BCS_Vitality, true ) < 0 )
				{
					if ( theGame.GetDifficultyMode() == EDM_Hard && !npc2.HasAbility('_combatFollowerHardE') ) npc2.AddAbility('_combatFollowerHardE', false);
					else if ( theGame.GetDifficultyMode() == EDM_Hardcore && !npc2.HasAbility('_combatFollowerHardcoreE') ) npc2.AddAbility('_combatFollowerHardcoreE', false);
				}
				
			}
		}
	}
}

quest function ShowBossFightIndicator(enable:bool, bossTag : name)
{
	theGame.GetGuiManager().GetHudEventController().RunEvent_BossFocusModule_ShowBossIndicator( enable, bossTag );
}

quest function ActivateQuestBonus( merchantTag : name )
{
	var merchantActor : W3MerchantNPC;

	merchantActor = ( ( W3MerchantNPC ) theGame.GetNPCByTag( merchantTag ) );

	if( merchantActor )
	{
		merchantActor.ActivateQuestBonus();
	}
}

quest function SetShopPriceMultiplier( priceMult : float, merchantTag : name )
{
	var merchantActor : CActor;
	
	merchantActor = theGame.GetActorByTag(merchantTag);
	
	if( merchantActor )
	{
		((CInventoryComponent)merchantActor.GetComponentByClassName( 'CInventoryComponent' )).SetPriceMultiplier( priceMult );
	}
}

quest function OpenMeditation()
{
	GetWitcherPlayer().Meditate();
}


quest function ShaveGeralt_Quest()
{
	var acs : array< CComponent >;
	
	acs = thePlayer.GetComponentsByClassName( 'CHeadManagerComponent' );
	( ( CHeadManagerComponent ) acs[0] ).Shave();
}


quest function SetGeraltBeard_Quest( maxBeard : bool, optional stage : int )
{
	var acs : array< CComponent >;
	
	acs = thePlayer.GetComponentsByClassName( 'CHeadManagerComponent' );
	( ( CHeadManagerComponent ) acs[0] ).SetBeardStage( maxBeard, stage);
}


quest function SetTattoo_Quest( hasTattoo : bool )
{
	var acs : array< CComponent >;
	
	acs = thePlayer.GetComponentsByClassName( 'CHeadManagerComponent' );
	( ( CHeadManagerComponent ) acs[0] ).SetTattoo( hasTattoo );
}


quest function SetDemonMarkQuest( hasDemonMark : bool )
{
	var acs : array< CComponent >;
	
	acs = thePlayer.GetComponentsByClassName( 'CHeadManagerComponent' );
	( ( CHeadManagerComponent ) acs[0] ).SetDemonMark( hasDemonMark );
}



quest function BlockBeardGrowth_Quest( optional block : bool )
{
	var acs : array< CComponent >;
	
	acs = thePlayer.GetComponentsByClassName( 'CHeadManagerComponent' );
	( ( CHeadManagerComponent ) acs[0] ).BlockGrowing( block );
}


quest function SetCustomHead_Quest( head : name, barberSystem : bool )
{
	var acs : array< CComponent >;
	
	if( barberSystem )
	{
		thePlayer.RememberCustomHead( head );
	}
	
	acs = thePlayer.GetComponentsByClassName( 'CHeadManagerComponent' );
	( ( CHeadManagerComponent ) acs[0] ).SetCustomHead( head );
}


quest function RemoveCustomHead_Quest( barberSystem : bool)
{
	var acs : array< CComponent >;
	var barberHead : name;
	
	acs = thePlayer.GetComponentsByClassName( 'CHeadManagerComponent' );

	if(!barberSystem)
	{
		barberHead = thePlayer.GetRememberedCustomHead();
		
		if( IsNameValid(barberHead) )
		{
			( ( CHeadManagerComponent ) acs[0] ).SetCustomHead( barberHead );
		}
		else
		{
			( ( CHeadManagerComponent ) acs[0] ).RemoveCustomHead();
		}
	}
	else
	{
		thePlayer.ClearRememberedCustomHead();
		( ( CHeadManagerComponent ) acs[0] ).RemoveCustomHead();
	}
}


quest function CopyPlayersEquipmentToNPCQuest(npcTag : name, copyHead : bool, dontCopyHair: bool)
{
	var npc : CNewNPC;
	var inv : CInventoryComponent;
	var witcher : W3PlayerWitcher;
	var item : SItemUniqueId;
	var ids : array<SItemUniqueId>;
	var i : int;
	var size : int;

	var acs : array< CComponent >;
	var head : name;

	npc = theGame.GetNPCByTag(npcTag);
	if(!npc)
	{
		LogQuest("Quest function <<CopyPlayersEquipmentToNPCQuest>>: cannot find NPC with tag <<" + npcTag + ">> aborting!");
		return;
	}
	
	inv = npc.GetInventory();
	if(!inv)
	{
		LogQuest("Quest function <<CopyPlayersEquipmentToNPCQuest>>: NPC with tag <<" + npcTag + ">> has no inventory - cannot give items, saborting!");
		return;
	}
	
	witcher = GetWitcherPlayer();
	if(witcher.GetItemEquippedOnSlot(EES_Armor, item))
	{
		ids = inv.AddAnItem(witcher.inv.GetItemName(item));
		inv.MountItem(ids[0]);
	}

	if(witcher.GetItemEquippedOnSlot(EES_Boots, item))
	{
		ids = inv.AddAnItem(witcher.inv.GetItemName(item));
		inv.MountItem(ids[0]);
	}
	
	if(witcher.GetItemEquippedOnSlot(EES_Pants, item))
	{
		ids = inv.AddAnItem(witcher.inv.GetItemName(item));
		inv.MountItem(ids[0]);
	}
	
	if(witcher.GetItemEquippedOnSlot(EES_Gloves, item))
	{
		ids = inv.AddAnItem(witcher.inv.GetItemName(item));
		inv.MountItem(ids[0]);
	}
	
	if(witcher.GetItemEquippedOnSlot(EES_RangedWeapon, item))
	{
		ids = inv.AddAnItem(witcher.inv.GetItemName(item));
		inv.MountItem(ids[0]);
	}
	
	if(witcher.GetItemEquippedOnSlot(EES_SilverSword, item))
	{
		ids = inv.AddAnItem(witcher.inv.GetItemName(item));
		inv.MountItem(ids[0]);
	}
	
	if(witcher.GetItemEquippedOnSlot(EES_SteelSword, item))
	{
		ids = inv.AddAnItem(witcher.inv.GetItemName(item));
		inv.MountItem(ids[0]);
	}

	
	if(!dontCopyHair)
	{
		ids = witcher.inv.GetItemsByCategory( 'hair' );
		size = ids.Size();
		if(size > 0 )
		{
			for(i=0; i < size; i+=1 )
			{
				if(witcher.inv.GetItemName(ids[i]) != 'Preview Hair' && witcher.inv.IsItemMounted( ids[i] ) )
				{
					ids = inv.AddAnItem(witcher.inv.GetItemName(ids[i]));
					inv.MountItem(ids[0]);
				}
			}
		}
	}
	
	if(copyHead)
	{
		acs = thePlayer.GetComponentsByClassName( 'CHeadManagerComponent' );
		head = ( ( CHeadManagerComponent ) acs[0] ).GetCurHeadName();
		
		ids = inv.AddAnItem( head );
		inv.MountItem(ids[0]);
	}
	
}

quest function ShowTimeLapse( showTime : float, optional timeLapseMessageKey : string, optional timeLapseAdditionalMessageKey : string )
{
	var hud : CR4ScriptedHud;
	var timeLapseModule : CR4HudModuleTimeLapse;
	
	hud = (CR4ScriptedHud)theGame.GetHud();
	if( hud )
	{
		timeLapseModule = (CR4HudModuleTimeLapse)hud.GetHudModule("TimeLapseModule");
		timeLapseModule.SetShowTime(showTime);

		
		
		if ( timeLapseMessageKey == "" && timeLapseAdditionalMessageKey != "" )
		{
			timeLapseMessageKey = timeLapseAdditionalMessageKey;
			timeLapseAdditionalMessageKey = "";
		}

		timeLapseModule.SetTimeLapseAdditionalMessage(timeLapseAdditionalMessageKey);
		timeLapseModule.SetTimeLapseMessage(timeLapseMessageKey);
	}
}

quest function DisplayHudMessage( localisedStringKey : name, localizedStringID : int )
{
	if( IsNameValid( localisedStringKey ) )
	{
		thePlayer.DisplayHudMessage(GetLocStringByKeyExt(localisedStringKey));
	}
	else
	{
		if( localizedStringID != 0 )
		{
			thePlayer.DisplayHudMessage(GetLocStringById(localizedStringID));
		}
	}
}

latent quest function DisplayRaceStart( countDownSecondsNumber : int )
{
	thePlayer.DisplayRaceStart( countDownSecondsNumber );
	while( thePlayer.GetCountDownToStart() > 0)
	{
		Sleep(0.1);
	}
}

quest function RemoveErrandsFromNoticeboard( boardTag : name, errandName : string )
{
	var boards : array<CEntity>;
	var board : W3NoticeBoard;
	var i : int;
	
	theGame.GetEntitiesByTag( boardTag, boards );
	
	if( boards.Size() == 0 )
		return;
	
	for( i = 0; boards.Size() > i; i += 1 )
	{
		board = (W3NoticeBoard) boards[i];
		
		if (board)
		{
			board.RemoveQuest(errandName);
			board.UpdateBoard();
			board.UpdateInteraction();
		}
	}
}

quest function AddErrandsToTheNoticeBoard( boardTag : name, errandDetails : array < ErrandDetailsList >, optional forceActivate : bool )
{
	var boards : array<CEntity>;
	var board : W3NoticeBoard;
	var j : int;
	var i : int;
	
	if( errandDetails.Size() == 0 )
		return;
	
	theGame.GetEntitiesByTag( boardTag, boards );
	
	if( boards.Size() == 0 )
		return;
	
	for( i = 0; boards.Size() > i; i += 1 )
	{
		board = (W3NoticeBoard) boards[i];
		
		if( board )
		{
			for( j = 0; errandDetails.Size() > j; j += 1 )
			{
				board.AddErrand( errandDetails[j], forceActivate );
			}
			board.UpdateBoard();
			board.UpdateInteraction();
		}
	}
}

quest function FocusClueManager( tag: name, actionType : EFocusClueAttributeAction, isAvailable: bool, isInteractive : bool, isReusable : bool, isVisible : bool, wasDetected : bool, isIgnoringFM : bool )
{
	var focusClues	: array< CNode >;
	var focusClue	: W3MonsterClue;
	var i, size 	: int;
	
	if ( tag == '' )
	{
		LogQuest( "Quest function <<FocusClueManager>>: empty tag!");	
		return;
	}
	
	theGame.GetNodesByTag( tag, focusClues );
	size = focusClues.Size();	
	for ( i = 0; i < size; i += 1 )
	{
		focusClue = (W3MonsterClue)focusClues[i];		
		if ( focusClue )
		{
			focusClue.SetAttributes( actionType, isAvailable, isInteractive, isReusable, isVisible, wasDetected, isIgnoringFM );			
		}
	}
}

quest function FocusDestroyableClueManager( tag: name, destroyable : bool, triggerDestruction : bool )
{
	var focusClues	: array< CNode >;
	var focusClue	: W3DestroyableClue;
	var i, size 	: int;
	
	if ( tag == '' )
	{
		LogQuest( "Quest function <<FocusClueManager>>: empty tag!");	
		return;
	}
	
	theGame.GetNodesByTag( tag, focusClues );
	size = focusClues.Size();	
	for ( i = 0; i < size; i += 1 )
	{
		focusClue = (W3DestroyableClue)focusClues[i];		
		if ( focusClue )
		{	
			if( triggerDestruction )
			{
				focusClue.ProcessDestruction();
			}
			else
			{
				focusClue.SetDestroyable( destroyable );
			}
		}
	}
}

quest function FocusSoundClueManager( tag: name, soundEffectType : EFocusModeSoundEffectType, startEventOverride : name, stopEventOverride : name)
{
	var nodes		: array< CNode >;
	var entity		: CGameplayEntity;
	var i, size 	: int;
	var focusModeController : CFocusModeController;
	var soundClue	: W3SavedSoundClue;
	
	if ( tag == '' )
	{
		LogQuest( "Quest function <<FocusSoundClueManager>>: empty tag!" );	
		return;
	}
	
	theGame.GetNodesByTag( tag, nodes );
	size = nodes.Size();	
	for ( i = 0; i < size; i += 1 )
	{
		entity = (CGameplayEntity)nodes[i];		
		if ( entity )
		{
			if (startEventOverride !='None' || stopEventOverride !='None')
			{
				focusModeController = theGame.GetFocusModeController();
				focusModeController.SetSoundClueEventNames(entity,startEventOverride,stopEventOverride,soundEffectType);
			}
			entity.SetFocusModeSoundEffectType( soundEffectType );
			soundClue = (W3SavedSoundClue)entity;
			if ( soundClue )
			{
				soundClue.savedFocusModeSoundEffectType = soundEffectType;
			}
		}
	}
}

quest function FocusAreaIntensity( areaTag : name, newIntensity : float )
{
	var focusAreas	: array< CNode >;
	var focusArea	: W3FocusAreaTrigger;
	var i, size 	: int;

	theGame.GetNodesByTag( areaTag, focusAreas );
	size = focusAreas.Size();
	
	for ( i = 0; i < size; i += 1 )
	{
		focusArea = (W3FocusAreaTrigger)focusAreas[i];		
		if ( focusArea )
		{
			focusArea.ChangeFocusAreaIntensity( newIntensity );
		}
	}

}

quest function FocusStashManager( tag : name, isDisabled : bool )
{
	var focusStashes	: array< CNode >;
	var focusStash		: W3ClueStash;
	var i, size 		: int;

	theGame.GetNodesByTag( tag, focusStashes );
	size = focusStashes.Size();
	
	for ( i = 0; i < size; i += 1 )
	{
		focusStash = (W3ClueStash)focusStashes[i];		
		if ( focusStash )
		{
			focusStash.SetStashDisabled( isDisabled );
		}
	}
}

enum EFocusEffectActivationAction
{
	FEAA_Enable,
	FEAA_Disable,
}

quest function FocusEffect( actionType : EFocusEffectActivationAction, effectName : name, effectEntityTag : name, duration : float )
{
	var focusModeController : CFocusModeController;
	var scentClues			: array< CNode >;
	var scentClue			: CGameplayEntity;
	var i, size 			: int;
	
	if ( effectEntityTag == '' )
	{
		LogQuest( "Quest function <<FocusScent>>: empty tag!");	
		return;
	}
	
	focusModeController = theGame.GetFocusModeController();
	if ( !focusModeController )
	{
		LogQuest( "Quest function <<FocusScent>>: can't find focus mode controller!");	
		return;	
	}
		
	theGame.GetNodesByTag( effectEntityTag, scentClues );
	size = scentClues.Size();	
	for ( i = 0; i < size; i += 1 )
	{
		scentClue = (CGameplayEntity)scentClues[i];

		if ( scentClue )
		{
			if ( actionType == FEAA_Enable)
			{
				focusModeController.ActivateScentClue( scentClue, effectName, duration );
			}
			else
			{
				focusModeController.DeactivateScentClue( scentClue );
			}
		}
	}
}

quest function FocusSetHighlight( tag : name, highlightType : EFocusModeVisibility, optional overrideCustomLogic : bool )
{
	var nodes			: array< CNode >;
	var i, size 		: int;
	var gameplayEntity 	: CGameplayEntity;
	var container		: W3Container;
	var poster			: W3SavedPoster;
	var clue			: W3MonsterClue;

	theGame.GetNodesByTag( tag, nodes );
	
	size = nodes.Size();	
	for ( i = 0; i < size; i += 1 )
	{
		gameplayEntity = (CGameplayEntity)nodes[i];
		if ( gameplayEntity )
		{
			gameplayEntity.SetFocusModeVisibility( highlightType, true, true );
			
			if ( overrideCustomLogic )
			{
				container = (W3Container)gameplayEntity;
				if ( container )
				{
					container.focusModeHighlight = highlightType;
				}
				poster = (W3SavedPoster)gameplayEntity;
				if ( poster )
				{
					poster.savedFocusModeHighlight = highlightType;
				}
				clue = (W3MonsterClue)gameplayEntity;
				if ( clue )
				{
					clue.OverrideVisibilityParams( highlightType );
				}
			}
		}
	}
}




quest function ChangeWeatherQuest( weatherName: name, blendTime: float, randomGen: bool, questPause: bool )
{
	if( randomGen )
	{
		RequestRandomWeatherChange( blendTime, questPause );
	}
	else
	{
		RequestWeatherChangeTo( weatherName, blendTime, questPause );
	}
}



quest function EffectOnCamera( effectName: name, play: bool )
{

	if( play )
	{
		theGame.GetGameCamera().PlayEffect( effectName );
	}
	else
	{
		theGame.GetGameCamera().StopEffect( effectName );
	}
}

enum ECameraEffect
{
    ECE_None,
    ECE_Drunk
}

quest function PlayCameraEffect( animName : ECameraEffect, strength : float, bLoop : bool )
{
    var animation : SCameraAnimationDefinition;

	if ( animName == ECE_None)
	{
		animation.animation = 'camera_exploration';
	}
    else if ( animName == ECE_Drunk )
	{
		animation.animation = 'CS_Drunk';
	}

	animation.priority = CAP_Low;
	animation.blendIn = 0.1f;
	animation.blendOut = 0.1f;
	animation.speed	= 1.0f;
	animation.weight = strength;
	animation.loop = bLoop;
	animation.additive = true;
	animation.reset = true;
	
	theGame.GetGameCamera().PlayAnimation( animation );
}

quest function SetCameraFOV ( newFov : float )
{
	var gameCamera : CCustomCamera;
	gameCamera = theGame.GetGameCamera();

	gameCamera.SetFov( newFov );

}

quest function RequestCameraRotation( cameraRequest : SQuestCameraRequest )
{
	thePlayer.RequestQuestCamera( cameraRequest );
}

quest function ResetCameraRotationRequest()
{
	thePlayer.ResetQuestCameraRequest();
}

quest function ReadBookByName( bookName : name, unread : bool )
{
	if(IsAlchemyRecipe(bookName))
	{
		if(GetWitcherPlayer().CanLearnAlchemyRecipe(bookName))
			GetWitcherPlayer().AddAlchemyRecipe(bookName);
	}
	else
	{
		thePlayer.inv.ReadBookByName( bookName, unread );
	}
}

quest function EnableFastTravelMapPins( pinTags : array< name >, enable : bool )
{
	var commonMapManager: CCommonMapManager = theGame.GetCommonMapManager();
	var i : int;
	
	for ( i = 0; i < pinTags.Size(); i += 1 )
	{
		commonMapManager.SetEntityMapPinDisabled( pinTags[ i ], !enable );
	}
}

quest function DiscoverFastTravelMapPins( pinTags : array< name >, show : bool )
{
	var commonMapManager: CCommonMapManager = theGame.GetCommonMapManager();
	var i : int;
	
	for ( i = 0; i < pinTags.Size(); i += 1 )
	{
		commonMapManager.SetEntityMapPinDiscoveredScript(true, pinTags[ i ], show );
	}
}

quest function EnableFastTravelling( enable : bool )
{
	var commonMapManager: CCommonMapManager = theGame.GetCommonMapManager();

	commonMapManager.EnableFastTravelling( enable );
}

quest function EnableGeraltPushing(enable : bool  )
{
	var movingComponent : CMovingPhysicalAgentComponent;
	movingComponent = (CMovingPhysicalAgentComponent)thePlayer.GetComponentByClassName('CMovingPhysicalAgentComponent');
	if(movingComponent)
	{
		movingComponent.SetPushable( enable );
	}
}

quest function EnableOrDisableContainers( containersTag : name, containerEnabled : bool )
{
	var container : W3Container;
	var containerNodes : array<CNode>;
	var i, size : int;
	
	if( IsNameValid(containersTag) )
		theGame.GetNodesByTag(containersTag, containerNodes);
	
	size = containerNodes.Size();
	
	for( i = 0; i < size; i += 1 )
	{
		container = (W3Container)containerNodes[i];
		
		if( container )
		{
			container.Enable( containerEnabled, false, true );
			container.SetIsQuestContainer( true );
			container.RequestUpdateContainer();
		}
	}
}


quest function CombatStageChange( npcsTag : name, stage : ENPCFightStage )
{
	var i, size : int;
	var npcsArray : array<CNewNPC>;
	
	theGame.GetNPCsByTag( npcsTag, npcsArray );
	
	size = npcsArray.Size();
	
	for( i = 0; i < size; i += 1 )
	{
		npcsArray[i].ChangeFightStage( stage );
	}
}


quest function AppearanceChange( npcsTag : name, appearanceName : name )
{
	var i, size : int;
	var npcsArray : array<CActor>;
	
	if(!IsNameValid(appearanceName))
		return;
		
	theGame.GetActorsByTag( npcsTag, npcsArray );
	
	size = npcsArray.Size();
	
	for( i = 0; i < size; i += 1 )
	{
		npcsArray[i].SetAppearance( appearanceName );
	}
}


quest function ApplyAppearance( entitiesTag : name, appearanceName : name )
{
	var i, size : int;
	var entitiesArray : array<CNode>;
	var entity : CEntity;
	var saEntity : W3SavedAppearanceEntity;
	
	if(!IsNameValid(appearanceName))
		return;
		
	theGame.GetNodesByTag( entitiesTag, entitiesArray );
	
	size = entitiesArray.Size();
	
	for( i = 0; i < size; i += 1 )
	{
		saEntity = (W3SavedAppearanceEntity)entitiesArray[i];
		if ( saEntity )
		{		
			saEntity.SetAppearance( appearanceName );
		}
		else
		{
			entity = (CEntity)entitiesArray[i];
			if (entity)
				entity.ApplyAppearance( appearanceName );
		}
	}
}






quest function SoundEventQuest( eventName : string, saveBehavior : ESoundEventSaveBehavior )
{
	theSound.SoundEvent( eventName );
	switch( saveBehavior)
	{
		case SESB_Save:
			theSound.SoundEventAddToSave( eventName );
			break;
		case SESB_ClearSaved:
			theSound.SoundEventClearSaved();
			break;
	}
}


quest function SoundEventOnActorQuest( actorTag : name, eventName : string, oneRandomActor : bool, onlyIfAlive : bool )
{
	var nodes : array<CNode>;
	var actor : CEntity;
	var aliveActor : CActor;
	
	if( oneRandomActor )
	{
		theGame.GetNodesByTag( actorTag, nodes );
		actor = ( CEntity ) nodes[ RandRange( nodes.Size(), 0) ];
	}
	else
	{
		actor = ( CEntity ) theGame.GetNodeByTag( actorTag );
	}
	
	if( onlyIfAlive )
	{
		aliveActor = (CActor) actor;
		
		if( !aliveActor.IsAlive() )
		{
			return;
		}
	}
	
	actor.SoundEvent( eventName );
}


latent quest function EnableFistFightMinigame( toTheDeath : bool, npcTag : array< name >, optional npcTeleportTag : array< name >, optional playerTeleportTag : name ) : bool
{
	return true;
	
	
}

quest function HidePlayerItemQuest()
{
	thePlayer.HideUsableItem();
}

quest function ShowUsableItemLQuest ()
{
	thePlayer.OnUseSelectedItem();
}



quest function AddItemQuest( targetTag : name, itemName : name, quantity : int, items : array<SItem>, informGUI : bool)
{
	var entities : array<CEntity>;
	var entity : CGameplayEntity;
	var inv : CInventoryComponent;
	var i, e, j, singletonItemMaxAmmo : int;
	var skip : bool;
	var ids : array<SItemUniqueId>;
	var dm : CDefinitionsManagerAccessor;
	var manager : CR4GuiManager;

	if(!IsNameValid(targetTag))
	{
		LogQuest( "Quest function <<AddItemQuest>>: entity tag <<" + targetTag + ">> is not a valid entity name, aborting!");		
		return;
	}
	
	theGame.GetEntitiesByTag(targetTag, entities);
	if(entities.Size() <= 0)
	{
		LogQuest( "Quest function <<AddItemQuest>>: entity with tag <<" + targetTag + ">> not found!");
		return;
	}
	
	dm = theGame.GetDefinitionsManager();
	for(e=0; e<entities.Size(); e+=1)
	{
		entity = (CGameplayEntity)entities[e];
		
		if(entity)
		{
			inv = entity.GetInventory();
			if(inv)
			{
				skip = false;
				if(!IsNameValid(itemName))
				{
					LogQuest( "Quest function <<AddItemQuest>>: item name <<" + itemName + ">> is not a valid item name, skipping!");
					skip = true;
				}
				if(itemName == 'Bodkin Bolt' || itemName == 'Harpoon Bolt')
				{
					LogQuest( "Quest function <<AddItemQuest>>: cannot add Bodkin Bolts from Quests");
					skip = true;
				}
				if(quantity < 0)
				{
					LogQuest( "Quest function <<AddItemQuest>>: quantity of " + quantity + "is not a valid value, skipping!");		
					skip = true;
				}
				
				if(!skip)
				{
					if(quantity == 0)
						quantity = 1;
					ids = inv.AddAnItem(itemName, quantity, !informGUI);
					if(ids.Size() > 0 && inv.IsItemSingletonItem(ids[0]))
					{
						singletonItemMaxAmmo = inv.SingletonItemGetMaxAmmo(ids[0]);
						inv.SingletonItemSetAmmo(ids[0], singletonItemMaxAmmo);
					}
					else if(ids.Size() == 0 && dm.IsItemSingletonItem(itemName) && inv.HasItem(itemName))
					{
						
						ids.Clear();
						ids = inv.GetItemsByName(itemName);
						inv.SingletonItemAddAmmo(ids[0], quantity);
					}
				}
			
				for(i=0; i<items.Size(); i+=1)
				{
					if(!IsNameValid(items[i].itemName))
					{
						LogQuest( "Quest function <<AddItemQuest>>: item name <<" + items[i].itemName + ">> is not a valid item name, skipping!");
						continue;
					}
					if(items[i].itemName == 'Bodkin Bolt' || items[i].itemName == 'Harpoon Bolt')
					{
						LogQuest( "Quest function <<AddItemQuest>>: cannot add Bodkin Bolts from Quests");
						continue;
					}
					if(items[i].quantity < 0)
					{
						LogQuest( "Quest function <<AddItemQuest>>: quantity of " + items[i].quantity + "is not a valid value, skipping!");		
						continue;
					}
					if(items[i].quantity == 0)
						items[i].quantity = 1;

					ids.Clear();
					ids = inv.AddAnItem(items[i].itemName, items[i].quantity, !informGUI);
					if(ids.Size() > 0 && inv.IsItemSingletonItem(ids[0]))
					{
						singletonItemMaxAmmo = inv.SingletonItemGetMaxAmmo(ids[0]);
						for(j=0; j<ids.Size(); j+=1)
							inv.SingletonItemSetAmmo(ids[j], singletonItemMaxAmmo);
					}
					else if(ids.Size() == 0 && dm.IsItemSingletonItem(items[i].itemName) && inv.HasItem(items[i].itemName))
					{
						
						ids.Clear();
						ids = inv.GetItemsByName(items[i].itemName);
						inv.SingletonItemAddAmmo(ids[0], items[i].quantity);
					}
				}
			}
			else
			{
				LogQuest( "Quest function <<AddItemQuest>>: entity with tag <<" + targetTag + ">> has no inventory component, cannot add item!");
			}
		}
		else
		{
			LogQuest( "Quest function <<AddItemQuest>>: entity with tag <<" + targetTag + ">> is not a gameplay entity!");
		}
	}
}

quest function AddItemQuestExt( targetTag : name, items : array<SItemExt>, informGUI : bool)
{
	var entities : array<CEntity>;
	var entity : CGameplayEntity;
	var inv : CInventoryComponent;
	var i, e, j, singletonItemMaxAmmo : int;
	var ids : array<SItemUniqueId>;
	var dm : CDefinitionsManagerAccessor;

	if(!IsNameValid(targetTag))
	{
		LogQuest( "Quest function <<AddItemQuest>>: entity tag <<" + targetTag + ">> is not a valid entity name, aborting!");		
		return;
	}
	
	theGame.GetEntitiesByTag(targetTag, entities);
	if(entities.Size() <= 0)
	{
		LogQuest( "Quest function <<AddItemQuest>>: entity with tag <<" + targetTag + ">> not found!");
		return;
	}
	
	dm = theGame.GetDefinitionsManager();
	for(e=0; e<entities.Size(); e+=1)
	{
		entity = (CGameplayEntity)entities[e];
		
		if(entity)
		{
			inv = entity.GetInventory();
			if(inv)
			{
		
				for(i=0; i<items.Size(); i+=1)
				{
					if(!IsNameValid(items[i].itemName.itemName))
					{
						LogQuest( "Quest function <<AddItemQuest>>: item name <<" + items[i].itemName.itemName + ">> is not a valid item name, skipping!");
						continue;
					}
					if(items[i].itemName.itemName == 'Bodkin Bolt' || items[i].itemName.itemName == 'Harpoon Bolt')
					{
						LogQuest( "Quest function <<AddItemQuest>>: cannot add Bodkin Bolts from Quests");
						continue;
					}
					if(items[i].quantity < 0)
					{
						LogQuest( "Quest function <<AddItemQuest>>: quantity of " + items[i].quantity + "is not a valid value, skipping!");		
						continue;
					}
					if(items[i].quantity == 0)
						items[i].quantity = 1;

					ids.Clear();
					ids = inv.AddAnItem( items[i].itemName.itemName, items[i].quantity, !informGUI );
					if(ids.Size() > 0 && inv.IsItemSingletonItem(ids[0]))
					{
						singletonItemMaxAmmo = inv.SingletonItemGetMaxAmmo(ids[0]);
						for(j=0; j<ids.Size(); j+=1)
							inv.SingletonItemSetAmmo(ids[j], singletonItemMaxAmmo);
					}
					else if(ids.Size() == 0 && dm.IsItemSingletonItem(items[i].itemName.itemName) && inv.HasItem(items[i].itemName.itemName))
					{
						
						ids.Clear();
						ids = inv.GetItemsByName(items[i].itemName.itemName);
						inv.SingletonItemAddAmmo(ids[0], items[i].quantity);
					}
				}
			}
			else
			{
				LogQuest( "Quest function <<AddItemQuest>>: entity with tag <<" + targetTag + ">> has no inventory component, cannot add item!");
			}
		}
		else
		{
			LogQuest( "Quest function <<AddItemQuest>>: entity with tag <<" + targetTag + ">> is not a gameplay entity!");
		}
	}
}

quest function EquipItemQuestByCategory( targetTag : name, category : name, unequip : bool, toHand : bool )
{
	var actors : array<CActor>;
	var target : CActor;
	var inv : CInventoryComponent;
	var ids : array<SItemUniqueId>;
	var a, i : int;
	var playerWitcher : W3PlayerWitcher;
	var itemID : SItemUniqueId;
	

	
	if( targetTag == 'PLAYER' )
	{
		actors.PushBack( thePlayer );
	}
	else
	{
		theGame.GetActorsByTag( targetTag, actors );
		if( actors.Size() <= 0 )
		{
			LogQuest( "EquipItemQuestByCategory: cannot find actor with tag <<" + targetTag + ">>. Aborting." );
			return;
		}
	}
	
	
	if( !IsNameValid( category ) )
	{
		LogQuest( "EquipItemQuestByCategory: category <<" + category + ">> is not valid. Aborting." );
		return;
	}
	
	for( a=0; a<actors.Size(); a+=1 )
	{
		target = actors[a];

		inv = target.GetInventory();		
		if( inv )
		{
			ids = inv.GetItemsByCategory( category );
			
			
			itemID = GetInvalidUniqueId();
			for( i=0; i<ids.Size(); i+=1 )
			{
				if( !inv.ItemHasTag( ids[i], 'Body' ) )
				{
					itemID = ids[i];
					break;
				}
			}
			
			
			
			
			
			if( !inv.IsIdValid( itemID ) )
			{
				LogQuest( "EquipItemQuestByCategory: cannot (un)equip item with category(" + category + ") on <<" + target + ">>, cannot find any suitable item. Aborting function.");
				return;
			}
			
			
			if( unequip )
			{
				target.UnequipItem( itemID );
			}
			else
			{
				playerWitcher = (W3PlayerWitcher)target;
				
				if( toHand && !inv.IsItemHeld( itemID ) )
				{
					if( playerWitcher )
					{
						if( !playerWitcher.IsItemEquipped( itemID ) )	
						{
							target.EquipItem( itemID, , true );
						}
					}
					else
					{
						target.EquipItem( itemID, , true );
					}
				}
				else if( !toHand && !inv.IsItemMounted( itemID ) )
				{
					if( playerWitcher )
					{
						if( !playerWitcher.IsItemEquipped( itemID ) )	
						{
							target.EquipItem( itemID );
						}
					}
					else
					{					
						target.EquipItem( itemID );
					}
				}
			}
			
			
			ids.Clear();
		}
		else
		{
			LogQuest("EquipItemQuestByCategory: target actor <<" + target + ">> has no inventory component, cannot equip/unequip items. Function will continue.");
		}
	}
}



quest function EquipItemQuest( targetTag : name, itemName : name, itemCategory : name, itemTag : name, optional unequip : bool, optional toHand : bool )
{
	var actors : array<CActor>;
	var target : CActor;
	var inv : CInventoryComponent;
	var ids : array<SItemUniqueId>;
	var a, i,idx : int;
	var playerWitcher : W3PlayerWitcher; 

	if(targetTag == 'PLAYER')
	{
		actors.PushBack(thePlayer);
	}
	else
	{
		theGame.GetActorsByTag(targetTag, actors);
		if(actors.Size() <= 0)
		{
			LogQuest("EquipItemQuest: cannot find actor with tag <<" + targetTag + ">>");
			return;
		}
	}
	
	for(a=0; a<actors.Size(); a+=1)
	{
		target = actors[a];

		inv = target.GetInventory();		
		if( inv )
		{
			
			if(IsNameValid(itemName))
			{
				ids = inv.GetItemsIds(itemName);
			}
			else if(IsNameValid(itemCategory))
			{
				ids = inv.GetItemsByCategory(itemCategory);
			}
			else if(IsNameValid(itemTag))
			{
				ids = inv.GetItemsByTag(itemTag);
			}
			
			if(ids.Size() <= 0)			
			{
				LogQuest("EquipItemQuest: cannot (un)equip item <<" + itemName + ">> on <<" + target + ">>, target does not have this item");
				return;
			}			
			for(i=0; i<ids.Size(); i+=1)
			{
				if(inv.GetItemName(ids[i]) == itemName)
				{
					idx = i;
					break;
				}
			}
		
			
			if(unequip)
			{
				target.UnequipItem(ids[idx]);
			}
			else
			{
				playerWitcher = (W3PlayerWitcher)target;
				
				if( toHand && !inv.IsItemHeld(ids[idx]) )
				{
					if ( playerWitcher )
					{
						if (!playerWitcher.IsItemEquippedByName ( itemName))
						{
							target.EquipItem(ids[idx], EES_InvalidSlot, true);
						}
					}
					else
					{
						target.EquipItem(ids[idx], EES_InvalidSlot, true);
					}
				}
				else if ( !toHand && !inv.IsItemMounted( ids[idx] ) )
				{
					if ( playerWitcher )
					{
						if (!playerWitcher.IsItemEquippedByName ( itemName))
						{
							target.EquipItem( ids[idx] );
						}
					}
					else
					{					
						target.EquipItem( ids[idx] );
					}
				}
			}			
		}
		else
		{
			LogQuest("EquipItemQuest: target actor <<" + target + ">> has no inventory component, cannot equip/unequip items");
		}
	}
}

quest function DropItemFromSlotQuest( targetTag : name, slotName : name, optional removeFromInv : bool )
{
	var actors : array<CActor>;
	var a : int;
	
	if(targetTag == 'PLAYER')
	{
		LogQuest("DropItemFromSlotQuest: THIS FUNCTION IS NOT ALLOWED ON PLAYER");
	}
	else
	{
		theGame.GetActorsByTag(targetTag, actors);
		if( actors.Size() <= 0 )
		{
			LogQuest("DropItemFromSlotQuest: cannot find actor with tag <<" + targetTag + ">>");
			return;
		}
	}
	
	for( a=0; a<actors.Size(); a+=1 )
	{
		actors[a].DropItemFromSlot( slotName, removeFromInv );
	}
}

quest function EquipItemQuestExt( targetTag : name, itemName : SItemNameProperty, itemCategory : name, itemTag : name, optional unequip : bool, optional toHand : bool )
{
	EquipItemQuest(targetTag, itemName.itemName, itemCategory, itemTag, unequip, toHand);
}


quest function RemoveItemQuest( entityTag : name, item_name : name, item_category : name, item_tag : name, optional quantity : int)
{
	var entity : CGameplayEntity;
	var inv : CInventoryComponent;
	var witcher : W3PlayerWitcher;
	var playerQuantity, horseQuantity, removedQuantity : int;

	if(!IsNameValid(entityTag))
	{
		LogQuest( "Quest function <<RemoveItemFromEntityQuest>>: entity tag <<" + entityTag + ">> is not a valid name, aborting!");
		return;
	}	
	if(!IsNameValid(item_name) &&
	   !IsNameValid(item_category) &&
	   !IsNameValid(item_tag))
	{
		LogQuest( "Quest function <<RemoveItemFromEntityQuest>>: no arguments provided, aborting!");
		return;
	}	
	if(quantity < -1)
	{
		LogQuest( "Quest function <<RemoveItemFromEntityQuest>>: quantity of <<" + quantity + ">> is not a valid value, aborting!");
		return;
	}
	if(quantity == 0)
		quantity = 1;
		
	entity = (CGameplayEntity)theGame.GetEntityByTag(entityTag);
	if(entity)
	{
		inv = entity.GetInventory();
		if(inv)
		{
			witcher = GetWitcherPlayer();
			
			if(IsNameValid(item_name))
			{
				if(entity != witcher)
				{
					inv.RemoveItemByName(item_name, quantity);
				}
				else if( quantity == -1 )
				{
					inv.RemoveItemByName(item_name, quantity);
					witcher.HorseRemoveItemByName(item_name, quantity);
				}
				else
				{					
					playerQuantity = inv.GetItemQuantityByName(item_name);
					horseQuantity = witcher.GetHorseManager().GetInventoryComponent().GetItemQuantityByName(item_name);
					
					if(playerQuantity + horseQuantity < quantity)
						return;
					
					
					removedQuantity = Min(playerQuantity, quantity);
					inv.RemoveItemByName(item_name, removedQuantity);
					
					
					if(removedQuantity < quantity)
					{
						witcher.HorseRemoveItemByName(item_name, quantity - removedQuantity);
					}
				}
			}
			else if(IsNameValid(item_category))
			{
				if(entity != witcher)
				{
					inv.RemoveItemByCategory(item_category, quantity);
				}
				else if( quantity == -1 )
				{
					inv.RemoveItemByCategory(item_category, quantity);
					witcher.HorseRemoveItemByCategory(item_category, quantity);
				}
				else
				{
					playerQuantity = inv.GetItemQuantityByCategory(item_category);
					horseQuantity = witcher.GetHorseManager().GetInventoryComponent().GetItemQuantityByCategory(item_category);
					
					if(playerQuantity + horseQuantity < quantity)
						return;
					
					
					removedQuantity = Min(playerQuantity, quantity);
					inv.RemoveItemByCategory(item_category, removedQuantity);
					
					
					if(removedQuantity < quantity)
					{
						witcher.HorseRemoveItemByCategory(item_category, quantity - removedQuantity);
					}
				}
			}
			else if(IsNameValid(item_tag))
			{
				if(entity != witcher)
				{
					inv.RemoveItemByTag(item_tag, quantity);
				}
				else if( quantity == -1 )
				{
					inv.RemoveItemByTag(item_tag, quantity);
					witcher.HorseRemoveItemByTag(item_tag, quantity);
				}
				else
				{
					playerQuantity = inv.GetItemQuantityByTag(item_tag);
					horseQuantity = witcher.GetHorseManager().GetInventoryComponent().GetItemQuantityByTag(item_tag);
					
					if(playerQuantity + horseQuantity < quantity)
						return;
					
					
					removedQuantity = Min(playerQuantity, quantity);
					inv.RemoveItemByTag(item_tag, removedQuantity);
					
					
					if(removedQuantity < quantity)
					{
						witcher.HorseRemoveItemByTag(item_tag, quantity - removedQuantity);
					}
				}
			}
		}
		else
			LogQuest( "Quest function <<RemoveItemFromEntityQuest>>: entity <<" + entityTag + ">> has no inventory component, cannot remove item!");
	}
	else
	{
		LogQuest( "Quest function <<RemoveItemFromEntityQuest>>: CGameplayEntity <<" + entityTag + ">> not found, cannot remove item");
	}	
}

quest function RemoveItemQuestExt( entityTag : name, item_name : SItemExt, item_category : name, item_tag : name )
{
	RemoveItemQuest(entityTag, item_name.itemName.itemName, item_category, item_tag, item_name.quantity);
}

quest function PlayEffectQuest ( entityTag : name, effectName : name, activate : bool, persistentEffect : bool, deactivateAll : bool, preventEffectStacking : bool )
{
	var entities : array <CNode>;
	var i      : int;
	var entity : CEntity;

	if( entityTag == 'CAMERA' )
	{
		if( activate )
		{
			if( !preventEffectStacking )
			{
				theGame.GetGameCamera().PlayEffect( effectName );	
			}
			else
			{
				theGame.GetGameCamera().PlayEffectSingle( effectName );
			}
		}	
		else
		{
			theGame.GetGameCamera().StopEffect( effectName );		
		}
		return;
	}

	theGame.GetNodesByTag( entityTag, entities);
	
	for (i = 0; i < entities.Size(); i += 1 )
	{
		entity = (CEntity) entities[i];
		if( deactivateAll && !activate )
		{
			entity.StopAllEffects();
			entity.SetAutoEffect( 'None' );
		}
		else
		{
			if (activate == true)
			{
				if ( persistentEffect )
				{
					entity.SetAutoEffect( effectName );
				}
				else
				{
					if( !preventEffectStacking )
					{
						entity.PlayEffect( effectName );	
					}
					else
					{
						entity.PlayEffectSingle( effectName );
					}
				}
			}
			else if (activate == false)
			{
				if ( persistentEffect )
				{
					entity.SetAutoEffect( 'None' );
				}
				else
				{
					entity.StopEffect(effectName);
				}
			}
		}
	}
}

quest function PlayEffectWithTargetQuest ( entityTag : name, effectName : name, activate : bool, targetTag: name) : bool
{
	var entities : array <CNode>;
	var i      : int;
	var entity : CEntity;
	var target : CNode;
	
	target = theGame.GetNodeByTag(targetTag);
	
	theGame.GetNodesByTag(entityTag, entities);
	
	for (i = 0; i < entities.Size(); i += 1 )
	{
		entity = (CEntity) entities[i];
		if (activate == true)
		{
				entity.PlayEffect(effectName, target );
		}
		else if (activate == false)
		{
				entity.StopEffect(effectName);
		}
	}
	
	return true;
}

quest function PlaySavableEffectQuest ( entityTag : name, effectName : name, activate : bool, targetTag : name, targetBone : name )
{
	var entities : array <CNode>;
	var i      : int;
	var entity : CEntity;
	var targetEntity : CEntity;
	var comp : CR4EffectComponent;
	
	targetEntity = (CEntity)theGame.GetNodeByTag(targetTag);
	
	theGame.GetNodesByTag(entityTag, entities);
	
	for (i = 0; i < entities.Size(); i += 1 )
	{
		entity = (CEntity) entities[i];
		
		comp = (CR4EffectComponent) entity.GetComponentByClassName( 'CR4EffectComponent' );
		
		if ( comp )
		{
			if (activate == true)
			{
				comp.PlayEffect( effectName, targetEntity, targetBone );
			}
			else if (activate == false)
			{
				comp.StopEffect();
			}
		}
	}	
}


quest function ActivateEnvironmentQuest ( environmentDefinition : CEnvironmentDefinition, priority : int, blendFactor : float, blendTime : float )
{
	ActivateQuestEnvironmentDefinition( environmentDefinition, priority, blendFactor, blendTime );
}


quest function DectivateEnvironmentQuest ( blendTime : float )
{
	ActivateQuestEnvironmentDefinition( NULL, 0, 0, blendTime );
}

quest function SetPlayerOxygen(percents : int, relative : bool)
{
	var pts : float;
	
	pts = thePlayer.GetStatMax(BCS_Air) * percents / 100;
	
	if(relative)
	{
		if(pts > 0)
			thePlayer.GainStat(BCS_Air, pts);
		else if(pts < 0)
			thePlayer.DrainAir(-pts, 0);
	}
	else
	{
		if(pts >= 0)
			thePlayer.ForceSetStat(BCS_Air, pts);
	}
}

quest function SetPlayerAdrenaline(percents : int, relative : bool)
{
	var pts : float;
	
	pts = thePlayer.GetStatMax(BCS_Focus) * percents / 100;
	
	if(relative)
	{
		if(pts > 0)
			thePlayer.GainStat(BCS_Focus, pts);
		else if(pts < 0)
			thePlayer.DrainFocus(-pts);
	}
	else
	{
		if(pts >= 0)
			thePlayer.ForceSetStat(BCS_Focus, pts);
	}
}

quest function SetPlayerToxicity(percents : int, points : float, relative : bool)
{
	if( points == 0 )
	{
		points = thePlayer.GetStatMax(BCS_Toxicity) * percents / 100;
	}
	
	if(relative)
	{
		if(points > 0)
			thePlayer.GainStat(BCS_Toxicity, points);
		else if(points < 0)
			thePlayer.DrainToxicity(-points);
	}
	else
	{
		if(points >= 0)
			thePlayer.ForceSetStat(BCS_Toxicity, points);
	}
}


quest function SetHealthQuest( targetTag : name, healthPerc : int, relative : bool, shouldPlayHitParticle : bool)
{
	var actors : array<CActor>;
	var maxVit, maxEss, hpp : float;
	var stat : EBaseCharacterStats;
	var action : W3DamageAction;
	var i : int;
	
	
	if(targetTag == 'PLAYER')
	{
		actors.PushBack(thePlayer);
	}
	else
	{
		theGame.GetActorsByTag(targetTag, actors);
		if(actors.Size() <= 0)
		{
			LogQuest( "SetHealthQuest: No actors with tag <<" + targetTag + ">> found!");
			return;
		}
	}
	
	for(i=0; i<actors.Size(); i+=1)
	{
		maxVit = actors[i].GetStatMax(BCS_Vitality);
		maxEss = actors[i].GetStatMax(BCS_Essence);
		
		if(maxVit > 0 && maxEss > 0)
		{
			LogQuest( "SetHealthQuest: Actor <<" + actors[i] + ">> has its health defined impoperly - report as bug! Moving to another actor...");
			return;
		}
		
		if(maxVit > 0)
		{
			hpp = healthPerc * maxVit / 100;
			stat = BCS_Vitality;
		}
		else
		{ 
			hpp = healthPerc * maxEss / 100;
			stat = BCS_Essence;
		}
		
		if(relative)
		{
			if(hpp > 0)
				actors[i].GainStat(stat,hpp);
			else
			{
				action = new W3DamageAction in theGame.damageMgr;
				action.Initialize(NULL, actors[i], NULL, '', EHRT_None, CPS_Undefined, false, false, false, false);
				action.AddDamage(theGame.params.DAMAGE_NAME_DIRECT, -hpp);
				action.SetSuppressHitSounds(true);
				action.SetIgnoreImmortalityMode(true);
				action.SetCanPlayHitParticle(shouldPlayHitParticle);
				theGame.damageMgr.ProcessAction(action);
				delete action;
			}
		}
		else
		{
			if(hpp >= 0)
			{
				actors[i].ForceSetStat(stat,hpp);
			}
			else
			{
				LogQuest( "SetHealthQuest: cannot set health to negative value for actor <<" + actors[i] + ">> ! Moving to another actor...");
				return;
			}
		}
	}
}



quest function SetNPCIsAttackableByPlayer ( npcTag : name , persistent : bool ,  attackable : bool , optional timeout : float)
{
	var npcs : array <CNewNPC>;
	var i : int;
	
	theGame.GetNPCsByTag(npcTag,npcs);
	if (npcs.Size() <= 0 )
	{
		LogQuest("SetNPCIsAttackableByPlayer: no NPC with tag " + npcTag + " found!!!");
		return;
	}
	
	if (persistent)
	{
		for ( i = 0 ; i < npcs.Size() ; i+= 1)
		{
			npcs[i].SetAttackableByPlayerPersistent( attackable );
		}
	return;
	}
	for (i = 0 ; i < npcs.Size() ; i+= 1)
	{
		npcs[i].SetAttackableByPlayerRuntime( attackable , timeout );
	}
}

quest function SetRewardModifierQuest( player: CStoryScenePlayer, rewardName : name, modifer : float, onlyIfDoesntExist : bool  )
{	
	if( onlyIfDoesntExist == true )
	{
		if( thePlayer.GetRewardMultiplierExists(rewardName) == false )
		{
			thePlayer.SetRewardMultiplier(rewardName, modifer);
		}
	}
	else
	{
		thePlayer.SetRewardMultiplier(rewardName, modifer);
	}
}


quest function SetImmortalQuest( targetsTag : name, immortalityMode : EActorImmortalityMode, optional unconsciousMinDuration : float )
{
	var targets : array<CActor>;
	var i : int;
	
	theGame.GetActorsByTag( targetsTag, targets );
	
	if(targets.Size() <= 0)
	{
		LogQuest("SetImmortalQuest: cannot find any Actors with tag <<" + targetsTag + ">>, aborting!");
		return;
	}
	
	for( i = 0; i < targets.Size(); i += 1 )
	{
		targets[i].SetImmortalityMode( immortalityMode, AIC_Default, true );
		if ( immortalityMode == AIM_Unconscious && unconsciousMinDuration != 0 )
			targets[i].SignalGameplayEventParamFloat('ChangeUnconsciousDuration',unconsciousMinDuration);
	}
}

quest function ChangeUnconsciousDuration( targetsTag : name, newMinDuration : float )
{
	var targets : array<CActor>;
	var i : int;
	
	theGame.GetActorsByTag( targetsTag, targets );
	
	if(targets.Size() <= 0)
	{
		LogQuest("ChangeUnconsciousDuration: cannot find any Actors with tag <<" + targetsTag + ">>, aborting!");
		return;
	}
	
	for( i = 0; i < targets.Size(); i += 1 )
		targets[i].SignalGameplayEventParamFloat('ChangeUnconsciousDuration',newMinDuration);
} 



latent quest function ChangePlayerQuest( designatedTemplate: EQuestReplacerEntities )
{
	if( designatedTemplate == EQRE_Geralt )
	{
		theGame.ChangePlayer( "Geralt" );
		while( !((W3PlayerWitcher)thePlayer) )
			SleepOneFrame();
		thePlayer.abilityManager.RestoreStat(BCS_Vitality);
	}
	else if( designatedTemplate == EQRE_Ciri )
	{
		theGame.ChangePlayer( "Ciri" );
		while( !((W3ReplacerCiri)thePlayer) )
			SleepOneFrame();
		thePlayer.ApplyAppearance("ciri_player");	
		thePlayer.abilityManager.RestoreStat(BCS_Vitality);
	}
	else if( designatedTemplate == EQRE_CiriNaked )
	{
		theGame.ChangePlayer( "Ciri_naked" );
		while( !((W3ReplacerCiri)thePlayer) )
			SleepOneFrame();
		thePlayer.abilityManager.RestoreStat(BCS_Vitality);
	}
	else if( designatedTemplate == EQRE_CiriWounded )
	{
		theGame.ChangePlayer( "Ciri" );
		while( !((W3ReplacerCiri)thePlayer) )
			SleepOneFrame();
		
		thePlayer.ApplyAppearance("ciri_wounded");			
		thePlayer.abilityManager.RestoreStat(BCS_Vitality);
	}
	else if( designatedTemplate == EQRE_CiriWinter )
	{
		theGame.ChangePlayer( "Ciri" );
		while( !((W3ReplacerCiri)thePlayer) )
			SleepOneFrame();
		
		thePlayer.ApplyAppearance("ciri_winter");						
		thePlayer.abilityManager.RestoreStat(BCS_Vitality);		
	}
}

enum EQuestReplacerEntities
{
	EQRE_Geralt,
	EQRE_Ciri,
	EQRE_CiriNaked,
	EQRE_CiriWounded,
	EQRE_CiriWinter,
	
}




quest function ModifyNPCAbilityQuest( npcTag : name, abilityName :name, remove : bool )
{
	var npcs : array <CNewNPC>;
	var i      : int;
	
	theGame.GetNPCsByTag(npcTag, npcs);
	if ( npcs.Size() <= 0 ) 
	{
		LogQuest("ModifyNPCAbilityQuest: No npc's with tag " + npcTag + " found!!!");
		return;
	}
	
	for (i = 0; i < npcs.Size(); i += 1 )
	{	
		if(remove)
			npcs[i].RemoveAbility( abilityName );
		else
			npcs[i].AddAbility( abilityName );
	}
}


quest function ModifyPlayerAbilityQuest( abilityName :name, remove : bool )
{
	if(remove)
		thePlayer.RemoveAbility( abilityName );
	else
		thePlayer.AddAbility( abilityName );
}


quest function ResetFactQuest( factID : name )
{
	var sum : int;
	
	sum = FactsQuerySum(factID);
	FactsAdd( factID , -sum);
}


quest function RemoveFactQuest( factId : name )
{
	if( FactsDoesExist( factId ) )
		FactsRemove( factId );
}


quest function CloneFactQuest( SourceFactID : name, TargetFactID : name )
{
	var SourceSum : int;
	SourceSum = FactsQuerySum(SourceFactID);
	
	if( FactsDoesExist( TargetFactID ) )
		FactsRemove( TargetFactID );
	
	FactsAdd( TargetFactID , SourceSum);
}


quest function FadeOutQuest( fadeTime : float, fadeColor : Color )
{
	var hud			 	: CR4ScriptedHud;
	var radialModule 	: CR4HudModuleRadialMenu;
	var guiManager 		: CR4GuiManager;
	
	theGame.FadeOutAsync(fadeTime, fadeColor );
	theGame.SetFadeLock( "Quest_FadeOutQuest" );
	
	hud = (CR4ScriptedHud)theGame.GetHud();
	
	if( hud )
	{
		radialModule = (CR4HudModuleRadialMenu)hud.GetHudModule("RadialMenuModule");
		if (radialModule && radialModule.IsRadialMenuOpened())
		{
			radialModule.HideRadialMenu();
		}
	}
	
	guiManager = theGame.GetGuiManager();
	if (guiManager && guiManager.IsAnyMenu())
	{
		guiManager.GetRootMenu().CloseMenu();
	}
}


quest function FadeInQuest( fadeTime : float )
{
	theGame.ResetFadeLock( "Quest_FadeInQuest" );
	theGame.FadeInAsync(fadeTime);
}


quest function ShowFastTravelLoadingScreen( fadeTime : float, enable : bool )
{
	
}




quest function SetLoadingScreenByCurrentLocation()
{
	var contextName : name;
	var mapManager : CCommonMapManager;
	
	mapManager = theGame.GetCommonMapManager();
	
	contextName = mapManager.GetLocalisationNameFromAreaType( mapManager.GetCurrentJournalAreaByPosition( thePlayer.GetWorldPosition() ) );
	theGame.SetSingleShotLoadingScreen( contextName );
}


quest function SwitchComponentStateQuest ( shouldBeEnabled : bool, objectTag : name, componentName : string)
{
	var entity    : array <CNode>;
	var component : array <CNode>;
	var count, i : int;
	var single_entity : CEntity;
	var single_component : CComponent;
	

	theGame.GetNodesByTag( objectTag, entity);
	count = entity.Size();
	
	for ( i = 0; i < count; i += 1 )
	{
		single_entity = (CEntity) entity[i];
		if ( ! single_entity )
			continue;
		
		single_component = single_entity.GetComponent( componentName );
		if ( ! single_component )
			continue;
		
		single_component.SetEnabled( shouldBeEnabled );
		single_component.SetShouldSave( true );
	}
}

enum EItemSelectionType
{
	IST_Equipped_Only,
	IST_All
}



quest function TransferPlayerItemsQuest(designatedContainerTag: name, itemSelectionType: EItemSelectionType, steelSword, silverSword, chestArmor, boots, gloves, pants, trophy, mask, bombs, lures, crossbow, secondaryWeapon : bool, optional fromContainerToPlayer : bool, optional equipAfterTransfer : bool )
{
	var player : W3PlayerWitcher;
	var ent : CEntity;
	var container : W3Container;
	var source, dest : CInventoryComponent;
	var items : array<SItemUniqueId>;
	var transferdItems : array<SItemUniqueId>;
	var equippedOnly : bool;
	var equipItems : bool;
	var i : int;
		
	ent = theGame.GetEntityByTag(designatedContainerTag);
	
	player = GetWitcherPlayer();
	
	if(! ((W3Container)ent) && ! ((CNewNPC)ent)  )
	{
		LogQuest( "TransferPlayerItemsQuest: <<" + designatedContainerTag + ">> is not a container or NPC! Aborting");
		return;
	}
	
	if(fromContainerToPlayer)
	{
		source = ((CGameplayEntity)ent).GetInventory();		
		dest = thePlayer.inv;
		equippedOnly = false;
		
		if ( equipAfterTransfer )
		{
			equipItems = true;
		}
	}
	else
	{
		dest = ((CGameplayEntity)ent).GetInventory();
		source = thePlayer.inv;
		equippedOnly = (itemSelectionType == IST_Equipped_Only);
		
		container = (W3Container)ent;
		if ( container )
		{
			container.SetIsQuestContainer( true );
		}
	}
	
	items = source.GetSpecifiedPlayerItemsQuest(steelSword, silverSword, chestArmor, boots, gloves, pants, trophy, mask, bombs, crossbow, secondaryWeapon, equippedOnly );
	
	if(!fromContainerToPlayer)
	{
		
		if( steelSword)		player.UnequipItemFromSlot(EES_SteelSword);
		if( silverSword)	player.UnequipItemFromSlot(EES_SilverSword);
		if( crossbow)       player.UnequipItemFromSlot(EES_RangedWeapon);
	}
	
	
	transferdItems = source.GiveItemsTo( dest, items, false, fromContainerToPlayer );
	
	if ( equipItems )
	{
		for ( i = 0; i < transferdItems.Size(); i+=1 )
		{
			if(thePlayer.HasRequiredLevelToEquipItem(transferdItems[i]))
				thePlayer.EquipItem ( transferdItems[i] );
		}
	}
}


quest function TransferItemQuest(sourceTag: name, targetTag: name, itemName: name, itemCategory: name, itemTag:name, quantity:int)
{	
	var source, target : CGameplayEntity;
	var container : W3Container;
	var sourceInv, targetInv : CInventoryComponent;
	var items : array<SItemUniqueId>;
	var i, itemAmount : int;
		
	source = (CGameplayEntity) theGame.GetEntityByTag(sourceTag);
	if(!source)
	{
		LogQuest( "TransferItemsQuest: Unable to find sounce entity by tag <<" + sourceTag + ">>");		
		return;
	}
		
	target = (CGameplayEntity) theGame.GetEntityByTag(targetTag);
	if(!target)
	{
		LogQuest( "TransferItemsQuest: Unable to find target entity by tag <<" + targetTag + ">>");		
		return;
	}
	container = (W3Container)target;
	if ( container )
	{
		container.SetIsQuestContainer( true );
	}
	
	sourceInv = source.GetInventory();
	targetInv = target.GetInventory();
	
	if ( !sourceInv || !targetInv )
	{
		LogQuest( "TransferItemsQuest: Unable to get an inventory for source and/or target");
		return;
	}
	
	if (quantity==0) quantity = 1;
	
	if(IsNameValid(itemName))
	{
		items = sourceInv.GetItemsByName(itemName);
	}
	else if(IsNameValid(itemCategory))
	{
		items = sourceInv.GetItemsByCategory(itemCategory);
	}
	else if(IsNameValid(itemTag))
	{
		items = sourceInv.GetItemsByTag(itemTag);
	}
	
	if(items.Size() <= 0)			
	{
		LogQuest("TransferItemsQuest: No items found for transfer");
		return;
	}
	
	if (quantity == -1)
		{
			sourceInv.GiveItemsTo( targetInv, items );
		}	
	else
	{		
		for(i=0; i<items.Size(); i+=1)
		{	
			if (quantity > 0)
			{	
				itemAmount = sourceInv.GetItemQuantity(items[i]);
				itemAmount = Min(itemAmount, quantity);
				sourceInv.GiveItemTo( targetInv, items[i], itemAmount, true );
				quantity -= itemAmount;
			}
			else
			{
				break;
			}
		}
	}
}

quest function RememberPlayerEquipment()
{
	var player : W3PlayerWitcher;
	
	player = GetWitcherPlayer();
	player.equipmentSlotHistory = player.GetEquippedItems();
}



quest function UnequipPlayerItemsQuest(steelSword, silverSword, chestArmor, boots, gloves, pants, trophy, bombs, lures, mask, potions, quickslot, bolts, all, crossbow, equipItems, rememberEquipment : bool, excludedItems : array <SItemNameProperty>, excludeHair, secondaryWeapon, forceRestore : bool )
{
	var player : W3PlayerWitcher;
	var inv : CInventoryComponent;
	var item : SItemUniqueId;
	var itemForSlot : SItemUniqueId;
	var items : array<SItemUniqueId>;
	var validItem : bool;
	var i : int;
	var currItemName : name;
	var isExcluded : bool;
	var currentSlot	: EEquipmentSlots;
	
	player = GetWitcherPlayer();
	
	if (!equipItems)
	{
		if (rememberEquipment) player.equipmentSlotHistory = player.GetEquippedItems();
	
		if(all || steelSword)		player.UnequipItemFromSlot(EES_SteelSword);
		if(all || silverSword)		player.UnequipItemFromSlot(EES_SilverSword);
		if(all || crossbow)        	player.UnequipItemFromSlot(EES_RangedWeapon);	
		if(all || chestArmor)		player.UnequipItemFromSlot(EES_Armor);
		if(all || boots)			player.UnequipItemFromSlot(EES_Boots);
		if(all || gloves)			player.UnequipItemFromSlot(EES_Gloves);
		if(all || pants)			player.UnequipItemFromSlot(EES_Pants);
		if(all || mask)				player.UnequipItemFromSlot(EES_Mask);
		if(all || bolts)			player.UnequipItemFromSlot(EES_Bolt);

		if(all || bombs || mask || potions || quickslot  )
		{
			inv = player.GetInventory();
		
			validItem = player.GetItemEquippedOnSlot(EES_Quickslot1, item);
			if(validItem && (all || (quickslot && inv.IsItemQuickslotItem(item)) || (mask && inv.IsItemMask(item))) )
				player.UnequipItemFromSlot(EES_Quickslot1);
			
			validItem = player.GetItemEquippedOnSlot(EES_Quickslot2, item);
			if(validItem && (all || (quickslot && inv.IsItemQuickslotItem(item)) || (mask && inv.IsItemMask(item))) )
				player.UnequipItemFromSlot(EES_Quickslot2);
				
			validItem = player.GetItemEquippedOnSlot(EES_Potion1, item);
			if(validItem && (all || (potions && inv.IsItemPotion(item))) )
				player.UnequipItemFromSlot(EES_Potion1);	

			validItem = player.GetItemEquippedOnSlot(EES_Potion2, item);
			if(validItem && (all || (potions && inv.IsItemPotion(item))) )
				player.UnequipItemFromSlot(EES_Potion2);
				
			validItem = player.GetItemEquippedOnSlot(EES_Potion3, item);
			if(validItem && (all || (potions && inv.IsItemPotion(item))) )
				player.UnequipItemFromSlot(EES_Potion3);
				
			validItem = player.GetItemEquippedOnSlot(EES_Potion4, item);
			if(validItem && (all || (potions && inv.IsItemPotion(item))) )
				player.UnequipItemFromSlot(EES_Potion4);

			validItem = player.GetItemEquippedOnSlot(EES_Petard1, item);
			if(validItem && (all || (bombs && inv.IsItemBomb(item)) ) )
				player.UnequipItemFromSlot(EES_Petard1);	

			validItem = player.GetItemEquippedOnSlot(EES_Petard2, item);
			if(validItem && (all || (bombs && inv.IsItemBomb(item)) ) )
				player.UnequipItemFromSlot(EES_Petard2);
				
		}
	}
	else
	{
		if ( equipItems )
		{
			if (rememberEquipment) 
			{
				items = player.equipmentSlotHistory;
				player.equipmentSlotHistory.Clear();
			}
			else
			{
				items = player.inv.GetSpecifiedPlayerItemsQuest(steelSword, silverSword, chestArmor, boots, gloves, pants, trophy, mask, bombs, crossbow, secondaryWeapon, false );
			}
			
			inv = player.GetInventory();
			
			for ( i = 0; i < items.Size(); i+=1 )
			{
				isExcluded = false;
				currItemName = inv.GetItemName(items[i]);
				
				if ( excludedItems.Size() > 0 )
				{
						
					isExcluded = inv.IsItemExcluded ( items[i], excludedItems );
						
					
					if (!isExcluded )
					{
						if( inv.GetItemCategory( items[i] ) != 'hair' && !player.IsItemEquippedByName(currItemName) )
						{
							currentSlot = inv.GetSlotForItemId( items[i] );
							
							if ( !inv.GetItemEquippedOnSlot( currentSlot,  itemForSlot ) || forceRestore )
							{
								thePlayer.EquipItem ( items[i] );
							}
							else if ( inv.IsItemExcluded ( itemForSlot, excludedItems ))
							{
								thePlayer.EquipItem ( items[i] );
							}
						}
						isExcluded = false;
					}
				}
				else
				{
					if( inv.GetItemCategory( items[i] ) != 'hair' && !player.IsItemEquippedByName(currItemName) )
					{
						currentSlot = inv.GetSlotForItemId( items[i] );
							
						if ( !inv.GetItemEquippedOnSlot( currentSlot,  itemForSlot ) || forceRestore )
						{
							thePlayer.EquipItem ( items[i] );
						}
					}
				}
			}
		}
	}
}





quest function DebugEnableShowFlag(showFlagName : EShowFlags, activate : bool)
{	
	DebugSetEShowFlag(showFlagName, activate);	
}

quest function DebugOverlayDisplay(overlayName : EEnvManagerModifier){
	EnableDebugOverlayFilter(overlayName);
}

quest function DebugSetPostProcessState(postProcessName : EDebugPostProcess, activate : bool){
	EnableDebugPostProcess(postProcessName, activate);
	}

quest function DebugDismemberNPC(npcTag : name)
{
	var actor	:	CActor;
	var dismemberComp	:	CDismembermentComponent;
	var allWounds	: array<name>;
	var getWound	: name;
	
	actor = theGame.GetActorByTag(npcTag);
	if(!actor){
		return;
	}else{
		dismemberComp = (CDismembermentComponent)(actor.GetComponentByClassName('CDismembermentComponent'));
	}
	
	if(!dismemberComp)
	{
		return;
	}else{
		
		dismemberComp.GetWoundsNames(allWounds, WTF_All);
	
		if (allWounds.Size() > 0){
			getWound = allWounds[RandRange(allWounds.Size())];
		}
	
		actor.SetWound(getWound, true, true, true, true);
	}
}





enum EQuestNPCStates
{
	EQNS_Default,
	EQNS_Dead,
	EQNS_Agony,
	EQNS_KnockedUnconscious,
	EQNS_DeadNoAgony,
	EQNS_DeadInstantRagdoll,
	EQNS_Combat
}


quest function ChangeNPCStateQuest(npcTag : name, npcState : EQuestNPCStates, ignoreImmortalityMode : bool)
{
	var actors : array<CActor>;
	var i : int;

	if(npcTag == 'PLAYER')
		actors.PushBack(thePlayer);
	else
		theGame.GetActorsByTag(npcTag, actors);
	
	if(actors.Size() <= 0)	
	{
		LogQuest( "ChangeNPCStateQuest: cannot find any actors with tag <<"+npcTag+">> aborting");
		return;
	}
	
	for(i=0; i<actors.Size(); i+=1)
	{
		if( npcState == EQNS_Dead )
		{
			actors[i].Kill( 'Quest', ignoreImmortalityMode );			
		}
		else if ( npcState == EQNS_DeadNoAgony )
		{
			((CNewNPC)actors[i]).DisableAgony();
			actors[i].Kill( 'Quest', ignoreImmortalityMode );
		}
		else if ( npcState == EQNS_KnockedUnconscious )
		{
			actors[i].SetImmortalityMode(AIM_Unconscious, AIC_Default, true);
			actors[i].Kill( 'Quest' );	
		}
		else if(npcState == EQNS_Agony)
		{
			if(actors[i] == thePlayer)
			{
				LogQuest( "ChangeNPCStateQuest: player cannot enter agony state! Ignoring");
				continue;
			}
			
			actors[i].SignalGameplayEvent('ForceAgony');
			actors[i].Kill( 'Quest', ignoreImmortalityMode );
		}
		else if(npcState == EQNS_Default)
		{
			if ( actors[i].IsKnockedUnconscious() )
				actors[i].SignalGameplayEvent('ForceStopUnconscious');
		}
		else if(npcState == EQNS_DeadInstantRagdoll)
		{
			((CNewNPC)actors[i]).DisableAgony();
			actors[i].Kill( 'Quest', ignoreImmortalityMode );
			if ( actors[i].IsVulnerable() || ignoreImmortalityMode )
				actors[i].SetKinematic(false);
		}
	}
}




quest function ChangeNPCStanceQuest( npcTag : name, npcStance : ENpcStance )
{
	var l_npc : CNewNPC;
	l_npc = (CNewNPC) theGame.GetActorByTag( npcTag );
	
	if( l_npc )
	{
		l_npc.ChangeStance( npcStance );
		if( npcStance == NS_Fly )
		{
			((CMovingPhysicalAgentComponent)l_npc.GetMovingAgentComponent()).SetAnimatedMovement( true );
		}
	}
}


quest function AddNPCModifierQuest(npcTag : name, buffEffects : array<EEffectType>, remove : bool, removeAll : bool, duration : float, valueAdditive : float, valueMultiplicative : float, valueBase : float, pause : bool, resume : bool, force : bool, pauseResumeSource : name)
{
	var params : SCustomEffectParams;
	var i,j : int;
	var actors : array<CActor>;
	var effectValue : SAbilityAttributeValue;
	

	if(buffEffects.Size() == 0 && !removeAll)
	{
		LogQuest( "AddNPCModifierQuest: empty buffs array passed, aborting");
		return;
	}
	
	if(pause && resume)
	{
		LogQuest( "AddNPCModifierQuest: cannot pause and resume at the same time - aborting!");
		return;
	}
	
	if(npcTag == 'PLAYER')
		actors.PushBack(thePlayer);
	else
		theGame.GetActorsByTag(npcTag, actors);
	
	if(actors.Size() <= 0)	
	{
		LogQuest( "AddNPCModifierQuest: cannot find any actors with tag <<"+npcTag+">>!!! Aborting");
		return;
	}
	
	if(!removeAll && !remove && duration != 0 && !pause && !resume)
	{
		params.sourceName = "quest";
		params.duration = duration;
		params.effectValue.valueAdditive = valueAdditive;
		params.effectValue.valueMultiplicative = valueMultiplicative;
		params.effectValue.valueBase = valueBase;
	}
	
	for(j=0; j<actors.Size(); j+=1)
	{
		if(removeAll)
		{
			actors[j].RemoveAllNonAutoBuffs();		
			continue;
		}
				
		for(i=0; i<buffEffects.Size(); i+=1)
		{					
			if(remove)
			{
				actors[j].RemoveAllBuffsOfType(buffEffects[i]);
			}
			else if(pause)
			{
				actors[j].PauseEffects(buffEffects[i], pauseResumeSource, true);
			}
			else if(resume)
			{
				actors[j].ResumeEffects(buffEffects[i], pauseResumeSource);
			}
			else
			{
				if ( force )
				{
					actors[j].SignalGameplayEvent( 'ForceCS' );
				}
				if ( duration == 0 )
				{
					actors[j].SoundSwitch( "opponent_weapon_type", 'empty');
					actors[j].SoundSwitch("opponent_weapon_size", '');
					actors[j].SoundSwitch("opponent_attack_type", '');
					actors[j].AddEffectDefault(buffEffects[i],NULL,"quest");
					
				}
				else
				{
					actors[j].SoundSwitch( "opponent_weapon_type", 'empty');
					actors[j].SoundSwitch("opponent_weapon_size", '');
					actors[j].SoundSwitch("opponent_attack_type", '');
					params.effectType = buffEffects[i];					
					actors[j].AddEffectCustom(params);
				}
			}
		}
	}
}




enum EDrawWeaponQuestType
{
	EDWQT_Steel,
	EDWQT_Silver,
	EDWQT_NoWeapon,
	EDWQT_Fists
}
quest function DrawWeaponQuest(weapon : EDrawWeaponQuestType, dontIgnoreDrawActionLock : bool)
{
	var i : int;
	var hasWeapon : bool;
	var inv : CInventoryComponent;
	var items : array<SItemUniqueId>;

	
	if(weapon == EDWQT_NoWeapon)
		thePlayer.OnMeleeForceHolster(!dontIgnoreDrawActionLock);
	else if((W3PlayerWitcher)thePlayer)
	{
		if(weapon == EDWQT_Silver)
		{
			hasWeapon = GetWitcherPlayer().IsAnyItemEquippedOnSlot(EES_SilverSword);
			
			if(!hasWeapon)
			{
				LogQuest("DrawWeaponQuest: witcher cannot draw silver sword as he has no silver weapon equipped, aborting!");
				return;
			}
			
			thePlayer.OnEquipMeleeWeapon(PW_Silver, !dontIgnoreDrawActionLock);
		}			
		else if(weapon == EDWQT_Steel)
		{
			hasWeapon = GetWitcherPlayer().IsAnyItemEquippedOnSlot(EES_SteelSword);
			
			if(!hasWeapon)
			{
				LogQuest("DrawWeaponQuest: witcher cannot draw steel sword as he has no steel weapon equipped, aborting!");
				return;
			}
			
			thePlayer.OnEquipMeleeWeapon(PW_Steel, !dontIgnoreDrawActionLock);
		}
		else if(weapon == EDWQT_Fists)
			thePlayer.OnEquipMeleeWeapon(PW_Fists, !dontIgnoreDrawActionLock);
	}
	else
	{
		if(weapon == EDWQT_Silver)
		{
			LogQuest("DrawWeaponQuest: player character is not witcher so he does not use silver weapon => cannot draw weapon, aborting!");
			return;
		}
		else if(weapon == EDWQT_Steel)
		{
			inv = thePlayer.inv;
			items = inv.GetAllWeapons();
			for(i=0; i<items.Size(); i+=1)
			{
				if(inv.IsItemMounted(items[i]))
				{
					hasWeapon = true;
					break;
				}
			}
			
			if(!hasWeapon)
			{
				LogQuest("DrawWeaponQuest: player does not have any weapon mounted, cannot equip steel weapon, aborting!");
				return;
			}
			
			thePlayer.OnEquipMeleeWeapon(PW_Steel, !dontIgnoreDrawActionLock);
		}
		else if(weapon == EDWQT_Fists)
			thePlayer.OnMeleeForceHolster(!dontIgnoreDrawActionLock);
	}
}

quest function DespawnNPCsWithTag( tag : name )
{
	var actors : array< CActor >;
	var i : int;
	
	theGame.GetActorsByTag( tag, actors );
	
	for( i = 0; i < actors.Size(); i+=1 )
	{
		actors[i].SignalGameplayEvent( 'Despawn' );
	}
}


enum ESwarmStateOnArrival
{
	SSOA_Idle,
	SSOA_Shield,
	SSOA_ClueBall,
}

quest function RequestSwarmAttackPlayer( tag : name, stateAfterAttack : ESwarmStateOnArrival, onArrivalFactID : string, onArrivalFactValue : int )
{
	
	var lair 			: CFlyingCrittersLairEntityScript;
	var stateName 		: name;
	var attackGroupID	: CFlyingGroupId;
	var i 				: int;
	
	lair = ((CFlyingCrittersLairEntityScript)theGame.GetEntityByTag(tag));
	if ( lair )
	{
		if ( stateAfterAttack == SSOA_Idle) { stateName = 'idle'; }
		if ( stateAfterAttack == SSOA_Shield) { stateName = 'shield'; }
		if ( stateAfterAttack == SSOA_ClueBall) { stateName = 'clueFly'; }
		if ( onArrivalFactID != "" && onArrivalFactID != "None" )
		{
			if ( onArrivalFactValue != 0 )
			{
				lair.SignalArrivalAtNode( 'attackPlayer', thePlayer, stateName, CFlyingGroupId(), 0, onArrivalFactID, onArrivalFactValue );
			}
			else
			{
				lair.SignalArrivalAtNode( 'attackPlayer', thePlayer, stateName, CFlyingGroupId(), 0, onArrivalFactID );
			}
		}
		else
		{
			lair.SignalArrivalAtNode( 'attackPlayer', thePlayer, stateName, CFlyingGroupId() );
		}		
	}
	else
	{
		LogChannel( 'swarmDebug', "Swarm lair with tag '" + tag + "' was not found" );
		LogQuest("Swarm lair with tag '" + tag + "' was not found" );
	}
}

quest function RequestSwarmGoTo( lairTag : name, initialStateName : name, stateAfterAttack : ESwarmStateOnArrival, onArrivalFactID : string, onArrivalFactValue : int )
{
	var lair 			: CFlyingCrittersLairEntityScript;
	var stateName 		: name;
	var attackGroupID	: CFlyingGroupId;
	var i 				: int;
	
	lair = ((CFlyingCrittersLairEntityScript)theGame.GetEntityByTag(lairTag));
	if ( lair )
	{
		if ( stateAfterAttack == SSOA_Idle) { stateName = 'idle'; }
		if ( stateAfterAttack == SSOA_Shield) { stateName = 'shield'; }
		if ( stateAfterAttack == SSOA_ClueBall) { stateName = 'clueFly'; }
		if ( onArrivalFactID != "" && onArrivalFactID != "None" )
		{
			if ( onArrivalFactValue != 0 )
			{
				lair.SignalArrivalAtNode( initialStateName, thePlayer, stateName, CFlyingGroupId(), 0, onArrivalFactID, onArrivalFactValue );
			}
			else
			{
				lair.SignalArrivalAtNode( initialStateName, thePlayer, stateName, CFlyingGroupId(), 0, onArrivalFactID );
			}
		}
		else
		{
			lair.SignalArrivalAtNode( initialStateName, thePlayer, stateName, CFlyingGroupId() );
		}
	}
	else
	{
		LogChannel( 'swarmDebug', "Swarm lair with tag '" + lairTag + "' was not found" );
	}
}

quest function SwarmFlying_RequestGroupStateChange_Quest( lairTag : name, groupState : name, affectAllGroups : bool )
{
	FlyingSwarm_RequestGroupStateChange( lairTag, groupState, affectAllGroups );
}
quest function SwarmFlying_RequestAllGroupsInstantDespawn_Quest( lairTag : name )
{
	FlyingSwarm_RequestAllGroupsInstantDespawn( lairTag );
}
quest function Swarm_DisablePOIs_Quest( poiTag : name, disable : bool )
{
	Swarm_DisablePOIs( poiTag, disable );
}
quest function Swarm_DisableLair_Quest( lairTag : name, disable : bool )
{
	Swarm_DisableLair( lairTag, disable );
}

quest function AnimalNervousState( npcsTag : name, reactionType : EAnimalReaction, percents : int )
{
	var actors : array< CActor >;
	var i : int;
	var perc : float;
	
	theGame.GetActorsByTag( npcsTag, actors );
		
	for( i = 0; i < actors.Size(); i+=1 )
	{
		if( reactionType == AR_Rearing )
		{
			actors[i].SignalGameplayEvent( 'HorseRearing' );
		}
		else if( reactionType == AR_Kick )
		{
			actors[i].SignalGameplayEvent( 'HorseKick' );
		}
		else if( reactionType == AR_Backing )
		{
			actors[i].SignalGameplayEvent( 'HorseBacking' );
		}
		else if( reactionType == AR_AddPanicPercents && (CNewNPC)actors[i] )
		{
			perc = percents * 0.01 * actors[i].GetStatMax( BCS_Panic );
			actors[i].AddPanic( perc );
		}		
	}
}

enum EAnimalReaction
{
	AR_Rearing,
	AR_Kick,
	AR_Backing,
	AR_AddPanicPercents
}

quest function TeleportObject( objectTag: name, destinationTag: name, xOffset : float, yOffset : float, zOffset : float, useSafePlacement : bool, onSafePlacementFailUseBruteForce : bool )
{
	var object, destination : CEntity;
	var position : Vector;
	var safePosition : Vector;
	var z : float;
	var safePlacementFound : bool;
	
	destination = (CEntity) theGame.GetNodeByTag( destinationTag );
	object = (CEntity) theGame.GetNodeByTag( objectTag );
	
	position = destination.GetWorldPosition();
	position = Vector( position.X + xOffset, position.Y + yOffset, position.Z + zOffset );
	
	if( useSafePlacement )
	{
		if( theGame.GetWorld().NavigationFindSafeSpot( position, 1.0, 6.0, safePosition ) )
		{
			if ( theGame.GetWorld().NavigationComputeZ(safePosition, safePosition.Z - 5.0, safePosition.Z + 5.0, z) )
			{
				safePosition.Z = z;
				if ( theGame.GetWorld().NavigationFindSafeSpot( safePosition, 1.0, 6.0, safePosition ) )
					safePlacementFound = true;
			}
		}
		
		if( safePlacementFound )
		{
			object.TeleportWithRotation( safePosition, destination.GetWorldRotation() );
		}
		else
		{
			if( onSafePlacementFailUseBruteForce )
			{
				object.TeleportWithRotation( position, destination.GetWorldRotation() );
			}
		}
		
	}
	else
	{
		object.TeleportWithRotation( position, destination.GetWorldRotation() );
	}
	
}


quest function FaceObjectQuest( objectsTag: name, TargetTag: name, degreeModifier : float )
{

	var objects : array<CNode>;
	var object : CEntity;
	var target : CNode;
	var i: int;
	
	var rot : EulerAngles;
	var targetPos : Vector;
	var headingVec : Vector;
	var Pos : Vector;
	
	theGame.GetNodesByTag( objectsTag, objects );
	target = theGame.GetNodeByTag( TargetTag );

	if(objects.Size() == 0)return;
	
	targetPos = target.GetWorldPosition();
	
	for( i = 0; i < objects.Size(); i+=1 )
	{
		object = (CEntity) objects[i];
		Pos = object.GetWorldPosition();
		headingVec = targetPos - Pos;
		rot = VecToRotation(headingVec);

		rot = EulerAdd(EulerAngles(0.0f, rot.Yaw, 0.0f), EulerAngles(0.0f, degreeModifier, 0.0f));
		
		object.TeleportWithRotation(Pos, rot );
	}

}

quest function AddTagToEntitiesQuest( entityTag : name, newTag:name, remove : bool )
{
	var entity, target : CEntity;		
	var entities : array <CEntity>;
	var tags : array<name>;
	var i      : int;
	
	theGame.GetEntitiesByTag(entityTag,entities);
	if ( entities.Size() <= 0 ) 
	{
		LogQuest("AddTagToEntitiesQuest_questFunction: no NPC with tag " + entityTag + " found!!!");
		return;
	}
	
	for ( i=0 ; i < entities.Size() ; i+=1 )
	{
		entity = entities[i];
		tags =  entity.GetTags();
		
		if ( !remove )
		{
			tags.PushBack(newTag);
		}
		else
		{
			if ( !tags.Remove(newTag) )
			{
				LogQuest("AddTagToNPCsQuest_questFunction: npc doesn't have " + entityTag + " tag!!! ");
				continue;
			}
		}
		entity.SetTags(tags);
	}
}

quest function AddTagToNPCsQuest( npcTag : name, newTag:name, remove : bool )
{
	var npc, target : CNewNPC;		
	var npcs : array <CNewNPC>;
	var tags : array<name>;
	var i      : int;
	
	theGame.GetNPCsByTag(npcTag,npcs);
	if ( npcs.Size() <= 0 ) 
	{
		LogQuest("AddTagToNPCsQuest_questFunction: no NPC with tag " + npcTag + " found!!!");
		return;
	}
	
	for ( i=0 ; i < npcs.Size() ; i+=1 )
	{
		npc = npcs[i];
		tags =  npc.GetTags();
		
		if ( !remove )
		{
			tags.PushBack(newTag);
		}
		else
		{
			if ( !tags.Remove(newTag) )
			{
				LogQuest("AddTagToNPCsQuest_questFunction: npc doesn't have " + npcTag + " tag!!! ");
				continue;
			}
		}
		npc.SetTags(tags);
	}
}

quest function AddTagToNearestActorQuest( actorTag : name, newTag:name, remove : bool )
{
	var entities : array <CGameplayEntity>;		
	var actor : CActor;
	var tags : array<name>;
	var i      : int;
	
	FindGameplayEntitiesInSphere(entities,thePlayer.GetWorldPosition(),1000,1,actorTag,FLAG_OnlyAliveActors+FLAG_ExcludePlayer);
	if ( entities.Size() <= 0 ) 
	{
		LogQuest("AddTagToNPCsQuest_questFunction: no Actor with tag " + actorTag + " found!!!");
		return;
	}
	else
	{
		actor = (CActor)entities[0];
		tags =  actor.GetTags();
		if ( !remove )
		{
			tags.PushBack(newTag);
		}
		else
		{
			if ( !tags.Remove(newTag) )
			{
				LogQuest("AddTagToNPCsQuest_questFunction: Actor doesn't have " + actorTag + " tag!!! ");
			}
		}
		actor.SetTags(tags);
	}
}

quest function AddTagToClosestNode( nodesTag: name, newTag: name, remove: bool)
{
	var foundEntities : array< CNode >;
	var closestNode : CNode;
	var tags : array<name>;
	
	theGame.GetNodesByTag( nodesTag, foundEntities );
	
	closestNode = FindClosestNode( thePlayer.GetWorldPosition(), foundEntities );
	
	tags =  closestNode.GetTags();
	
	if ( !remove )
	{
		tags.PushBack(newTag);
	}
	else
	{
		if ( !tags.Remove(newTag) )
		{
			LogQuest("AddTagToClosestEntity_questFunction: GameplayEntity doesn't have " + newTag + " tag!!! ");
		}
	}
	closestNode.SetTags(tags);
}

quest function ChangeCombatStyleByTag( preferedCombatStyle : EBehaviorGraph, npcTag : name)
{
	var npcs : array <CNewNPC>;
	var i      : int;
	
	theGame.GetNPCsByTag(npcTag,npcs);
	if ( npcs.Size() <= 0 ) 
	{
		LogQuest("ChangeCombatStyleByTag_questFunction: no NPC with tag " + npcTag + " found!!!");
		return;
	}
	
	for ( i=0 ; i < npcs.Size() ; i+=1 )
	{
		npcs[i].SignalGameplayEventParamInt('ChangePreferedCombatStyle',(int)preferedCombatStyle );
		if ( preferedCombatStyle == EBG_Combat_Fists )
		{
			npcs[i].fistFightForcedFromQuest = true;
			npcs[i].AddTimer('AddLevelBonuses', 1.0f, true, false, , true);
		}
	}
}

quest function CameraShake( strength : float )
{
	GCameraShake(strength);
}

quest function CameraShakeLooped( strength : float, loopTime : float, animName : name )
{
	var player  : CR4Player = thePlayer;

	GCameraShake(strength, false, Vector(0,0,0), 0.f, true);
	if ( loopTime > 0.f )
	{
		thePlayer.RemoveQuestCameraShake( player.loopingCameraShakeAnimName );
		player.loopingCameraShakeAnimName = animName;
		thePlayer.AddTimer( 'RemoveQuestCameraShakeTimer', loopTime );
	}
}

quest function StopCameraShake( animName : name )
{
	thePlayer.RemoveQuestCameraShake( animName );
}

quest function InstantMountPlayer ( vehicleTag : name, vehicleType : EVehicleType, dismount : bool, useAnim : bool )
{
	var vehicleEntity 		: CEntity;
	var createEntityHelper 	: CR4CreateEntityHelper;
	var vehicle 			: CVehicleComponent; 
	
	if ( dismount == false )
	{
		if ( vehicleTag != 'None' )
		{
			vehicleEntity = theGame.GetEntityByTag( vehicleTag );
		}

		if ( vehicleEntity )
		{
			if ( vehicleType == EVT_Horse )
			{
				vehicle = (CVehicleComponent)( vehicleEntity.GetComponentByClassName('W3HorseComponent') );
				
				if ( !vehicle )
				{
					LogAssert( vehicle, "InstantMountPlayer: Entity with tag <<" + vehicleTag + ">> is not a horse !!" );
					return;
				}
			}
			else
			{
				vehicle = (CVehicleComponent)( vehicleEntity.GetComponentByClassName('CBoatComponent') );
				if ( !vehicle )
				{
					LogAssert( vehicle, "InstantMountPlayer: Entity with tag <<" + vehicleTag + ">> is not a boat !!" );
					return;
				}
			}
		}
		else
		{
			if ( vehicleType == EVT_Horse )
			{
				
				vehicleEntity = thePlayer.GetHorseWithInventory();
				
				if ( !vehicleEntity )
				{
					createEntityHelper = new CR4CreateEntityHelper in thePlayer;
					createEntityHelper.SetPostAttachedCallback( thePlayer, 'OnInstantMountVehicle' );
					theGame.SummonPlayerHorse( false, createEntityHelper );
					return;
				}
			}
			else
			{
				LogQuest( "InstantMountPlayer: Boat with tag <<" + vehicleTag + ">> doesn't exist !!" );
				return;
			}
		}
		
		if ( useAnim )
			thePlayer.MountVehicle( vehicleEntity, VMT_ApproachAndMount);
		else
			thePlayer.MountVehicle( vehicleEntity, VMT_ImmediateUse);
		
	}
	else
	{
		if ( vehicleType == EVT_Horse )
		{
			vehicleEntity = thePlayer.GetHorseCurrentlyMounted();
			if ( !vehicleEntity )
			{
				LogQuest( "InstantMountPlayer: Geralt is not on horse!!" );
				return;
			}
		}
		else 
		{
			if ( vehicleTag != 'None' )
			{
				vehicleEntity = theGame.GetEntityByTag( vehicleTag );
			}
			else
			{
				vehicleEntity = thePlayer.GetUsedVehicle();
			}
			
			if ( !vehicleEntity )
				return;
		}
		
		if ( useAnim )
		{
			
			thePlayer.GetUsedHorseComponent().OnSmartDismount();
		}
		else
			thePlayer.DismountVehicle( vehicleEntity, DT_instant );
	}
}


quest function InstantDismountPlayer ( )
{	
	thePlayer.DismountVehicle( thePlayer.GetHorseCurrentlyMounted(), DT_instant );
}

quest function InstantMountNPC ( npcTag : name )
{
	var actor 				: CActor;
	var entities			: array<CEntity>;
	var i 					: int;
	
	theGame.GetEntitiesByTag( npcTag, entities );
		
	for ( i = 0; i < entities.Size(); i += 1 )
	{
		actor = (CActor)entities[ i ];
		if ( actor )
		{
			actor.SignalGameplayEventParamInt( 'RidingManagerMountHorse', MT_instant | MT_fromScript );
		}
	}
}

quest function InstantDismountNPC ( npcTag : name, dismountType : EDismountType )
{
	var actor 				: CActor;
	var entities			: array<CEntity>;
	var i 					: int;
	
	if ( dismountType == 0 )
		dismountType = DT_normal;
	
	theGame.GetEntitiesByTag( npcTag, entities );
		
	for ( i = 0; i < entities.Size(); i += 1 )
	{
		actor = (CActor)entities[ i ];
		if ( actor )
		{
			actor.SignalGameplayEventParamInt( 'RidingManagerDismountHorse', dismountType | DT_fromScript );
		}
	}
}

quest function TameHorse( horseTag : name, tame : bool, riderTag : name )
{
	var horseEntity 			: CEntity;
	var riderActor 				: CActor;
	var horseComponent 			: W3HorseComponent;
	
	if ( horseTag != 'None' )
	{
		horseEntity = theGame.GetEntityByTag( horseTag );
	}
	if ( riderTag != 'None' )
	{
		riderActor = (CActor)theGame.GetEntityByTag( riderTag );
	}
	
	if ( horseEntity )
	{
		horseComponent = (W3HorseComponent)horseEntity.GetComponentByClassName( 'W3HorseComponent' );
		horseComponent.Tame( riderActor, tame );
	}
}

quest function SoundSetState( soundState : ESoundGameState )
{
	theSound.EnterGameState( soundState );
}

enum EDoorQuestState
{
	EDQS_Open,
	EDQS_Close,
	EDQS_RemoveLock,
	EDQS_Enable,
	EDQS_Disable,
	EDQS_Lock
}

quest function DoorChangeState(tag : name, newState : EDoorQuestState, optional keyItemName : name, optional removeKeyOnUse : bool, optional smoooth : bool, optional dontBlockInCombat : bool )
{
	var nodes : array<CNode>;
	var entity : CEntity;
	var door : W3Door;
	var newDoorEntity : W3NewDoor;
	var doorComponent : CDoorComponent;
	var lockableEntity : W3LockableEntity;
	var i : int;
	
	theGame.GetNodesByTag(tag, nodes);
	
	for(i=0; i<nodes.Size(); i+=1)
	{
		
		
		door = (W3Door)nodes[i];
		if(door)
		{			
			switch(newState)
			{
				case EDQS_Open:
					door.Open();
					break;
				case EDQS_Close:
					door.Close();
					break;
				case EDQS_RemoveLock:
					door.Unlock();
					break;
				case EDQS_Enable:
					door.Enable(true);
					break;
				case EDQS_Disable:
					door.Enable(false);
					break;
				case EDQS_Lock:
					door.Lock(keyItemName, removeKeyOnUse);
					break;
			}
		}
		else
		{
			
			entity = (CEntity)nodes[i];
			if( !entity )
			{
				continue;
			}
			
			doorComponent = (CDoorComponent)entity.GetComponentByClassName( 'CDoorComponent' );			
			lockableEntity = (W3LockableEntity)entity;
			newDoorEntity = (W3NewDoor)entity;
			if ( newDoorEntity )
			{
				newDoorEntity.EnableDeniedAreaInCombat( !dontBlockInCombat );
			}
			
			switch(newState)
			{
				case EDQS_Open:
					if( doorComponent )
					{
						if( smoooth )
						{
							doorComponent.Open( true, true );
						}
						else
						{
							doorComponent.InstantOpen( true );
						}
					}
					break;
				case EDQS_Close:
					if( doorComponent )
					{
						if( smoooth )
						{
							doorComponent.Close( true );
						}
						else
						{
							doorComponent.InstantClose();
						}
					}
					break;
				case EDQS_Enable:
					if( lockableEntity )
					{
						lockableEntity.Enable( true );
					}
					else if( doorComponent )
					{
						doorComponent.SetEnabled( true );
					}
					break;
				case EDQS_Disable:
					if( lockableEntity )
					{
						lockableEntity.Enable( false );
					}
					else if( doorComponent )
					{
						doorComponent.SetEnabled( false );
					}
					break;
				case EDQS_RemoveLock:
					if( lockableEntity )
					{
						lockableEntity.Unlock();							
					}
					break;
				case EDQS_Lock:											
					if( lockableEntity )
					{
						lockableEntity.Lock(keyItemName, removeKeyOnUse, smoooth );							
					}
					break;
			}			
			
		}
	}
}

quest function BlockLockableInteraction(tag : name, block : bool)
{
	var nodes : array<CNode>;
	var i : int;
	var didSomething : bool;
	var lockable : W3LockableEntity;
	
	theGame.GetNodesByTag(tag, nodes);
	
	didSomething = false;
	for(i=0; i<nodes.Size(); i+=1)
	{
		lockable = (W3LockableEntity)nodes[i];
		if(lockable)
		{
			didSomething = true;
			lockable.SetInteractionBlocked(block);
		}
	}
	
	if(!didSomething)
		LogQuest("BlockLockableInteraction: cannot find any LockableEntity with tag <<" + tag + ">> !!!");
}

latent function QuestHelper_BlockGameplayFunctionality(act : EInputActionBlock, sourceName : name, lock : bool)
{
	var locking : string;

	if(lock)
		locking = "  Locking";
	else
		locking = "Unlocking";
		
	if(FactsQuerySum("debug_BGF_single_channels") > 0)
		LogChannel(sourceName, locking + " action " + act + "...");
	else
		LogBlockGameplayFunctionality(NameToString(sourceName), locking + " action " + act + "...");
		
	while(true)
	{
		if( lock )
		{
			if( thePlayer.BlockAction( act, sourceName, true, true ) )
			{
				break;
			}
		}
		else
		{
			if( thePlayer.UnblockAction( act, sourceName ) )
			{
				break;
			}
		}
		
		Sleep(0.1);
	}
	
	if(FactsQuerySum("debug_BGF_single_channels") > 0)
		LogChannel(sourceName, "Done");
	else
		LogBlockGameplayFunctionality(NameToString(sourceName),"Done");
}


latent quest function BlockGameplayFunctionality(lock : bool, sourceName : name, signs, drawWeapon, openInventory, openPreparation, radialMenu, callHorse, fastTravel, movement, jump, meditation, bombThrow, runAndSprint, sprint, openMap, openCharacterPanel, openJournal, highlightObjective, openAlchemy, explorationFocus, dive, interactions, explorations, climb, slide, mount, dismount, fistFight, swordAttacks, lightAttacks, heavyAttacks, dodgee, roll, parry, counter, quickslots, custom0, crossbow, usableItem, openGlossary, hardLockTarget, meditationWaiting, interactionContainers, XXXXXXX, allGUI, all, sheatheWeaponIfDrawn, specialLightAttack, specialHeavyAttack, openGwint, openFastMenu, openMeditation, noticeboards : bool)
{
	var ret : bool;
	var locking : string;

	if( (lock || !(all || allGUI)) && !IsNameValid(sourceName))
	{
		LogBlockGameplayFunctionality(sourceName, "Source name is not a valid name! You must provide it! Skipping block!");
		return;
	}
	
	if(lock)
		locking = "  Locking";
	else
		locking = "Unlocking";
	
	if(allGUI)
	{
		
		if(FactsQuerySum("debug_BGF_single_channels") > 0)
			LogChannel(sourceName, locking + " action    " + "All GUI Panels...");
		else
			LogBlockGameplayFunctionality(NameToString(sourceName), locking + " action    " + "All GUI Panels...");
			
		
		thePlayer.BlockAllUIQuestActions(sourceName, lock);
		
		
		if(FactsQuerySum("debug_BGF_single_channels") > 0)
			LogChannel(sourceName, "Done");
		else
			LogBlockGameplayFunctionality(NameToString(sourceName),"Done");
	}
	if(all)
	{
		
		if(FactsQuerySum("debug_BGF_single_channels") > 0)
			LogChannel(sourceName, locking + " action    " + "All Actions...");
		else
			LogBlockGameplayFunctionality(NameToString(sourceName), locking + " action    " + "All Actions...");
			
		
		thePlayer.BlockAllQuestActions(sourceName, lock);
		
		
		if(FactsQuerySum("debug_BGF_single_channels") > 0)
			LogChannel(sourceName, "Done");
		else
			LogBlockGameplayFunctionality(NameToString(sourceName),"Done");
	}
	
	
	if(sheatheWeaponIfDrawn && thePlayer.GetCurrentMeleeWeaponType() != PW_None )
	{
		
		thePlayer.OnMeleeForceHolster(true);
			
		
		thePlayer.DisableCombatState();
	}
	
	if(!all && !allGUI)
	{		
		if(signs)			QuestHelper_BlockGameplayFunctionality(EIAB_Signs, sourceName, lock);	
		if(drawWeapon)		QuestHelper_BlockGameplayFunctionality(EIAB_DrawWeapon, sourceName, lock);
		if(openPreparation)	QuestHelper_BlockGameplayFunctionality(EIAB_OpenPreparation, sourceName, lock);
		if(meditationWaiting)	QuestHelper_BlockGameplayFunctionality(EIAB_MeditationWaiting, sourceName, lock);	
		if(openInventory)	QuestHelper_BlockGameplayFunctionality(EIAB_OpenInventory, sourceName, lock);
		if(radialMenu)		QuestHelper_BlockGameplayFunctionality(EIAB_RadialMenu, sourceName, lock);
		if(callHorse)		QuestHelper_BlockGameplayFunctionality(EIAB_CallHorse, sourceName, lock);
		if(fastTravel)		QuestHelper_BlockGameplayFunctionality(EIAB_FastTravel, sourceName, lock);
		if(fistFight)		QuestHelper_BlockGameplayFunctionality(EIAB_Fists, sourceName, lock);
		if(bombThrow)		QuestHelper_BlockGameplayFunctionality(EIAB_ThrowBomb, sourceName, lock);
		if(crossbow)		QuestHelper_BlockGameplayFunctionality(EIAB_Crossbow, sourceName, lock);
		if(usableItem)		QuestHelper_BlockGameplayFunctionality(EIAB_UsableItem, sourceName, lock);
		if(runAndSprint)	QuestHelper_BlockGameplayFunctionality(EIAB_RunAndSprint, sourceName, lock);
		if(highlightObjective)	QuestHelper_BlockGameplayFunctionality(EIAB_HighlightObjective, sourceName, lock);
		if(jump)			QuestHelper_BlockGameplayFunctionality(EIAB_Jump, sourceName, lock);
		if(roll)			QuestHelper_BlockGameplayFunctionality(EIAB_Roll, sourceName, lock);
		if(custom0)			QuestHelper_BlockGameplayFunctionality(EIAB_InteractionAction, sourceName, lock);
		if(sprint)			QuestHelper_BlockGameplayFunctionality(EIAB_Sprint, sourceName, lock);
		if(hardLockTarget)  QuestHelper_BlockGameplayFunctionality(EIAB_HardLock, sourceName, lock);
		if(explorations)	QuestHelper_BlockGameplayFunctionality(EIAB_Explorations, sourceName, lock);
		if(climb)			QuestHelper_BlockGameplayFunctionality(EIAB_Climb, sourceName, lock);
		if(slide)			QuestHelper_BlockGameplayFunctionality(EIAB_Slide, sourceName, lock);
		if(interactionContainers) QuestHelper_BlockGameplayFunctionality(EIAB_InteractionContainers, sourceName, lock);
		if(movement)
		{
			QuestHelper_BlockGameplayFunctionality(EIAB_Movement, sourceName, lock);
			thePlayer.SetIsMovable( !lock );
		}
		if(meditation)			QuestHelper_BlockGameplayFunctionality(EIAB_MeditationWaiting, sourceName, lock);
		if(openMap)				QuestHelper_BlockGameplayFunctionality(EIAB_OpenMap, sourceName, lock);
		if(openCharacterPanel)	QuestHelper_BlockGameplayFunctionality(EIAB_OpenCharacterPanel, sourceName, lock);
		if(openGlossary)		QuestHelper_BlockGameplayFunctionality(EIAB_OpenGlossary, sourceName, lock);
		if(openJournal)			QuestHelper_BlockGameplayFunctionality(EIAB_OpenJournal, sourceName, lock);
		if(openAlchemy)			QuestHelper_BlockGameplayFunctionality(EIAB_OpenAlchemy, sourceName, lock);
		if(explorationFocus)	QuestHelper_BlockGameplayFunctionality(EIAB_ExplorationFocus, sourceName, lock);
		if(dive)				QuestHelper_BlockGameplayFunctionality(EIAB_Dive, sourceName, lock);
		if(interactions)		QuestHelper_BlockGameplayFunctionality(EIAB_Interactions, sourceName, lock);
		if(mount)				QuestHelper_BlockGameplayFunctionality(EIAB_MountVehicle, sourceName, lock);
		if(dismount)			QuestHelper_BlockGameplayFunctionality(EIAB_DismountVehicle, sourceName, lock);
		if(swordAttacks)		QuestHelper_BlockGameplayFunctionality(EIAB_SwordAttack, sourceName, lock);
		if(dodgee)				QuestHelper_BlockGameplayFunctionality(EIAB_Dodge, sourceName, lock);
		if(parry)				QuestHelper_BlockGameplayFunctionality(EIAB_Parry, sourceName, lock);
		if(counter)				QuestHelper_BlockGameplayFunctionality(EIAB_Counter, sourceName, lock);
		if(openGwint)			QuestHelper_BlockGameplayFunctionality(EIAB_OpenGwint, sourceName, lock);
		if(openFastMenu)		QuestHelper_BlockGameplayFunctionality(EIAB_OpenFastMenu, sourceName, lock);
		if(lightAttacks)
		{
			QuestHelper_BlockGameplayFunctionality(EIAB_LightAttacks, sourceName, lock);
			QuestHelper_BlockGameplayFunctionality(EIAB_SpecialAttackLight, sourceName, lock);
		}
		if(heavyAttacks)
		{
			QuestHelper_BlockGameplayFunctionality(EIAB_HeavyAttacks, sourceName, lock);
			QuestHelper_BlockGameplayFunctionality(EIAB_SpecialAttackHeavy, sourceName, lock);
		}
		if(specialLightAttack)	QuestHelper_BlockGameplayFunctionality(EIAB_SpecialAttackLight, sourceName, lock);
		if(specialHeavyAttack)	QuestHelper_BlockGameplayFunctionality(EIAB_SpecialAttackHeavy, sourceName, lock);
		if(quickslots)			QuestHelper_BlockGameplayFunctionality(EIAB_QuickSlots, sourceName, lock);
		if(openMeditation)		
			QuestHelper_BlockGameplayFunctionality(EIAB_OpenMeditation, sourceName, lock);
		if(noticeboards)		
			QuestHelper_BlockGameplayFunctionality(EIAB_Noticeboards, sourceName, lock);
	}
	
	if(FactsQuerySum("debug_BGF_single_channels") > 0)
		LogChannel(sourceName,"");
	else
		LogChannel('QuestBlockGF', "");
}

quest function ShootProjectileByTag( projectileTag : name, optional targetTag: name, optional speed : float, optional angle : float, optional range : float )
{
	var nodes : array<CNode>;
	var advProj : W3AdvancedProjectile;
	var proj : CProjectileTrajectory;
	var target : CNode;
	var actorTarget : CActor;
	var targetPosition : Vector;
	
	var i : int;
	
	theGame.GetNodesByTag(projectileTag, nodes);
	
	if ( targetTag )
		target = theGame.GetNodeByTag(targetTag);
	
	for ( i=0 ; i < nodes.Size() ; i+=1 )
	{
		proj = (CProjectileTrajectory)nodes[i];
		
		if (!proj)
			continue;
		
		if ( !speed )
		{
			advProj = (W3AdvancedProjectile)proj;
			if ( advProj )
				speed = advProj.projSpeed;
			else
				speed = 25;
		}
		
		if ( target )
		{
			actorTarget = (CActor)target;
			if ( actorTarget )
			{
				targetPosition = actorTarget.GetWorldPosition();
				targetPosition.Z += 1.5;
			}
			else
				targetPosition = target.GetWorldPosition();
			
		}
		if ( range )
			proj.ShootProjectileAtPosition( angle, speed, targetPosition );
		else
			proj.ShootProjectileAtPosition( angle, speed, targetPosition, range );
	}
}

quest function ShootProjectileByEntityName( advProjectileName : string, sourceTag: name, optional slotName : name, targetTag: name, optional speed : float, optional angle : float, optional range : float, optional damage : float  )
{
	var source : CNode;
	var sourceEntity : CGameplayEntity;
	var proj : W3AdvancedProjectile;
	var advProjectile : CEntityTemplate;
	var target : CNode;
	var actorTarget : CActor;
	var targetPosition : Vector;
	var shootPos : Vector;
	var slotMatrix : Matrix;
	var rot : EulerAngles;
	
	source = theGame.GetNodeByTag(sourceTag);
	
	if ( source )
	{
		if ( slotName )
		{
			sourceEntity = (CGameplayEntity) source;
			if (sourceEntity && sourceEntity.CalcEntitySlotMatrix( slotName, slotMatrix ))
			{
				shootPos = MatrixGetTranslation( slotMatrix );
			}
			else
			{
				LogAssert(false, "source  has no projectile slot with given name. Setting projectiel to source's local 0.0.0");
				shootPos = source.GetWorldPosition();
			}
		}
		else
		{
			shootPos = source.GetWorldPosition();
		}
		
		if ( targetTag )
		{
			target = theGame.GetNodeByTag(targetTag);
			if ( target )
			{
				rot = VecToRotation ( source.GetWorldPosition() - target.GetWorldPosition() );
			}
			else
			{
				rot = source.GetWorldRotation();
			}
		}
		
		advProjectile = (CEntityTemplate)LoadResource( advProjectileName );
		proj = (W3AdvancedProjectile) theGame.CreateEntity( advProjectile, shootPos, rot );
		
		if ( proj )
		{
			if ( sourceEntity )
			{				
				proj.Init ( sourceEntity );
			}
			else
			{
				proj.OnProjectileInit();
			}
			
			if ( !speed )
			{			
				speed = proj.projSpeed;
							
			}
			
			if ( damage )
			{
				proj.projDMG = damage;
			}
			
			if ( target )
			{				
				actorTarget = (CActor)target;
				if ( actorTarget )
				{
					targetPosition = actorTarget.GetWorldPosition();
					targetPosition.Z += 1.5;
				}
				else
				{
					targetPosition = target.GetWorldPosition();
				}
				
			}
			if ( range )
			{
				proj.ShootProjectileAtPosition( angle, speed, targetPosition, range );
			}
			else
			{
				proj.ShootProjectileAtPosition( angle, speed, targetPosition );
			}
		}
	}
}



exec function bgfsinglechannels()
{
	if(FactsQuerySum("debug_BGF_single_channels") > 0)
		FactsRemove("debug_BGF_single_channels");
	else
		FactsAdd("debug_BGF_single_channels");
}

exec function bgfstatus()
{
	var i,j : int;
	var locks : array<SInputActionLock>;
	var fakeCast : EInputActionBlock;
		
	LogChannel('QuestBlockGF', "------------------------------------------------------------");
	LogChannel('QuestBlockGF', "Current action locks are:");
	
	for(i=0; i<EnumGetMax('EInputActionBlock')+1; i+=1)
	{
		locks.Clear();
		locks = thePlayer.GetActionLocks(i);
		LogChannel('QuestBlockGF', "");
		fakeCast = i;
		LogChannel('QuestBlockGF', "* " + fakeCast + ":");
		
		for(j=0; j<locks.Size(); j+=1)
			LogChannel('QuestBlockGF', locks[j].sourceName + ", removedOnSpawn=" + locks[j].removedOnSpawn + ", isQuestLock=" + locks[j].isFromQuest );
	}
	LogChannel('QuestBlockGF', "------------------------------------------------------------");
}

latent quest function TogglePhysicalDamageMechanismByTag( tag : name, toggle : bool )
{
	var nodes : array<CNode>;
	var i : int;
	
	theGame.GetNodesByTag(tag, nodes);
	
	if ( toggle )
		for ( i=0 ; i < nodes.Size() ; i+=1 )
			((W3PhysicalDamageMechanism)nodes[i]).Activate();
	else
		for ( i=0 ; i < nodes.Size() ; i+=1 )
			((W3PhysicalDamageMechanism)nodes[i]).Deactivate();
} 

quest function KillPlayer(ignoreImmortalityMode : bool)
{
	thePlayer.Kill( 'Quest', ignoreImmortalityMode);
}

quest function DrawableComponentVisiblityQuest( objectTag : name, componentName : name, on : bool )
{
	var objects : array < CNode >;
	var component : CDrawableComponent;
	var singleEntity : CEntity;
	var i : int;
	var isVisible : bool;
	
	theGame.GetNodesByTag( objectTag, objects );
	
	for ( i=0 ; i < objects.Size() ; i+=1 )	
	{
		singleEntity = (CEntity) objects[i];
		component = (CDrawableComponent)singleEntity.GetComponent( componentName );
		
		if(on == true)
		{
			component.SetVisible(true);
		}
		else
		{
			component.SetVisible(false);		
		}
		
	}

}

quest function ToggleRagdollByTag( tag : name , toggle : bool )
{
	var i : int;
	var actors : array<CActor>;
	
	if(tag == 'PLAYER')
		actors.PushBack(thePlayer);
	else
		theGame.GetActorsByTag(tag, actors);
	
	if(actors.Size() <= 0)	
	{
		LogQuest( "ToggleRagdollByTag: cannot find any actors with tag <<"+tag+">>!!! Aborting");
		return;
	}
	
	for(i=0; i<actors.Size(); i+=1)
	{
		if(toggle)
		{
			actors[i].AddEffectDefault(EET_Ragdoll, NULL);
		}
		else
		{
			actors[i].RemoveAllBuffsOfType(EET_Ragdoll);
		}
	}
}


quest function MonsterHuntingClueHandler( huntingNumber : name, clueNumber : name ) : bool
{	
	if( FactsDoesExist( 'mh_'+huntingNumber+'_'+clueNumber ) == false )
	{
		FactsAdd('mh_'+huntingNumber+'_'+clueNumber, 1);
		FactsAdd('mh_'+huntingNumber+'_total', 1);
		
		return true;
	}
	else
	{
		return false;
	}
}





quest function TryToAddUniqueFact( uniqueFactName : name ) : bool
{	
	var appendedUniqueFactName : string;
	appendedUniqueFactName = uniqueFactName + '_unique';
	
	if( FactsDoesExist( appendedUniqueFactName ) == false )
	{
		FactsAdd(appendedUniqueFactName, 1);
		return true;
	}
	else
	{
		return false;
	}
}


quest function DispelIllusionQuest ( spawnerTag : name )
{
	var spawners : array < CNode >;
	var singleSpawner : W3IllusionSpawner;
	var singleIllusion : W3IllusionaryObstacle;
	var i : int;

	theGame.GetNodesByTag( spawnerTag, spawners );
	
	for ( i=0 ; i < spawners.Size() ; i+=1 )	
	{
		singleSpawner = (W3IllusionSpawner) spawners[i];
		
		if(singleSpawner)
		{
			singleSpawner.ManualDispel();
		}
		else
		{
			singleIllusion =(W3IllusionaryObstacle) spawners[i];
			
			if(singleIllusion)
			{
				singleIllusion.Dispel();
				singleIllusion.DestroyObstacle();
			}
		}
	}

}


quest function EnableIllusionQuest ( illusionTag : name, enabled : bool )
{
	var illusions : array < CNode >;
	var illusion : W3IllusionaryObstacle;
	var i : int;

	theGame.GetNodesByTag( illusionTag, illusions );
	
	for ( i=0 ; i < illusions.Size() ; i+=1 )	
	{
		illusion = (W3IllusionaryObstacle) illusions[i];
		
		if(illusion)
		{
			illusion.SetIllusionEnabled( enabled );	
		}
	}

}






quest function SwitchTrapActivation( activate : bool , trapTag: name, optional targetTag:name, armInsteadOfActivate : bool )
{
	var	i			: int;
	var l_trap 		: W3Trap;
	var l_target 	: CNode;
	var l_traps		: array<CEntity>;
	
	theGame.GetEntitiesByTag( trapTag, l_traps );
	
	for	( i = 0; i < l_traps.Size(); i += 1 )
	{
		l_trap 	= ( W3Trap )	l_traps[ i ];
		if( l_trap )
		{
			if ( activate )
			{
				l_target 	= ( CNode )	theGame.GetEntityByTag( targetTag );
				if (!armInsteadOfActivate)
				{
					l_trap.Activate( l_target );
				}
				else
				{
					l_trap.Arm(true);
				}
			}
			else
			{
				if (!armInsteadOfActivate)
				{
					l_trap.Deactivate();
				}
				else
				{
					l_trap.Arm(false);
				}
			}
		}
	}
}

quest function EnableTrapTrigger( triggerTag : name, enable : bool )
{
	var l_trapTrigger 		: W3TrapTrigger;
	
	l_trapTrigger 		= ( W3TrapTrigger )theGame.GetEntityByTag( triggerTag );
	if( l_trapTrigger )
	{
		l_trapTrigger.Enable( enable  );
	}
}

quest function ManageDamageAreaTrigger ( damageAreaTag : name, affectedEntityTag : name, activate : bool ) 
{
	var l_damageArea 				: W3DamageAreaTrigger;
	var l_affectedEntity			: CEntity;
	
	l_damageArea 		= ( W3DamageAreaTrigger )theGame.GetEntityByTag( damageAreaTag );
	l_affectedEntity 		= theGame.GetEntityByTag( affectedEntityTag );
	
	if ( activate )
	{
		l_damageArea.SetEnable ( activate );
		l_damageArea.Activate ( l_affectedEntity );
	}
	else
	{
		l_damageArea.Deactivate ( l_affectedEntity );
		l_damageArea.SetEnable ( activate );
	}
}


quest function ManageEffectAreaTrigger ( effectAreaTag : name, activate : bool, updateEffects : bool ) 
{
	var effectAreaList		: array<CEntity>;
	var effectArea			: W3EffectAreaTrigger;
	var triggerComponent 	: CTriggerAreaComponent;
	var i : int;
	
	theGame.GetEntitiesByTag( effectAreaTag, effectAreaList );
	
	for(i=0; i<effectAreaList.Size(); i+=1)
	{
		effectArea = (W3EffectAreaTrigger)effectAreaList[i];
		if (effectArea)
		{
			triggerComponent = (CTriggerAreaComponent)effectArea.GetComponentByClassName( 'CTriggerAreaComponent' );
			triggerComponent.SetEnabled(activate);
			
			if(updateEffects)
			{
				if (activate)
				{
					effectArea.SetAutoEffect('active_effect');
				}
				
				else
				{
					effectArea.SetAutoEffect( 'None' );
				}
			}
		}	
	}
}

quest function ManageOilBarrels ( barrelsTag : name, executeAction : array < EOilBarrelOperation >)
{
	var nodesWithTag    : array <CNode>; 
	var i : int;
	var oilBarrelEntity : COilBarrelEntity;

	theGame.GetNodesByTag( barrelsTag, nodesWithTag);
	
	for ( i = 0; i < nodesWithTag.Size(); i += 1 )
	{
		oilBarrelEntity = (COilBarrelEntity) nodesWithTag[i];
		if (oilBarrelEntity)
		{
			oilBarrelEntity.OnManageOilBarrel(executeAction);
		}
	}
}

quest function ManageRift( riftTag : name, activate : bool, dontActivateEncounter : bool )
{
	var riftEntity : CRiftEntity;
	riftEntity = ( CRiftEntity )( theGame.GetEntityByTag( riftTag ) );
	
	if( !riftEntity )
	{
		LogChannel( 'Error', "Rift not set properly in ManageRift quest function." );
		return;
	}
	
	if( activate )
	{
		riftEntity.ActivateRift(dontActivateEncounter);
	}
	else
	{
		riftEntity.DeactivateRift();
	}
}

quest function ManageRiftDisabling( riftTag : name, canBeDisabled : bool )
{
	var riftEntity : CRiftEntity;
	riftEntity = ( CRiftEntity )( theGame.GetEntityByTag( riftTag ) );
	
	if( !riftEntity )
	{
		LogChannel( 'Error', "Rift not set properly in ManageRift quest function." );
		return;
	}
	
	riftEntity.SetCanBeDisabled(canBeDisabled);
}

quest function ManageTeleport( teleportTag : name, enabling_activating : bool, value : bool, keepBlackscreen : bool, activationTime : float )
{
	var teleportEntity : CTeleportEntity;
	teleportEntity = ( CTeleportEntity )( theGame.GetEntityByTag( teleportTag ) );
	
	if( !teleportEntity )
			LogChannel( 'Error', "Teleport not set properly in ManageTeleport quest function." );
	
	if( enabling_activating )
	{
		teleportEntity.EnableTeleport( value );
	}
	else
	{
		if( value )
		{
			teleportEntity.ActivateTeleport( activationTime );
		}
		else
		{
			teleportEntity.DeactivateTeleport();
		}
	}
	
	if( keepBlackscreen )
	{
		teleportEntity.keepBlackscreen = true;
	}
	else
	{
		teleportEntity.keepBlackscreen = false;
	}
}

quest function ManageToxicCloud ( toxicCloudsTag : name, executeAction : array < EToxicCloudOperation >)
{
	var nodesWithTag    : array <CNode>; 
	var i : int;
	var toxicCloudEntity : W3ToxicCloud;

	theGame.GetNodesByTag( toxicCloudsTag, nodesWithTag);
	
	for ( i = 0; i < nodesWithTag.Size(); i += 1 )
	{
		toxicCloudEntity = (W3ToxicCloud) nodesWithTag[i];
		if (toxicCloudEntity)
		{
			toxicCloudEntity.OnManageToxicCloud(executeAction);
		}
		else
		{
			LogChannel( 'Error', "Tagged object is not a CToxicCloudEntity" );
		}
	}
}

quest function BlockActorAbility( actorTag : name, abilityName : name, unBlock : bool )
{
	var actor : CActor;
	actor = ( CActor )( theGame.GetEntityByTag( actorTag ) );
	if( !actor )
			LogChannel( 'Error', "Actor not found in BlockActorAbility quest function." );
	
	if ( actor.BlockAbility( abilityName, !unBlock) )
	{
		LogQuest( "Quest function <<BlockActorAbility>>: Ability " + abilityName + " was found on " + actorTag + " and blocked" );
	}
	else
	{
		LogQuest( "Quest function <<BlockActorAbility>>: BlockAbility " + abilityName + " on " + actorTag + " FAILED" );
	}
}


quest function BroadcastDanger( lifetime : float, distance : float, interval : float )
{
	theGame.GetBehTreeReactionManager().CreateReactionEvent( thePlayer, 'Danger', lifetime, distance, interval, -1 );
}

quest function ApplyForce( fromNode : name, toTag : name, force : float, optional destroy : bool )
{
	var size, size2, i, j : int;
	var from : CNode;
	var to : array<CEntity>;
	var comps : array<CComponent>;
	var impulse : Vector;
	var destructable : CDestructionSystemComponent;
	var destructableNew : CDestructionComponent;
	
	from = theGame.GetNodeByTag( fromNode );
	
	if( from )
	{
		theGame.GetEntitiesByTag( toTag, to );
		
		size = to.Size();
		for( i = 0; i < size; i += 1 )
		{
			impulse = VecNormalize( to[i].GetWorldPosition() - from.GetWorldPosition() ) * force;
			
			comps = to[i].GetComponentsByClassName('CComponent');
			size2 = comps.Size();
			for( j = 0; j < size2; j += 1 )
			{
				if( destroy )
				{
					destructable = (CDestructionSystemComponent)comps[j];
					if( destructable )
					{
						destructable.ApplyFracture();
					}
					else
					{
						destructableNew = (CDestructionComponent)comps[j];
						if( destructableNew )
						{
							destructableNew.ApplyFracture();
						}
					}
				}
				comps[j].ApplyLocalImpulseToPhysicalObject( impulse );
			}
		}
	}
}

quest function AddRaceSlowMo( factor : float )
{	
	
	theGame.SetTimeScale( factor, theGame.GetTimescaleSource(ETS_RaceSlowMo), theGame.GetTimescalePriority(ETS_RaceSlowMo), false);
}

quest function RemoveRaceSlowMo()
{	
	theGame.RemoveTimeScale( theGame.GetTimescaleSource(ETS_RaceSlowMo) );
}

quest function SetBarrelsOnFire( tag : name, explodeTime : float, optional randomize : bool )
{
	var barrels : array<CEntity>;
	var size, i : int;
	
	theGame.GetEntitiesByTag( tag, barrels );
	
	size = barrels.Size();
	for( i = 0; i < size; i += 1 )
	{
		((COilBarrelEntity)barrels[i]).SetOnFire( explodeTime, randomize );
	}
}

quest function EnableBeeSwarm( tag : name )
{
	var swarm : W3BeeSwarm;
	var swarms : array<W3BeeSwarm>;
	var i : int;
	var ents : array<CEntity>;
	
	theGame.GetEntitiesByTag(tag, ents);
	
	for(i=0; i<ents.Size(); i+=1)
	{
		swarm = (W3BeeSwarm)ents[i];
		if(swarm)
			swarms.PushBack(swarm);
	}
	
	if( swarms.Size() == 0 )
	{
		LogQuest("EnableBeeSwarm_questFunction: cannot find any swarms with tag <<" + tag + ">>!!!");
	}
	else
	{
		for(i=0; i<swarms.Size(); i+=1)
			swarms[i].Enable(true);
	}
}

quest function StartHeartFight( tag : name )
{
	var heart : CHeartMiniboss;
	heart = ( CHeartMiniboss )( theGame.GetEntityByTag( tag ) );
	
	if( !heart )
			LogChannel( 'Error', "Heart not set properly in StartHeartFight quest function." );
	else
	{
		heart.GotoState( 'FullyCovered' );
	}
}

quest function KillHeart( tag : name )
{
	var heart : CHeartMiniboss;
	heart = ( CHeartMiniboss )( theGame.GetEntityByTag( tag ) );
	
	if( !heart )
			LogChannel( 'Error', "heart not set properly in KillHeart quest function." );
	else
	{
		thePlayer.EnableSnapToNavMesh( 'TreeHeartFight', false ); 
		heart.GotoState( 'Dead' );
	}
}

quest function HorseWhistle()
{
	if(thePlayer.IsActionAllowed(EIAB_CallHorse))
		theGame.OnSpawnPlayerHorse();
}	

quest function LockReactions( toggle : bool, areaTag : name )
{
	theGame.GetBehTreeReactionManager().SuppressReactions( toggle, areaTag );
}

quest function MeditationStop()
{
	
	var stejt : CScriptableState;
	var wejt : W3PlayerWitcherStateMeditationWaiting;
	var meed : W3PlayerWitcherStateMeditation;
	
	stejt = thePlayer.GetCurrentState();	
	wejt = (W3PlayerWitcherStateMeditationWaiting)stejt;
	if(wejt)
	{
		wejt.StopRequested(true);
	}
	else
	{
		meed = (W3PlayerWitcherStateMeditation)stejt;
		if(meed)
			meed.StopRequested(true);
	}
}

quest function ToggleHorseCanFlee( tag : name, value : bool )
{
	var horse : CNewNPC;
	
	horse = (CNewNPC)( theGame.GetEntityByTag( tag ) );
	
	if( !horse )
	{
		LogChannel( 'Error', "Horse not found with ToggleHorseCanFlee quest function." );
	}
	else
	{
		horse.ToggleCanFlee( value );
	}
}

quest function ForceDismount( horseTag : name )
{
	var horse : CNewNPC;
	var horseComp : W3HorseComponent;
	
	horse = (CNewNPC)( theGame.GetEntityByTag( horseTag ) );
	
	horseComp = horse.GetHorseComponent();
	
	if (horseComp.GetCurrentUser() == thePlayer)
	{
		horseComp.IssueCommandToDismount( DT_normal );
	}
	else
	{
		horseComp.riderSharedParams.rider.SignalGameplayEventParamInt( 'RidingManagerDismountHorse', DT_normal );
	}
}

enum EGeraltPath
{
	EGP_SWORD,
	EGP_SIGNS,
	EGP_ALCHEMY
}



quest function SetCiriLevel( level : int )
{
	GetReplacerPlayer().SetLevel( level );
}


quest function SetNPCLevel( npcTag : name, level : int )
{
	var npc : CNewNPC;
	
	npc = theGame.GetNPCByTag ( npcTag );
	
	if ( npc )
	{
		npc.SetLevel ( level );
	}
}

quest function Q001_EquipFood()
{
	var iID : array<SItemUniqueId>;
		
	if(FactsQuerySum("NewGamePlus") <= 0)
	{
		GetWitcherPlayer().inv.RemoveItemByName( 'Tawny Owl 1' );		
		iID =  GetWitcherPlayer().inv.GetItemsByName( 'Torch' );
		GetWitcherPlayer().EquipItem(iID[0]);
		iID =  GetWitcherPlayer().inv.GetItemsByName( 'Bread' );
		GetWitcherPlayer().EquipItem(iID[0]);
		iID =  GetWitcherPlayer().inv.GetItemsByName( 'Bottled water' );
		GetWitcherPlayer().EquipItem(iID[0]);
	}
}

quest function SetGeraltLevelHandsOn()
{
	var iID : array<SItemUniqueId>;
	var lm : W3PlayerWitcher;
	var exp, prevLvl, currLvl : int;
	var level : int = 15;
	
	GetWitcherPlayer().Debug_ClearCharacterDevelopment();
	
	lm = GetWitcherPlayer();
	prevLvl = lm.GetLevel();
	currLvl = lm.GetLevel();
		
	while(currLvl < level)
	{
		exp = lm.GetTotalExpForNextLevel() - lm.GetPointsTotal(EExperiencePoint);
		lm.AddPoints(EExperiencePoint, exp, false);
		currLvl = lm.GetLevel();
		
		if(prevLvl == currLvl)
			break;				
		
		prevLvl = currLvl;
	}		
	
	GetWitcherPlayer().AddSkill(S_Sword_s21);
	GetWitcherPlayer().AddSkill(S_Sword_s21);
	GetWitcherPlayer().AddSkill(S_Sword_s21);
	GetWitcherPlayer().AddSkill(S_Sword_s17);
	GetWitcherPlayer().AddSkill(S_Sword_s17);
	GetWitcherPlayer().AddSkill(S_Sword_s17);
	GetWitcherPlayer().AddSkill(S_Sword_s04);
	GetWitcherPlayer().AddSkill(S_Sword_s04);
	GetWitcherPlayer().AddSkill(S_Sword_s04);
	GetWitcherPlayer().AddSkill(S_Sword_4);
	GetWitcherPlayer().AddSkill(S_Sword_s10);
	GetWitcherPlayer().AddSkill(S_Sword_s13);
	GetWitcherPlayer().AddSkill(S_Sword_s13);
	
	GetWitcherPlayer().EquipSkill(S_Sword_s21, 1);
	GetWitcherPlayer().EquipSkill(S_Sword_s17, 3);
	GetWitcherPlayer().EquipSkill(S_Sword_s04, 5);
	GetWitcherPlayer().EquipSkill(S_Sword_s10, 2);
	GetWitcherPlayer().EquipSkill(S_Sword_s13, 4);
	
	iID = GetWitcherPlayer().inv.AddAnItem('Nilfgaardian sword 2', 1);
	GetWitcherPlayer().EquipItem(iID[0]);
	iID = GetWitcherPlayer().inv.AddAnItem('Silver sword 2', 1);
	GetWitcherPlayer().EquipItem(iID[0]);
	iID = GetWitcherPlayer().inv.AddAnItem('Pants 02', 1); GetWitcherPlayer().EquipItem(iID[0]);
	iID = GetWitcherPlayer().inv.AddAnItem('Gloves 04', 1); GetWitcherPlayer().EquipItem(iID[0]);
	iID = GetWitcherPlayer().inv.AddAnItem('Boots 04', 1); GetWitcherPlayer().EquipItem(iID[0]);
	iID = GetWitcherPlayer().inv.AddAnItem('Lynx Armor 1', 1); GetWitcherPlayer().EquipItem(iID[0]);
	
	iID =  GetWitcherPlayer().inv.GetItemsByName( 'Long Steel Sword' );
	GetWitcherPlayer().inv.RemoveItem( iID[0] );
	iID =  GetWitcherPlayer().inv.GetItemsByName( 'Witcher Silver Sword' );
	GetWitcherPlayer().inv.RemoveItem( iID[0] );
	iID =  GetWitcherPlayer().inv.GetItemsByName( 'Starting Gloves' );
	GetWitcherPlayer().inv.RemoveItem( iID[0] );
	iID =  GetWitcherPlayer().inv.GetItemsByName( 'Starting Pants' );
	GetWitcherPlayer().inv.RemoveItem( iID[0] );
	iID =  GetWitcherPlayer().inv.GetItemsByName( 'Starting Boots' );
	GetWitcherPlayer().inv.RemoveItem( iID[0] );
	iID =  GetWitcherPlayer().inv.GetItemsByName( 'Starting Armor' );
	GetWitcherPlayer().inv.RemoveItem( iID[0] );
	
	GetWitcherPlayer().inv.AddAnItem('Geralt Shirt');
	GetWitcherPlayer().inv.AddAnItem('Skellige Casual Suit');
	
	GetWitcherPlayer().inv.AddAnItem('Recipe for Necrophage Oil', 1);
	GetWitcherPlayer().inv.AddAnItem('Necrophage Oil', 1);
	GetWitcherPlayer().inv.AddAnItem('Recipe for Hanged Man Venom', 1);
	GetWitcherPlayer().inv.AddAnItem('Recipe for Beast Oil', 1);
	GetWitcherPlayer().inv.AddAnItem('Dog tallow', 4);
	GetWitcherPlayer().inv.AddAnItem('Wolf liver', 4);
	GetWitcherPlayer().inv.AddAnItem('Celandine', 5);
	GetWitcherPlayer().inv.AddAnItem('Wolfsbane', 4);
	GetWitcherPlayer().inv.AddAnItem('Grave Hag ear', 2);
	GetWitcherPlayer().inv.AddAnItem('Honeysuckle', 6);
	GetWitcherPlayer().inv.AddAnItem('Fools parsley leaves', 8);
	
	GetWitcherPlayer().inv.AddAnItem('Recipe for Samum', 1);
	GetWitcherPlayer().inv.AddAnItem('Samum', 1);
	GetWitcherPlayer().inv.AddAnItem('Dwarven spirit', 1);
	GetWitcherPlayer().inv.AddAnItem('Berbercane fruit', 7);
	GetWitcherPlayer().inv.AddAnItem('Hellebore petals', 4);
	GetWitcherPlayer().inv.AddAnItem('Cortinarius', 4);
	GetWitcherPlayer().inv.AddAnItem('Recipe for Grapeshot', 1);
	GetWitcherPlayer().inv.AddAnItem('Saltpetre', 2);
	GetWitcherPlayer().inv.AddAnItem('Calcium equum', 1);
	GetWitcherPlayer().inv.AddAnItem('Blowbill', 4);
	GetWitcherPlayer().inv.AddAnItem('Crows eye', 2);
	
	GetWitcherPlayer().inv.AddAnItem('Recipe for Cat', 1);
	GetWitcherPlayer().inv.AddAnItem('Recipe for Swallow', 1);
	GetWitcherPlayer().inv.AddAnItem('Swallow', 1);
	GetWitcherPlayer().inv.AddAnItem('Recipe for White Honey', 1);
	GetWitcherPlayer().inv.AddAnItem('White Honey', 1);
	
	GetWitcherPlayer().inv.AddAnItem('Mahakam Spirit', 10);
	
	GetWitcherPlayer().inv.AddAnItem('Bread', 5);
	iID =  GetWitcherPlayer().inv.GetItemsByName( 'Bread' );
	GetWitcherPlayer().EquipItem(iID[0]);
	iID =  GetWitcherPlayer().inv.GetItemsByName( 'Tawny Owl 1' );
	GetWitcherPlayer().EquipItem(iID[0]);
	iID =  GetWitcherPlayer().inv.GetItemsByName( 'Torch' );
	GetWitcherPlayer().EquipItem(iID[0]);	
	
	GetWitcherPlayer().AddPoints(EExperiencePoint, 850, false );
}


quest function SetGeraltLevel( level : int, path : EGeraltPath )
{
	var iID : array<SItemUniqueId>;
	var lm : W3PlayerWitcher;
	var exp, prevLvl, currLvl : int;
	
	GetWitcherPlayer().Debug_ClearCharacterDevelopment();
	
	
	lm = GetWitcherPlayer();
	prevLvl = lm.GetLevel();
	currLvl = lm.GetLevel();
		
	while(currLvl < level)
	{
		exp = lm.GetTotalExpForNextLevel() - lm.GetPointsTotal(EExperiencePoint);
		lm.AddPoints(EExperiencePoint, exp, false);
		currLvl = lm.GetLevel();
		
		if(prevLvl == currLvl)
			break;				
		
		prevLvl = currLvl;
	}		
	
	iID = GetWitcherPlayer().inv.AddAnItem('Autogen steel sword', 1);
	GetWitcherPlayer().EquipItem(iID[0]);
	iID = GetWitcherPlayer().inv.AddAnItem('Autogen silver sword', 1);
	GetWitcherPlayer().EquipItem(iID[0]);
	iID = GetWitcherPlayer().inv.AddAnItem('Autogen Pants', 1); GetWitcherPlayer().EquipItem(iID[0]);
	iID = GetWitcherPlayer().inv.AddAnItem('Autogen Gloves', 1); GetWitcherPlayer().EquipItem(iID[0]);
	iID = GetWitcherPlayer().inv.AddAnItem('Autogen Boots', 1); GetWitcherPlayer().EquipItem(iID[0]);
	iID = GetWitcherPlayer().inv.AddAnItem('Autogen Armor', 1); GetWitcherPlayer().EquipItem(iID[0]);
}

quest function DestroyEntity( entityTag : name )
{
	var entity : CEntity;
	
	entity = theGame.GetEntityByTag( entityTag );
	
	if( entity )		
		entity.Destroy();
}


quest function SetSkating()
{
	thePlayer.GotoState('Skating');
}

quest function BirdsManagerTryFlyIfBirdsPresent(birdsManagerTag : name)
{
	var i : int;
	var bm : CBirdsManager;
	var nodes : array<CNode>;

	theGame.GetNodesByTag(birdsManagerTag, nodes);
	
	if(nodes.Size() == 0)
	{
		LogQuest("BirdsManagerTryFlyIfBirdsPresent_questFunction: cannot find any nodes with tag <<" + birdsManagerTag + ">>!!");
		return;
	}
	
	for(i=0; i<nodes.Size(); i+=1)
	{
		bm = (CBirdsManager)nodes[i];
		if(bm)
			bm.FlyBirds();
	}
}


quest function PlayerModeQuest( playerMode : EPlayerMode, toggle : bool, snapToNavMeshSourceName : name, snapToNavMeshEnable : bool )
{
	if ( toggle )
	{
		if ( playerMode == PM_Safe )
		{
			thePlayer.EnableMode( PM_Safe, true );		
		}
		else if ( playerMode == PM_Combat )
		{
			thePlayer.GetPlayerMode().ForceCombatMode( FCMR_QuestFunction );		
		}
	}
	else
	{
		if ( playerMode == PM_Safe )
		{
			thePlayer.EnableMode( PM_Safe, false );
		}
		else if ( playerMode == PM_Combat )
		{
			thePlayer.GetPlayerMode().ReleaseForceCombatMode( FCMR_QuestFunction );
		}
	}
	
	if ( snapToNavMeshSourceName )
	{
		thePlayer.EnableSnapToNavMesh( snapToNavMeshSourceName, snapToNavMeshEnable );
	}	
	
}

quest function AddAndEquipItemsRandomlyQuest ( actorsTag : name, itemsNames : array<SItem> )
{
	var actorI : int;
	var rand, j, singletonItemMaxAmmo : int;
	
	var itemsIDs : array<SItemUniqueId>;
	var inv : CInventoryComponent;
	
	var actor : CActor;
	var actors : array <CActor>;
	
	
	theGame.GetActorsByTag ( actorsTag, actors );
	
	for ( actorI  = 0; actorI < actors.Size(); actorI +=1 )
	{
		rand = RandRange ( itemsNames.Size() - 1, 0 );
		actor = actors[actorI];
		inv = actor.GetInventory();
		
		if ( inv )
		{
			if(!IsNameValid(itemsNames[rand].itemName ))
			{
				LogQuest( "Quest function <<AddAndEquipItemsRandomlyQuest>>: item name <<" + itemsNames[rand].itemName + ">> is not a valid item name, skipping!");
				continue;
			}	
			if(itemsNames[rand].quantity < 0)
			{
				LogQuest( "Quest function <<AddAndEquipItemsRandomlyQuest>>: quantity of " + itemsNames[rand].quantity + "is not a valid value, skipping!");		
				continue;
			}
			itemsIDs = inv.AddAnItem ( itemsNames[rand].itemName );
			if(inv.IsItemSingletonItem(itemsIDs[0]))
			{
				singletonItemMaxAmmo = inv.SingletonItemGetMaxAmmo(itemsIDs[0]);
				for(j=0; j<itemsIDs.Size(); j+=1)
					inv.SingletonItemSetAmmo(itemsIDs[j], singletonItemMaxAmmo);
			}
			
			actor.EquipItem ( itemsIDs[0] );
		}
		
	}
}

quest function AddAndEquipItemsRandomlyQuestExt ( actorsTag : name, itemsNames : array<SItemExt> )
{
	var actorI : int;
	var rand, j, singletonItemMaxAmmo : int;
	
	var itemsIDs : array<SItemUniqueId>;
	var inv : CInventoryComponent;
	
	var actor : CActor;
	var actors : array <CActor>;
	
	
	theGame.GetActorsByTag ( actorsTag, actors );
	
	for ( actorI  = 0; actorI < actors.Size(); actorI +=1 )
	{
		rand = RandRange ( itemsNames.Size() - 1, 0 );
		actor = actors[actorI];
		inv = actor.GetInventory();
		
		if ( inv )
		{
			if(!IsNameValid(itemsNames[rand].itemName.itemName ))
			{
				LogQuest( "Quest function <<AddAndEquipItemsRandomlyQuest>>: item name <<" + itemsNames[rand].itemName.itemName + ">> is not a valid item name, skipping!");
				continue;
			}	
			if(itemsNames[rand].quantity < 0)
			{
				LogQuest( "Quest function <<AddAndEquipItemsRandomlyQuest>>: quantity of " + itemsNames[rand].quantity + "is not a valid value, skipping!");		
				continue;
			}
			itemsIDs = inv.AddAnItem ( itemsNames[rand].itemName.itemName );
			if(inv.IsItemSingletonItem(itemsIDs[0]))
			{
				singletonItemMaxAmmo = inv.SingletonItemGetMaxAmmo(itemsIDs[0]);
				for(j=0; j<itemsIDs.Size(); j+=1)
					inv.SingletonItemSetAmmo(itemsIDs[j], singletonItemMaxAmmo);
			}
			actor.EquipItem ( itemsIDs[0] );
		}
		
	}
}

quest function HACK_MinimapWerewolf()
{
}

quest function EnterJumpToWaterArea( optional requireDirection : bool, optional direction : Vector, optional requireSprint : bool )	
{
	thePlayer.substateManager.m_SharedDataO.EnableJumpToWaterArea( requireDirection, direction, requireSprint );
}

quest function ExitJumpToWaterArea()
{
	thePlayer.substateManager.m_SharedDataO.DisableJumpToWaterArea();
}

quest function EnableMapPath( tag : name, enable : bool, lineWidth : float, segmentLength : float, color : Color )
{
	var commonMapManager: CCommonMapManager = theGame.GetCommonMapManager();
	if ( commonMapManager )
	{
		commonMapManager.EnableMapPath( tag, enable, lineWidth, segmentLength, color );
	}
}


enum EDM_MappinType
{
	EDM_QuestAvailable,
	EDM_MonsterNest,
	EDM_Prostitute,
	EDM_HorseRacingNPC,
	EDM_NonQuestHorseRace,
	EDM_QuestAvailableFromNonActor,
	EDM_EP1QuestAvailable,
	EDM_EP1QuestAvailableFromNonActor,
	EDM_EP2QuestAvailable,
	EDM_EP2QuestAvailableFromNonActor,
	EDM_Torch,
	EDM_HorseRaceTarget,
	EDM_HorseRaceDummy,
}



quest function AddQuestMappinToNoticeboard( noticeboardTag : name, entityTag : name,  entityType : AQMTN_EntityType )
{
	var boards : array<CEntity>;
	var board : W3NoticeBoard;
	var i : int;
	
	theGame.GetEntitiesByTag( noticeboardTag, boards );
	
	if( boards.Size() == 0 )
		return;
	
	for( i = 0; boards.Size() > i; i += 1 )
	{
		board = (W3NoticeBoard) boards[i];
		
		if (board)
		{
			board.AddQuestMappin( entityTag, entityType );
		}
	}

}


quest function EnableDynamicMappin( tag : name, optional enable : bool, optional type : EDM_MappinType, optional informUI : bool )
{
	var commonMapManager: CCommonMapManager = theGame.GetCommonMapManager();
	
	if ( commonMapManager )
	{
		switch ( type )
		{
		case EDM_QuestAvailable:
			commonMapManager.EnableDynamicMappin( tag, enable, 'QuestAvailable', true );
			break;
		case EDM_MonsterNest:
			commonMapManager.EnableDynamicMappin( tag, enable, 'MonsterNest' );
			break;
		case EDM_Prostitute:
			commonMapManager.EnableDynamicMappin( tag, enable, 'Prostitute' );
			break;
		case EDM_HorseRacingNPC:
			commonMapManager.EnableDynamicMappin( tag, enable, 'HorseRacingNPC' );
			break;
		case EDM_NonQuestHorseRace:
			commonMapManager.EnableDynamicMappin( tag, enable, 'NonQuestHorseRace' );
			break;
		case EDM_QuestAvailableFromNonActor:
			commonMapManager.EnableDynamicMappin( tag, enable, 'QuestAvailable' );
			break;
		case EDM_EP1QuestAvailable:
			commonMapManager.EnableDynamicMappin( tag, enable, 'QuestAvailableHoS', true );
			break;
		case EDM_EP1QuestAvailableFromNonActor:
			commonMapManager.EnableDynamicMappin( tag, enable, 'QuestAvailableHoS' );
			break;
		case EDM_EP2QuestAvailable:
			commonMapManager.EnableDynamicMappin( tag, enable, 'QuestAvailableBaW', true );
			break;
		case EDM_EP2QuestAvailableFromNonActor:
			commonMapManager.EnableDynamicMappin( tag, enable, 'QuestAvailableBaW' );
			break;
		case EDM_Torch:
			commonMapManager.EnableDynamicMappin( tag, enable, 'Torch' );
			break;
		case EDM_HorseRaceTarget:
			commonMapManager.EnableDynamicMappin( tag, enable, 'HorseRaceTarget' );
			break;
		case EDM_HorseRaceDummy:
			commonMapManager.EnableDynamicMappin( tag, enable, 'HorseRaceDummy' );
			break;
			
		default:
			break;
		}
		
		
	}
}

quest function EnableStaticMappin( tag : name, enable : bool, isFastTravelPoint : bool )
{
	var commonMapManager: CCommonMapManager = theGame.GetCommonMapManager();
	if ( commonMapManager )
	{
		if ( enable )
		{
			commonMapManager.SetEntityMapPinDiscoveredScript(isFastTravelPoint, tag, true );
		}
		else
		{
			commonMapManager.SetEntityMapPinDiscoveredScript(isFastTravelPoint, tag, false);
		}
	}
}

quest function SetSimulatedCloth( e : CEntity, enable : bool )
{	
	
}

quest function DestroyByTag( tag : name )
{
	var entitesList : array<CEntity>;
	var i 			: int;
	var destroyed 	: int = 0;
	
	theGame.GetEntitiesByTag( tag, entitesList );
	
	for(i=0; i<entitesList.Size(); i+=1)
	{
		entitesList[i].Destroy();
		destroyed += 1;
	}
	LogQuest( "Quest function <<DestroyByTag>>: Destroyed " + destroyed + " entities." );
}

quest function ManageRootsEntrance( tag : name, shouldOpen : bool )
{
	var entity : CEntity;
	var roots : W3RootsEntrance;
	
	entity = theGame.GetEntityByTag( tag );

	if( entity )
	{
		roots = (W3RootsEntrance)entity;
		
		if( roots )
		{
			if( shouldOpen )
			{
				roots.Open();
			}
			else
			{
				roots.Close();
			}
		}
	}
}

quest function MakePhilippaShootAtNode( philippaTag : name, nodeTag : name )
{
	var philippa : CNewNPC;
	var node : CNode;
	
	philippa = (CNewNPC)( theGame.GetActorByTag( philippaTag ) );
	node = theGame.GetNodeByTag( nodeTag );

	if( philippa && node )
	{
		philippa.SignalGameplayEventParamObject( 'shootAtPoint', node );
	}
}

quest function DespawnMagicBubble( magicBubbleOwnerTag : name )
{
	var entities : array<CGameplayEntity>;
	var magicBubble : W3MagicBubbleEntity;
	var owner : CActor;
	
	owner = theGame.GetActorByTag(magicBubbleOwnerTag);
	
	if ( !owner )
	{
		LogQuest( "Quest function <<DespawnMagicBubbleActor>>: Actor " + magicBubbleOwnerTag + " NOT FOUND!" );
		return;
	}
	
	FindGameplayEntitiesInRange(entities,owner,1,1,'q104_magicBubble_AITask');
	
	if ( entities.Size() > 0 )
	{
		magicBubble = (W3MagicBubbleEntity)entities[0];
		if ( magicBubble )
		{
			magicBubble.ToggleActivate(false);
			magicBubble.DestroyAfter(5);
		}
		else
			entities[0].DestroyAfter(5);
	}
}

quest function ScaleMagicBubble( magicBubbleTag : name, desiredScale : Vector, scaleDuration : float )
{
	var entitesList : array<CEntity>;
	var magicBubble : W3MagicBubbleEntity;
	var i : int;
	
	theGame.GetEntitiesByTag( magicBubbleTag, entitesList );
	
	if ( entitesList.Size() <= 0 )
	{
		LogQuest( "Quest function <<ScaleMagicBubble>>: No entities with tag: '" + magicBubbleTag + "' was found!" );
		return;
	}
	
	for(i=0; i<entitesList.Size(); i+=1)
	{
		magicBubble = (W3MagicBubbleEntity)entitesList[i];
		if ( magicBubble )
		{
			magicBubble.ScaleOverTime( desiredScale, scaleDuration );
		}
	}
}

quest function SwitchAttachment( attach : bool, parentEntityTag : name, childEntityTag : name, attachSlot: name, switchGravity : bool )
{
	var l_parentEntity	: CEntity;
	var l_childEntity	: CEntity;
	var l_slotMatrix 	: Matrix;
	var l_slotRotation	: EulerAngles;
	var l_slotPos		: Vector;
	
	l_parentEntity 	= theGame.GetEntityByTag( parentEntityTag );
	l_childEntity 	= theGame.GetEntityByTag( childEntityTag );
	
	if( !l_parentEntity || !l_childEntity )
	{
		return;
	}
	
	if( attach )
	{
		
		l_childEntity.CreateAttachment( l_parentEntity, attachSlot );
		if( switchGravity && (CActor) l_childEntity )
		{
			((CMovingPhysicalAgentComponent) ((CActor) l_childEntity).GetMovingAgentComponent()).SetAnimatedMovement( true );
		}
	}
	else
	{
		l_childEntity.BreakAttachment();
		if( switchGravity && (CActor) l_childEntity )
		{
			((CMovingPhysicalAgentComponent) ((CActor) l_childEntity).GetMovingAgentComponent()).SetAnimatedMovement( false );
		}
	}
}

quest function SwitchCapsuleCollision( actorTag : name, enable : bool, switchVulnerability : bool, effectLinkedToCollision : name )
{
	var l_actor : CActor;
	
	l_actor = theGame.GetNPCByTag( actorTag );
	
	if( !l_actor ) return;
	
	l_actor.EnableCharacterCollisions( enable );
	
	if( switchVulnerability )
	{
		if( enable )
		{
			l_actor.SetImmortalityMode( AIM_None, AIC_Combat );
		}
		else
		{
			l_actor.SetImmortalityMode( AIM_Invulnerable, AIC_Combat );
		}
	}
	
	if( IsNameValid( effectLinkedToCollision ) )
	{
		if( !enable &&  !l_actor.IsEffectActive( effectLinkedToCollision ) )
		{
			l_actor.PlayEffect( effectLinkedToCollision );
		}
		else if( enable )
		{
			l_actor.StopEffect( effectLinkedToCollision );
		}
	}
}

quest function PlayerSelectQuickslotItem(itemName : name, itemCategory : name, useSign : bool, sign : ESignType)
{
	var witcher : W3PlayerWitcher;
	var equipmentSlot : EEquipmentSlots;
	var items : array<SItemUniqueId>;
	var i : int;
	
	witcher = GetWitcherPlayer();
	if(witcher && !((W3ReplacerCiri)thePlayer) )
	{
		
		if( IsNameValid( itemName) )
		{
			equipmentSlot = witcher.GetItemSlotByItemName(itemName);
			if(equipmentSlot != EES_InvalidSlot)
			{
				witcher.SelectQuickslotItem(equipmentSlot);
			}
			else
			{
				LogQuest("Quest function <<PlayerSelectQuickslot>>: item <<" + itemName + ">> is not equipped on any slot - cannot select");
			}
		}
		else
		{
			if( IsNameValid( itemCategory ) )
			{
				items = thePlayer.inv.GetItemsByCategory(itemCategory );
				
				if( items.Size() > 0 )
				{
					for( i=0; i < items.Size(); i+=1 )
					{
						if( witcher.IsItemEquipped( items[i] ) )
						{
							equipmentSlot = witcher.GetItemSlotByItemName(thePlayer.inv.GetItemName(items[i]));
							
							if(equipmentSlot != EES_InvalidSlot)
							{
								witcher.SelectQuickslotItem(equipmentSlot);
							}
							else
							{
								LogQuest("Quest function <<PlayerSelectQuickslot>>: item found for category <<" + itemCategory + ">> is not equipped on any slot - cannot select");
							}
						}
					}
				}
				
				witcher.SelectQuickslotItem(equipmentSlot);			
				
			}
			else
			{
				LogQuest("Quest function <<PlayerSelectQuickslot>>: item name for type <<" + itemName + ">> is not valid");				
			}
		}
		
		
		if(useSign)
			witcher.SetEquippedSign(sign);
	}
	else
	{
		LogQuest("Quest function <<PlayerSelectQuickslot>>: only Geralt has item slots!");
		return;
	}
}

quest function EquipAmmoOnCrossbow( ammoName : name )
{
	var player			: W3PlayerWitcher;
	var crossbow		: Crossbow;
	var items 			: array<SItemUniqueId>;
	var count			: int;
	var loadWeapon		: bool;
	var i				: int;
	var crossbowIsEquipped	: bool;
	
	player =  (W3PlayerWitcher)thePlayer;
	
	
	items = player.inv.GetItemsByCategory( 'crossbow' );
	
	for ( i = 0; i < items.Size() ; i += 1 )
	{
		if ( player.inv.IsItemMounted( items[i] ) )
		{
			crossbowIsEquipped = true;
			break;
		}
	}

	if ( !crossbowIsEquipped )
	{
		if ( items.Size() > 0 )
			player.EquipItem( items[0] );
		else
			LogChannel( 'EquipAmmoOnCrossbow', "EquipAmmoOnCrossbow Failed: No crossbow in Geralt inventory!!!" );
	}
	
	player.SelectQuickslotItem(EES_RangedWeapon);
	
	items.Clear();
	
	
	items = player.inv.GetItemsByName( ammoName );
	if ( items.Size() > 0)
	{
		if ( !player.inv.ItemHasTag(items[0], theGame.params.TAG_INFINITE_AMMO) )
		{
			count = player.inv.SingletonItemGetAmmo(items[0]);
			if ( count > 0 )
				loadWeapon = true;
			else
				LogChannel( 'EquipAmmoOnCrossbow', "EquipAmmoOnCrossbow Failed: special ammo specified has zero shots!!!" );
		}
		else 
			loadWeapon = true;
		
		if ( loadWeapon )
		{
			player.EquipItem( items[0], EES_Bolt );
			player.rangedWeapon = ( Crossbow )( player.inv.GetItemEntityUnsafe( player.GetSelectedItemId() ) );
			player.rangedWeapon.OnReplaceAmmo();
			player.rangedWeapon.OnWeaponReload();
		}
	}
	else
		LogChannel( 'EquipAmmoOnCrossbow', "EquipAmmoOnCrossbow Failed: special ammo specified is not in Geralt inventory!!!" );
}


quest function EnableShopkeeper( tag: name, enable : bool )
{
	var manager : CCommonMapManager = theGame.GetCommonMapManager();
	
	if ( manager )
	{
		manager.EnableShopkeeper( tag, enable );
	}
}

quest function EnableShopkeeperCraftingQuest( npcTag : name, enable : bool )
{
	var actors 	: array<CActor>;
	var shopkeeper : W3MerchantNPC;
	var i 		: int;
	
	theGame.GetActorsByTag( npcTag, actors );
	
	if ( actors.Size() <= 0 )
	{
		LogQuest("Quest function <<EnableShopkeeperCrafting>>: No Actors with tag " + npcTag + " were found!");
		return;
	}
	
	for ( i = 0; i < actors.Size(); i += 1 )
	{
		shopkeeper = (W3MerchantNPC)actors[i];
		if ( shopkeeper )
			shopkeeper.SetCraftingEnabled( enable );
	}

}

quest function IgniteFlammableArea( tag : name )
{
	var entity : CEntity;
	var flammableArea : W3FlammableAreaTrigger;
	
	entity = theGame.GetEntityByTag( tag );
	flammableArea = (W3FlammableAreaTrigger)entity;

	if( flammableArea )
	{
		flammableArea.Ignite();
	}
}

quest function EnableTalkInteractionInCombatByTag( npcTag : name, enable : bool )
{
	var actors 	: array<CActor>;
	var i 		: int;
	var comp 	: CInteractionComponent;
	
	theGame.GetActorsByTag( npcTag, actors );
	
	if ( actors.Size() <= 0 )
	{
		LogQuest("Quest function <<EnableTalkInteractionInCombatByTag>>: No Actors with tag " + npcTag + " were found!");
		return;
	}
	
	for ( i = 0; i < actors.Size(); i += 1 )
	{
		comp = (CInteractionComponent)actors[i].GetComponent('talk');
		if ( comp )
		{			
			comp.EnableInCombat(enable);
			comp.SetShouldSave( true );
		}
	}
}

enum EGwentCardFaction
{
	EGCF_Neutral,
	EGCF_Kingdoms,
	EGCF_Nilfgaard,
	EGCF_Monsters,
	EGCF_Scoiatael,
	EGCG_Skellige
}

quest function IsGwentFactionPlayable( faction : EGwentCardFaction ) : bool
{
	var neutralCreatures : int;
	var playerCollection : array<CollectionCard>;
	var cardDefinitions : array<SCardDefinition>;
	var currentDefinition : SCardDefinition;
	var currentCollectionCard : CollectionCard;
	var i : int;
	var x : int;
	var unitCardCount : int;
	var maskResult : int;
	
	playerCollection = theGame.GetGwintManager().GetPlayerCollection();
	cardDefinitions = theGame.GetGwintManager().GetCardDefs();
	unitCardCount = 0;
	
	if (faction != EGCF_Neutral)
	{
		for (i = 0; i < playerCollection.Size(); i += 1)
		{
			currentCollectionCard = playerCollection[i];
			
			for (x = 0; x < cardDefinitions.Size(); x += 1)
			{
				currentDefinition = cardDefinitions[x];
				if (currentDefinition.index == currentCollectionCard.cardID)
				{
					if ((int)currentDefinition.faction == (int)EGCF_Neutral || (int)currentDefinition.faction == (int)faction)
					{
						maskResult = currentDefinition.typeFlags & GwintType_Creature;
						
						if (maskResult == GwintType_Creature)
						{
							unitCardCount += currentCollectionCard.numCopies; 
						}
						break;
					}
				}
			}
		}
	}
	
	return unitCardCount >= 22;
}

quest function UnlockSkelligeGwentDeck()
{
	var gwintManager: CR4GwintManager;
	
	if (!FactsDoesExist("skel_gwint_base_deck_given"))
	{
		gwintManager = theGame.GetGwintManager();
		
		FactsAdd("skel_gwint_base_deck_given");
		
		gwintManager.AddCardToCollection(22);
		gwintManager.AddCardToCollection(501);
		gwintManager.AddCardToCollection(505);
		gwintManager.AddCardToCollection(506);
		gwintManager.AddCardToCollection(507);
		gwintManager.AddCardToCollection(508);
		gwintManager.AddCardToCollection(509);
		gwintManager.AddCardToCollection(510);
		gwintManager.AddCardToCollection(511);
		gwintManager.AddCardToCollection(513);
		gwintManager.AddCardToCollection(515);
		gwintManager.AddCardToCollection(517);
		gwintManager.AddCardToCollection(517);
		gwintManager.AddCardToCollection(517);
		gwintManager.AddCardToCollection(518);
		gwintManager.AddCardToCollection(519);
		gwintManager.AddCardToCollection(520);
		gwintManager.AddCardToCollection(520);
		gwintManager.AddCardToCollection(521);
		gwintManager.AddCardToCollection(521);
		gwintManager.AddCardToCollection(522);
		gwintManager.AddCardToCollection(522);
		gwintManager.AddCardToCollection(523);
		
		
		if( !gwintManager.IsDeckUnlocked( GwintFaction_Skellige ) &&
			gwintManager.HasCardsOfFactionInCollection( GwintFaction_Skellige, false ) )
		{
			gwintManager.UnlockDeck( GwintFaction_Skellige );
		}
	}
}

quest function AddGwentCards( val : EGwentCardFaction )
{

	var arr : array<int>;
	switch ( val )
	{
		case EGCF_Neutral :
		{			
			arr.PushBack(7);
			arr.PushBack(8);
			arr.PushBack(9);
			arr.PushBack(10);
			arr.PushBack(11);
			arr.PushBack(12);
			arr.PushBack(13);
			arr.PushBack(14);
			arr.PushBack(15);
			arr.PushBack(16);			
			
			thePlayer.InitGwintCardNumbersArray( arr );
			break;
		}
		case EGCF_Kingdoms :
		{		
			arr.PushBack(20);
			arr.PushBack(37);
			arr.PushBack(37);
			arr.PushBack(37);
			arr.PushBack(30);
			arr.PushBack(29);
			arr.PushBack(38);
			arr.PushBack(39);
			arr.PushBack(40);
			arr.PushBack(40);
			arr.PushBack(31);
			arr.PushBack(31);
			arr.PushBack(35);
			arr.PushBack(35);
			arr.PushBack(41);
			arr.PushBack(42);
			arr.PushBack(34);
			arr.PushBack(43);		
			
			thePlayer.InitGwintCardNumbersArray( arr );
			break;
		}
			
		case EGCF_Monsters :
		{		
			arr.PushBack (125);
			arr.PushBack (126);
			arr.PushBack (127);
			arr.PushBack (117);
			arr.PushBack (108);
			arr.PushBack (108);
			arr.PushBack (109);
			arr.PushBack (118);
			arr.PushBack (119);
			arr.PushBack (120);
			arr.PushBack (121);
			arr.PushBack (122);
			arr.PushBack (123);
			arr.PushBack (107);
			arr.PushBack (107);
			arr.PushBack (124);
			arr.PushBack (124);
			arr.PushBack (124);	
			
			thePlayer.InitGwintCardNumbersArray( arr );
			break;
			
		}
		
		case EGCF_Nilfgaard :
		{
			arr.PushBack (52);
			arr.PushBack (52);
			arr.PushBack (52);
			arr.PushBack (48);
			arr.PushBack (53);
			arr.PushBack (45);
			arr.PushBack (45);
			arr.PushBack (63);
			arr.PushBack (46);
			arr.PushBack (50);
			arr.PushBack (57);
			arr.PushBack (64);
			arr.PushBack (47);
			arr.PushBack (54);
			
			thePlayer.InitGwintCardNumbersArray( arr );
			break;
		}
		case EGCF_Scoiatael :
		{
			arr.PushBack (76);
			arr.PushBack (76);
			arr.PushBack (88);
			arr.PushBack (88);
			arr.PushBack (88);
			arr.PushBack (88);
			arr.PushBack (94);
			arr.PushBack (94);
			arr.PushBack (95);
			arr.PushBack (78);
			arr.PushBack (89);
			arr.PushBack (79);
			arr.PushBack (77);
			arr.PushBack (75);
			
			thePlayer.InitGwintCardNumbersArray( arr );
			break;
			
		}
	}		
}

quest function ManageBuffImmunities( npcTag : name, effects : array< EEffectType >, remove : bool )
{
	var npc : CActor;
	var actors : array<CActor>;
	var i,j : int;
	
	theGame.GetActorsByTag( npcTag, actors );
	
	if( actors.Size() <= 0 )
	{
		LogQuest("Quest function <<ManageBuffImmunities>>: No actors were found with the following tag: " + npcTag + "" );
		return;
	}
	
	
	for ( i=0 ; i < actors.Size(); i += 1)
	{
		for ( j = 0; j < effects.Size(); j += 1 )
		{
			if( remove )
			{
				actors[i].RemoveBuffImmunity( effects[j], 'ManageBuffImmunities' );
			}
			else
			{
				actors[i].AddBuffImmunity( effects[j], 'ManageBuffImmunities', true );
			}
		}
	}
}

quest function UseRiddleNodeQuest ( riddleNodeTag : name )
{
	var riddleNide : W3RiddleNode;
	
	riddleNide = ( W3RiddleNode )theGame.GetEntityByTag ( riddleNodeTag );
	
	riddleNide.ChangePosition();
}

quest function EnableRigidMeshQuest ( entityTag : name, enable : bool )
{
	var i : int;
	var k : int;
	var entities: array <CEntity>;
	var rigidMeshComponents : array <CComponent>;
	
	 theGame.GetEntitiesByTag ( entityTag, entities );
	
	for ( k=0; k < entities.Size(); k += 1 )
	{
		rigidMeshComponents = entities[i].GetComponentsByClassName ( 'CRigidMeshComponent' );
		
		for ( i=0; i < rigidMeshComponents.Size(); i+=1 )
		{
			((CRigidMeshComponent)rigidMeshComponents[i]).SetEnabled ( enable );
		}
	}
}

quest function PadVibrationEnable(enable : bool)
{
	theGame.SetVibrationEnabled(enable);
}


quest function TriggerSonarFXQuest( sonarEntityTag : name )
{
	var rot				: EulerAngles;
	var pos 			: Vector;
	var spawnedEntity	: CEntity;
	var entityTemplate	: CEntityTemplate;
	var sonarEntity		: CEntity;

	entityTemplate = (CEntityTemplate)LoadResource('sonar_fx');		
	sonarEntity = theGame.GetEntityByTag ( sonarEntityTag );
	pos = sonarEntity.GetWorldPosition();
	
	spawnedEntity = theGame.CreateEntity( entityTemplate, pos, rot );
}

quest function EnableFXManager( fxManagerTag : name, enable : bool )
{
	var fxManager	:	CEntity;
	
	fxManager	=	theGame.GetEntityByTag( fxManagerTag );
	
	if( fxManager )
	{
		if( enable )
		{
			((CGroupFXManager)fxManager).Activate();
		}
		else
		{
			((CGroupFXManager)fxManager).Deactivate();
		}
	}
}

quest function PlayVoicesetQuest( tag : name, voiceSet : string, oneRandomActor : bool )
{
	var actors : array<CActor>;
	var i : int;
	
	theGame.GetActorsByTag( tag, actors );
	
	
	if( actors.Size() == 0 )
	{
		return;
	}
	
	
	if( oneRandomActor )
	{
		actors[ RandRange( actors.Size(), 0) ].PlayVoiceset( 100, voiceSet );
	}
	else
	{
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actors[i].PlayVoiceset( 100, voiceSet );
		}
	}
}

quest function Achievement_FinishedGame()
{
	var lowestDiffMode : EDifficultyMode;
	var profile : W3GamerProfile;
	
	lowestDiffMode = theGame.GetLowestDifficultyUsed();
	profile = theGame.GetGamerProfile();
	
	
	
	
	
	
	profile.AddAchievement(EA_FinishTheGameEasy);

	
	if(lowestDiffMode >= EDM_Hard)
		profile.AddAchievement(EA_FinishTheGameNormal);
		
	
	if(lowestDiffMode >= EDM_Hardcore)
		profile.AddAchievement(EA_FinishTheGameHard);
}

quest function SpawnAndAttachEntity( entTemplate : CEntityTemplate, attachToEntityTag : name, attachSlot : name, persistanceMode : EPersistanceMode, addedTags : array<name> )
{
	var ent : CEntity;
	var parentEnt : CEntity;
	
	ent = theGame.CreateEntity(entTemplate, Vector(0.f,0.f,0.f), EulerAngles(0.0f, 0.0f, 0.0f), true, false, false, persistanceMode, addedTags );
	parentEnt = theGame.GetEntityByTag( attachToEntityTag );
	
	ent.CreateAttachment( parentEnt, attachSlot );
}

quest function DisableHorseSlowdownTriggers( HorseCanAlwaysGallop : bool )
{
	thePlayer.SetIsHorseRacing( HorseCanAlwaysGallop );
}

quest function SetHorseRacingMode( value : bool )
{
	thePlayer.SetIsHorseRacing( value );
}

quest function SetArachasEggDestoryedCustomQuest( EggsTag : name, dontAddFact : bool )
{
	var Eggs : array<CNode>;
	var Egg : W3ArachasEggCustom;
	var i : int;
	
	theGame.GetNodesByTag( EggsTag, Eggs );

	if(Eggs.Size() > 0)
	{
		for(i=0; i < Eggs.Size(); i += 1)
		{
			Egg = (W3ArachasEggCustom) Eggs[i];
			Egg.ManualEggDestruction( !dontAddFact );
		}
		
	}

}


quest function SetCreaturesGroupState ( encounterTag : name, creaturesGroups : array < name >, sourceName : name, enable : bool, setDelayManually : bool, delay : GameTimeWrapper )
{
	var task 					: SOwnerEncounterTaskParams;
	var encounter 				: CEncounter;
	var dataManager 			: CEncounterDataManager;
	var i 						: int;
	
	encounter = (CEncounter)theGame.GetEntityByTag ( encounterTag );
	
	if ( encounter )
	{
		dataManager = encounter.dataManager;
		
		if ( !dataManager )
		{
			encounter.InitializeEncounterDataManager ();
			dataManager = encounter.dataManager;
		}
		
		
		if ( enable )
		{
			if ( setDelayManually )
			{
				task.delay = delay;
			}
			else
			{
				task.delay.gameTime = GameTimeCreate ( 0, 5, 0, 0 );
			}
			
			task.creaturesGroupToEnable = creaturesGroups;
			task.sourceName = sourceName;
			
		}
		
		else
		{
			if ( setDelayManually )
			{
				task.delay = delay;
			}
			
			task.creaturesGroupToDisable = creaturesGroups;
			task.sourceName = sourceName;
			task.forceDespawn = true;
			
		}
		
			dataManager.AddOwnerTask ( task );
			encounter.ProcessTasks ();
	}
}

quest function ActivateBoatRacingGate( tag : name )
{
	var gate : CBoatRacingGateEntity;
	
	gate = (CBoatRacingGateEntity)theGame.GetEntityByTag( tag );
	
	if( gate )
	{
		gate.ActivateGate();
	}
}

quest function ForceInteractSwitch ( tag : name , on : bool , switchType : PhysicalSwitchAnimationType )
{
	var entity : CEntity;
	var lever : W3InteractionSwitch;
	
	entity = theGame.GetEntityByTag( tag );
	
	if ( entity )
	{
		lever = (W3InteractionSwitch)entity;
		
		if ( lever )
		{
			lever.InteractWith( on , switchType );
		}
		return;
	}
	return;
}

quest function ManageGate( tag : name, open : bool, speedModifier : float )
{
	var entity : CEntity;
	var gate : CGateEntity;
	
	
	entity = theGame.GetEntityByTag( tag );

	if( entity )
	{
		gate = (CGateEntity)entity;
		
		if( gate )
		{
			if( open )
			{
				gate.OpenGate(speedModifier);
			}
			else
			{
				gate.CloseGate(speedModifier);
			}
		}
	}
}

quest function LaunchGwint()
{
	theGame.GetGwintManager().setDoubleAIEnabled(false);
	theGame.RequestMenu( 'GwintGame' );
}

quest function QuestItemDisable( itemName : name , addQuestTag : bool, containerTag : name )
{
	var allItems				: array<SItemUniqueId>;
	var i 						: int;
	var horseManInv, contInv	: CInventoryComponent;
	var containers				: array<CEntity>;
	var cont					: W3Container;
	
	
	if( containerTag == '' )
	{
		allItems = thePlayer.inv.GetItemsByName( itemName );
		
		thePlayer.inv.ManageItemsTag( allItems, 'Quest', addQuestTag );
		
		
		if( GetWitcherPlayer() )
		{
			horseManInv = GetWitcherPlayer().GetAssociatedInventory();
			if( horseManInv )
			{
				allItems.Clear();
				allItems = horseManInv.GetItemsByName( itemName );
				horseManInv.ManageItemsTag( allItems, 'Quest', addQuestTag );
			}
		}
	}
	
	else
	{
		theGame.GetEntitiesByTag( containerTag, containers );
		if( containers.Size() == 0 )
		{
			LogQuest( "QuestItemDisable - containers with given tag:" + containerTag + " don't exist." );
		}
		else
		{
			for( i = 0 ; i < containers.Size() ; i += 1 )
			{
				cont = (W3Container)containers[i];
				contInv = cont.GetInventory();
				if( !contInv )
				{
					LogQuest( "QuestItemDisable - given container doesn't have any inventory component." );
				}
				else
				{
					allItems = contInv.GetItemsByName( itemName );
					if( allItems.Size() == 0 )
					{
						LogQuest( "QuestItemDisable - container with " + containerTag + " tag, doesn't have given item." );
					}
					else
					{
						contInv.ManageItemsTag( allItems, 'Quest', addQuestTag );
						cont.RequestUpdateContainer();
						
						if( !cont.HasQuestItem() )
						{
							cont.StopQuestItemFx();
						}
					}
				}
			}
		}	
	}
}

quest function TeleportPlayerWithPortalFx ( targetTag : name )
{
	var portal 			: W3OnSpawnPortal;
	var portalPos   	: Vector;
	var portalRot		: EulerAngles;
	var target 			: CNode;
	var entityToCreate	: CEntityTemplate;
	
	target = theGame.GetNodeByTag ( targetTag );
	
	if ( target )
	{
		portalPos = target.GetWorldPosition();
		portalRot = target.GetWorldRotation();
		
		entityToCreate = (CEntityTemplate)LoadResource( "portal_04" );
		thePlayer.TeleportWithRotation ( portalPos, portalRot );
		portal = (W3OnSpawnPortal)theGame.CreateEntity( entityToCreate, portalPos, portalRot );
		portal.HideCreature( thePlayer );
		
	}
	
	
}
enum EGwentDeckUnlock
{
	EGDU_Northern_Kingdom,
	EGDU_Nilfgaard,
	EGDU_Scoiatael,
	EGDU_No_Mans_Land,
}
quest function UnlockGwentDeck( val : EGwentDeckUnlock )
{
	switch ( val )
	{
		case EGDU_Northern_Kingdom :
		{
			theGame.GetGwintManager().UnlockDeck( GwintFaction_NothernKingdom );
			break;
		}
		case EGDU_Nilfgaard :
		{
			theGame.GetGwintManager().UnlockDeck( GwintFaction_Nilfgaard );
			break;
		}
		case EGDU_Scoiatael :
		{
			theGame.GetGwintManager().UnlockDeck( GwintFaction_Scoiatael );
			break;
		}
		case EGDU_No_Mans_Land :
		{
			theGame.GetGwintManager().UnlockDeck( GwintFaction_NoMansLand );
			break;
		}
	}
}

quest function SetHorsePanicMult( horseTag : name, mult : float )
{
	var entity : CEntity;
	var horse : CNewNPC;
	var horseComp : W3HorseComponent;
	
	entity = theGame.GetEntityByTag( horseTag );
	
	if( !entity )
	{
		LogQuest( "SetHorsePanicMult: Entity with tag <<" + horseTag + ">> doesn't exist, aborting." );
		return;
	}
	
	horse = (CNewNPC)entity;
	
	if( !horse )
	{
		LogQuest( "SetHorsePanicMult: Entity with tag <<" + horseTag + ">> is not CNewNPC, aborting." );
		return;
	}
	
	horseComp = horse.GetHorseComponent();
	
	if( !horseComp )
	{
		LogQuest( "SetHorsePanicMult: Could not get horseComponent, aborting." );
		return;
	}
	
	horseComp.SetPanicMult( mult );
}

enum EEnableMode
{
	EEM_AsIs,
	EEM_Enable,
	EEM_Disable
}

quest function ManagerReplacerWarningArea(areaTag : name, enable : EEnableMode)
{
	var i : int;
	var area : W3ReplacerWarningArea;
	var nodes : array<CNode>;
	
	
	if(enable == EEM_AsIs)
		return;
		
	theGame.GetNodesByTag(areaTag, nodes);
	
	if(nodes.Size() == 0)
	{
		LogQuest("QuestFunction ManagerReplacerWarningArea : cannot find any W3ReplacerWarningAreas with tag <<" + areaTag + ">>");
		return;
	}
	
	for(i=0; i<nodes.Size(); i+=1)
	{
		area = (W3ReplacerWarningArea)nodes[i];
		if(area)
		{
			if(enable == EEM_Enable)
				area.SetEnabled(true);
			else if(enable == EEM_Disable)
				area.SetEnabled(false);
		}
	}
}

quest function ToggleBoatCanBeDestroyed( boatTag : name, val : bool )
{
	var entity : CEntity;
	var boat : W3Boat;
	
	entity = theGame.GetEntityByTag( boatTag );
	
	if( !entity )
	{
		LogQuest( "ToggleBoatCanBeDestroyed: Entity with tag <<" + boatTag + ">> doesn't exist, aborting." );
		return;
	}
	
	boat = (W3Boat)entity;
	
	if( !boat )
	{
		LogQuest( "ToggleBoatCanBeDestroyed: Entity with tag <<" + boatTag + ">> is not W3Boat, aborting." );
		return;
	}

	
	boat.SetCanBeDestroyed( val );
}

quest function ToggleBoatInteraction( boatTag : name, enable : bool )
{
	var entity : CEntity;
	var boat : W3Boat;
	
	entity = theGame.GetEntityByTag( boatTag );
	
	if( !entity )
	{
		LogQuest( "ToggleBoatCanBeDestroyed: Entity with tag <<" + boatTag + ">> doesn't exist, aborting." );
		return;
	}
	
	boat = (W3Boat)entity;
	
	if( !boat )
	{
		LogQuest( "ToggleBoatCanBeDestroyed: Entity with tag <<" + boatTag + ">> is not W3Boat, aborting." );
		return;
	}
	
	boat.ToggleInteraction( enable );
}

quest function AllowHorseInTheInterior_Q ( interiorAreaTag: name, isAllowed : bool )
{
	var interiorArea: CR4InteriorAreaComponent;
	
	interiorArea = (CR4InteriorAreaComponent)theGame.GetEntityByTag( interiorAreaTag ).GetComponentByClassName ( 'CR4InteriorAreaComponent' );
	interiorArea.allowHorseInThisInterior = isAllowed;
}

quest function ApplyOil(oilName : name, onSteelSword : bool)
{
	var oilIds : array<SItemUniqueId>;
	var slot : EEquipmentSlots;
	var swordId : SItemUniqueId;
	
	if(GetWitcherPlayer())
	{
		if(onSteelSword)
			slot = EES_SteelSword;
		else
			slot = EES_SilverSword;
			
		GetWitcherPlayer().GetItemEquippedOnSlot(slot, swordId);
	}
	else if(thePlayer.IsCiri())
	{
		swordId = ((W3ReplacerCiri)thePlayer).GetEquippedSword(onSteelSword);
	}
	
	if(!thePlayer.inv.IsIdValid(swordId))
	{
		LogQuest("QuestFunction ApplyOil: player does not have selected sword type");
		return;
	}
	
	oilIds = thePlayer.inv.GetItemsByName(oilName);
	if(oilIds.Size() == 0)
	{
		LogQuest("QuestFunction ApplyOil: player does not have oil named <<" + oilName + ">>");
		return;
	}
	
	thePlayer.ApplyOil(oilIds[0], swordId);
}

quest function RemoveAllHerbsFromInventory()
{
	var allItems : array<SItemUniqueId>;
	var i : int;
	var inv : CInventoryComponent = thePlayer.GetInventory();
	
	allItems = inv.GetItemsByTag('HerbGameplay');
	for(i=allItems.Size()-1; i >= 0; i-=1)
	{
		inv.RemoveItem( allItems[i], inv.GetItemQuantity( allItems[i] ) ); 
	}
}

struct SGwentIngDef
{
	var itemName : name;
	var reqLevel : int;
	var quantityMin : int;
	var quantityMax : int;
};

function OutOfMemoryHack_Level0Items(out items : array<SGwentIngDef>)
{
	var itemDef : SGwentIngDef;	
	
	itemDef.itemName = 'Cotton';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 3;
	itemDef.quantityMax = 7;
	items.PushBack(itemDef);

	itemDef.itemName = 'Thread';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 4;
	itemDef.quantityMax = 6;
	items.PushBack(itemDef);

	itemDef.itemName = 'String';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 2;
	itemDef.quantityMax = 5;
	items.PushBack(itemDef);

	itemDef.itemName = 'Linen';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 4;
	itemDef.quantityMax = 6;
	items.PushBack(itemDef);

	itemDef.itemName = 'Silk';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 2;
	itemDef.quantityMax = 4;
	items.PushBack(itemDef);

	itemDef.itemName = 'Fiber';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 3;
	itemDef.quantityMax = 6;
	items.PushBack(itemDef);

	itemDef.itemName = 'Timber';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 2;
	itemDef.quantityMax = 4;
	items.PushBack(itemDef);

	itemDef.itemName = 'Coal';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 3;
	itemDef.quantityMax = 6;
	items.PushBack(itemDef);

	itemDef.itemName = 'Dye';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 1;
	itemDef.quantityMax = 3;
	items.PushBack(itemDef);

	itemDef.itemName = 'Oil';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 1;
	itemDef.quantityMax = 3;
	items.PushBack(itemDef);

	itemDef.itemName = 'Sap';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 1;
	itemDef.quantityMax = 4;
	items.PushBack(itemDef);

	itemDef.itemName = 'Resin';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 2;
	itemDef.quantityMax = 5;
	items.PushBack(itemDef);

	itemDef.itemName = 'Wax';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 3;
	itemDef.quantityMax = 7;
	items.PushBack(itemDef);

	itemDef.itemName = 'Leather straps';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 4;
	itemDef.quantityMax = 9;
	items.PushBack(itemDef);

	itemDef.itemName = 'Leather squares';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 3;
	itemDef.quantityMax = 5;
	items.PushBack(itemDef);

	itemDef.itemName = 'Fur square';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 1;
	itemDef.quantityMax = 4;
	items.PushBack(itemDef);

	itemDef.itemName = 'Leather';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 2;
	itemDef.quantityMax = 5;
	items.PushBack(itemDef);

	itemDef.itemName = 'Lead ore';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 1;
	itemDef.quantityMax = 4;
	items.PushBack(itemDef);

	itemDef.itemName = 'Gold mineral';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 1;
	itemDef.quantityMax = 3;
	items.PushBack(itemDef);

	itemDef.itemName = 'Iron ore';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 3;
	itemDef.quantityMax = 6;
	items.PushBack(itemDef);

	itemDef.itemName = 'Nails';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 2;
	itemDef.quantityMax = 5;
	items.PushBack(itemDef);

	itemDef.itemName = 'Iron ingot';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 3;
	itemDef.quantityMax = 6;
	items.PushBack(itemDef);

	itemDef.itemName = 'Wire';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 2;
	itemDef.quantityMax = 4;
	items.PushBack(itemDef);

	itemDef.itemName = 'Steel ingot';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 2;
	itemDef.quantityMax = 5;
	items.PushBack(itemDef);

	itemDef.itemName = 'Steel plate';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 2;
	itemDef.quantityMax = 3;
	items.PushBack(itemDef);

	itemDef.itemName = 'Silver mineral';
	itemDef.reqLevel = 0;
	itemDef.quantityMin = 3;
	itemDef.quantityMax = 5;
	items.PushBack(itemDef);
}

function OutOfMemoryHack_Level10Items(out items : array<SGwentIngDef>)
{
	var itemDef : SGwentIngDef;	
	
	itemDef.itemName = 'Hardened timber';
	itemDef.reqLevel = 10;
	itemDef.quantityMin = 2;
	itemDef.quantityMax = 4;
	items.PushBack(itemDef);

	itemDef.itemName = 'Hardened leather';
	itemDef.reqLevel = 10;
	itemDef.quantityMin = 3;
	itemDef.quantityMax = 4;
	items.PushBack(itemDef);

	itemDef.itemName = 'Parchment';
	itemDef.reqLevel = 10;
	itemDef.quantityMin = 2;
	itemDef.quantityMax = 4;
	items.PushBack(itemDef);

	itemDef.itemName = 'Amber';
	itemDef.reqLevel = 10;
	itemDef.quantityMin = 1;
	itemDef.quantityMax = 3;
	items.PushBack(itemDef);

	itemDef.itemName = 'Amber fossil';
	itemDef.reqLevel = 10;
	itemDef.quantityMin = 0;
	itemDef.quantityMax = 1;
	items.PushBack(itemDef);

	itemDef.itemName = 'Gold ore';
	itemDef.reqLevel = 10;
	itemDef.quantityMin = 1;
	itemDef.quantityMax = 2;
	items.PushBack(itemDef);

	itemDef.itemName = 'Wire rope';
	itemDef.reqLevel = 10;
	itemDef.quantityMin = 1;
	itemDef.quantityMax = 3;
	items.PushBack(itemDef);

	itemDef.itemName = 'Silver ore';
	itemDef.reqLevel = 10;
	itemDef.quantityMin = 2;
	itemDef.quantityMax = 4;
	items.PushBack(itemDef);

	itemDef.itemName = 'Silver plate';
	itemDef.reqLevel = 10;
	itemDef.quantityMin = 1;
	itemDef.quantityMax = 3;
	items.PushBack(itemDef);
}

function AddRandomCraftingComponentsGwintQuest( merchantTag : name )
{
	var itemDef : SGwentIngDef;
	var items : array<SGwentIngDef>;
	var playerLevel, quantity, alreadyGivenCount : int;
	
	playerLevel = GetWitcherPlayer().GetLevel();
	
	
	OutOfMemoryHack_Level0Items(items);
	
	if(playerLevel >= 10)
		OutOfMemoryHack_Level10Items(items);
	
	
	itemDef = items[ RandRange(items.Size()) ];
	
	
	quantity = RandRange(itemDef.quantityMax + 1, itemDef.quantityMin);
	
	
	alreadyGivenCount = FactsQuerySum(merchantTag + "_gwent_given");
	quantity = Max(1, quantity - FloorF(alreadyGivenCount * 0.5f));
	
	thePlayer.inv.AddAnItem(itemDef.itemName, quantity, true, false, true);
	
	FactsAdd(merchantTag + "_gwent_given");
}


quest function GiveSpecificGwentCardViaMerchantQuest( merchantTag : name, cardName : name, disableCraftingComponentsIfGiven : bool  )
{
	var i: int;
	
	if( FactsQuerySum( "merchant_card_" + merchantTag + "_card_already_given" ) >= 1 )
	{
		if(!disableCraftingComponentsIfGiven)
		{	
			AddRandomCraftingComponentsGwintQuest(merchantTag);
		}
		return;
	}
	else
	{
		FactsAdd( "merchant_card_" + cardName + "_already_given", 1, -1 );
		FactsAdd( "merchant_card_" + merchantTag + "_card_already_given", 1, -1);
		
		thePlayer.inv.AddAnItem( cardName, 1, true, true);
	}
}


quest function GiveMerchantRandomGwintCardToPlayerQuest( merchantTag : name )
{
	var cards 			: array<name>;
	var cardsAvailable  : array<name>;
	var selectedCard    : name;
	var i: int;
	
	if( FactsQuerySum( "merchant_card_" + merchantTag + "_card_already_given" ) >= 1 )
	{
		AddRandomCraftingComponentsGwintQuest(merchantTag);
		return;
	}
	
	
	cards.PushBack( 'gwint_card_fog' );
	cards.PushBack( 'gwint_card_frost' );		
	cards.PushBack( 'gwint_card_rain' );
	cards.PushBack( 'gwint_card_clear_sky' );
		
	cards.PushBack( 'gwint_card_arachas_behemoth' );
	cards.PushBack( 'gwint_card_assire' );	
	cards.PushBack( 'gwint_card_filavandrel' );
	cards.PushBack( 'gwint_card_cahir' );
	cards.PushBack( 'gwint_card_celaeno_harpy' );
	cards.PushBack( 'gwint_card_ciaran' );
	cards.PushBack( 'gwint_card_cockatrice' );
	cards.PushBack( 'gwint_card_crone_brewess' );
	cards.PushBack( 'gwint_card_dennis' );
	cards.PushBack( 'gwint_card_dol_dwarf2' );
	cards.PushBack( 'gwint_card_dol_dwarf3' );
	cards.PushBack( 'gwint_card_dol_infantry2' );
	cards.PushBack( 'gwint_card_dol_infantry3' );
	cards.PushBack( 'gwint_card_elf_skirmisher2' );
	cards.PushBack( 'gwint_card_elf_skirmisher3' );
	cards.PushBack( 'gwint_card_emiel' );	
	cards.PushBack( 'gwint_card_endrega' );
	cards.PushBack( 'gwint_card_fire_elemental' );
	cards.PushBack( 'gwint_card_forktail' );
	cards.PushBack( 'gwint_card_frightener' );
	cards.PushBack( 'gwint_card_gargoyle' );
	cards.PushBack( 'gwint_card_garkain' );
	cards.PushBack( 'gwint_card_ghoul2' );
	cards.PushBack( 'gwint_card_ghoul3' );
	cards.PushBack( 'gwint_card_grave_hag' );
	cards.PushBack( 'gwint_card_griffin' );
	cards.PushBack( 'gwint_card_havekar_nurse' );
	cards.PushBack( 'gwint_card_havekar_support2' );
	cards.PushBack( 'gwint_card_ida' );	
	cards.PushBack( 'gwint_card_imlerith' );
	cards.PushBack( 'gwint_card_kayran' );
	cards.PushBack( 'gwint_card_toruviel' );
	cards.PushBack( 'gwint_card_nekker3' );
	cards.PushBack( 'gwint_card_philippa' );
	cards.PushBack( 'gwint_card_plague_maiden' );
	cards.PushBack( 'gwint_card_renuald' );
	cards.PushBack( 'gwint_card_riordain' );
	cards.PushBack( 'gwint_card_rotten' );
	cards.PushBack( 'gwint_card_shilard' );
	cards.PushBack( 'gwint_card_siege_tower' );
	cards.PushBack( 'gwint_card_stefan' );
	cards.PushBack( 'gwint_card_vanhemar' );
	cards.PushBack( 'gwint_card_vattier' );
	cards.PushBack( 'gwint_card_villen' );	
	cards.PushBack( 'gwint_card_vreemde' );
	cards.PushBack( 'gwint_card_vrihedd_cadet' );
	cards.PushBack( 'gwint_card_wyvern' );
	
	for( i = 0; i < cards.Size(); i+=1 )
	{
		if( FactsQuerySum( "merchant_card_" + cards[i] + "_already_given" ) == 0 )
		cardsAvailable.PushBack( cards[i] );
	}
	
	if( cardsAvailable.Size() > 0 )
	{
		selectedCard = cardsAvailable[ RandRange(cardsAvailable.Size() - 1 ) ];
		
		FactsAdd( "merchant_card_" + selectedCard + "_already_given", 1, -1 );
		FactsAdd( "merchant_card_" + merchantTag + "_card_already_given", 1, -1);
		
		thePlayer.inv.AddAnItem( selectedCard, 1, true, true);
	}
}
	
quest function KillWithoutAgony( killTag : name )
{
	var npc : CNewNPC;

	npc = theGame.GetNPCByTag( killTag );
	npc.DisableAgony();
	npc.Kill( 'Quest', true );
}


quest function EnableSignReactiveEntityQ ( igni : bool, aard : bool, entityTag : name )
{
	var i : int;
	var entities : array <CEntity>;
	var signEntity : CSignReactiveEntity;
	
	theGame.GetEntitiesByTag ( entityTag, entities );
	
	for ( i=0; i<entities.Size(); i+=1 )
	{
		signEntity = (CSignReactiveEntity)entities[i];
		if ( signEntity )
		{
			signEntity.igni = igni;
			signEntity.aard = aard;

		}
	}
}

quest function ToggleSupressBroadcastingReactionsByTag( supress : bool, tag : name )
{
	var i : int;
	var npcs : array<CNewNPC>;
	
	theGame.GetNPCsByTag(tag,npcs);
	
	for ( i=0; i<npcs.Size(); i+=1 )
	{
		npcs[i].suppressBroadcastingReactions = supress;
	}
}

quest function DisableNPCInteractivness ( npcTag : name, disableTalking : bool, disableOnliners : bool, disableLookats : bool )
{
	var i : int;
	var npcs : array <CNewNPC>;
	var npc : CNewNPC;
	
	theGame.GetNPCsByTag ( npcTag, npcs );
	
	for ( i=0; i<npcs.Size(); i+=1 )
	{
		npc = npcs[i];
		if ( npc )
		{
			npc.DisableTalking ( disableTalking );
			npc.dontUseReactionOneLiners = disableOnliners;
			npc.disableConstrainLookat = disableLookats;
			
		}
	}
}

quest function SpawnMagicBubble( resourceName : name, spawnPos : Vector, spawnRot : EulerAngles, addTag : name )
{
	var magicBubbleTemplate : CEntityTemplate;
	var magicBubble	: CEntity;

	magicBubbleTemplate = (CEntityTemplate)LoadResource(resourceName);	

	if ( magicBubbleTemplate )
	{
		magicBubble = theGame.CreateEntity(magicBubbleTemplate,spawnPos,spawnRot);
		if ( IsNameValid(addTag) && magicBubble )
			magicBubble.AddTag(addTag);
	}
	else
		LogQuest( "Quest function <<SpawnMagicBubble>>: No resource with name: '" + resourceName + "' was found!" );
}

quest function DespawnMagicBubbleByTag( magicBubbleTag : name )
{
	var entitesList : array<CEntity>;
	var magicBubble : W3MagicBubbleEntity;
	var i : int;

	theGame.GetEntitiesByTag( magicBubbleTag, entitesList );
	
	if ( entitesList.Size() <= 0 )
	{
		LogQuest( "Quest function <<DespawnMagicBubbleByTag>>: No entities with tag: '" + magicBubbleTag + "' was found!" );
		return;
	}
	
	for(i=0; i<entitesList.Size(); i+=1)
	{
		magicBubble = (W3MagicBubbleEntity)entitesList[i];
		if ( magicBubble )
		{
			magicBubble.ToggleActivate(false);
			magicBubble.DestroyAfter(5);
		}
	}
}

quest function AddAlchemyRecipeQ ( recipeName : name )
{
	var player : W3PlayerWitcher;
	
	player = GetWitcherPlayer();
	
	if ( player )
	{
		player.AddAlchemyRecipe( recipeName );
	}
	
}

quest function AddCraftingSchematicsQ ( schematicsName : name )
{
	var player : W3PlayerWitcher;
	
	player = GetWitcherPlayer();
	
	if ( player )
	{
		player.AddAlchemyRecipe( schematicsName );
	}
}

quest function SetBehaviorVariableQuest( entityTag : name, variableName : name, variableValue : float )
{
	var entities : array<CEntity>;
	var i : int;

	theGame.GetEntitiesByTag( entityTag, entities );
	
	if ( entities.Size() <= 0 )
	{
		LogQuest( "Quest function <<SetBehaviorVariableOnActor>>: No entities with tag: '" + entityTag + "' was found!" );
		return;
	}
	
	for(i=0; i<entities.Size(); i+=1)
	{
		entities[i].SetBehaviorVariable(variableName,variableValue);
	}
}

quest function EnableProudWalk( enable : bool )
{
	var player : CR4Player;

	player = thePlayer;
	player.proudWalk = enable;
	player.SetBehaviorVariable( 'proudWalk', (float)( player.proudWalk ) );
}

quest function EnableInjuredWalk( enable : bool )
{
	var player : CR4Player;

	player = thePlayer;
	player.injuredWalk = enable;
	if ( enable )
	{
		player.SetBehaviorVariable( 'alternateWalk', 1.0f );
	}
	else
	{
		player.SetBehaviorVariable( 'alternateWalk', 0.0f );
	}
}

quest function EnableTiedWalk( enable : bool )
{
	var player : CR4Player;

	player = thePlayer;
	player.tiedWalk = enable;
	if ( enable )
	{
		player.SetBehaviorVariable( 'alternateWalk', 2.0f );
	}
	else
	{
		player.SetBehaviorVariable( 'alternateWalk', 0.0f );
	}
}

quest function RecoverGeralt(dontUpdateUI : bool)
{
	thePlayer.inv.SingletonItemsRefillAmmoNoAlco(dontUpdateUI);
	thePlayer.Heal(thePlayer.GetStatMax(BCS_Vitality));
	
	if(GetWitcherPlayer())
	{
		thePlayer.ForceSetStat(BCS_Toxicity, 0.f);
	}
}

quest function ApplyAlchemyTableBuff()
{
	thePlayer.inv.ManageSingletonItemsBonus();
}

quest function EnableTargetingOnActorsQ (actorsTag : name, isEnabled : bool )
{
	var i : int;
	var actors : array <CActor>;
	var actor : CActor;
	
	theGame.GetActorsByTag ( actorsTag, actors );
	
	for ( i=0; i<actors.Size(); i+=1 )
	{
		actor = actors[i];
		if ( actor )
		{
			actor.SetTatgetableByPlayer(isEnabled);
			
		}
	}
}

quest function ForceManaualSaveQ ()
{
	var title:  string = "force_manual_save_title";
	var message : string = "force_manual_save_message";
	
	var l_title:  string;
	var l_message : string;
	
	l_title = GetLocStringByKeyExt( title );
	
	l_message = GetLocStringByKeyExt( message );

	
	theGame.GetGuiManager().ShowUserDialog(UMID_ForceManualSaveWindow, title, message, UDB_OkCancel);
}

quest function ForceManaualSaveQ_Custom( title:  string, message : string )
{
	theGame.GetGuiManager().ShowUserDialog(UMID_ForceManualSaveWindow, title, message, UDB_OkCancel);
}


quest function SetHorseMountableByPlayerQ ( horseTag: name, isMountable : bool )
{
	var comp 	: W3HorseComponent;
	var horse 	: CNewNPC;
	
	horse = theGame.GetNPCByTag(horseTag);
	
	if (horse)
	{
		comp = (W3HorseComponent)horse.GetComponentByClassName ('W3HorseComponent');
		if ( comp )
		{
			comp.SetMountableByPlayer(isMountable);
		}
	}
}

quest function HideUsableItemLQuest ( force : bool )
{
	thePlayer.HideUsableItem(force);
}

quest function ShowHud( show : bool )
{
	var hud : CR4ScriptedHud;
	
	hud = (CR4ScriptedHud)theGame.GetHud();
	if ( hud )
	{
		hud.ForceShow( show, HVS_System );
	}
}

quest function SetNPCTargetabilityQuest (npcTag: name, _isTargetable : bool, _isAttackable : bool, _isUsingTooltip : bool )
{
	var npcs : array<CNewNPC>;
	var i : int;
	
	theGame.GetNPCsByTag(npcTag, npcs );
	
	for ( i=0; i< npcs.Size(); i+=1 )
	{
		npcs[i].SetIsUsingTooltip( _isUsingTooltip );
		npcs[i].SetAttackableByPlayerPersistent( _isAttackable );
		npcs[i].SetTatgetableByPlayer( _isTargetable );
	}
}

quest function MuteHeadAudio( tag: name, mute : bool )
{
	var entities : array< CEntity >;
	var i : int;
	var actor : CActor;
	theGame.GetEntitiesByTag( tag, entities );
	for( i = 0; i < entities.Size(); i+=1 )
	{
		actor = (CActor) entities[ i ];
		if( actor )
		{
			actor.MuteHeadAudio( mute );
		}
	}
}

quest function AddTagToFurthestNodeQuest( nodeTag : name, newTag : name, remove: bool )
{
	var node  : CNode;
	var nodes : array<CNode>;
	var size  : int;
	var tags : array<name>;
	
	theGame.GetNodesByTag( nodeTag, nodes );
	SortNodesByDistance( thePlayer.GetWorldPosition(), nodes );
	
	size = nodes.Size();
	node = nodes[size-1];
	tags = node.GetTags();
	
	if ( !remove )
	{
		tags.PushBack(newTag);
	}
	else
	{
		if ( !tags.Remove(newTag) )
		{
			LogQuest("AddTagToFurthestNodeQuest_questFunction: GameplayEntity doesn't have " + newTag + " tag!!! ");
		}
	}
	node.SetTags(tags);
}

quest function MoneyModifyQuest(containerTag : name, value : int, isPercentage : bool)
{
	var ent : CGameplayEntity;
	var inv : CInventoryComponent;
	
	ent = (CGameplayEntity)theGame.GetNodeByTag(containerTag);
	inv = ent.GetInventory();
	
	if(isPercentage)
	{
		value = RoundMath(value * inv.GetMoney() / 100);
	}
	
	if(value > 0)
	{
		inv.AddMoney(value);
	}
	else
	{
		inv.RemoveMoney(-value);
	}
}

quest function UseCoatOfArmsInsteadOfWolfsHead( value : bool )
{
	theGame.GetGuiManager().GetHudEventController().RunEvent_WolfHeadModule_SetCoatOfArms( value );
}

enum EHudTimeOutAction
{
	EHTOA_Start,
	EHTOA_Stop,
	EHTOA_Add,
};

quest function ManageHudTimeOut( action : EHudTimeOutAction, value : float )
{
	theGame.GetGuiManager().GetHudEventController().RunEvent_TimeLeftModule_ManageHudTimeOut( action, value );
}

quest function ActivateEthereal( tag : name )
{
	var actor : CActor;
	actor = ( CActor )( theGame.GetEntityByTag( tag ) );
	
	if( !actor )
			LogChannel( 'Error', "Actor not found in ActivateEthereal quest function." );
	else
	{
		actor.ActivateEthereal();
	}
}

quest function AddSkillToEthereals( skillNumber : int, tag : name )
{
	
}

quest function BoostPlayerLevel(toLevel : int)
{
	var curLvl, i	: int;
	var lvlMng		: W3LevelManager;
	
	curLvl = thePlayer.GetLevel();
	lvlMng = GetWitcherPlayer().levelManager;
	
	if(curLvl>=toLevel)
		return;
	else 
	{	
		for(i=curLvl;i<toLevel;i+=1)
		{
			lvlMng.AddPoints(EExperiencePoint, (lvlMng.GetTotalExpForNextLevel() - lvlMng.GetPointsTotal(EExperiencePoint)), false);
		}	
	}		
}

quest function BoostPlayerLevelEx(toLevel : int, notifyUI : bool )
{
	var curLvl, i	: int;
	var lvlMng		: W3LevelManager;
	
	curLvl = thePlayer.GetLevel();
	lvlMng = GetWitcherPlayer().levelManager;
	
	if(curLvl>=toLevel)
		return;
	else 
	{	
		for(i=curLvl;i<toLevel;i+=1)
		{
			lvlMng.AddPoints(EExperiencePoint, (lvlMng.GetTotalExpForNextLevel() - lvlMng.GetPointsTotal(EExperiencePoint)), notifyUI );
		}	
	}		
}

quest function InteractiveQuestEntityEnable( tag : name, enable : bool )
{

	var entities : array< CEntity >;
	var i : int;
	var entity : W3InteractiveQuestEntity;
	theGame.GetEntitiesByTag( tag, entities );
	
	for( i = 0; i < entities.Size(); i+=1 )
	{
		entity = (W3InteractiveQuestEntity) entities[ i ];
		if( entity )
		{
			entity.SetInteractions( enable );
		}
	}
	
}

quest function PerformRaycastQuest( collisionGroupsNames : array<name>, searchedTag : name ) : bool
{

	var cachedCamDirection 	: Vector;
	var cachedCamPosition	: Vector;
	var cachedOwnerPosition	: Vector;

	var traceResultDists		: array<float>;
	var tracePosFromInitial		: Vector;
	var maxRangePos				: Vector;
	
	var traceManager 			: CScriptBatchQueryAccessor;
	
	var i, size					: int;
	var hasResult				: bool;
	var rayCastResult 			: SRaycastHitResult;
	var rayCastResults 			: array<SRaycastHitResult>;	
	var ent						: CEntity;	
	var entityTags				: array<name>;
	
	traceManager = theGame.GetWorld().GetTraceManager();
	
	cachedCamDirection = theCamera.GetCameraDirection();
	cachedCamPosition = theCamera.GetCameraPosition();
	cachedOwnerPosition = thePlayer.GetWorldPosition();
	tracePosFromInitial = 0.5f * VecNormalize( cachedCamDirection ) + cachedCamPosition;
	maxRangePos = VecNormalize( cachedCamDirection ) * theGame.params.MAX_THROW_RANGE + tracePosFromInitial;

		if ( traceManager.RayCastSync( tracePosFromInitial, maxRangePos , rayCastResults, collisionGroupsNames ) )		
		{		
			size =  rayCastResults.Size();
			if ( size > 0 )
			{	
				
				for ( i = 0; i < rayCastResults.Size(); i += 1 )
				{
					ent = rayCastResults[i].component.GetEntity();
					
					if(ent)
					{
						if( ent.HasTag( searchedTag ) )
						return true;
					}
					
				}
			}
		}
	
	return false;
}

quest function DestroyMonsterNest(tag : name)
{
	var entity : CEntity;
	var nest : CMonsterNestEntity;
	
	entity = theGame.GetEntityByTag(tag);
	if(entity)
	{
		nest = (CMonsterNestEntity)entity;
		if(nest)
		{
			
			nest.OnFireHit(NULL);
		}
	}
}

quest function EnableMimics( tag : name, enable : bool )
{
	var actors : array<CActor>;
	var i : int;
	
	theGame.GetActorsByTag( tag, actors );
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		if( enable )
			actors[i].SetBehaviorMimicVariable( 'gameplayMimicsMode', (float)(int)GMM_Default );
		else
			actors[i].SetBehaviorMimicVariable( 'gameplayMimicsMode', (float)(int)GMM_Tpose );
	}
}


quest function MarkEquippedItems(sourceName : name, allItems : bool, slots : array<EEquipmentSlots>)
{
	var i, j : int;
	var witcher : W3PlayerWitcher;
	var duplicateSlot : bool;
	var item : SItemUniqueId;
	var items, horseItems : array<SItemUniqueId>;
	var horseMan : W3HorseManager;
	var slot : EEquipmentSlots;
	var selectedQuickslotItem : SItemUniqueId;
	var sel : SSelectedQuickslotItem;
	
	
	if(!IsNameValid(sourceName))
	{
		LogQuest("Quest function <<MarkEquippedItems>>: no source name provided, aborting!");
		return;
	}
	if(!allItems && slots.Size() == 0)
	{
		LogQuest("Quest function <<MarkEquippedItems>>: no items selected, aborting!");
		return;
	}
	witcher = GetWitcherPlayer();
	if(!witcher)
	{
		LogQuest("Quest function <<MarkEquippedItems>>: only Geralt has equip item functionality, aborting!");
		return;
	}
	
	
	if(allItems)
	{
		items = witcher.GetEquippedItems();
		horseMan = witcher.GetHorseManager();
		
		item = horseMan.GetItemInSlot(EES_HorseBlinders);
		if(horseMan.GetInventoryComponent().IsIdValid(item))
			horseItems.PushBack(item);
			
		item = horseMan.GetItemInSlot(EES_HorseSaddle);
		if(horseMan.GetInventoryComponent().IsIdValid(item))
			horseItems.PushBack(item);
			
		item = horseMan.GetItemInSlot(EES_HorseBag);
		if(horseMan.GetInventoryComponent().IsIdValid(item))
			horseItems.PushBack(item);
			
		item = horseMan.GetItemInSlot(EES_HorseTrophy);
		if(horseMan.GetInventoryComponent().IsIdValid(item))
			horseItems.PushBack(item);
	}
	else
	{
		for(i=0; i<slots.Size(); i+=1)
		{
			
			if(slots[i] == EES_InvalidSlot)
				continue;
				
			
			duplicateSlot = false;
			for(j=0; j<i; j+=1)
			{
				if(slots[j] == slots[i])
				{
					duplicateSlot = true;
					break;
				}
			}
			
			if(duplicateSlot)
				continue;
			
			
			if(IsSlotHorseSlot(slots[i]))
			{
				item = witcher.GetHorseManager().GetItemInSlot(slots[i]);
				if(witcher.GetHorseManager().GetInventoryComponent().IsIdValid(item))
					horseItems.PushBack(item);
					
				continue;
			}
			
			
			if(witcher.GetItemEquippedOnSlot(slots[i], item))
				items.PushBack(item);
		}
	}
	
	selectedQuickslotItem = witcher.GetSelectedItemId();
	
	
	for(i=0; i<items.Size(); i+=1)
	{
		if(witcher.inv.GetItemModifierInt(items[i], sourceName, 0) == 0)
		{
			
			slot = witcher.GetItemSlot(items[i]);
			witcher.inv.SetItemModifierInt(items[i], sourceName, slot);
			
			
			if( selectedQuickslotItem == items[i] )
			{
				sel.sourceName = sourceName;
				sel.itemID = selectedQuickslotItem;
				witcher.AddQuestMarkedSelectedQuickslotItem( sel );
			}
		}
	}
	
	for(i=0; i<horseItems.Size(); i+=1)
	{
		if(horseMan.GetInventoryComponent().GetItemModifierInt(horseItems[i], sourceName, 0) == 0)
			horseMan.GetInventoryComponent().SetItemModifierInt(horseItems[i], sourceName, horseMan.GetInventoryComponent().GetSlotForItemId(horseItems[i]) );
	}
}

quest function ReequipMarkedItems(sourceName : name)
{
	var i, j : int;
	var items : array<SItemUniqueId>;
	var witcher : W3PlayerWitcher;
	var horseItem, selectedItemID : SItemUniqueId;
	var tags : array<name>;
	var slot : EEquipmentSlots;
	var slotTag : name;
	
	
	if(!IsNameValid(sourceName))
	{
		LogQuest("Quest function <<ReequipMarkedItems>>: no source name provided, aborting!");
		return;
	}
	witcher = GetWitcherPlayer();
	if(!witcher)
	{
		LogQuest("Quest function <<ReequipMarkedItems>>: only Geralt has equip item functionality, aborting!");
		return;
	}
	
	
	witcher.inv.GetAllItems(items);
	for(i=0; i<items.Size(); i+=1)
	{
		slot = witcher.inv.GetItemModifierInt(items[i], sourceName, 0);
		
		
		if(slot == 0)
			continue;
		
		if(witcher.inv.IsItemHorseItem(items[i]))
		{
			horseItem = witcher.GetHorseManager().MoveItemToHorse(items[i]);
			witcher.GetHorseManager().EquipItem(horseItem);
			witcher.GetHorseManager().GetInventoryComponent().SetItemModifierInt(horseItem, sourceName, 0);
		}
		else
		{
			
			witcher.EquipItemInGivenSlot(items[i], slot, false);
			
			
			witcher.inv.SetItemModifierInt(items[i], sourceName, 0);
		}
	}
	
	
	selectedItemID = witcher.GetQuestMarkedSelectedQuickslotItem( sourceName );
	if( witcher.inv.IsIdValid( selectedItemID ) )
	{
		witcher.SelectQuickslotItem( witcher.GetSlotForEquippedItem( selectedItemID ) );
	}
}

quest function AddItemTagQuest( itemName : name , itemTag : name, remove : bool, entityTag : name )
{
	var allItems : array<SItemUniqueId>;
	var i : int;
	var horseManInv, inv : CInventoryComponent;
	var entities : array<CEntity>;
	
	if( entityTag != '' )
	{
		theGame.GetEntitiesByTag( entityTag, entities );
		if( entities.Size() == 0 )
		{
			LogQuest( "AddItemTagQuest: cannot find any entities with tag <<" + entityTag + ">>, aborting!" );
			return;
		}
		inv = (CInventoryComponent) entities[0].GetComponentByClassName( 'CInventoryComponent' );
		if( !inv )
		{
			LogQuest( "AddItemTagQuest: entity with tag <<" + entityTag + ">> has no inventory, aborting!" );
			return;
		}
	}
	else
	{
		inv = thePlayer.inv;
	}
	
	
	allItems = inv.GetItemsByName(itemName);
	for(i=allItems.Size()-1; i >= 0; i-=1)
	{
		if (!remove)
		{
			inv.AddItemTag( allItems[i], itemTag );
		}
		else
		{
			inv.RemoveItemTag( allItems[i], itemTag );
		}
	}
	
	
	if( entityTag == '' && GetWitcherPlayer() )
	{
		horseManInv = GetWitcherPlayer().GetAssociatedInventory();
		if(horseManInv)
		{
			allItems.Clear();
			allItems = horseManInv.GetItemsByName(itemName);
			for(i=allItems.Size()-1; i >= 0; i-=1)
			{
				if (!remove)
				{
					horseManInv.AddItemTag( allItems[i], itemTag );
				}
				else
				{
					horseManInv.RemoveItemTag( allItems[i], itemTag );
				}
			}
		}
	}
}



quest function ForceOpenNoticeboardQuest( boardTag : name, dontConsiderAsVisiting : bool, dontAddDiscoveryFact : bool, dontSetPOIEntitiesKnown : bool )
{
	var board : W3NoticeBoard;
	board = (W3NoticeBoard) theGame.GetEntityByTag( boardTag );
	
	if( board )
	{
		board.OpenNoticeboardPanel( dontConsiderAsVisiting, dontAddDiscoveryFact, dontSetPOIEntitiesKnown );
	}
}


quest function DisableNoticeboardQuest( boardTag : name, disabled : bool )
{
	var boards : array<CEntity>;
	var board : W3NoticeBoard;
	var i : int;
	
	theGame.GetEntitiesByTag( boardTag, boards );
	
	for( i = 0; boards.Size() > i; i += 1 )
	{
		board = (W3NoticeBoard) boards[i];
		
		if (board)
		{
			board.DisableNoticeboard( disabled );
		}
	}
}

enum EQuestPadVibrationStrength
{
	EQPVS_VeryLight,
	EQPVS_Light,
	EQPVS_Hard,
	EQPVS_VeryHard
}

quest function VibrateController(strength : EQuestPadVibrationStrength, duration : float)
{
	switch(strength)
	{
		case EQPVS_VeryLight:
			theGame.VibrateControllerVeryLight(duration);
			return;
		case EQPVS_Light:
			theGame.VibrateControllerLight(duration);
			return;
		case EQPVS_Hard:
			theGame.VibrateControllerHard(duration);
			return;
		case EQPVS_VeryHard:
			theGame.VibrateControllerVeryHard(duration);
			return;
		default:
			return;
	}
}

quest function StoreEnchanterMoney( enchanterTag : name )
{
	var enchanterEntity : W3MerchantNPC;
	var inventoryComp : CInventoryComponent;

	if ( enchanterTag == '' )
	{
		return;
	}

	enchanterEntity = ( W3MerchantNPC )theGame.GetEntityByTag( enchanterTag );
	if ( !enchanterEntity )
	{
		return;
	}
	
	inventoryComp = ( CInventoryComponent )enchanterEntity.GetComponentByClassName( 'CInventoryComponent' );
		
	theGame.SetSavedEnchanterFunds( inventoryComp.GetMoney() );
}

quest function RestoreEnchanterMoney( enchanterTag : name )
{
	
	return;
}

latent quest function SetHorseMode( mode : EHorseMode )
{
	GetWitcherPlayer().GetHorseManager().SetHorseMode( mode );
}

latent quest function CollectItemsTHCustomQuest ( collectorTag : name, items : array<name>, uniqueTransactionId : string, keepItemsInContainer : bool, optional filterTagsList : array<name> ) : bool
{
	var popupData : W3ItemSelectionPopupData;
	var itemSelectionPopup : CR4ItemSelectionPopup;
	var inventory : CInventoryComponent;
	var received, alreadyCollected : bool;
	var i, collectedCount : int = 0;	
	var result : bool;
	var ent : CGameplayEntity;
	var validItemFound : bool;
	
	ent = (CGameplayEntity)theGame.GetEntityByTag( collectorTag );
	
	
	if( !ent )
	{
		return false;
	}
	
	inventory = ent.GetInventory();		
	theGame.GetGuiManager().SetLastOpenedCommonMenuName( 'None' ); 		
	
	
	popupData = new W3ItemSelectionPopupData in theGame.GetGuiManager();
	popupData.targetInventory = inventory;
	popupData.collectorTag = collectorTag;
	popupData.filterTagsList = filterTagsList;
	popupData.targetItems = items;
	
	theGame.RequestPopup('ItemSelectionPopup', popupData);

	
	while (popupData)
	{
		SleepOneFrame();
	}

	
	for( i=0; i < items.Size(); i+=1 )
	{
		FactsRemove( uniqueTransactionId + "_" + items[i] );
	}

	
	for( i=0; i < items.Size(); i+=1 )
	{
		if( inventory.HasItem( items[i] ) )
		{	 
			FactsAdd( uniqueTransactionId + "_" + items[i], 1, -1 );
			validItemFound = true;
			
			if( !keepItemsInContainer )
			{
				inventory.RemoveItemByName( items[i], 1 );
			}
		}
	}
	
	return validItemFound;
}


quest function EnableHouseDecorationQuest( decorationTag : name, enable : bool )
{
	var entities : array<CEntity>;
	var entity : W3HouseDecorationBase;
	var size, i : int;

	theGame.GetEntitiesByTag( decorationTag, entities );
	size = entities.Size();
	
	for( i=0; i < size; i+= 1 )
	{
		entity = (W3HouseDecorationBase) entities[i];
		
		if( entity )
		{
			entity.SetDecorationEnabled( enable );
		}
		
	}

}

quest function MutationSystemEnable( enable : bool )
{
	GetWitcherPlayer().MutationSystemEnable( enable );
}

quest function AddSkillPoints( amount : int, dontShowOnHUD : bool )
{
	if( !GetWitcherPlayer() )
	{
		LogQuest( "AddSkillPoints: can't add skillpoints - only Geralt can have those! Aborting." );
		return;
	}
	
	if( amount <= 0 )
	{
		LogQuest( "AddSkillPoints: can't add skillpoints - amount (" + amount + ") has to be >0. Aborting." );
		return;
	}
	
	GetWitcherPlayer().AddPoints( ESkillPoint, amount, !dontShowOnHUD );
}



latent quest function SyncNPCHealthQuest( targetNPCTag : name, sourceNPCsTags : array<name>, useCurrentTargetHPAsBaseline : bool, killOnNoValidSources : bool  )
{
	var targetNPC : CNewNPC;
	var sourceNPCs : array<CNewNPC>;
	var searchedNPC : CNewNPC;
	var sourceNPCNumber : int;
	var i : int;
	var hpSum : float;
	var quotaModifier : float;
	
	targetNPC  = theGame.GetNPCByTag( targetNPCTag );
	
	
	if( !targetNPC )
	{
		return;
	}
	
	
	for( i=0; i < sourceNPCsTags.Size() ; i+= 1 )
	{
		searchedNPC = theGame.GetNPCByTag( sourceNPCsTags[i] );
		
		if( searchedNPC )
		{
			sourceNPCs.PushBack( searchedNPC );
		}
	}
	
	sourceNPCNumber = sourceNPCs.Size();
	
	
	if( sourceNPCNumber == 0)
	{
		return;
	}
	
	
	if( useCurrentTargetHPAsBaseline )
	{
		quotaModifier = targetNPC.GetHealthPercents();
	}
	
	
	while( targetNPC.IsAlive() )
	{
		hpSum = 0.0f;
		
		for( i=0; i < sourceNPCNumber ; i+= 1 )
		{
			if( sourceNPCs[i] )
			{
				if( sourceNPCs[i].IsAlive() )
				{
					hpSum += sourceNPCs[i].GetHealthPercents();
				}
			}
		}		
		
		
		if( hpSum == 0.0f )
		{
			if( killOnNoValidSources )
			{
				targetNPC.Kill( 'SyncNPCHealthQuest', true, thePlayer );
			}
			
			return;
		}
		else
		{
			hpSum = ( hpSum / sourceNPCNumber );
			
			
			if( quotaModifier <= 1.0f && quotaModifier > 0.0f )
			{
				hpSum = hpSum * quotaModifier;
			}
			
			targetNPC.SetHealthPerc( hpSum );
		}
		
		Sleep(0.5f);
	}
	
}


quest function ManuallyOpenContainerQuest( containerTag : name )
{
	var container : W3Container;
	
	container = (W3Container) theGame.GetNodeByTag( containerTag );
	
	if( container )
	{
		if( !container.IsEmpty() )
		{
			container.ShowLoot();
		}
	}
}

quest function IsEntityVisibleInCameraFrame( tag : name ) : bool
{
	var actor : CActor;
	
	actor = theGame.GetActorByTag( tag );
	if ( thePlayer.WasVisibleInScaledFrame( actor, 1.f, 1.f ) )
	{
		return true;
	}
	
	return false;
}


quest function DisableWeatherDisplay( disable : bool )
{
	thePlayer.SetWeatherDisplayDisabled( disable );
}


quest function ForceBruxaSpawn( entityTag : name )
{
	var entities : array<CEntity>;
	var entity : CEntity;
	var size, i : int;
	var comp : CDismembermentComponent;

	theGame.GetEntitiesByTag( entityTag, entities );
	size = entities.Size();
	
	for( i=0; i < size; i+= 1 )
	{
		entity = entities[i];
		
		if( entity )
		{
			theGame.GetBehTreeReactionManager().CreateReactionEventIfPossible( entity, 'ForceBruxaSpawn', -1.f , 0.5f, 3.f, -1, false, false, entity.GetWorldPosition() );
		}
	}
}


quest function EnableDismembermentQuest( entityTag : name, dismembermentName : name, enable : bool )
{
	var entities : array<CEntity>;
	var entity : CEntity;
	var size, i : int;
	var comp : CDismembermentComponent;

	theGame.GetEntitiesByTag( entityTag, entities );
	size = entities.Size();
	
	for( i=0; i < size; i+= 1 )
	{
		entity = entities[i];
		
		if( entity )
		{
			comp = (CDismembermentComponent) entity.GetComponentByClassName( 'CDismembermentComponent' );
			
			if( comp )
			{
				if( enable )
				{
					if( comp.IsWoundDefined( dismembermentName ) )
					{
						comp.SetVisibleWound( dismembermentName, true, true, true, true );
					}
				}
				else
				{
					comp.ClearVisibleWound();
				}
			}
			
		}
		
	}
}


quest function EditLeaderBoardQuest( boardTag : name, competitorStringKey : string, points : int )
{
	var boards : array<CEntity>;
	var board : W3LeaderboardCustom;
	var i : int;
	
	theGame.GetEntitiesByTag( boardTag, boards );
	
	if( boards.Size() == 0 )
	{
		return;
	}
	
	if( competitorStringKey == "" )
	{
		return;
	}
	
	for( i = 0; boards.Size() > i; i += 1 )
	{
		board = (W3LeaderboardCustom) boards[i];
		
		if (board)
		{
			board.AddPointToCompetitor( competitorStringKey, points );
		}
	}
}

quest function MandragoraMagicShow( tag : name, side : bool, up : bool )
{
	var entity : CEntity;
	
	entity = theGame.GetEntityByTag( tag );
	
	if ( entity )
	{
		if ( side )
		{
			entity.SetBehaviorVariable( 'side', 1 );
		}
		else
		{
			entity.SetBehaviorVariable( 'side', 0 );
		}
		if ( up )
		{
			entity.SetBehaviorVariable( 'up', 1 );
		}
		else
		{
			entity.SetBehaviorVariable( 'up', 0 );
		}
	}
}


quest function HouseDecorationProcessItemReceivalQuest( decorationEntityTag : name )
{
	var entity : W3HouseDecorationBase;
	
	entity = (W3HouseDecorationBase) theGame.GetEntityByTag( decorationEntityTag );

	if( entity )
	{
		entity.ProcessItemReceival( true );
	}
}


quest function BlockGlobalFastTravelQuest( block : bool )
{
	if( block  )
	{
		thePlayer.BlockAction( EIAB_FastTravelGlobal, 'BlockGlobalFastTravelQuest', true, true );
	}
	else
	{
		thePlayer.UnblockAction( EIAB_FastTravelGlobal, 'BlockGlobalFastTravelQuest' );	
	}
}
quest function CustomShootingRangeCrossbowSetup()
{
	var witcher : W3PlayerWitcher;
	var equipmentSlot : EEquipmentSlots;
	var items : array<SItemUniqueId>;
	var i : int;
	
	witcher = GetWitcherPlayer();
	
	if(witcher && !((W3ReplacerCiri)thePlayer) )
	{
		items = thePlayer.inv.GetItemsByCategory( 'crossbow' );
		
		if( items.Size() > 0 )
		{
			for( i=0; i < items.Size(); i+=1 )
			{
				if( witcher.IsItemEquipped( items[i] ) )
				{
					equipmentSlot = witcher.GetItemSlotByItemName(thePlayer.inv.GetItemName(items[i]));
					
					if(equipmentSlot != EES_InvalidSlot)
					{
						witcher.SelectQuickslotItem(equipmentSlot);
					}
				}
			}
		}
	}
}


latent quest function CustomShootingRangeHandlerQuest( collisionGroupsNames : array<name>, acceptedTags : array<name> )
{

	var cachedCamDirection 	: Vector;
	var cachedCamPosition	: Vector;
	var cachedOwnerPosition	: Vector;

	var traceResultDists		: array<float>;
	var tracePosFromInitial		: Vector;
	var maxRangePos				: Vector;
	
	var traceManager 			: CScriptBatchQueryAccessor;
	
	var i, size					: int;
	var hasResult				: bool;
	var rayCastResult 			: SRaycastHitResult;
	var rayCastResults 			: array<SRaycastHitResult>;	
	var ent						: CEntity;	
	var entityTags				: array<name>;
	var j, tagsSize				: int;
	
	var distanceToPlayer 		: float;
	
	traceManager = theGame.GetWorld().GetTraceManager();
	
	cachedCamDirection = theCamera.GetCameraDirection();
	cachedCamPosition = theCamera.GetCameraPosition();
	cachedOwnerPosition = thePlayer.GetWorldPosition();
	tracePosFromInitial = 0.5f * VecNormalize( cachedCamDirection ) + cachedCamPosition;
	maxRangePos = VecNormalize( cachedCamDirection ) * theGame.params.MAX_THROW_RANGE + tracePosFromInitial;

	tagsSize = acceptedTags.Size();

		if ( traceManager.RayCastSync( tracePosFromInitial, maxRangePos , rayCastResults, collisionGroupsNames ) )		
		{		
			size =  rayCastResults.Size();
			if ( size > 0 )
			{	
				
				for ( i = 0; i < rayCastResults.Size(); i += 1 )
				{
					ent = rayCastResults[i].component.GetEntity();
					
					if(ent)
					{
						
						for( j=0; j < tagsSize; j+=1 )
						{
							if( ent.HasTag( acceptedTags[j] ) )
							{
								distanceToPlayer = VecDistance2D( thePlayer.GetWorldPosition(), ent.GetWorldPosition() );
								
								if( distanceToPlayer > 0 )
								{
									Sleep( distanceToPlayer * 0.02f );
								}
								
								if( FactsQuerySum( "shooting_range_"+acceptedTags[j]+"_was_hit" ) == 0 )
								{
									FactsAdd( "shooting_range_"+acceptedTags[j]+"_was_hit", 1, -1 );
								}
								
								return;
							}
							
						}
						
					}
					
				}
			}
		}
}

quest function ShowEP2Logo_Q( show : bool, fadeInterval : float, x : int, y : int )
{
	var overlayPopupRef : CR4OverlayPopup;
	
	overlayPopupRef = (CR4OverlayPopup) theGame.GetGuiManager().GetPopup('OverlayPopup');
	if ( overlayPopupRef )
	{
		overlayPopupRef.ShowEP2Logo( show, fadeInterval, x, y );
	}
}

exec function dupa( tag : name, side : bool, up : bool )
{
	var entity : CEntity;
	
	entity = theGame.GetEntityByTag( tag );
	
	if ( entity )
	{
		if ( side )
		{
			entity.SetBehaviorVariable( 'side', 1 );
		}
		else
		{
			entity.SetBehaviorVariable( 'side', 0 );
		}
		if ( up )
		{
			entity.SetBehaviorVariable( 'up', 1 );
		}
		else
		{
			entity.SetBehaviorVariable( 'up', 0 );
		}
	}
}

exec function walk( f : float )
{
	var entity : CEntity;
	
	entity = thePlayer.GetTarget();
	
	if ( entity )
	{
		entity.SetBehaviorVariable( 'Editor_MoveSpeed', f );
	}
}



quest function VibrateMedallion( activate : bool, vibrateController : bool, optional vibrateStrength : EQuestPadVibrationStrength, optional vibrateDuration : float )
{
	var hud : CR4ScriptedHud;
	var hudWolfHeadModule : CR4HudModuleWolfHead;	
	var wolfActivation : CScriptedFlashFunction;

	hud = (CR4ScriptedHud)theGame.GetHud();
	if ( hud )
	{
		hudWolfHeadModule = (CR4HudModuleWolfHead)hud.GetHudModule( "WolfHeadModule" );		
		wolfActivation = hudWolfHeadModule.GetWolfActivator();
		wolfActivation.InvokeSelfOneArg( FlashArgBool( activate ) );		
		
		if(vibrateController)
		{
			switch(vibrateStrength)
			{
				case EQPVS_VeryLight:
					theGame.VibrateControllerVeryLight(vibrateDuration);
					return;
				case EQPVS_Light:
					theGame.VibrateControllerLight(vibrateDuration);
					return;
				case EQPVS_Hard:
					theGame.VibrateControllerHard(vibrateDuration);
					return;
				case EQPVS_VeryHard:
					theGame.VibrateControllerVeryHard(vibrateDuration);
					return;
				default:
					return;
			}
		}
	}
}


quest function IsCurrentlyUsingController() : bool
{
	return !theInput.LastUsedPCInput();
}


quest function IsCurrentlyUsingAlternateSignCasting() : bool
{
	return thePlayer.GetInputHandler().GetIsAltSignCasting();
}


latent quest function AddAndReadBook(bookName : name, optional addToInventoryFirst : bool)
{
	var m_bookPopupData : BookPopupFeedback;
	var playerInv    	: CInventoryComponent;
	var itemId 			: SItemUniqueId;
	var i : int;
	
	if(IsNameValid(bookName))
	{
		playerInv = thePlayer.inv;
		
		if(addToInventoryFirst)
		{
			playerInv.AddAnItem(bookName, 1, true, true);
		}		
		
		itemId = playerInv.GetItemId(bookName);

		if ( playerInv.IsIdValid(itemId) )
		{
			m_bookPopupData = new BookPopupFeedback in thePlayer;
			m_bookPopupData.SetMessageTitle( GetLocStringByKeyExt(playerInv.GetItemLocalizedNameByUniqueID(itemId)) );
			m_bookPopupData.SetMessageText( playerInv.GetBookText(itemId) );
			m_bookPopupData.curInventory = thePlayer.GetInventory();
			m_bookPopupData.PauseGame = true;
			m_bookPopupData.singleBookMode = true;
			m_bookPopupData.bookItemId = itemId;
			
			thePlayer.inv.ReadBookByName( bookName, false, true );
			
			theGame.RequestMenu('PopupMenu', m_bookPopupData);
			
			
			while ( i < 30 || theGame.IsPausedForReason("Popup") || theGame.GetGuiManager().IsAnyMenu() )
			{
				i += 1;
				SleepOneFrame();
			}
			delete m_bookPopupData;
		}
	}
}


quest function IsCiriDLCAppearance() : bool
{
	var ciri : CActor;
	var appearance : string;

	ciri = theGame.GetActorByTag( 'ciri' );
	appearance = NameToString( ciri.GetAppearance() );
	
	if( StrEndsWith( appearance, "_dlc" ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}


quest function PlayerDrinkPotionQuest( itemName : name )
{
	var ids : array<SItemUniqueId>;
	
	if(IsNameValid(itemName))
	{
		ids = thePlayer.inv.AddAnItem(itemName, 1);
		if(ids.Size() > 0)
		{
			GetWitcherPlayer().DrinkPreparedPotion( EES_Potion1, ids[0] );
		}
	}
}


quest function IsPlatformPC() : bool
{
	if(theGame.GetPlatform() == Platform_PC)
		return true;
	else
		return false;
}


quest function IsPlatformPlaystation() : bool
{
	if(theGame.GetPlatform() == Platform_PS4 || theGame.GetPlatform() == Platform_PS5)
		return true;
	else
		return false;
}


quest function IsActorHPAboveX(tag : CName, health : int) : bool
{
	var actor : CActor;

	actor = theGame.GetActorByTag( tag );
	
	if(actor)
	{
		if(actor.GetHealthPercents()*100 > health)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	return false;
}


quest function UpscaleNPCLevel( npcTag : name, levelFromPlayer : int )
{
	var npc : CNewNPC;
	var playerLevel : int;
	
	npc = theGame.GetNPCByTag ( npcTag );
	
	if ( npc )
	{
		playerLevel = thePlayer.GetLevel();
		npc.SetLevel( playerLevel + levelFromPlayer );
	}
}


quest function UpscaleNPCHealth( npcTag : name, statType : EBaseCharacterStats )
{
	var npc : CNewNPC;
	var playerLevel : float;
	var addedHP : float;
	
	npc = theGame.GetNPCByTag ( npcTag );
	
	if ( npc )
	{
		playerLevel = (float)thePlayer.GetLevel();
		addedHP = 200.0 * playerLevel;
		npc.abilityManager.SetStatPointMax(statType, npc.GetMaxHealth() + addedHP );
		npc.SetHealth(npc.GetMaxHealth());
	}
}


quest function WasMonsterNestDestroyed( tag : name ) : bool
{
	var nest : CMonsterNestEntity;
	
	nest = (CMonsterNestEntity)theGame.GetEntityByTag( tag );
	
	if ( nest )
	{
		return nest.wasExploded;
	}
	
	return false;
}


quest function ApplyFractureQuest( tag : name )
{
	var comp : CDestructionSystemComponent;
	var ent : CEntity;
	
	ent = theGame.GetEntityByTag( tag );	
	comp = (CDestructionSystemComponent)ent.GetComponentByClassName('CDestructionSystemComponent');
	
	if ( comp )
	{
		comp.ApplyFracture();
	}
}


quest function IsPlayerDoingSpecialAttack(heavy : bool) : bool
{
	return thePlayer.IsDoingSpecialAttack(heavy);
}


quest function EredinForceCounter()
{
	var eredin : CNewNPC;

	eredin = (CNewNPC)( theGame.GetActorByTag( 'eredin' ) );
	if( eredin )
	{
		eredin.SignalGameplayEvent( 'Counter' );
	}
}


quest function IsUsingSSD() : bool
{
	return theGame.GetDriveType() == DT_SSD;
}


quest function ScaleComponentsQuest ( tag : name, componentNames : array<string>)
{
	var entity    : CEntity;
	var component : CComponent;
	var i 		  : int;
	
	entity = theGame.GetEntityByTag( tag );

	if(entity)
	{	
		for(i=0;i<componentNames.Size();i+=1)
		{
			component = entity.GetComponent( componentNames[i] );
			component.SetScale( Vector(0,0,0) );
		}
	}
}


quest function CanGeraltUseUndyingSkill() : bool
{
	var witcher : W3PlayerWitcher;
	var healingFactor : float;
	
	witcher = GetWitcherPlayer(); 
	
	if(!witcher.GetCannotUseUndying() && FloorF(witcher.GetStat(BCS_Focus)) >= 1 && witcher.CanUseSkill(S_Sword_s18) && witcher.HasBuff(EET_BattleTrance) )
	{
		healingFactor = CalculateAttributeValue( witcher.GetSkillAttributeValue(S_Sword_s18, 'healing_factor', false, true) );
		healingFactor *= witcher.GetStatMax(BCS_Vitality);
		healingFactor *= witcher.GetStat(BCS_Focus);
		healingFactor *= 1 + CalculateAttributeValue( witcher.GetSkillAttributeValue(S_Sword_s18, 'healing_bonus', false, true) ) * (witcher.GetSkillLevel(S_Sword_s18) - 1);
		witcher.ForceSetStat(BCS_Vitality, witcher.GetStatMax(BCS_Vitality));
		witcher.DrainFocus(witcher.GetStat(BCS_Focus));
		witcher.RemoveBuff(EET_BattleTrance);
		witcher.SetCannotUseUndyingSkill(true);
		witcher.AddTimer('UndyingSkillCooldown', CalculateAttributeValue( witcher.GetSkillAttributeValue(S_Sword_s18, 'trigger_delay', false, true) ), false, , , true);

		return true;
	}

	return false;
}


quest function NGE_SwapNetflixHelmet()
{
	var entity    : CEntity;
	var component : CComponent;
	
	if( !theGame.GetDLCManager().IsDLCEnabled('dlc_020_001') )
		return;
	
	entity = theGame.GetEntityByTag( 'q001_nightmare_netflix_helmet' );

	if(entity)
	{	
		component = entity.GetComponent( "c_03_mb__nilfgaard_knight" );
		component.SetScale( Vector(0,0,0) );
		
		component = entity.GetComponent( "c_05_mb__nilfgaard_knight" );
		component.SetScale( Vector(0,0,0) );
	
		component = entity.GetComponent( "netflix_helmet" );
		component.SetScale( Vector(1.26,1.26,1.26) );
	}
}


quest function NGE_RepairItems(itemName : name)
{
	var inv : CInventoryComponent;
	var itemMaxDurablity : float;
	var items : array<SItemUniqueId>;
	var i : int;
	
	inv = thePlayer.GetInventory();
	if(!inv)
		return;
		
	items = inv.GetItemsByName(itemName);
		
	for(i=0;i<items.Size();i+=1)
	{
		if(!inv.IsIdValid(items[i]))
			continue;
		
		itemMaxDurablity = inv.GetItemMaxDurability(items[i]);
		inv.SetItemDurabilityScript ( items[i], itemMaxDurablity );
	}
}


quest function NGE_NPCDisableLookat(npcTag : name, disableLookats : bool)
{
	var i : int;
	var npcs : array <CNewNPC>;
	
	theGame.GetNPCsByTag ( npcTag, npcs );
	
	for ( i=0; i<npcs.Size(); i+=1 )
	{
		if ( npcs[i] )
		{
			npcs[i].disableConstrainLookat = disableLookats;			
		}
	}
}


quest function NGE_FinisherEnd()
{
	thePlayer.OnFinisherEnd();
}


quest function NGE_NPCAnimationMultiplier(npcTag : name, multiplier : float)
{
	var i : int;
	var npcs : array <CNewNPC>;
	
	theGame.GetNPCsByTag ( npcTag, npcs );
	
	for ( i=0; i<npcs.Size(); i+=1 )
	{
		if ( npcs[i] )
		{
			npcs[i].SetAnimationTimeMultiplier(multiplier);		
		}
	}
}