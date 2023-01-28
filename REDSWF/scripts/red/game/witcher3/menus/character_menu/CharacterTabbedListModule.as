package red.game.witcher3.menus.character_menu
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.interfaces.IDragTarget;
   import red.game.witcher3.interfaces.IDropTarget;
   import red.game.witcher3.managers.InputFeedbackManager;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.modules.CollapsableTabbedListModule;
   import red.game.witcher3.slots.SlotBase;
   import red.game.witcher3.slots.SlotDragAvatar;
   import red.game.witcher3.slots.SlotInventoryGrid;
   import red.game.witcher3.slots.SlotSkillGrid;
   import red.game.witcher3.slots.SlotSkillMutagen;
   import red.game.witcher3.slots.SlotSkillSocket;
   import red.game.witcher3.slots.SlotsListGrid;
   import red.game.witcher3.slots.SlotsTransferManager;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.controls.Button;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.ListEvent;
   
   public class CharacterTabbedListModule extends CollapsableTabbedListModule implements IDropTarget
   {
      
      public static const TabIndex_Sword:int = 0;
      
      public static const TabIndex_Signs:int = 1;
      
      public static const TabIndex_Alchemy:int = 2;
      
      public static const TabIndex_Perks:int = 3;
      
      public static const TabIndex_Mutagens:int = 4;
       
      
      public var mcStateDropTarget:MovieClip;
      
      public var mcGridMask:MovieClip;
      
      public var mcSkillSlotList:CharacterSkillSlotsList;
      
      public var mcMutagenSlotList:SlotsListGrid;
      
      public var txtSpentPoints:TextField;
      
      protected var mcNumSkillPoints:Array;
      
      protected var mcNumSkillsLearnt:Array;
      
      private var _disableMutagenEquipping:Boolean;
      
      private var _inputSymbolIDX:int = -1;
      
      private var _pointsCount:int = 0;
      
      public var iconLock1:MovieClip;
      
      public var iconLock2:MovieClip;
      
      public var iconLock3:MovieClip;
      
      private var _buySkillBtnRef:Button = null;
      
      private var _dropEnabled:Boolean = true;
      
      private var _dropSelection:Boolean;
      
      public function CharacterTabbedListModule()
      {
         super();
         this.mcNumSkillPoints = new Array();
         this.mcNumSkillPoints.push(0);
         this.mcNumSkillPoints.push(0);
         this.mcNumSkillPoints.push(0);
         this.mcNumSkillPoints.push(0);
         this.mcNumSkillsLearnt = new Array();
         this.mcNumSkillsLearnt.push(0);
         this.mcNumSkillsLearnt.push(0);
         this.mcNumSkillsLearnt.push(0);
         this.mcNumSkillsLearnt.push(0);
         this.mcMutagenSlotList.dropEnabled = false;
         this.mcStateDropTarget.visible = false;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.updateLockedIcons();
         setTabData(new DataProvider([{
            "icon":"Sword",
            "locKey":"[[panel_character_skill_sword]]"
         },{
            "icon":"Signs",
            "locKey":"[[panel_character_skill_signs]]"
         },{
            "icon":"Alchemy",
            "locKey":"[[panel_character_skill_alchemy]]"
         },{
            "icon":"Perks",
            "locKey":"[[panel_character_perks_name]]"
         },{
            "icon":"Mutagens",
            "locKey":"[[panel_inventory_paperdoll_slotname_mutagen]]"
         }]));
         addToListContainer(this.mcSkillSlotList);
         addToListContainer(this.mcMutagenSlotList);
         if(this.mcSkillSlotList)
         {
            this.mcSkillSlotList.focusable = false;
            _inputHandlers.push(this.mcSkillSlotList);
            this.mcSkillSlotList.addEventListener(ListEvent.INDEX_CHANGE,this.onSkillSelectionChanged,false,0,true);
         }
         if(this.mcMutagenSlotList)
         {
            this.mcMutagenSlotList.focusable = false;
            _inputHandlers.push(this.mcMutagenSlotList);
            this.mcMutagenSlotList.visible = false;
            this.mcMutagenSlotList.handleScrollBar = true;
            this.mcMutagenSlotList.ignoreGridPosition = true;
            this.mcMutagenSlotList.addEventListener(ListEvent.INDEX_CHANGE,this.onMutagenSelectionChanged,false,0,true);
         }
         SlotsTransferManager.getInstance().addDropTarget(this);
      }
      
      public function get pointsCount() : int
      {
         return this._pointsCount;
      }
      
      public function set pointsCount(param1:int) : void
      {
         this._pointsCount = param1;
      }
      
      public function set BuySkillBtnRef(param1:Button) : void
      {
         this._buySkillBtnRef = param1;
      }
      
      override protected function onTabListItemSelected(param1:ListEvent) : void
      {
         super.onTabListItemSelected(param1);
         this.updatePointsSpentTextField();
         this.updateLockedIcons();
      }
      
      override protected function state_colapsed_begin() : void
      {
         super.state_colapsed_begin();
         this.updatePointsSpentTextField();
      }
      
      override protected function state_Open_begin() : void
      {
         super.state_Open_begin();
         this.updatePointsSpentTextField();
      }
      
      protected function updatePointsSpentTextField() : void
      {
         var _loc1_:int = mcTabList.selectedIndex;
         if(_loc1_ != TabIndex_Mutagens)
         {
            if(this.txtSpentPoints)
            {
               this.updateLockedIcons();
               this.txtSpentPoints.visible = true;
               this.txtSpentPoints.text = "[[panel_character_points_spent]]";
               this.txtSpentPoints.appendText(": " + this.mcNumSkillPoints[_loc1_]);
               this.txtSpentPoints.text = CommonUtils.toUpperCaseSafe(this.txtSpentPoints.text);
            }
         }
         else if(this.txtSpentPoints)
         {
            this.txtSpentPoints.visible = false;
         }
      }
      
      public function updateLockedIcons() : *
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc1_:* = this.iconLock1.getChildByName("txtValue") as TextField;
         var _loc2_:* = this.iconLock2.getChildByName("txtValue") as TextField;
         var _loc3_:* = this.iconLock3.getChildByName("txtValue") as TextField;
         var _loc7_:int = mcTabList.selectedIndex;
         switch(_loc7_)
         {
            case TabIndex_Sword:
               _loc4_ = 8;
               _loc5_ = 20;
               _loc6_ = 30;
               break;
            case TabIndex_Signs:
               _loc4_ = 6;
               _loc5_ = 18;
               _loc6_ = 28;
               break;
            case TabIndex_Alchemy:
               _loc4_ = 8;
               _loc5_ = 20;
               _loc6_ = 28;
         }
         _loc1_.text = _loc4_.toString();
         _loc2_.text = _loc5_.toString();
         _loc3_.text = _loc6_.toString();
         if(this.txtSpentPoints && _loc7_ != TabIndex_Mutagens && _loc7_ != TabIndex_Perks)
         {
            this.iconLock1.visible = true;
            this.iconLock2.visible = true;
            this.iconLock3.visible = true;
            if(this.mcNumSkillPoints[_loc7_] >= _loc4_)
            {
               this.iconLock1.visible = false;
            }
            if(this.mcNumSkillPoints[_loc7_] >= _loc5_)
            {
               this.iconLock2.visible = false;
            }
            if(this.mcNumSkillPoints[_loc7_] >= _loc6_)
            {
               this.iconLock3.visible = false;
            }
         }
         else
         {
            this.iconLock1.visible = false;
            this.iconLock2.visible = false;
            this.iconLock3.visible = false;
         }
      }
      
      protected function onSkillSelectionChanged(param1:ListEvent) : void
      {
         this.mcGridMask.visible = false;
         mcListContainer.mask = null;
         updateInputFeedback();
      }
      
      protected function onMutagenSelectionChanged(param1:ListEvent) : void
      {
         this.mcGridMask.visible = true;
         mcListContainer.mask = this.mcGridMask;
         updateInputFeedback();
      }
      
      override protected function updateInputFeedbackButtons() : void
      {
         var _loc1_:SlotInventoryGrid = null;
         var _loc2_:SlotSkillGrid = null;
         var _loc3_:String = null;
         super.updateInputFeedbackButtons();
         if(this._buySkillBtnRef)
         {
            this._buySkillBtnRef.visible = false;
         }
         if(this._inputSymbolIDX != -1)
         {
            InputFeedbackManager.removeButton(this,this._inputSymbolIDX);
            this._inputSymbolIDX = -1;
         }
         if(isOpen)
         {
            if(_inputSymbolIDA != -1)
            {
               InputFeedbackManager.removeButton(this,_inputSymbolIDA);
               _inputSymbolIDA = -1;
            }
            if(_hideInputFeedback)
            {
               return;
            }
            if(mcTabList.selectedIndex == TabIndex_Mutagens)
            {
               _loc1_ = this.mcMutagenSlotList.getSelectedRenderer() as SlotInventoryGrid;
               if(_loc1_ && _loc1_.data && focused && !this.disableMutagenEquipping)
               {
                  _inputSymbolIDA = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_A,KeyCode.SPACE,"panel_character_skill_equip");
               }
            }
            else
            {
               _loc2_ = this.mcSkillSlotList.getSelectedRenderer() as SlotSkillGrid;
               if(_loc2_ && _loc2_.data && Boolean(focused))
               {
                  if((parent as MenuCharacter).moduleSkillSlot.hasSkillSlotUnlocked() && _loc2_.data.level > 0 && !_loc2_.data.isCoreSkill)
                  {
                     _inputSymbolIDA = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_A,KeyCode.SPACE,"panel_character_skill_equip");
                  }
                  if(_loc2_.data.level < _loc2_.data.maxLevel && _loc2_.data.updateAvailable && this._pointsCount > 0)
                  {
                     _loc3_ = _loc2_.data.level == 0 ? "panel_character_popup_title_buy_skill" : "panel_character_popup_title_upgrade_skill";
                     this._inputSymbolIDX = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_X,KeyCode.E,_loc3_);
                     if(this._buySkillBtnRef)
                     {
                        this._buySkillBtnRef.label = _loc3_;
                        this._buySkillBtnRef.enabled = true;
                        if(!InputManager.getInstance().isGamepad())
                        {
                           this._buySkillBtnRef.visible = true;
                        }
                     }
                  }
               }
            }
         }
      }
      
      override protected function handleControllerChange(param1:ControllerChangeEvent) : void
      {
         var _loc2_:SlotSkillGrid = null;
         super.handleControllerChange(param1);
         if(this._buySkillBtnRef)
         {
            if(param1.isGamepad)
            {
               this._buySkillBtnRef.visible = false;
            }
            else if(this.mcSkillSlotList.visible)
            {
               _loc2_ = this.mcSkillSlotList.getSelectedRenderer() as SlotSkillGrid;
               if(_loc2_ && _loc2_.data && _loc2_.data.level < _loc2_.data.maxLevel)
               {
                  this._buySkillBtnRef.visible = true;
               }
            }
         }
      }
      
      override protected function updateSubData(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:SlotInventoryGrid = null;
         super.updateSubData(param1);
         if(param1 == TabIndex_Mutagens)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mcMutagenSlotList.getRenderersCount())
            {
               _loc3_ = this.mcMutagenSlotList.getRendererAt(_loc2_) as SlotInventoryGrid;
               if(_loc3_)
               {
                  _loc3_.useContextMgr = false;
               }
               _loc2_++;
            }
         }
         this.updatePointsSpentTextField();
      }
      
      override protected function setSubData(param1:int, param2:Array) : void
      {
         var _loc6_:Object = null;
         var _loc7_:* = undefined;
         super.setSubData(param1,param2);
         var _loc3_:AdvancedTabListItem = mcTabList.getRendererAt(param1) as AdvancedTabListItem;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 != TabIndex_Mutagens)
         {
            _loc7_ = 0;
            while(_loc7_ < param2.length)
            {
               if(!(_loc6_ = param2[_loc7_]).isCoreSkill && _loc6_.level > 0)
               {
                  _loc5_++;
                  _loc4_ += _loc6_.level;
               }
               _loc7_++;
            }
            this.mcNumSkillPoints[param1] = _loc4_;
            this.mcNumSkillsLearnt[param1] = _loc5_;
         }
         if(_loc3_)
         {
            switch(param1)
            {
               case TabIndex_Sword:
                  _loc3_.setText(this.mcNumSkillsLearnt[TabIndex_Sword].toString());
                  break;
               case TabIndex_Signs:
                  _loc3_.setText(this.mcNumSkillsLearnt[TabIndex_Signs].toString());
                  break;
               case TabIndex_Alchemy:
                  _loc3_.setText(this.mcNumSkillsLearnt[TabIndex_Alchemy].toString());
                  break;
               case TabIndex_Perks:
                  _loc3_.setText(this.mcNumSkillsLearnt[TabIndex_Perks].toString());
                  break;
               case TabIndex_Mutagens:
                  _loc3_.setText(this.countMutagens(param2).toString());
            }
         }
      }
      
      private function countMutagens(param1:Array) : int
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         _loc4_ = 0;
         _loc3_ = param1.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ += param1[_loc2_].quantity;
            _loc2_++;
         }
         return _loc4_;
      }
      
      override protected function setAllowSelectionHighlight(param1:Boolean) : void
      {
         var _loc2_:SlotBase = null;
         var _loc3_:int = 0;
         super.setAllowSelectionHighlight(param1);
         if(this.mcSkillSlotList)
         {
            this.mcSkillSlotList.validateNow();
            _loc3_ = 0;
            while(_loc3_ < this.mcSkillSlotList.getRenderersLength())
            {
               _loc2_ = this.mcSkillSlotList.getRendererAt(_loc3_) as SlotBase;
               if(_loc2_)
               {
                  _loc2_.activeSelectionEnabled = param1;
               }
               _loc3_++;
            }
         }
         if(this.mcMutagenSlotList)
         {
            this.mcMutagenSlotList.validateNow();
            _loc3_ = 0;
            while(_loc3_ < this.mcMutagenSlotList.getRenderersLength())
            {
               _loc2_ = this.mcMutagenSlotList.getRendererAt(_loc3_) as SlotBase;
               if(_loc2_)
               {
                  _loc2_.activeSelectionEnabled = param1;
               }
               _loc3_++;
            }
         }
      }
      
      override public function getDataShowerForTab(param1:int) : UIComponent
      {
         if(param1 != TabIndex_Mutagens)
         {
            return this.mcSkillSlotList;
         }
         return this.mcMutagenSlotList;
      }
      
      public function get dropEnabled() : Boolean
      {
         return this._dropEnabled;
      }
      
      public function set dropEnabled(param1:Boolean) : void
      {
         this._dropEnabled = param1;
      }
      
      public function get dropSelection() : Boolean
      {
         return this._dropSelection;
      }
      
      public function set dropSelection(param1:Boolean) : void
      {
         this._dropSelection = param1;
         this.mcStateDropTarget.visible = this._dropSelection && !InputManager.getInstance().isGamepad() && SlotsTransferManager.getInstance().isDragging();
      }
      
      public function get disableMutagenEquipping() : Boolean
      {
         return this._disableMutagenEquipping;
      }
      
      public function set disableMutagenEquipping(param1:Boolean) : void
      {
         this._disableMutagenEquipping = param1;
         this.updateInputFeedbackButtons();
      }
      
      public function canDrop(param1:IDragTarget) : Boolean
      {
         var _loc2_:DisplayObject = param1 as DisplayObject;
         while(Boolean(_loc2_) && Boolean(_loc2_.parent))
         {
            if(this == _loc2_)
            {
               return false;
            }
            _loc2_ = _loc2_.parent;
         }
         return true;
      }
      
      public function applyDrop(param1:IDragTarget) : void
      {
         var _loc2_:SlotSkillMutagen = param1 as SlotSkillMutagen;
         var _loc3_:SlotSkillSocket = param1 as SlotSkillSocket;
         if(_loc2_)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnUnequipMutagen",[_loc2_.slotType]));
         }
         else if(_loc3_)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnUnequipSkill",[uint(_loc3_.getDragData().slotId)]));
         }
      }
      
      public function processOver(param1:SlotDragAvatar) : int
      {
         var _loc2_:SlotSkillMutagen = null;
         var _loc3_:SlotSkillSocket = null;
         if(param1)
         {
            _loc2_ = param1.getSourceContainer() as SlotSkillMutagen;
            _loc3_ = param1.getSourceContainer() as SlotSkillSocket;
            if(_loc2_)
            {
               if(currentlySelectedTabIndex != CharacterTabbedListModule.TabIndex_Mutagens)
               {
                  onSetTabCalled(CharacterTabbedListModule.TabIndex_Mutagens);
               }
            }
            else if(_loc3_)
            {
               if(_loc3_.data)
               {
                  onSetTabCalled(_loc3_.data.tabId);
               }
               else if(currentlySelectedTabIndex == CharacterTabbedListModule.TabIndex_Mutagens)
               {
                  onSetTabCalled(CharacterTabbedListModule.TabIndex_Sword);
               }
            }
         }
         return SlotDragAvatar.ACTION_GRID_DROP;
      }
   }
}
