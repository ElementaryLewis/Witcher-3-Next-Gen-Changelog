/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/






class W3StandaloneDismantleComponent extends W3GuiPlayerInventoryComponent
{
	protected  function ShouldShowItem( item : SItemUniqueId ):bool
	{
		var itemTags    	 : array <name>;
		var showItem 		 : bool;
		var slotsCount  	 : int;
		var isArmorOrWeapon  : bool;
		
		_inv.GetItemTags( item, itemTags );
		
		showItem = !itemTags.Contains( theGame.params.TAG_DONT_SHOW )
				&& !itemTags.Contains( theGame.params.TAG_DONT_SHOW_ONLY_IN_PLAYERS )
				&& itemTags.Contains( 'mod_alchemy_table' )
				&& !_inv.IsItemQuest( item )
				&& !GetWitcherPlayer().IsItemEquipped( item );
				
		
		return showItem;
	}
	
	public  function SetInventoryFlashObjectForItem( item : SItemUniqueId, out flashObject : CScriptedFlashObject) : void
	{
		super.SetInventoryFlashObjectForItem( item, flashObject );
		addRecyclingPartsList( item, flashObject );
		flashObject.SetMemberFlashInt( "gridPosition", -1 );
		flashObject.SetMemberFlashInt( "sectionId", -1 );
	}
	
	public function DoDismantling( item : SItemUniqueId, dismantleCount : int, out addedItems : array <SItemUniqueId>) : void
	{
		var i, count	  : int;
		var curItemPart   : SItemParts;
		var newItems	  : array <SItemUniqueId>;
		var dismantleList : array <SItemParts>;
		
		dismantleList = GetDismantlingParts( item ); 
		count = dismantleList.Size();
		
		for( i = 0; i < count; i += 1 )
		{
			curItemPart = dismantleList[i];
			newItems = _inv.AddAnItem( curItemPart.itemName, dismantleCount );
			
			if( newItems.Size() > 0 )
			{
				addedItems.PushBack( newItems[0] );
			}
		}
		
		_inv.RemoveItem( item, dismantleCount );
	}
	
	private function addRecyclingPartsList( item : SItemUniqueId, out flashObject : CScriptedFlashObject ) : void
	{
		var idx, len	  : int;
		var partList	  : array< SItemParts >;
		var curPart		  : SItemParts;
		var partDataList  : CScriptedFlashArray;
		var curPartData	  : CScriptedFlashObject;
		var invItem 	  : SInventoryItem;
		
		var itemQuantityPrice : int;
		var itemQuantity 	  : int;
		
		invItem = _inv.GetItem( item );
		partList = GetDismantlingParts( item );
		len = partList.Size();
		partDataList = flashObject.CreateFlashArray();
		
		for( idx = 0; idx < len; idx += 1 )
		{
			curPart = partList[idx];
			curPartData = flashObject.CreateFlashObject();
			curPartData.SetMemberFlashString( "name", GetLocStringByKeyExt( _inv.GetItemLocalizedNameByName( curPart.itemName ) ) );
			curPartData.SetMemberFlashString( "iconPath", _inv.GetItemIconPathByName( curPart.itemName ) );
			curPartData.SetMemberFlashInt( "quantity", 1 );
			partDataList.PushBackFlashObject( curPartData );
		}
		
		flashObject.SetMemberFlashArray( "partList", partDataList );
		flashObject.SetMemberFlashInt( "actionPrice", 0 );
		flashObject.SetMemberFlashInt( "actionPriceTotal", 0 );
	}
	
	public function GetDismantlingParts( item : SItemUniqueId ) : array <SItemParts>
	{
		var i, count	  : int;
		var curPart    	  : SItemParts;
		var curPartsList  : array <SItemParts>;
		var abilitiesList : array <name>;
		
		_inv.GetItemAbilities( item, abilitiesList );
		count = abilitiesList.Size();
		
		for( i = 0; i < count; i+=1 )
		{
			curPart.quantity = _inv.GetItemQuantity( item );
			
			switch ( abilitiesList[ i ] )
			{
				case 'lesser_mutagen_color_red':
					curPart.itemName = 'Lesser mutagen red';
					break;
					
				case 'mutagen_color_red':
					curPart.itemName = 'Mutagen red';
					break;
					
				case 'greater_mutagen_color_red':
					curPart.itemName = 'Greater mutagen red';
					break;
					
				case 'lesser_mutagen_color_green':
					curPart.itemName = 'Lesser mutagen green';
					break;
					
				case 'mutagen_color_green':
					curPart.itemName = 'Mutagen green';
					break;
					
				case 'greater_mutagen_color_green':
					curPart.itemName = 'Greater mutagen green';
					break;
					
				case 'lesser_mutagen_color_blue':
					curPart.itemName = 'Lesser mutagen blue';
					break;
					
				case 'mutagen_color_blue':
					curPart.itemName = 'Mutagen blue';
					break;
					
				case 'greater_mutagen_color_blue':
					curPart.itemName = 'Greater mutagen blue';
					break;
					
				default:
					curPart.itemName = '';
					
			}
			
			if( curPart.itemName != '' )
			{
				curPartsList.PushBack( curPart );
			}
		}
		
		return curPartsList;
	}
	
}