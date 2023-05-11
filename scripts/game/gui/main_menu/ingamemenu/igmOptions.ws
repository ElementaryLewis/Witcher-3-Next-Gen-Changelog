/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/




enum IgmOptionsAmbientOcclusion
{
	IGMOPT_AO_SSAO = 1,
	IGMOPT_AO_RTAO = 2,
	IGMOPT_AO_NRDRTAO = 3
};

enum IgmOptionsAntiAliasing
{
	IGMOPT_AA_XESS = 4,	
	IGMOPT_AA_DLSS = 5
};

function IngameMenu_GetOptionTypeFromString(optionType:string): InGameMenuActionType
{
	if (optionType == "TOGGLE")
	{
		return IGMActionType_Toggle;
	}
	else if (optionType == "SLIDER")
	{
		return IGMActionType_Slider;
	}
	else if (optionType == "OPTIONS")
	{
		return IGMActionType_List;
	}
	else if (optionType == "OPTIONSWITHCOND")
	{
		return IGMActionType_ListWithCondition;
	}
	else if (optionType == "GAMMA")
	{
		return IGMActionType_Gamma;
	}
	else if (optionType == "BUTTON")
	{
		return IGMActionType_Button;
	}
	else if (optionType == "STEPPER")
	{
		return IGMActionType_Stepper;
	}
	else if (optionType == "TOGGLESTEPPER")
	{
		return IGMActionType_ToggleStepper;
	}
	else if (optionType == "SEPARATOR")
	{
		return IGMActionType_Separator;
	}
	else if (optionType == "SUBTLE_SEPARATOR")
	{
		return IGMActionType_SubtleSeparator;
	}
	
	return IGMActionType_Toggle; 
}

function IngameMenu_FillOptionsSubMenuData(flashStorageUtility : CScriptedFlashValueStorage, isMainMenu : bool) : CScriptedFlashArray
{
	var l_optionChildList		: CScriptedFlashArray;
	var i 						: int;
	var numOptionsGroups		: int;
	var l_ChildMenuFlashArray	: CScriptedFlashArray;
	var l_DataFlashObject 		: CScriptedFlashObject;
	var groupRootObject			: CScriptedFlashObject;
	var groupOptionArray		: CScriptedFlashArray;
	var groupParentArray		: CScriptedFlashArray;
	var groupName				: name;
	var videoDisplayName		: string;
	var dlcGroupID				: int = -1;
	var inGameConfigWrapper 	: CInGameConfigWrapper;
	var isPlatformWithoutRt     : bool = false;
	var dlcOptionIndex			: array<int>;
	var hasChildOptions			: bool;

	inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
	isPlatformWithoutRt = (theGame.GetPlatform() == Platform_Xbox_SCARLETT_LOCKHART) 
						|| (theGame.GetPlatform() == Platform_Xbox1) 
						|| (theGame.GetPlatform() == Platform_PS4);
	l_optionChildList = flashStorageUtility.CreateTempFlashArray();
	
	
	
	IngameMenu_FetchAndGenerateGroupMenuObject(flashStorageUtility, "panel_", "audio", l_optionChildList, groupParentArray);
	IngameMenu_FetchAndGenerateGroupMenuObject(flashStorageUtility, "panel_", "option_controllerhelp", l_optionChildList, groupParentArray);
		
	
	{
		l_DataFlashObject = flashStorageUtility.CreateTempFlashObject();
		l_DataFlashObject.SetMemberFlashString( "id", "option_control_scheme");
		l_DataFlashObject.SetMemberFlashUInt(  "tag", NameToFlashUInt('controllerhelp') );
		
		if(theGame.GetPlatform() == Platform_PS5)
			l_DataFlashObject.SetMemberFlashString(  "label", GetLocStringByKeyExt("panel_mainmenu_controls_options_gamepad_description_ps5") );	
		else
			l_DataFlashObject.SetMemberFlashString(  "label", GetLocStringByKeyExt("menu_option_control_scheme") );	
		
		l_DataFlashObject.SetMemberFlashUInt( "type", IGMActionType_ControllerHelp );	
		
		l_ChildMenuFlashArray = flashStorageUtility.CreateTempFlashArray();
		l_DataFlashObject.SetMemberFlashArray( "subElements", l_ChildMenuFlashArray );
		
		l_optionChildList.PushBackFlashObject(l_DataFlashObject);
	}
	
	
	if (theGame.GetPlatform() == Platform_PC)
	{
		l_DataFlashObject = flashStorageUtility.CreateTempFlashObject();
		l_DataFlashObject.SetMemberFlashString( "id", "option_keybinds");
		l_DataFlashObject.SetMemberFlashUInt(  "tag", NameToFlashUInt('controllerhelp') );
		l_DataFlashObject.SetMemberFlashString(  "label", inGameMenu_TryLocalize("menu_option_keybinds") );	
		
		l_DataFlashObject.SetMemberFlashUInt( "type", IGMActionType_KeyBinds );	
		
		l_ChildMenuFlashArray = flashStorageUtility.CreateTempFlashArray();
		l_DataFlashObject.SetMemberFlashArray( "subElements", l_ChildMenuFlashArray );
		
		l_optionChildList.PushBackFlashObject(l_DataFlashObject);
	}
	
	IngameMenu_FetchAndGenerateGroupMenuObject(flashStorageUtility, "panel_", "gameplay", l_optionChildList, groupParentArray);
	if (theGame.GetPlatform() == Platform_PC)
	{
		videoDisplayName = "video";
	}
	else
	{
		videoDisplayName = "visuals";
	}
	IngameMenu_FetchAndGenerateGroupMenuObject(flashStorageUtility, "panel_", videoDisplayName + ".hudelements", l_optionChildList, groupParentArray);
	
	
	if (GetObjectFromArrayWithLabel(l_optionChildList, "id", videoDisplayName, groupRootObject))
	{
		groupOptionArray = groupRootObject.GetMemberFlashArray("subElements");
		
		l_DataFlashObject = flashStorageUtility.CreateTempFlashObject();
		l_DataFlashObject.SetMemberFlashString( "id", "uirescale");
		l_DataFlashObject.SetMemberFlashUInt(  "tag", NameToFlashUInt('UI_Rescale') );
		l_DataFlashObject.SetMemberFlashString(  "label", GetLocStringByKeyExt("panel_mainmenu_rescale") );	
		
		l_DataFlashObject.SetMemberFlashUInt( "type", IGMActionType_UIRescale );	
		
		l_ChildMenuFlashArray = flashStorageUtility.CreateTempFlashArray();
		l_DataFlashObject.SetMemberFlashArray( "subElements", l_ChildMenuFlashArray );
		
		groupOptionArray.PushBackFlashObject(l_DataFlashObject);
	}
	
	IngameMenu_FetchAndGenerateGroupMenuObject(flashStorageUtility, "panel_", videoDisplayName + ".postprocess", l_optionChildList, groupParentArray);
		
	if (theGame.GetPlatform() == Platform_PC)
	{
		IngameMenu_FetchAndGenerateGroupMenuObject(flashStorageUtility, "panel_", "video.general", l_optionChildList, groupParentArray);
	}
	
	if (isMainMenu)
	{
		IngameMenu_FetchAndGenerateGroupMenuObject(flashStorageUtility, "panel_", "localization", l_optionChildList, groupParentArray);
	}
	
	
	
	
	numOptionsGroups = inGameConfigWrapper.GetGroupsNum();
	
	for (i = 0; i < numOptionsGroups; i += 1)
	{
		groupName = inGameConfigWrapper.GetGroupName(i);
		
		if (groupName == 'DLC') 
		{
			dlcGroupID = i;
		}
		else if(groupName != 'DLCOptions')
		{
			IngameMenu_FillArrayFromConfigGroup(flashStorageUtility, i, l_optionChildList, isMainMenu);
		}
	}
	
	
	if (isMainMenu)
	{
		
		if ( theGame.GetDLCManager().IsAnyDLCAvailable() )
		{
			
			l_DataFlashObject = flashStorageUtility.CreateTempFlashObject();
			l_DataFlashObject.SetMemberFlashString( "id", "installed_dlc" );
			l_DataFlashObject.SetMemberFlashUInt( "tag", NameToFlashUInt( 'InstalledDLC' ) );
			l_DataFlashObject.SetMemberFlashUInt( "type", IGMActionType_InstalledDLC );
			l_DataFlashObject.SetMemberFlashString( "label", GetLocStringByKeyExt( "panel_mainmenu_installed_dlc" ) );
			l_optionChildList.PushBackFlashObject( l_DataFlashObject );

			
			hasChildOptions = false;
			inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();

			for ( i = 0; i < inGameConfigWrapper.GetGroupsNum(); i += 1 )
			{
				groupName = inGameConfigWrapper.GetGroupName( i );
				if (groupName == 'DLC' || groupName == 'DLCOptions')
				{			
					dlcOptionIndex.PushBack( i );
				}
			}
			
			if ( dlcOptionIndex.Size() > 0 && GetObjectFromArrayWithLabel( l_optionChildList, "id", "gameplay", l_DataFlashObject ) )
			{
				for ( i = 0; i < dlcOptionIndex.Size(); i += 1 )
				{
					groupName = inGameConfigWrapper.GetGroupName( dlcOptionIndex[i] );
					hasChildOptions = IngameMenu_FillSubMenuOptionsList( flashStorageUtility, dlcOptionIndex[i], groupName, l_DataFlashObject );
				}
			}
		}
		

		
		l_DataFlashObject = flashStorageUtility.CreateTempFlashObject();
		l_DataFlashObject.SetMemberFlashString( "id", "credits");
		l_DataFlashObject.SetMemberFlashUInt(  "tag", CreditsIndex_Wither3 );
		l_DataFlashObject.SetMemberFlashString(  "label", GetLocStringByKeyExt("panel_mainmenu_extras_credits") );	
		
		l_DataFlashObject.SetMemberFlashString( "listTitle", GetLocStringByKeyExt("panel_mainmenu_extras_credits") );
		l_ChildMenuFlashArray = flashStorageUtility.CreateTempFlashArray();

		l_DataFlashObject.SetMemberFlashUInt( "type", IGMActionType_MenuHolder );
		IngameMenu_FillCreditsSubGroup(flashStorageUtility, l_ChildMenuFlashArray);
		
		l_DataFlashObject.SetMemberFlashArray( "subElements", l_ChildMenuFlashArray );
		
		l_optionChildList.PushBackFlashObject(l_DataFlashObject);
		
	}
	else
	{
		
		if (GetObjectFromArrayWithLabel(l_optionChildList, "id", "gameplay", groupRootObject))
		{
			groupOptionArray = groupRootObject.GetMemberFlashArray("subElements");
			IngameMenu_AddDifficultyOption(flashStorageUtility, groupOptionArray);
			IngameMenu_AddGwentDifficultyOption(flashStorageUtility, groupOptionArray);
		}
		
	}
	
	
	
	
	
	
	
	return l_optionChildList;
}

