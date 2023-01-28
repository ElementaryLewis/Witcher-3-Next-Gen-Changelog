package red.game.witcher3.menus.common
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.core.CoreMenuModule;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.BaseListItem;
   import red.game.witcher3.controls.W3DropdownMenuListItem;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.managers.InputFeedbackManager;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.controls.ScrollBar;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   
   public class ListModuleBase extends CoreMenuModule
   {
       
      
      public var textField:TextField;
      
      public var mcScrollBar:ScrollBar;
      
      public var mcList:W3ScrollingList;
      
      public var tfCurrentState:TextField;
      
      public var mcMask:MovieClip;
      
      public var mcEmptyListFeedback:MovieClip;
      
      public var mcListItem1:BaseListItem;
      
      public var mcListItem2:BaseListItem;
      
      public var mcListItem3:BaseListItem;
      
      public var mcListItem4:BaseListItem;
      
      public var mcListItem5:BaseListItem;
      
      public var mcListItem6:BaseListItem;
      
      public var mcListItem7:BaseListItem;
      
      public var mcListItem8:BaseListItem;
      
      protected var _dataBindingKey:String = "journal.quest.list";
      
      protected var _moduleDisplayName:String = "";
      
      protected var _itemInputFeedbackLabel:String;
      
      protected var _itemInputFeedback:int = -1;
      
      protected var _toggleInputFeedback:int = -1;
      
      protected var _itemButtonShown:Boolean;
      
      protected var _toggleButtonShown:Boolean;
      
      public var itemRenderer:String;
      
      public var _itemListClass:String = "W3ScrollingListNoBG";
      
      public var _itemRendererClass:String = "IconListItem";
      
      public var menuName:String;
      
      public var _listWidth:Number = 1200;
      
      public var _listHeight:Number = 600;
      
      public var _movieIsPlaying:Boolean = false;
      
      public function ListModuleBase()
      {
         super();
         dataBindingKey = this._dataBindingKey;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,this._dataBindingKey + ".name",[this.handleModuleNameSet]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,this._dataBindingKey,[this.handleListData]));
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         if(this.mcList)
         {
            if(!this.mcList.mask)
            {
               this.mcList.mask = this.mcMask;
            }
            _inputHandlers.push(this.mcList);
            this.mcList.addEventListener(ListEvent.INDEX_CHANGE,this.handleIndexChange,false,0,true);
            this.mcList.addEventListener(ListEvent.ITEM_CLICK,this.handleClick,false,0,true);
         }
         this.UpdateEmptyStateFeedback(true);
      }
      
      public function get itemInputFeedbackLabel() : String
      {
         return this._itemInputFeedbackLabel;
      }
      
      public function set itemInputFeedbackLabel(param1:String) : void
      {
         this._itemInputFeedbackLabel = param1;
      }
      
      public function set ItemListClass(param1:String) : *
      {
         this._itemListClass = param1;
      }
      
      public function set ItemRendererClass(param1:String) : *
      {
         this._itemRendererClass = param1;
      }
      
      public function set DataBindingKey(param1:String) : *
      {
         this._dataBindingKey = param1;
      }
      
      public function get listWidth() : Number
      {
         return this._listWidth;
      }
      
      public function set listWidth(param1:Number) : void
      {
         this._listWidth = param1;
      }
      
      public function get listHeight() : Number
      {
         return this._listHeight;
      }
      
      public function set listHeight(param1:Number) : void
      {
         this._listHeight = param1;
      }
      
      public function handleListData(param1:Object, param2:int) : void
      {
         var _loc3_:Array = param1 as Array;
         if(this.mcList)
         {
            if(_loc3_.length > 0)
            {
               this.mcList.dataProvider = new DataProvider(_loc3_);
               this.mcList.validateNow();
               this.mcList.focused = 1;
               this.UpdateEmptyStateFeedback(false);
               if(this.mcList.selectedIndex == -1)
               {
                  this.mcList.selectedIndex = 0;
               }
            }
         }
      }
      
      protected function handleModuleNameSet(param1:String) : void
      {
         if(this.tfCurrentState)
         {
            this._moduleDisplayName = param1;
            this.tfCurrentState.htmlText = param1;
         }
      }
      
      protected function handleIndexChange(param1:ListEvent) : void
      {
         var _loc2_:BaseListItem = this.mcList.getRendererAt(this.mcList.selectedIndex) as BaseListItem;
         if(!_loc2_ && param1.index == -1 || !enabled)
         {
            this.hideItemInputFeedback();
            return;
         }
         if(_loc2_)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnEntrySelected",[_loc2_.data.tag]));
            this.showItemInputFeedback();
         }
      }
      
      private function handleClick(param1:ListEvent = null) : void
      {
         var _loc2_:BaseListItem = param1.itemRenderer as BaseListItem;
         if(!_loc2_ && param1.index == -1 || !enabled || this._movieIsPlaying)
         {
            return;
         }
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnEntryPress",[_loc2_.data.tag]));
         this.SetMovieIsPlaying(true);
      }
      
      public function SetMovieIsPlaying(param1:Boolean) : *
      {
         this._movieIsPlaying = param1;
         if(param1)
         {
            this.mcList.removeEventListener(ListEvent.ITEM_CLICK,this.handleClick);
            this.mcList.focused = 0;
         }
         else
         {
            this.mcList.addEventListener(ListEvent.ITEM_CLICK,this.handleClick,false,0,true);
            this.mcList.focused = 1;
         }
      }
      
      public function GetMovieIsPlaying() : Boolean
      {
         return this._movieIsPlaying;
      }
      
      protected function showItemInputFeedback() : void
      {
         if(visible && enabled)
         {
            if(Boolean(this._itemInputFeedbackLabel) && this._itemInputFeedback < 0)
            {
               this._itemInputFeedback = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_A,KeyCode.ENTER,this._itemInputFeedbackLabel);
               InputFeedbackManager.updateButtons(this);
               this._itemButtonShown = true;
            }
         }
      }
      
      protected function hideItemInputFeedback() : void
      {
         if(this._itemInputFeedback > 0)
         {
            InputFeedbackManager.removeButton(this,this._itemInputFeedback);
            InputFeedbackManager.updateButtons(this);
            this._itemInputFeedback = -1;
            this._itemButtonShown = false;
         }
      }
      
      override public function set focused(param1:Number) : void
      {
         var _loc2_:W3DropdownMenuListItem = null;
         if(param1 == _focused || !_focusable)
         {
            return;
         }
         super.focused = param1;
         if(_focused)
         {
            this.SetAsActiveContainer(true);
            if(this._itemButtonShown)
            {
               this.showItemInputFeedback();
            }
         }
         else
         {
            this.SetAsActiveContainer(false);
            if(this._itemInputFeedback > 0)
            {
               this.hideItemInputFeedback();
               this._itemButtonShown = true;
            }
         }
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(!this.mcList)
         {
            return;
         }
         if(visible)
         {
            if(this._itemButtonShown)
            {
               this.showItemInputFeedback();
            }
         }
         else if(this._itemInputFeedback > 0)
         {
            this.hideItemInputFeedback();
            this._itemButtonShown = true;
         }
      }
      
      protected function CreateMask() : *
      {
         if(this.mcMask)
         {
            this.mcMask.width = this.listWidth;
            this.mcMask.height = this.listHeight;
         }
      }
      
      public function UpdateEmptyStateFeedback(param1:Boolean) : *
      {
         if(this.textField)
         {
            this.textField.visible = param1;
            if(param1)
            {
               this.textField.htmlText = this.GetPanelEmptyStateFeedbackDescription();
               this.textField.htmlText = CommonUtils.toUpperCaseSafe(this.textField.htmlText);
            }
         }
         if(this.mcEmptyListFeedback)
         {
            this.mcEmptyListFeedback.visible = param1;
            if(param1 && this.mcEmptyListFeedback.mcIcon && Boolean(this.menuName))
            {
               this.mcEmptyListFeedback.mcIcon.gotoAndStop(this.menuName);
            }
         }
      }
      
      protected function GetPanelEmptyStateFeedbackDescription() : String
      {
         return "[[panel_menu_empty_list_" + (!!this.menuName ? this.menuName.toLowerCase() : "") + "]]";
      }
      
      public function SetAsActiveContainer(param1:Boolean) : *
      {
         if(this.tfCurrentState)
         {
            this.tfCurrentState.htmlText = this._moduleDisplayName;
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:UIComponent = null;
         if(param1.handled || !focused || !enabled || !visible || this._movieIsPlaying)
         {
            return;
         }
         for each(_loc2_ in _inputHandlers)
         {
            _loc2_.handleInput(param1);
            if(param1.handled)
            {
               param1.stopImmediatePropagation();
               return;
            }
         }
      }
   }
}
