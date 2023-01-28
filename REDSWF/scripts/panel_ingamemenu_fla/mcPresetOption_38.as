package panel_ingamemenu_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class mcPresetOption_38 extends MovieClip
   {
       
      
      public var mcPresetScrollbar:DefaultScrollBar;
      
      public var mcScrollingList:W3ScrollingListNoBG;
      
      public var mcScrollingListItem1:MenuListItemCommonSmall;
      
      public var mcScrollingListItem2:MenuListItemCommonSmall;
      
      public var mcScrollingListItem3:MenuListItemCommonSmall;
      
      public var mcScrollingListItem4:MenuListItemCommonSmall;
      
      public var mcScrollingListItem5:MenuListItemCommonSmall;
      
      public var mcScrollingListItem6:MenuListItemCommonSmall;
      
      public var txtPresetTitle:TextField;
      
      public function mcPresetOption_38()
      {
         super();
         this.__setProp_mcScrollingList_mcPresetOption_mcScrollingList_0();
      }
      
      internal function __setProp_mcScrollingList_mcPresetOption_mcScrollingList_0() : *
      {
         try
         {
            this.mcScrollingList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcScrollingList.DownAction = 39;
         this.mcScrollingList.enabled = true;
         this.mcScrollingList.enableInitCallback = false;
         this.mcScrollingList.focusable = true;
         this.mcScrollingList.itemRendererName = "";
         this.mcScrollingList.itemRendererInstanceName = "mcScrollingListItem";
         this.mcScrollingList.margin = 0;
         this.mcScrollingList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         this.mcScrollingList.rowHeight = 0;
         this.mcScrollingList.scrollBar = "mcPresetScrollbar";
         this.mcScrollingList.UpAction = 37;
         this.mcScrollingList.visible = true;
         this.mcScrollingList.wrapping = "wrap";
         try
         {
            this.mcScrollingList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
