/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/




class W3AlchemyManager
{
	private var recipes : array<SAlchemyRecipe>;									
	private var isPlayerMounted  : bool;
	private var isPlayerInCombat : bool;
	
	
	public function Init(optional alchemyRecipes : array<name>)
	{
		if(alchemyRecipes.Size() > 0)
		{
			LoadRecipesCustomXMLData( alchemyRecipes );
		}
		else
		{
			LoadRecipesCustomXMLData( GetWitcherPlayer().GetAlchemyRecipes() );
		}
		
		isPlayerMounted = thePlayer.GetUsedVehicle();
		isPlayerInCombat = thePlayer.IsInCombat();
	}
	
	
	public function GetRecipe(recipeName : name, out ret : SAlchemyRecipe) : bool
	{
		var i : int;
		
		for(i=0; i<recipes.Size(); i+=1)
		{
			if(recipes[i].recipeName == recipeName)
			{
				ret = recipes[i];
				return true;
			}
		}
		
		return false;
	}
	
	
	private function LoadRecipesCustomXMLData(recipesNames : array<name>)
	{
		var dm : CDefinitionsManagerAccessor;
		var main, ingredients : SCustomNode;
		var tmpBool : bool;
		var tmpName : name;
		var tmpString : string;
		var tmpInt : int;
		var rec : SAlchemyRecipe;
		var i, k, readRecipes : int;
		var ing : SItemParts;
		
		dm = theGame.GetDefinitionsManager();
		main = dm.GetCustomDefinition('alchemy_recipes');
		readRecipes = 0;
		
		for(i=0; i<main.subNodes.Size(); i+=1)
		{
			
			if(dm.GetCustomNodeAttributeValueName(main.subNodes[i], 'name_name', tmpName) && IsNameValid(tmpName) && recipesNames.Contains(tmpName))
			{
				rec.recipeName = tmpName;
				
				if(dm.GetCustomNodeAttributeValueName(main.subNodes[i], 'cookedItem_name', tmpName))
					rec.cookedItemName = tmpName;
				else
					rec.cookedItemName = '';
					
				if(dm.GetCustomNodeAttributeValueName(main.subNodes[i], 'type_name', tmpName))
					rec.typeName = tmpName;
				else
					rec.typeName = '';
				
				if(dm.GetCustomNodeAttributeValueInt(main.subNodes[i], 'level', tmpInt))
					rec.level = tmpInt;
				else
					rec.level = -1;
					
				if(dm.GetCustomNodeAttributeValueString(main.subNodes[i], 'cookedItemType', tmpString))
					rec.cookedItemType = AlchemyCookedItemTypeStringToEnum(tmpString);
				else
					rec.cookedItemType = EACIT_Undefined;
					
				if(dm.GetCustomNodeAttributeValueInt(main.subNodes[i], 'cookedItemQuantity', tmpInt))
					rec.cookedItemQuantity = tmpInt;
				else
					rec.cookedItemQuantity = -1;
				
				
				ingredients = dm.GetCustomDefinitionSubNode(main.subNodes[i],'ingredients');
				rec.requiredIngredients.Clear();					
				for(k=0; k<ingredients.subNodes.Size(); k+=1)
				{		
					if(dm.GetCustomNodeAttributeValueName(ingredients.subNodes[k], 'item_name', tmpName))						
						ing.itemName = tmpName;
					else
						ing.itemName = '';
						
					if(dm.GetCustomNodeAttributeValueInt(ingredients.subNodes[k], 'quantity', tmpInt))
						ing.quantity = tmpInt;
					else
						ing.quantity = -1;
						
					rec.requiredIngredients.PushBack(ing);						
				}
				
				
				
				rec.cookedItemIconPath			= dm.GetItemIconPath( rec.cookedItemName );
				
				
				rec.recipeIconPath				= dm.GetItemIconPath( rec.recipeName );

				recipes.PushBack(rec);
				
				
				readRecipes += 1;
				if(readRecipes >= recipesNames.Size())
					break;
			}
		}
	}
	
