package panel_enchanting_fla
{
   import flash.display.MovieClip;
   
   public dynamic class PinnedCraftingItemInfoRendererSmall_animatedHighlight_84 extends MovieClip
   {
       
      
      public var mcHighlight:MovieClip;
      
      public function PinnedCraftingItemInfoRendererSmall_animatedHighlight_84()
      {
         super();
         addFrameScript(0,this.frame1,29,this.frame30);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame30() : *
      {
         gotoAndPlay("active");
      }
   }
}
