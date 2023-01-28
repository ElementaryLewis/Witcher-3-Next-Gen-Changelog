package red.game.witcher3.managers
{
   import flash.events.EventDispatcher;
   import red.core.events.GameEvent;
   import scaleform.clik.core.UIComponent;
   
   public class InputFeedbackManager
   {
      
      public static var useOverlayPopup:Boolean = false;
      
      public static var eventDispatcher:EventDispatcher;
      
      private static var _currentMaxIdx:uint = 0;
      
      private static var _buttonsList:Object = {};
       
      
      public function InputFeedbackManager()
      {
         super();
      }
      
      public static function appendButtonById(param1:uint, param2:String, param3:int, param4:String, param5:Boolean = false) : void
      {
         if(!eventDispatcher)
         {
            return;
         }
         if(useOverlayPopup)
         {
            param4 = "[[" + param4 + "]]";
            eventDispatcher.dispatchEvent(new GameEvent(GameEvent.CALL,"OnAppendButton",[param1,param2,param3,param4]));
         }
         else
         {
            eventDispatcher.dispatchEvent(new GameEvent(GameEvent.CALL,"OnAppendGFxButton",[param1,param2,param3,param4,param5]));
         }
      }
      
      public static function removeButtonById(param1:uint) : void
      {
         if(!eventDispatcher)
         {
            return;
         }
         if(useOverlayPopup)
         {
            eventDispatcher.dispatchEvent(new GameEvent(GameEvent.CALL,"OnRemoveButton",[param1]));
         }
         else
         {
            eventDispatcher.dispatchEvent(new GameEvent(GameEvent.CALL,"OnRemoveGFxButton",[param1]));
         }
      }
      
      public static function appendButton(param1:EventDispatcher, param2:String, param3:int, param4:String, param5:Boolean = false) : int
      {
         var _loc6_:UIComponent;
         if((Boolean(_loc6_ = param1 as UIComponent)) && !_loc6_.initialized)
         {
            return -1;
         }
         ++_currentMaxIdx;
         if(useOverlayPopup)
         {
            param1.dispatchEvent(new GameEvent(GameEvent.CALL,"OnAppendButton",[_currentMaxIdx,param2,param3,param4]));
         }
         else
         {
            param1.dispatchEvent(new GameEvent(GameEvent.CALL,"OnAppendGFxButton",[_currentMaxIdx,param2,param3,param4,param5]));
         }
         return _currentMaxIdx;
      }
      
      public static function removeButton(param1:EventDispatcher, param2:uint) : void
      {
         if(useOverlayPopup)
         {
            param1.dispatchEvent(new GameEvent(GameEvent.CALL,"OnRemoveButton",[param2]));
         }
         else
         {
            param1.dispatchEvent(new GameEvent(GameEvent.CALL,"OnRemoveGFxButton",[param2]));
         }
      }
      
      public static function cleanupButtons(param1:EventDispatcher = null) : void
      {
         var _loc2_:EventDispatcher = !!eventDispatcher ? eventDispatcher : param1;
         if(!_loc2_)
         {
            return;
         }
         if(useOverlayPopup)
         {
            _loc2_.dispatchEvent(new GameEvent(GameEvent.CALL,"OnCleanupButtons"));
         }
      }
      
      public static function appendUniqueButton(param1:EventDispatcher, param2:String, param3:int, param4:String) : void
      {
         var _loc5_:UIComponent;
         if((Boolean(_loc5_ = param1 as UIComponent)) && !_loc5_.initialized)
         {
            return;
         }
         var _loc6_:String = param1.toString() + param2 + "_" + param3;
         tryRemoveUniqueButton(param1,_loc6_);
         ++_currentMaxIdx;
         _buttonsList[_loc6_] = _currentMaxIdx;
         param1.dispatchEvent(new GameEvent(GameEvent.CALL,"OnAppendGFxButton",[_currentMaxIdx,param2,param3,param4]));
      }
      
      public static function removeUniqueButton(param1:EventDispatcher, param2:String, param3:int) : void
      {
         var _loc4_:String = param1.toString() + param2 + "_" + param3;
         tryRemoveUniqueButton(param1,_loc4_);
      }
      
      private static function tryRemoveUniqueButton(param1:EventDispatcher, param2:String) : void
      {
         var _loc3_:int = int(_buttonsList[param2]);
         if(_loc3_)
         {
            param1.dispatchEvent(new GameEvent(GameEvent.CALL,"OnRemoveGFxButton",[_loc3_]));
            delete _buttonsList[param2];
         }
      }
      
      public static function updateButtons(param1:EventDispatcher) : void
      {
         param1.dispatchEvent(new GameEvent(GameEvent.CALL,"OnUpdateGFxButtonsList"));
      }
   }
}
