package panel_credits_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class Section_2 extends MovieClip
   {
       
      
      public var tfCurrent:TextField;
      
      public function Section_2()
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
