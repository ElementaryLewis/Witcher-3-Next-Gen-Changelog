package
{
   import flash.display.MovieClip;
   
   public dynamic class classBoat extends MovieClip
   {
       
      
      public function classBoat()
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
