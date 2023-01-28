package red.game.witcher3.menus.mainmenu
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import red.game.witcher3.controls.BaseListItem;
   import red.game.witcher3.utils.CommonUtils;
   
   public class W3MenuListItemRenderer extends BaseListItem
   {
       
      
      public var _CapitalizeAll:Boolean = true;
      
      public var _IsBackButton:Boolean = false;
      
      public var mcFrame:MovieClip;
      
      protected var _showOpen:Boolean = false;
      
      private var _hideSelection:Boolean = false;
      
      public function W3MenuListItemRenderer()
      {
         super();
         canBePressed = false;
      }
      
      override protected function setState(param1:String) : void
      {
         super.setState(param1);
      }
      
      override public function setData(param1:Object) : void
      {
         if(!param1)
         {
            return;
         }
         if(param1.isBackButton)
         {
            this._IsBackButton = param1.isBackButton;
         }
         super.setData(param1);
      }
      
      public function set showOpen(param1:Boolean) : void
      {
         this._showOpen = param1;
         this.updateText();
      }
      
      override protected function updateText() : void
      {
         if(_label != null && textField != null)
         {
            if(Boolean(data) && Boolean(data.unavailable))
            {
               textField.htmlText = "<font color=\"#555555\">" + _label + "</font>";
            }
            else if(this._IsBackButton && !selected)
            {
               textField.htmlText = "<font color=\"#FFFFFF\">" + _label + "</font>";
            }
            else if(this._showOpen)
            {
               textField.htmlText = "<font color=\"#FFFFFF\">" + _label + "</font>";
            }
            else
            {
               textField.htmlText = _label;
            }
            if(this._CapitalizeAll)
            {
               textField.htmlText = CommonUtils.toUpperCaseSafe(textField.htmlText);
            }
            this.mcFrame = getChildByName("mcFrame") as MovieClip;
            if(this.mcFrame)
            {
               if(this.hideSelection)
               {
                  if(this.mcFrame.visible)
                  {
                     this.mcFrame.visible = false;
                  }
               }
               else
               {
                  if(!this.mcFrame.visible)
                  {
                     this.mcFrame.visible = true;
                  }
                  this.mcFrame.height = textField.textHeight + 33;
               }
            }
         }
      }
      
      public function set hideSelection(param1:Boolean) : void
      {
         this._hideSelection = param1;
         this.mcFrame = getChildByName("mcFrame") as MovieClip;
         if(this.mcFrame)
         {
            if(this.hideSelection)
            {
               if(this.mcFrame.visible)
               {
                  this.mcFrame.visible = false;
               }
            }
            else if(!this.mcFrame.visible)
            {
               this.mcFrame.visible = true;
            }
         }
      }
      
      public function get hideSelection() : Boolean
      {
         return this._hideSelection;
      }
      
      public function get capitalizeAll() : Boolean
      {
         return this._CapitalizeAll;
      }
      
      public function set capitalizeAll(param1:Boolean) : void
      {
         this._CapitalizeAll = param1;
      }
      
      override public function set selected(param1:Boolean) : void
      {
         super.selected = param1;
      }
      
      public function showTooltip() : void
      {
      }
      
      public function hideTooltip() : void
      {
      }
      
      protected function pendedTooltipShow(param1:Event) : void
      {
      }
      
      protected function pendedTooltipHide(param1:Event) : void
      {
      }
      
      protected function fireTooltipShowEvent(param1:Boolean = false) : void
      {
      }
      
      protected function fireTooltipHideEvent(param1:Boolean = false) : void
      {
      }
      
      public function getGlobalRect() : Rectangle
      {
         var _loc1_:Rectangle = new Rectangle(x,y,width,height);
         var _loc2_:Point = localToGlobal(new Point(_loc1_.x,_loc1_.y));
         _loc1_.x = _loc2_.x;
         _loc1_.y = _loc2_.y;
         return _loc1_;
      }
   }
}
