package red.game.witcher3.menus.common
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import red.core.CoreComponent;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.controls.W3DropDownItemRenderer;
   import red.game.witcher3.controls.W3UILoader;
   
   public class IconItemRenderer extends W3DropDownItemRenderer
   {
       
      
      public var mcIconLoader:W3UILoader;
      
      public var mcSelectionHighlight:MovieClip;
      
      public var skipTextCentering:Boolean = false;
      
      public var headerColor:MovieClip;
      
      public var crests:MovieClip;
      
      protected var _activeSelectionEnabled:Boolean = true;
      
      internal const SINGLE_TF_ONE_LINE:Number = 18;
      
      internal const TF1_SINGLE_LINE_TEXT_POS:Number = 14;
      
      internal const TF1_MULTI_LINE_TEXT_POS:Number = 6;
      
      internal const TF2_SINGLE_LINE_TEXT_POS:Number = 45;
      
      internal const TF2_MULTI_LINE_TEXT_POS:Number = 55;
      
      public function IconItemRenderer()
      {
         super();
      }
      
      public function set activeSelectionEnabled(param1:Boolean) : void
      {
         this._activeSelectionEnabled = param1;
         if(this.mcSelectionHighlight)
         {
            this.mcSelectionHighlight.visible = param1;
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      override public function toString() : String
      {
         return "[W3 IconItemRenderer]";
      }
      
      override public function setData(param1:Object) : void
      {
         if(!param1)
         {
            return;
         }
         super.setData(param1);
         if(Boolean(param1.iconPath) && Boolean(this.mcIconLoader))
         {
            this.mcIconLoader.source = "img://" + param1.iconPath;
         }
         if(this.crests)
         {
            this.crests.gotoAndStop(param1.questArea);
         }
         if(this.headerColor)
         {
            this.headerColor.gotoAndStop(1);
            switch(param1.isStory)
            {
               case 0:
                  this.headerColor.gotoAndStop("main");
                  break;
               case 1:
                  this.headerColor.gotoAndStop("main");
                  break;
               case 2:
                  this.headerColor.gotoAndStop("secondary");
                  break;
               case 3:
                  this.headerColor.gotoAndStop("contract");
                  break;
               case 4:
                  this.headerColor.gotoAndStop("treasurehunt");
            }
         }
         if(selected)
         {
            if(param1.id)
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnEntrySelected",[param1.id]));
            }
            else if(param1.tag)
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnEntrySelected",[param1.tag]));
            }
         }
      }
      
      override public function handleEntryPress() : void
      {
         if(data)
         {
            if(data.tag)
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnEntryPress",[data.tag]));
            }
         }
      }
      
      override protected function handleMouseRollOver(param1:MouseEvent) : void
      {
         setState("over");
      }
      
      override protected function handleMouseRollOut(param1:MouseEvent) : void
      {
         setState("up");
      }
      
      override protected function draw() : void
      {
         super.draw();
         if(this.mcSelectionHighlight)
         {
            this.mcSelectionHighlight.visible = this._activeSelectionEnabled;
         }
      }
      
      override protected function updateText() : void
      {
         var _loc1_:* = false;
         var _loc2_:Boolean = false;
         if(_label != null && textField != null)
         {
            textField.htmlText = _label;
            textField.height = textField.textHeight + CommonConstants.SAFE_TEXT_PADDING;
            _loc1_ = textField.height > 35;
            _loc2_ = Boolean(tfSecondLine) && tfSecondLine.visible && tfSecondLine.htmlText != "";
            if(_loc1_)
            {
               textField.y = this.TF1_MULTI_LINE_TEXT_POS;
            }
            else if(!_loc2_)
            {
               textField.y = this.SINGLE_TF_ONE_LINE;
            }
            else
            {
               textField.y = this.TF1_SINGLE_LINE_TEXT_POS;
            }
            if(_loc2_)
            {
               if(_loc1_)
               {
                  tfSecondLine.y = this.TF2_MULTI_LINE_TEXT_POS;
               }
               else
               {
                  tfSecondLine.y = this.TF2_SINGLE_LINE_TEXT_POS;
               }
            }
            if(CoreComponent.isArabicAligmentMode)
            {
               textField.htmlText = "<p align=\"right\">" + _label + "</p>";
            }
         }
      }
   }
}
