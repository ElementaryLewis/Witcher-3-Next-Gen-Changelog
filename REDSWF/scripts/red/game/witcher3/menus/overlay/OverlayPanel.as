package red.game.witcher3.menus.overlay
{
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import flash.display.Sprite;
   import flash.utils.getDefinitionByName;
   import red.core.CoreMenu;
   import red.core.events.GameEvent;
   import red.game.witcher3.menus.common_menu.ModuleInputFeedback;
   import scaleform.clik.events.InputEvent;
   import scaleform.gfx.Extensions;
   
   public class OverlayPanel extends CoreMenu
   {
       
      
      public var background:Sprite;
      
      protected var _feedbackMap:Array;
      
      protected var _popup:BasePopup;
      
      public function OverlayPanel()
      {
         upToCloseEnabled = false;
         _restrictDirectClosing = true;
         _disableShowAnimation = true;
         _enableInputValidation = true;
         _loadAssets = false;
         visible = false;
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"popup.data",[this.handlePopupData]));
         stage.addEventListener(InputEvent.INPUT,handleInput,false,0,true);
         this.background.x = Extensions.visibleRect.x;
         this.background.y = Extensions.visibleRect.y;
         this.background.width = Extensions.visibleRect.width;
         this.background.height = Extensions.visibleRect.height;
         if(Extensions.isScaleform)
         {
         }
         visible = true;
         this.alpha = 0;
         GTweener.to(this,0.5,{"alpha":1},{"ease":Exponential.easeOut});
      }
      
      protected function handlePopupData(param1:Object) : void
      {
         var popupContentRef:Class = null;
         var popupInstance:BasePopup = null;
         var inputModule:ModuleInputFeedback = null;
         var dataObject:Object = param1;
         if(!dataObject)
         {
            throw new Error("WARNING: Can\'t create a popup, data is NULL");
         }
         if(this._popup as QuantityMonsterBarganingPopup)
         {
            popupInstance = this._popup;
         }
         else
         {
            try
            {
               popupContentRef = getDefinitionByName(dataObject.ContentRef) as Class;
               popupInstance = new popupContentRef() as BasePopup;
               inputModule = popupInstance.mcInpuFeedback;
               if(inputModule)
               {
                  inputModule.filterKeyCodeFunction = isKeyCodeValid;
                  inputModule.filterNavCodeFunction = isNavEquivalentValid;
               }
            }
            catch(er:Error)
            {
               throw new Error("WARNING: Can\'t create definition " + dataObject.ContentRef + " in the OverlayMenu.fla : " + er.message);
            }
         }
         if(popupInstance)
         {
            popupInstance.data = dataObject;
            this._popup = popupInstance;
            addChild(popupInstance);
            popupInstance.validateNow();
         }
         if(dataObject.backgroundVisible != null)
         {
            this.background.visible = dataObject.backgroundVisible;
         }
         if(dataObject.ButtonsList)
         {
            this._feedbackMap = dataObject.ButtonsList;
         }
      }
      
      protected function checkInputMap(param1:String = "", param2:int = 0) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this._feedbackMap)
         {
            _loc3_ = int(this._feedbackMap.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if(this._feedbackMap[_loc4_].gamepad_navEquivalent == param1 || this._feedbackMap[_loc4_].keyboard_keyCode == param2)
               {
                  return true;
               }
               _loc4_++;
            }
         }
         return false;
      }
      
      override protected function get menuName() : String
      {
         return "PopupMenu";
      }
      
      private function startDebugMode() : void
      {
         var _loc1_:Object = {};
         _loc1_.ContentRef = "ItemInfoPopupRef";
         var _loc2_:Array = [];
         _loc2_.push({
            "label":"1",
            "title":"Some Title 1",
            "description":"Some Description 1"
         });
         _loc2_.push({
            "label":"1",
            "title":"Some Title 2",
            "description":"Some Description 2"
         });
         _loc2_.push({
            "label":"1",
            "title":"Some Title 3",
            "description":"Some Description 3"
         });
         _loc1_.tutorialList = _loc2_;
         this.handlePopupData(_loc1_);
      }
      
      public function setBarValue(param1:Number) : void
      {
         var _loc2_:QuantityMonsterBarganingPopup = this._popup as QuantityMonsterBarganingPopup;
         if(_loc2_)
         {
            _loc2_.setBarValue(param1);
         }
      }
   }
}
