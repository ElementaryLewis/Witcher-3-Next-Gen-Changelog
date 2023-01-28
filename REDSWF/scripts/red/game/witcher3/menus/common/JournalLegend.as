package red.game.witcher3.menus.common
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.menus.journal.ObjectiveItemRenderer;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.InputEvent;
   
   public class JournalLegend extends UIComponent
   {
       
      
      public var tfLegend:TextField;
      
      public var mcSeparatorMiddle:MovieClip;
      
      public var mcSeparatorBottom:MovieClip;
      
      public var mcLegendBackground:MovieClip;
      
      public var mcFeedbackList:W3ScrollingList;
      
      public var mcFeedbackListItem1:ObjectiveItemRenderer;
      
      public var mcFeedbackListItem2:ObjectiveItemRenderer;
      
      public var mcFeedbackListItem3:ObjectiveItemRenderer;
      
      public var mcFeedbackListItem4:ObjectiveItemRenderer;
      
      public var mcFeedbackQuestList:W3ScrollingList;
      
      public var mcFeedbackQuestListItem1:IconItemRenderer;
      
      public var mcFeedbackQuestListItem2:IconItemRenderer;
      
      public var mcFeedbackQuestListItem3:IconItemRenderer;
      
      public var titleString:String = "[[panel_journal_quest_legend]]";
      
      public var dataBindingKeyFeedbackLegend:String = "journal.legend.list";
      
      public var dataBindingKeyQuestFeedbackLegend:String = "journal.legend.quests.list";
      
      public function JournalLegend()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         mouseEnabled = mouseChildren = false;
         dispatchEvent(new GameEvent(GameEvent.REGISTER,this.dataBindingKeyFeedbackLegend,[this.handleLegendFeedbackDataSet]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,this.dataBindingKeyQuestFeedbackLegend,[this.handleLegendFeedbackQuestDataSet]));
         this.Init();
      }
      
      protected function Init() : void
      {
         if(this.tfLegend)
         {
            this.tfLegend.htmlText = this.titleString;
            this.tfLegend.htmlText = CommonUtils.toUpperCaseSafe(this.tfLegend.htmlText);
         }
      }
      
      override public function toString() : String
      {
         return "[W3 JournalLegend]";
      }
      
      protected function handleLegendFeedbackDataSet(param1:Object, param2:int) : void
      {
         var _loc5_:ObjectiveItemRenderer = null;
         var _loc3_:Array = param1 as Array;
         if(param2 > 0)
         {
            if(param1)
            {
               this.mcFeedbackList.dataProvider = new DataProvider(_loc3_);
            }
         }
         else if(param1)
         {
            this.mcFeedbackList.dataProvider = new DataProvider(_loc3_);
         }
         this.mcFeedbackList.ShowRenderers(true);
         this.mcFeedbackList.selectedIndex = -1;
         this.mcFeedbackList.focusable = false;
         var _loc4_:int = 0;
         while(_loc4_ < this.mcFeedbackList.dataProvider.length)
         {
            (_loc5_ = this.mcFeedbackList.getRendererAt(_loc4_) as ObjectiveItemRenderer).RemoveEventListeners();
            _loc5_.mouseEnabled = false;
            _loc4_++;
         }
      }
      
      protected function handleLegendFeedbackQuestDataSet(param1:Object, param2:int) : void
      {
         var _loc3_:Array = param1 as Array;
         if(param2 > 0)
         {
            if(param1)
            {
               this.mcFeedbackQuestList.dataProvider = new DataProvider(_loc3_);
            }
         }
         else if(param1)
         {
            this.mcFeedbackQuestList.dataProvider = new DataProvider(_loc3_);
         }
         this.mcFeedbackQuestList.selectedIndex = -1;
         this.mcFeedbackQuestList.focusable = false;
         this.mcFeedbackQuestList.ShowRenderers(true);
         this.CalculateBackgroundHeight();
      }
      
      protected function CalculateBackgroundHeight() : void
      {
         var _loc1_:Number = 0;
         if(this.mcFeedbackQuestList.dataProvider.length < 3)
         {
            _loc1_ -= 120;
            this.mcFeedbackListItem1.y += _loc1_;
            this.mcFeedbackListItem2.y += _loc1_;
            this.mcFeedbackListItem3.y += _loc1_;
            this.mcFeedbackListItem4.y += _loc1_;
            this.mcSeparatorMiddle.y += _loc1_;
            this.mcLegendBackground.height += _loc1_;
            this.mcSeparatorBottom.y -= _loc1_;
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
      }
   }
}
