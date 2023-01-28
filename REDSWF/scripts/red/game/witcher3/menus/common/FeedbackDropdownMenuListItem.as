package red.game.witcher3.menus.common
{
   import flash.display.MovieClip;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.EInputDeviceType;
   import red.game.witcher3.controls.BaseListItem;
   import red.game.witcher3.controls.W3DropDownItemRenderer;
   import red.game.witcher3.controls.W3DropdownMenuListItem;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.events.ListEvent;
   
   public class FeedbackDropdownMenuListItem extends W3DropdownMenuListItem
   {
       
      
      public var mcFeedbackIcon:MovieClip;
      
      public var mcNewOverlay:MovieClip;
      
      public var mcSelectionHighlight:MovieClip;
      
      public var mcCollapseBtnIcon:MovieClip;
      
      protected var _isNew:Boolean = false;
      
      private var selectedByTag:Boolean;
      
      public function FeedbackDropdownMenuListItem()
      {
         var _loc1_:InputManager = null;
         super();
         if(this.mcFeedbackIcon)
         {
            this.mcFeedbackIcon.visible = false;
         }
         if(this.mcNewOverlay)
         {
            this.mcNewOverlay.visible = false;
         }
         if(this.mcCollapseBtnIcon)
         {
            _loc1_ = InputManager.getInstance();
            this.mcCollapseBtnIcon.visible = false;
            if(_loc1_.gamepadType == EInputDeviceType.IDT_Steam)
            {
               this.mcCollapseBtnIcon.gotoAndStop(3);
            }
            else
            {
               this.mcCollapseBtnIcon.gotoAndStop(_loc1_.isPsGamepad() ? 2 : 1);
            }
            _loc1_.addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChanged,false,0,true);
         }
      }
      
      private function handleControllerChanged(param1:ControllerChangeEvent) : void
      {
         this.mcCollapseBtnIcon.visible = param1.isGamepad && isOpen() && selected;
      }
      
      override public function open(param1:Boolean = true) : void
      {
         super.open(param1);
         if(this.mcCollapseBtnIcon)
         {
            this.mcCollapseBtnIcon.visible = InputManager.getInstance().isGamepad() && selected;
         }
      }
      
      override public function close() : void
      {
         super.close();
         if(this.mcCollapseBtnIcon)
         {
            this.mcCollapseBtnIcon.visible = false;
         }
      }
      
      override public function set selected(param1:Boolean) : void
      {
         super.selected = param1;
         this.mcCollapseBtnIcon.visible = InputManager.getInstance().isGamepad() && isOpen() && selected;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         if(this.mcSelectionHighlight)
         {
            this.mcSelectionHighlight.visible = false;
         }
      }
      
      override public function setDropdownData(param1:Object) : void
      {
         super.setDropdownData(param1);
         this.CheckDropDownRefNewState();
      }
      
      protected function SetReadState(param1:MovieClip) : *
      {
         if(this._isNew)
         {
            param1.visible = true;
         }
         else
         {
            param1.visible = false;
         }
      }
      
      override protected function handleSelectChange(param1:ListEvent) : *
      {
         var _loc2_:BaseListItem = null;
         if(this.mcSelectionHighlight)
         {
            this.mcSelectionHighlight.visible = true;
         }
         if(param1.index > -1)
         {
            if(_dropdownRef)
            {
               _loc2_ = _dropdownRef.getRendererAt(param1.index) as BaseListItem;
               this.CheckDropDownRefNewState();
               if(_loc2_)
               {
                  if(_loc2_.data)
                  {
                     if(_loc2_.data.id)
                     {
                        dispatchEvent(new GameEvent(GameEvent.CALL,selectionEventName,[_loc2_.data.id]));
                        this.selectedByTag = false;
                     }
                     else if(_loc2_.data.tag)
                     {
                        dispatchEvent(new GameEvent(GameEvent.CALL,selectionEventName,[_loc2_.data.tag]));
                        this.selectedByTag = true;
                     }
                     if(_loc2_ is RecipeIconItemRenderer)
                     {
                        (_loc2_ as RecipeIconItemRenderer).fireShowTooltipEvent();
                     }
                  }
               }
               else
               {
                  dispatchEvent(new GameEvent(GameEvent.CALL,selectionEventName,[uint(0)]));
               }
               if(this.mcSelectionHighlight)
               {
                  this.mcSelectionHighlight.visible = false;
               }
            }
         }
         else
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,selectionEventName,[uint(0)]));
         }
      }
      
      protected function CheckDropDownRefNewState() : *
      {
         var _loc1_:int = 0;
         this._isNew = false;
         _loc1_ = 0;
         while(_loc1_ < dropDownData.length)
         {
            if(dropDownData[_loc1_].isNew)
            {
               this._isNew = true;
               break;
            }
            _loc1_++;
         }
         this.SetReadState(this.mcNewOverlay);
      }
      
      override protected function handleMenuItemDoubleClick(param1:ListEvent) : void
      {
         var _loc2_:W3DropDownItemRenderer = _dropdownRef.getRendererAt(param1.index) as W3DropDownItemRenderer;
         _loc2_.handleEntryPress();
      }
      
      override protected function handleMenuItemPress(param1:ListEvent) : void
      {
         var _loc2_:W3DropDownItemRenderer = null;
         if(param1.isKeyboard)
         {
            _loc2_ = _dropdownRef.getRendererAt(param1.index) as W3DropDownItemRenderer;
            _loc2_.handleEntryPress();
         }
      }
   }
}
