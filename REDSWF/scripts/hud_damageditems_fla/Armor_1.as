package hud_damageditems_fla
{
   import flash.display.MovieClip;
   
   public dynamic class Armor_1 extends MovieClip
   {
       
      
      public function Armor_1()
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
