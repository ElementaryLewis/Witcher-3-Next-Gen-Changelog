package red.game.witcher3.menus.endscreen
{
   import red.game.witcher3.menus.startscreen.StartScreenMenu;
   import scaleform.clik.events.InputEvent;
   
   public class EndScreenMenu extends StartScreenMenu
   {
       
      
      public function EndScreenMenu()
      {
         addFrameScript(0,this.frame1);
         super();
      }
      
      override protected function get menuName() : String
      {
         return "EndScreenMenu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
