package red.game.witcher3.tooltips
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.managers.ContextInfoManager;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InvalidationType;
   import scaleform.clik.core.UIComponent;
   
   public class TooltipBase extends UIComponent
   {
       
      
      protected var INVALIDATE_PADDING:String = "padding";
      
      protected var INVALIDATE_POSITION:String = "position";
      
      protected var _internalVisibility:Boolean = true;
      
      protected var _shown:Boolean;
      
      protected var _populated:Boolean;
      
      protected var _expanded:Boolean;
      
      protected var isArabicAligmentMode:Boolean;
      
      protected var _backgroundVisibility:Boolean;
      
      protected var _actualPosition:Point;
      
      protected var _anchorRect:Rectangle;
      
      protected var _defaultHeight:Number;
      
      protected var _cachedExtraWidth:Number = 0;
      
      protected var _isMouseTooltip:Boolean;
      
      protected var _lockFixedPosition:Boolean;
      
      protected var _visibility:Boolean = true;
      
      protected var _data;
      
      protected var _tweenerShow:GTween;
      
      protected var _tweenerScale:GTween;
      
      protected var _contextMgr:ContextInfoManager;
      
      protected var _tooltipAlignment:String = "Right";
      
      private var tempStr:String;
      
      public function TooltipBase()
      {
         super();
         this._actualPosition = new Point();
         this._defaultHeight = height;
         this._contextMgr = ContextInfoManager.getInstanse();
      }
      
      public function get backgroundVisibility() : Boolean
      {
         return this._backgroundVisibility;
      }
      
      public function set backgroundVisibility(param1:Boolean) : void
      {
         this._backgroundVisibility = param1;
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function set data(param1:*) : void
      {
         this._data = param1;
         invalidateData();
      }
      
      public function get anchorRect() : Rectangle
      {
         return this._anchorRect;
      }
      
      public function set anchorRect(param1:Rectangle) : void
      {
         this._anchorRect = param1;
      }
      
      public function get expanded() : Boolean
      {
         return this._expanded;
      }
      
      public function set expanded(param1:Boolean) : void
      {
         if(this._expanded != param1)
         {
            this._expanded = param1;
            if(this.actualHeight > this._defaultHeight)
            {
               this.expandTooltip();
            }
         }
      }
      
      public function setVisibility(param1:Boolean) : void
      {
         this._visibility = param1;
         this.updateVisibility();
      }
      
      public function toggleVisibility() : void
      {
         this._visibility = !this._visibility;
         this.updateVisibility();
      }
      
      public function get tooltipAlignment() : String
      {
         return this._tooltipAlignment;
      }
      
      public function set tooltipAlignment(param1:String) : void
      {
         this._tooltipAlignment = param1;
      }
      
      public function get isMouseTooltip() : Boolean
      {
         return this._isMouseTooltip;
      }
      
      public function set isMouseTooltip(param1:Boolean) : void
      {
         this._isMouseTooltip = param1;
      }
      
      public function get lockFixedPosition() : Boolean
      {
         return this._lockFixedPosition;
      }
      
      public function set lockFixedPosition(param1:Boolean) : void
      {
         this._lockFixedPosition = param1;
         if(!stage)
         {
            addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage,false,0,true);
         }
         else
         {
            invalidate(this.INVALIDATE_POSITION);
         }
      }
      
      public function stopSafeRectCheck(param1:Boolean = false) : void
      {
      }
      
      public function updateSafeRectCheck() : void
      {
      }
      
      public function getPositionAfterScale(param1:Number = -1) : Point
      {
         return new Point(x,y);
      }
      
      override public function set visible(param1:Boolean) : void
      {
         this._internalVisibility = param1;
         this.updateVisibility();
      }
      
      protected function updateVisibility() : void
      {
         super.visible = this._internalVisibility && this._visibility;
      }
      
      override protected function draw() : void
      {
         super.draw();
         if(isInvalid(InvalidationType.DATA))
         {
            this.populateData();
         }
         if(isInvalid(InvalidationType.SIZE))
         {
            this.updateSize();
         }
         if(isInvalid(this.INVALIDATE_POSITION))
         {
            this.updatePosition();
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         mouseEnabled = mouseChildren = false;
         InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChange,false,0,true);
      }
      
      protected function showAnimation() : void
      {
         alpha = 0;
         this._tweenerShow = GTweener.to(this,0.2,{"alpha":1},{"ease":Exponential.easeOut});
      }
      
      protected function handleAddedToStage(param1:Event) : void
      {
         this.invalidatePosition();
      }
      
      protected function invalidatePosition() : void
      {
         this.updatePosition();
         invalidate(this.INVALIDATE_POSITION);
         invalidateSize();
      }
      
      protected function updatePosition() : void
      {
         this.applyPositioning();
         x = this._actualPosition.x;
         y = this._actualPosition.y;
      }
      
      protected function applyPositioning() : void
      {
         var _loc1_:Point = null;
         if(this._anchorRect)
         {
            _loc1_ = new Point(this._anchorRect.x,this._anchorRect.y);
            this._actualPosition.x = _loc1_.x + this._anchorRect.width;
            this._actualPosition.y = _loc1_.y + this._anchorRect.height;
         }
         else
         {
            if(!this._lockFixedPosition)
            {
               _loc1_ = new Point(0,0);
               throw new Error(" Missing anchor for tooltip");
            }
            this._actualPosition.x = this.x;
            this._actualPosition.y = this.y;
         }
      }
      
      protected function populateData() : void
      {
         this._populated = true;
         invalidateSize();
         invalidate(this.INVALIDATE_POSITION);
      }
      
      protected function updateSize() : void
      {
         invalidate(this.INVALIDATE_POSITION);
         if(!this._shown)
         {
            this._shown = true;
            this.showAnimation();
         }
      }
      
      protected function handleControllerChange(param1:ControllerChangeEvent) : void
      {
      }
      
      protected function expandTooltip(param1:Boolean = true) : void
      {
      }
      
      protected function getExtraHeight() : Number
      {
         return 0;
      }
      
      protected function applyTextValue(param1:TextField, param2:String, param3:Boolean, param4:Boolean = false) : void
      {
         this.tempStr = param2;
         if(!param1 || !param2)
         {
            if(param1)
            {
               param1.htmlText = "";
               param1.visible = false;
            }
            return;
         }
         param1.visible = true;
         param1.htmlText = this.tempStr;
         if(param4 && this._contextMgr.isArabicAligmentMode)
         {
            param1.htmlText = "<p align=\"right\">" + this.tempStr + "</p>";
         }
         else if(param3)
         {
            param1.htmlText = CommonUtils.toUpperCaseSafe(param1.htmlText);
         }
         param1.height = param1.textHeight + CommonConstants.SAFE_TEXT_PADDING;
      }
   }
}
