package
{
   import flash.display.MovieClip;
   
   public dynamic class classNoticeBoard extends MovieClip
   {
       
      
      public function classNoticeBoard()
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
