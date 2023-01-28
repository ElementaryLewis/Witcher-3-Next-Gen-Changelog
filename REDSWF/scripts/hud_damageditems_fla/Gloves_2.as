package hud_damageditems_fla
{
   import flash.display.MovieClip;
   
   public dynamic class Gloves_2 extends MovieClip
   {
       
      
      public function Gloves_2()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}
