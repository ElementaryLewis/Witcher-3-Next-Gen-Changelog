package
{
   import flash.display.MovieClip;
   
   public dynamic class classTeleport extends MovieClip
   {
       
      
      public function classTeleport()
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
