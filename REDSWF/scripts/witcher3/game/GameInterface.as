package witcher3.game
{
   import flash.display.DisplayObject;
   import flash.external.ExternalInterface;
   import flash.utils.getQualifiedClassName;
   import scaleform.gfx.Extensions;
   
   public class GameInterface
   {
      
      private static var m_bInitialized:Boolean = false;
      
      public static var createBindingHandlerImpl:Function;
      
      public static var deleteBindingHandlerImpl:Function;
      
      public static var addInventoryUpdateListenerImpl:Function;
      
      public static var removeInventoryUpdateListenerImpl:Function;
      
      public static var clearBindingsImpl:Function;
      
      public static var clearInventoryUpdateListenersImpl:Function;
      
      public static var getAsyncInventoryItemStubListImpl:Function;
      
      public static var getInventoryItemStubImpl:Function;
      
      public static var getInventoryItemDetailsImpl:Function;
      
      public static var getJournalQuestObjectivesImpl:Function;
      
      public static var callEventImpl:Function;
      
      public static var getLocStringImpl:Function;
      
      public static var playSoundImpl:Function;
      
      public static var sendDisplayObjectImpl:Function;
      
      public static var sendFunctionClosuresImpl:Function;
      
      public static var getBoundValueImpl:Function;
      
      public static var sendPopupResultImpl:Function;
      
      public static var _closeAllPanelsImpl:Function;
      
      public static var _isGameValueHandleValidImpl:Function;
      
      public static var _getGameValueHandleDebugStringImpl:Function;
      
      public static var _setHudInputImpl:Function;
       
      
      public function GameInterface()
      {
         super();
      }
      
      public static function initialize() : void
      {
         if(!m_bInitialized)
         {
            if(Extensions.isScaleform)
            {
               ExternalInterface.call("GameInterfaceInit",GameInterface);
            }
            m_bInitialized = true;
         }
      }
      
      public static function isUsingGamepad() : Boolean
      {
         return true;
      }
      
      public static function createBindingHandler(param1:String, param2:Object, param3:Object = null) : void
      {
         if(createBindingHandlerImpl != null)
         {
            createBindingHandlerImpl(param1,param2,param3);
         }
      }
      
      public static function deleteBindingHandler(param1:String, param2:Object, param3:Object = null) : void
      {
         if(deleteBindingHandlerImpl != null)
         {
            deleteBindingHandlerImpl(param1,param2,param3);
         }
      }
      
      public static function getBoundValue(param1:String) : *
      {
         if(getBoundValueImpl != null)
         {
            return getBoundValueImpl(param1);
         }
         return undefined;
      }
      
      public static function getJournalQuestObjectives(param1:String, param2:Object) : void
      {
         if(getJournalQuestObjectivesImpl != null)
         {
            getJournalQuestObjectivesImpl(param1,param2);
         }
      }
      
      public static function clearBindings() : void
      {
         if(clearBindingsImpl != null)
         {
            clearBindingsImpl();
         }
      }
      
      public static function callEvent(param1:String, ... rest) : void
      {
         if(callEventImpl != null)
         {
            callEventImpl(param1,rest);
         }
      }
      
      public static function callEventEx(param1:String, param2:Array) : void
      {
         if(callEventImpl != null)
         {
            callEventImpl.apply(null,[param1].concat(param2));
         }
      }
      
      public static function getLocString(param1:String) : String
      {
         if(getLocStringImpl != null)
         {
            return getLocStringImpl(param1);
         }
         return null;
      }
      
      public static function playSound(param1:String) : void
      {
         if(playSoundImpl != null)
         {
            playSoundImpl(param1);
         }
      }
      
      public static function sendDisplayObject(param1:DisplayObject, param2:String = "") : void
      {
         var _loc3_:String = null;
         if(sendDisplayObjectImpl != null)
         {
            _loc3_ = getQualifiedClassName(param1);
            sendDisplayObjectImpl(param1,_loc3_,param2);
         }
      }
      
      public static function sendFunctionClosures(param1:Object) : void
      {
         if(sendFunctionClosuresImpl != null)
         {
            sendFunctionClosuresImpl(param1);
         }
      }
      
      public static function sendPopupResult(param1:int, param2:int = -1, param3:String = "") : void
      {
         if(sendPopupResultImpl != null)
         {
            sendPopupResultImpl(param1,param2,param3);
         }
      }
      
      public static function closeAllPanels() : void
      {
         if(_closeAllPanelsImpl != null)
         {
            _closeAllPanelsImpl();
         }
      }
      
      public static function isGameValueHandleValid(param1:uint) : Boolean
      {
         if(_isGameValueHandleValidImpl != null)
         {
            _isGameValueHandleValidImpl(param1);
         }
         return false;
      }
      
      public static function getGameValueHandleDebugString(param1:uint) : String
      {
         if(_getGameValueHandleDebugStringImpl != null)
         {
            return _getGameValueHandleDebugStringImpl(param1);
         }
         return "!!! [ GameInterface Uninitialized ] !!!";
      }
      
      public static function setHudInput(param1:Boolean) : void
      {
         if(_setHudInputImpl != null)
         {
            _setHudInputImpl(param1);
         }
      }
   }
}