function IngameMenu_FillCreditsSubGroup(flashStorageUtility : CScriptedFlashValueStorage, rootFlashArray:CScriptedFlashArray):void
{
	var l_ChildMenuFlashArray	: CScriptedFlashArray;
	var l_DataFlashObject 		: CScriptedFlashObject;
	
	
	l_DataFlashObject = flashStorageUtility.CreateTempFlashObject();
	l_DataFlashObject.SetMemberFlashString( "id", "credits_witcher");
	l_DataFlashObject.SetMemberFlashUInt(  "tag", CreditsIndex_Wither3 );
	l_DataFlashObject.SetMemberFlashString(  "label", GetLocStringByKeyExt("TW3") );	
	
	l_DataFlashObject.SetMemberFlashUInt( "type", IGMActionType_Credits );	
	
	l_ChildMenuFlashArray = flashStorageUtility.CreateTempFlashArray();
	l_DataFlashObject.SetMemberFlashArray( "subElements", l_ChildMenuFlashArray );
	
	rootFlashArray.PushBackFlashObject(l_DataFlashObject);
	
	
	if (theGame.GetDLCManager().IsEP1Available())
	{
		
		l_DataFlashObject = flashStorageUtility.CreateTempFlashObject();
		l_DataFlashObject.SetMemberFlashString( "id", "credits_heart_of_stone");
		l_DataFlashObject.SetMemberFlashUInt(  "tag", CreditsIndex_Ep1 );
		l_DataFlashObject.SetMemberFlashString(  "label", GetLocStringByKeyExt("dlc_hearts_of_stone") );	
		
		l_DataFlashObject.SetMemberFlashUInt( "type", IGMActionType_Credits );	
		
		l_ChildMenuFlashArray = flashStorageUtility.CreateTempFlashArray();
		l_DataFlashObject.SetMemberFlashArray( "subElements", l_ChildMenuFlashArray );
		
		rootFlashArray.PushBackFlashObject(l_DataFlashObject);
		
	}
	
	if ( theGame.GetDLCManager().IsEP2Available() )
	{
		
		l_DataFlashObject = flashStorageUtility.CreateTempFlashObject();
		l_DataFlashObject.SetMemberFlashString( "id", "credits_blood_and_wine");
		l_DataFlashObject.SetMemberFlashUInt(  "tag", CreditsIndex_Ep2 );
		l_DataFlashObject.SetMemberFlashString(  "label", GetLocStringByKeyExt("dlc_blood_and_wine") );	
		
		l_DataFlashObject.SetMemberFlashUInt( "type", IGMActionType_Credits );	
		
		l_ChildMenuFlashArray = flashStorageUtility.CreateTempFlashArray();
		l_DataFlashObject.SetMemberFlashArray( "subElements", l_ChildMenuFlashArray );
		
		rootFlashArray.PushBackFlashObject(l_DataFlashObject);
		
	}
	
		
	l_DataFlashObject = flashStorageUtility.CreateTempFlashObject();
	l_DataFlashObject.SetMemberFlashString( "id", "credits_witcher_ng" );
	l_DataFlashObject.SetMemberFlashUInt(  "tag", CreditsIndex_Witcher3_NG );
	l_DataFlashObject.SetMemberFlashString(  "label", GetLocStringByKeyExt("nge_credits_title") );	
	l_DataFlashObject.SetMemberFlashUInt( "type", IGMActionType_Credits );	
		
	l_ChildMenuFlashArray = flashStorageUtility.CreateTempFlashArray();
	l_DataFlashObject.SetMemberFlashArray( "subElements", l_ChildMenuFlashArray );
		
	rootFlashArray.PushBackFlashObject(l_DataFlashObject);
	
}

