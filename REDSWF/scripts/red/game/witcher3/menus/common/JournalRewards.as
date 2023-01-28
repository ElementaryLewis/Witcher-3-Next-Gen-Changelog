package red.game.witcher3.menus.common
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.core.events.GameEvent;
   import red.game.witcher3.events.GridEvent;
   import red.game.witcher3.slots.SlotBase;
   import red.game.witcher3.slots.SlotsListGrid;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   
   public class JournalRewards extends UIComponent
   {
       
      
      public var tfRewards:TextField;
      
      public var tfExperience:TextField;
      
      public var tfExperienceValue:TextField;
      
      public var mcRewardGrid:SlotsListGrid;
      
      public var mcSeparatorMiddle:MovieClip;
      
      public var mcSeparatorBottom:MovieClip;
      
      public var mcRewardsBackground:MovieClip;
      
      public var titleString:String = "[[panel_journal_quest_rewards]]";
      
      public var dataBindingKeyReward:String = "journal.objectives.list.reward.items";
      
      public function JournalRewards()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         mouseEnabled = false;
         this.mcRewardGrid.visible = false;
         dispatchEvent(new GameEvent(GameEvent.REGISTER,this.dataBindingKeyReward,[this.handleRewardDataSet]));
         this.mcRewardGrid.addEventListener(GridEvent.ITEM_CHANGE,this.onGridItemChange,false,0,true);
         this.mcRewardGrid.initFindSelection = false;
         this.handleExperienceValueSet("0");
         this.Init();
      }
      
      protected function Init() : void
      {
         if(this.tfRewards)
         {
            this.tfRewards.text = this.titleString;
         }
         if(this.tfExperience)
         {
            this.tfExperience.htmlText = "[[panel_journal_quest_experience]]";
            this.tfExperience.htmlText = CommonUtils.toUpperCaseSafe(this.tfExperience.htmlText);
         }
         dispatchEvent(new GameEvent(GameEvent.REGISTER,this.dataBindingKeyReward + ".experience",[this.handleExperienceValueSet]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"journal.rewards.panel.visible",[this.handleShowRewards]));
      }
      
      override public function toString() : String
      {
         return "[W3 JournalRewards]";
      }
      
      public function get columns() : uint
      {
         return this.mcRewardGrid.columns;
      }
      
      public function set columns(value:uint) : void
      {
         this.mcRewardGrid.columns = value;
      }
      
      protected function handleExperienceValueSet(value:String) : void
      {
         if(this.tfExperienceValue)
         {
            if(value == "0")
            {
               this.tfExperienceValue.visible = false;
               this.tfExperience.visible = false;
               this.mcSeparatorBottom.visible = false;
            }
            else
            {
               this.tfExperienceValue.htmlText = value;
               this.tfExperienceValue.visible = true;
               this.tfExperience.visible = true;
               this.mcSeparatorBottom.visible = true;
            }
         }
         this.CalculateBackgroundHeight();
      }
      
      protected function CalculateBackgroundHeight() : void
      {
         var backgroundHeight:Number = 0;
         if(this.mcRewardGrid.visible)
         {
            backgroundHeight += 117;
         }
         if(this.tfExperienceValue.visible)
         {
            backgroundHeight += 63;
         }
         this.mcRewardsBackground.height = backgroundHeight;
         this.mcSeparatorBottom.y = this.mcRewardsBackground.y + this.mcRewardsBackground.height;
         this.tfExperienceValue.y = this.mcSeparatorBottom.y - 46;
         this.tfExperience.y = this.tfExperienceValue.y;
      }
      
      protected function handleShowRewards(value:Boolean) : void
      {
         var displayEvent:GridEvent = null;
         this.visible = value;
         if(!value)
         {
            displayEvent = new GridEvent(GridEvent.HIDE_TOOLTIP,true,false,0,-1,-1,null,null);
            dispatchEvent(displayEvent);
         }
      }
      
      protected function handleRewardDataSet(gameData:Object, index:int) : void
      {
         var slot:SlotBase = null;
         var dataArray:Array = gameData as Array;
         if(!dataArray || dataArray.length == 0)
         {
            this.mcRewardGrid.visible = false;
            this.mcRewardGrid.enabled = false;
            this.mcSeparatorMiddle.visible = false;
         }
         else
         {
            this.mcRewardGrid.visible = true;
            this.mcRewardGrid.enabled = true;
            this.mcSeparatorMiddle.visible = true;
            this.handleShowRewards(true);
            if(gameData)
            {
               this.mcRewardGrid.data = dataArray;
               this.mcRewardGrid.validateNow();
               this.mcRewardGrid.selectedIndex = 0;
            }
            this.updateActiveSelectionVisible();
         }
         for(var i:int = 0; i < this.mcRewardGrid.columns; i++)
         {
            slot = this.mcRewardGrid.getRendererAt(i) as SlotBase;
            slot.visible = slot.data != null;
            slot.draggingEnabled = false;
         }
         this.CalculateBackgroundHeight();
      }
      
      public function set activeSelectionVisible(value:Boolean) : void
      {
         this.mcRewardGrid.activeSelectionVisible = value;
         this.updateActiveSelectionVisible();
      }
      
      protected function updateActiveSelectionVisible() : void
      {
         this.mcRewardGrid.updateActiveSelectionVisible();
      }
      
      protected function onGridItemChange(event:GridEvent) : void
      {
         dispatchEvent(event);
      }
      
      override public function handleInput(event:InputEvent) : void
      {
         if(event.handled && !_focused)
         {
            return;
         }
         this.mcRewardGrid.handleInputNavSimple(event);
      }
      
      public function GetSelectedIndex() : int
      {
         return this.mcRewardGrid.selectedIndex;
      }
      
      public function SetSelectedIndex(value:int) : void
      {
         this.mcRewardGrid.selectedIndex = value;
      }
      
      public function FindSelectedIndex() : void
      {
         this.mcRewardGrid.findSelection();
      }
      
      override public function set focused(value:Number) : void
      {
         super.focused = value;
         this.mcRewardGrid.focused = value;
         var currentSlot:SlotBase = this.mcRewardGrid.getSelectedRenderer() as SlotBase;
         if(currentSlot)
         {
            currentSlot.activeSelectionEnabled = value != 0;
            if(!value)
            {
               currentSlot.hideTooltip();
            }
            else
            {
               currentSlot.showTooltip();
            }
         }
      }
      
      public function HasItems() : Boolean
      {
         return this.mcRewardGrid.visible && this.mcRewardGrid.NumNonEmptyRenderers() > 0;
      }
   }
}
