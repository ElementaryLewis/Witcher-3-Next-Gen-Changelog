package red.game.witcher3.menus.gwint
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.easing.Sine;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class CardTweenManager extends EventDispatcher
   {
      
      protected static const FLIP_TIMELAPSE_DURATION:Number = 0.5;
      
      protected static const FLIP_TIMELAPSE_SCALE:Number = 1.4;
      
      protected static const FLIP_MIN_SCALE:Number = 0.001;
      
      protected static const FLIP_SCALE:Number = 1.2;
      
      protected static const DEFAULT_TWEEN_DURATION:Number = 1;
      
      protected static const MOVE_TWEEN_SPEED:Number = 2000;
      
      protected static var _instance:CardTweenManager;
       
      
      protected var _cardTweens:Dictionary;
      
      protected var _cardPositions:Dictionary;
      
      public function CardTweenManager()
      {
         this._cardTweens = new Dictionary(true);
         this._cardPositions = new Dictionary(true);
         super();
      }
      
      public static function getInstance() : CardTweenManager
      {
         if(!_instance)
         {
            _instance = new CardTweenManager();
         }
         return _instance;
      }
      
      public function tweenTo(card:CardSlot, targetX:Number, targetY:Number, finishCallback:Function = null) : GTween
      {
         var curTween:GTween = null;
         if(!card)
         {
            trace("GFX [WARNING] <CardTweenManager.tweenTo> card is undefined");
            return null;
         }
         this.tryStopCardTween(card,false);
         if(targetX == card.x && targetY == card.y)
         {
            return null;
         }
         var tweenDuration:Number = this.calcTweenDuration(card.x,card.y,targetX,targetY);
         var tweenConfig:Object = {};
         if(finishCallback != null)
         {
            tweenConfig.onComplete = finishCallback;
         }
         tweenConfig.ease = Sine.easeInOut;
         curTween = new GTween(card,tweenDuration,{
            "x":targetX,
            "y":targetY
         },tweenConfig);
         this._cardTweens[card] = curTween;
         return curTween;
      }
      
      public function flipTo(card:CardSlot, targetState:String, targetX:Number = NaN, targetY:Number = NaN, finishCallback:Function = null) : GTween
      {
         var movePosition:Boolean = false;
         var startPoint:Point = null;
         var flippedPoint:Point = null;
         var middlePoint:Point = null;
         var finishPoint:Point = null;
         var tweenDuration:Number = NaN;
         var startFlipTween:GTween = null;
         var middleFlipTween:GTween = null;
         var finishFlipTween:GTween = null;
         if(!card)
         {
            trace("GFX [WARNING] <CardTweenManager.flipTo> card is undefined");
            return null;
         }
         this.tryStopCardTween(card,false);
         if(!isNaN(targetX) && !isNaN(targetY))
         {
            movePosition = true;
            startPoint = new Point(card.x,card.y);
            finishPoint = new Point(targetX,targetY);
            middlePoint = new Point((startPoint.x + finishPoint.x) / 2,(startPoint.y + finishPoint.y) / 2);
            flippedPoint = new Point((startPoint.x + middlePoint.x) / 2,(startPoint.y + middlePoint.y) / 2);
         }
         tweenDuration = this.calcTweenDuration(card.x,card.y,targetX,targetY);
         var startFlipValues:Object = {};
         var startFlipProps:Object = {};
         if(movePosition)
         {
            startFlipValues.x = flippedPoint.x;
            startFlipValues.y = flippedPoint.y;
         }
         startFlipValues.rotationY = 90;
         startFlipProps.data = targetState;
         startFlipProps.onComplete = this.onStartFlipComplete;
         startFlipTween = new GTween(card,tweenDuration / 3,startFlipValues,startFlipProps);
         var middleFlipValue:Object = {};
         var middleFlipProps:Object = {};
         if(movePosition)
         {
            middleFlipValue.x = middlePoint.x;
            middleFlipValue.y = middlePoint.y;
         }
         middleFlipValue.rotationY = 0;
         middleFlipTween = new GTween(card,tweenDuration / 3,middleFlipValue,middleFlipProps);
         middleFlipTween.paused = true;
         startFlipTween.nextTween = middleFlipTween;
         var finishFlipValue:Object = {};
         var finishFlipProps:Object = {};
         if(movePosition)
         {
            finishFlipValue.x = finishPoint.x;
            finishFlipValue.y = finishPoint.y;
         }
         finishFlipProps.onComplete = finishCallback;
         finishFlipTween = new GTween(card,tweenDuration / 3,finishFlipValue,finishFlipProps);
         finishFlipTween.paused = true;
         middleFlipTween.nextTween = finishFlipTween;
         return null;
      }
      
      public function onStartFlipComplete(tweenInstance:GTween) : void
      {
         var targetCard:CardSlot = tweenInstance.target as CardSlot;
         if(targetCard)
         {
            targetCard.cardState = tweenInstance.data as String;
            targetCard.rotationY = -90;
         }
      }
      
      public function flip(card:CardSlot, targetState:String) : void
      {
         card.cardState = targetState;
      }
      
      public function getPosition(card:CardSlot) : Point
      {
         return this._cardPositions[card];
      }
      
      public function setPosition(card:CardSlot, x:Number, y:Number) : void
      {
         this._cardPositions[card] = new Point(x,y);
         card.x = x;
         card.y = y;
      }
      
      public function storePosition(card:CardSlot) : void
      {
         this._cardPositions[card] = new Point(card.x,card.y);
      }
      
      public function restorePosition(card:CardSlot, enableTween:Boolean = false) : Boolean
      {
         var defaultPos:Point = this._cardPositions[card];
         if(defaultPos)
         {
            if(enableTween)
            {
               this.tweenTo(card,defaultPos.x,defaultPos.y);
            }
            else
            {
               card.x = defaultPos.x;
               card.y = defaultPos.y;
            }
            return true;
         }
         return false;
      }
      
      public function isCardMoving(card:CardSlot) : Boolean
      {
         return this._cardTweens[card];
      }
      
      public function isAnyCardMoving() : Boolean
      {
         var curTween:GTween = null;
         for each(curTween in this._cardTweens)
         {
            if(Boolean(curTween) && !curTween.paused)
            {
               return true;
            }
         }
         return false;
      }
      
      private function calcTweenDuration(x1:Number, y1:Number, x2:Number, y2:Number) : Number
      {
         var distance:Number = NaN;
         if(isNaN(x1) || isNaN(y1) || isNaN(x2) || isNaN(y2))
         {
            return DEFAULT_TWEEN_DURATION;
         }
         distance = Point.distance(new Point(x1,y1),new Point(x2,y2));
         return distance / MOVE_TWEEN_SPEED;
      }
      
      private function getCardTween(card:CardSlot) : GTween
      {
         return this._cardTweens[card] as GTween;
      }
      
      private function getCardDefaultPosition(card:CardSlot) : Point
      {
         return this._cardPositions[card] as Point;
      }
      
      private function tryStopCardTween(card:CardSlot, useCallback:Boolean = true) : Boolean
      {
         var curTween:GTween = this.getCardTween(card);
         if(curTween)
         {
            if(curTween.onComplete != null && useCallback)
            {
               curTween.onComplete(curTween);
            }
            curTween.paused = true;
            curTween = null;
            return true;
         }
         return false;
      }
   }
}
