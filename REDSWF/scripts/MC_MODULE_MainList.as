package
{
   import red.game.witcher3.menus.common.ListModuleBase;
   
   public dynamic class MC_MODULE_MainList extends ListModuleBase
   {
       
      
      public function MC_MODULE_MainList()
      {
         super();
         addFrameScript(0,this.frame1);
         this.__setProp_mcList_MC_MODULE_MainList_mcList_0();
      }
      
      internal function __setProp_mcList_MC_MODULE_MainList_mcList_0() : *
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
         mcList.rowHeight = 0;
         mcList.scrollBar = "mcScrollBar";
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
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
