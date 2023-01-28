package
{
   import red.game.witcher3.menus.mainmenu.KeyBindsOptionModule;
   
   public dynamic class MC_MODULE_KeyBindsOption extends KeyBindsOptionModule
   {
       
      
      public function MC_MODULE_KeyBindsOption()
      {
         super();
         this.__setProp_mcList_MC_MODULE_KeyBindsOption_mcList_0();
      }
      
      internal function __setProp_mcList_MC_MODULE_KeyBindsOption_mcList_0() : *
      {
         try
         {
            mcList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcList.DownAction = 40;
         mcList.enabled = true;
         mcList.enableInitCallback = false;
         mcList.focusable = false;
         mcList.itemRendererName = "";
         mcList.itemRendererInstanceName = "mcItemRenderer";
         mcList.margin = 0;
         mcList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         mcList.rowHeight = 0;
         mcList.scrollBar = "mcScrollbar";
         mcList.UpAction = 38;
         mcList.visible = true;
         mcList.wrapping = "normal";
         try
         {
            mcList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
