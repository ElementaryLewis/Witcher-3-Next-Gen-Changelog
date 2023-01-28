package red.game.witcher3.menus.blacksmith
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import red.game.witcher3.controls.RenderersList;
   import red.game.witcher3.slots.SlotPaperdoll;
   
   public class ItemSocketsInfo extends BlacksmithItemPanel
   {
       
      
      private const FILLED_RUNE_NAME:Number = 10326918;
      
      private const FILLED_SOCKET_COLOR:Number = 11963977;
      
      private const EMPTY_SOCKET_COLOR:Number = 10066329;
      
      private const MAX_SOCKETS_COUNT:int = 3;
      
      private const LABEL_ONE_SLOT:String = "one";
      
      private const LABEL_TWO_SLOT:String = "two";
      
      private const LABEL_THREE_SLOT:String = "three";
      
      public var txtValue1:TextField;
      
      public var txtValue2:TextField;
      
      public var txtValue3:TextField;
      
      public var connector1:MovieClip;
      
      public var connector2:MovieClip;
      
      public var connector3:MovieClip;
      
      public var mcSlot1:SlotPaperdoll;
      
      public var mcSlot2:SlotPaperdoll;
      
      public var mcSlot3:SlotPaperdoll;
      
      public var mcRunesList:RenderersList;
      
      public function ItemSocketsInfo()
      {
         super();
         this.cleanupSockets();
      }
      
      override public function cleanup() : void
      {
         super.cleanup();
         this.cleanupSockets();
      }
      
      override protected function cleanupView() : void
      {
         super.cleanupView();
      }
      
      override protected function updateData() : void
      {
         super.updateData();
         if(!_data.socketsCount)
         {
            return;
         }
         if(_data.actionPrice)
         {
            txtPriceLabel.visible = true;
            txtPriceValue.text = _data.actionPrice;
         }
         if(this.mcRunesList)
         {
            this.mcRunesList.dataList = _data.socketsData as Array;
         }
         this.cleanupSockets();
         switch(_data.socketsCount)
         {
            case 1:
               gotoAndStop(this.LABEL_ONE_SLOT);
               break;
            case 2:
               gotoAndStop(this.LABEL_TWO_SLOT);
               break;
            case 3:
               gotoAndStop(this.LABEL_THREE_SLOT);
         }
         addEventListener(Event.ENTER_FRAME,this.handleTimelineValidation,false,0,true);
      }
      
      private function handleTimelineValidation(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.handleTimelineValidation);
         this.cleanupSockets();
         this.populateSocketsData();
      }
      
      private function populateSocketsData() : void
      {
         var _loc3_:TextField = null;
         var _loc4_:TextField = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:SlotPaperdoll = null;
         var _loc10_:MovieClip = null;
         var _loc1_:Array = _data.socketsData;
         var _loc2_:int = !!_data.socketsCount ? int(_data.socketsCount) : 0;
         _loc2_ = Math.min(_loc2_,this.MAX_SOCKETS_COUNT);
         if(_loc1_)
         {
            _loc5_ = Math.min(_loc1_.length,this.MAX_SOCKETS_COUNT);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc8_ = _loc1_[_loc6_];
               _loc9_ = getChildByName("mcSlot" + (_loc6_ + 1)) as SlotPaperdoll;
               _loc10_ = getChildByName("connector" + (_loc6_ + 1)) as MovieClip;
               _loc3_ = getChildByName("txtLabel" + (_loc6_ + 1)) as TextField;
               _loc4_ = getChildByName("txtValue" + (_loc6_ + 1)) as TextField;
               if(_loc9_)
               {
                  _loc9_.data = _loc8_;
                  _loc9_.tfSlotName.text = "";
               }
               if(_loc10_)
               {
                  _loc10_.gotoAndPlay("filled");
               }
               if(_loc3_)
               {
                  _loc3_.visible = true;
                  _loc3_.textColor = this.FILLED_SOCKET_COLOR;
               }
               if(_loc4_)
               {
                  _loc4_.text = _loc8_.name;
                  _loc4_.textColor = this.FILLED_RUNE_NAME;
               }
               _loc6_++;
            }
            _loc7_ = _loc5_;
            while(_loc7_ < _loc2_)
            {
               _loc3_ = getChildByName("txtLabel" + (_loc7_ + 1)) as TextField;
               _loc4_ = getChildByName("txtValue" + (_loc7_ + 1)) as TextField;
               if(_loc3_)
               {
                  _loc3_.visible = true;
                  _loc3_.textColor = this.EMPTY_SOCKET_COLOR;
               }
               if(_loc4_)
               {
                  _loc4_.text = "[[panel_blacksmith_empty_socket]]";
                  _loc4_.textColor = this.EMPTY_SOCKET_COLOR;
               }
               _loc7_++;
            }
         }
      }
      
      private function cleanupSockets() : void
      {
         var _loc2_:SlotPaperdoll = null;
         var _loc3_:MovieClip = null;
         var _loc4_:TextField = null;
         var _loc5_:TextField = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.MAX_SOCKETS_COUNT)
         {
            _loc2_ = getChildByName("mcSlot" + (_loc1_ + 1)) as SlotPaperdoll;
            _loc3_ = getChildByName("connector" + (_loc1_ + 1)) as MovieClip;
            _loc4_ = getChildByName("txtLabel" + (_loc1_ + 1)) as TextField;
            _loc5_ = getChildByName("txtValue" + (_loc1_ + 1)) as TextField;
            if(_loc2_)
            {
               _loc2_.tfSlotName.text = "";
               _loc2_.cleanup();
               _loc2_.darkUnselectable = false;
               _loc2_.selectable = false;
               _loc2_.draggingEnabled = false;
            }
            if(_loc3_)
            {
               _loc3_.gotoAndPlay("empty");
            }
            if(_loc4_)
            {
               _loc4_.visible = false;
            }
            if(_loc5_)
            {
               _loc5_.text = "";
            }
            _loc1_++;
         }
      }
   }
}
