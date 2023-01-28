package red.game.witcher3.menus.common
{
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.controls.Button;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class DownloadButton extends Button
   {
       
      
      public var gamepadButton:String;
      
      public var keyboardButton:uint;
      
      public function DownloadButton()
      {
         super();
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = param1.details;
         if(_loc2_.value == InputValue.KEY_DOWN && this.IsButtonPressed(_loc2_))
         {
            this.handlePress();
            param1.handled = true;
         }
         else if(_loc2_.value == InputValue.KEY_UP && this.IsButtonPressed(_loc2_))
         {
            this.handleRelease();
            param1.handled = true;
         }
      }
      
      private function IsButtonPressed(param1:InputDetails) : Boolean
      {
         return param1.navEquivalent == this.gamepadButton || param1.code == this.keyboardButton;
      }
   }
}
