package
{
   import red.game.witcher3.hud.modules.buffs.HudBuffDurationBar;
   
   public dynamic class BuffCircle extends HudBuffDurationBar
   {
       
      
      public function BuffCircle()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