function IngameMenu_FillArrayFromConfigGroup(flashStorageUtility : CScriptedFlashValueStorage, groupID:int, rootFlashArray:CScriptedFlashArray, isMainMenu : bool ):void
{
	var groupRootObject			: CScriptedFlashObject;
	var groupName				: name;
	var hasChildOptions			: bool;
	var groupParentArray		: CScriptedFlashArray;
	var inGameConfigWrapper	: CInGameConfigWrapper;
	
	var i						: int;
	var hasChildOptionsDLC		: bool;
	var dlcOptionIndex			: int;
	
	dlcOptionIndex = -1;
	
	inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
	
	groupName = inGameConfigWrapper.GetGroupName(groupID);
	
	if (groupName != 'Hidden' && inGameConfigWrapper.IsGroupVisible(groupName) && !inGameConfigWrapper.DoGroupHasTag(groupName, 'keybinds'))
	{
		groupRootObject = IngameMenu_FetchAndGenerateGroupMenuObject(flashStorageUtility, "panel_", inGameConfigWrapper.GetGroupDisplayName(groupName), rootFlashArray, groupParentArray);
		
		if (groupRootObject)
		{
			hasChildOptions = IngameMenu_FillSubMenuOptionsList(flashStorageUtility, groupID, groupName, groupRootObject);
			
		
			
			
			if (! ( hasChildOptions || hasChildOptionsDLC ) && groupParentArray)
			{
				groupParentArray.PopBack();
			}
		}
	}
}

function IngameMenu_FetchAndGenerateGroupMenuObject(flashStorageUtility : CScriptedFlashValueStorage, displayNamePrefix:string, groupDisplayName:string, rootFlashArray:CScriptedFlashArray, out optionParentArray:CScriptedFlashArray):CScriptedFlashObject
{
	var displayNameArray 	: string;
	var newChildArray 		: CScriptedFlashArray;
	var tokenedDisplayNames	: array<string>;
	var deconstructedString : string;
	var currentSubMenuName	: string;
	var tmp					: string;
	var currentArray		: CScriptedFlashArray;
	var currentObject		: CScriptedFlashObject;
	var inGameConfigWrapper	: CInGameConfigWrapper;
	
	inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
	
	deconstructedString = groupDisplayName;
	currentArray = rootFlashArray;
	
	if ( GetVarsNumForGroupDisplayName( groupDisplayName ) == 0 )
		return currentObject;	
	
	while (deconstructedString != "")
	{
		currentSubMenuName = "";
		
		StrSplitFirst(deconstructedString, ".", currentSubMenuName, tmp);
		
		if (currentSubMenuName == "" && deconstructedString != "")
		{
			currentSubMenuName = deconstructedString;
		}
		
		deconstructedString = tmp;
		tmp = "";
		
		while (StrBeginsWith(deconstructedString, "."))
		{
			StrReplace(deconstructedString, ".", "");
		}
		
		if (GetObjectFromArrayWithLabel(currentArray, "id", currentSubMenuName, currentObject))
		{
			currentArray = currentObject.GetMemberFlashArray("subElements");
		}
		else
		{
			currentObject = flashStorageUtility.CreateTempFlashObject();
			currentObject.SetMemberFlashString( "id", currentSubMenuName);
			currentObject.SetMemberFlashString(  "label", GetLocStringByKeyExt(displayNamePrefix + currentSubMenuName) );
			currentObject.SetMemberFlashUInt(  "tag", NameToFlashUInt( 'MenuSelector') );
			
			
			if (deconstructedString == "")
			{	
				currentObject.SetMemberFlashUInt( "type", IGMActionType_MenuLastHolder );	
			}
			else
			{
				currentObject.SetMemberFlashUInt( "type", IGMActionType_MenuHolder );	
			}
			
			currentObject.SetMemberFlashString( "listTitle", GetLocStringByKeyExt(displayNamePrefix + currentSubMenuName) );
			
			newChildArray = flashStorageUtility.CreateTempFlashArray();
			currentObject.SetMemberFlashArray( "subElements", newChildArray );
			
			optionParentArray = currentArray;
			currentArray.PushBackFlashObject(currentObject);
			
			currentArray = newChildArray;
		}
	}
	
	return currentObject;
}

function IngameMenu_IsOptionalEntryActive( optionName : name ):bool
{
	var masterOptionValue	: string;

	var inGameConfigWrapper	: CInGameConfigWrapper;
	inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
	
	
	
	
	
	
	
	
	return false;
}


function SetOptionSkipsAndLocks(flashObject : CScriptedFlashObject, optionName : name, applySSAOLocks:bool) : void
{
	var skip : string = "-1";
	var lock : string = "-1";
	var inGameConfigWrapper	: CInGameConfigWrapper;

	if (applySSAOLocks && optionName == 'Virtual_SSAOSolution')
	{
		inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
		
		if(inGameConfigWrapper.GetVarValueByStr( "Rendering/RT" , 'EnableRT' ) == "true")
		{
			skip = IntToString(IGMOPT_AO_SSAO);
		}
		
		else if(inGameConfigWrapper.GetVarValueByStr( "Rendering/RT" , 'EnableRT' ) == "false")
		{
			lock = IntToString(IGMOPT_AO_RTAO);
		}
	}
	
	else if(optionName == 'AAMode' && !theGame.GetIsDLSSSupported() )
	{
		lock = IntToString(IGMOPT_AA_DLSS);
		if(!theGame.GetIsXESSSupported())
		{
			
			lock = IntToString(IGMOPT_AA_XESS);
		}
	}
	
	flashObject.SetMemberFlashString( "skip", skip );
	flashObject.SetMemberFlashString( "lock", lock );
}

