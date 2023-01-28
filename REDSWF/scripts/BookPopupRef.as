package
{
   import red.game.witcher3.menus.overlay.BookPopup;
   
   public dynamic class BookPopupRef extends BookPopup
   {
       
      
      public function BookPopupRef()
      {
         super();
         this.__setProp_txtMessage_BookPopup_textField_0();
         this.__setProp_mcBooksList_BookPopup_list_0();
         this.__setProp_btnPrior_BookPopup_arrowscarousel_0();
         this.__setProp_btnNext_BookPopup_arrowscarousel_0();
      }
      
      internal function __setProp_txtMessage_BookPopup_textField_0() : *
      {
         try
         {
            txtMessage["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         txtMessage.actAsButton = false;
         txtMessage.defaultText = "There is missing text here!";
         txtMessage.displayAsPassword = false;
         txtMessage.editable = false;
         txtMessage.enabled = true;
         txtMessage.enableInitCallback = false;
         txtMessage.focusable = true;
         txtMessage.maxChars = 0;
         txtMessage.minThumbSize = 1;
         txtMessage.scrollBar = "scrollBar";
         txtMessage.scrollSpeed = 40;
         txtMessage.text = "";
         txtMessage.thumbOffset = {
            "top":0,
            "bottom":0
         };
         txtMessage.visible = true;
         try
         {
            txtMessage["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcBooksList_BookPopup_list_0() : *
      {
         try
         {
            mcBooksList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcBooksList.DownAction = 40;
         mcBooksList.enabled = true;
         mcBooksList.enableInitCallback = false;
         mcBooksList.focusable = true;
         mcBooksList.itemRendererName = "";
         mcBooksList.itemRendererInstanceName = "mcBookRenderer";
         mcBooksList.margin = 0;
         mcBooksList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         mcBooksList.PCDownAction = 83;
         mcBooksList.PCUpAction = 87;
         mcBooksList.rowHeight = 0;
         mcBooksList.scrollBar = "";
         mcBooksList.selectOnOver = false;
         mcBooksList.UpAction = 38;
         mcBooksList.visible = true;
         mcBooksList.wrapping = "normal";
         try
         {
            mcBooksList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_btnPrior_BookPopup_arrowscarousel_0() : *
      {
         try
         {
            btnPrior["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         btnPrior.autoRepeat = false;
         btnPrior.autoSize = "none";
         btnPrior.data = "";
         btnPrior.enabled = true;
         btnPrior.enableInitCallback = false;
         btnPrior.focusable = false;
         btnPrior.label = "";
         btnPrior.selected = false;
         btnPrior.showOnGamepad = true;
         btnPrior.showOnMouseKeyboard = true;
         btnPrior.toggle = false;
         btnPrior.visible = true;
         try
         {
            btnPrior["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_btnNext_BookPopup_arrowscarousel_0() : *
      {
         try
         {
            btnNext["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         btnNext.autoRepeat = false;
         btnNext.autoSize = "none";
         btnNext.data = "";
         btnNext.enabled = true;
         btnNext.enableInitCallback = false;
         btnNext.focusable = false;
         btnNext.label = "";
         btnNext.selected = false;
         btnNext.showOnGamepad = true;
         btnNext.showOnMouseKeyboard = true;
         btnNext.toggle = false;
         btnNext.visible = true;
         try
         {
            btnNext["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
