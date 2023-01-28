package
{
   import flash.display.MovieClip;
   
   public dynamic class classHerb extends MovieClip
   {
       
      
      public function classHerb()
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