function IngameMenu_FetchDropdownOptions( 
	flashStorageUtility : CScriptedFlashValueStorage, 
	groupID : int, 
	groupName : name, 
	varName : name, 
	currentOptionId : int,
	optionArray : CScriptedFlashArray )
{
	var inGameConfigWrapper	: CInGameConfigWrapper;
	var numOptions			: int;
	var numOptionValues		: int;
	var optionName			: name;
	var optionDisplayName	: string;
	var optionDisplayType	: string;
	var optionValue			: string;
	var optionVarValue		: string;
	var currentOptionType	: int;
	var numValidOptions		: int;
	var noLocalization 		: bool;
	var customNames			: bool;
	var customDisplayName	: bool;
	var optionObject		: CScriptedFlashObject;
	var optionFlashArray 	: CScriptedFlashArray;
	var i					: int;
	var option_it 			: int;
	var masterTag			: int;
	var previousOptionName 	: name;
	
	inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
	numOptions = inGameConfigWrapper.GetEntriesNumForOption( groupName, varName, currentOptionId );
	previousOptionName = '';
	
	for (i = 0; i < numOptions; i += 1)
	{
		optionName = inGameConfigWrapper.GetEntryNameForOption( groupName, varName, currentOptionId, i );
		numOptionValues = inGameConfigWrapper.GetVarOptionsNum(groupName, optionName);
		optionDisplayType = inGameConfigWrapper.GetVarDisplayType(groupName, optionName);
		noLocalization = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'nonLocalized');
		customNames = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'customNames');
		customDisplayName = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'customDisplayName');
		
		if ( inGameConfigWrapper.IsVarVisible(groupName, optionName) && 
			(optionDisplayType != "OPTIONS" || numOptionValues > 1) &&
			(optionDisplayType != "STEPPER" || numOptionValues > 1) )
		{
			optionDisplayName = inGameConfigWrapper.GetVarDisplayName(groupName, optionName);
			
			optionValue = inGameConfigWrapper.GetVarValue(groupName, optionName);
			
			optionObject = flashStorageUtility.CreateTempFlashObject();
			optionObject.SetMemberFlashString( "id", "" + i );
			
			if (customDisplayName)
			{
				optionObject.SetMemberFlashString( "label", inGameMenu_TryLocalize(optionDisplayName) );
			}
			else
			{
				optionObject.SetMemberFlashString( "label", inGameMenu_TryLocalize("option_" + optionDisplayName) );
			}
						
			optionObject.SetMemberFlashUInt( "type", IngameMenu_GetOptionTypeFromString(optionDisplayType) );
			optionObject.SetMemberFlashUInt( "tag", NameToFlashUInt(optionName) );
			optionObject.SetMemberFlashString( "current", optionValue);
			optionObject.SetMemberFlashString( "startingValue", optionValue);
			optionObject.SetMemberFlashInt( "groupID", groupID );
			optionObject.SetMemberFlashBool( "checkHardwareCursor", optionName == 'UIMouseSensitivity' || optionName == 'MouseSensitivity' );
			optionObject.SetMemberFlashBool( "streamable", false );	
			optionObject.SetMemberFlashBool( "isDropdownContent", true );
			optionObject.SetMemberFlashBool( "isDeveloper", inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'developer') );
			
			SetOptionSkipsAndLocks(optionObject, optionName, false);
						
			optionFlashArray = flashStorageUtility.CreateTempFlashArray();
			for (option_it = 0; option_it < numOptionValues; option_it += 1)
			{
				optionVarValue = inGameConfigWrapper.GetVarOption(groupName, optionName, option_it);

				if (IngameMenu_GetOptionTypeFromString(optionDisplayType) == IGMActionType_List 
					|| IngameMenu_GetOptionTypeFromString(optionDisplayType) == IGMActionType_ListWithCondition
					|| IngameMenu_GetOptionTypeFromString(optionDisplayType) == IGMActionType_Stepper )
				{
					if(!customNames)
					{
						optionVarValue = "preset_value_" + optionVarValue;
					}
					
					if(!noLocalization)
					{
						optionVarValue = inGameMenu_TryLocalize(optionVarValue);
					}
				}
				
				optionFlashArray.PushBackFlashString( optionVarValue );
			}
			
			optionObject.SetMemberFlashArray( "subElements", optionFlashArray );
			
			if( optionDisplayType == "TOGGLE" && numOptionValues == 2 )
			{
				optionVarValue = inGameConfigWrapper.GetVarOption(groupName, optionName, 0);
				optionObject.SetMemberFlashString( "offString", inGameMenu_TryLocalize(optionVarValue) );
				
				optionVarValue = inGameConfigWrapper.GetVarOption(groupName, optionName, 1);
				optionObject.SetMemberFlashString( "onString", inGameMenu_TryLocalize(optionVarValue) );
			}
			
			if( optionDisplayType == "STEPPER" || optionDisplayType == "TOGGLESTEPPER" )
			{
				optionObject.SetMemberFlashBool( "hideIndicator", inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'hideIndicator') );
			}
			
			if( inGameConfigWrapper.DoVarHasTag( groupName, optionName, 'developer' ) )
			{
				if( previousOptionName == '' )
				{
					masterTag = NameToFlashUInt( varName );
				}
				else
				{
					masterTag = NameToFlashUInt( previousOptionName );
				}
				
				optionObject.SetMemberFlashUInt( "masterTag", masterTag );
				theGame.GetGuiManager().GetIngameMenu().GetDeveloperOptionsContainer().PushBackFlashObject( optionObject );
			}
			else
			{
				optionArray.PushBackFlashObject(optionObject);
			}
			
			previousOptionName = optionName;
		}
	}
}

