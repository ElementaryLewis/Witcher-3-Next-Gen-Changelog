package
{
   import flash.display.MovieClip;
   
   public dynamic class classMonsterNest extends MovieClip
   {
       
      
      public function classMonsterNest()
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
