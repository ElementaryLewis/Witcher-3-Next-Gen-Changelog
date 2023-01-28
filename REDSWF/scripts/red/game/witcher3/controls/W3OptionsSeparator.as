package red.game.witcher3.controls
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class W3OptionsSeparator extends MovieClip
   {
       
      
      public var label:TextField;
      
      public var leftLine:MovieClip;
      
      public var rightLine:MovieClip;
      
      public function W3OptionsSeparator()
      {
         super();
      }
      
      override public function set width(param1:Number) : void
      {
         this.label.width = this.label.textWidth;
         var _loc2_:int = param1 - this.label.textWidth;
         var _loc3_:int = 5;
         var _loc4_:int = 15;
         if(this.label.textWidth == 0)
         {
            this.rightLine.visible = false;
            this.leftLine.width = _loc2_;
         }
         else
         {
            this.leftLine.width = _loc2_ / 2 - _loc3_;
            this.rightLine.width = _loc2_ / 2 - _loc4_;
            this.leftLine.x = 0;
            this.label.x = this.leftLine.width + _loc3_;
            this.rightLine.x = this.leftLine.width + this.label.textWidth + _loc4_;
         }
      }
      
      override public function set height(param1:Number) : void
      {
         this.label.height = param1;
      }
   }
}
