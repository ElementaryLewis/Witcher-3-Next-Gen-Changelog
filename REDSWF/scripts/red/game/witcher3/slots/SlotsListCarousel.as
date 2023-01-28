package red.game.witcher3.slots
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import flash.display.DisplayObject;
   import red.core.constants.KeyCode;
   import red.game.witcher3.interfaces.IBaseSlot;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.menus.gwint.CardInstance;
   import red.game.witcher3.menus.gwint.CardSlot;
   import red.game.witcher3.menus.gwint.GwintTutorial;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class SlotsListCarousel extends SlotsListBase
   {
      
      private static const ITEM_ROTATE_KOEFF:Number = 15;
      
      private static const ITEM_SCALE_KOEFF:Number = 0.3;
      
      private static const ITEM_PADDING:Number = 10;
      
      private static const ITEM_Y_OFFSET:Number = 70;
       
      
      private var _displayItemsCount:uint;
      
      private var baseComponentWidth:Number;
      
      private var baseComponentHeight:Number;
      
      public var inputEnabled:Boolean = true;
      
      public function SlotsListCarousel()
      {
         super();
         ignoreSelectable = true;
      }
      
      public function get displayItemsCount() : uint
      {
         return this._displayItemsCount;
      }
      
      public function set displayItemsCount(value:uint) : void
      {
         this._displayItemsCount = value;
      }
      
      public function replaceItem(sourceItem:*, newItem:*) : void
      {
         var curCard:CardSlot = null;
         var sourceInstance:CardInstance = null;
         var newInstance:CardInstance = null;
         trace("GFX [SlotsListCarousel][replaceItem] newItem: ",newItem);
         var len:int = int(_renderers.length);
         for(var i:int = 0; i < len; i++)
         {
            curCard = _renderers[i] as CardSlot;
            sourceInstance = sourceItem as CardInstance;
            newInstance = newItem as CardInstance;
            if(Boolean(curCard) && curCard.instanceId == sourceInstance.instanceId)
            {
               curCard.setCardSource(newInstance);
            }
         }
      }
      
      private function spawnRenderer(index:uint) : IBaseSlot
      {
         var newInstanse:IBaseSlot = new _slotRendererRef() as IBaseSlot;
         newInstanse.index = index;
         _canvas.addChild(newInstanse as DisplayObject);
         setupRenderer(newInstanse);
         return newInstanse;
      }
      
      private function shiftRenderers(direction:Boolean) : void
      {
      }
      
      override protected function populateData() : void
      {
         var count:int = 0;
         var curPosition:Number = NaN;
         var i:int = 0;
         var newInstance:SlotBase = null;
         var cardSlot:CardSlot = null;
         var instanceComponent:UIComponent = null;
         trace("GFX [SlotsListCarousel] populateData ",_data);
         if(_renderers.length > 0)
         {
            clearRenderers();
         }
         super.populateData();
         if(_data)
         {
            count = int(_data.length);
            curPosition = 0;
            for(i = 0; i < count; i++)
            {
               newInstance = this.spawnRenderer(i) as SlotBase;
               cardSlot = newInstance as CardSlot;
               newInstance.useContextMgr = false;
               if(cardSlot)
               {
                  cardSlot.cardState = CardSlot.STATE_CAROUSEL;
                  if(_data[i] is CardInstance)
                  {
                     cardSlot.setCardSource(_data[i]);
                  }
                  else
                  {
                     cardSlot.cardIndex = _data[i];
                  }
               }
               else
               {
                  newInstance.setData(_data[i]);
               }
               _renderers.push(newInstance);
               instanceComponent = newInstance as UIComponent;
            }
            _canvas.x = 0;
            _canvas.y = ITEM_Y_OFFSET;
         }
         if(_renderers.length > 0)
         {
            this.baseComponentWidth = CardSlot.CARD_ORIGIN_WIDTH;
            this.baseComponentHeight = CardSlot.CARD_ORIGIN_HEIGHT;
         }
         if(InputManager.getInstance().isGamepad())
         {
            this.selectedIndex = 0;
         }
         if(_renderers.length > 0)
         {
            this.repositionCards(false);
         }
      }
      
      override public function set selectedIndex(value:int) : void
      {
         var scrollBackward:* = _selectedIndex < value;
         super.selectedIndex = value;
         this.repositionCards(true);
      }
      
      override public function get itemClickEnabled() : Boolean
      {
         if(GwintTutorial.mSingleton)
         {
            return !GwintTutorial.mSingleton.active;
         }
         return true;
      }
      
      protected function repositionCards(animated:Boolean) : void
      {
         var i:int = 0;
         var targetX:Number = NaN;
         var targetY:Number = NaN;
         var targetScale:Number = NaN;
         var targetRotation:Number = NaN;
         var middleIndex:int = 0;
         var distanceFromMiddle:int = 0;
         var currentComponent:UIComponent = null;
         var shouldBeVisible:Boolean = false;
         var maxOffset:Number = Math.floor(this._displayItemsCount / 2);
         if(_cachedSelection < 0)
         {
            middleIndex = 0;
         }
         else
         {
            middleIndex = _cachedSelection;
         }
         for(i = 0; i < _renderers.length; i++)
         {
            distanceFromMiddle = i - middleIndex;
            if(distanceFromMiddle == 0)
            {
               targetX = 0;
               targetY = 0;
               targetScale = 1;
               targetRotation = 0;
               shouldBeVisible = true;
            }
            else if(Math.abs(distanceFromMiddle) <= maxOffset)
            {
               targetX = distanceFromMiddle * this.baseComponentWidth;
               targetScale = 1 - ITEM_SCALE_KOEFF * Math.abs(distanceFromMiddle) / maxOffset;
               targetY = -((this.baseComponentHeight - this.baseComponentHeight * targetScale) / 2);
               targetRotation = ITEM_ROTATE_KOEFF * distanceFromMiddle / maxOffset;
               shouldBeVisible = true;
            }
            else
            {
               shouldBeVisible = false;
               if(distanceFromMiddle > 0)
               {
                  targetX = 1920 + this.baseComponentWidth;
               }
               else
               {
                  targetX = -1920 - this.baseComponentWidth;
               }
               targetY = this.baseComponentHeight * ITEM_SCALE_KOEFF / 2;
               targetScale = 1 - ITEM_SCALE_KOEFF;
               targetRotation = ITEM_ROTATE_KOEFF;
            }
            currentComponent = _renderers[i] as UIComponent;
            GTweener.removeTweens(currentComponent);
            if(!animated)
            {
               currentComponent.visible = shouldBeVisible;
               currentComponent.x = targetX;
               currentComponent.y = targetY;
               currentComponent.actualScaleX;
               currentComponent.scaleX = currentComponent.scaleY = targetScale;
            }
            else if(shouldBeVisible)
            {
               currentComponent.visible = true;
               GTweener.to(currentComponent,0.2,{
                  "x":targetX,
                  "y":targetY,
                  "scaleX":targetScale,
                  "scaleY":targetScale
               },{});
            }
            else if(targetX != currentComponent.x)
            {
               GTweener.to(currentComponent,0.2,{
                  "x":targetX,
                  "y":targetY,
                  "scaleX":targetScale,
                  "scaleY":targetScale
               },{"onComplete":this.onHideComplete});
            }
         }
      }
      
      protected function onHideComplete(curTween:GTween) : void
      {
         var targetComponent:UIComponent = curTween.target as UIComponent;
         if(targetComponent)
         {
            targetComponent.visible = false;
         }
      }
      
      override public function handleInput(event:InputEvent) : void
      {
         if(!this.inputEnabled)
         {
            return;
         }
         super.handleInput(event);
         if(event.handled || !parent.visible)
         {
            return;
         }
         var details:InputDetails = event.details;
         var keyPress:Boolean = details.value == InputValue.KEY_DOWN || details.value == InputValue.KEY_HOLD;
         if(keyPress)
         {
            switch(details.code)
            {
               case KeyCode.LEFT:
                  this.navigateLeft();
                  break;
               case KeyCode.RIGHT:
                  this.navigateRight();
            }
         }
      }
      
      public function navigateLeft() : void
      {
         if(selectedIndex > 0)
         {
            --selectedIndex;
         }
      }
      
      public function navigateRight() : void
      {
         if(selectedIndex < _renderers.length - 1)
         {
            ++selectedIndex;
         }
      }
   }
}
