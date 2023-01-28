package red.game.witcher3.hud.modules.wolfHead
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class WolfMedallion extends MovieClip
   {
       
      
      public var mcWolfGlow:MovieClip;
      
      private var m_shouldStop:Boolean;
      
      public function WolfMedallion()
      {
         super();
         this.mcWolfGlow.gotoAndStop(1);
      }
      
      public function StartGlow() : *
      {
         this.mcWolfGlow.gotoAndPlay("play");
         this.m_shouldStop = false;
         addEventListener(Event.ENTER_FRAME,this.Update);
      }
      
      public function StopGlow() : *
      {
         this.m_shouldStop = true;
      }
      
      public function Update(param1:Event) : *
      {
         if(this.m_shouldStop && this.mcWolfGlow.currentFrame == 1)
         {
            this.mcWolfGlow.gotoAndStop(1);
            removeEventListener(Event.ENTER_FRAME,this.Update);
         }
      }
      
      public function SetMedalionGraphic(param1:String) : *
      {
         gotoAndStop(param1);
         this.mcWolfGlow = getChildByName("mcWolfGlow") as MovieClip;
         this.mcWolfGlow.gotoAndStop(1);
      }
   }
}
