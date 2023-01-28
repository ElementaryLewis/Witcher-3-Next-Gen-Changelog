package red.game.witcher3.menus.mainmenu
{
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class CommonIngameMenu extends CommonMainMenu
   {
       
      
      public function CommonIngameMenu()
      {
         super();
         SHOW_ANIM_OFFSET = 0;
         SHOW_ANIM_DURATION = 2;
      }
      
      override protected function get menuName() : String
      {
         return "CommonIngameMenu";
      }
      
      override protected function handleInputNavigate(param1:InputEvent) : void
      {
         super.handleInput(param1);
         var _loc2_:InputDetails = param1.details;
         var _loc3_:* = _loc2_.value == InputValue.KEY_DOWN;
         var _loc4_:* = _loc2_.value == InputValue.KEY_UP;
         if(!param1.handled)
         {
            if(_loc4_ && !_restrictDirectClosing)
            {
               switch(_loc2_.navEquivalent)
               {
                  case NavigationCode.GAMEPAD_START:
                  case NavigationCode.GAMEPAD_BACK:
                     closeMenu();
                     return;
               }
            }
         }
      }
   }
}
