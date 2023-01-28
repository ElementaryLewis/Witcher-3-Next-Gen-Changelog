package red.game.witcher3.hud.modules.console
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import red.core.events.GameEvent;
   import scaleform.clik.core.UIComponent;
   
   public class ConsoleMessagesQueue extends UIComponent
   {
      
      protected static const RENDERER_CONTENT_REF:String = "mcConsoleMessageItem";
      
      protected static const ANIM_DIRECTION_UP:String = "up";
      
      protected static const ANIM_DIRECTION_DOWN:String = "down";
      
      protected static const ANIM_REARRANGE_DURATION:Number = 0.1;
       
      
      private var _direction:String;
      
      private var _msgVisibilityDuration:Number;
      
      private var _padding:Number;
      
      private var _cachedHeight:Number;
      
      private var _messageRenderers:Vector.<ConsoleMessageItem>;
      
      private var _canvas:Sprite;
      
      private var _rendererClassRef:Class;
      
      public function ConsoleMessagesQueue()
      {
         this._messageRenderers = new Vector.<ConsoleMessageItem>();
         super();
         this._canvas = new Sprite();
         addChild(this._canvas);
         this._cachedHeight = height;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this._rendererClassRef = getDefinitionByName(RENDERER_CONTENT_REF) as Class;
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(param1:String) : void
      {
         this._direction = param1;
      }
      
      public function get msgVisibilityDuration() : Number
      {
         return this._msgVisibilityDuration;
      }
      
      public function set msgVisibilityDuration(param1:Number) : void
      {
         this._msgVisibilityDuration = param1;
      }
      
      public function get padding() : Number
      {
         return this._padding;
      }
      
      public function set padding(param1:Number) : void
      {
         this._padding = param1;
      }
      
      public function pushMessage(param1:String) : void
      {
         var _loc2_:ConsoleMessageItem = this.createMessage(param1,this._msgVisibilityDuration);
         this.rearrangeMessages(_loc2_);
      }
      
      public function cleanup() : void
      {
         var _loc1_:uint = this._messageRenderers.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this._canvas.removeChild(this._messageRenderers.pop());
            _loc2_++;
         }
      }
      
      protected function createMessage(param1:String, param2:Number) : ConsoleMessageItem
      {
         var _loc3_:ConsoleMessageItem = new this._rendererClassRef() as ConsoleMessageItem;
         _loc3_.init(param1,param2,this.width);
         this._canvas.addChild(_loc3_);
         _loc3_.addEventListener(Event.COMPLETE,this.handleItemHidden,false,0,true);
         this._messageRenderers.push(_loc3_);
         return _loc3_;
      }
      
      protected function removeLastItem() : void
      {
         var _loc1_:ConsoleMessageItem = null;
         var _loc2_:Number = NaN;
         if(this._messageRenderers)
         {
            if(this._messageRenderers[0])
            {
               _loc1_ = this._messageRenderers[0];
               _loc2_ = this._direction == ANIM_DIRECTION_UP ? -_loc1_.actualHeight : this._cachedHeight + _loc1_.actualHeight;
               _loc1_.forceRemove();
               _loc1_.y = _loc2_;
               _loc1_.alpha = 0;
               this.removeItemFromQueue(_loc1_);
            }
         }
      }
      
      protected function removeDepricatedItems() : void
      {
         var _loc3_:ConsoleMessageItem = null;
         var _loc1_:uint = this._messageRenderers.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._messageRenderers[_loc2_];
            if(_loc3_.isVanishing())
            {
               _loc3_.destroy();
               this._canvas.removeChild(_loc3_);
               _loc3_ = null;
            }
            _loc2_++;
         }
      }
      
      protected function rearrangeMessages(param1:ConsoleMessageItem = null, param2:Boolean = false) : void
      {
         var _loc4_:Number = NaN;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:ConsoleMessageItem = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc3_:uint = this._messageRenderers.length;
         var _loc5_:Number = 0;
         var _loc6_:Dictionary = new Dictionary(true);
         var _loc7_:int = 0;
         while(_loc7_ < _loc3_)
         {
            _loc8_ = this._direction == ANIM_DIRECTION_UP ? uint(_loc7_) : uint(_loc3_ - _loc7_ - 1);
            _loc9_ = this._direction == ANIM_DIRECTION_UP ? 0 : _loc3_ - 1;
            _loc10_ = this._messageRenderers[_loc8_];
            _loc11_ = _loc8_ == _loc9_ ? 0 : this._padding;
            _loc12_ = _loc10_.actualHeight + _loc11_;
            _loc4_ = _loc5_ + _loc11_;
            _loc6_[_loc10_] = _loc4_;
            if((_loc5_ += _loc12_) > this._cachedHeight && _loc12_ < this._cachedHeight)
            {
               this.rearrangeMessages(param1,true);
               return;
            }
            if(param1 == _loc10_ && !param2)
            {
               _loc10_.y = _loc4_;
            }
            else
            {
               if(param1 == _loc10_)
               {
                  _loc10_.y = this._direction == ANIM_DIRECTION_UP ? this._cachedHeight + _loc10_.height : -_loc10_.height;
                  _loc10_.alpha = 0;
               }
               if(_loc10_)
               {
                  _loc10_.y = _loc4_;
                  _loc10_.alpha = 1;
               }
            }
            _loc7_++;
         }
      }
      
      protected function handleItemHidden(param1:Event) : void
      {
         var _loc2_:ConsoleMessageItem = param1.currentTarget as ConsoleMessageItem;
         if(_loc2_)
         {
            _loc2_.removeEventListener(Event.COMPLETE,this.handleItemHidden);
            this._canvas.removeChild(_loc2_);
            this.removeItemFromQueue(_loc2_);
            _loc2_ = null;
            this.rearrangeMessages(null,false);
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnMessageHidden",["" + this._messageRenderers.length]));
         }
      }
      
      protected function removeItemFromQueue(param1:ConsoleMessageItem) : void
      {
         var _loc2_:int = this._messageRenderers.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._messageRenderers.splice(_loc2_,1);
         }
      }
   }
}
