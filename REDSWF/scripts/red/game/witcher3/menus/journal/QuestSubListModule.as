package red.game.witcher3.menus.journal
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.managers.InputFeedbackManager;
   import red.game.witcher3.menus.common.JournalRewardModule;
   import red.game.witcher3.slots.SlotBase;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.controls.ScrollBar;
   import scaleform.clik.controls.UILoader;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class QuestSubListModule extends JournalRewardModule
   {
       
      
      public var mcList:W3ScrollingList;
      
      public var mcListItem1:ObjectiveItemRenderer;
      
      public var mcListItem2:ObjectiveItemRenderer;
      
      public var mcListItem3:ObjectiveItemRenderer;
      
      public var mcListItem4:ObjectiveItemRenderer;
      
      public var mcListItem5:ObjectiveItemRenderer;
      
      public var mcListItem6:ObjectiveItemRenderer;
      
      public var mcListItem7:ObjectiveItemRenderer;
      
      public var mcListItem8:ObjectiveItemRenderer;
      
      public var mcListItem9:ObjectiveItemRenderer;
      
      public var mcListItem10:ObjectiveItemRenderer;
      
      public var mcScrollbar:ScrollBar;
      
      public var tfObjectives:TextField;
      
      public var mcObjectivesBackground:MovieClip;
      
      public var mcExpansionIcon1:UILoader;
      
      public var mcExpansionIcon2:UILoader;
      
      public var mcExpIconAnchor:MovieClip;
      
      private var _expansionIcon:int;
      
      protected var _trackInputFeedback:int = -1;
      
      protected var _lastMoveWasMouse:Boolean = false;
      
      public function QuestSubListModule()
      {
         super();
      }
      
      override public function hasSelectableItems() : Boolean
      {
         if(this.mcListItem1 == null || !this.mcListItem1.hasData())
         {
            return super.hasSelectableItems();
         }
         return true;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         selectRewardsOnFocus = false;
         this.focusable = true;
         this.mcList.focusable = false;
         enabled = true;
         this.Init();
      }
      
      protected function Init() : void
      {
         dispatchEvent(new GameEvent(GameEvent.REGISTER,dataBindingKey,[this.handleDataSet]));
         this.mcList.addEventListener(ListEvent.INDEX_CHANGE,this.OnListItemClick,false,0,true);
         dispatchEvent(new GameEvent(GameEvent.REGISTER,dataBindingKey + ".questname",[this.handleQuestNameSet]));
         stage.addEventListener(W3ScrollingList.REPOSITION,this.repositionRenderers,false,0,true);
         this.tfObjectives.htmlText = "";
      }
      
      override public function toString() : String
      {
         return "[W3 QuestSubListModule]";
      }
      
      public function LoadExpansionTexture(param1:int, param2:String) : *
      {
         if(param1 == 1)
         {
            this.mcExpansionIcon1 = new UILoader();
            this.mcExpansionIcon1.scaleX = 0.7;
            this.mcExpansionIcon1.scaleY = 0.7;
            this.mcExpansionIcon1.source = param2;
            this.mcExpansionIcon1.visible = false;
            addChild(this.mcExpansionIcon1);
            this.mcExpansionIcon1.x = this.mcExpIconAnchor.x;
            this.mcExpansionIcon1.y = this.mcExpIconAnchor.y;
         }
         else if(param1 == 2)
         {
            this.mcExpansionIcon2 = new UILoader();
            this.mcExpansionIcon2.scaleX = 0.7;
            this.mcExpansionIcon2.scaleY = 0.7;
            this.mcExpansionIcon2.source = param2;
            this.mcExpansionIcon2.visible = false;
            addChild(this.mcExpansionIcon2);
            this.mcExpansionIcon2.x = this.mcExpIconAnchor.x;
            this.mcExpansionIcon2.y = this.mcExpIconAnchor.y;
         }
      }
      
      public function updateExpansionIcon(param1:int) : *
      {
         this._expansionIcon = param1;
      }
      
      private function OnListItemClick(param1:ListEvent) : void
      {
         this.mcList.validateNow();
         this.repositionRenderers();
      }
      
      override protected function handleSlotClick(param1:ListEvent) : void
      {
      }
      
      protected function objectiveSorter(param1:*, param2:*) : int
      {
         if(param1.status != param2.status)
         {
            if(param1.status == 1)
            {
               return -1;
            }
            if(param2.status == 1)
            {
               return 1;
            }
         }
         if(param1.phaseIndex != param2.phaseIndex)
         {
            return param1.phaseIndex - param2.phaseIndex;
         }
         return param1.objectiveIndex - param2.objectiveIndex;
      }
      
      protected function handleDataSet(param1:Object, param2:int) : void
      {
         var _loc6_:ObjectiveItemRenderer = null;
         var _loc3_:Array = param1 as Array;
         _loc3_.sort(this.objectiveSorter);
         this.insertOrDelimiter(_loc3_);
         if(_loc3_.length == 0)
         {
            this.tfObjectives.visible = false;
         }
         else
         {
            this.tfObjectives.visible = true;
         }
         if(param2 > 0)
         {
            if(param1)
            {
               this.mcList.dataProvider = new DataProvider(_loc3_);
            }
         }
         else if(param1)
         {
            this.mcList.dataProvider = new DataProvider(_loc3_);
         }
         this.mcList.ShowRenderers(true);
         this.mcList.selectedIndex = 0;
         mcRewards.SetSelectedIndex(-1);
         this.mcList.validateNow();
         if(!focused && this.mcList.selectedIndex != -1)
         {
            if(_loc6_ = this.mcList.getSelectedRenderer() as ObjectiveItemRenderer)
            {
               _loc6_.selectionGlowEnabled = false;
            }
         }
         this.repositionRenderers();
         var _loc4_:int = Math.min(this.mcList.dataProvider.length,this.mcList.getRenderers().length) - 1;
         var _loc5_:ObjectiveItemRenderer;
         if(_loc5_ = this.mcList.getRendererAt(_loc4_) as ObjectiveItemRenderer)
         {
            this.mcObjectivesBackground.height = _loc5_.y + _loc5_.actualHeight + 30 - this.mcObjectivesBackground.y;
         }
         else
         {
            this.mcObjectivesBackground.height = 0;
         }
         handleDataChanged();
         switch(this._expansionIcon)
         {
            case 0:
               if(this.mcExpansionIcon1)
               {
                  this.mcExpansionIcon1.visible = false;
               }
               if(this.mcExpansionIcon2)
               {
                  this.mcExpansionIcon2.visible = false;
               }
               break;
            case 1:
               if(this.mcExpansionIcon1)
               {
                  this.mcExpansionIcon1.visible = true;
               }
               if(this.mcExpansionIcon2)
               {
                  this.mcExpansionIcon2.visible = false;
               }
               break;
            case 2:
               if(this.mcExpansionIcon1)
               {
                  this.mcExpansionIcon1.visible = false;
               }
               if(this.mcExpansionIcon2)
               {
                  this.mcExpansionIcon2.visible = true;
               }
         }
         if(this.mcExpansionIcon1)
         {
            this.mcExpansionIcon1.y = _loc5_.y + _loc5_.height;
         }
         if(this.mcExpansionIcon2)
         {
            this.mcExpansionIcon2.y = _loc5_.y + _loc5_.height - this.mcExpansionIcon2.height / 2;
         }
      }
      
      public function repositionRenderers() : void
      {
         var _loc1_:int = 0;
         var _loc2_:ObjectiveItemRenderer = null;
         var _loc3_:Number = this.mcList.y;
         _loc1_ = 0;
         while(_loc1_ < this.mcList.numRenderers)
         {
            _loc2_ = this.mcList.getRenderers()[_loc1_] as ObjectiveItemRenderer;
            _loc2_.validateNow();
            if(_loc2_)
            {
               _loc2_.y = _loc3_;
               _loc3_ += _loc2_.textField.textHeight + 15;
            }
            _loc1_++;
         }
         this.mcScrollbar.height = _loc3_ - this.mcScrollbar.y - 5;
      }
      
      protected function handleQuestNameSet(param1:String) : void
      {
      }
      
      private function updateInputFeedback() : void
      {
         var _loc1_:ObjectiveItemRenderer = null;
         _loc1_ = this.mcList.getSelectedRenderer() as ObjectiveItemRenderer;
         var _loc2_:Boolean = _focused > 0 && _loc1_ && _loc1_.data && !_loc1_.data.tracked && _loc1_.data.status == 1;
         if(_loc2_ && this._trackInputFeedback < 0)
         {
            this._trackInputFeedback = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_A,KeyCode.ENTER,"panel_button_journal_track");
            InputFeedbackManager.updateButtons(this);
         }
         else if(!_loc2_ && this._trackInputFeedback >= 0)
         {
            InputFeedbackManager.removeButton(this,this._trackInputFeedback);
            InputFeedbackManager.updateButtons(this);
            this._trackInputFeedback = -1;
         }
      }
      
      override public function set focused(param1:Number) : void
      {
         var _loc2_:SlotBase = null;
         this.mcList.focused = 0;
         mcRewards.focused = 0;
         if(param1 == _focused || !_focusable)
         {
            return;
         }
         super.focused = param1;
         this.updateInputFeedback();
         if(param1)
         {
            if(this.mcList.selectedIndex == -1 && mcRewards.mcRewardGrid.selectedIndex == -1)
            {
               if(this.mcList.dataProvider.length > 0)
               {
                  this.mcList.selectedIndex = 0;
                  mcRewards.SetSelectedIndex(-1);
               }
               else if(mcRewards.mcRewardGrid.data.length > 0)
               {
                  mcRewards.SetSelectedIndex(0);
                  mcRewards.FindSelectedIndex();
                  this.mcList.selectedIndex = -1;
               }
            }
         }
         this.setActiveSelectionEnabled(param1 != 0 && !this._lastMoveWasMouse);
      }
      
      override protected function handleControllerChanged(param1:Event) : void
      {
         super.handleControllerChanged(param1);
      }
      
      public function updateLastMoveWasMouseNavigation(param1:Boolean) : void
      {
         this._lastMoveWasMouse = param1;
         this.setActiveSelectionEnabled(focused != 0 && !this._lastMoveWasMouse);
      }
      
      public function setActiveSelectionEnabled(param1:Boolean) : *
      {
         var _loc2_:ObjectiveItemRenderer = null;
         mcRewards.activeSelectionVisible = param1;
         var _loc3_:int = 0;
         while(_loc3_ < this.mcList.getRenderers().length)
         {
            _loc2_ = this.mcList.getRendererAt(_loc3_) as ObjectiveItemRenderer;
            if(_loc2_)
            {
               _loc2_.selectionGlowEnabled = param1;
            }
            _loc3_++;
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         if(param1.handled || !_focused)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         var _loc3_:Boolean = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
         if(_loc3_)
         {
            switch(_loc2_.navEquivalent)
            {
               case NavigationCode.UP:
                  if(mcRewards.GetSelectedIndex() > -1)
                  {
                     mcRewards.SetSelectedIndex(-1);
                     param1.handled = true;
                     this.mcList.selectedIndex = this.mcList.dataProvider.length - 1;
                  }
                  else if(this.mcList.selectedIndex == 0 && _loc2_.value != InputValue.KEY_HOLD)
                  {
                     if(mcRewards.HasItems())
                     {
                        mcRewards.SetSelectedIndex(0);
                        mcRewards.FindSelectedIndex();
                        param1.handled = true;
                        this.mcList.selectedIndex = -1;
                     }
                  }
                  break;
               case NavigationCode.DOWN:
                  if(mcRewards.GetSelectedIndex() > -1 && _loc2_.value != InputValue.KEY_HOLD)
                  {
                     mcRewards.SetSelectedIndex(-1);
                     param1.handled = true;
                     this.mcList.selectedIndex = 0;
                  }
                  else if(this.mcList.selectedIndex == this.mcList.dataProvider.length - 1)
                  {
                     if(mcRewards.HasItems())
                     {
                        this.mcList.selectedIndex = -1;
                        mcRewards.SetSelectedIndex(0);
                        mcRewards.FindSelectedIndex();
                        param1.handled = true;
                     }
                  }
            }
            if(!param1.handled)
            {
               if(mcRewards.GetSelectedIndex() > -1)
               {
                  mcRewards.handleInput(param1);
               }
               else if(this.mcList.selectedIndex > -1)
               {
                  this.mcList.handleInput(param1);
               }
            }
            this.updateInputFeedback();
         }
      }
      
      private function insertOrDelimiter(param1:Array) : *
      {
         var _loc2_:int = 0;
         var _loc4_:Object = null;
         var _loc3_:Boolean = false;
         if(param1 == null)
         {
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(_loc3_)
            {
               if(this.isActiveAndMutuallyExclusive(param1[_loc2_]))
               {
                  (_loc4_ = new Object())["tag"] = 0;
                  _loc4_["isNew"] = false;
                  _loc4_["tracked"] = false;
                  _loc4_["isLegend"] = false;
                  _loc4_["status"] = ObjectiveItemRenderer.DELIMITER_STATUS;
                  _loc4_["label"] = "[[hud_questracker_or]]";
                  _loc4_["phaseIndex"] = 0;
                  _loc4_["objectiveIndex"] = 0;
                  _loc4_["isMutuallyExclusive"] = false;
                  param1.splice(_loc2_,0,_loc4_);
               }
            }
            _loc3_ = this.isActiveAndMutuallyExclusive(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      private function isActiveAndMutuallyExclusive(param1:Object) : Boolean
      {
         return Boolean(param1.isMutuallyExclusive) && param1.status == 1;
      }
   }
}