	private final function GetItemNameWithoutLevelAsString(itemName : name) : string
	{
		var itemStr : string;
		
		itemStr = NameToString(itemName);
		if(StrEndsWith(itemStr, " 1") || StrEndsWith(itemStr, " 2") || StrEndsWith(itemStr, " 3"))
			return StrLeft(itemStr, StrLen(itemStr)-2);
		
		return itemStr;
	}
	
	
	public function CanCookRecipe(recipeName : name, optional ignorePlayerState:bool) : EAlchemyExceptions
	{
		var i, cnt, itemLevel : int;
		var recipe : SAlchemyRecipe;
		var items  : array<SItemUniqueId>;
		var itemType : string;
		var itemName : name;
		var dm : CDefinitionsManagerAccessor;
		
		if(!GetRecipe(recipeName, recipe))
			return EAE_NoRecipe;
		
		if (!ignorePlayerState)
		{
			if (isPlayerMounted) return EAE_Mounted;
			if (isPlayerInCombat) return EAE_InCombat;
		}
		
		
		itemType = GetItemNameWithoutLevelAsString(recipe.cookedItemName);
		
		if( theGame.GetDefinitionsManager().IsItemSingletonItem(recipe.cookedItemName) )
		{
			thePlayer.inv.GetAllItems(items);	
			for(i=0; i<items.Size(); i+=1)
			{
				itemName = thePlayer.inv.GetItemName(items[i]);
				
				
				if(itemName == recipe.cookedItemName)
					return EAE_CannotCookMore;
					
				
				if(StrStartsWith(NameToString(itemName), itemType))
				{
					itemLevel = (int)CalculateAttributeValue(thePlayer.inv.GetItemAttributeValue(items[i], 'level'));
					if(itemLevel >= recipe.level)
						return EAE_CannotCookMore;
				}
			}
		}
		
		dm = theGame.GetDefinitionsManager();
		
		
		for(i=0; i<recipe.requiredIngredients.Size(); i+=1)
		{
			itemName = recipe.requiredIngredients[i].itemName;
			
			if (dm.ItemHasTag( itemName, 'MutagenIngredient' ))
			{
				cnt = thePlayer.inv.GetUnusedMutagensCount(itemName);
			}
			else
			{
				cnt = thePlayer.inv.GetItemQuantityByName(itemName);
			}
			
			if(cnt < recipe.requiredIngredients[i].quantity)
			{
				return EAE_NotEnoughIngredients;
			}			
		}
		return EAE_NoException;
	}
		
	
	public function CookItem(recipeName : name)
	{
		var i, j, quantity, removedIngQuantity, maxAmmo : int;
		var recipe : SAlchemyRecipe;
		var dm : CDefinitionsManagerAccessor;
		var crossbowID : SItemUniqueId;
		var min, max : SAbilityAttributeValue;
		var uiStateAlchemy : W3TutorialManagerUIHandlerStateAlchemy;
		var uiStateAlchemyMutagens : W3TutorialManagerUIHandlerStateAlchemyMutagens;
		var ids : array<SItemUniqueId>;
		var items, alchIngs  : array<SItemUniqueId>;
		var isPotion, isSingletonItem : bool;
		var witcher : W3PlayerWitcher;
		var equippedOnSlot : EEquipmentSlots;
		var itemName:name;
		
		GetRecipe(recipeName, recipe);
		
		
		equippedOnSlot = EES_InvalidSlot;
		dm = theGame.GetDefinitionsManager();
		dm.GetItemAttributeValueNoRandom(recipe.cookedItemName, true, 'ammo', min, max);
		quantity = (int)CalculateAttributeValue(GetAttributeRandomizedValue(min, max));
		
		if(recipe.cookedItemType == EACIT_Bomb && GetWitcherPlayer().CanUseSkill(S_Alchemy_s08))
			quantity += GetWitcherPlayer().GetSkillLevel(S_Alchemy_s08);
		
		
		isSingletonItem = dm.IsItemSingletonItem(recipe.cookedItemName);
		if(isSingletonItem && thePlayer.inv.GetItemQuantityByName(recipe.cookedItemName) > 0 )
		{
			items = thePlayer.inv.GetItemsByName(recipe.cookedItemName);
			
			if (items.Size() == 1 && thePlayer.inv.ItemHasTag(items[0], 'NoShow'))
			{
				thePlayer.inv.RemoveItemTag(items[i], 'NoShow');
			}
		}
		else
		{
			ids = thePlayer.inv.AddAnItem(recipe.cookedItemName, quantity);
			if(isSingletonItem)
			{
				maxAmmo = thePlayer.inv.SingletonItemGetMaxAmmo(ids[0]);
				for(i=0; i<ids.Size(); i+=1)
					thePlayer.inv.SingletonItemSetAmmo(ids[i], maxAmmo);
			}
		}
		
		
		for(i=0; i<recipe.requiredIngredients.Size(); i+=1)
		{
			itemName = recipe.requiredIngredients[i].itemName;
			
			
			
			if( dm.ItemHasTag( itemName, 'MutagenIngredient' ) )
			{
				thePlayer.inv.RemoveUnusedMutagensCount( itemName, recipe.requiredIngredients[i].quantity);
			}
			else if( dm.IsItemAlchemyItem( itemName ))
			{
				removedIngQuantity = 0;
				alchIngs = thePlayer.inv.GetItemsByName(itemName);
				witcher = GetWitcherPlayer();
				
				for(j=0; j<alchIngs.Size(); j+=1)
				{
					equippedOnSlot = witcher.GetItemSlot(alchIngs[j]);
					
					if(equippedOnSlot != EES_InvalidSlot)
					{
						witcher.UnequipItem(alchIngs[j]);
					}
					
					removedIngQuantity += 1;
					witcher.inv.RemoveItem(alchIngs[j], 1);
					
					if(removedIngQuantity >= recipe.requiredIngredients[i].quantity)
						break;
				}
			}
			else
			{
				
				thePlayer.inv.RemoveItemByName(itemName, recipe.requiredIngredients[i].quantity);
			}
		}
		
		RemoveLowerLevelItems(recipe);
		
		if( ids.Size() > 0  && thePlayer.inv.IsItemPotion( ids[0] ) )
		{
			isPotion = true;
		}
		else if( items.Size() > 0  && thePlayer.inv.IsItemPotion( items[0] ) )
		{
			isPotion = true;
		}
		else
		{
			isPotion = false;
		}
		
		if( isPotion )
		{
			theTelemetry.LogWithLabelAndValue( TE_ITEM_COOKED, recipe.cookedItemName, 1 );
		}
		else
		{
			theTelemetry.LogWithLabelAndValue( TE_ITEM_COOKED, recipe.cookedItemName, 0 );
		}
		
		
		if(equippedOnSlot != EES_InvalidSlot)
		{
			witcher.EquipItemInGivenSlot(ids[0], equippedOnSlot, false);
		}
		
		LogAlchemy("Item <<" + recipe.cookedItemName + ">> cooked x" + recipe.cookedItemQuantity);
		
		
		if(ShouldProcessTutorial('TutorialAlchemyCook'))
		{
			uiStateAlchemy = (W3TutorialManagerUIHandlerStateAlchemy)theGame.GetTutorialSystem().uiHandler.GetCurrentState();
			if(uiStateAlchemy)
			{
				uiStateAlchemy.CookedItem(recipeName);
			}
			else
			{
				uiStateAlchemyMutagens = (W3TutorialManagerUIHandlerStateAlchemyMutagens)theGame.GetTutorialSystem().uiHandler.GetCurrentState();
				if(uiStateAlchemyMutagens)
					uiStateAlchemyMutagens.CookedItem(recipeName);
			}
		}
	}
	
	
	private function RemoveLowerLevelItems(recipe : SAlchemyRecipe)
	{
		var i, j : int;
		var items : array<SItemUniqueId>;
		var witcher : W3PlayerWitcher;
		
		witcher = GetWitcherPlayer();
		for(i=0; i<recipes.Size(); i+=1)
		{
			if(recipes[i].typeName == recipe.typeName && recipes[i].level < recipe.level)
			{
				items = thePlayer.inv.GetItemsByName(recipes[i].cookedItemName);
				for(j=0; j<items.Size(); j+=1)
				{
					if(witcher.IsItemEquipped(items[j]))
						witcher.UnequipItem(items[j]);
						
					witcher.inv.RemoveItem(items[j]);
				}
			}
		}
	}
			
	
	public function GetRecipes(forceAll : bool) : array<SAlchemyRecipe>
	{
		var ret : array<SAlchemyRecipe>;
		var i, j, cnt : int;
		var checkedRecipe, testedRecipe : string;
		var deletedCheckted : bool;
		var alchemyItems : array<SItemUniqueId>;
		var itemName : name;
		
		
		forceAll = true;
		
		
		if(forceAll)
			return recipes;
		
		alchemyItems = thePlayer.inv.GetAlchemyCraftableItems();
		
		
		
		
		ret.Resize(recipes.Size());
		for(i=0; i<recipes.Size(); i+=1)
		{
			ret[i] = recipes[i];
		}
		
		i=0;
		while(i < ret.Size())
		{
			j=i+1;
			deletedCheckted = false;
			
			
			checkedRecipe = NameToString(ret[i].cookedItemName);
			checkedRecipe = StrLeft(checkedRecipe, StrLen(checkedRecipe)-2);
						
			while(j<ret.Size())	
			{
				
				testedRecipe = NameToString(ret[j].cookedItemName);
				testedRecipe = StrLeft(testedRecipe, StrLen(testedRecipe)-2);
				
				
				if(checkedRecipe == testedRecipe)
				{				
					if(ret[i].level < ret[j].level)
					{
						if(ShouldRemoveRecipe(ret[i].cookedItemName, ret[i].level, alchemyItems))
						{
							
							ret.EraseFast(i);
							deletedCheckted = true;
							break;
						}
					}
					else
					{
						if(ShouldRemoveRecipe(ret[j].cookedItemName, ret[j].level, alchemyItems))
						{
							
							ret.EraseFast(j);
							continue;
						}
					}
				}
				
				
				j+=1;
			}
			
			
			if(!deletedCheckted)
				i+=1;
		}
		
		
		for(i=ret.Size()-1; i>=0; i-=1)
		{
			itemName = ret[i].cookedItemName;
			cnt = thePlayer.inv.GetItemQuantityByName(itemName);
			
			if(cnt <= 0)
				continue;
				
			
			if(ret[i].cookedItemType == EACIT_Potion && StrStartsWith(NameToString(ret[i].typeName), "Mutagen"))
			{
				ret.EraseFast(i);
				continue;
			}
			
			
			if(ret[i].level == 3)
			{
				ret.EraseFast(i);
				continue;
			}
			
			
			if(itemName == 'Killer Whale 1' || itemName == 'Trial Potion Kit' || itemName == 'Pops Antidote' || itemName == 'mh107_czart_lure' || StrContains(NameToString(itemName), "Pheromone"))
			{
				ret.EraseFast(i);
				continue;
			}
		}
		
		return ret;
	}
	
	
	private final function ShouldRemoveRecipe(itemName : name, itemLevel : int, alchemyItems : array<SItemUniqueId>) : bool
	{
		var recipeItemType, checkedItemType : string;
		var i : int;
		
		recipeItemType = NameToString(itemName);
		recipeItemType = StrLeft(recipeItemType, StrLen(recipeItemType)-2);
		
		for(i=0; i<alchemyItems.Size(); i+=1)
		{
			checkedItemType = NameToString(thePlayer.inv.GetItemName(alchemyItems[i]));
			checkedItemType = StrLeft(checkedItemType, StrLen(checkedItemType)-2);
			
			if(recipeItemType == checkedItemType)
			{
				if( CalculateAttributeValue(thePlayer.inv.GetItemAttributeValue(alchemyItems[i], 'level')) >= itemLevel )
					return true;
			}
		}
		
		return false;
	}
	
