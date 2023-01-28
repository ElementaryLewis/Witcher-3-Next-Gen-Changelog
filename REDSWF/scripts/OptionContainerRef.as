package
{
   import red.game.witcher3.hud.modules.dialog.OptionContainer;
   
   public dynamic class OptionContainerRef extends OptionContainer
   {
       
      
      public function OptionContainerRef()
      {
         super();
         this.__setProp_mcOptionList_OptionContainer_mcDialogOptionList_0();
      }
      
      internal function __setProp_mcOptionList_OptionContainer_mcDialogOptionList_0() : *
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
         mcOptionList.itemRendererInstanceName = "mcOption";
         mcOptionList.margin = 0;
         mcOptionList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         mcOptionList.PCDownAction = 83;
         mcOptionList.PCUpAction = 87;
         mcOptionList.reverseMouseWheel = false;
         mcOptionList.rowHeight = 0;
         mcOptionList.scrollBar = "";
         mcOptionList.selectOnOver = true;
         mcOptionList.UpAction = 38;
         mcOptionList.visible = true;
         mcOptionList.wrapping = "wrap";
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
