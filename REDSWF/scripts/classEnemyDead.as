package
{
   import flash.display.MovieClip;
   
   public dynamic class classEnemyDead extends MovieClip
   {
       
      
      public function classEnemyDead()
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
