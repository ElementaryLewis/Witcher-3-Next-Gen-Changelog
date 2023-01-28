package red.game.witcher3.menus.mainmenu
{
   import flash.events.Event;
   import flash.text.TextField;
   import red.core.CoreMenu;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.SliderEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class MainMenuGamma extends CoreMenu
   {
       
      
      public var mcGammaModule:GammaSettingModule;
      
      public var mcInputFeedbackModule:ModuleInputFeedback;
      
      public var txtUserName:TextField;
      
      public function MainMenuGamma()
      {
         addFrameScript(0,this.frame1);
         super();
      }
      
      public function setCurrentUsername(name:String) : void
      {
         if(this.txtUserName)
         {
            this.txtUserName.text = name;
         }
      }
      
      override protected function get menuName() : String
      {
         return "MainGammaMenu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.setCurrentUsername("");
         if(this.mcGammaModule)
         {
            this.mcGammaModule.addEventListener(IngameMenu.OnOptionPanelClosed,this.handlePanelClosed,false,0,true);
         }
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"gammamenu.setvalues",[this.handleRecieveGamma]));
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         this.mcInputFeedbackModule.appendButton(0,NavigationCode.GAMEPAD_L3,-1,"[[panel_button_common_navigation]]",false);
         this.mcInputFeedbackModule.appendButton(1,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_continue]]",true);
      }
      
      public function SetInitialGamma(value:Number) : *
      {
      }
      
      private function handleSliderValueChange(event:SliderEvent) : *
      {
      }
      
      override protected function handleInputNavigate(event:InputEvent) : void
      {
         this.mcGammaModule.handleInputNavigate(event);
         var details:InputDetails = event.details;
         var keyUp:* = details.value == InputValue.KEY_UP;
         if(keyUp && !event.handled)
         {
            switch(details.navEquivalent)
            {
               case NavigationCode.GAMEPAD_A:
                  closeMenu();
                  event.handled = true;
            }
         }
         if(keyUp && !event.handled && (details.code == KeyCode.SPACE || details.code == KeyCode.ENTER || details.code == KeyCode.E))
         {
            closeMenu();
            event.handled = true;
         }
      }
      
      protected function handlePanelClosed(event:Event) : void
      {
         closeMenu();
      }
      
      protected function handleRecieveGamma(gammaData:Object) : void
      {
         if(this.mcGammaModule)
         {
            this.mcGammaModule.showWithData(gammaData);
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
