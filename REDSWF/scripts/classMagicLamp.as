package
{
   import flash.display.MovieClip;
   
   public dynamic class classMagicLamp extends MovieClip
   {
       
      
      public function classMagicLamp()
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
