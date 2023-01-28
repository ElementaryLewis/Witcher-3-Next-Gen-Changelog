package red.game.witcher3.menus.meditation_menu
{
   import red.core.CoreMenu;
   import red.core.events.GameEvent;
   
   public class MenuMeditation extends CoreMenu
   {
       
      
      public function MenuMeditation()
      {
         super();
      }
      
      override protected function get menuName() : String
      {
         return "MeditationMenu";
      }
      
      override protected function configUI() : void
      {
         trace("GFX ------------------------ ");
         trace("GFX [MenuMeditation] configUI");
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
   }
}
