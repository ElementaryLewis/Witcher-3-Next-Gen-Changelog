package red.game.witcher3.menus.common
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import red.core.CoreComponent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.events.GridEvent;
   import red.game.witcher3.slots.SlotInventoryGrid;
   import scaleform.clik.core.UIComponent;
   
   public class InventoryListItemRenderer extends IconItemRenderer
   {
      
      public static const SOUND_TRIGGER_EVENT:String = "sound_trigger_event";
       
      
      private const TEXT_CENTER:Number = 49;
      
      private const TEXT_PADDING:Number = 5;
      
      private const SLOT_SCALING:Number = 0.78;
      
      private const STATIC_HEIGHT:Number = 100;
      
      public var mcProgressRemoveEnchantment:MovieClip;
      
      public var mcProgressEnchantment:MovieClip;
      
      public var mcItemSlot:SlotInventoryGrid;
      
      public var mcShowAllIcon:MovieClip;
      
      protected var _currentProgressBar:MovieClip;
      
      protected var _progressCallback:Function;
      
      protected var _soundCallback:Function;
      
      protected var _tooltipRequested:Boolean;
      
      protected var _isInProgress:Boolean;
      
      protected var _isRemoving:Boolean;
      
      public function InventoryListItemRenderer()
      {
         super();
         this.mcProgressRemoveEnchantment.visible = false;
         this.mcProgressEnchantment.visible = false;
         visible = false;
         this.mcProgressRemoveEnchantment.addEventListener(Event.COMPLETE,this.onProgressComplete,false,0,true);
         this.mcProgressEnchantment.addEventListener(Event.COMPLETE,this.onProgressComplete,false,0,true);
         this.mcProgressRemoveEnchantment.addEventListener(SOUND_TRIGGER_EVENT,this.onSoundTrigger,false,0,true);
         this.mcProgressEnchantment.addEventListener(SOUND_TRIGGER_EVENT,this.onSoundTrigger,false,0,true);
         this._isInProgress = false;
      }
      
      public function showProgress(param1:Boolean = false, param2:Function = null, param3:Function = null) : void
      {
         this.resetProgress();
         this._isRemoving = param1;
         this._isInProgress = true;
         this._currentProgressBar = this._isRemoving ? this.mcProgressRemoveEnchantment : this.mcProgressEnchantment;
         this._currentProgressBar.visible = true;
         this._currentProgressBar.gotoAndPlay(2);
         this._progressCallback = param2;
         this._soundCallback = param3;
      }
      
      public function resetProgress() : void
      {
         if(this._currentProgressBar)
         {
            this._currentProgressBar.gotoAndStop(1);
            this._currentProgressBar.visible = false;
            this._currentProgressBar = null;
         }
         this._isInProgress = false;
      }
      
      private function onProgressComplete(param1:Event) : void
      {
         if(this._isInProgress)
         {
            this.resetProgress();
            if(this._progressCallback != null)
            {
               this._progressCallback();
            }
         }
      }
      
      private function onSoundTrigger(param1:Event) : void
      {
         if(this._soundCallback != null)
         {
            this._soundCallback(this._isRemoving);
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut,false,0,true);
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         if(!param1)
         {
            return;
         }
         visible = true;
         if(param1.userData as String == "ShowAll")
         {
            this.mcItemSlot.cleanup();
            this.mcItemSlot.visible = false;
            if(this.mcShowAllIcon)
            {
               this.mcShowAllIcon.visible = true;
            }
         }
         else
         {
            this.mcItemSlot.visible = true;
            this.mcItemSlot.data = param1;
            this.mcItemSlot.validateNow();
            this.mcItemSlot.y = this.TEXT_CENTER - this.mcItemSlot.getSlotRect().height * this.SLOT_SCALING / 2;
            if(this.mcShowAllIcon)
            {
               this.mcShowAllIcon.visible = false;
            }
         }
         if(selected)
         {
            this.fireTooltipShowEvent(false);
         }
         else
         {
            this.fireTooltipHideEvent();
         }
      }
      
      override protected function updateText() : void
      {
         var _loc1_:* = null;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         if(_data)
         {
            _loc1_ = String(_data.itemName);
            _loc2_ = false;
            _loc3_ = false;
            if(CoreComponent.isArabicAligmentMode)
            {
               _loc1_ = "<p align=\"right\">" + _loc1_ + "</p>";
            }
            _loc2_ = Boolean(_data.isEquipped);
            _loc3_ = Boolean(_data.isNotEnoughSockets);
            tfSecondLine.textColor = 10066329;
            if(_loc3_)
            {
               _loc4_ = String(_data.description);
               tfSecondLine.htmlText = _loc4_;
               tfSecondLine.textColor = 13173250;
               tfSecondLine.visible = true;
               if(CoreComponent.isArabicAligmentMode)
               {
                  tfSecondLine.htmlText = "<p align=\"right\">" + _loc4_ + "</p>";
                  tfSecondLine.textColor = 13173250;
               }
            }
            else if(_loc2_)
            {
               _loc4_ = "[[panel_blacksmith_equipped]]";
               tfSecondLine.htmlText = _loc4_;
               if(CoreComponent.isArabicAligmentMode)
               {
                  tfSecondLine.htmlText = "<p align=\"right\">" + _loc4_ + "</p>";
               }
               tfSecondLine.visible = true;
            }
            else
            {
               tfSecondLine.visible = false;
            }
            textField.htmlText = _loc1_;
            textField.height = textField.textHeight + CommonConstants.SAFE_TEXT_PADDING;
            if(_loc2_ || _loc3_)
            {
               _loc5_ = textField.textHeight + tfSecondLine.textHeight + this.TEXT_PADDING;
               textField.y = this.TEXT_CENTER - _loc5_ / 2;
               tfSecondLine.y = textField.y + textField.textHeight + this.TEXT_PADDING;
            }
            else
            {
               textField.y = this.TEXT_CENTER - textField.textHeight / 2;
            }
         }
      }
      
      override public function toString() : String
      {
         return "[W3 IconItemRenderer] " + name + "[" + index + "]";
      }
      
      override public function get height() : Number
      {
         return this.STATIC_HEIGHT;
      }
      
      private function handleMouseMove(param1:MouseEvent) : void
      {
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
      }
      
      override public function set selected(param1:Boolean) : void
      {
         super.selected = param1;
         if(this.mcItemSlot.visible)
         {
            if(param1 && _activeSelectionEnabled)
            {
               this.fireTooltipShowEvent(false);
            }
            else
            {
               this.fireTooltipHideEvent();
            }
         }
      }
      
      override public function set activeSelectionEnabled(param1:Boolean) : void
      {
         var _loc2_:UIComponent = owner as UIComponent;
         var _loc3_:Boolean = !!_loc2_ ? _loc2_.enabled : true;
         super.activeSelectionEnabled = param1;
         if(param1 && selected && _loc3_ && this.mcItemSlot.visible)
         {
            this.fireTooltipShowEvent(false);
         }
      }
      
      private function fireTooltipShowEvent(param1:Boolean) : void
      {
         var _loc3_:* = new Namespace("");
         var _loc4_:* = new Namespace("");
         var _loc5_:Point = null;
         var _loc2_:GridEvent = new GridEvent(GridEvent.DISPLAY_TOOLTIP,true,false,0,-1,-1,null,data);
         _loc2_.isMouseTooltip = false;
         if(!this.mcItemSlot.visible)
         {
            return;
         }
         if(param1)
         {
            _loc3_ = 90;
            _loc4_ = 15;
            _loc5_ = localToGlobal(new Point(_loc3_,_loc4_));
            _loc2_.anchorRect = new Rectangle(_loc5_.x,_loc5_.y);
         }
         dispatchEvent(_loc2_);
         this._tooltipRequested = true;
      }
      
      private function fireTooltipHideEvent() : void
      {
         var _loc1_:GridEvent = null;
         if(this._tooltipRequested)
         {
            _loc1_ = new GridEvent(GridEvent.HIDE_TOOLTIP,true,false,0,-1,-1,null,null);
            dispatchEvent(_loc1_);
            this._tooltipRequested = false;
         }
      }
   }
}
