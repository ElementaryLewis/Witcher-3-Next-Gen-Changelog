package red.game.witcher3.menus.infopopup
{
   import flash.display.MovieClip;
   import red.core.CoreComponent;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.W3GamepadButton;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.ButtonEvent;
   
   public class InformationPopup extends CoreComponent
   {
       
      
      public var mcTextArea:W3TextArea;
      
      public var btnFirst:W3GamepadButton;
      
      public var btnSecond:W3GamepadButton;
      
      public var mcTextAreaBck:MovieClip;
      
      public var bTwoButtons:Boolean;
      
      public function InformationPopup()
      {
         super();
         _inputHandlers = new Vector.<UIComponent>();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.btnFirst.label = "[[panel_button_common_close]]";
         this.btnFirst.navigationCode = NavigationCode.GAMEPAD_A;
         this.btnFirst.addEventListener(ButtonEvent.CLICK,this.handleButtonOne,false,150,true);
         _inputHandlers.push(this.btnFirst);
         this.btnSecond.visible = false;
         this.arrangeButtons(false);
         this.bTwoButtons = false;
         visible = false;
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"popup.info.text",[this.handleSetPopupText]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"popup.info.button1",[this.SetFirstButton]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"popup.info.button2",[this.SetSecondButton]));
      }
      
      private function handleSetPopupText(param1:String) : void
      {
         this.mcTextArea.textField.htmlText = param1;
         visible = true;
      }
      
      private function SetFirstButton(param1:Object, param2:int) : void
      {
         var _loc3_:Array = null;
         if(param1)
         {
            _loc3_ = param1 as Array;
            this.btnFirst.label = _loc3_[0].label;
            this.btnFirst.navigationCode = _loc3_[0].icon;
            this.btnFirst.addEventListener(ButtonEvent.CLICK,this.handleButtonOne,false,150,true);
            _inputHandlers.push(this.btnFirst);
         }
      }
      
      private function SetSecondButton(param1:Object, param2:int) : void
      {
         var _loc3_:Array = null;
         if(param1)
         {
            _loc3_ = param1 as Array;
            this.btnSecond.label = _loc3_[0].label;
            this.btnSecond.navigationCode = _loc3_[0].icon;
            this.arrangeButtons(true);
            this.btnSecond.visible = true;
            this.bTwoButtons = true;
            this.btnSecond.addEventListener(ButtonEvent.CLICK,this.handleButtonTwo,false,150,true);
            _inputHandlers.push(this.btnSecond);
         }
      }
      
      private function handleButtonOne(param1:ButtonEvent) : void
      {
         param1.stopImmediatePropagation();
      }
      
      private function handleButtonTwo(param1:ButtonEvent) : void
      {
         param1.stopImmediatePropagation();
      }
      
      private function arrangeButtons(param1:Boolean) : void
      {
         if(param1)
         {
            this.btnFirst.x = this.mcTextArea.x + this.mcTextArea.width / 3;
            this.btnSecond.x = this.mcTextArea.x + 2 * (this.mcTextArea.width / 3);
         }
         else
         {
            this.btnFirst.x = this.mcTextArea.x + this.mcTextArea.width / 2;
         }
      }
      
      override public function toString() : String
      {
         return "[W3 InformationPopup: ]";
      }
   }
}
