package red.game.witcher3.popups.test
{
   import red.core.CorePopup;
   import red.core.events.GameEvent;
   
   public class TestPopup extends CorePopup
   {
       
      
      public function TestPopup()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      override protected function get popupName() : String
      {
         return "TestPopup";
      }
      
      public function CloseMenu() : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnClosePopup"));
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
