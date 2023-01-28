package
{
   import flash.display.MovieClip;
   
   public dynamic class classEnemy extends MovieClip
   {
       
      
      public function classEnemy()
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
