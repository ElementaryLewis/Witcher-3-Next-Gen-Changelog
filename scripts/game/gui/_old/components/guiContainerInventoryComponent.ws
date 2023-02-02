/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/
abstract class W3CommonContainerInventoryComponent extends W3GuiBaseInventoryComponent
{
	

	public function GiveAllItems( receiver : W3GuiBaseInventoryComponent )
	{
		
	
		
		
	}
		
	public function GetItemActionType( item : SItemUniqueId, optional bGetDefault : bool) : EInventoryActionType
	{
		return IAT_Transfer;
	}	

	public function HideAllItems( ) : void 
	{
		var i : int;
		var item : SItemUniqueId;
		var rawItems : array< SItemUniqueId >;
		var itemTags : array<name>;
		
		_inv.GetAllItems( rawItems );
		
		for ( i = 0; i < rawItems.Size(); i += 1 )
		{		
			item = rawItems[i];
			itemTags.Clear();
			_inv.GetItemTags( item, itemTags );
		
			if ( !itemTags.Contains( 'NoShowInContainer' ) )
			{
				_inv.AddItemTag(item,'NoShowInContainer');
			}
		}
	}
	
	protected function ShouldShowItem( item : SItemUniqueId ) : bool
	{
		var itemTags : array<name>;
		
		_inv.GetItemTags( item, itemTags );
		
		
		if ( itemTags.Contains( 'NoShowInContainer' ) )
		{
			return false;
		}
		
		return super.ShouldShowItem( item );
	}
}

class W3GuiTakeOnlyContainerInventoryComponent extends W3CommonContainerInventoryComponent
{	
	public function ReceiveItem( item : SItemUniqueId, giver : W3GuiBaseInventoryComponent, optional quantity : int, optional newItemID : SItemUniqueId ) : bool
	{

		return false;
	}
}



class W3GuiContainerInventoryComponent extends W3CommonContainerInventoryComponent 
{
	public var dontShowEquipped:bool; default dontShowEquipped = false;
	
	public function ReceiveItem( item : SItemUniqueId, giver : W3GuiBaseInventoryComponent, optional quantity : int, optional newItemID : SItemUniqueId  ) : bool 
	{
		var invalidatedItems, newIds : array< SItemUniqueId >;
		var newItem : SItemUniqueId;
		var success: bool;
		var itemName : name;
		
		if( quantity  < 1 )
		{
			quantity = 1;
		}
		success = false;
		itemName = giver._inv.GetItemName(item);
		
		giver._inv.RemoveItem(item,quantity); 
		newIds = _inv.AddAnItem(itemName,quantity,true,true);
		newItem = newIds[0];
		if ( newItem != GetInvalidUniqueId() )
		{
			success = true;
		}
		
		return success;
	}
	
	protected function ShouldShowItem( item : SItemUniqueId ) : bool
	{
		if (dontShowEquipped)
		{
			if (isHorseItem(item))
			{
				if (GetWitcherPlayer().GetHorseManager().IsItemEquipped(item))
				{
					return false;
				}
			}
			else
			{
				if ( _inv == GetWitcherPlayer().GetInventory() && GetWitcherPlayer().IsItemEquipped(item))
				{
					return false;
				}
			}
		}
		
		return super.ShouldShowItem( item );
	}
	
	protected function GridPositionEnabled() : bool
	{
		return false;
	}
}


