package red.game.witcher3.tooltips
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.core.UIComponent;
   
   public class TooltipMap extends UIComponent
   {
       
      
      private const TITLE_PADDING:Number = 25;
      
      private const TITLE_MAX_WIDTH_FOR_TRACKED:Number = 460;
      
      private const TITLE_MAX_WIDTH:Number = 520;
      
      private const TRACKER_DEFAULT_Y:Number = 10;
      
      private const PADDING_LEFT:Number = 15;
      
      private const PADDING_BOTTOM:Number = 35;
      
      private const TEXT_BLOCK_PADDING:Number = 4;
      
      private const TRACKED_BLOCK_PADDING:Number = 6;
      
      public var txtTitle:TextField;
      
      public var txtDescription:TextField;
      
      public var txtTracked:TextField;
      
      public var trackIndicator:MovieClip;
      
      public var trackedBackground:MovieClip;
      
      public var delimiterLine:MovieClip;
      
      public var background:MovieClip;
      
      protected var _data:Object;
      
      public function TooltipMap()
      {
         super();
         this.txtTracked.text = "[[panel_journal_legend_tracked]]";
         this.txtTracked.width = this.txtTracked.textWidth + CommonConstants.SAFE_TEXT_PADDING;
         this.txtTracked.visible = false;
         this.trackIndicator.visible = false;
         this.trackedBackground.width = this.trackIndicator.width + this.txtTracked.textWidth + this.TITLE_PADDING;
         this.trackedBackground.visible = false;
         mouseChildren = mouseEnabled = false;
         visible = false;
      }
      
      public function ShowTooltip(param1:Object, param2:Boolean) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc6_:String = null;
         this._data = param1;
         if(this._data)
         {
            _loc3_ = Boolean(this._data.tracked);
            _loc4_ = _loc3_ ? this.TITLE_MAX_WIDTH_FOR_TRACKED : this.TITLE_MAX_WIDTH + CommonConstants.SAFE_TEXT_PADDING;
            _loc5_ = param2 ? "<p align=\"right\">" + this._data.title + "</p>" : String(this._data.title);
            _loc6_ = param2 ? "<p align=\"right\">" + this._data.description + "</p>" : String(this._data.description);
            this.txtTitle.multiline = false;
            this.txtTitle.wordWrap = false;
            this.txtTitle.htmlText = this._data.title;
            this.txtTitle.htmlText = CommonUtils.toUpperCaseSafe(this.txtTitle.htmlText);
            if(this.txtTitle.textWidth > _loc4_)
            {
               this.txtTitle.multiline = true;
               this.txtTitle.wordWrap = true;
            }
            this.txtTitle.height = this.txtTitle.textHeight + CommonConstants.SAFE_TEXT_PADDING;
            this.txtDescription.htmlText = _loc6_;
            this.txtDescription.height = this.txtDescription.textHeight + CommonConstants.SAFE_TEXT_PADDING;
            this.delimiterLine.y = this.txtTitle.y + this.txtTitle.textHeight + this.TEXT_BLOCK_PADDING;
            this.txtDescription.y = this.delimiterLine.y + this.TEXT_BLOCK_PADDING;
            if(param2)
            {
               if(_loc3_)
               {
                  this.txtTracked.x = this.trackIndicator.x - this.txtTracked.width;
               }
            }
            else if(_loc3_)
            {
               this.txtTracked.x = this.trackIndicator.x + this.trackIndicator.width;
            }
            this.trackIndicator.visible = _loc3_;
            this.txtTracked.visible = _loc3_;
            this.trackedBackground.visible = _loc3_;
            this.background.height = this.txtDescription.height + this.txtTitle.height + this.PADDING_BOTTOM;
            visible = true;
         }
         else
         {
            visible = false;
         }
      }
      
      public function HideTooltip() : void
      {
         visible = false;
      }
   }
}
