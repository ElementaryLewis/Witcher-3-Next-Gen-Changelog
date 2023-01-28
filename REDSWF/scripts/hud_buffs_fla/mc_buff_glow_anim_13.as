package hud_buffs_fla
{
   import flash.display.MovieClip;
   
   public dynamic class mc_buff_glow_anim_13 extends MovieClip
   {
       
      
      public function mc_buff_glow_anim_13()
      {
         super();
         addFrameScript(0,this.frame1,10,this.frame11);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame11() : *
      {
         gotoAndStop("start");
      }
   }
}
