package
{
   import red.game.witcher3.controls.TooltipAnchor;
   
   public dynamic class TooltipAnchorRef extends TooltipAnchor
   {
       
      
      public function TooltipAnchorRef()
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