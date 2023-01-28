package red.game.witcher3.hud.modules.dialog
{
   import red.core.constants.KeyCode;
   import red.game.witcher3.controls.InputFeedbackButton;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.core.UIComponent;
   
   public class SkipIndicator extends UIComponent
   {
       
      
      public var btnSkip:InputFeedbackButton;
      
      private var inited:Boolean;
      
      public function SkipIndicator()
      {
         super();
         this.inited = false;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         alpha = 0;
         this.setupData();
      }
      
      public function setupData() : void
      {
         if(!this.inited)
         {
            this.btnSkip.clickable = false;
            this.btnSkip.label = "[[panel_button_dialogue_skip]]";
            this.btnSkip.setDataFromStage(NavigationCode.GAMEPAD_X,KeyCode.SPACE);
            this.btnSkip.validateNow();
            this.inited = true;
         }
      }
   }
}
