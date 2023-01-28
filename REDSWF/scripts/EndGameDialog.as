package
{
   import red.game.witcher3.menus.gwint.GwintEndGameDialog;
   
   public dynamic class EndGameDialog extends GwintEndGameDialog
   {
       
      
      public function EndGameDialog()
      {
         super();
         addFrameScript(0,this.frame1,6,this.frame7,7,this.frame8,13,this.frame14,14,this.frame15,19,this.frame20);
         this.__setProp_mcIconLoader_EndGameDialog_mcIconLoader_0();
      }
      
      internal function __setProp_mcIconLoader_EndGameDialog_mcIconLoader_0() : *
      {
         try
         {
            mcIconLoader["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcIconLoader.autoSize = false;
         mcIconLoader.enableInitCallback = false;
         mcIconLoader.maintainAspectRatio = false;
         mcIconLoader.source = "";
         mcIconLoader.visible = true;
         try
         {
            mcIconLoader["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame7() : *
      {
         stop();
      }
      
      internal function frame8() : *
      {
         stop();
      }
      
      internal function frame14() : *
      {
         stop();
      }
      
      internal function frame15() : *
      {
         stop();
      }
      
      internal function frame20() : *
      {
         stop();
      }
   }
}
