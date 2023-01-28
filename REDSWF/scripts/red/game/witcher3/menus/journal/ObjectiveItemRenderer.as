package red.game.witcher3.menus.journal
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import red.core.CoreComponent;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.W3ScrollingList;
   import scaleform.clik.events.ButtonEvent;
   
   public class ObjectiveItemRenderer extends QuestItemRenderer
   {
      
      protected static var UNHILIGHT:String = "UNHILIGHT WHOLE LIST";
      
      public static const DELIMITER_STATUS:int = 1000;
       
      
      public var mcSelection:MovieClip;
      
      public var mcSelectionGlow:MovieClip;
      
      public var mcHitArea:MovieClip;
      
      public var mcOverBackground:MovieClip;
      
      public var mcCheckboxFrame:MovieClip;
      
      private const INVALID_VALUE:int = -100000;
      
      private var selectionStartY:int = -100000;
      
      private var selectionGlowStartY:int = -100000;
      
      private var selectionGlowStartHeight:int = -100000;
      
      private var startingColor:uint;
      
      protected var _selectionGlowEnabled:Boolean = true;
      
      public function ObjectiveItemRenderer()
      {
         super();
         if(this.mcHitArea)
         {
            hitArea = this.mcHitArea;
         }
      }
      
      override protected function configUI() : void
      {
         if(textField)
         {
            this.startingColor = textField.textColor;
         }
         if(Boolean(this.mcSelection) && this.selectionStartY == this.INVALID_VALUE)
         {
            this.selectionStartY = this.mcSelection.y;
         }
         if(Boolean(this.mcSelectionGlow) && this.selectionGlowStartY == this.INVALID_VALUE)
         {
            this.selectionGlowStartY = this.mcSelectionGlow.y;
            this.selectionGlowStartHeight = this.mcSelectionGlow.height;
         }
         addEventListener(ButtonEvent.PRESS,this.handleButtonPress,false,0,false);
         super.configUI();
      }
      
      override protected function UpdateQuestStatusText() : void
      {
      }
      
      override public function setData(param1:Object) : void
      {
         if(index == 0)
         {
            this.SetIsNew(false);
         }
         super.setData(param1);
         this.updateSelectionStrokePosition();
         this.updateVisibility();
         enabled = !this.isDelimiter();
      }
      
      public function set selectionGlowEnabled(param1:Boolean) : void
      {
         this._selectionGlowEnabled = param1;
         if(this.mcSelectionGlow)
         {
            this.mcSelectionGlow.visible = this._selectionGlowEnabled;
         }
      }
      
      override protected function IsStory() : Boolean
      {
         return false;
      }
      
      protected function handleButtonPress(param1:ButtonEvent) : void
      {
         if(data.status < 2)
         {
            stage.dispatchEvent(new Event(ObjectiveItemRenderer.UNHILIGHT));
            Tracked = !Tracked;
            if(Tracked)
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnHighlightObjective",[data.tag]));
            }
         }
      }
      
      override public function AddEventListeners() : *
      {
         stage.addEventListener(ObjectiveItemRenderer.UNHILIGHT,handleUntrackItem,false,0,false);
      }
      
      public function RemoveEventListeners() : *
      {
         stage.removeEventListener(ObjectiveItemRenderer.UNHILIGHT,handleUntrackItem);
      }
      
      public function SetIsNew(param1:Boolean) : *
      {
         _isNew = param1;
      }
      
      override protected function updateText() : void
      {
         var _loc1_:String = null;
         if(_label != null && textField != null)
         {
            if(Boolean(data) && !data.isLegend)
            {
               if(_tracked)
               {
                  _loc1_ = "<font color=\'#FFFFFF\'>" + _Title + questStatusColorEnd;
               }
               else if(data.status == 2)
               {
                  _loc1_ = "<font color=\'#6B6A69\'>" + _Title + questStatusColorEnd;
               }
               else if(data.status == 3)
               {
                  _loc1_ = "<font color=\'#BE190B\'>" + _Title + questStatusColorEnd;
               }
               else
               {
                  _loc1_ = _label;
               }
            }
            else
            {
               _loc1_ = _label;
            }
            if(CoreComponent.isArabicAligmentMode)
            {
               textField.htmlText = "<p align=\"right\">" + _loc1_ + "</p>";
            }
            else
            {
               textField.htmlText = _loc1_;
            }
         }
         if(this.mcSelectionGlow)
         {
            this.mcSelectionGlow.visible = this._selectionGlowEnabled;
         }
         this.updateSelectionStrokePosition();
      }
      
      private function updateSelectionStrokePosition() : void
      {
         if(this.mcSelection)
         {
            this.mcSelection.y = textField.textHeight - 7;
         }
         if(this.mcSelectionGlow)
         {
            this.mcSelectionGlow.height = textField.textHeight + 14;
            this.mcSelectionGlow.y = -6;
         }
         if(this.mcHitArea)
         {
            this.mcHitArea.height = textField.textHeight + 13;
         }
         if(this.mcOverBackground)
         {
            this.mcOverBackground.height = textField.textHeight + 13;
         }
         parent.dispatchEvent(new Event(W3ScrollingList.REPOSITION));
      }
      
      override protected function SetReadState(param1:MovieClip) : *
      {
         super.SetReadState(param1);
         if(param1.visible)
         {
            param1.gotoAndStop("new");
         }
      }
      
      private function updateVisibility() : *
      {
         var _loc1_:Number = 1;
         if(this.isDelimiter())
         {
            _loc1_ = 0;
         }
         if(mcFeedbackIcon)
         {
            mcFeedbackIcon.alpha = _loc1_;
         }
         if(mcFeedbackIconSecond)
         {
            mcFeedbackIconSecond.alpha = _loc1_;
         }
         if(this.mcCheckboxFrame)
         {
            this.mcCheckboxFrame.alpha = _loc1_;
         }
         if(this.mcOverBackground)
         {
            this.mcOverBackground.alpha = _loc1_;
         }
      }
      
      override protected function updateAfterStateChange() : void
      {
         super.updateAfterStateChange();
         this.updateVisibility();
      }
      
      private function isDelimiter() : Boolean
      {
         if(data)
         {
            return data.status == DELIMITER_STATUS;
         }
         return false;
      }
   }
}
