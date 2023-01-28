package red.game.witcher3.menus.common
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.data.KeyBindingData;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.InputEvent;
   
   public class LoadingSymbol extends UIComponent
   {
       
      
      public var textField:TextField;
      
      public var mcLoading:MovieClip;
      
      public var mcSkipButton:InputFeedbackButton;
      
      protected var _isGamepad:Boolean;
      
      public function LoadingSymbol()
      {
         super();
         this.textField.htmlText = "[[panel_loading_screen_loading]]";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         this.SetupButton();
      }
      
      override public function toString() : String
      {
         return "[W3 LoadingSymbol: ]";
      }
      
      protected function SetupButton() : void
      {
         this._isGamepad = InputManager.getInstance().isGamepad();
         var _loc1_:KeyBindingData = new KeyBindingData();
         _loc1_.gamepad_navEquivalent = "enter-gamepad_A";
         _loc1_.label = "[[panel_button_dialogue_skip]]";
         _loc1_.keyboard_keyCode = 113;
         this.mcSkipButton.enabled = false;
         this.mcSkipButton.setData(_loc1_,true);
         this.mcSkipButton.addEventListener(ButtonEvent.CLICK,this.handleButtonPress,false,10,true);
      }
      
      protected function handleButtonPress(param1:ButtonEvent) : void
      {
         var _loc2_:InputFeedbackButton = param1.target as InputFeedbackButton;
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         if(param1.handled)
         {
            return;
         }
         if(this.mcSkipButton.enabled)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnSkipPressed"));
         }
      }
      
      public function enableSkip(param1:Boolean) : void
      {
         if(this.mcSkipButton)
         {
            this.mcSkipButton.enabled = param1;
            this.mcSkipButton.visible = param1;
            this.mcLoading.visible = !param1;
            if(param1)
            {
               this.textField.htmlText = "";
            }
            else
            {
               this.textField.htmlText = "[[panel_loading_screen_loading]]";
            }
         }
      }
   }
}
