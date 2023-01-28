package red.game.witcher3.hud.modules.quests
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.interfaces.IListItemRenderer;
   import scaleform.gfx.InteractiveObjectEx;
   
   public class HudQuestContainer extends UIComponent
   {
       
      
      public var mcDifficultyIcon:MovieClip;
      
      public var mcQuestObjectiveList:HudQuestObjectiveList;
      
      public var mcQuestObjectiveListItem1:HudQuestObjectiveListItem;
      
      public var mcQuestObjectiveListItem2:HudQuestObjectiveListItem;
      
      public var mcQuestObjectiveListItem3:HudQuestObjectiveListItem;
      
      public var mcQuestObjectiveListItem4:HudQuestObjectiveListItem;
      
      public var mcQuestObjectiveListItem5:HudQuestObjectiveListItem;
      
      public var mcQuestObjectiveListItem6:HudQuestObjectiveListItem;
      
      public var mcQuestObjectiveListItem7:HudQuestObjectiveListItem;
      
      public var mcQuestObjectiveListItem8:HudQuestObjectiveListItem;
      
      public var mcArrowUp:MovieClip;
      
      public var mcArrowDown:MovieClip;
      
      public var tfOr:TextField;
      
      private var _QuestType:String;
      
      public function HudQuestContainer()
      {
         super();
         InteractiveObjectEx.setHitTestDisable(this,true);
         mouseEnabled = tabEnabled = mouseChildren = tabChildren = false;
      }
      
      public function get QuestType() : String
      {
         return this._QuestType;
      }
      
      public function set QuestType(param1:String) : void
      {
         this._QuestType = param1;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         alpha = 0;
         if(this.mcDifficultyIcon)
         {
            this.mcDifficultyIcon.visible = false;
         }
      }
      
      public function onDifficultyUpdate(param1:Boolean) : void
      {
         if(this.mcDifficultyIcon)
         {
            this.mcDifficultyIcon.visible = param1;
         }
      }
      
      public function onQuestNameSet(param1:String) : void
      {
         this.mcQuestObjectiveList.onQuestNameSet(param1);
      }
      
      public function onQuestNameColorSet(param1:int) : void
      {
         this.mcQuestObjectiveList.onQuestNameColorSet(param1);
      }
      
      public function onObjectiveDataSet(param1:Object, param2:int) : void
      {
         this.mcQuestObjectiveList.selectedIndex = -1;
         this.mcQuestObjectiveList.validateNow();
         var _loc3_:Array = param1 as Array;
         if(param2 <= 0)
         {
            if(param1)
            {
               this.mcQuestObjectiveList.dataProvider = new DataProvider(_loc3_);
            }
         }
         this.mcQuestObjectiveList.selectedIndex = this.getHighlightedIndex();
         this.mcQuestObjectiveList.validateNow();
         this.mcQuestObjectiveList.repositionRenderers();
         this.repositionOrSeparator();
         this.repositionArrowDown();
         this.updateArrows();
      }
      
      private function getHighlightedIndex() : int
      {
         var _loc1_:* = 0;
         while(_loc1_ < this.mcQuestObjectiveList.dataProvider.length)
         {
            if(this.mcQuestObjectiveList.dataProvider[_loc1_].isHighlighted)
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return -1;
      }
      
      public function UpdateObjectiveCounter(param1:int, param2:String) : void
      {
         var _loc5_:DataProvider = null;
         var _loc3_:int = param1 - this.mcQuestObjectiveList.scrollPosition;
         var _loc4_:HudQuestObjectiveListItem;
         if(_loc4_ = this.mcQuestObjectiveList.getRendererAt(_loc3_) as HudQuestObjectiveListItem)
         {
            if(_loc5_ = this.mcQuestObjectiveList.dataProvider as DataProvider)
            {
               _loc5_[param1].name = _loc5_[param1].label = param2;
               _loc5_.invalidate();
               _loc4_.tfObjective.htmlText = param2;
               _loc4_.ShowNewFeedback();
            }
         }
      }
      
      public function HighlightObjective(param1:int, param2:Boolean) : void
      {
         this.mcQuestObjectiveList.selectedIndex = param1;
         this.mcQuestObjectiveList.validateNow();
         this.updateArrows();
         var _loc3_:int = param1 - this.mcQuestObjectiveList.scrollPosition;
         var _loc4_:HudQuestObjectiveListItem;
         if(_loc4_ = this.mcQuestObjectiveList.getRendererAt(_loc3_) as HudQuestObjectiveListItem)
         {
            _loc4_.Highlight(param2);
         }
         this.mcQuestObjectiveList.invalidateData();
      }
      
      public function UnhighlightAllObjectives() : void
      {
         var _loc3_:HudQuestObjectiveListItem = null;
         var _loc1_:Vector.<IListItemRenderer> = this.mcQuestObjectiveList.getRenderers();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_] as HudQuestObjectiveListItem;
            if(_loc3_)
            {
               _loc3_.Highlight(false);
            }
            _loc2_++;
         }
         this.mcQuestObjectiveList.invalidateData();
      }
      
      private function repositionOrSeparator() : *
      {
         var _loc2_:HudQuestObjectiveListItem = null;
         var _loc3_:HudQuestObjectiveListItem = null;
         var _loc1_:Vector.<IListItemRenderer> = this.mcQuestObjectiveList.getRenderers();
         if(Boolean(_loc1_) && _loc1_.length >= 2)
         {
            _loc2_ = _loc1_[0] as HudQuestObjectiveListItem;
            _loc3_ = _loc1_[1] as HudQuestObjectiveListItem;
            if(Boolean(_loc2_) && Boolean(_loc3_))
            {
               if(_loc2_.data && _loc2_.data.isMutuallyExclusive && _loc3_.data && Boolean(_loc3_.data.isMutuallyExclusive))
               {
                  this.tfOr.visible = true;
                  this.tfOr.y = _loc3_.y - 15;
                  _loc3_.y += this.tfOr.textHeight;
                  return;
               }
            }
         }
         this.tfOr.visible = false;
      }
      
      public function repositionArrowDown() : *
      {
         var _loc3_:HudQuestObjectiveListItem = null;
         var _loc1_:Vector.<IListItemRenderer> = this.mcQuestObjectiveList.getRenderers();
         var _loc2_:* = _loc1_.length - 1;
         while(_loc2_ >= 0)
         {
            _loc3_ = _loc1_[_loc2_] as HudQuestObjectiveListItem;
            if(_loc3_)
            {
               if(_loc3_.visible)
               {
                  this.mcArrowDown.y = _loc3_.y + _loc3_.tfObjective.height - 3;
                  return;
               }
            }
            _loc2_--;
         }
      }
      
      public function updateArrows() : *
      {
         var _loc1_:int = int(this.mcQuestObjectiveList.getRenderers().length);
         var _loc2_:int = int(this.mcQuestObjectiveList.dataProvider.length);
         if(_loc2_ <= _loc1_)
         {
            this.mcArrowUp.visible = false;
            this.mcArrowDown.visible = false;
         }
         else
         {
            this.mcArrowUp.visible = this.mcQuestObjectiveList.scrollPosition > 0;
            this.mcArrowDown.visible = _loc1_ + this.mcQuestObjectiveList.scrollPosition < _loc2_;
         }
      }
   }
}
