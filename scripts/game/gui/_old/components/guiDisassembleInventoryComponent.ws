/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/
class W3GuiDisassembleInventoryComponent extends W3GuiPlayerInventoryComponent
{
	public var merchantInv : CInventoryComponent;
	
	public  function SetInventoryFlashObjectForItem( item : SItemUniqueId, out flashObject : CScriptedFlashObject) : void
	{
		var targetGridSection : int;
		
		super.SetInventoryFlashObjectForItem( item, flashObject );
		
		addRecyclingPartsList( item, flashObject );
		if ( !_inv.IsItemEnchanted( item ) )
			addSocketsListInfo( item, flashObject );
		flashObject.SetMemberFlashBool( "enableComparison", _inv.CanBeCompared(item) );
		flashObject.SetMemberFlashInt( "gridPosition", -1 );
		
		if( _inv.IsItemAnyArmor( item ) || _inv.IsItemWeapon( item ) || _inv.IsItemUpgrade( item ) || _inv.IsItemArmorReapairKit( item ) || _inv.IsItemWeaponReapairKit( item )  )
		{
			targetGridSection = 0;
		}
		else
		{
			targetGridSection = 1;
		}
		
		flashObject.SetMemberFlashInt( "sectionId", targetGridSection );
	}
	
	public  function ShouldShowItem( item : SItemUniqueId ):bool
	{
		var itemTags : array<name>;
		var parts : array<SItemParts>;
		var showItem : bool;
		
		
		if( GetWitcherPlayer().IsItemEquipped( item ) || ( _inv.IsItemReadable( item ) && _inv.IsBookRead( item ) ) )
		{
			return false;
		}
		
		_inv.GetItemTags( item, itemTags );	
		parts = _inv.GetItemRecyclingParts(item);
		showItem = !itemTags.Contains( theGame.params.TAG_DONT_SHOW )
				&& !itemTags.Contains( theGame.params.TAG_DONT_SHOW_ONLY_IN_PLAYERS )
				&& !_inv.IsItemQuest( item );
		return parts.Size() > 0 && showItem;
	}
	
	private function addRecyclingPartsList( item : SItemUniqueId, out flashObject : CScriptedFlashObject ) : void
	{
		var idx, len	  : int;
		var partList	  : array<SItemParts>;
		var curPart		  : SItemParts;
		var partDataList  : CScriptedFlashArray;
		var curPartData	  : CScriptedFlashObject;
		var invItem 	 : SInventoryItem;
		var itemQuantityPrice : int;
		var itemQuantity : int;
		
		
		invItem = _inv.GetItem( item );
		
		partList = _inv.GetItemRecyclingParts(item);
		len = partList.Size();
		partDataList = flashObject.CreateFlashArray();
		for (idx = 0; idx < len; idx+=1)
		{
			curPart = partList[idx];
			curPartData = flashObject.CreateFlashObject();
			curPartData.SetMemberFlashString("name", GetLocStringByKeyExt(_inv.GetItemLocalizedNameByName(curPart.itemName)));
			curPartData.SetMemberFlashString("iconPath", _inv.GetItemIconPathByName(curPart.itemName));
			
			
			
			curPartData.SetMemberFlashInt("quantity", 1);
			
			partDataList.PushBackFlashObject(curPartData);
		}
		flashObject.SetMemberFlashArray("partList", partDataList);
		flashObject.SetMemberFlashBool("disableAction", GetWitcherPlayer().IsItemEquipped(item) );
		
		itemQuantity = _inv.GetItemQuantity( item );
		itemQuantityPrice = merchantInv.GetItemPriceDisassemble( invItem );
		
		flashObject.SetMemberFlashInt("actionPrice", itemQuantityPrice);
		flashObject.SetMemberFlashInt("actionPriceTotal", itemQuantity * itemQuantityPrice);
	}
	
	private function addSocketsListInfo(item : SItemUniqueId, out flashObject : CScriptedFlashObject) : void
	{
		var idx				  : int;
		var socketsCount	  : int;
		var usedSocketsCount  : int;
		var socketItems		  : array<name>;
		var socketList		  : CScriptedFlashArray;
		var socketData 		  : CScriptedFlashObject;
		
		_inv.GetItemEnhancementItems(item, socketItems);
		socketsCount = _inv.GetItemEnhancementSlotsCount( item );
		usedSocketsCount = _inv.GetItemEnhancementCount( item );
		socketList = flashObject.CreateFlashArray();
		
		for (idx = 0; idx < usedSocketsCount; idx+=1)
		{
			socketData = flashObject.CreateFlashObject();
			socketData.SetMemberFlashString("name", GetLocStringByKeyExt(_inv.GetItemLocalizedNameByName(socketItems[idx])));
			socketData.SetMemberFlashString("iconPath", _inv.GetItemIconPathByName(socketItems[idx]));
			socketList.PushBackFlashObject(socketData);
		}
		flashObject.SetMemberFlashArray("socketsData", socketList);
		flashObject.SetMemberFlashInt("socketsCount", socketsCount);
	}
}