function IngameMenu_FillSubMenuOptionsList(flashStorageUtility : CScriptedFlashValueStorage, groupID:int, groupName:name, groupRootObject : CScriptedFlashObject):bool
{
	var groupDisplayName	: string;
	var groupOptionArray	: CScriptedFlashArray;
	var optionObject		: CScriptedFlashObject;
	var optionFlashArray 	: CScriptedFlashArray;
	var optionValueObject	: CScriptedFlashObject;
	var presetNum			: int;
	var numOptions			: int;
	var i					: int;
	var option_it			: int;
	var numOptionValues		: int;
	var optionName			: name;
	var optionDisplayName	: string;
	var optionDisplayType	: string;
	var optionValue			: string;
	var startingValue		: string;
	var optionVarValue		: string;
	var currentOptionType	: int;
	var numValidOptions		: int;
	var noLocalization 		: bool;
	var nonLocalizedExceptFirst : bool;
	var customNames			: bool;
	var customDisplayName	: bool;
	var previousOptionName 	: name;
	
	var streamable			  : bool;
	var streamableStatusArray : CScriptedFlashArray;
	var streamableStatus      : CScriptedFlashObject;
	
	var optionalEntry		  : bool;

	
	var isIntelGPU		  	  : bool;
	var isRTEnabled  		  : bool;
	var isRTSupported  		  : bool;
	var isHairWorksEnabled	  : bool;
	var isFSREnabled		  : bool;
	var isDLSSEnabled		  : bool;
	var isXESSEnabled		  : bool;
	var isRTAOEnabled		  : bool;
	var isRTREnabled 		  : bool;
	var isDLSSGEnabled	  	  : bool;
	var isDLSSGSupported	  : bool;
	var isReflexSupported	  : bool;
	var isMotionBlurEnabled   : bool;

	var enableIfRT		  	: bool;
	var enableIfRTSupported	: bool;
	var enableIfHairWorks	: bool;
	var enableIfFSR		  	: bool;
	var disableIfFSR		: bool;
	var enableIfXESS		: bool;
	var disableIfXESS		: bool;
	var enableIfDLSS		: bool;
	var disableIfDLSS		: bool;
	var disableIfRTAO		: bool;
	var disableIfRTR		: bool;
	var enableIfDLSSGSupported	: bool;
	var enableIfReflexSupported	: bool;
	var disableIfDLSSG			: bool;
	var disableIfDLSSGAndSet1	: bool;
	var disableIfIntelGPU    	: bool;
	var enableIfMotionBlur		: bool;
	
	var inGameConfigWrapper	: CInGameConfigWrapper;
	
	inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
	
	numValidOptions = 0;
	
	groupOptionArray = groupRootObject.GetMemberFlashArray("subElements");
	
	groupDisplayName = StrReplaceAll(inGameConfigWrapper.GetGroupDisplayName(groupName), ".", "_");

	isIntelGPU = theGame.IsIntelGPU();
	isRTEnabled = theGame.GetRTEnabled();
	isRTSupported = theGame.GetRTSupported();
	isHairWorksEnabled = theGame.GetHairWorksEnabled();
	isFSREnabled = theGame.GetFSREnabled();
	isDLSSEnabled = theGame.GetDLSSEnabled();
	isRTAOEnabled = theGame.GetRTAOEnabled();
	isRTREnabled = theGame.GetRTREnabled();
	isDLSSGEnabled = theGame.GetDLSSGEnabled();
	isDLSSGSupported = theGame.GetDLSSGSupported();
	isReflexSupported = theGame.GetReflexSupported();
	isMotionBlurEnabled = theGame.GetMotionBlurEnabled();
	isXESSEnabled = theGame.GetXESSEnabled();
	
	presetNum = inGameConfigWrapper.GetGroupPresetsNum(groupName);
	if (presetNum > 0)
	{
		numValidOptions = 1;
		optionObject = flashStorageUtility.CreateTempFlashObject();
		
		optionObject.SetMemberFlashString( "id", "Presets");
		optionObject.SetMemberFlashString( "label", inGameMenu_TryLocalize("preset_" + groupDisplayName ));
		optionObject.SetMemberFlashUInt( "tag", NameToFlashUInt( 'OptionPresets') );
		optionObject.SetMemberFlashUInt( "type", IGMActionType_Preset );
		optionObject.SetMemberFlashInt( "groupID", groupID );
		optionObject.SetMemberFlashUInt( "GroupName", NameToFlashUInt( groupName ) );
		
		optionFlashArray = flashStorageUtility.CreateTempFlashArray();
		
		
		if ( !isRTSupported && presetNum == 6 ) presetNum = 4;

		for (i = 0; i < presetNum; i += 1)
		{
			optionValueObject = flashStorageUtility.CreateTempFlashObject();
			optionValueObject.SetMemberFlashInt( "id", i );
			optionValueObject.SetMemberFlashString( "label", inGameMenu_TryLocalize("preset_value_" + inGameConfigWrapper.GetGroupPresetDisplayName(groupName, i)));
			optionValueObject.SetMemberFlashUInt( "type", IGMActionType_Preset );
			optionFlashArray.PushBackFlashObject(optionValueObject);
		}
		
		optionObject.SetMemberFlashArray( "subElements", optionFlashArray );
		
		groupOptionArray.PushBackFlashObject(optionObject);
	}
	
	numOptions = inGameConfigWrapper.GetVarsNumByGroupName(groupName);
	previousOptionName = '';
	
	for (i = 0; i < numOptions; i += 1)
	{
		optionName = inGameConfigWrapper.GetVarNameByGroupName(groupName, i);		
		numOptionValues = inGameConfigWrapper.GetVarOptionsNum(groupName, optionName);
		optionDisplayType = inGameConfigWrapper.GetVarDisplayType(groupName, optionName);
		noLocalization = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'nonLocalized');
		nonLocalizedExceptFirst = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'nonLocalizedExceptFirst'); 
		customNames = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'customNames');
		customDisplayName = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'customDisplayName');
		streamable = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'streamable');
		optionalEntry = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'optional');

		enableIfRT = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'enableIfRT');
		enableIfRTSupported = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'enableIfRTSupported');
		enableIfHairWorks = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'enableIfHairWorks');
		enableIfFSR = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'enableIfFSR');
		disableIfFSR = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'disableIfFSR');
		enableIfDLSS = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'enableIfDLSS');
		disableIfDLSS = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'disableIfDLSS');
		enableIfXESS = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'enableIfXESS');
		disableIfXESS = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'disableIfXESS');
		disableIfRTAO = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'disableIfRTAO');
		disableIfRTR = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'disableIfRTR');
		enableIfDLSSGSupported = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'enableIfDLSSGSupported');
		enableIfReflexSupported = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'enableIfReflexSupported');
		disableIfDLSSG = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'disableIfDLSSG');
		disableIfDLSSGAndSet1 = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'disableIfDLSSGAndSet1');
		disableIfIntelGPU = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'disableIfIntelGPU');
		enableIfMotionBlur = inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'enableIfMotionBlur');
		
		if( optionName == 'DeveloperMode' )
			continue;
		
		if ( inGameConfigWrapper.IsVarVisible(groupName, optionName) && 
			(optionDisplayType != "OPTIONS" || numOptionValues > 1) &&
			(optionDisplayType != "STEPPER" || numOptionValues > 1) &&
			((optionalEntry && IngameMenu_IsOptionalEntryActive(optionName)) || !optionalEntry) )
		{
			optionDisplayName = inGameConfigWrapper.GetVarDisplayName(groupName, optionName);
			
			optionValue = inGameConfigWrapper.GetVarValue(groupName, optionName);
			
			optionObject = flashStorageUtility.CreateTempFlashObject();
			optionObject.SetMemberFlashString( "id", "" + i );
			
			if (customDisplayName)
			{
				optionObject.SetMemberFlashString( "label", inGameMenu_TryLocalize(optionDisplayName) );
			}
			else
			{
				optionObject.SetMemberFlashString( "label", inGameMenu_TryLocalize("option_" + optionDisplayName) );
			}

			startingValue = optionValue;
			if (disableIfDLSSGAndSet1 && isDLSSGEnabled) optionValue = "1";
			if (enableIfRTSupported && !isRTSupported) optionValue = "0"; 
			if (optionName == 'Virtual_HairWorksLevel' && disableIfIntelGPU && isIntelGPU) optionValue = "0"; 
						
			optionObject.SetMemberFlashUInt( "type", IngameMenu_GetOptionTypeFromString(optionDisplayType) );
			optionObject.SetMemberFlashUInt( "tag", NameToFlashUInt(optionName) );
			optionObject.SetMemberFlashString( "current", optionValue);
			optionObject.SetMemberFlashString( "startingValue", startingValue);
			optionObject.SetMemberFlashInt( "groupID", groupID );
			optionObject.SetMemberFlashBool( "checkHardwareCursor", optionName == 'UIMouseSensitivity' || optionName == 'MouseSensitivity' );
			optionObject.SetMemberFlashBool( "streamable", streamable);	
			optionObject.SetMemberFlashBool( "isDropdownContent", false );
			optionObject.SetMemberFlashBool( "isDeveloper", inGameConfigWrapper.DoVarHasTag( groupName, optionName, 'developer' ) );
			optionObject.SetMemberFlashBool( "disabled", 
				(enableIfRT && !isRTEnabled) ||
				(enableIfRTSupported && !isRTSupported) ||
				(enableIfHairWorks && !isHairWorksEnabled) ||
				(enableIfFSR && !isFSREnabled) ||
				(disableIfFSR && isFSREnabled) ||
				(enableIfDLSS && !isDLSSEnabled) ||
				(disableIfDLSS && isDLSSEnabled) ||
				(enableIfXESS && !isXESSEnabled) ||
				(disableIfXESS && isXESSEnabled) ||
				(disableIfRTAO && isRTAOEnabled) ||
				(disableIfRTR && isRTREnabled) ||
				(disableIfDLSSGAndSet1 && isDLSSGEnabled) ||
				(disableIfDLSSG && isDLSSGEnabled) ||
				(enableIfDLSSGSupported && !isDLSSGSupported) ||
				(enableIfReflexSupported && !isReflexSupported) ||
				(disableIfIntelGPU && isIntelGPU) ||
				(enableIfMotionBlur && !isMotionBlurEnabled)
			);
			optionObject.SetMemberFlashBool( "indent", inGameConfigWrapper.DoVarHasTag( groupName, optionName, 'indent' ) );
			
			SetOptionSkipsAndLocks(optionObject, optionName, false);
			
			if( optionName == 'Virtual_Localization_speech' )
			{
				theGame.SetVoiceLangDownloadStatusListener( flashStorageUtility );
			}
			
			SetDescriptionText(optionObject, optionName, optionValue);
			
			optionFlashArray = flashStorageUtility.CreateTempFlashArray();
			streamableStatusArray = flashStorageUtility.CreateTempFlashArray();
			for (option_it = 0; option_it < numOptionValues; option_it += 1)
			{
				optionVarValue = inGameConfigWrapper.GetVarOption(groupName, optionName, option_it);
				
				if( streamable )
				{
					streamableStatus = flashStorageUtility.CreateTempFlashObject();
					streamableStatus.SetMemberFlashString( "optionValueString", optionVarValue );			
					streamableStatus.SetMemberFlashBool( "optionStatus", theGame.GetVoiceLangDownloadStatus( optionVarValue ) == STREAMABLE_LOADED );
					
					streamableStatusArray.PushBackFlashObject( streamableStatus );
				}
				
				if (IngameMenu_GetOptionTypeFromString(optionDisplayType) == IGMActionType_List 
					|| IngameMenu_GetOptionTypeFromString(optionDisplayType) == IGMActionType_ListWithCondition
					|| IngameMenu_GetOptionTypeFromString(optionDisplayType) == IGMActionType_Stepper )
				{
					if(!customNames)
					{
						optionVarValue = "preset_value_" + optionVarValue;
					}
					
					if((!noLocalization && !nonLocalizedExceptFirst) || 
						(nonLocalizedExceptFirst && option_it == 0)) 
					{
						optionVarValue = inGameMenu_TryLocalize(optionVarValue);
					}
				}
				
				optionFlashArray.PushBackFlashString( optionVarValue );
			}
			
			optionObject.SetMemberFlashArray( "subElements", optionFlashArray );
			
			if( optionDisplayType == "TOGGLE" && numOptionValues == 2 )
			{
				optionVarValue = inGameConfigWrapper.GetVarOption(groupName, optionName, 0);
				optionObject.SetMemberFlashString( "offString", inGameMenu_TryLocalize(optionVarValue) );
				
				optionVarValue = inGameConfigWrapper.GetVarOption(groupName, optionName, 1);
				optionObject.SetMemberFlashString( "onString", inGameMenu_TryLocalize(optionVarValue) );
			}
			
			if( optionDisplayType == "STEPPER" || optionDisplayType == "TOGGLESTEPPER" )
			{
				optionObject.SetMemberFlashBool( "hideIndicator", inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'hideIndicator') );
			}
			
			if( streamable )
			{
				optionObject.SetMemberFlashArray( "streamableStatus", streamableStatusArray );
			}
			
			if( inGameConfigWrapper.DoVarHasTag( groupName, optionName, 'developer' ) )
			{				
				optionObject.SetMemberFlashUInt( "masterTag", NameToFlashUInt( previousOptionName ) );
				theGame.GetGuiManager().GetIngameMenu().GetDeveloperOptionsContainer().PushBackFlashObject( optionObject );
			}
			else
			{
				groupOptionArray.PushBackFlashObject(optionObject);
				numValidOptions += 1;
			}
				
			if( inGameConfigWrapper.DoVarHasTag(groupName, optionName, 'dropDown' ) )
			{
				IngameMenu_FetchDropdownOptions( 
					flashStorageUtility, 
					groupID, 
					groupName, 
					optionName, 
					inGameConfigWrapper.GetCurrentOptionId( groupName, optionName ), 
					groupOptionArray );
			}
		}
	}
	
	return numValidOptions > 0;
}

