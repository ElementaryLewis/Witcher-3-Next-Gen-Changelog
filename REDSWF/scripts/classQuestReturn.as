package
{
   import flash.display.MovieClip;
   
   public dynamic class classQuestReturn extends MovieClip
   {
       
      
      public function classQuestReturn()
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
