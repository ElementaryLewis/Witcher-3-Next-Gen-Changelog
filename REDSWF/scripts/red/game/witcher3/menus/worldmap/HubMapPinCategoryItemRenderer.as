package red.game.witcher3.menus.worldmap
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import red.core.constants.KeyCode;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.controls.BaseListItem;
   import red.game.witcher3.menus.worldmap.data.CategoryPinData;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.MouseEventEx;
   
   public class HubMapPinCategoryItemRenderer extends BaseListItem
   {
       
      
      public var tfPinType:TextField;
      
      public var mcIconContainer:MovieClip;
      
      public var mcArrowsContainer:MovieClip;
      
      public var funcChangePinIndex:Function;
      
      public var funcTogglePin:Function;
      
      public var funcIsPinDisabled:Function;
      
      public var mcBackground:MovieClip;
      
      public var mcSelectionAnim:MovieClip;
      
      private const TEXT_PADDING = 10;
      
      private var txtCounter:TextField;
      
      private var otherTextFormat:TextFormat;
      
      private var lTextFormat:TextFormat;
      
      private var currTextFormat:TextFormat;
      
      public function HubMapPinCategoryItemRenderer()
      {
         super();
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         mouseEnabled = true;
         mouseChildren = true;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         mouseEnabled = true;
         mouseChildren = true;
         this.mcArrowsContainer.mcHubMapPinCategoryArrowLeft.addEventListener(MouseEvent.MOUSE_DOWN,this.handleArrowLeft,false,0,true);
         this.mcArrowsContainer.mcHubMapPinCategoryArrowRight.addEventListener(MouseEvent.MOUSE_DOWN,this.handleArrowRight,false,0,true);
         this.mcIconContainer.addEventListener(MouseEvent.MOUSE_DOWN,this.handleToggleVisibilityLMB,false,0,true);
         addEventListener(MouseEvent.MOUSE_DOWN,this.handleToggleVisibilityRMB,false,0,true);
      }
      
      public function handleArrowLeft(param1:MouseEventEx) : *
      {
         if(param1.buttonIdx == MouseEventEx.LEFT_BUTTON)
         {
            if(this.funcChangePinIndex != null)
            {
               this.funcChangePinIndex(this,-1);
            }
         }
      }
      
      public function handleArrowRight(param1:MouseEventEx) : *
      {
         if(param1.buttonIdx == MouseEventEx.LEFT_BUTTON)
         {
            if(this.funcChangePinIndex != null)
            {
               this.funcChangePinIndex(this,1);
            }
         }
      }
      
      public function handleToggleVisibilityLMB(param1:MouseEventEx) : *
      {
         if(param1.buttonIdx == MouseEventEx.LEFT_BUTTON)
         {
            this.toggleVisibility();
         }
      }
      
      public function handleToggleVisibilityRMB(param1:MouseEventEx) : *
      {
         if(param1.buttonIdx == MouseEventEx.RIGHT_BUTTON)
         {
            this.toggleVisibility();
         }
      }
      
      private function toggleVisibility() : *
      {
         if(this.funcTogglePin != null)
         {
            this.funcTogglePin(data._name);
         }
         this.updateVisibility();
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = param1.details;
         var _loc3_:Boolean = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
         var _loc4_:* = _loc2_.value == InputValue.KEY_UP;
         if(_loc2_.code == KeyCode.PAD_LEFT_TRIGGER)
         {
            if(_loc4_)
            {
               this.toggleVisibility();
               return;
            }
         }
         super.handleInput(param1);
      }
      
      public function updateVisibility() : *
      {
         var _loc1_:Boolean = false;
         if(this.funcIsPinDisabled != null)
         {
            _loc1_ = this.funcIsPinDisabled(data._name);
         }
         this.mcIconContainer.mcDisabled.visible = _loc1_;
         this.setColoredText(data.translation,_loc1_);
      }
      
      override public function set selected(param1:Boolean) : void
      {
         super.selected = param1;
         if(this.mcSelectionAnim)
         {
            this.mcSelectionAnim.visible = selected;
         }
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         var _loc2_:CategoryPinData = param1 as CategoryPinData;
         if(_loc2_)
         {
            this.mcIconContainer.mcIcon.gotoAndStop(_loc2_._name);
            this.updateVisibility();
            this.tfPinType.width = this.tfPinType.textWidth + CommonConstants.SAFE_TEXT_PADDING;
            this.setCounter(_loc2_._index,_loc2_._instances.length);
            this.mcBackground.width = this.tfPinType.x - this.mcBackground.x + this.tfPinType.textWidth + this.TEXT_PADDING;
            if(this.mcSelectionAnim)
            {
               this.mcSelectionAnim.width = this.mcBackground.width;
            }
         }
      }
      
      private function setColoredText(param1:String, param2:Boolean) : *
      {
         if(param2)
         {
            this.tfPinType.htmlText = "<font color=\'#bf1f1f\'>" + data._translation + "</font>";
         }
         else
         {
            this.tfPinType.htmlText = "<font color=\'#dfdede\'>" + data._translation + "</font>";
         }
      }
      
      public function setCounter(param1:*, param2:int) : *
      {
         var _loc3_:int = 1;
         if(param2 == 0)
         {
            _loc3_ = 0;
         }
         this.lTextFormat = new TextFormat("$NormalFont",20);
         this.lTextFormat.font = "$NormalFont";
         this.lTextFormat.align = TextFormatAlign.CENTER;
         this.otherTextFormat = new TextFormat("$NormalFont",17);
         this.otherTextFormat.font = "$NormalFont";
         this.otherTextFormat.align = TextFormatAlign.CENTER;
         this.txtCounter = this.mcArrowsContainer.getChildByName("tfCounter") as TextField;
         if(this.txtCounter)
         {
            this.txtCounter.defaultTextFormat = this.lTextFormat;
            this.txtCounter.setTextFormat(this.lTextFormat);
            this.txtCounter.text = param1 + _loc3_ + "/" + param2;
            if(this.txtCounter.textWidth > this.txtCounter.width)
            {
               this.currTextFormat = this.otherTextFormat;
            }
            else
            {
               this.currTextFormat = this.lTextFormat;
            }
            this.formatText();
         }
      }
      
      override protected function updateText() : void
      {
         super.updateText();
         this.formatText();
      }
      
      private function formatText() : void
      {
         if(Boolean(this.txtCounter) && Boolean(this.currTextFormat))
         {
            this.txtCounter.defaultTextFormat = this.currTextFormat;
            this.txtCounter.setTextFormat(this.currTextFormat);
         }
      }
   }
}
