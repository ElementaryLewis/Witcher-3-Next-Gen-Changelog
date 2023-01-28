package red.game.witcher3.utils.motion
{
   import scaleform.clik.motion.Tween;
   
   public class TweenEx extends Tween
   {
       
      
      public function TweenEx(param1:Number, param2:Object = null, param3:Object = null, param4:Object = null)
      {
         super(param1,param2,param3,param4);
      }
      
      public static function pauseTweenOn(param1:Object) : *
      {
         var _loc3_:Tween = null;
         var _loc2_:Vector.<Tween> = new Vector.<Tween>();
         _loc3_ = firstTween;
         while(_loc3_ != null)
         {
            if(_loc3_.target == param1)
            {
               _loc2_.push(_loc3_);
            }
            _loc3_ = _loc3_.nextTween;
         }
         for each(_loc3_ in _loc2_)
         {
            _loc3_.paused = true;
         }
      }
      
      public static function to(param1:Number, param2:Object = null, param3:Object = null, param4:Object = null) : TweenEx
      {
         return new TweenEx(param1,param2,param3,param4);
      }
   }
}
