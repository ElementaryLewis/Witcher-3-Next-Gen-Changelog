package red.game.witcher3.menus.worldmap
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.W3ScrollingList;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.interfaces.IListItemRenderer;
   import scaleform.clik.ui.InputDetails;
   
   public class HubMapQuestTracker extends UIComponent
   {
       
      
      public var mcHubMapQuestTrackerQuest:MovieClip;
      
      public var mcHubMapQuestTrackerList:W3ScrollingList;
      
      private var _objectivesCount:int = 0;
      
      private var _collapseWhenUpdated:Boolean;
      
      private var _expandedList:Boolean = false;
      
      private const RIGHT_MARGIN:int = 70;
      
      private const LEFT_MARGIN:int = 5;
      
      public function HubMapQuestTracker()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         addEventListener(MouseEvent.MOUSE_OVER,this.OnMouseOver,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,this.OnMouseOut,false,0,true);
         this.mcHubMapQuestTrackerList.addEventListener(ListEvent.INDEX_CHANGE,this.handleIndexChanged,false,0,true);
      }
      
      public function enableMouse(param1:Boolean) : *
      {
         mouseEnabled = param1;
         mouseChildren = param1;
      }
      
      public function OnMouseOver(param1:MouseEvent) : *
      {
         if(mouseEnabled)
         {
            this.expandList(true);
         }
      }
      
      public function OnMouseOut(param1:MouseEvent) : *
      {
         this.expandList(false);
      }
      
      public function OnMouseMoveFromParent(param1:Point) : *
      {
         if(mouseEnabled)
         {
            this.expandList(this.isGlobalPointInsideBounds(param1));
         }
      }
      
      protected function handleIndexChanged(param1:ListEvent) : *
      {
         var _loc2_:HubMapQuestTrackerItemRenderer = null;
         this.expandList(true);
         if(param1.index > 0)
         {
            _loc2_ = this.mcHubMapQuestTrackerList.getRendererAt(param1.index) as HubMapQuestTrackerItemRenderer;
            if(_loc2_)
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnHighlightObjective",[_loc2_.getScriptName()]));
            }
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = param1.details;
         var _loc3_:* = _loc2_.value == InputValue.KEY_DOWN;
         var _loc4_:* = _loc2_.value == InputValue.KEY_UP;
         var _loc5_:Boolean = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
         if(_loc2_.code == 1000)
         {
            this.expandList(false);
         }
         else if(_loc2_.code == KeyCode.PAD_RIGHT_THUMB || _loc2_.code == KeyCode.V)
         {
            this.expandList(true);
            if(_loc3_)
            {
               if(this._objectivesCount > 1)
               {
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnHighlightNextObjective"));
               }
            }
         }
      }
      
      private function isGlobalPointInsideBounds(param1:Point) : Boolean
      {
         var _loc2_:Rectangle = this.mcHubMapQuestTrackerList.getBounds(stage);
         return param1.x > _loc2_.left && param1.x < _loc2_.right && param1.y > _loc2_.top && param1.y < _loc2_.bottom;
      }
      
      public function canBeShown() : Boolean
      {
         return this._objectivesCount > 0;
      }
      
      public function setCurrentQuest(param1:Object) : *
      {
         if(!param1)
         {
            return;
         }
         this.mcHubMapQuestTrackerQuest.tfQuest.htmlText = param1.questName;
         this.mcHubMapQuestTrackerQuest.tfQuest.width = this.mcHubMapQuestTrackerQuest.tfQuest.textWidth;
         this.mcHubMapQuestTrackerQuest.tfQuest.x = this.mcHubMapQuestTrackerQuest.mcBackground.x + 15 - this.RIGHT_MARGIN - this.mcHubMapQuestTrackerQuest.tfQuest.width;
         this.mcHubMapQuestTrackerQuest.mcBackground.width = this.RIGHT_MARGIN + this.mcHubMapQuestTrackerQuest.tfQuest.textWidth + this.LEFT_MARGIN;
         switch(param1.questType)
         {
            case 0:
            case 1:
            case 2:
               switch(param1.contentType)
               {
                  case 0:
                     this.mcHubMapQuestTrackerQuest.mcPinIcon.gotoAndStop("QuestAvailable");
                     break;
                  case 1:
                     this.mcHubMapQuestTrackerQuest.mcPinIcon.gotoAndStop("QuestAvailableHoS");
                     break;
                  case 2:
                     this.mcHubMapQuestTrackerQuest.mcPinIcon.gotoAndStop("QuestAvailableBaW");
               }
               break;
            case 3:
               this.mcHubMapQuestTrackerQuest.mcPinIcon.gotoAndStop("MonsterHunt");
               break;
            case 4:
               this.mcHubMapQuestTrackerQuest.mcPinIcon.gotoAndStop("TreasureHunt");
         }
         this._collapseWhenUpdated = !param1.onHighlight;
      }
      
      public function setCurrentObjectives(param1:Array) : *
      {
         if(!param1)
         {
            return;
         }
         this._objectivesCount = param1.length;
         this.mcHubMapQuestTrackerList.dataProvider = new DataProvider(param1);
         this.mcHubMapQuestTrackerList.selectedIndex = -1;
         this.mcHubMapQuestTrackerList.validateNow();
         if(this._collapseWhenUpdated)
         {
            if(!this.expandList(false))
            {
               this.updateVisibility();
               this.resizeHitArea();
            }
         }
         else
         {
            this.updateVisibility();
            this.resizeHitArea();
         }
      }
      
      private function expandList(param1:Boolean) : Boolean
      {
         if(this._expandedList == param1)
         {
            return false;
         }
         this._expandedList = param1;
         this.updateVisibility();
         this.resizeHitArea();
         return true;
      }
      
      private function updateVisibility() : *
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<IListItemRenderer> = null;
         var _loc3_:HubMapQuestTrackerItemRenderer = null;
         _loc2_ = this.mcHubMapQuestTrackerList.getRenderers();
         _loc1_ = 0;
         while(_loc1_ < this._objectivesCount)
         {
            _loc3_ = _loc2_[_loc1_] as HubMapQuestTrackerItemRenderer;
            if(_loc3_)
            {
               if(this._expandedList)
               {
                  _loc3_.alpha = 1;
                  if(_loc1_ > 2)
                  {
                     _loc3_.visible = true;
                  }
               }
               else if(_loc1_ == 0)
               {
                  _loc3_.alpha = 1;
               }
               else if(_loc1_ == 1)
               {
                  _loc3_.alpha = 0.5;
               }
               else if(_loc1_ == 2)
               {
                  _loc3_.alpha = 0.3;
               }
               else
               {
                  _loc3_.visible = false;
               }
            }
            _loc1_++;
         }
      }
      
      private function resizeHitArea() : *
      {
         var _loc5_:Rectangle = null;
         var _loc7_:int = 0;
         var _loc8_:HubMapQuestTrackerItemRenderer = null;
         var _loc9_:Rectangle = null;
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         _loc3_ = (_loc5_ = this.mcHubMapQuestTrackerQuest.getBounds(this)).top;
         _loc2_ = _loc5_.right;
         _loc1_ = _loc5_.left;
         _loc4_ = _loc5_.bottom;
         var _loc6_:Vector.<IListItemRenderer> = this.mcHubMapQuestTrackerList.getRenderers();
         _loc7_ = 0;
         while(_loc7_ < _loc6_.length)
         {
            if((_loc8_ = _loc6_[_loc7_] as HubMapQuestTrackerItemRenderer) && _loc8_.visible && _loc8_.alpha > 0)
            {
               _loc9_ = _loc8_.getBounds(this);
               if(isNaN(_loc1_) || _loc1_ > _loc9_.left)
               {
                  _loc1_ = _loc9_.left;
               }
               if(isNaN(_loc2_) || _loc2_ < _loc9_.right)
               {
                  _loc2_ = _loc9_.right;
               }
               if(isNaN(_loc3_) || _loc3_ > _loc9_.top)
               {
                  _loc3_ = _loc9_.top;
               }
               if(isNaN(_loc4_) || _loc4_ < _loc9_.bottom)
               {
                  _loc4_ = _loc9_.bottom;
               }
            }
            _loc7_++;
         }
         this.mcHubMapQuestTrackerList.x = _loc2_;
         this.mcHubMapQuestTrackerList.y = _loc3_;
         this.mcHubMapQuestTrackerList.scaleX = (_loc2_ - _loc1_) / 100;
         this.mcHubMapQuestTrackerList.scaleY = (_loc4_ - _loc3_) / 100;
      }
   }
}
