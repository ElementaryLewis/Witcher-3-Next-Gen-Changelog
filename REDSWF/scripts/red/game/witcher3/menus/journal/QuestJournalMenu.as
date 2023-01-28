package red.game.witcher3.menus.journal
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.core.CoreMenu;
   import red.core.events.GameEvent;
   import red.game.witcher3.events.GridEvent;
   import red.game.witcher3.menus.common.ItemDataStub;
   import red.game.witcher3.menus.common.TextAreaModuleCustomInput;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class QuestJournalMenu extends CoreMenu
   {
       
      
      public var mcQuestListModule:QuestListModule;
      
      public var mcObjectiveListModule:QuestSubListModule;
      
      public var mcTextAreaModule:TextAreaModuleCustomInput;
      
      public var mcCurrentlyTrackedQuest:MovieClip;
      
      public var mcCurrentlyTrackedObjective:MovieClip;
      
      public var mcAnchor_MODULE_Tooltip:MovieClip;
      
      public function QuestJournalMenu()
      {
         addFrameScript(0,this.frame1);
         super();
         this.mcQuestListModule.menuName = this.menuName;
         this.SetDataBindings();
         this.__setProp_mcQuestListModule_Scene1_mcQuestListModule_0();
      }
      
      protected function SetDataBindings() : void
      {
         this.mcTextAreaModule.dataBindingKey = "journal.quest.description";
      }
      
      override protected function get menuName() : String
      {
         return "JournalQuestMenu";
      }
      
      override protected function configUI() : void
      {
         var _loc1_:TextField = null;
         super.configUI();
         if(this.mcCurrentlyTrackedQuest)
         {
            _loc1_ = this.mcCurrentlyTrackedQuest.getChildByName("txtTitle") as TextField;
            if(_loc1_)
            {
               _loc1_.text = "[[panel_hub_journal_tracked]]";
            }
            this.mcCurrentlyTrackedQuest.visible = false;
         }
         if(this.mcCurrentlyTrackedObjective)
         {
            _loc1_ = this.mcCurrentlyTrackedObjective.getChildByName("txtTitle") as TextField;
            if(_loc1_)
            {
               _loc1_.text = "[[panel_journal_current_objective]]";
            }
            this.mcCurrentlyTrackedObjective.visible = false;
         }
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         addEventListener(GridEvent.ITEM_CHANGE,this.onGridItemChange,false,0,true);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         stage.invalidate();
         validateNow();
         focused = 1;
         _contextMgr.defaultAnchor = this.mcAnchor_MODULE_Tooltip;
         _contextMgr.addGridEventsTooltipHolder(stage);
         this.mcQuestListModule.addEventListener(ListEvent.INDEX_CHANGE,this.handleListItemChanged,false,0,true);
      }
      
      private function handleListItemChanged(param1:ListEvent) : void
      {
         if(param1.itemData)
         {
            this.mcTextAreaModule.SetTitle(param1.itemData.label);
            this.mcTextAreaModule.SetText(param1.itemData.description);
            this.mcTextAreaModule.setDifficulty(param1.itemData.reqdifficulty);
            this.mcTextAreaModule.setLocation(param1.itemData.secondLabel);
            this.mcTextAreaModule.setHeaderColor(param1.itemData.isStory);
            this.mcTextAreaModule.setCrest(param1.itemData.questArea);
            this.mcTextAreaModule.ShowSkullIcon(param1.itemData.isdeadlydifficulty);
         }
      }
      
      public function setTitle(param1:String) : void
      {
         if(!this.mcTextAreaModule)
         {
         }
      }
      
      public function setText(param1:String) : void
      {
         if(!this.mcTextAreaModule)
         {
         }
      }
      
      public function setExpansionTexture(param1:int, param2:String) : *
      {
         this.mcObjectiveListModule.LoadExpansionTexture(param1,param2);
      }
      
      public function updateExpansionIcon(param1:int) : *
      {
         this.mcObjectiveListModule.updateExpansionIcon(param1);
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:UIComponent = null;
         var _loc3_:InputDetails = null;
         var _loc4_:Boolean = false;
         if(param1.handled)
         {
            return;
         }
         for each(_loc2_ in actualModules)
         {
            if(param1.handled)
            {
               param1.stopImmediatePropagation();
               return;
            }
            _loc2_.handleInput(param1);
         }
         _loc3_ = param1.details;
         if(_loc4_ = _loc3_.value == InputValue.KEY_DOWN || _loc3_.value == InputValue.KEY_HOLD)
         {
            switch(_loc3_.navEquivalent)
            {
               case NavigationCode.GAMEPAD_B:
                  hideAnimation();
            }
         }
      }
      
      public function setCurrentlyTrackedQuest(param1:String) : void
      {
         var _loc2_:TextField = null;
         if(this.mcCurrentlyTrackedQuest)
         {
            _loc2_ = this.mcCurrentlyTrackedQuest.getChildByName("txtCurrentObjective") as TextField;
            if(_loc2_)
            {
               this.mcCurrentlyTrackedQuest.visible = true;
               _loc2_.text = param1;
            }
         }
         this.mcQuestListModule.updateItemInputFeedback();
      }
      
      public function setCurrentlyTrackedObjective(param1:String) : void
      {
         var _loc2_:TextField = null;
         if(this.mcCurrentlyTrackedObjective)
         {
            _loc2_ = this.mcCurrentlyTrackedObjective.getChildByName("txtCurrentObjective") as TextField;
            if(_loc2_)
            {
               this.mcCurrentlyTrackedObjective.visible = true;
               _loc2_.text = param1;
            }
         }
      }
      
      public function CloseMenu() : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnCloseMenu"));
      }
      
      protected function onGridItemChange(param1:GridEvent) : void
      {
         var _loc3_:GridEvent = null;
         var _loc2_:ItemDataStub = param1.itemData as ItemDataStub;
         if(_loc2_)
         {
            if(_loc2_.id)
            {
               _loc3_ = new GridEvent(GridEvent.DISPLAY_TOOLTIP,true,false,0,-1,-1,null,_loc2_);
            }
            else
            {
               _loc3_ = new GridEvent(GridEvent.HIDE_TOOLTIP,true,false,0,-1,-1,null,_loc2_);
            }
         }
         else
         {
            _loc3_ = new GridEvent(GridEvent.HIDE_TOOLTIP,true,false,0,-1,-1,null,_loc2_);
         }
         dispatchEvent(_loc3_);
      }
      
      override public function ShowSecondaryModules(param1:Boolean) : *
      {
         super.ShowSecondaryModules(param1);
         this.mcObjectiveListModule.visible = param1;
         this.mcObjectiveListModule.enabled = param1;
         this.mcTextAreaModule.visible = param1;
         this.mcTextAreaModule.enabled = param1;
      }
      
      override protected function onLastMoveStatusChanged() : *
      {
         super.onLastMoveStatusChanged();
         if(_lastMoveWasMouse)
         {
            currentModuleIdx = 0;
         }
         this.mcObjectiveListModule.updateLastMoveWasMouseNavigation(_lastMoveWasMouse);
      }
      
      internal function __setProp_mcQuestListModule_Scene1_mcQuestListModule_0() : *
      {
         try
         {
            this.mcQuestListModule["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcQuestListModule.DataBindingKey = "journal.quest.list";
         this.mcQuestListModule.DropDownItemRendererClass = "QuestDropDownListItem";
         this.mcQuestListModule.DropDownListClass = "DropDownList";
         this.mcQuestListModule.enabled = true;
         this.mcQuestListModule.enableInitCallback = false;
         this.mcQuestListModule.ItemListClass = "W3ScrollingListNoBG";
         this.mcQuestListModule.ItemRendererClass = "QuestListItem";
         this.mcQuestListModule.visible = true;
         try
         {
            this.mcQuestListModule["componentInspectorSetting"] = false;
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
