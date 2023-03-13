/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/







class W3HorseManager extends CPeristentEntity
{
	private autobind inv : CInventoryComponent = single;		
	private saved var horseAbilities : array<name>;				
	private saved var itemSlots : array<SItemUniqueId>;			
	private saved var wasSpawned : bool;						
	private saved var horseMode : EHorseMode;					
	
	default wasSpawned = false;
	
	public function OnCreated()
	{
		itemSlots.Grow(EnumGetMax('EEquipmentSlots')+1);
		
		Debug_TraceInventories( "OnCreated" );
	}
	
	public function GetInventoryComponent() : CInventoryComponent
	{
		return inv;
	}
	
	
	public function GetHorseMode() : EHorseMode
	{
		return horseMode;
	}
	
	
	
	
	public final function GetShouldHideAllItems() : bool
	{
		return horseMode == EHM_Unicorn;
	}
	
	private final function GetAppearanceName() : name
	{
		var worldName : String;
		var isOnBobLevel : bool;
		
		worldName =  theGame.GetWorld().GetDepotPath();
		if( StrFindFirst( worldName, "bob" ) < 0 )
			isOnBobLevel = false;
		else
			isOnBobLevel = true; 
	
		if( horseMode == EHM_Unicorn )
		{
			return 'unicorn_wild_01';
		}
		else if( horseMode == EHM_Devil )
		{
			if( isOnBobLevel )
				return 'player_horse_with_devil_saddle_mimics';
			else
				return 'player_horse_with_devil_saddle';
		}		
		else if( FactsQuerySum( "q110_geralt_refused_pay" ) > 0 ) 
		{
			if( isOnBobLevel )
				return 'player_horse_after_q110_mimics';
			else
				return 'player_horse_after_q110';
		}	
		else
		{
			if( isOnBobLevel )
				return 'player_horse_mimics';
			else
				return 'player_horse';
		}
	}	
	
