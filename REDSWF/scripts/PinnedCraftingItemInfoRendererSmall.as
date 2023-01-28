package
{
   import red.game.witcher3.menus.inventory_menu.PinnedCraftingItemInfo;
   
   public dynamic class PinnedCraftingItemInfoRendererSmall extends PinnedCraftingItemInfo
   {
       
      
      public function PinnedCraftingItemInfoRendererSmall()
      {
         super();
         this.__setProp_iconLoader_PinnedCraftingItemInfoRendererSmall_iconLoader_0();
      }
      
      internal function __setProp_iconLoader_PinnedCraftingItemInfoRendererSmall_iconLoader_0() : *
      {
         try
         {
            iconLoader["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         iconLoader.autoSize = false;
         iconLoader.enableInitCallback = false;
         iconLoader.maintainAspectRatio = true;
         iconLoader.source = "";
         iconLoader.visible = true;
         try
         {
            iconLoader["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
