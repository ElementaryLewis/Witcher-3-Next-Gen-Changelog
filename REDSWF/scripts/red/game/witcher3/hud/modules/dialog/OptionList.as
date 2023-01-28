package red.game.witcher3.hud.modules.dialog
{
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.managers.InputManager;
   
   public class OptionList extends W3ScrollingList
   {
       
      
      public function OptionList()
      {
         super();
      }
      
      override public function trySelectingIndex(param1:int) : *
      {
         if(!InputManager.getInstance().isGamepad())
         {
            selectedIndex = param1;
         }
      }
   }
}
