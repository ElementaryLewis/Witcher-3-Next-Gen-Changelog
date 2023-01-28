package red.game.witcher3.tooltips
{
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import red.core.constants.KeyCode;
   import red.game.witcher3.controls.RenderersList;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.managers.InputDelegate;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.Extensions;
   
   public class TooltipStatistic extends TooltipBase
   {
      
      protected static const SMOOTH_TWEEN:Boolean = true;
      
      protected static const ANIM_DURATION:Number = 1;
      
      protected static const SAFE_TEXT_PADDING:Number = 4;
      
      protected static const MODULE_PADDING:Number = 12;
      
      protected static const LIST_PADDING:Number = 10;
      
      protected static const MIN_BACKGROUND_HEIGHT:Number = 143;
       
      
      public var txtTitle:TextField;
      
      public var txtDescription:TextField;
      
      public var mcStatsList:RenderersList;
      
      public var contentMask:Sprite;
      
      public var background:Sprite;
      
      public var delemiter:Sprite;
      
      public var btnExpand:MovieClip;
      
      public function TooltipStatistic()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         if(!Extensions.isScaleform)
         {
            this.displayDebugData();
         }
         InputDelegate.getInstance().addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         super.handleInput(param1);
         if(param1.handled)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         if(_loc2_.value == InputValue.KEY_UP && _loc2_.code == KeyCode.PAD_LEFT_THUMB)
         {
            expanded = !_expanded;
         }
      }
      
      override protected function expandTooltip(param1:Boolean = true) : void
      {
         GTweener.removeTweens(this.contentMask);
         GTweener.removeTweens(this.delemiter);
         if(_expanded)
         {
            this.btnExpand.gotoAndStop(2);
            if(param1)
            {
               GTweener.to(this.contentMask,ANIM_DURATION,{"height":this.actualHeight},{"ease":Exponential.easeOut});
               GTweener.to(this.delemiter,ANIM_DURATION,{"y":this.actualHeight},{"ease":Exponential.easeOut});
            }
            else
            {
               this.contentMask.height = this.actualHeight;
               this.delemiter.y = this.actualHeight;
            }
         }
         else
         {
            this.btnExpand.gotoAndStop(1);
            if(param1)
            {
               GTweener.to(this.contentMask,ANIM_DURATION,{"height":_defaultHeight},{"ease":Exponential.easeOut});
               GTweener.to(this.delemiter,ANIM_DURATION,{"y":_defaultHeight},{"ease":Exponential.easeOut});
            }
            else
            {
               this.contentMask.height = _defaultHeight;
               this.delemiter.y = _defaultHeight;
            }
         }
         invalidate(INVALIDATE_POSITION);
      }
      
      override protected function populateData() : void
      {
         super.populateData();
         if(!_data)
         {
            return;
         }
         this.applyStatsData();
      }
      
      protected function applyStatsData() : void
      {
         var _loc1_:Number = MODULE_PADDING;
         this.txtTitle.htmlText = _data.title;
         this.txtTitle.htmlText = CommonUtils.toUpperCaseSafe(this.txtTitle.htmlText);
         this.txtDescription.htmlText = _data.description;
         this.txtDescription.height = this.txtDescription.textHeight + SAFE_TEXT_PADDING;
         _loc1_ += this.txtDescription.height;
         this.mcStatsList.dataList = _data.statsList as Array;
         this.mcStatsList.validateNow();
         this.mcStatsList.y = this.txtDescription.y + this.txtDescription.height + LIST_PADDING;
         _loc1_ += LIST_PADDING + this.mcStatsList.actualHeight + MODULE_PADDING;
         this.background.height = Math.max(MIN_BACKGROUND_HEIGHT,_loc1_);
         this.contentMask.height = _defaultHeight;
         this.delemiter.y = actualHeight;
         this.expandTooltip(false);
         this.btnExpand.visible = actualHeight > _defaultHeight;
      }
      
      override protected function getExtraHeight() : Number
      {
         var _loc1_:Number = NaN;
         if(_expanded)
         {
            _loc1_ = actualHeight - _defaultHeight;
            return _loc1_ > 0 ? _loc1_ : 0;
         }
         return 0;
      }
      
      protected function displayDebugData() : void
      {
         var _loc1_:Object = {};
         var _loc2_:Array = [];
         _loc2_.push({
            "label":"Test stat 1",
            "value":"1"
         });
         _loc2_.push({
            "label":"Test stat 2",
            "value":"2"
         });
         _loc2_.push({
            "label":"Test stat 3",
            "value":"3"
         });
         _loc2_.push({
            "label":"Test stat 4",
            "value":"4"
         });
         _loc1_.title = "Stat tooltip";
         _loc1_.description = "This";
         _loc1_.statsList = _loc2_;
         this.anchorRect = stage.getRect(parent["testAnchor"] as MovieClip);
         this.lockFixedPosition = true;
         this.data = _loc1_;
      }
   }
}
