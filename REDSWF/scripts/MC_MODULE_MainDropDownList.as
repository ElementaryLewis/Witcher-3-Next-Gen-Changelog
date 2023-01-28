package
{
   import red.game.witcher3.menus.common.DropdownListModuleBase;
   
   public dynamic class MC_MODULE_MainDropDownList extends DropdownListModuleBase
   {
       
      
      public function MC_MODULE_MainDropDownList()
      {
         super();
         this.__setProp_mcDropDownList_MC_MODULE_MainDropDownList_dropdown_0();
      }
      
      internal function __setProp_mcDropDownList_MC_MODULE_MainDropDownList_dropdown_0() : *
      {
         try
         {
            mcDropDownList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcDropDownList.DownAction = 40;
         mcDropDownList.enabled = true;
         mcDropDownList.enableInitCallback = false;
         mcDropDownList.focusable = true;
         mcDropDownList.itemRendererName = "IconDropDownListItem";
         mcDropDownList.itemRendererInstanceName = "IconDropDownListItem";
         mcDropDownList.listHeight = 803.7;
         mcDropDownList.listWidth = 500;
         mcDropDownList.margin = 0;
         mcDropDownList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         mcDropDownList.rowHeight = 0;
         mcDropDownList.scrollBar = "mcScrollBar";
         mcDropDownList.scrollSpeed = 40;
         mcDropDownList.UpAction = 38;
         mcDropDownList.visible = true;
         mcDropDownList.wrapping = "wrap";
         try
         {
            mcDropDownList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
