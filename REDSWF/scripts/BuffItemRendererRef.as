package
{
   import red.game.witcher3.hud.modules.buffs.HudBuff;
   
   public dynamic class BuffItemRendererRef extends HudBuff
   {
       
      
      public function BuffItemRendererRef()
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
