package red.game.witcher3.menus.worldmap
{
   import scaleform.clik.events.InputEvent;
   
   public class InteriorMap extends BaseMap
   {
       
      
      public function InteriorMap()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      private function Clear() : *
      {
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         if(param1.handled || !IsEnabled())
         {
            return;
         }
      }
   }
}
