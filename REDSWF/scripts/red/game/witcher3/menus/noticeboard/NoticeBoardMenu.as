package red.game.witcher3.menus.noticeboard
{
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import red.core.CoreComponent;
   import red.core.CoreMenu;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.ConditionalCloseButton;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.controls.W3DirectionalScrollingList;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.managers.InputDelegate;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.MouseEventEx;
   
   public class NoticeBoardMenu extends CoreMenu
   {
       
      
      public var tfTitle:TextField;
      
      public var tfDescription:TextField;
      
      public var btnConfirm:InputFeedbackButton;
      
      public var btnQuit:InputFeedbackButton;
      
      public var mcCloseBtn:ConditionalCloseButton;
      
      public var mcList:W3DirectionalScrollingList;
      
      public var mcErrand1:NoticeboardListItem;
      
      public var mcErrand2:NoticeboardListItem;
      
      public var mcErrand3:NoticeboardListItem;
      
      public var mcErrand4:NoticeboardListItem;
      
      public var mcErrand5:NoticeboardListItem;
      
      public var mcErrand6:NoticeboardListItem;
      
      private var fluffOffset:int = 9;
      
      public function NoticeBoardMenu()
      {
         addFrameScript(0,this.frame1);
         super();
         _enableInputValidation = true;
         upToCloseEnabled = false;
         this.btnConfirm.label = "[[panel_button_common_take]]";
         this.btnConfirm.setDataFromStage(NavigationCode.GAMEPAD_A,KeyCode.E);
         this.btnConfirm.clickable = false;
         this.btnQuit.label = "[[panel_button_common_exit]]";
         this.btnQuit.setDataFromStage(NavigationCode.GAMEPAD_B,-1);
         this.btnQuit.addEventListener(MouseEvent.CLICK,this.onQuitClicked,false,0,true);
         this.btnQuit.clickable = false;
         this.mcList.activeSelectionVisible = true;
         this.mcList.internalRenderers = false;
         this.__setProp_mcErrand1_Scene1_List_0();
         this.__setProp_mcErrand2_Scene1_List_0();
         this.__setProp_mcErrand3_Scene1_List_0();
         this.__setProp_mcErrand4_Scene1_List_0();
         this.__setProp_mcErrand5_Scene1_List_0();
         this.__setProp_mcErrand6_Scene1_List_0();
         this.__setProp_mcList_Scene1_mcList_0();
      }
      
      override protected function get menuName() : String
      {
         return "NoticeBoardMenu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"noticeboard.errands.list",[this.handleDataSet]));
         this.setupMouseEvents();
         InputDelegate.getInstance().addEventListener(InputEvent.INPUT,this.handleInput,false,1,true);
         this.mcList.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,this.onItemClicked,false,0,true);
         this.mcList.addEventListener(ListEvent.INDEX_CHANGE,this.onItemSelected,false,0,true);
         this.mcList.selectedIndex = 1;
         this.mcList.focused = 1;
         if(this.mcCloseBtn)
         {
            this.mcCloseBtn.addEventListener(ButtonEvent.PRESS,this.handleClosePressed,false,0,true);
         }
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      protected function setupMouseEvents() : void
      {
         this.attachEventsToItem(this.mcErrand1);
         this.attachEventsToItem(this.mcErrand2);
         this.attachEventsToItem(this.mcErrand3);
         this.attachEventsToItem(this.mcErrand4);
         this.attachEventsToItem(this.mcErrand5);
         this.attachEventsToItem(this.mcErrand6);
         stage.addEventListener(MouseEvent.CLICK,this.onStageClick,false,1,true);
      }
      
      protected function attachEventsToItem(param1:NoticeboardListItem) : void
      {
         param1.addEventListener(MouseEvent.CLICK,this.onNoticeBoardItemClicked,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_OVER,this.onNoticeBoardItemMouseOver,false,0,true);
      }
      
      protected function onNoticeBoardItemClicked(param1:MouseEvent) : void
      {
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(_loc2_.buttonIdx == MouseEventEx.LEFT_BUTTON)
         {
            this.onItemClicked(null);
            param1.stopImmediatePropagation();
         }
         else if(_loc2_.buttonIdx == MouseEventEx.RIGHT_BUTTON)
         {
            hideAnimation();
            param1.stopImmediatePropagation();
         }
      }
      
      protected function handleClosePressed(param1:ButtonEvent) : void
      {
         hideAnimation();
      }
      
      protected function onStageClick(param1:MouseEvent) : void
      {
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(_loc2_.buttonIdx == MouseEventEx.RIGHT_BUTTON)
         {
            hideAnimation();
            param1.stopImmediatePropagation();
         }
      }
      
      protected function onNoticeBoardItemMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:NoticeboardListItem = param1.currentTarget as NoticeboardListItem;
         this.mcList.selectedIndex = _loc2_.index;
      }
      
      public function setTitle(param1:String) : void
      {
         if(this.tfTitle)
         {
            this.tfTitle.htmlText = param1;
         }
      }
      
      public function setSelectedIndex(param1:int) : void
      {
         if(this.mcList)
         {
            this.mcList.selectedIndex = param1;
         }
      }
      
      public function setDescription(param1:String) : void
      {
         if(this.tfDescription)
         {
            if(CoreComponent.isArabicAligmentMode)
            {
               param1 = "<p align=\"right\">" + param1 + "</p>";
            }
            this.tfDescription.htmlText = param1;
         }
      }
      
      private function onItemClicked(param1:ListEvent) : void
      {
         if(this.mcList.selectedIndex == -1)
         {
            return;
         }
         var _loc2_:NoticeboardListItem = this.mcList.getRendererAt(this.mcList.selectedIndex) as NoticeboardListItem;
         if(_loc2_)
         {
            if(_loc2_.visible && _loc2_.enabled)
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnTakeQuest",[_loc2_.data.tag]));
               _loc2_.visible = false;
               _loc2_.enabled = false;
               _loc2_.selectable = false;
               this.setTitle("");
               this.setDescription("");
               this.TrySelectNextOne();
            }
         }
      }
      
      private function TrySelectNextOne() : void
      {
         var _loc1_:int = 0;
         var _loc2_:NoticeboardListItem = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         _loc1_ = this.mcList.selectedIndex;
         while(!_loc3_)
         {
            _loc1_++;
            if(_loc1_ > this.mcList.data.length - 1)
            {
               _loc1_ = 0;
               if(_loc4_)
               {
                  return;
               }
               _loc4_ = true;
            }
            _loc2_ = this.mcList.getRendererAt(_loc1_) as NoticeboardListItem;
            if(_loc2_)
            {
               if(_loc2_.visible)
               {
                  this.mcList.selectedIndex = _loc1_;
                  _loc3_ = true;
               }
            }
         }
      }
      
      private function onItemSelected(param1:ListEvent) : void
      {
         var _loc2_:NoticeboardListItem = this.mcList.getRendererAt(param1.index) as NoticeboardListItem;
         if(Boolean(_loc2_) && _loc2_.data)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnErrandSelected",[_loc2_.data.tag]));
         }
      }
      
      protected function handleDataSet(param1:Object, param2:int) : void
      {
         var _loc3_:Array = param1 as Array;
         if(_loc3_)
         {
            this.mcList.data = _loc3_;
            this.mcList.validateNow();
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = param1.details;
         var _loc3_:Boolean = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
         if(_loc2_.value == InputValue.KEY_DOWN && (_loc2_.code == KeyCode.ENTER || _loc2_.code == KeyCode.E) || _loc3_ && _loc2_.navEquivalent == NavigationCode.GAMEPAD_A)
         {
            this.onItemClicked(null);
            param1.handled = true;
         }
         if(!param1.handled)
         {
            this.mcList.handleInputPreset(param1);
         }
      }
      
      protected function onQuitClicked(param1:MouseEvent) : void
      {
         hideAnimation();
      }
      
      internal function __setProp_mcErrand1_Scene1_List_0() : *
      {
         try
         {
            this.mcErrand1["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcErrand1.draggingEnabled = true;
         this.mcErrand1.enabled = true;
         this.mcErrand1.enableInitCallback = false;
         this.mcErrand1.gridSize = 1;
         this.mcErrand1.navigationDown = 3;
         this.mcErrand1.navigationLeft = -1;
         this.mcErrand1.navigationRight = 1;
         this.mcErrand1.navigationUp = -1;
         this.mcErrand1.selectable = true;
         this.mcErrand1.visible = true;
         try
         {
            this.mcErrand1["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcErrand2_Scene1_List_0() : *
      {
         try
         {
            this.mcErrand2["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcErrand2.draggingEnabled = true;
         this.mcErrand2.enabled = true;
         this.mcErrand2.enableInitCallback = false;
         this.mcErrand2.gridSize = 1;
         this.mcErrand2.navigationDown = 4;
         this.mcErrand2.navigationLeft = 0;
         this.mcErrand2.navigationRight = 2;
         this.mcErrand2.navigationUp = -1;
         this.mcErrand2.selectable = true;
         this.mcErrand2.visible = true;
         try
         {
            this.mcErrand2["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcErrand3_Scene1_List_0() : *
      {
         try
         {
            this.mcErrand3["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcErrand3.draggingEnabled = true;
         this.mcErrand3.enabled = true;
         this.mcErrand3.enableInitCallback = false;
         this.mcErrand3.gridSize = 1;
         this.mcErrand3.navigationDown = 5;
         this.mcErrand3.navigationLeft = 1;
         this.mcErrand3.navigationRight = -1;
         this.mcErrand3.navigationUp = -1;
         this.mcErrand3.selectable = true;
         this.mcErrand3.visible = true;
         try
         {
            this.mcErrand3["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcErrand4_Scene1_List_0() : *
      {
         try
         {
            this.mcErrand4["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcErrand4.draggingEnabled = true;
         this.mcErrand4.enabled = true;
         this.mcErrand4.enableInitCallback = false;
         this.mcErrand4.gridSize = 1;
         this.mcErrand4.navigationDown = -1;
         this.mcErrand4.navigationLeft = -1;
         this.mcErrand4.navigationRight = 4;
         this.mcErrand4.navigationUp = 0;
         this.mcErrand4.selectable = true;
         this.mcErrand4.visible = true;
         try
         {
            this.mcErrand4["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcErrand5_Scene1_List_0() : *
      {
         try
         {
            this.mcErrand5["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcErrand5.draggingEnabled = true;
         this.mcErrand5.enabled = true;
         this.mcErrand5.enableInitCallback = false;
         this.mcErrand5.gridSize = 1;
         this.mcErrand5.navigationDown = -1;
         this.mcErrand5.navigationLeft = 3;
         this.mcErrand5.navigationRight = 5;
         this.mcErrand5.navigationUp = 1;
         this.mcErrand5.selectable = true;
         this.mcErrand5.visible = true;
         try
         {
            this.mcErrand5["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcErrand6_Scene1_List_0() : *
      {
         try
         {
            this.mcErrand6["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcErrand6.draggingEnabled = true;
         this.mcErrand6.enabled = true;
         this.mcErrand6.enableInitCallback = false;
         this.mcErrand6.gridSize = 1;
         this.mcErrand6.navigationDown = -1;
         this.mcErrand6.navigationLeft = 4;
         this.mcErrand6.navigationRight = -1;
         this.mcErrand6.navigationUp = 2;
         this.mcErrand6.selectable = true;
         this.mcErrand6.visible = true;
         try
         {
            this.mcErrand6["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcList_Scene1_mcList_0() : *
      {
         try
         {
            this.mcList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcList.enabled = true;
         this.mcList.enableInitCallback = false;
         this.mcList.internalRenderers = false;
         this.mcList.slotRendererName = "NoticeboardListItem";
         this.mcList.visible = true;
         try
         {
            this.mcList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
