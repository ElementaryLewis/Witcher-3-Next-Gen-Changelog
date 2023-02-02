/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/



class W3QuestCond_IsItemQuantityMet_GlobalListener extends IGlobalEventScriptedListener
{
	public var condition : W3QuestCond_IsItemQuantityMet;
	
	event OnGlobalEventName( eventCategory : EGlobalEventCategory, eventType : EGlobalEventType, eventParam : name )
	{
		if ( condition && eventParam == condition.entityTag )
		{
			condition.FindInventory();	
		}
	}
}

class W3QuestCond_IsItemQuantityMet_InventoryListener extends IInventoryScriptedListener
{
	public var condition : W3QuestCond_IsItemQuantityMet;
	
	event OnInventoryScriptedEvent( eventType : EInventoryEventType, itemId : SItemUniqueId, quantity : int, fromAssociatedInventory : bool )
	{
		if ( condition )
		{
			condition.EvaluateImpl();
		}
	}
}

class W3QuestCond_IsItemQuantityMet extends CQuestScriptedCondition
{
	editable var itemName	 : name;
	editable var entityTag	 : name;
	editable var itemTag	 : name;
	editable var itemCategory	 : name;
	editable var comparator : ECompareOp;
	editable var count 		: int;
	default count = 1;
	editable var includeHorseInventory : bool;
	default includeHorseInventory = true;
	editable var ignoreTags	: array< name >;
	
	var inventory			: CInventoryComponent;
	saved var isFulfilled	: bool;
	var isTrophy			: bool;
	var globalListener		: W3QuestCond_IsItemQuantityMet_GlobalListener;
	var inventoryListener	: W3QuestCond_IsItemQuantityMet_InventoryListener;
	
	function RegisterGlobalListener( flag : bool )
	{
		
		if(!IsNameValid(entityTag))
			entityTag = 'PLAYER';
	
		if ( flag )
		{
			globalListener = new W3QuestCond_IsItemQuantityMet_GlobalListener in this;
			globalListener.condition = this;
			theGame.GetGlobalEventsManager().AddListenerFilterName( GEC_Tag, globalListener, entityTag );
			FindInventory();
		}
		else
		{
			theGame.GetGlobalEventsManager().RemoveListenerFilterName( GEC_Tag, globalListener, entityTag );
			delete globalListener;
			globalListener = NULL;
		}
	}
	
	function RegisterInventoryListener( flag : bool )
	{
		if ( flag )
		{
			inventoryListener = new W3QuestCond_IsItemQuantityMet_InventoryListener in this;
			inventoryListener.condition = this;
			inventory.AddListener( inventoryListener );		
		}
		else
		{
			inventory.RemoveListener( inventoryListener );
			delete inventoryListener;
			inventoryListener = NULL;
		}
	}
	
	function Activate()
	{	
		isFulfilled = false;
		inventory = NULL;
		FindInventory();
		if ( !inventory )
		{
			RegisterGlobalListener( true );
		}
		else
		{
			EvaluateImpl();
			if ( !isFulfilled )
			{
				RegisterInventoryListener( true );
			}
		}
	}
	
	function Deactivate()
	{
		if ( globalListener )
		{
			RegisterGlobalListener( false );
		}
		if ( inventory && inventoryListener )
		{
			RegisterInventoryListener( false );
		}
		else if ( inventoryListener )
		{
			delete inventoryListener;
			inventoryListener = NULL;
		}
		inventory = NULL;
	}

	function Evaluate() : bool
	{
		if ( !isFulfilled && !inventory && !globalListener )
		{
			RegisterGlobalListener( true );
		}
		if ( isFulfilled && isTrophy )
		{
			if ( theGame.GetGuiManager().GetPopup('LootPopup'))
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		else
		{
			return isFulfilled;
		}
	}

	function EvaluateImpl()
	{
		var itemQuantity, i : int;
		var itemID :  SItemUniqueId;
		var horseInv : CInventoryComponent;
		var witcher : W3PlayerWitcher;
				
		if ( isFulfilled )
		{
			return;
		}

		if ( inventory )
		{
			if ( itemName != 'None' )
			{
				itemQuantity = inventory.GetItemQuantityByName( itemName, includeHorseInventory, ignoreTags );
			}
			else if ( itemCategory != 'None' )
			{
				itemQuantity = inventory.GetItemQuantityByCategory( itemCategory, includeHorseInventory, ignoreTags );
			}
			else if( IsNameValid(itemTag) )
			{
				itemQuantity = inventory.GetItemQuantityByTag( itemTag, includeHorseInventory, ignoreTags );
			}
			else	
			{
				itemQuantity = inventory.GetAllItemsQuantity( includeHorseInventory, ignoreTags );
			}
			
			itemID = inventory.GetItemId( itemName );
			if ( itemCategory == 'trophy' || itemTag == 'Trophy' ||  itemTag == 'HorseTrophy' || inventory.IsItemTrophy( itemID ) )
			{
				isTrophy = true;
			}
			isFulfilled = ProcessCompare( comparator, itemQuantity, count );
		}
		else
		{
			LogQuest( "W3QuestCond_IsItemQuantityMet: iventory can't be NULL inside EvaluateImpl" );
		}
		
		if ( isFulfilled && inventory && inventoryListener )
		{
			RegisterInventoryListener( false );
		}		
	}
	
	function FindInventory()
	{
		var gameplayEntity : CGameplayEntity;
	
		if ( inventory )
		{
			return;
		}
	
		if ( IsNameValid(entityTag) )
		{
			gameplayEntity = (CGameplayEntity)theGame.GetEntityByTag( entityTag );
		}
		else
		{
			gameplayEntity = thePlayer;
		}

		if ( gameplayEntity )
		{
			inventory = gameplayEntity.GetInventory();
		}
		if ( inventory )
		{
			if ( globalListener )
			{
				RegisterGlobalListener( false );
			}
			EvaluateImpl();
			if ( !isFulfilled )
			{
				RegisterInventoryListener( true );				
			}
		}
	}
}