	public function SetHorseMode( m : EHorseMode )
	{
		var horse : CNewNPC;		
		
		
		if( horseMode == EHM_Unicorn && m == EHM_Devil )
		{
			return;
		}
		
		horse = thePlayer.GetHorseWithInventory();
		
		
		if( horse && horseMode == EHM_Devil && m != horseMode )
		{
			horse.RemoveBuff( EET_WeakeningAura, true );
			horse.StopEffect( 'demon_horse' );
		}
		
		horseMode = m;
		
		
		if( horse )
		{
			if( horseMode == EHM_Devil )
			{
				horse.PlayEffectSingle( 'demon_horse' );
				if( !horse.HasBuff( EET_WeakeningAura ) )
					horse.AddEffectDefault( EET_WeakeningAura, horse, 'horse saddle', false );
			}
			
			horse.AddTimer( 'SetShowAllHorseItems', 0.3f );
			
			
			horse.ApplyAppearance( GetAppearanceName() );
		}
	}
		
	
	public function ApplyHorseUpdateOnSpawn() : bool
	{
		var ids, items 		: array<SItemUniqueId>;
		var eqId  			: SItemUniqueId;
		var i 				: int;
		var horseInv 		: CInventoryComponent;
		var horse			: CNewNPC;
		var itemName		: name;
		var devilSaddle		: bool; 
		var tempItems		: array<SItemUniqueId>; 
		
		horse = thePlayer.GetHorseWithInventory();
		if( !horse )
		{
			return false;
		}
		
		horseInv = horse.GetInventory();
		
		if( !horseInv )
		{
			return false;
		}
		
		horseInv.GetAllItems(items);
		
		Debug_TraceInventories( "ApplyHorseUpdateOnSpawn ] BEFORE" );
		
		
		if (!wasSpawned)
		{
			for(i=items.Size()-1; i>=0; i-=1)
			{
				if ( horseInv.ItemHasTag(items[i], 'HorseTail') || horseInv.ItemHasTag(items[i], 'HorseReins') || horseInv.GetItemCategory( items[i] ) == 'horse_hair' )
				{
					continue;
				}
				eqId = horseInv.GiveItemTo(inv, items[i], 1, false);
				EquipItem(eqId);
			}
			wasSpawned = true;
		}
		
		devilSaddle = horseInv.HasItem( 'Devil Saddle' );
		
		
		for(i=items.Size()-1; i>=0; i-=1)
		{
			
			itemName = horseInv.GetItemName(items[i]);
			if( horseInv.ItemHasTag(items[i], 'HorseReins') || itemName == 'mon_horse_weapon' )
			{
				continue;
			}
			else if (devilSaddle && horseInv.ItemHasTag(items[i], 'HorseTail'))			
			{
				continue;
			}
			else if (devilSaddle && horseInv.GetItemCategory( items[i] ) == 'horse_hair' || itemName == 'Horse Saddle 0')			
			{
				horseInv.UnmountItem( items[i] );
				continue;
			}
			
			
			
			horseInv.RemoveItem(items[i]);
		}
		
		
		if( !horseInv.HasItem( 'Horse Hair 0' ) )
		{
			tempItems = horseInv.AddAnItem( 'Horse Hair 0' );
			horseInv.MountItem( tempItems[0] );
		}
		
		if( !horseInv.HasItem( 'Horse Universal Reins' ) )
		{
			tempItems = horseInv.AddAnItem( 'Horse Universal Reins' );
			horseInv.MountItem( tempItems[0] );
		}
		
		if( !horseInv.HasItem( 'Horse apex tail' ) )
		{
			tempItems = horseInv.AddAnItem( 'Horse apex tail' );
			horseInv.MountItem( tempItems[0] );
		}
		
		
		
		for( i = 0; i < itemSlots.Size(); i += 1 )
		{
			if( inv.IsIdValid( itemSlots[i] ) )
			{
				itemName = inv.GetItemName( itemSlots[i] );
				ids = horseInv.AddAnItem( itemName );
				horseInv.MountItem( ids[0] );
			}
		}
	
		
		horseAbilities.Clear();
		horse.GetCharacterStats().GetAbilities(horseAbilities, true);
		
		
		if( GetWitcherPlayer().HasBuff( EET_HorseStableBuff ) && !horse.HasAbility( 'HorseStableBuff', false ) )
		{
			horse.AddAbility( 'HorseStableBuff' );
		}
		else if( !GetWitcherPlayer().HasBuff( EET_HorseStableBuff ) && horse.HasAbility( 'HorseStableBuff', false ) )
		{
			horse.RemoveAbility( 'HorseStableBuff' );
		}
		
		ReenableMountHorseInteraction( horse );
		
		
		if( horseMode == EHM_NotSet )
		{
			if( horseInv.HasItem( 'Devil Saddle' ) )
			{
				horseMode = EHM_Devil;
			}
			else
			{
				horseMode = EHM_Normal;
			}
		}
		
		
		SetHorseMode( horseMode );

		Debug_TraceInventories( "ApplyHorseUpdateOnSpawn ] AFTER" );
				
		return true;
	}
	
	public function ReenableMountHorseInteraction( horse : CNewNPC )
	{
		var components : array< CComponent >;
		var ic : CInteractionComponent;
		var hc : W3HorseComponent;
		var i : int;

		if ( horse )
		{
			hc = horse.GetHorseComponent();
			if ( hc && !hc.GetUser() ) 
			{
				components = horse.GetComponentsByClassName( 'CInteractionComponent' );
				for ( i = 0; i < components.Size(); i += 1 )
				{
					ic = ( CInteractionComponent )components[ i ];
					if ( ic && ic.GetActionName() == "MountHorse" )
					{
						if ( !ic.IsEnabled() )
						{
							ic.SetEnabled( true );
						}
						return;
					}
				}
			}
		}
	}
	
	public function IsItemEquipped(id : SItemUniqueId) : bool
	{
		return itemSlots.Contains(id);
	}
	
	public function IsItemEquippedByName( itemName : name ) : bool
	{
		var i : int;
		
		for( i=0; i<itemSlots.Size(); i+=1 )
		{
			if( inv.GetItemName( itemSlots[i] ) == itemName )
			{
				return true;
			}
		}
		
		return false;
	}
	
