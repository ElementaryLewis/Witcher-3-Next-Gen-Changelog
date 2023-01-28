package red.game.witcher3.menus.inventory_menu
{
   import flash.text.TextField;
   import red.core.events.GameEvent;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.core.UIComponent;
   
   public class PinnedCraftingInfoModule extends UIComponent
   {
       
      
      public var txtTitle:TextField;
      
      public var txtRecipeTitle:TextField;
      
      public var craftedItemInfo:PinnedCraftingItemInfo;
      
      public var ingredientItemInfo1:PinnedCraftingItemInfo;
      
      public var ingredientItemInfo2:PinnedCraftingItemInfo;
      
      public var ingredientItemInfo3:PinnedCraftingItemInfo;
      
      public var ingredientItemInfo4:PinnedCraftingItemInfo;
      
      public var ingredientItemInfo5:PinnedCraftingItemInfo;
      
      public var ingredientItemInfo6:PinnedCraftingItemInfo;
      
      public var ingredientItemInfo7:PinnedCraftingItemInfo;
      
      public function PinnedCraftingInfoModule()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         visible = false;
         this.txtTitle.htmlText = "[[panel_shop_title_pinned_recipe]]";
         this.txtTitle.htmlText = CommonUtils.toUpperCaseSafe(this.txtTitle.htmlText);
         this.txtRecipeTitle.htmlText = "[[panel_alchemy_required_ingridients]]";
         this.txtRecipeTitle.htmlText = CommonUtils.toUpperCaseSafe(this.txtRecipeTitle.htmlText);
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"inventory.pinned.crafting.info",[this.setPinnedCraftingInfo]));
      }
      
      protected function setPinnedCraftingInfo(param1:Array) : void
      {
         var _loc2_:int = 0;
         if(param1.length > 0)
         {
            visible = true;
            this.craftedItemInfo.setItemData(param1[0]);
            if(param1.length > 1)
            {
               this.ingredientItemInfo1.setItemData(param1[1]);
            }
            if(param1.length > 2)
            {
               this.ingredientItemInfo2.setItemData(param1[2]);
            }
            if(param1.length > 3)
            {
               this.ingredientItemInfo3.setItemData(param1[3]);
            }
            if(param1.length > 4)
            {
               this.ingredientItemInfo4.setItemData(param1[4]);
            }
            if(param1.length > 5)
            {
               this.ingredientItemInfo5.setItemData(param1[5]);
            }
            if(param1.length > 6)
            {
               this.ingredientItemInfo6.setItemData(param1[6]);
            }
            if(param1.length > 7)
            {
               this.ingredientItemInfo7.setItemData(param1[7]);
            }
         }
      }
   }
}
