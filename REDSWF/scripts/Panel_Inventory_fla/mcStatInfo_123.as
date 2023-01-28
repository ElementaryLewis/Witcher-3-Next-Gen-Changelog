package Panel_Inventory_fla
{
   import flash.display.MovieClip;
   
   public dynamic class mcStatInfo_123 extends MovieClip
   {
       
      
      public var txfStats:MovieClip;
      
      public var mcChangedHighlight:MovieClip;
      
      public function mcStatInfo_123()
      {
         super();
         addFrameScript(0,this.frame1,6,this.frame7,7,this.frame8,26,this.frame27);
      }
      
      internal function frame1() : *
      {
         this.mcChangedHighlight.visible = false;
      }
      
      internal function frame7() : *
      {
         stop();
      }
      
      internal function frame8() : *
      {
         this.mcChangedHighlight.visible = true;
      }
      
      internal function frame27() : *
      {
         gotoAndPlay("Normal");
      }
   }
}