	public function GetItemInSlot( slot : EEquipmentSlots ) : SItemUniqueId
	{
		if(slot == EES_InvalidSlot)
			return GetInvalidUniqueId();
		else
			return itemSlots[slot];
	}
	
	public function GetHorseAttributeValue(attributeName : name, excludeItems : bool) : SAbilityAttributeValue
	{
		var i : int;
		var dm : CDefinitionsManagerAccessor;
		var min, max, val : SAbilityAttributeValue;
	
		
		if(horseAbilities.Size() == 0)
		{
			if(thePlayer.GetHorseWithInventory())
			{
				thePlayer.GetHorseWithInventory().GetCharacterStats().GetAbilities(horseAbilities,true);
			}
			else if(!excludeItems)
			{
				
				for(i=0; i<itemSlots.Size(); i+=1)
				{
					if(itemSlots[i] != GetInvalidUniqueId())
					{
						val += inv.GetItemAttributeValue(itemSlots[i], attributeName);
					}
				}
				
				return val;
			}
		}
		
		dm = theGame.GetDefinitionsManager();
		
		for(i=0; i<horseAbilities.Size(); i+=1)
		{
			dm.GetAbilityAttributeValue(horseAbilities[i], attributeName, min, max);
			val += GetAttributeRandomizedValue(min, max);
		}
		
		
		if(excludeItems)
		{
			for(i=0; i<itemSlots.Size(); i+=1)
			{
				if(itemSlots[i] != GetInvalidUniqueId())
				{
					val -= inv.GetItemAttributeValue(itemSlots[i], attributeName);
				}
			}
		}
		
		return val;
	}
	
	public function EquipItem(id : SItemUniqueId) : SItemUniqueId
	{
		var horse    : CActor;
		var ids      : array<SItemUniqueId>;
		var slot     : EEquipmentSlots;
		var itemName : name;
		var resMount, usePerk : bool;
		var abls	 : array<name>;
		var i		 : int;
		var unequippedItem : SItemUniqueId;
		var itemNameUnequip : name;
		
		
		var horseHairs : array<SItemUniqueId>;
		var horseInv : CInventoryComponent;
	
		
		if(!inv.IsIdValid(id))
			return GetInvalidUniqueId();
			
		
		slot = GetHorseSlotForItem(id);
		if(slot == EES_InvalidSlot)
			return GetInvalidUniqueId();
		
		Debug_TraceInventories( "EquipItem ] " + inv.GetItemName( id ) + " - BEFORE" );
		
		
		if(inv.IsIdValid(itemSlots[slot]))
		{
			itemNameUnequip = inv.GetItemName(itemSlots[slot]);
			unequippedItem = UnequipItem(slot);
		}
			
		
		itemSlots[slot] = id;
		horse = thePlayer.GetHorseWithInventory();
		horseInv = horse.GetInventory(); 
		if(horse)
		{
			itemName = inv.GetItemName(id);
			ids = horseInv.AddAnItem(itemName); 
			resMount = horseInv.MountItem(ids[0]); 
			if (resMount)
			{
				horseInv.GetItemAbilities(ids[0], abls); 
				for (i=0; i < abls.Size(); i+=1)
					horseAbilities.PushBack(abls[i]);
			}
			
			if ( itemNameUnequip == 'Devil Saddle' && horseMode != EHM_Unicorn)
			{
				SetHorseMode( EHM_Normal );				
			}
			
			if ( itemName == 'Devil Saddle' ) 
			{
				SetHorseMode( EHM_Devil );		
				
				horseHairs = horseInv.GetItemsByName('Horse Hair 0');
				for(i=0;i<horseHairs.Size();i+=1)
				{
					horseInv.UnmountItem(horseHairs[i]);
				}
				
			}
		}
		else
		{
			inv.GetItemAbilities(id, abls);
			for (i=0; i < abls.Size(); i+=1)
				horseAbilities.PushBack(abls[i]);
			SetHorseMode( EHM_NotSet );
		}
		
		
		if ( slot == EES_HorseTrophy )
		{
			abls.Clear();
			inv.GetItemAbilities(id, abls);
			for (i=0; i < abls.Size(); i += 1)
			{
				if ( abls[i] == 'base_trophy_stats' )
					continue;

				thePlayer.AddAbility(abls[i]);
			}
		}
		
		
		theGame.GetGlobalEventsManager().OnScriptedEvent( SEC_OnItemEquipped );
		
		if(inv.IsItemHorseBag(id))
			GetWitcherPlayer().UpdateEncumbrance();
		
		Debug_TraceInventories( "EquipItem ] " + inv.GetItemName( id ) + " - AFTER" );
		
		
		
		if( horse )
		{
			horse.AddTimer( 'SetShowAllHorseItems', 0.0f );
		}
		
		return unequippedItem;
	}
	
