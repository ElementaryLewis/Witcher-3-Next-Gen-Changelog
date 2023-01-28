package
{
   import red.game.witcher3.menus.common.LoadingSymbol;
   
   public dynamic class LoadingSymbol extends red.game.witcher3.menus.common.LoadingSymbol
   {
       
      
      public function LoadingSymbol()
      {
         super();
         addFrameScript(0,this.frame1);
         this.__setProp_mcSkipButton_LoadingSymbol_Button_0();
      }
      
      internal function __setProp_mcSkipButton_LoadingSymbol_Button_0() : *
      {
         try
         {
            mcSkipButton["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcSkipButton.autoRepeat = false;
         mcSkipButton.autoSize = "none";
         mcSkipButton.data = "";
         mcSkipButton.enabled = true;
         mcSkipButton.enableInitCallback = false;
         mcSkipButton.focusable = true;
         mcSkipButton.label = "";
         mcSkipButton.selected = false;
         mcSkipButton.toggle = false;
         mcSkipButton.visible = false;
         try
         {
            mcSkipButton["componentInspectorSetting"] = false;
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
