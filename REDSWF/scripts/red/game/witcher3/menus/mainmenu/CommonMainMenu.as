package red.game.witcher3.menus.mainmenu
{
   import red.core.CoreMenu;
   import red.core.events.GameEvent;
   import scaleform.clik.events.InputEvent;
   
   public class CommonMainMenu extends CoreMenu
   {
       
      
      public function CommonMainMenu()
      {
         super();
         SHOW_ANIM_OFFSET = 0;
         SHOW_ANIM_DURATION = 2;
      }
      
      override protected function get menuName() : String
      {
         return "CommonMainMenu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      override protected function handleInputNavigate(param1:InputEvent) : void
      {
      }
   }
}
