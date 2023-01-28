package red.game.witcher3.menus.startup
{
   import red.core.CoreMenu;
   import red.core.events.GameEvent;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class Startup1Menu extends CoreMenu
   {
       
      
      public function Startup1Menu()
      {
         addFrameScript(0,this.frame1);
         super();
      }
      
      override protected function get menuName() : String
      {
         return "Startup1Menu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         if(param1.handled)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         var _loc3_:Boolean = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
         if(_loc3_)
         {
            switch(_loc2_.navEquivalent)
            {
               case NavigationCode.GAMEPAD_A:
               case NavigationCode.GAMEPAD_B:
               case NavigationCode.GAMEPAD_X:
               case NavigationCode.GAMEPAD_Y:
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnCloseMenu"));
                  return;
            }
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
