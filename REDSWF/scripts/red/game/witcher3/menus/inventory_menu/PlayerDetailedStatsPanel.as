package red.game.witcher3.menus.inventory_menu
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Sine;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.menus.common.AdaptiveStatsListItem;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.core.UIComponent;
   
   public class PlayerDetailedStatsPanel extends UIComponent
   {
       
      
      private const RENDERER_CLASS_REF:String = "AdaptiveStatsListItem_Ref";
      
      private const TIME_TEXT_PADDING:Number = 10;
      
      private const ANIM_OFFSET:Number = 5;
      
      private const PANEL_PADDING:Number = 145;
      
      public var mcAnchor:MovieClip;
      
      public var tfTimeLabel:TextField;
      
      public var tfHoursValue:TextField;
      
      public var tfMinutesValue:TextField;
      
      public var tfHoursLabel:TextField;
      
      public var tfMinutesLabel:TextField;
      
      private var _renderersList:Vector.<AdaptiveStatsListItem>;
      
      private var _data:Array;
      
      private var _canvas:Sprite;
      
      private var _maxValueTextSize:Number = 0;
      
      public function PlayerDetailedStatsPanel()
      {
         super();
         this._renderersList = new Vector.<AdaptiveStatsListItem>();
         this._canvas = new Sprite();
         this._canvas.x = this.mcAnchor.x;
         this._canvas.y = this.mcAnchor.y;
         addChild(this._canvas);
         this.tfHoursLabel.text = "[[time_hours]]";
         this.tfMinutesLabel.text = "[[time_minutes]]";
      }
      
      public function setTimeData(param1:String, param2:String) : void
      {
         this.tfTimeLabel.text = "[[message_total_play_time]]";
         this.tfTimeLabel.text = CommonUtils.toUpperCaseSafe(this.tfTimeLabel.text);
         this.tfTimeLabel.width = this.tfTimeLabel.textWidth + CommonConstants.SAFE_TEXT_PADDING;
         this.tfHoursValue.htmlText = param1;
         this.tfHoursValue.htmlText = CommonUtils.toUpperCaseSafe(this.tfHoursValue.htmlText);
         this.tfMinutesValue.htmlText = param2;
         this.tfMinutesValue.htmlText = CommonUtils.toUpperCaseSafe(this.tfMinutesValue.htmlText);
         var _loc3_:Number = Math.max(this.tfMinutesValue.textWidth,this.tfHoursValue.textWidth);
         this.tfHoursValue.width = _loc3_ + CommonConstants.SAFE_TEXT_PADDING;
         this.tfMinutesValue.width = _loc3_ + CommonConstants.SAFE_TEXT_PADDING;
         this.tfHoursValue.x = this.tfMinutesValue.x = this.tfTimeLabel.x + this.tfTimeLabel.width + this.TIME_TEXT_PADDING;
         this.tfHoursLabel.x = this.tfMinutesLabel.x = this.tfMinutesValue.x + this.tfMinutesValue.width + this.TIME_TEXT_PADDING;
      }
      
      public function setData(param1:Array) : void
      {
         this.data = param1;
      }
      
      public function get data() : Array
      {
         return this._data;
      }
      
      public function set data(param1:Array) : void
      {
         if(!this._data)
         {
            this._data = param1;
            this.cleanupRenderers();
            this.createRenderers();
         }
         else
         {
            this._data = param1;
            GTweener.removeTweens(this._canvas);
            GTweener.to(this._canvas,0.2,{"alpha":0},{
               "ease":Sine.easeIn,
               "onComplete":this.handleCanvasHidden
            });
         }
      }
      
      private function handleCanvasHidden(param1:GTween) : void
      {
         this.cleanupRenderers();
         this.createRenderers();
         GTweener.removeTweens(this._canvas);
         GTweener.to(this._canvas,0.2,{"alpha":1},{"ease":Sine.easeOut});
      }
      
      private function createRenderers() : void
      {
         var _loc10_:AdaptiveStatsListItem = null;
         var _loc11_:Number = NaN;
         if(!this._data)
         {
            return;
         }
         var _loc1_:* = 8;
         var _loc2_:* = 20;
         var _loc3_:* = 0;
         var _loc4_:* = 20;
         var _loc5_:int = int(this._data.length);
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         var _loc8_:Class = getDefinitionByName(this.RENDERER_CLASS_REF) as Class;
         this._maxValueTextSize = 0;
         var _loc9_:int = 0;
         while(_loc9_ < _loc5_)
         {
            _loc10_ = new _loc8_() as AdaptiveStatsListItem;
            _loc7_ = 0;
            if(this._data[_loc9_].tag == "Header")
            {
               _loc6_ += _loc1_;
            }
            else if(this._data[_loc9_].tag == "SuperHeader")
            {
               _loc7_ += _loc2_;
            }
            _loc10_.setData(this._data[_loc9_]);
            _loc10_.validateNow();
            _loc10_.visible = true;
            _loc10_.y = _loc6_;
            _loc11_ = _loc10_.tfStatValue.textWidth + _loc4_;
            if(this._maxValueTextSize < _loc11_)
            {
               this._maxValueTextSize = _loc11_;
            }
            this._canvas.addChild(_loc10_);
            this._renderersList.push(_loc10_);
            _loc6_ += _loc10_.rendererHeight + _loc3_ + _loc7_;
            _loc9_++;
         }
         this._renderersList.forEach(this.setRendererTextPosition);
         this._canvas.x = this.mcAnchor.x - this._canvas.width + this.PANEL_PADDING;
      }
      
      private function setRendererTextPosition(param1:AdaptiveStatsListItem) : void
      {
         if(param1)
         {
            param1.textField.x = this._maxValueTextSize;
         }
      }
      
      private function cleanupRenderers() : void
      {
         while(this._renderersList.length)
         {
            this._canvas.removeChild(this._renderersList.pop());
         }
      }
   }
}