function SetDescriptionText(optionObject: CScriptedFlashObject, optionName: name, optionValue: string)
{
	if( optionName == 'EnableRT' && (theGame.GetPlatform() == Platform_PS5 || theGame.GetPlatform() == Platform_Xbox_SCARLETT_ANACONDA) )
	{
		optionObject.SetMemberFlashString( "descriptionTrue", GetLocStringByKeyExt("panel_video_quality_mode_tooltip") );
		optionObject.SetMemberFlashString( "descriptionFalse", GetLocStringByKeyExt("panel_video_performance_mode_tooltip") );
	}
	else if( optionName == 'LockhartPerformanceMode' )
	{
		optionObject.SetMemberFlashString( "descriptionFalse", GetLocStringByKeyExt("option_lockhart_performance_mode_description_quality") );
		optionObject.SetMemberFlashString( "descriptionTrue", GetLocStringByKeyExt("option_lockhart_performance_mode_description_performance") );
		
	}
}

function IngameMenu_AddDifficultyOption(flashStorageUtility : CScriptedFlashValueStorage, listToAddToo:CScriptedFlashArray):void
{
	var optionObject 		: CScriptedFlashObject;
	var optionFlashArray	: CScriptedFlashArray;
	var startValue 			: string;
	var difficulty			: int;
	var optionValue			: string;
	
	
	difficulty = theGame.GetDifficultyLevel();
	
	if (difficulty != 0) 
	{
		difficulty -= 1;
	}
	
	startValue = "" + difficulty;
	
	optionObject = flashStorageUtility.CreateTempFlashObject();
	optionObject.SetMemberFlashString( "id", "difficulty");
	optionObject.SetMemberFlashString( "label", GetLocStringByKeyExt("option_difficulty") );
	optionObject.SetMemberFlashUInt( "type", IGMActionType_List );
	optionObject.SetMemberFlashUInt( "tag", NameToFlashUInt('GameDifficulty') );
	optionObject.SetMemberFlashString( "current", startValue);
	optionObject.SetMemberFlashString( "startingValue", startValue);
	optionObject.SetMemberFlashInt( "groupID", NameToFlashUInt('SpecialSettingsGroupId') );
	
	optionFlashArray = flashStorageUtility.CreateTempFlashArray();
	
	optionFlashArray.PushBackFlashString(GetLocStringByKeyExt("panel_mainmenu_dificulty_easy_title"));
	optionFlashArray.PushBackFlashString(GetLocStringByKeyExt("panel_mainmenu_dificulty_normal_title"));
	optionFlashArray.PushBackFlashString(GetLocStringByKeyExt("panel_mainmenu_dificulty_hard_title"));
	optionFlashArray.PushBackFlashString(GetLocStringByKeyExt("panel_mainmenu_dificulty_hardcore_title"));
	
	optionObject.SetMemberFlashArray( "subElements", optionFlashArray );
	
	listToAddToo.PushBackFlashObject(optionObject);
}

