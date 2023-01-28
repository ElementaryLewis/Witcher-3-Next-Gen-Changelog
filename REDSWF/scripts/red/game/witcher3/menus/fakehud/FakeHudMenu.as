package red.game.witcher3.menus.fakehud
{
   import red.core.CoreMenu;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class FakeHudMenu extends CoreMenu
   {
       
      
      public function FakeHudMenu()
      {
         addFrameScript(0,this.frame1);
         super();
      }
      
      override protected function get menuName() : String
      {
         return "FakeHudMenu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = param1.details;
         var _loc3_:Boolean = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
         if(_loc3_)
         {
            switch(_loc2_.code)
            {
               case KeyCode.O:
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnCloseMenu"));
                  return;
               default:
                  switch(_loc2_.navEquivalent)
                  {
                     case NavigationCode.GAMEPAD_B:
                        dispatchEvent(new GameEvent(GameEvent.CALL,"OnCloseMenu"));
                        return;
                  }
            }
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
