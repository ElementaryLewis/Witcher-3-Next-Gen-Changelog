package red.game.witcher3.hud.modules
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import red.core.events.GameEvent;
   
   public class HudModuleOneliners extends HudModuleBase
   {
       
      
      private var savedScale:Number;
      
      private var oneliners:Dictionary;
      
      private var onelinerClassRef:Class;
      
      private var onelinerPool:Vector.<Sprite>;
      
      public function HudModuleOneliners()
      {
         this.oneliners = new Dictionary(true);
         this.onelinerPool = new Vector.<Sprite>();
         super();
         addFrameScript(0,this.frame1);
      }
      
      override public function get moduleName() : String
      {
         return "OnelinersModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         alpha = 0;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         this.onelinerClassRef = getDefinitionByName("OnelinerLabelRef") as Class;
         if(!this.onelinerClassRef)
         {
            return;
         }
         this.AddOnelinersToPool(5);
      }
      
      private function AddOnelinersToPool(param1:int) : *
      {
         var _loc2_:Sprite = null;
         var _loc3_:TextField = null;
         if(!this.onelinerClassRef)
         {
            this.onelinerPool.push(null);
            return;
         }
         var _loc4_:* = 0;
         while(_loc4_ < param1)
         {
            _loc2_ = new this.onelinerClassRef() as Sprite;
            this.onelinerPool.push(_loc2_);
            _loc4_++;
         }
      }
      
      private function GetOnelinerFromPool() : Sprite
      {
         if(this.onelinerPool.length == 0)
         {
            this.AddOnelinersToPool(1);
         }
         return this.onelinerPool.pop();
      }
      
      private function PutOnelinerToPool(param1:Sprite) : *
      {
         return this.onelinerPool.push(param1);
      }
      
      public function UpdateScale(param1:Number) : void
      {
         var _loc2_:Sprite = null;
         this.savedScale = param1;
         for each(_loc2_ in this.oneliners)
         {
            _loc2_.scaleX = this.savedScale;
            _loc2_.scaleY = this.savedScale;
         }
      }
      
      public function CreateOneliner(param1:int, param2:String) : void
      {
         var _loc3_:Sprite = null;
         _loc3_ = this.GetOnelinerFromPool();
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:TextField;
         (_loc4_ = _loc3_["textField"] as TextField).htmlText = param2;
         _loc4_.y = -_loc4_.textHeight;
         _loc3_.visible = true;
         _loc3_.name = "mcOneliner" + param1;
         _loc3_.x = -1920;
         _loc3_.y = -1080;
         _loc3_.scaleX = this.savedScale;
         _loc3_.scaleY = this.savedScale;
         this.oneliners[param1] = _loc3_;
         addChild(_loc3_);
      }
      
      public function UpdateOneliner(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:Sprite;
         if(!(_loc4_ = this.oneliners[param1]))
         {
            return;
         }
         _loc4_.x = param2;
         _loc4_.y = param3;
      }
      
      public function RemoveOneliner(param1:int) : void
      {
         var _loc2_:Sprite = null;
         _loc2_ = this.oneliners[param1];
         if(!_loc2_)
         {
            return;
         }
         removeChild(_loc2_);
         _loc2_.visible = false;
         this.PutOnelinerToPool(_loc2_);
         delete this.oneliners[param1];
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