function IngameMenu_AddGwentDifficultyOption(flashStorageUtility : CScriptedFlashValueStorage, listToAddToo:CScriptedFlashArray):void
{
	var optionObject 		: CScriptedFlashObject;
	var optionFlashArray	: CScriptedFlashArray;
	var startValue 			: string;
	var difficulty			: int;
	var optionValue			: string;
	
	
	difficulty = FactsQueryLatestValue('gwent_difficulty');
	
	if (difficulty != 0) 
	{
		difficulty -= 1;
	}
	
	startValue = "" + difficulty;
	
	optionObject = flashStorageUtility.CreateTempFlashObject();
	optionObject.SetMemberFlashString( "id", "GwentDifficulty");
	optionObject.SetMemberFlashString( "label", GetLocStringByKeyExt("option_gwent_difficulty") );
	optionObject.SetMemberFlashUInt( "type", IGMActionType_List );
	optionObject.SetMemberFlashUInt( "tag", NameToFlashUInt('GwentDifficulty') );
	optionObject.SetMemberFlashString( "current", startValue);
	optionObject.SetMemberFlashString( "startingValue", startValue);
	optionObject.SetMemberFlashInt( "groupID", NameToFlashUInt('Gameplay') );
	
	optionFlashArray = flashStorageUtility.CreateTempFlashArray();
	
	optionFlashArray.PushBackFlashString(GetLocStringByKeyExt("panel_mainmenu_dificulty_easy"));
	optionFlashArray.PushBackFlashString(GetLocStringByKeyExt("panel_mainmenu_dificulty_normal"));
	optionFlashArray.PushBackFlashString(GetLocStringByKeyExt("panel_mainmenu_dificulty_hard"));
	
	optionObject.SetMemberFlashArray( "subElements", optionFlashArray );
	
	listToAddToo.PushBackFlashObject(optionObject);
}

function IngameMenu_ChangePresetValue(groupId:name, targetPresetIndex:int, parentMenu:CR4IngameMenu):void
{
	var inGameConfigWrapper	: CInGameConfigWrapper;
	
	inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
	
	inGameConfigWrapper.ApplyGroupPreset(groupId, targetPresetIndex);
	
	if (parentMenu)
	{
		parentMenu.UpdateOptions(groupId, false);
	}
}

function IngameMenu_GatherOptionUpdatedValueList(groupId:name, flashStorageUtility : CScriptedFlashValueStorage):void
{
	var inGameConfigWrapper	: CInGameConfigWrapper;
	var numOptions				: int;
	var iter					: int;
	var curOptionName			: name;
	var curOptionValue			: string;
	
	inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
		
	numOptions = inGameConfigWrapper.GetVarsNumByGroupName(groupId);
	
	for (iter = 0; iter < numOptions; iter += 1)
	{
		curOptionName = inGameConfigWrapper.GetVarNameByGroupName(groupId, iter);
		curOptionValue = inGameConfigWrapper.GetVarValue(groupId, curOptionName);

		IngameMenu_AdditionalOptionValueChangeHandling( groupId, curOptionName, curOptionValue, flashStorageUtility );
	}
}


function IngameMenu_GatherOptionUpdatedValues(groupId:name, parentObject:CScriptedFlashObject, flashStorageUtility : CScriptedFlashValueStorage, applyLocks:bool):void
{
	var inGameConfigWrapper	: CInGameConfigWrapper;
	var optionsArray			: CScriptedFlashArray;
	var curOptionInfo			: CScriptedFlashObject;
	var numOptions				: int;
	var iter					: int;
	var curOptionName			: name;
	var curOptionValue			: string;
	
	inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
	
	parentObject.SetMemberFlashUInt( "presetGroupID", NameToFlashUInt(groupId) );
	optionsArray = flashStorageUtility.CreateTempFlashArray();
	
	numOptions = inGameConfigWrapper.GetVarsNumByGroupName(groupId);
	
	for (iter = 0; iter < numOptions; iter += 1)
	{
		curOptionInfo = flashStorageUtility.CreateTempFlashObject();
		
		curOptionName = inGameConfigWrapper.GetVarNameByGroupName(groupId, iter);
		curOptionInfo.SetMemberFlashUInt( "optionName", NameToFlashUInt(curOptionName) );
		
		curOptionValue = inGameConfigWrapper.GetVarValue(groupId, curOptionName);
		curOptionInfo.SetMemberFlashString( "optionValue", curOptionValue );
		
		
		
		SetOptionSkipsAndLocks(curOptionInfo, curOptionName, applyLocks);
		
		optionsArray.PushBackFlashObject(curOptionInfo);
	}
	
	parentObject.SetMemberFlashArray( "optionList", optionsArray );
}



function IngameMenu_AdditionalOptionValueChangeHandling(  groupName:name, optionName:name, optionValue:string, flashStorageUtility : CScriptedFlashValueStorage )
{
	var optionDisplayName	: string;
	var optionDisplayType	: string;
	var optionVarValue		: string;
	var optionObject		: CScriptedFlashObject;
	var optionFlashArray 	: CScriptedFlashArray;
	var entriesArray		: CScriptedFlashArray;
	var entriesObject		: CScriptedFlashObject;
	var it					: int;
	var numOptionValues		: int;
	var optionId 			: int;
	var entriesNum 			: int;
	
	var inGameConfigWrapper	: CInGameConfigWrapper;
	inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
	
	if( inGameConfigWrapper.DoVarHasTag( groupName, optionName, 'dropDown' ) )
	{
		
		entriesArray = flashStorageUtility.CreateTempFlashArray();
		numOptionValues = inGameConfigWrapper.GetVarOptionsNum( groupName, optionName );
		
		for( optionId = 0; it < numOptionValues; optionId += 1 )
		{
			entriesNum = inGameConfigWrapper.GetEntriesNumForOption( groupName, optionName, optionId );
			for( it = 0; it < entriesNum; it += 1 )
			{
				optionObject = flashStorageUtility.CreateTempFlashObject();
				optionObject.SetMemberFlashUInt( "tag", NameToFlashUInt( inGameConfigWrapper.GetEntryNameForOption( groupName, optionName, optionId, it ) ) );
				entriesArray.PushBackFlashObject( optionObject );
			}
		}

		entriesObject = flashStorageUtility.CreateTempFlashObject();
		entriesObject.SetMemberFlashArray( "list", entriesArray );
		flashStorageUtility.SetFlashObject( "options.remove_entry", entriesObject );
		
		
		entriesArray = flashStorageUtility.CreateTempFlashArray();
		IngameMenu_FetchDropdownOptions( 
			flashStorageUtility, 
			inGameConfigWrapper.GetGroupIdx( groupName ), 
			groupName, 
			optionName, 
			StringToInt( optionValue ),
			entriesArray );
		entriesObject = flashStorageUtility.CreateTempFlashObject();
		entriesObject.SetMemberFlashArray( "list", entriesArray );
		entriesObject.SetMemberFlashUInt( "masterTag", NameToFlashUInt( optionName ) );
		flashStorageUtility.SetFlashObject( "options.insert_entry", entriesObject );
		
		theGame.GetGuiManager().ForceProcessFlashStorage();
		theGame.GetGuiManager().GetIngameMenu().ShowDeveloperOptions( theGame.GetInGameConfigWrapper().GetVarValue( 'Rendering', 'DeveloperMode' ) == "true" );
	}
}

