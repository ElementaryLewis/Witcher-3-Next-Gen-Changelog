package red.game.witcher3.menus.gwint
{
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Sine;
   import flash.events.Event;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.GwintInputFeedback;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.managers.InputFeedbackManager;
   import red.game.witcher3.modules.CollapsableTabbedListModule;
   import red.game.witcher3.slots.SlotBase;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.ListEvent;
   
   public class GwintDeckCTabModule extends CollapsableTabbedListModule
   {
      
      public static const TabIndex_All:int = 0;
      
      public static const TabIndex_Melee:int = 1;
      
      public static const TabIndex_Ranged:int = 2;
      
      public static const TabIndex_Siege:int = 3;
      
      public static const TabIndex_Heroes:int = 4;
      
      public static const TabIndex_Weather:int = 5;
      
      public static const TabIndex_Special:int = 6;
       
      
      public var mcCardSlotList:GwintCardGridList;
      
      protected var targetDeck:GwintDeck;
      
      protected var forceRefreshSelectionCardID:int = -1;
      
      public var tutorialCardSorting:Boolean = false;
      
      private var cardsSentOnce:Boolean = false;
      
      protected var _lastMousedOverCardIndex:int = -1;
      
      public function GwintDeckCTabModule()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         bToCloseEnabled = false;
         setTabData(new DataProvider([{
            "icon":"All",
            "locKey":"[[gwint_card_category_title_all]]"
         },{
            "icon":"Melee",
            "locKey":"[[gwint_card_category_title_melee]]"
         },{
            "icon":"Ranged",
            "locKey":"[[gwint_card_category_title_ranged]]"
         },{
            "icon":"Siege",
            "locKey":"[[gwint_card_category_title_siege]]"
         },{
            "icon":"Heroes",
            "locKey":"[[gwint_card_category_title_Heroes]]"
         },{
            "icon":"Weather",
            "locKey":"[[gwint_card_category_title_weather]]"
         },{
            "icon":"Special",
            "locKey":"[[gwint_card_category_title_special]]"
         }]));
         if(mcTabList.selectedIndex == -1)
         {
            mcTabList.selectedIndex = 0;
         }
         if(this.mcCardSlotList)
         {
            this.mcCardSlotList.focusable = false;
            _inputHandlers.push(this.mcCardSlotList);
            this.mcCardSlotList.addEventListener(CardSlot.CardMouseOver,this.OnCardMouseOver,false,0,true);
            this.mcCardSlotList.addEventListener(CardSlot.CardMouseOut,this.OnCardMouseOut,false,0,true);
         }
      }
      
      override public function open() : void
      {
         if(this.canOpen() || _lastMoveWasMouse)
         {
            stateMachine.ChangeState(CollapsableTabbedListModule.State_Open);
         }
      }
      
      public function canOpen() : Boolean
      {
         return stateMachine.currentState != CollapsableTabbedListModule.State_Open && (this.mcCardSlotList.data != null && this.mcCardSlotList.data.length > 0);
      }
      
      override protected function onTabListItemSelected(param1:ListEvent) : void
      {
         super.onTabListItemSelected(param1);
         if(focused)
         {
            InputFeedbackManager.removeButtonById(GwintInputFeedback.openTab);
            if(this.canOpen())
            {
               InputFeedbackManager.appendButtonById(GwintInputFeedback.openTab,NavigationCode.GAMEPAD_A,-1,"inputfeedback_common_open_grid");
            }
         }
      }
      
      override public function hasSelectableItems() : Boolean
      {
         return true;
      }
      
      public function setTargetDeck(param1:GwintDeck) : void
      {
         if(this.targetDeck != param1)
         {
            if(this.targetDeck != null)
            {
               this.targetDeck.refreshCallback = null;
               this.targetDeck.onCardChangedCallback = null;
            }
            this.targetDeck = param1;
            if(this.targetDeck)
            {
               this.targetDeck.refreshCallback = this.onDeckRefreshTriggered;
               this.targetDeck.onCardChangedCallback = this.onCardChangedCallback;
               this.onDeckRefreshTriggered();
            }
         }
         else
         {
            this.onDeckRefreshTriggered();
         }
      }
      
      protected function onDeckRefreshTriggered() : void
      {
         this.updateSubData(mcTabList.selectedIndex);
      }
      
      override protected function state_colapsed_begin() : void
      {
         super.state_colapsed_begin();
         if(focused)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_global_highlight"]));
         }
      }
      
      protected function onCardChangedCallback(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:CardSlot = null;
         var _loc8_:AdvancedTabListItem = null;
         var _loc5_:CardSlot = null;
         _loc3_ = 0;
         while(_loc3_ < this.mcCardSlotList.getRenderersLength())
         {
            if((_loc4_ = this.mcCardSlotList.getRendererAt(_loc3_) as CardSlot).cardIndex == param1)
            {
               _loc5_ = _loc4_;
               break;
            }
            _loc3_++;
         }
         var _loc6_:Boolean = false;
         var _loc7_:Object = {
            "cardID":param1,
            "numCopies":param2
         };
         if(_loc5_ == null)
         {
            if(param2 > 0)
            {
               this.mcCardSlotList.addRenderer(_loc7_);
               _loc6_ = true;
            }
         }
         else if(param2 == 0)
         {
            this.mcCardSlotList.removeRenderer(_loc5_);
            if(this.mcCardSlotList.getRenderersLength() == 0)
            {
               close();
            }
         }
         else
         {
            _loc5_.setData(_loc7_);
            _loc6_ = true;
         }
         if(!this.IsCardInCurrentTab(param1) && mcTabList.selectedIndex != -1)
         {
            if(_loc8_ = mcTabList.getSelectedRenderer() as AdvancedTabListItem)
            {
               _loc8_.selected = false;
               _loc8_.setIsOpen(false);
            }
            this.forceRefreshSelectionCardID = param1;
            mcTabList.selectedIndex = 0;
         }
         else if(!_lastMoveWasMouse)
         {
            this.mcCardSlotList.validateNow();
            _loc3_ = 0;
            while(_loc3_ < this.mcCardSlotList.getRenderersLength())
            {
               if((_loc4_ = this.mcCardSlotList.getRendererAt(_loc3_) as CardSlot).cardIndex == param1)
               {
                  this.mcCardSlotList.selectedIndex = _loc3_;
                  break;
               }
               _loc3_++;
            }
         }
      }
      
      protected function IsCardInCurrentTab(param1:int) : Boolean
      {
         var _loc3_:CardTemplate = null;
         var _loc2_:CardManager = CardManager.getInstance();
         _loc3_ = _loc2_.getCardTemplate(param1);
         if(_loc3_)
         {
            switch(mcTabList.selectedIndex)
            {
               case TabIndex_All:
               default:
                  return true;
               case TabIndex_Melee:
                  return this.isMelee(_loc3_);
               case TabIndex_Ranged:
                  return this.isRanged(_loc3_);
               case TabIndex_Siege:
                  return this.isSiege(_loc3_);
               case TabIndex_Heroes:
                  return this.isHero(_loc3_);
               case TabIndex_Weather:
                  return this.isWeather(_loc3_);
               case TabIndex_Special:
                  return this.isSpecial(_loc3_);
            }
         }
         else
         {
            return false;
         }
      }
      
      override protected function updateSubData(param1:int) : void
      {
         var _loc3_:UIComponent = null;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:CardSlot = null;
         var _loc2_:Array = new Array();
         this.cardsSentOnce = true;
         switch(param1)
         {
            case TabIndex_All:
            default:
               _loc2_ = this.fillDataWithCallback(null);
               break;
            case TabIndex_Melee:
               _loc2_ = this.fillDataWithCallback(this.isMelee);
               break;
            case TabIndex_Ranged:
               _loc2_ = this.fillDataWithCallback(this.isRanged);
               break;
            case TabIndex_Siege:
               _loc2_ = this.fillDataWithCallback(this.isSiege);
               break;
            case TabIndex_Heroes:
               _loc2_ = this.fillDataWithCallback(this.isHero);
               break;
            case TabIndex_Weather:
               _loc2_ = this.fillDataWithCallback(this.isWeather);
               break;
            case TabIndex_Special:
               _loc2_ = this.fillDataWithCallback(this.isSpecial);
         }
         if(this.tutorialCardSorting)
         {
            _loc2_.sort(this.deckbuilderCardSorter_tutorial);
         }
         else
         {
            _loc2_.sort(this.deckbuilderCardSorter);
         }
         this.mcCardSlotList.data = _loc2_;
         this.mcCardSlotList.validateNow();
         this.mcCardSlotList.findSelection();
         this.mcCardSlotList.validateNow();
         if(hideTabBackgroundWhenData && Boolean(mcTabBackground))
         {
            mcTabBackground.visible = this.mcCardSlotList.data.length == 0;
         }
         _loc3_ = this.mcCardSlotList as UIComponent;
         if(_loc3_)
         {
            _loc3_.visible = true;
            _loc3_.validateNow();
            if(subDataTweener)
            {
               subDataTweener.paused = true;
               GTweener.removeTweens(_loc3_);
            }
            _loc3_.alpha = 0;
            _loc5_ = 0.5;
            subDataTweener = GTweener.to(_loc3_,_loc5_,{"alpha":1},{
               "onComplete":handleTweenComplete,
               "ease":Sine.easeOut
            });
         }
         var _loc4_:UIComponent;
         if(_loc4_ = getDataShowerForCurrentTab())
         {
            if(stateMachine.currentState != State_Open)
            {
               if(!focused)
               {
                  _loc4_.visible = false;
               }
            }
         }
         this.setAllowSelectionHighlight(isOpen && Boolean(focused));
         if(this.forceRefreshSelectionCardID != -1 && !_lastMoveWasMouse)
         {
            this.mcCardSlotList.validateNow();
            _loc6_ = 0;
            while(_loc6_ < this.mcCardSlotList.getRenderersLength())
            {
               if((_loc7_ = this.mcCardSlotList.getRendererAt(_loc6_) as CardSlot).cardIndex == this.forceRefreshSelectionCardID)
               {
                  this.mcCardSlotList.selectedIndex = _loc6_;
                  break;
               }
               _loc6_++;
            }
            this.forceRefreshSelectionCardID = -1;
         }
         this.closeIfEmpty();
         updateInputFeedback();
      }
      
      override protected function closeIfEmpty() : void
      {
         if(isOpen)
         {
            if(this.mcCardSlotList == null || this.mcCardSlotList.data == null || this.mcCardSlotList.data.length == 0)
            {
               close();
            }
         }
      }
      
      public function sortTutorialCards() : void
      {
         this.tutorialCardSorting = true;
         if(this.cardsSentOnce)
         {
            this.updateSubData(TabIndex_All);
         }
      }
      
      protected function isMelee(param1:CardTemplate) : Boolean
      {
         return param1.isType(CardTemplate.CardType_Melee) && param1.isType(CardTemplate.CardType_Creature);
      }
      
      protected function isRanged(param1:CardTemplate) : Boolean
      {
         return param1.isType(CardTemplate.CardType_Ranged) && param1.isType(CardTemplate.CardType_Creature);
      }
      
      protected function isSiege(param1:CardTemplate) : Boolean
      {
         return param1.isType(CardTemplate.CardType_Siege) && param1.isType(CardTemplate.CardType_Creature);
      }
      
      protected function isHero(param1:CardTemplate) : Boolean
      {
         return param1.isType(CardTemplate.CardType_Hero);
      }
      
      protected function isWeather(param1:CardTemplate) : Boolean
      {
         return param1.isType(CardTemplate.CardType_Weather);
      }
      
      protected function isSpecial(param1:CardTemplate) : Boolean
      {
         return !param1.isType(CardTemplate.CardType_Creature);
      }
      
      protected function OnCardMouseOver(param1:Event) : void
      {
         if(!_lastMoveWasMouse)
         {
            return;
         }
         var _loc2_:CardSlot = param1.target as CardSlot;
         if(_loc2_)
         {
            this._lastMousedOverCardIndex = this.mcCardSlotList.getRendererIndex(_loc2_);
            this.mcCardSlotList.selectedIndex = this._lastMousedOverCardIndex;
         }
      }
      
      protected function OnCardMouseOut(param1:Event) : void
      {
         if(!_lastMoveWasMouse)
         {
            return;
         }
         this.mcCardSlotList.selectedIndex = -1;
         this._lastMousedOverCardIndex = -1;
      }
      
      override protected function handleControllerChange(param1:ControllerChangeEvent) : void
      {
         super.handleControllerChange(param1);
         if(param1.isGamepad)
         {
            _lastMoveWasMouse = false;
         }
         if(!_lastMoveWasMouse)
         {
            if(this.mcCardSlotList.selectedIndex == -1)
            {
               this.mcCardSlotList.findSelection();
            }
         }
         else
         {
            this.mcCardSlotList.selectedIndex = this._lastMousedOverCardIndex;
         }
      }
      
      protected function fillDataWithCallback(param1:Function) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:CardTemplate = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:Array = new Array();
         var _loc6_:CardManager = CardManager.getInstance();
         if(this.targetDeck)
         {
            _loc7_ = 0;
            while(_loc7_ < this.targetDeck.cardIndices.length)
            {
               _loc4_ = int(this.targetDeck.cardIndices[_loc7_]);
               _loc3_ = null;
               _loc8_ = 0;
               while(_loc8_ < _loc2_.length)
               {
                  if(_loc2_[_loc8_].cardID == _loc4_)
                  {
                     _loc3_ = _loc2_[_loc8_];
                  }
                  _loc8_++;
               }
               if(_loc3_ != null)
               {
                  _loc3_.numCopies += 1;
               }
               else
               {
                  _loc5_ = _loc6_.getCardTemplate(_loc4_);
                  if(param1 == null || param1(_loc5_))
                  {
                     _loc3_ = {
                        "cardID":_loc4_,
                        "numCopies":1
                     };
                     _loc2_.push(_loc3_);
                  }
               }
               _loc7_++;
            }
         }
         return _loc2_;
      }
      
      protected function deckbuilderCardSorter(param1:Object, param2:Object) : Number
      {
         var _loc3_:CardTemplate = CardManager.getInstance().getCardTemplate(param1.cardID);
         var _loc4_:CardTemplate = CardManager.getInstance().getCardTemplate(param2.cardID);
         if(_loc3_.isType(CardTemplate.CardType_Creature) && !_loc4_.isType(CardTemplate.CardType_Creature))
         {
            return 1;
         }
         if(!_loc3_.isType(CardTemplate.CardType_Creature) && _loc4_.isType(CardTemplate.CardType_Creature))
         {
            return -1;
         }
         if(_loc3_.factionIdx != _loc4_.factionIdx)
         {
            if(_loc3_.factionIdx < _loc4_.factionIdx)
            {
               return -1;
            }
            if(_loc3_.factionIdx > _loc4_.factionIdx)
            {
               return 1;
            }
         }
         if(_loc3_.power != _loc4_.power)
         {
            return _loc4_.power - _loc3_.power;
         }
         return _loc3_.index - _loc4_.index;
      }
      
      protected function deckbuilderCardSorter_tutorial(param1:Object, param2:Object) : Number
      {
         var _loc3_:CardTemplate = CardManager.getInstance().getCardTemplate(param1.cardID);
         var _loc4_:CardTemplate = CardManager.getInstance().getCardTemplate(param2.cardID);
         if(_loc3_.isType(CardTemplate.CardType_Creature) && !_loc4_.isType(CardTemplate.CardType_Creature))
         {
            return -1;
         }
         if(!_loc3_.isType(CardTemplate.CardType_Creature) && _loc4_.isType(CardTemplate.CardType_Creature))
         {
            return 1;
         }
         if(_loc3_.factionIdx != _loc4_.factionIdx)
         {
            if(_loc3_.factionIdx < _loc4_.factionIdx)
            {
               return -1;
            }
            if(_loc3_.factionIdx > _loc4_.factionIdx)
            {
               return 1;
            }
         }
         if(_loc3_.power != _loc4_.power)
         {
            return _loc4_.power - _loc3_.power;
         }
         return _loc3_.index - _loc4_.index;
      }
      
      override protected function updateInputFeedbackButtons() : void
      {
         if(_inputSymbolIDB != -1)
         {
            InputFeedbackManager.removeButton(this,_inputSymbolIDB);
            _inputSymbolIDB = -1;
         }
         if(_inputSymbolIDA != -1)
         {
            InputFeedbackManager.removeButton(this,_inputSymbolIDA);
            _inputSymbolIDA = -1;
         }
         if(stateMachine.currentState == State_Colapsed)
         {
            if(_focused && mcTabList.selectedIndex != -1 && subDataDictionary[mcTabList.selectedIndex] != null && subDataDictionary[mcTabList.selectedIndex].length > 0)
            {
               _inputSymbolIDA = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_A,-1,"inputfeedback_common_open_grid");
            }
         }
      }
      
      override protected function setAllowSelectionHighlight(param1:Boolean) : void
      {
         var _loc2_:SlotBase = null;
         var _loc3_:int = 0;
         super.setAllowSelectionHighlight(param1);
         if(this.mcCardSlotList)
         {
            this.mcCardSlotList.validateNow();
            this.mcCardSlotList.activeSelectionVisible = param1 || _lastMoveWasMouse;
         }
      }
   }
}
