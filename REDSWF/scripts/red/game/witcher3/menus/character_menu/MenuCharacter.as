package red.game.witcher3.menus.character_menu
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Sine;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import red.core.CoreMenu;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.InventoryActionType;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.events.SlotActionEvent;
   import red.game.witcher3.managers.ContextInfoManager;
   import red.game.witcher3.managers.InputFeedbackManager;
   import red.game.witcher3.slots.SlotBase;
   import red.game.witcher3.slots.SlotInventoryGrid;
   import red.game.witcher3.slots.SlotSkillGrid;
   import red.game.witcher3.slots.SlotSkillMutagen;
   import red.game.witcher3.slots.SlotSkillSocket;
   import red.game.witcher3.slots.SlotsTransferManager;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.interfaces.IListItemRenderer;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.Extensions;
   
   public class MenuCharacter extends CoreMenu
   {
       
      
      private const UNEQUIP_MUTAGEN_HOLD_DURATION:Number = 1000;
      
      public var moduleSkillTabList:CharacterTabbedListModule;
      
      public var moduleSkillSlot:ModuleSkillsSockets;
      
      public var applyMode:CharacterModeBackground;
      
      public var tooltipAnchor:DisplayObject;
      
      public var txfAvailablePoints:TextField;
      
      public var txfPointsValue:TextField;
      
      public var btnMutationMode:InputFeedbackButton;
      
      public var mcPointIcon:MovieClip;
      
      public var mcPointsBorder:MovieClip;
      
      public var mcBackgroundImage:MovieClip;
      
      public var mcRunewordIcon:MovieClip;
      
      public var tfRunewordDescription:TextField;
      
      public var _calledWSChange:Boolean = false;
      
      public var _pointsCount:int = 0;
      
      protected var _cachedSlotData:Object;
      
      protected var _holdY_triggered:Boolean = false;
      
      public var mcMasterMutation:MasterMutationItemRenderer;
      
      private var _isMutationEnabled:Boolean = false;
      
      private var _mcMutationPanel:MutationsPanel;
      
      private var _btn_mutation:int = -1;
      
      private var _btn_switch_sections:int = -1;
      
      private var _isMutationInited:Boolean = false;
      
      public function MenuCharacter()
      {
         super();
         this.moduleSkillTabList.noDelay = true;
         this.applyMode.deactivate();
         this.btnMutationMode.visible = true;
         this.btnMutationMode.setDataFromStage(NavigationCode.GAMEPAD_Y,KeyCode.C);
         this.btnMutationMode.clickable = false;
         this.btnMutationMode.mouseChildren = this.btnMutationMode.mouseEnabled = false;
         if(this.mcMasterMutation)
         {
            this.mcMasterMutation.enabled = false;
            this.mcMasterMutation.selectable = false;
            this.mcMasterMutation.visible = false;
            this.mcMasterMutation.mouseChildren = this.mcMasterMutation.mouseEnabled = false;
            this.mcMasterMutation.addEventListener(MouseEvent.CLICK,this.handleMasterMutationClick,false,0,true);
         }
         this.__setProp_moduleSkillTabList_Scene1_moduleSkillTabList_0();
         this.__setProp_mcMasterMutation_Scene1_equippedMutation_0();
      }
      
      override protected function get menuName() : String
      {
         return "CharacterMenu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         if(this.mcRunewordIcon)
         {
            this.mcRunewordIcon.visible = false;
         }
         if(this.tfRunewordDescription)
         {
            this.tfRunewordDescription.visible = false;
         }
         this.txfAvailablePoints.text = "[[panel_character_availablepoints]]";
         this.txfAvailablePoints.text = CommonUtils.toUpperCaseSafe(this.txfAvailablePoints.text);
         this.txfPointsValue.text = "0";
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"character.skills.grid",[this.updateSkillsGrid]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"character.skills.slots",[this.updateSkillsSockets]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"character.skills.slot.update",[this.updateSkillSocket]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"character.skills.mutagens",[this.updateSkillMutagens]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"character.skills.points",[this.setSkillPoints]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"character.groups.bonus",[this.updateGroupsBonus]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"character.skills.grid.stable",[this.stableUpdateSkillsGrid]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"character.paperdoll.changed",[this.onPaperdollChanged]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"character.mutations.list",[this.setMutationDataList]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"character.mutation",[this.setSingleMutationData]));
         if(!Extensions.isScaleform)
         {
            this.initDebugData();
         }
         this.moduleSkillTabList.addEventListener(SlotActionEvent.EVENT_ACTIVATE,this.handleSkillAction,false,0,true);
         this.moduleSkillSlot.addEventListener(SlotActionEvent.EVENT_ACTIVATE,this.handleSlotAction,false,0,true);
         this.moduleSkillSlot.socketsList.addEventListener(ListEvent.INDEX_CHANGE,this.onSlotSelected,false,0,true);
         this.moduleSkillSlot.addEventListener(SlotActionEvent.EVENT_SELECT,this.handleSlotActivate,false,0,true);
         this.moduleSkillTabList.addEventListener(SlotActionEvent.EVENT_SECONDARY_ACTION,this.handleSkillSecondaryAction,false,0,true);
         this.moduleSkillSlot.addEventListener(SlotActionEvent.EVENT_SECONDARY_ACTION,this.handleSkillSecondaryAction,false,0,true);
         this.applyMode.addEventListener(CharacterModeBackground.CANCEL,this.handleApplyModeCancel,false,0,true);
         this.applyMode.addEventListener(CharacterModeBackground.ACCEPT,this.handleApplyModeAccept,false,0,true);
         _contextMgr.defaultAnchor = this.tooltipAnchor;
         _contextMgr.addGridEventsTooltipHolder(stage);
         _contextMgr.addEventListener(ContextInfoManager.TOOLTIP_SHOW_ERROR,this.handleTooltipFailedToShow,false,0,true);
         _contextMgr.enableInputFeedbackShowing(true);
         _contextMgr.saveScaleValue = true;
         currentModuleIdx = 1;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         if(this._btn_switch_sections == -1)
         {
            this._btn_switch_sections = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_R3,-1,"panel_button_common_jump_sections");
         }
         InputFeedbackManager.updateButtons(this);
      }
      
      public function get mcMutationPanel() : MutationsPanel
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:String = null;
         var _loc4_:Class = null;
         if(!this._mcMutationPanel)
         {
            _loc1_ = -23.6;
            _loc2_ = 8.55;
            _loc3_ = "MutationPanelRef";
            _loc4_ = getDefinitionByName(_loc3_) as Class;
            this._mcMutationPanel = new _loc4_() as MutationsPanel;
            this._mcMutationPanel.x = _loc1_;
            this._mcMutationPanel.y = _loc2_;
            this._mcMutationPanel.addEventListener(Event.ACTIVATE,this.handleMutationPanelToggled,false,0,true);
            this._mcMutationPanel.addEventListener(Event.DEACTIVATE,this.handleMutationPanelToggled,false,0,true);
            addChild(this._mcMutationPanel);
            this._mcMutationPanel.validateNow();
            this._isMutationInited = true;
         }
         return this._mcMutationPanel;
      }
      
      public function confirmMutationResearch() : void
      {
      }
      
      public function setMutationDataList(param1:Array) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:MasterMutationItemRenderer;
         (_loc4_ = this.mcMutationPanel.mcMutation13 as MasterMutationItemRenderer).resetColor();
         this.mcMasterMutation.resetColor();
         if(param1)
         {
            _loc5_ = int(param1.length);
            this._isMutationEnabled = _loc5_ > 0;
            this.moduleSkillSlot.mutationMode = this._isMutationEnabled;
            if(!this._isMutationEnabled)
            {
               this.btnMutationMode.visible = false;
               this.mcMasterMutation.visible = false;
               this.mcMasterMutation.mouseChildren = this.mcMasterMutation.mouseEnabled = false;
            }
            else
            {
               if(this._btn_mutation == -1)
               {
                  this._btn_mutation = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_Y,KeyCode.C,"mutation_title_mutations");
               }
               this.btnMutationMode.visible = !this.mcMutationPanel.active;
               this.mcMutationPanel.setDataList(param1);
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  if((_loc7_ = param1[_loc6_]).isEquipped)
                  {
                     this.mcMutationPanel.equippedMutationId = _loc7_.mutationId;
                     _loc4_.setColorByMutationId(_loc7_.mutationId);
                     this.mcMasterMutation.setColorByMutationId(_loc7_.mutationId);
                     this.mcMasterMutation.setEquippedMutationData(_loc7_);
                     _loc2_ = true;
                     if(_loc3_)
                     {
                        break;
                     }
                  }
                  else if(_loc7_.isMasterMutation)
                  {
                     this.mcMasterMutation.data = _loc7_;
                     this.mcMasterMutation.validateNow();
                     this.mcMasterMutation.visible = true;
                     this.mcMasterMutation.enabled = false;
                     this.mcMasterMutation.selectable = false;
                     this.mcMasterMutation.mouseChildren = this.mcMasterMutation.mouseEnabled = true;
                     _loc3_ = true;
                     if(_loc2_)
                     {
                        break;
                     }
                  }
                  _loc6_++;
               }
               if(!_loc2_)
               {
                  this.mcMutationPanel.equippedMutationId = -1;
                  this.mcMasterMutation.hideDescription(true);
                  this.moduleSkillSlot.additionalSkillsMode = false;
               }
               else
               {
                  this.mcMasterMutation.hideDescription(false);
                  this.moduleSkillSlot.additionalSkillsMode = true;
               }
            }
         }
      }
      
      public function setSingleMutationData(param1:Object) : void
      {
         if(Boolean(param1) && Boolean(param1.isEquipped))
         {
            this.mcMasterMutation.data = param1;
            this.mcMasterMutation.setEquippedMutationData(param1);
            this.mcMasterMutation.setColorByMutationId(param1.mutationId);
            this.mcMasterMutation.hideDescription(false);
            this.mcMasterMutation.validateNow();
         }
         if(this._isMutationInited)
         {
            this.mcMutationPanel.setSingleMutationData(param1);
         }
         if(!this._isMutationEnabled)
         {
            this._isMutationEnabled = true;
            this.moduleSkillSlot.mutationMode = this._isMutationEnabled;
         }
      }
      
      public function setMutationBonusMode(param1:Boolean) : void
      {
         this._isMutationEnabled = param1;
         if(this._isMutationEnabled)
         {
            this.moduleSkillSlot.mutationMode = this._isMutationEnabled;
         }
         else
         {
            this.btnMutationMode.visible = false;
            this.mcMasterMutation.visible = false;
            this.mcMasterMutation.enabled = false;
            this.mcMasterMutation.selectable = false;
            this.mcMasterMutation.mouseChildren = this.mcMasterMutation.mouseEnabled = false;
         }
         this.mcMasterMutation.hideDescription(true);
      }
      
      public function activateRunwordBuf(param1:Boolean, param2:String) : void
      {
         if(Boolean(this.mcRunewordIcon) && Boolean(this.tfRunewordDescription))
         {
            this.mcRunewordIcon.visible = param1;
            this.tfRunewordDescription.visible = param1;
            this.tfRunewordDescription.htmlText = param2;
            this.mcRunewordIcon.y = this.tfRunewordDescription.y + this.tfRunewordDescription.textHeight / 2;
         }
         SlotSkillSocket.GLOW_EQUIPPED = param1;
      }
      
      private function enableMutationButton(param1:Boolean) : void
      {
      }
      
      private function onCallUnequipMutation() : void
      {
         this._holdY_triggered = true;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnUnequipMutation"));
      }
      
      protected function startApplyMode(param1:SlotBase) : void
      {
         if(_inCombat)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnSendNotification",["menu_cannot_perform_action_combat"]));
         }
         else
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnStartApplyMode"));
            this.applyMode.activate(param1);
            this.moduleSkillTabList._inputEnabled = false;
            if(param1 is SlotSkillGrid)
            {
               this.moduleSkillSlot.disableMutagens(true);
               this.moduleSkillSlot.SetUnselectableLockedAndMutagens(param1.data.color);
            }
            else
            {
               this.moduleSkillSlot.disableNonMutagensAndLocked();
            }
            this.moduleSkillSlot.setSelectionMode(true);
            this.moduleSkillSlot.socketsList.ReselectIndexIfInvalid(this.moduleSkillSlot.socketsList.selectedIndex);
            this.moduleSkillTabList.enabled = false;
            currentModuleIdx = 0;
            this._cachedSlotData = param1.data;
            SlotsTransferManager.getInstance().disabled = true;
            this.enableMutationButton(false);
            _contextMgr.enableInputFeedbackShowing(false);
         }
      }
      
      protected function endApplyMode() : void
      {
         this.moduleSkillTabList._inputEnabled = true;
         this.applyMode.deactivate();
         this.moduleSkillSlot.disableMutagens(false);
         this.moduleSkillSlot.SetAllSelectable();
         this.moduleSkillSlot.setSelectionMode(false);
         this.moduleSkillTabList.enabled = true;
         currentModuleIdx = 0;
         this._cachedSlotData = null;
         SlotsTransferManager.getInstance().disabled = false;
         _contextMgr.enableInputFeedbackShowing(true);
      }
      
      override protected function handleInputNavigate(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = param1.details;
         var _loc3_:Boolean = _loc2_.value == InputValue.KEY_UP && !param1.handled;
         if(_loc2_.value == InputValue.KEY_UP && _loc2_.navEquivalent == NavigationCode.GAMEPAD_Y && this._holdY_triggered)
         {
            this._holdY_triggered = false;
            param1.handled = true;
            return;
         }
         if(_loc3_)
         {
            switch(_loc2_.navEquivalent)
            {
               case NavigationCode.GAMEPAD_Y:
                  if(this._isMutationEnabled && this.btnMutationMode.getCurrentHoldProgress() < 0.1 && !this.applyMode.isActive())
                  {
                     this.mcMutationPanel.active = !this.mcMutationPanel.active;
                     param1.handled = true;
                     param1.stopImmediatePropagation();
                  }
                  break;
               case NavigationCode.GAMEPAD_A:
                  if(this.applyMode.isActive())
                  {
                     this.handleApplyModeAccept();
                     param1.handled = true;
                     param1.stopImmediatePropagation();
                  }
                  break;
               case NavigationCode.GAMEPAD_B:
                  if(this.applyMode.isActive())
                  {
                     this.endApplyMode();
                     dispatchEvent(new GameEvent(GameEvent.CALL,"OnCancelApplyMode"));
                     param1.handled = true;
                     param1.stopImmediatePropagation();
                     return;
                  }
                  break;
               case NavigationCode.GAMEPAD_R2:
            }
            if(_loc2_.code == KeyCode.C)
            {
               if(this._isMutationEnabled && !this.applyMode.isActive())
               {
                  this.mcMutationPanel.active = !this.mcMutationPanel.active;
                  param1.handled = true;
                  param1.stopImmediatePropagation();
               }
            }
            else if(_loc2_.code == KeyCode.SPACE || _loc2_.code == KeyCode.E)
            {
               if(this.applyMode.isActive())
               {
                  this.handleApplyModeAccept();
                  param1.handled = true;
                  param1.stopImmediatePropagation();
               }
            }
         }
         super.handleInputNavigate(param1);
      }
      
      private function handleMasterMutationClick(param1:Event) : void
      {
         if(this._isMutationEnabled && !this.mcMutationPanel.active && !this.applyMode.isActive())
         {
            this.mcMutationPanel.active = true;
         }
      }
      
      protected function handleMutationPanelToggled(param1:Event) : void
      {
         this.updateMutationPanelVisibility();
         if(this.mcMutationPanel.active)
         {
            SlotsTransferManager.getInstance().disabled = true;
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnOpenMutationPanel"));
            this.moduleSkillSlot.hideInputFeedback = true;
            this.moduleSkillTabList.hideInputFeedback = true;
            this.moduleSkillSlot.enabled = false;
            this.moduleSkillTabList.enabled = false;
            _contextMgr.blockModeSwitching = true;
            _contextMgr.enableInputFeedbackShowing(false);
            if(this._btn_mutation != -1)
            {
               InputFeedbackManager.removeButton(this,this._btn_mutation);
               this._btn_mutation = -1;
            }
            if(this._btn_switch_sections != -1)
            {
               InputFeedbackManager.removeButton(this,this._btn_switch_sections);
               this._btn_switch_sections = -1;
            }
            InputFeedbackManager.updateButtons(this);
         }
         else
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnCloseMutationPanel"));
            SlotsTransferManager.getInstance().disabled = false;
            this.moduleSkillSlot.hideInputFeedback = false;
            this.moduleSkillTabList.hideInputFeedback = false;
            this.moduleSkillSlot.enabled = true;
            this.moduleSkillTabList.enabled = true;
            _contextMgr.blockModeSwitching = false;
            _contextMgr.enableInputFeedbackShowing(true);
            if(this._btn_mutation == -1)
            {
               this._btn_mutation = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_Y,KeyCode.C,"mutation_title_mutations");
            }
            if(this._btn_switch_sections == -1)
            {
               this._btn_switch_sections = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_R3,-1,"panel_button_common_jump_sections");
            }
            InputFeedbackManager.updateButtons(this);
         }
      }
      
      protected function updateMutationPanelVisibility() : void
      {
         GTweener.removeTweens(this.moduleSkillTabList);
         GTweener.removeTweens(this.moduleSkillSlot);
         GTweener.removeTweens(this.mcMutationPanel);
         GTweener.removeTweens(this.mcMasterMutation);
         GTweener.removeTweens(this.mcBackgroundImage);
         if(this.mcMutationPanel.active)
         {
            this.txfPointsValue.visible = false;
            this.mcPointIcon.visible = false;
            this.mcPointsBorder.visible = false;
            this.mcRunewordIcon.visible = false;
            this.btnMutationMode.visible = false;
            this.mcMutationPanel.visible = true;
            this.mcMutationPanel.alpha = 0;
            this.mcRunewordIcon.alpha = 0;
            this.txfAvailablePoints.alpha = 0;
            GTweener.to(this.moduleSkillTabList,0.5,{"alpha":0},{"ease":Sine.easeOut});
            GTweener.to(this.moduleSkillSlot,0.5,{"alpha":0},{"ease":Sine.easeOut});
            GTweener.to(this.mcMasterMutation,0.5,{"alpha":0},{"ease":Sine.easeOut});
            GTweener.to(this.mcBackgroundImage,0.5,{"alpha":0},{"ease":Sine.easeOut});
            GTweener.to(this.mcMutationPanel,0.5,{"alpha":1},{"ease":Sine.easeOut});
         }
         else
         {
            GTweener.to(this.moduleSkillTabList,0.5,{"alpha":1},{"ease":Sine.easeOut});
            GTweener.to(this.moduleSkillSlot,0.5,{"alpha":1},{"ease":Sine.easeOut});
            GTweener.to(this.mcMasterMutation,0.5,{"alpha":1},{"ease":Sine.easeOut});
            GTweener.to(this.mcBackgroundImage,0.5,{"alpha":1},{"ease":Sine.easeOut});
            GTweener.to(this.mcMutationPanel,0.5,{"alpha":0},{
               "ease":Sine.easeOut,
               "onComplete":this.handleMutationHidden
            });
         }
      }
      
      protected function handleMutationHidden(param1:GTween = null) : void
      {
         this.mcMutationPanel.visible = false;
         this.txfAvailablePoints.visible = true;
         this.mcPointsBorder.visible = true;
         this.btnMutationMode.visible = true;
         this.txfPointsValue.visible = true;
         this.mcPointIcon.visible = true;
         this.mcRunewordIcon.alpha = 1;
         this.txfAvailablePoints.alpha = 1;
      }
      
      protected function showFullStats() : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnShowFullStats"));
      }
      
      protected function onSlotSelected(param1:ListEvent) : void
      {
      }
      
      protected function handleSkillAction(param1:SlotActionEvent) : void
      {
         var _loc2_:SlotSkillGrid = param1.targetSlot as SlotSkillGrid;
         var _loc3_:SlotInventoryGrid = param1.targetSlot as SlotInventoryGrid;
         if(param1.actionType == InventoryActionType.DROP)
         {
            return;
         }
         if(_loc2_)
         {
            if(_loc2_.data == null || _loc2_.isLocked || _loc2_.data.isCoreSkill || _loc2_.data.level == 0)
            {
               return;
            }
            if(this.moduleSkillSlot.hasSkillSlotUnlocked())
            {
               this.startApplyMode(_loc2_);
            }
         }
         else if(_loc3_ && _loc3_.data != null && this.moduleSkillSlot.hasMutagenSlotUnlocked())
         {
            this.startApplyMode(_loc3_);
         }
      }
      
      protected function handleSlotAction(param1:SlotActionEvent) : void
      {
         var _loc3_:SlotSkillSocket = null;
         if(this.applyMode.isActive())
         {
            this.handleApplyModeAccept();
            return;
         }
         var _loc2_:SlotSkillMutagen = param1.targetSlot as SlotSkillMutagen;
         if(Boolean(_loc2_) && !_loc2_.isLocked())
         {
            this.mutagenSlotAction(param1.targetSlot as SlotSkillMutagen);
         }
         else
         {
            _loc3_ = param1.targetSlot as SlotSkillSocket;
            if(param1.targetSlot.data.skillPath != SlotSkillSocket.NULL_SKILL || this.applyMode.isActive())
            {
               this.skillSlotAction(param1.targetSlot as SlotSkillGrid);
            }
            else if(_loc3_ && _loc3_.data && !_loc3_.isLocked)
            {
               if(this.moduleSkillTabList.mcTabList.selectedIndex == CharacterTabbedListModule.TabIndex_Mutagens)
               {
                  this.moduleSkillTabList.mcTabList.selectedIndex = CharacterTabbedListModule.TabIndex_Sword;
               }
               this.moduleSkillTabList.open();
               currentModuleIdx = 0;
            }
         }
      }
      
      protected function handleSkillSecondaryAction(param1:SlotActionEvent) : void
      {
         var _loc2_:SlotSkillGrid = param1.targetSlot as SlotSkillGrid;
         if(this.applyMode.isActive())
         {
            this.handleApplyModeAccept();
            return;
         }
         if(_loc2_)
         {
            this.skillSlotSecondaryAction(_loc2_);
         }
      }
      
      protected function skillSlotAction(param1:SlotSkillGrid) : void
      {
         var _loc4_:int = 0;
         var _loc2_:Object = this._cachedSlotData;
         var _loc3_:int = int(param1.data.slotId);
         if(Boolean(_loc2_) && _loc2_.level == 0)
         {
            return;
         }
         if(this.applyMode.isActive())
         {
            _loc4_ = int(_loc2_.skillTypeId);
            this.endApplyMode();
            this.callEquipSkill(_loc4_,_loc3_);
         }
         else
         {
            this.callUnequipSkill(_loc3_);
         }
      }
      
      protected function skillSlotSecondaryAction(param1:SlotSkillGrid) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = false;
         var _loc4_:Boolean = false;
         if(this.applyMode.isActive())
         {
            return;
         }
         if(param1)
         {
            _loc2_ = param1.data;
            _loc3_ = _loc2_.level < _loc2_.maxLevel;
            _loc4_ = _loc3_ && !_loc2_.notEnoughPoints && !param1.isLocked;
            if(_loc2_.notEnoughPoints)
            {
               this.callNotifyNotEnoughtPoints();
               return;
            }
            if(_loc4_)
            {
               this.callUpgradeSkill(_loc2_.skillTypeId);
            }
         }
      }
      
      protected function mutagenSlotAction(param1:SlotSkillMutagen) : void
      {
         if(this.applyMode.isActive())
         {
            this.callEquipMutagen(this._cachedSlotData.id,param1.slotType);
         }
         else if(!param1.isMutEquiped())
         {
            this.moduleSkillTabList.mcTabList.selectedIndex = CharacterTabbedListModule.TabIndex_Mutagens;
            this.moduleSkillTabList.open();
            currentModuleIdx = 0;
         }
         else
         {
            this.callUnequipMutagen(param1.slotType);
         }
      }
      
      protected function handleSlotActivate(param1:SlotActionEvent) : void
      {
         var _loc2_:SlotSkillMutagen = param1.target as SlotSkillMutagen;
         var _loc3_:SlotSkillSocket = param1.target as SlotSkillSocket;
         if(_loc2_)
         {
            this.moduleSkillTabList.onSetTabCalled(CharacterTabbedListModule.TabIndex_Mutagens);
         }
         else if(_loc3_)
         {
            if(param1.data)
            {
               this.moduleSkillTabList.onSetTabCalled(param1.data.tabId);
            }
            else if(this.moduleSkillTabList.currentlySelectedTabIndex == CharacterTabbedListModule.TabIndex_Mutagens)
            {
               this.moduleSkillTabList.onSetTabCalled(CharacterTabbedListModule.TabIndex_Sword);
            }
         }
      }
      
      public function handleApplyModeAccept(param1:Event = null) : void
      {
         var _loc2_:IListItemRenderer = this.moduleSkillSlot.socketsList.getSelectedRenderer();
         var _loc3_:SlotSkillMutagen = _loc2_ as SlotSkillMutagen;
         var _loc4_:SlotSkillSocket = _loc2_ as SlotSkillSocket;
         var _loc5_:Object = this.applyMode.originalSlot.data;
         if(_loc3_)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnEquipMutagen",[uint(_loc5_.id),_loc3_.slotType]));
         }
         else if(_loc4_)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnEquipSkill",[uint(_loc5_.id),_loc4_.slotId]));
         }
         this.endApplyMode();
      }
      
      public function handleApplyModeCancel(param1:Event) : *
      {
         this.endApplyMode();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnCancelApplyMode"));
      }
      
      public function handleTooltipFailedToShow(param1:Event) : *
      {
      }
      
      public function onBuyButtonClicked(param1:ButtonEvent) : *
      {
         if(param1.buttonIdx == 0)
         {
            if(this.moduleSkillTabList.focused)
            {
               this.skillSlotSecondaryAction(this.moduleSkillTabList.mcSkillSlotList.getSelectedRenderer() as SlotSkillGrid);
            }
            else if(this.moduleSkillSlot.focused)
            {
               this.skillSlotSecondaryAction(this.moduleSkillSlot.socketsList.getSelectedRenderer() as SlotSkillGrid);
            }
         }
      }
      
      protected function updateGroupsBonus(param1:Array) : void
      {
         this.moduleSkillSlot.setBonusData(param1);
      }
      
      public function onPaperdollChanged() : void
      {
         this.moduleSkillSlot.mcSlotChangeHighlight.gotoAndPlay("animation");
      }
      
      public function notifySkillUpgraded(param1:int) : void
      {
         var _loc2_:SlotSkillGrid = null;
         var _loc3_:Object = null;
         if(!this.applyMode.isActive())
         {
            if(!this.moduleSkillSlot.socketsList.hasSkillWithType(param1))
            {
               _loc2_ = this.moduleSkillTabList.mcSkillSlotList.getSkillWithType(param1) as SlotSkillGrid;
               if(_loc2_)
               {
                  _loc3_ = _loc2_.data;
                  _loc3_.level += 1;
                  _loc2_.setData(_loc2_);
                  _loc2_.validateNow();
                  this.startApplyMode(_loc2_ as SlotBase);
               }
            }
         }
      }
      
      protected function stableUpdateSkillsGrid(param1:Array) : void
      {
      }
      
      protected function updateSkillsGrid(param1:Array) : void
      {
      }
      
      protected function updateSkillsSockets(param1:Array) : void
      {
         this.moduleSkillSlot.setData(param1);
      }
      
      protected function updateSkillSocket(param1:Object) : void
      {
         this.moduleSkillSlot.updateSocket(param1);
      }
      
      public function clearSkillSlot(param1:int) : void
      {
         this.moduleSkillSlot.clearSkillSlot(param1);
      }
      
      protected function updateSkillMutagens(param1:Array) : void
      {
         this.moduleSkillSlot.setMutagensData(param1);
      }
      
      protected function setSkillPoints(param1:int) : void
      {
         this._pointsCount = param1;
         this.moduleSkillTabList.pointsCount = param1;
         this.moduleSkillSlot.pointsCount = param1;
         this.txfAvailablePoints.text = "[[panel_character_availablepoints]]";
         this.txfPointsValue.text = param1.toString();
         this.txfAvailablePoints.text = CommonUtils.toUpperCaseSafe(this.txfAvailablePoints.text);
      }
      
      protected function callNotifyNotEnoughtPoints() : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnNotEnoughtPoints"));
      }
      
      protected function callBuySkill(param1:int, param2:int) : void
      {
         if(this._pointsCount > 0)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnBuySkill",[param1,param2]));
         }
      }
      
      protected function callEquipSkill(param1:int, param2:int) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnEquipSkill",[param1,param2]));
         if(this.applyMode.visible)
         {
            this.endApplyMode();
         }
      }
      
      protected function callUnequipSkill(param1:int) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnUnequipSkill",[param1]));
      }
      
      protected function callUpgradeSkill(param1:int) : void
      {
         if(this._pointsCount > 0)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnUpgradeSkill",[param1]));
         }
      }
      
      protected function callOpenMutagenList(param1:int) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnRequestMutagenList",[param1]));
      }
      
      protected function callEquipMutagen(param1:uint, param2:int) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnEquipMutagen",[param1,param2]));
         if(this.applyMode.visible)
         {
            this.endApplyMode();
         }
      }
      
      protected function callUnequipMutagen(param1:int) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnUnequipMutagen",[param1]));
      }
      
      protected function initDebugData() : void
      {
         var _loc1_:Array = [];
         var _loc2_:* = {
            "dropDownLabel":"cat1",
            "skillType":"11",
            "skillSubPath":"ESP_Sword"
         };
         var _loc3_:* = {
            "dropDownLabel":"cat1",
            "skillType":"11",
            "skillSubPath":"ESP_Sword"
         };
         var _loc4_:* = {
            "dropDownLabel":"cat1",
            "skillType":"11",
            "skillSubPath":"ESP_Sword"
         };
         _loc1_.push(_loc2_);
         _loc1_.push(_loc3_);
         _loc1_.push(_loc4_);
         this.updateSkillsGrid(_loc1_);
      }
      
      protected function debugTraceData(param1:Array) : void
      {
         var _loc2_:int = 0;
         if(param1)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               if(param1[_loc2_].skillType != "S_Undefined")
               {
                  CommonUtils.traceObject(param1[_loc2_],"GFX [MUTAGENS] ");
               }
               _loc2_++;
            }
         }
      }
      
      internal function __setProp_moduleSkillTabList_Scene1_moduleSkillTabList_0() : *
      {
         try
         {
            this.moduleSkillTabList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.moduleSkillTabList.enabled = true;
         this.moduleSkillTabList.enableInitCallback = false;
         this.moduleSkillTabList.subDataProvider = "character.menu.tabs.data";
         this.moduleSkillTabList.tabDataEventName = "OnTabDataRequested";
         this.moduleSkillTabList.visible = true;
         try
         {
            this.moduleSkillTabList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcMasterMutation_Scene1_equippedMutation_0() : *
      {
         try
         {
            this.mcMasterMutation["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcMasterMutation.draggingEnabled = true;
         this.mcMasterMutation.enabled = true;
         this.mcMasterMutation.enableInitCallback = false;
         this.mcMasterMutation.gridSize = 1;
         this.mcMasterMutation.mutationId = 0;
         this.mcMasterMutation.navigationDown = -1;
         this.mcMasterMutation.navigationLeft = -1;
         this.mcMasterMutation.navigationRight = -1;
         this.mcMasterMutation.navigationUp = -1;
         this.mcMasterMutation.selectable = false;
         this.mcMasterMutation.slotNavigationId = -1;
         this.mcMasterMutation.visible = true;
         try
         {
            this.mcMasterMutation["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
