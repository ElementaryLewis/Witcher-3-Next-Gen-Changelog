package
{
   import red.game.witcher3.modules.SimpleListModule;
   
   public dynamic class MenuListModule extends SimpleListModule
   {
       
      
      public function MenuListModule()
      {
         super();
         this.__setProp_mcList_MenuListModule_mcMenuList_0();
      }
      
      internal function __setProp_mcList_MenuListModule_mcMenuList_0() : *
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
         mcList.focusable = true;
         mcList.itemRendererName = "";
         mcList.itemRendererInstanceName = "mcListItem";
         mcList.margin = 0;
         mcList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         mcList.rowHeight = 40;
         mcList.scrollBar = "";
         mcList.UpAction = 38;
         mcList.visible = true;
         mcList.wrapping = "wrap";
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
