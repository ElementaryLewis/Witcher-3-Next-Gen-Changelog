package red.game.witcher3.controls
{
   import flash.display.MovieClip;
   
   public class InvisibleComponent extends MovieClip
   {
       
      
      public function InvisibleComponent()
      {
         super();
         visible = mouseChildren = mouseEnabled = false;
      }
   }
}
