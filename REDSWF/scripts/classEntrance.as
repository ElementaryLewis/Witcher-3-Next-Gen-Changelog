package
{
   import flash.display.MovieClip;
   
   public dynamic class classEntrance extends MovieClip
   {
       
      
      public function classEntrance()
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
