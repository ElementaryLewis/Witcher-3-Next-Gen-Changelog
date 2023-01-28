package hud_buffs_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class mc_buff_stack_indicator_17 extends MovieClip
   {
       
      
      public var tfBuffStack:TextField;
      
      public var mcStackBackground:MovieClip;
      
      public function mc_buff_stack_indicator_17()
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