function IngameMenu_GatherKeybindData(parentArray : CScriptedFlashArray, flashStorageUtility : CScriptedFlashValueStorage):void
{
	var currentKeybindData : CScriptedFlashObject;
	var inGameConfigWrapper	: CInGameConfigWrapper;
	var currentKeybindName : name;
	var keybindLabelKey : string;
	var keybindBindingKey : string;
	var groupIndex : int;
	var numKeybinds : int;
	var i:int;
	
	groupIndex = -1;
	inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
	
	
	for (i = 0; i < inGameConfigWrapper.GetGroupsNum(); i += 1)
	{
		if (inGameConfigWrapper.GetGroupName(i) == 'PCInput')
		{
			groupIndex = i;
			break;
		}
	}
	
	if (groupIndex != -1)
	{
		numKeybinds = inGameConfigWrapper.GetVarsNumByGroupName('PCInput');
		
		for (i = 0; i < numKeybinds; i += 1)
		{
			currentKeybindName = inGameConfigWrapper.GetVarName(groupIndex, i);
			
			currentKeybindData = flashStorageUtility.CreateTempFlashObject();
			
			currentKeybindData.SetMemberFlashString("label", IngameMenu_GetLocalizedKeybindName(currentKeybindName));
			
			keybindBindingKey = inGameConfigWrapper.GetVarValue('PCInput', currentKeybindName);
			keybindBindingKey = StrReplace(keybindBindingKey, ";IK_None", ""); 
			keybindBindingKey = StrReplace(keybindBindingKey, "IK_None;", "");
			currentKeybindData.SetMemberFlashString("value", inGameMenu_LocalizeKeyString(keybindBindingKey));
			currentKeybindData.SetMemberFlashBool("locked", inGameConfigWrapper.DoVarHasTag('PCInput', currentKeybindName, 'locked'));
			currentKeybindData.SetMemberFlashBool("permaLocked", false);
			
			currentKeybindData.SetMemberFlashUInt("tag", NameToFlashUInt(currentKeybindName));
			
			parentArray.PushBackFlashObject(currentKeybindData);
		}
	}
	
	currentKeybindData = flashStorageUtility.CreateTempFlashObject();
	currentKeybindData.SetMemberFlashString("label", inGameMenu_TryLocalize("panel_mainmenu_quicksave"));
	currentKeybindData.SetMemberFlashString("value", inGameMenu_LocalizeKeyString("IK_F5"));
	currentKeybindData.SetMemberFlashBool("locked", true);
	currentKeybindData.SetMemberFlashBool("permaLocked", true);
	currentKeybindData.SetMemberFlashUInt("tag", 0);
	
	parentArray.PushBackFlashObject(currentKeybindData);
	
	if (theGame.IsRayTracingSupported() && !theGame.IsFinalBuild())
	{
		currentKeybindData = flashStorageUtility.CreateTempFlashObject();
		currentKeybindData.SetMemberFlashString("label", inGameMenu_TryLocalize("panel_video_enable_rt"));
		currentKeybindData.SetMemberFlashString("value", GetLocStringByKeyExt("ControlLayout_hold")+" "+inGameMenu_LocalizeKeyString("IK_F7"));
		currentKeybindData.SetMemberFlashBool("locked", true);
		currentKeybindData.SetMemberFlashBool("permaLocked", true);
		currentKeybindData.SetMemberFlashUInt("tag", 0);
	
		parentArray.PushBackFlashObject(currentKeybindData);
	}
}

function IngameMenu_GetLocalizedKeybindName(keybindName : name) : string
{
	var inGameConfigWrapper	: CInGameConfigWrapper;
	var label : string;
	
	inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
	
	label = inGameConfigWrapper.GetVarDisplayName('PCInput', keybindName);
	
	
	if (label == "move_forward")
	{
		return GetLocStringByKeyExt("ControlLayout_Movement") + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Up");
	}
	else if (label == "move_back")
	{
		return GetLocStringByKeyExt("ControlLayout_Movement") + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Down");
	}
	else if (label == "move_left")
	{
		return GetLocStringByKeyExt("ControlLayout_Movement") + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Left");
	}
	else if (label == "move_right")
	{
		return GetLocStringByKeyExt("ControlLayout_Movement") + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Right");
	}
	
	return inGameMenu_TryLocalize(label);
}

function IngameMenu_GetPCInputGroupIndex() : int
{
	var inGameConfigWrapper	: CInGameConfigWrapper;
	var numGroups : int;
	var i : int;
	
	inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
	numGroups = inGameConfigWrapper.GetGroupsNum();
	
	
	for (i = 0; i < numGroups; i += 1)
	{
		if (inGameConfigWrapper.GetGroupName(i) == 'PCInput')
		{
			return i;
		}
	}
	
	return -1;
}

function IngameMenu_GetKeybindTagWithKeybindKey(newKeybindValue:EInputKey):name
{
	var inGameConfigWrapper	: CInGameConfigWrapper;
	var currentKeybindName : name;
	var keybindLabelKey : string;
	var keybindBindingKey : string;
	var groupIndex : int;
	var numKeybinds : int;
	var searchingKeybind : string;
	var subKeybind : string;
	var i:int;
	
	searchingKeybind = newKeybindValue;
	
	inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
	
	groupIndex = IngameMenu_GetPCInputGroupIndex();
	
	if (groupIndex != -1)
	{
		numKeybinds = inGameConfigWrapper.GetVarsNumByGroupName('PCInput');
		
		for (i = 0; i < numKeybinds; i += 1)
		{
			currentKeybindName = inGameConfigWrapper.GetVarName(groupIndex, i);
			keybindBindingKey = inGameConfigWrapper.GetVarValue('PCInput', currentKeybindName);
			
			subKeybind = StrReplace(keybindBindingKey, ";IK_None", ""); 
			subKeybind = StrReplace(subKeybind, "IK_None;", "");
			
			if (subKeybind == searchingKeybind) 
			{
				return currentKeybindName;
			}
		}
	}
	
	return 'None';
}

function inGameMenu_LocalizeKeyString(key:string):string
{
	var loclizedKey : string;
	var semiColonIndex : int;
	
	
	semiColonIndex = StrFindFirst(key, ";");
	if (semiColonIndex != -1)
	{
		key = StrLeft(key, semiColonIndex);
	}
	
	loclizedKey = GetLocStringByKeyExt("input_device_key_name_" + key);
	
	if (loclizedKey != "")
	{
		return loclizedKey;
	}
	
	return StrReplace(key, "IK_", "");
}

function inGameMenu_TryLocalize(key:string):string
{
	var localizedKey : string;
	var value:EInputKey;
	var transformation:string;
	
	localizedKey = GetLocStringByKeyExt(key);
	if (localizedKey != "")
	{
		return localizedKey;
	}
	
	return "##" + key;
}
