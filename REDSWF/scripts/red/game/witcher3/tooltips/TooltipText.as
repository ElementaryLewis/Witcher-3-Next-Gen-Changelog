package red.game.witcher3.tooltips
{
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class TooltipText extends TooltipBase
   {
       
      
      public var background:Sprite;
      
      public var tfDescription:TextField;
      
      protected var _maxWidth:Number = 500;
      
      protected var _minWidth:Number = 50;
      
      public function TooltipText()
      {
         super();
         this.background.mouseChildren = this.background.mouseEnabled = false;
         this.tfDescription.mouseEnabled = false;
      }
      
      public function get maxWidth() : Number
      {
         return this._maxWidth;
      }
      
      public function set maxWidth(param1:Number) : void
      {
         this._maxWidth = param1;
         invalidateSize();
      }
      
      public function get minWidth() : Number
      {
         return this._minWidth;
      }
      
      public function set minWidth(param1:Number) : void
      {
         this._minWidth = param1;
         invalidateSize();
      }
      
      override protected function populateData() : void
      {
         super.populateData();
         this.tfDescription.htmlText = String(_data);
      }
      
      override protected function updateSize() : void
      {
         var _loc1_:Number = this.tfDescription.textWidth + _padding.left + _padding.right;
         this.tfDescription.width = Math.max(Math.min(_loc1_,this._maxWidth),this._minWidth);
         this.tfDescription.height = this.tfDescription.textHeight;
         this.background.width = this.tfDescription.width + _padding.left + _padding.right;
         this.background.height = this.tfDescription.height + _padding.top + _padding.bottom;
         this.tfDescription.x = _padding.left;
         this.tfDescription.y = _padding.top;
         super.updateSize();
      }
   }
}