	public function AddAbility(abilityName : name)
	{
		var horse : CNewNPC;
		
		horse = thePlayer.GetHorseWithInventory();
		if(horse)
		{
			horse.AddAbility(abilityName, true);
		}
		
		horseAbilities.PushBack(abilityName);
	}
	
	public function UnequipItem(slot : EEquipmentSlots) : SItemUniqueId
	{
		var itemName : name;
		var horse : CActor;
		var ids : array<SItemUniqueId>;
		var abls : array<name>;
		var i : int;
		var usePerk : bool;
		var oldItem : SItemUniqueId;
		var newId : SItemUniqueId;
		
		var horseInv : CInventoryComponent; 
		var horseHairs : array<SItemUniqueId>; 
	
		
		if(slot == EES_InvalidSlot)
			return GetInvalidUniqueId();
			
		
		if(!inv.IsIdValid(itemSlots[slot]))
			return GetInvalidUniqueId();
			
		oldItem = itemSlots[slot];
			
		
		if ( slot == EES_HorseTrophy )
		{
			inv.GetItemAbilities(oldItem, abls);
			for (i=0; i < abls.Size(); i += 1)
			{
				if ( abls[i] == 'base_trophy_stats' )
					continue;
				
				thePlayer.RemoveAbility(abls[i]);
			}
		}
			
		
		if(inv.IsItemHorseBag( itemSlots[slot] ))
			GetWitcherPlayer().UpdateEncumbrance();
		
		itemName = inv.GetItemName(itemSlots[slot]);
		itemSlots[slot] = GetInvalidUniqueId();
		horse = thePlayer.GetHorseWithInventory();
		horseInv = horse.GetInventory(); 
		
		Debug_TraceInventories( "UnequipItem ] " + itemName + " - BEFORE" );
		
		if ( itemName == 'Devil Saddle' && horseMode == EHM_Devil) 
		{
			SetHorseMode( EHM_Normal );	
			
			horseHairs = horseInv.GetItemsByName('Horse Hair 0');
			for(i=0;i<horseHairs.Size();i+=1)
			{
				horseInv.MountItem(horseHairs[i]);
			}
			
		}
		
		
		if( horse )
		{
			ids = horseInv.GetItemsByName( itemName ); 	
			horseInv.UnmountItem( ids[ 0 ] );			
			horseInv.RemoveItem( ids[ 0 ] );			
		}
		
		
		abls.Clear();
		ids = inv.GetItemsByName( itemName );
		inv.GetItemAbilities( ids[ 0 ], abls );
		for( i = 0; i < abls.Size(); i += 1 )
		{
			horseAbilities.Remove( abls[ i ] );
		}
		
		
		newId = inv.GiveItemTo(thePlayer.inv, oldItem, 1, false, true, false);

		
		theGame.GetGlobalEventsManager().OnScriptedEvent( SEC_OnItemEquipped );
		
		Debug_TraceInventories( "UnequipItem ] " + itemName + " - AFTER" );

		return newId;
	}
	
	public function Debug_TraceInventory( inventory : CInventoryComponent, optional categoryName : name )
	{
		var i : int;
		var itemsNames : array< name >;
		var items : array< SItemUniqueId >;
		if( categoryName == '' )
		{
			itemsNames = inventory.GetItemsNames();
			for( i = 0; i < itemsNames.Size(); i+=1 )
			{
				LogChannel( 'Dbg_HorseInv', itemsNames[ i ] );
			}
		}
		else
		{
			items = inventory.GetItemsByCategory( categoryName );
			for( i = 0; i < items.Size(); i+=1 )
			{
				LogChannel( 'Dbg_HorseInv', inventory.GetItemName( items[ i ] ) );
			}
		}
	}
	
