package
{
   import red.game.witcher3.menus.common.TextAreaModuleCustomInput;
   
   public dynamic class MC_MODULE_TextAreaLegend extends TextAreaModuleCustomInput
   {
       
      
      public function MC_MODULE_TextAreaLegend()
      {
         super();
         addFrameScript(0,this.frame1);
         this.__setProp_mcTextArea_MC_MODULE_TextAreaLegend_mcTextArea_0();
      }
      
      internal function __setProp_mcTextArea_MC_MODULE_TextAreaLegend_mcTextArea_0() : *
      {
         try
         {
            mcTextArea["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcTextArea.actAsButton = false;
         mcTextArea.defaultText = "";
         mcTextArea.displayAsPassword = false;
         mcTextArea.editable = false;
         mcTextArea.enabled = true;
         mcTextArea.enableInitCallback = false;
         mcTextArea.focusable = true;
         mcTextArea.maxChars = 0;
         mcTextArea.minThumbSize = 1;
         mcTextArea.scrollBar = "mcScrollbar";
         mcTextArea.text = "";
         mcTextArea.thumbOffset = {
            "top":0,
            "bottom":0
         };
         mcTextArea.visible = true;
         try
         {
            mcTextArea["componentInspectorSetting"] = false;
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
