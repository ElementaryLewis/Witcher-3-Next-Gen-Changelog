package red.game.witcher3.data
{
   public class KeyBindingData
   {
       
      
      public var actionId:uint;
      
      public var gamepad_navEquivalent:String = "";
      
      public var keyboard_keyCode:int;
      
      public var label:String;
      
      public var level:int;
      
      public var isContextBinding:Boolean;
      
      public var gamepad_keyCode:int = -1;
      
      public var disabled:Boolean;
      
      public var contextId:int;
      
      public var holdDuration:Number;
      
      public var hasHoldPrefix:Boolean;
      
      public var altKeyCode:int;
      
      public function KeyBindingData()
      {
         super();
      }
      
      public function toString() : String
      {
         return "[KeyBindingData: " + this.label + " " + this.keyboard_keyCode + " " + this.gamepad_navEquivalent + " ]";
      }
   }
}
