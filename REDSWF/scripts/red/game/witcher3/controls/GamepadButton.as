package red.game.witcher3.controls
{
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.controls.Button;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class GamepadButton extends Button
   {
       
      
      protected var _navigationCode:String;
      
      public function GamepadButton()
      {
         super();
      }
      
      public function get navigationCode() : String
      {
         return this._navigationCode;
      }
      
      public function set navigationCode(param1:String) : void
      {
         this._navigationCode = param1;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         focusable = false;
      }
      
      override public function setActualSize(param1:Number, param2:Number) : void
      {
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         if(param1.isDefaultPrevented())
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         var _loc3_:* = _loc2_.controllerIndex;
         if(_loc2_.navEquivalent != this._navigationCode)
         {
            return;
         }
         if(_loc2_.value == InputValue.KEY_DOWN)
         {
            this.handlePress(_loc3_);
            param1.handled = true;
         }
         else if(_loc2_.value == InputValue.KEY_UP)
         {
            if(_pressedByKeyboard)
            {
               this.handleRelease(_loc3_);
               param1.handled = true;
            }
         }
      }
      
      override protected function handlePress(param1:uint = 0) : void
      {
         if(!enabled)
         {
            return;
         }
         _pressedByKeyboard = true;
         setState(_focusIndicator == null ? "down" : "kb_down");
         var _loc2_:ButtonEvent = new ButtonEvent(ButtonEvent.CLICK,true,false,param1,0,true,false);
         dispatchEvent(_loc2_);
      }
      
      override protected function handleRelease(param1:uint = 0) : void
      {
         if(!enabled)
         {
            return;
         }
         setState(focusIndicator == null ? "release" : "kb_release");
         _pressedByKeyboard = false;
      }
      
      override public function toString() : String
      {
         return "[W3 GamepadButton" + name + ", navigation code " + this._navigationCode;
      }
   }
}
