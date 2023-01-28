package
{
   import red.game.witcher3.menus.mainmenu.OptionListModule;
   
   public dynamic class OptionListModuleRef extends OptionListModule
   {
       
      
      public function OptionListModuleRef()
      {
         super();
         this.__setProp_mcOptionList_OptionListModule_mcOptionList_0();
      }
      
      internal function __setProp_mcOptionList_OptionListModule_mcOptionList_0() : *
      {
         try
         {
            mcOptionList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcOptionList.DownAction = 40;
         mcOptionList.enabled = true;
         mcOptionList.enableInitCallback = false;
         mcOptionList.focusable = true;
         mcOptionList.itemRendererName = "";
         mcOptionList.itemRendererInstanceName = "mcOptionListItem";
         mcOptionList.margin = 0;
         mcOptionList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         mcOptionList.rowHeight = 0;
         mcOptionList.scrollBar = "mcOptionScrollbar";
         mcOptionList.UpAction = 38;
         mcOptionList.visible = true;
         mcOptionList.wrapping = "normal";
         try
         {
            mcOptionList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
