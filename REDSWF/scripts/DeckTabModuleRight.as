package
{
   import red.game.witcher3.menus.gwint.GwintDeckCTabModule;
   
   public dynamic class DeckTabModuleRight extends GwintDeckCTabModule
   {
       
      
      public function DeckTabModuleRight()
      {
         super();
         this.__setProp_mcCardSlotList_DeckTabModuleRight_mcCardSlotList_0();
         this.__setProp_mcTabList_DeckTabModuleRight_mcTabList_0();
      }
      
      internal function __setProp_mcCardSlotList_DeckTabModuleRight_mcCardSlotList_0() : *
      {
         try
         {
            mcCardSlotList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcCardSlotList.baseXOffset = 105;
         mcCardSlotList.baseYOffset = 185;
         mcCardSlotList.enabled = true;
         mcCardSlotList.enableInitCallback = false;
         mcCardSlotList.heightPadding = 370;
         mcCardSlotList.numColumns = 3;
         mcCardSlotList.numRowsVisible = 2;
         mcCardSlotList.scrollBar = "mcScrollbar";
         mcCardSlotList.slotRendererName = "CardSlotRef";
         mcCardSlotList.visible = true;
         mcCardSlotList.widthPadding = 205;
         try
         {
            mcCardSlotList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcTabList_DeckTabModuleRight_mcTabList_0() : *
      {
         try
         {
            mcTabList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcTabList.DownAction = 149;
         mcTabList.enabled = true;
         mcTabList.enableInitCallback = false;
         mcTabList.focusable = false;
         mcTabList.itemRendererName = "";
         mcTabList.itemRendererInstanceName = "mcTabListItem";
         mcTabList.margin = 0;
         mcTabList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         mcTabList.PCDownAction = 83;
         mcTabList.PCUpAction = 87;
         mcTabList.rowHeight = 0;
         mcTabList.scrollBar = "";
         mcTabList.UpAction = 148;
         mcTabList.visible = true;
         mcTabList.wrapping = "wrap";
         try
         {
            mcTabList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
