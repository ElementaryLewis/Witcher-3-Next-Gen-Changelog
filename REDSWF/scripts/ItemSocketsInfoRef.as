package
{
   import flash.events.Event;
   import flash.utils.Dictionary;
   import red.game.witcher3.menus.blacksmith.ItemSocketsInfo;
   
   public dynamic class ItemSocketsInfoRef extends ItemSocketsInfo
   {
       
      
      public var __setPropDict:Dictionary;
      
      public var __lastFrameProp:int = -1;
      
      public function ItemSocketsInfoRef()
      {
         this.__setPropDict = new Dictionary(true);
         super();
         addFrameScript(8,this.frame9,18,this.frame19,29,this.frame30);
         addEventListener(Event.FRAME_CONSTRUCTED,this.__setProp_handler,false,0,true);
      }
      
      internal function __setProp_mcSlot1_ItemSocketsInfo_slots_0(param1:int) : *
      {
         if(mcSlot1 != null && param1 >= 1 && param1 <= 19 && (this.__setPropDict[mcSlot1] == undefined || !(int(this.__setPropDict[mcSlot1]) >= 1 && int(this.__setPropDict[mcSlot1]) <= 19)))
         {
            this.__setPropDict[mcSlot1] = param1;
            try
            {
               mcSlot1["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            }
            mcSlot1.enabled = true;
            mcSlot1.enableInitCallback = false;
            mcSlot1.equipID = 8;
            mcSlot1.gridSize = 1;
            mcSlot1.navigationDown = -1;
            mcSlot1.navigationLeft = 5;
            mcSlot1.navigationRight = 13;
            mcSlot1.navigationUp = 6;
            mcSlot1.slotTag = "";
            mcSlot1.slotTypeID = 0;
            mcSlot1.visible = true;
            try
            {
               mcSlot1["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            }
         }
      }
      
      internal function __setProp_mcSlot1_ItemSocketsInfo_slots_19(param1:int) : *
      {
         if(mcSlot1 != null && param1 >= 20 && param1 <= 30 && (this.__setPropDict[mcSlot1] == undefined || !(int(this.__setPropDict[mcSlot1]) >= 20 && int(this.__setPropDict[mcSlot1]) <= 30)))
         {
            this.__setPropDict[mcSlot1] = param1;
            try
            {
               mcSlot1["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            }
            mcSlot1.enabled = true;
            mcSlot1.enableInitCallback = false;
            mcSlot1.equipID = 8;
            mcSlot1.gridSize = 1;
            mcSlot1.navigationDown = -1;
            mcSlot1.navigationLeft = 5;
            mcSlot1.navigationRight = 13;
            mcSlot1.navigationUp = 6;
            mcSlot1.slotTag = "petard2";
            mcSlot1.slotTypeID = 0;
            mcSlot1.visible = true;
            try
            {
               mcSlot1["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            }
         }
      }
      
      internal function __setProp_mcSlot2_ItemSocketsInfo_slots_0(param1:int) : *
      {
         if(mcSlot2 != null && param1 >= 1 && param1 <= 19 && (this.__setPropDict[mcSlot2] == undefined || !(int(this.__setPropDict[mcSlot2]) >= 1 && int(this.__setPropDict[mcSlot2]) <= 19)))
         {
            this.__setPropDict[mcSlot2] = param1;
            try
            {
               mcSlot2["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            }
            mcSlot2.enabled = true;
            mcSlot2.enableInitCallback = false;
            mcSlot2.equipID = 8;
            mcSlot2.gridSize = 1;
            mcSlot2.navigationDown = -1;
            mcSlot2.navigationLeft = 5;
            mcSlot2.navigationRight = 13;
            mcSlot2.navigationUp = 6;
            mcSlot2.slotTag = "";
            mcSlot2.slotTypeID = 0;
            mcSlot2.visible = true;
            try
            {
               mcSlot2["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            }
         }
      }
      
      internal function __setProp_mcSlot3_ItemSocketsInfo_slots_0(param1:int) : *
      {
         if(mcSlot3 != null && param1 >= 1 && param1 <= 9 && (this.__setPropDict[mcSlot3] == undefined || !(int(this.__setPropDict[mcSlot3]) >= 1 && int(this.__setPropDict[mcSlot3]) <= 9)))
         {
            this.__setPropDict[mcSlot3] = param1;
            try
            {
               mcSlot3["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            }
            mcSlot3.enabled = true;
            mcSlot3.enableInitCallback = false;
            mcSlot3.equipID = 8;
            mcSlot3.gridSize = 1;
            mcSlot3.navigationDown = -1;
            mcSlot3.navigationLeft = 5;
            mcSlot3.navigationRight = 13;
            mcSlot3.navigationUp = 6;
            mcSlot3.slotTag = "";
            mcSlot3.slotTypeID = 0;
            mcSlot3.visible = true;
            try
            {
               mcSlot3["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            }
         }
      }
      
      internal function __setProp_handler(param1:Object) : *
      {
         var _loc2_:int = currentFrame;
         if(this.__lastFrameProp == _loc2_)
         {
            return;
         }
         this.__lastFrameProp = _loc2_;
         this.__setProp_mcSlot1_ItemSocketsInfo_slots_0(_loc2_);
         this.__setProp_mcSlot1_ItemSocketsInfo_slots_19(_loc2_);
         this.__setProp_mcSlot2_ItemSocketsInfo_slots_0(_loc2_);
         this.__setProp_mcSlot3_ItemSocketsInfo_slots_0(_loc2_);
      }
      
      internal function frame9() : *
      {
         stop();
      }
      
      internal function frame19() : *
      {
         stop();
      }
      
      internal function frame30() : *
      {
         stop();
      }
   }
}
