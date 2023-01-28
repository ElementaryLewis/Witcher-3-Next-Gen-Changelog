package
{
   import red.game.witcher3.controls.TooltipAnchor;
   
   public dynamic class AnchorResearchRef extends TooltipAnchor
   {
       
      
      public function AnchorResearchRef()
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
