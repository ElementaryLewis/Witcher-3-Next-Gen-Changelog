package red.game.witcher3.hud.modules
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.text.TextField;
   import flash.utils.Timer;
   import red.core.constants.KeyCode;
   import red.core.data.InputAxisData;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.controls.MouseCursor;
   import red.game.witcher3.controls.W3UILoader;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.hud.modules.radialmenu.RadialMenuFieldsContainer;
   import red.game.witcher3.hud.modules.radialmenu.RadialMenuItem;
   import red.game.witcher3.hud.modules.radialmenu.RadialMenuItemEquipped;
   import red.game.witcher3.hud.modules.radialmenu.RadialMenuSubItemView;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.menus.common_menu.ModuleInputFeedback;
   import red.game.witcher3.utils.CommonUtils;
   import red.game.witcher3.utils.InputUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.managers.InputDelegate;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.MouseEventEx;
   
   public class HudModuleRadialMenu extends HudModuleBase
   {
      
      private static const CENTER_X = 960;
      
      private static const CENTER_Y = 540;
      
      private static const CENTER_Y_DEADZONE_TOP = 492;
      
      private static const CENTER_Y_DEADZONE_BOT = 592;
      
      private static const CENTER_DEADZONE_RADIUS_MIN = 146;
      
      private static const CENTER_DEADZONE_RADIUS_MAX = 260;
      
      private static const MAX_DISTANCE_FROM_CENTER = 150;
      
      private static const MOUSE_DEAD_ZONE = 30;
      
      private static const DESCR_PADDING = 20;
      
      private static const FADE_IN_DURATION:Number = 250;
       
      
      private const ITEM_SECTOR:Number = 0.785;
      
      private const ITEM_COUNT:uint = 8;
      
      public var mcRadialMenuFields:RadialMenuFieldsContainer;
      
      public var mcLabel:TextField;
      
      public var textField:TextField;
      
      private const BTN_ID_SWITCH:int = 0;
      
      private const BTN_ID_ACCEPT:int = 1;
      
      private const BTN_ID_EXIT:int = 2;
      
      private const BTN_ID_MEDITATION:int = 3;
      
      public var mcInputFeedback:ModuleInputFeedback;
      
      public var mcSelection:MovieClip;
      
      public var mcBck:MovieClip;
      
      public var mcMeditationBtnBck:MovieClip;
      
      public var mcRadialPointer:MovieClip;
      
      public var mcBlinkIcon:MovieClip;
      
      public var mcChargeIcon:MovieClip;
      
      public var mcIconLoaderMedalion:W3UILoader;
      
      public var bIsCiri:Boolean = false;
      
      public var textFieldRight:TextField;
      
      public var textFieldRightUp:TextField;
      
      public var textFieldMedalion:TextField;
      
      public var textFieldMedalionUp:TextField;
      
      public var mcDBGMouseCenter:MovieClip;
      
      public var mcSubItemView:RadialMenuSubItemView;
      
      private var bSignsBlocked:Boolean = false;
      
      protected var _mouseCursor:MouseCursor;
      
      private var subCategory:String = "none";
      
      private var subCategoryID:int = -1;
      
      private var bCheckStick:Boolean = false;
      
      private var realeseTimer:Timer;
      
      private var bBlockRadialMenu:Boolean = false;
      
      private var bOpenTimerRunning:Boolean = false;
      
      public var DebugOpeningKey:String = "escape-gamepad_B";
      
      public var previousMagnitude:Number = 0;
      
      private var _dynamicMouseCenterX:Number = 960;
      
      private var _dynamicMouseCenterY:Number = 540;
      
      private var m_isUsingRightStickNow:Boolean = false;
      
      private var SlotsNames:Array;
      
      public var mcItemDescrBackground:MovieClip;
      
      internal const HOLD_CLOSE_DELAY = 400;
      
      private var holdCloseTimer:Timer;
      
      private var _isAlternativeInputMode:Boolean;
      
      private var _shouldShowRadialPointer:Boolean = true;
      
      private var mouseEventsRegistered:Boolean = false;
      
      private const PENDING_DELAY:Number = 100;
      
      private var pendingTimer:Timer;
      
      private var pendingLabel:String;
      
      private var pendingDescription:String;
      
      private var pendingCategory:String;
      
      private var pendingIsDesaturated;
      
      private var _lastSetSelection:int = -1;
      
      public function HudModuleRadialMenu()
      {
         this.SlotsNames = new Array();
         addFrameScript(0,this.frame1,1,this.frame2);
         super();
         this.RadialGeraltMode();
         this.mcInputFeedback.buttonAlign = "center";
         this.mcInputFeedback.clickable = false;
         this.__setProp_mcIconLoaderMedalion_Scene1_mcIconLoader_0();
      }
      
      public function setAlternativeInputMode(param1:Boolean) : void
      {
         this._isAlternativeInputMode = param1;
         var _loc2_:RadialMenuItemEquipped = this.mcRadialMenuFields.GetSelectedRadialMenuField() as RadialMenuItemEquipped;
         if(_loc2_)
         {
            this.updateSelectedSlotItemFeedback(_loc2_);
         }
      }
      
      override public function get moduleName() : String
      {
         return "RadialMenuModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         visible = false;
         this.mcRadialMenuFields.setExternalViewer(this.mcSubItemView);
         if(this.mcDBGMouseCenter)
         {
            this.mcDBGMouseCenter.visible = false;
         }
         this.mcRadialMenuFields.SetRadialMenuFieldsNames(this.SlotsNames);
         this.mcRadialMenuFields.Init();
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         focused = 1;
         this.alpha = 0;
         this.configLabels();
         this.realeseTimer = new Timer(500,1);
         this.mcBck.mcSign.gotoAndStop("none");
         this.mcInputFeedback.appendButton(this.BTN_ID_MEDITATION,NavigationCode.GAMEPAD_X,KeyCode.SPACE,"[[panel_title_meditation]]");
         this.mcInputFeedback.appendButton(this.BTN_ID_EXIT,NavigationCode.GAMEPAD_B,KeyCode.ESCAPE,"[[panel_button_common_back_to_game]]",true);
         InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChange,false,0,true);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         this._mouseCursor = new MouseCursor(this);
         this.textFieldRight.visible = false;
         this.textFieldRightUp.visible = false;
         this.textFieldMedalion.visible = false;
         this.textFieldMedalionUp.visible = false;
         this.mcRadialMenuFields.addEventListener(Event.CHANGE,this.handleItemChanged,false,0,true);
         registerDataBinding("hud.radial.items",this.handleSetItemsList);
      }
      
      private function handleItemChanged(param1:Event) : void
      {
         var _loc3_:String = null;
         var _loc2_:RadialMenuItemEquipped = param1.target as RadialMenuItemEquipped;
         if(Boolean(_loc2_) && Boolean(_loc2_.data))
         {
            _loc3_ = _loc2_.getCurrentGroupSlotName();
            if(_loc3_)
            {
               if(this.mcRadialMenuFields.mcRadialMenuItem6 != _loc2_)
               {
                  this.mcRadialMenuFields.mcRadialMenuItem6["mcEquipped"].visible = false;
               }
               if(this.mcRadialMenuFields.mcRadialMenuItem7 != _loc2_)
               {
                  this.mcRadialMenuFields.mcRadialMenuItem7["mcEquipped"].visible = false;
               }
               if(this.mcRadialMenuFields.mcRadialMenuItem8 != _loc2_)
               {
                  this.mcRadialMenuFields.mcRadialMenuItem8["mcEquipped"].visible = false;
               }
               this.setSelectedItem(_loc3_,true);
            }
         }
      }
      
      private function handleSetItemsList(param1:Array) : void
      {
         var _loc4_:Object = null;
         var _loc5_:RadialMenuItemEquipped = null;
         RadialMenuItemEquipped.enableAnimationFx = true;
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc4_ = param1[_loc3_])
            {
               if(_loc5_ = this.mcRadialMenuFields.GetRadialMenuFieldByID(_loc4_.slotId) as RadialMenuItemEquipped)
               {
                  _loc5_.data = _loc4_;
               }
            }
            _loc3_++;
         }
      }
      
      public function setCiriRadial(param1:Boolean, param2:Boolean, param3:Boolean) : void
      {
         this.bIsCiri = param1;
         if(this.mcLabel)
         {
            this.mcLabel.text = "";
         }
         if(this.mcSubItemView)
         {
            this.mcSubItemView.cleanup();
         }
         if(this.textField)
         {
            this.textField.text = "";
            this.mcItemDescrBackground.visible = false;
            this.updateItemDescrBackground();
         }
         if(this.mcRadialMenuFields)
         {
            this.mcRadialMenuFields.visible = false;
         }
         if(this.mcItemDescrBackground)
         {
            this.mcItemDescrBackground.visible = false;
         }
         if(param1)
         {
            this.RadialCiriMode(param2,param3);
         }
         else
         {
            this.RadialGeraltMode();
         }
      }
      
      private function RadialGeraltMode() : *
      {
         this.subCategory = "none";
         gotoAndStop("Geralt");
         this.SlotsNames = new Array();
         this.SlotsNames.push("Yrden");
         this.SlotsNames.push("Quen");
         this.SlotsNames.push("Igni");
         this.SlotsNames.push("Axii");
         this.SlotsNames.push("Aard");
         this.SlotsNames.push("Slot1");
         this.SlotsNames.push("Crossbow");
         this.SlotsNames.push("Slot3");
         this.mcRadialMenuFields.visible = true;
         if(Boolean(this.mcItemDescrBackground) && !this.bIsCiri)
         {
            this.mcItemDescrBackground.visible = true;
         }
         this.mcInputFeedback.alpha = 1;
         this.mcInputFeedback.visible = true;
         this.mcMeditationBtnBck.visible = true;
         this.shouldShouldRadialPointer = true;
         this.mcBlinkIcon.visible = false;
         this.mcChargeIcon.visible = false;
         this.mcIconLoaderMedalion.visible = false;
         this.textFieldRight.visible = false;
         this.textFieldRightUp.visible = false;
         this.textFieldMedalion.visible = false;
         this.textFieldMedalionUp.visible = false;
      }
      
      private function RadialCiriMode(param1:Boolean, param2:Boolean) : *
      {
         this.shouldShouldRadialPointer = false;
         gotoAndStop("Ciri");
         this.SlotsNames = new Array();
         this.SlotsNames.push("disabled");
         this.SlotsNames.push("disabled");
         this.SlotsNames.push("disabled");
         this.SlotsNames.push("disabled");
         this.SlotsNames.push("disabled");
         this.SlotsNames.push("disabled");
         this.SlotsNames.push("disabled");
         this.SlotsNames.push("disabled");
         this.mcInputFeedback.alpha = 0;
         this.mcInputFeedback.visible = false;
         if(param2)
         {
            this.mcLabel.htmlText = "[[panel_hud_radial_ciri_charge]]";
            this.mcLabel.htmlText = CommonUtils.toUpperCaseSafe(this.mcLabel.htmlText);
            this.textField.htmlText = "[[panel_hud_radial_ciri_charge_description]]";
         }
         this.mcChargeIcon.visible = param2;
         this.mcLabel.visible = param2;
         this.textField.visible = param2;
         this.mcBlinkIcon.visible = param1;
         this.textFieldRight.visible = param1;
         this.textFieldRightUp.visible = param1;
         if(param1)
         {
            this.textFieldRightUp.htmlText = "[[panel_hud_radial_ciri_blink]]";
            this.textFieldRightUp.htmlText = CommonUtils.toUpperCaseSafe(this.textFieldRightUp.htmlText);
            this.textFieldRight.htmlText = "[[panel_hud_radial_ciri_blink_description]]";
         }
         this.mcIconLoaderMedalion.visible = false;
         this.updateItemDescrBackground();
      }
      
      public function updateItemDescrBackground() : *
      {
         if(Boolean(this.mcItemDescrBackground) && !this.bIsCiri)
         {
            this.mcItemDescrBackground.visible = this.textField.visible && Boolean(this.textField.text);
            this.mcItemDescrBackground.height = this.textField.textHeight + DESCR_PADDING;
         }
      }
      
      public function set shouldShouldRadialPointer(param1:Boolean) : void
      {
         this._shouldShowRadialPointer = param1;
         this.mcRadialPointer.visible = param1;
      }
      
      public function get dynamicMouseCenterX() : Number
      {
         return this._dynamicMouseCenterX;
      }
      
      public function set dynamicMouseCenterX(param1:Number) : void
      {
         this._dynamicMouseCenterX = param1;
         if(this.mcDBGMouseCenter)
         {
            this.mcDBGMouseCenter.x = this._dynamicMouseCenterX;
         }
      }
      
      public function get dynamicMouseCenterY() : Number
      {
         return this._dynamicMouseCenterY;
      }
      
      public function set dynamicMouseCenterY(param1:Number) : void
      {
         this._dynamicMouseCenterY = param1;
         if(this.mcDBGMouseCenter)
         {
            this.mcDBGMouseCenter.y = this._dynamicMouseCenterY;
         }
      }
      
      protected function handleControllerChange(param1:ControllerChangeEvent) : void
      {
         this.shouldShouldRadialPointer = this._shouldShowRadialPointer;
      }
      
      protected function registerMouseEvents() : void
      {
         if(!this.mouseEventsRegistered)
         {
            this.mouseEventsRegistered = true;
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove,false,0,true);
            stage.addEventListener(MouseEvent.CLICK,this.handleClick,false,0,true);
            stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheel,false,0,true);
            stage.addEventListener(MouseEvent.DOUBLE_CLICK,this.handleDoubleClick,false,0,true);
            stage.doubleClickEnabled = true;
            stage.mouseChildren = false;
         }
      }
      
      protected function unregisterMouseEvents() : void
      {
         if(this.mouseEventsRegistered)
         {
            this.mouseEventsRegistered = false;
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove);
            stage.removeEventListener(MouseEvent.CLICK,this.handleClick);
            stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheel);
            stage.removeEventListener(MouseEvent.DOUBLE_CLICK,this.handleDoubleClick);
            stage.doubleClickEnabled = false;
            stage.mouseChildren = true;
         }
      }
      
      protected function handleMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc7_:* = undefined;
         var _loc3_:int = -1;
         var _loc5_:Number = param1.stageX - this._dynamicMouseCenterX;
         var _loc6_:Number = param1.stageY - this._dynamicMouseCenterY;
         _loc2_ = Math.sqrt(Math.pow(_loc5_,2) + Math.pow(_loc6_,2));
         if(_loc2_ > MOUSE_DEAD_ZONE)
         {
            if(_loc2_ > MAX_DISTANCE_FROM_CENTER)
            {
               this.dynamicMouseCenterX = param1.stageX + -_loc5_ / _loc2_ * MAX_DISTANCE_FROM_CENTER;
               this.dynamicMouseCenterY = param1.stageY + -_loc6_ / _loc2_ * MAX_DISTANCE_FROM_CENTER;
            }
            _loc7_ = Math.atan2(this._dynamicMouseCenterY - param1.stageY,param1.stageX - this._dynamicMouseCenterX);
            _loc3_ = this.getSubCategoryFromAngle(_loc7_,true);
         }
         if(_loc3_ != -1)
         {
            this.updateRadialPointer(_loc7_);
            this.SetSubCategory(_loc3_,false);
         }
      }
      
      protected function handleClick(param1:MouseEvent) : void
      {
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(_loc2_.buttonIdx == MouseEventEx.LEFT_BUTTON)
         {
            if(this._lastSetSelection != -1)
            {
               if(this.activateSelectedSlot())
               {
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnRequestCloseRadial"));
               }
            }
         }
         else if(_loc2_.buttonIdx == MouseEventEx.RIGHT_BUTTON)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnRequestCloseRadial"));
         }
      }
      
      protected function handleDoubleClick(param1:MouseEvent) : void
      {
         this.activateSelectedSlot();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnRequestCloseRadial"));
      }
      
      protected function handleMouseWheel(param1:MouseEvent) : void
      {
         var _loc2_:RadialMenuItemEquipped = this.mcRadialMenuFields.GetSelectedRadialMenuField() as RadialMenuItemEquipped;
         if(_loc2_)
         {
            if(param1.delta > 0)
            {
               _loc2_.nextSubItem();
            }
            else
            {
               _loc2_.priorSubItem();
            }
         }
      }
      
      protected function activateSelectedSlot() : Boolean
      {
         var _loc1_:RadialMenuItemEquipped = null;
         var _loc2_:String = null;
         if(this.pendingTimer)
         {
            this.handlePendedDataUpdate();
         }
         if(this._lastSetSelection != -1)
         {
            _loc1_ = this.mcRadialMenuFields.GetSelectedRadialMenuField() as RadialMenuItemEquipped;
            if(_loc1_)
            {
               _loc2_ = _loc1_.getCurrentSlotName();
            }
            else
            {
               _loc2_ = String(this.SlotsNames[this._lastSetSelection]);
            }
            if(_loc2_ != "disabled" && !this.mcRadialMenuFields.IsDesatureted(_loc2_))
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnActivateSlot",[_loc2_]));
               return true;
            }
         }
         return false;
      }
      
      private function configLabels() : void
      {
         this.mcLabel.visible = false;
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:InputAxisData = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc14_:RadialMenuItemEquipped = null;
         var _loc12_:InputDetails;
         var _loc13_:Boolean = (_loc12_ = param1.details).value == InputValue.KEY_DOWN || _loc12_.value == InputValue.KEY_HOLD;
         if(!this.bCheckStick)
         {
            return;
         }
         if(this._isAlternativeInputMode)
         {
            _loc10_ = NavigationCode.LEFT;
            _loc9_ = NavigationCode.RIGHT;
            _loc11_ = KeyCode.PAD_RIGHT_STICK_AXIS;
         }
         else
         {
            _loc10_ = NavigationCode.RIGHT_STICK_LEFT;
            _loc9_ = NavigationCode.RIGHT_STICK_RIGHT;
            _loc11_ = KeyCode.PAD_LEFT_STICK_AXIS;
         }
         if(_loc12_.value == InputValue.KEY_UP && (_loc12_.navEquivalent == NavigationCode.GAMEPAD_L1 || _loc12_.code == KeyCode.TAB))
         {
            if(this.holdCloseTimer == null)
            {
               this.activateSelectedSlot();
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnRequestCloseRadial"));
            }
            else
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnRadialPauseGame"));
            }
            return;
         }
         if(_loc12_.value == InputValue.KEY_UP && !this.bIsCiri)
         {
            if(_loc12_.navEquivalent == _loc10_ || !this._isAlternativeInputMode && _loc12_.navEquivalent == NavigationCode.DPAD_LEFT || _loc12_.code == KeyCode.A)
            {
               if(_loc14_ = this.mcRadialMenuFields.GetSelectedRadialMenuField() as RadialMenuItemEquipped)
               {
                  _loc14_.priorSubItem();
               }
            }
            else if(_loc12_.navEquivalent == _loc9_ || !this._isAlternativeInputMode && _loc12_.navEquivalent == NavigationCode.DPAD_RIGHT || _loc12_.code == KeyCode.D)
            {
               if(_loc14_ = this.mcRadialMenuFields.GetSelectedRadialMenuField() as RadialMenuItemEquipped)
               {
                  _loc14_.nextSubItem();
               }
            }
         }
         switch(_loc12_.code)
         {
            case _loc11_:
               if(!this.bIsCiri)
               {
                  _loc2_ = InputAxisData(_loc12_.value);
                  _loc3_ = _loc2_.xvalue;
                  _loc4_ = _loc2_.yvalue;
                  _loc5_ = InputUtils.getMagnitude(_loc3_,_loc4_);
                  _loc6_ = _loc5_ * _loc5_ * _loc5_;
                  if(_loc5_ < 0.5)
                  {
                     break;
                  }
                  _loc7_ = Math.atan2(_loc4_,_loc3_);
                  _loc8_ = this.getSubCategoryFromAngle(_loc7_,false);
                  this.updateRadialPointer(_loc7_);
                  this.SetSubCategory(_loc8_);
               }
               break;
            case KeyCode.ESCAPE:
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnRequestCloseRadial"));
               break;
            case KeyCode.E:
            case KeyCode.ENTER:
               this.activateSelectedSlot();
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnRequestCloseRadial"));
         }
      }
      
      protected function getSubCategoryFromAngle(param1:Number, param2:Boolean) : int
      {
         var _loc3_:int = Math.round(Math.abs(param1 - Math.PI) / this.ITEM_SECTOR);
         if(_loc3_ >= this.ITEM_COUNT)
         {
            _loc3_ = 0;
         }
         return _loc3_;
      }
      
      protected function updateRadialPointer(param1:Number) : void
      {
         this.mcRadialPointer.rotation = (-param1 + Math.PI / 2) * 180 / Math.PI;
      }
      
      public function setSelectedItem(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         _loc3_ = 0;
         while(_loc3_ < this.SlotsNames.length)
         {
            if(this.SlotsNames[_loc3_] == param1)
            {
               _loc4_ = -_loc3_ * this.ITEM_SECTOR + Math.PI;
               this.SetSubCategory(_loc3_,true,param2);
               this.updateRadialPointer(_loc4_);
               break;
            }
            _loc3_++;
         }
      }
      
      private function SetSubCategory(param1:int, param2:Boolean = true, param3:Boolean = false) : void
      {
         if(!param2 && param1 == -1)
         {
            return;
         }
         if((this.subCategory != this.SlotsNames[param1] || param3) && this.subCategory != "disabled")
         {
            if(this.subCategory != "none")
            {
               this.deselectSubCategory(this.subCategoryID);
            }
            this.subCategory = param1 == -1 ? "none" : String(this.SlotsNames[param1]);
            this.subCategoryID = param1;
            this.selectSubCategory(param1);
         }
      }
      
      private function deselectSubCategory(param1:int) : void
      {
         var _loc2_:RadialMenuItem = null;
         if(param1 != -1)
         {
            _loc2_ = this.mcRadialMenuFields.GetRadialMenuFieldByID(param1);
            this.SetSelection(-1);
            this.mcRadialMenuFields.SetDeselected(param1);
            this.updateItemDescrBackground();
         }
      }
      
      private function selectSubCategory(param1:int) : void
      {
         var _loc2_:String = null;
         var _loc3_:RadialMenuItemEquipped = null;
         var _loc4_:RadialMenuItem = null;
         if(param1 != -1)
         {
            _loc2_ = this.SlotsNames[param1] as String;
            if(_loc2_ != "disabled")
            {
               if(!this.mcRadialMenuFields.SetSelected(param1) && !this.bIsCiri)
               {
                  this.mcLabel.visible = false;
                  this.textField.visible = false;
                  this.mcItemDescrBackground.visible = false;
                  return;
               }
               this.SetSelection(param1);
               if(this.GetCurrentItemIcon() != "")
               {
                  this.pendingLabel = this.GetCurrentItemName();
               }
               else
               {
                  this.pendingLabel = "[[" + _loc2_ + "]]";
               }
               _loc3_ = this.mcRadialMenuFields.GetSelectedRadialMenuField() as RadialMenuItemEquipped;
               if(_loc3_)
               {
                  this.pendingCategory = _loc3_.getCurrentSlotName();
                  this.pendingDescription = _loc3_.GetItemDescription();
                  this.updateSelectedSlotItemFeedback(_loc3_);
               }
               else
               {
                  this.pendingDescription = this.GetCurrentItemDescription();
                  this.pendingCategory = this.subCategory;
                  if((Boolean(_loc4_ = this.mcRadialMenuFields.GetSelectedRadialMenuField() as RadialMenuItem)) && !_loc4_.IsDesatureted())
                  {
                     this.mcInputFeedback.appendButton(this.BTN_ID_ACCEPT,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_button_common_select_radial_item]]");
                  }
                  else
                  {
                     this.mcInputFeedback.removeButton(this.BTN_ID_ACCEPT);
                  }
                  this.mcInputFeedback.removeButton(this.BTN_ID_SWITCH,true);
               }
               this.pendingIsDesaturated = this.mcRadialMenuFields.IsDesatureted(_loc2_);
               this.handlePendedDataUpdate();
            }
         }
         else
         {
            this.SetSelection(param1);
         }
         if(this.bIsCiri)
         {
         }
      }
      
      private function updateSelectedSlotItemFeedback(param1:RadialMenuItemEquipped) : void
      {
         var _loc2_:String = null;
         if(!param1.IsDesatureted() && Boolean(param1.data))
         {
            this.mcInputFeedback.appendButton(this.BTN_ID_ACCEPT,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_button_common_select_radial_item]]");
         }
         else
         {
            this.mcInputFeedback.removeButton(this.BTN_ID_ACCEPT,true);
         }
         if(param1.isSwitchable())
         {
            _loc2_ = param1.isCrossbow() ? "[[hud_radial_change_bolt]]" : "[[hud_radial_change_item]]";
            this.mcInputFeedback.removeButton(this.BTN_ID_SWITCH,false);
            if(this._isAlternativeInputMode)
            {
               this.mcInputFeedback.appendButton(this.BTN_ID_SWITCH,"gamepad_L_Tab",KeyCode.MOUSE_SCROLL,_loc2_,true);
            }
            else
            {
               this.mcInputFeedback.appendButton(this.BTN_ID_SWITCH,NavigationCode.GAMEPAD_RSTICK_TAB,KeyCode.MOUSE_SCROLL,_loc2_,true);
            }
         }
         else
         {
            this.mcInputFeedback.removeButton(this.BTN_ID_SWITCH,true);
         }
      }
      
      private function handlePendedDataUpdate(param1:TimerEvent = null) : void
      {
         if(this.pendingTimer)
         {
            this.pendingTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.handlePendedDataUpdate);
            this.pendingTimer.stop();
            this.pendingTimer = null;
         }
         this.textField.visible = true;
         this.textField.text = this.pendingDescription;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnRadialMenuItemSelected",[this.pendingCategory,this.pendingIsDesaturated]));
         this.updateItemDescrBackground();
      }
      
      public function SetChoosenDescription(param1:String) : void
      {
         this.textField.htmlText = param1;
         this.textField.height = this.textField.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         this.updateItemDescrBackground();
      }
      
      private function SendChoosen() : void
      {
         var _loc1_:String = null;
         _loc1_ = this.subCategory;
         if(_loc1_ != "" && _loc1_ != "none" && _loc1_ != "disabled")
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnRadialMenuItemChoose",[_loc1_]));
         }
      }
      
      public function ShowRadialMenu(param1:Boolean) : void
      {
      }
      
      override public function ShowElementFromState(param1:Boolean, param2:Boolean = false) : void
      {
         if(!this.bBlockRadialMenu)
         {
            if(!param1 && this.bCheckStick)
            {
               visible = false;
               this.alpha = 0;
               this.desiredAlpha = 0;
               this.unregisterMouseEvents();
               InputManager.getInstance().removeInputBlocker("HUD_RADIAL");
               this.dynamicMouseCenterX = CENTER_X;
               this.dynamicMouseCenterY = CENTER_Y;
               if(this.holdCloseTimer)
               {
                  this.holdCloseTimer.removeEventListener(TimerEvent.TIMER,this.handleHoldTimer,false);
                  this.holdCloseTimer.stop();
                  this.holdCloseTimer = null;
               }
               if(!this.bIsCiri)
               {
                  this.mcRadialMenuFields.Init();
               }
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnHideRadialMenu"));
            }
            else if(param1 && !this.bCheckStick)
            {
               visible = true;
               this.alpha = OPACITY_MAX;
               this.desiredAlpha = OPACITY_MAX;
               if(this.holdCloseTimer)
               {
                  this.holdCloseTimer.removeEventListener(TimerEvent.TIMER,this.handleHoldTimer,false);
                  this.holdCloseTimer.stop();
               }
               this.holdCloseTimer = new Timer(this.HOLD_CLOSE_DELAY);
               this.holdCloseTimer.addEventListener(TimerEvent.TIMER,this.handleHoldTimer,false,0,true);
               this.holdCloseTimer.start();
               focused = 1;
               this.registerMouseEvents();
               InputManager.getInstance().addInputBlocker(false,"HUD_RADIAL");
               if(this.bIsCiri)
               {
               }
            }
            this.bCheckStick = param1;
         }
      }
      
      private function handleHoldTimer(param1:Event) : void
      {
         if(this.holdCloseTimer)
         {
            this.holdCloseTimer.removeEventListener(TimerEvent.TIMER,this.handleHoldTimer,false);
            this.holdCloseTimer.stop();
            this.holdCloseTimer = null;
         }
      }
      
      public function BlockRadialMenu(param1:Boolean) : *
      {
         this.bBlockRadialMenu = param1;
      }
      
      private function SetSelection(param1:int) : void
      {
         var _loc2_:MovieClip = null;
         if(this._lastSetSelection == param1)
         {
            return;
         }
         if(this._lastSetSelection != -1)
         {
            _loc2_ = this.mcSelection.getChildByName("mcSelector" + (this._lastSetSelection + 1)) as MovieClip;
            if(Boolean(_loc2_) && _loc2_.currentLabel != "start")
            {
               _loc2_.gotoAndPlay("FadeOut");
            }
         }
         this._lastSetSelection = param1;
         if(this._lastSetSelection != -1)
         {
            _loc2_ = this.mcSelection.getChildByName("mcSelector" + (this._lastSetSelection + 1)) as MovieClip;
            if(_loc2_)
            {
               _loc2_.gotoAndPlay("FadeIn");
            }
         }
      }
      
      public function UpdateItemIcon(param1:int, param2:String, param3:String, param4:String, param5:String, param6:int) : void
      {
         var _loc7_:RadialMenuItem = null;
         var _loc8_:String = null;
         if(_loc7_ = this.mcRadialMenuFields.GetRadialMenuFieldByID(param1) as RadialMenuItem)
         {
            _loc7_.SetIcon(param2,param3,param4,param5,param6);
         }
      }
      
      private function GetCurrentItemIcon() : String
      {
         var _loc1_:RadialMenuItem = null;
         var _loc2_:String = "";
         _loc1_ = this.mcRadialMenuFields.GetRadialMenuFieldByName(this.subCategory) as RadialMenuItem;
         if(_loc1_)
         {
            _loc2_ = _loc1_.GetIconPath();
         }
         return _loc2_;
      }
      
      private function GetCurrentItemName() : String
      {
         var _loc1_:RadialMenuItem = null;
         var _loc2_:String = "";
         _loc1_ = this.mcRadialMenuFields.GetRadialMenuFieldByName(this.subCategory) as RadialMenuItem;
         if(_loc1_)
         {
            _loc2_ = _loc1_.GetItemName();
         }
         return _loc2_;
      }
      
      private function GetCurrentItemDescription() : String
      {
         var _loc1_:RadialMenuItem = null;
         var _loc2_:String = "";
         _loc1_ = this.mcRadialMenuFields.GetRadialMenuFieldByName(this.subCategory) as RadialMenuItem;
         if(_loc1_)
         {
            _loc2_ = _loc1_.GetItemDescription();
         }
         return _loc2_;
      }
      
      public function UpdateFieldEquippedState(param1:String, param2:String, param3:Boolean, param4:int) : void
      {
         var _loc5_:RadialMenuItem = null;
         var _loc6_:RadialMenuItem = null;
         var _loc7_:InputDelegate = null;
         var _loc8_:String = null;
         if(_loc5_ = this.mcRadialMenuFields.GetRadialMenuFieldByName(param1) as RadialMenuItem)
         {
            _loc7_ = InputDelegate.getInstance();
            if(param1 == "Aard" || param1 == "Yrden" || param1 == "Igni" || param1 == "Quen" || param1 == "Axii")
            {
               if(_loc6_ = this.mcRadialMenuFields.GetRadialMenuFieldByName("Aard") as RadialMenuItem)
               {
                  _loc6_["mcEquipped"].visible = false;
               }
               if(_loc6_ = this.mcRadialMenuFields.GetRadialMenuFieldByName("Yrden") as RadialMenuItem)
               {
                  _loc6_["mcEquipped"].visible = false;
               }
               if(_loc6_ = this.mcRadialMenuFields.GetRadialMenuFieldByName("Igni") as RadialMenuItem)
               {
                  _loc6_["mcEquipped"].visible = false;
               }
               if(_loc6_ = this.mcRadialMenuFields.GetRadialMenuFieldByName("Quen") as RadialMenuItem)
               {
                  _loc6_["mcEquipped"].visible = false;
               }
               if(_loc6_ = this.mcRadialMenuFields.GetRadialMenuFieldByName("Axii") as RadialMenuItem)
               {
                  _loc6_["mcEquipped"].visible = false;
               }
            }
            _loc5_["mcEquipped"].visible = param3;
            if(param3)
            {
               _loc5_["mcEquipped"].gotoAndPlay(2);
            }
            if(param3)
            {
            }
         }
      }
      
      public function UpdateFieldDescription(param1:RadialMenuItem) : void
      {
         if(param1)
         {
            if(param1.getRadialItemName() == "Meditation")
            {
               return;
            }
            if(param1.IsItemField())
            {
            }
         }
      }
      
      public function SetDesaturated(param1:Boolean, param2:String) : *
      {
         this.mcRadialMenuFields.SetDesatureted(param2,param1);
         this.SetSelectionDesaturated(param1,param2);
      }
      
      public function SetSelectionDesaturated(param1:Boolean, param2:String) : *
      {
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:ColorMatrixFilter = null;
         _loc4_ = 0;
         while(_loc4_ < this.SlotsNames.length)
         {
            if(param2 == this.SlotsNames[_loc4_])
            {
               _loc5_ = _loc4_;
            }
            _loc4_++;
         }
         _loc3_ = this.mcSelection.getChildByName("mcSelector" + _loc5_) as MovieClip;
         if(param1)
         {
            _loc6_ = CommonUtils.getDesaturateFilter();
            _loc3_.filters = [_loc6_];
            _loc3_.alpha = 0.5;
         }
         else
         {
            _loc3_.filters = [];
            _loc3_.alpha = 1;
         }
      }
      
      public function SetMeditationButtonEnabled(param1:Boolean) : *
      {
         if(!this.bIsCiri)
         {
            if(param1)
            {
               this.mcMeditationBtnBck.alpha = 1;
               this.mcInputFeedback.appendButton(this.BTN_ID_MEDITATION,NavigationCode.GAMEPAD_X,KeyCode.SPACE,"[[panel_title_meditation]]",true);
            }
            else
            {
               this.mcMeditationBtnBck.alpha = 0.5;
               this.mcInputFeedback.removeButton(this.BTN_ID_MEDITATION,true);
            }
         }
      }
      
      public function setCiriItem(param1:String, param2:String, param3:String) : *
      {
         if(param1 != "")
         {
            this.mcIconLoaderMedalion.source = "img://" + param1;
         }
         else
         {
            this.mcIconLoaderMedalion.source = "";
         }
         this.textFieldMedalionUp.htmlText = param2;
         this.textFieldMedalionUp.htmlText = CommonUtils.toUpperCaseSafe(this.textFieldMedalionUp.htmlText);
         this.textFieldMedalion.htmlText = param3;
         this.textFieldMedalion.visible = true;
         this.textFieldMedalionUp.visible = true;
      }
      
      override public function SetScaleFromWS(param1:Number) : void
      {
      }
      
      internal function __setProp_mcIconLoaderMedalion_Scene1_mcIconLoader_0() : *
      {
         try
         {
            this.mcIconLoaderMedalion["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcIconLoaderMedalion.autoSize = true;
         this.mcIconLoaderMedalion.enableInitCallback = false;
         this.mcIconLoaderMedalion.maintainAspectRatio = true;
         this.mcIconLoaderMedalion.source = "";
         this.mcIconLoaderMedalion.visible = false;
         try
         {
            this.mcIconLoaderMedalion["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}