	public function Debug_TraceInventories( optional heading : string )
	{
		
		return; 
		
	
		if( heading != "" )
		{
			LogChannel( 'Dbg_HorseInv', "----------------------------------] " + heading );
		}
	
		if( thePlayer && thePlayer.GetHorseWithInventory() )
		{
			LogChannel( 'Dbg_HorseInv', "] Entity Inventory" );
			LogChannel( 'Dbg_HorseInv', "----------------------------------" );
			
			Debug_TraceInventory( thePlayer.GetHorseWithInventory().GetInventory() );
			
			
			LogChannel( 'Dbg_HorseInv', "" );
		}
		
		if( inv )
		{
			LogChannel( 'Dbg_HorseInv', "] Manager Inventory" );
			LogChannel( 'Dbg_HorseInv', "----------------------------------" );
			
			Debug_TraceInventory( inv );
			
			
			LogChannel( 'Dbg_HorseInv', "" );
		}
	}
	
	public function MoveItemToHorse(id : SItemUniqueId, optional quantity : int) : SItemUniqueId
	{
		return thePlayer.inv.GiveItemTo(inv, id, quantity, false, true, false);
	}
	
	public function MoveItemFromHorse(id : SItemUniqueId, optional quantity : int) : SItemUniqueId
	{
		return inv.GiveItemTo(thePlayer.inv, id, quantity, false, true, false);
	}
	
	public function GetHorseSlotForItem(id : SItemUniqueId) : EEquipmentSlots
	{
		return inv.GetHorseSlotForItem(id);
	}
	
		
	public final function HorseRemoveItemByName(itemName : name, quantity : int)
	{
		var ids : array<SItemUniqueId>;
		var slot : EEquipmentSlots;
		
		ids = inv.GetItemsIds(itemName);
		slot = GetHorseSlotForItem(ids[0]);
		UnequipItem(slot);
		
		inv.RemoveItemByName(itemName, quantity);
	}
	
	
	public final function HorseRemoveItemByCategory(itemCategory : name, quantity : int)
	{
		var ids : array<SItemUniqueId>;
		var slot : EEquipmentSlots;
		
		Debug_TraceInventories( "HorseRemoveItemByCategory ] " + itemCategory + " - BEFORE" );
		
		ids = inv.GetItemsByCategory(itemCategory);
		slot = GetHorseSlotForItem(ids[0]);
		UnequipItem(slot);
		
		inv.RemoveItemByCategory(itemCategory, quantity);
		
		Debug_TraceInventories( "HorseRemoveItemByCategory ] " + itemCategory + " - AFTER" );
	}
	
	
	public final function HorseRemoveItemByTag(itemTag : name, quantity : int)
	{
		var ids : array<SItemUniqueId>;
		var slot : EEquipmentSlots;
		
		Debug_TraceInventories( "HorseRemoveItemByTag ] " + itemTag + " - BEFORE" );
		
		ids = inv.GetItemsByTag(itemTag);
		slot = GetHorseSlotForItem(ids[0]);
		UnequipItem(slot);
		
		inv.RemoveItemByTag(itemTag, quantity);
		
		Debug_TraceInventories( "HorseRemoveItemByTag ] " + itemTag + " - AFTER" );
	}
	
	public function RemoveAllItems()
	{
		var playerInvId : SItemUniqueId;
		
		playerInvId = UnequipItem(EES_HorseBlinders);
		thePlayer.inv.RemoveItem(playerInvId);
		playerInvId = UnequipItem(EES_HorseSaddle);
		thePlayer.inv.RemoveItem(playerInvId);
		playerInvId = UnequipItem(EES_HorseBag);
		thePlayer.inv.RemoveItem(playerInvId);
		playerInvId = UnequipItem(EES_HorseTrophy);
		thePlayer.inv.RemoveItem(playerInvId);
	}
	
	public function GetAssociatedInventory() : CInventoryComponent
	{
		return GetWitcherPlayer().GetInventory();
	}
}
