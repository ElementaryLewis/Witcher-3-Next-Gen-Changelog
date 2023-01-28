package
{
   import flash.display.MovieClip;
   
   public dynamic class classHarbor extends MovieClip
   {
       
      
      public function classHarbor()
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