	public function GetRequiredIngredients(recipeName : name) : array<SItemParts>
	{
		var rec : SAlchemyRecipe;
		var null : array<SItemParts>;
	
		if(GetRecipe(recipeName, rec))
			return rec.requiredIngredients;
			
		return null;
	}	
}

function getAlchemyRecipeFromName(recipeName : name):SAlchemyRecipe
{
	var dm : CDefinitionsManagerAccessor;
	var main, ingredients : SCustomNode;
	var tmpBool : bool;
	var tmpName : name;
	var tmpString : string;
	var tmpInt : int;
	var ing : SItemParts;
	var i,k : int;
	var rec : SAlchemyRecipe;
	
	dm = theGame.GetDefinitionsManager();
	main = dm.GetCustomDefinition('alchemy_recipes');
	
	for(i=0; i<main.subNodes.Size(); i+=1)
	{
		dm.GetCustomNodeAttributeValueName(main.subNodes[i], 'name_name', tmpName);
		
		if (tmpName == recipeName)
		{
			if(dm.GetCustomNodeAttributeValueName(main.subNodes[i], 'cookedItem_name', tmpName))
				rec.cookedItemName = tmpName;
			if(dm.GetCustomNodeAttributeValueName(main.subNodes[i], 'type_name', tmpName))
				rec.typeName = tmpName;
			if(dm.GetCustomNodeAttributeValueInt(main.subNodes[i], 'level', tmpInt))
				rec.level = tmpInt;	
			if(dm.GetCustomNodeAttributeValueString(main.subNodes[i], 'cookedItemType', tmpString))
				rec.cookedItemType = AlchemyCookedItemTypeStringToEnum(tmpString);
			if(dm.GetCustomNodeAttributeValueInt(main.subNodes[i], 'cookedItemQuantity', tmpInt))
				rec.cookedItemQuantity = tmpInt;
			
			
			ingredients = dm.GetCustomDefinitionSubNode(main.subNodes[i],'ingredients');					
			for(k=0; k<ingredients.subNodes.Size(); k+=1)
			{		
				ing.itemName = '';
				ing.quantity = -1;
			
				if(dm.GetCustomNodeAttributeValueName(ingredients.subNodes[k], 'item_name', tmpName))						
					ing.itemName = tmpName;
				if(dm.GetCustomNodeAttributeValueInt(ingredients.subNodes[k], 'quantity', tmpInt))
					ing.quantity = tmpInt;
					
				rec.requiredIngredients.PushBack(ing);						
			}
			
			rec.recipeName = recipeName;
			
			
			rec.cookedItemIconPath			= dm.GetItemIconPath( rec.cookedItemName );
			rec.recipeIconPath				= dm.GetItemIconPath( rec.recipeName );
			break;
		}
	}
	
	return rec;
}
