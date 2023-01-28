package
{
   import flash.display.MovieClip;
   
   public dynamic class classPlayerStash extends MovieClip
   {
       
      
      public function classPlayerStash()
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
