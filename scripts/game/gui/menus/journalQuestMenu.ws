/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/




struct JournalDescriptionText
{
	var order:int;
	var groupOrder:int;
	var stringKey:int;
	var currentEntry:CJournalQuestDescriptionEntry;
}

class CR4JournalQuestMenu extends CR4ListBaseMenu
{	
	default DATA_BINDING_NAME 		= "journal.quest.list";
	default DATA_BINDING_NAME_SUBLIST	= "journal.objectives.list";
	default DATA_BINDING_NAME_DESCRIPTION	= "journal.quest.description";
		
	var allQuests						: array<CJournalQuest>;
	var currentObjectives				: array<CJournalQuestObjective>;
	var initialTrackedQuest				: CJournalQuest;
	var bDisplayCompleted				: bool;
	default bDisplayCompleted			= false;
	
	private var m_initSelection : bool;
	default m_initSelection = false;
	
	var lastSelectedQuestTag			: name;
	private var m_fxSetTrackedQuest 	: CScriptedFlashFunction;
	private var m_fxSetTrackedObj		: CScriptedFlashFunction;
	
	private var m_fxSetTitle			: CScriptedFlashFunction;
	private var m_fxSetText				: CScriptedFlashFunction;
		
	private var m_fxSetExpansionTexture : CScriptedFlashFunction;
	private var m_fxUpdateExpansionIcon : CScriptedFlashFunction;
		
	
	
	
	
	
	event  OnConfigUI()
	{	
		UISavedData.selectedTag = m_journalManager.GetTrackedQuest().GetUniqueScriptTag();
		
		m_initialSelectionsToIgnore = 3;
		
		super.OnConfigUI();
		
		
		FactsAdd("tutorial_journal_opened", 1, 1);
		
		m_fxSetTrackedQuest 		= m_flashModule.GetMemberFlashFunction("setCurrentlyTrackedQuest");
		m_fxSetTrackedObj 			= m_flashModule.GetMemberFlashFunction("setCurrentlyTrackedObjective");
		m_fxSetTitle 				= m_flashModule.GetMemberFlashFunction("setTitle");
		m_fxSetText 				= m_flashModule.GetMemberFlashFunction("setText");
		
		
		m_fxSetExpansionTexture = m_flashModule.GetMemberFlashFunction("setExpansionTexture");
		m_fxUpdateExpansionIcon = m_flashModule.GetMemberFlashFunction("updateExpansionIcon");
		
		m_fxSetExpansionTexture.InvokeSelfTwoArgs( FlashArgInt( 1 ), FlashArgString( GetEpTextureName( 1 ) ) );
		m_fxSetExpansionTexture.InvokeSelfTwoArgs( FlashArgInt( 2 ), FlashArgString( GetEpTextureName( 2 ) ) );
		
		m_initSelection = true;
		
		GetQuests();
		PopulateData();
		
		
		SelectCurrentModule();
		
		UpdateTrackedQuest();
	}
	
	
	
	protected function UpdateTrackedQuest():void
	{
		var l_objective						: CJournalQuestObjective;
		var l_objectiveProgress				: string;
		var l_objectiveTitle				: string;
		var l_trackedQuest					: CJournalQuest;
		
		l_objective = m_journalManager.GetHighlightedObjective();
		l_trackedQuest = m_journalManager.GetTrackedQuest();
		
		if (l_objective)
		{
			l_objectiveProgress = "";
							
			if( l_objective.GetCount() > 0 )
			{
				l_objectiveProgress =  " " + m_journalManager.GetQuestObjectiveCount( l_objective.guid ) + "/" + l_objective.GetCount();
			}
			
			l_objectiveTitle = GetLocStringById( l_objective.GetTitleStringId() ) + l_objectiveProgress;
			
			m_fxSetTrackedObj.InvokeSelfOneArg(FlashArgString(l_objectiveTitle));
		}
		
		if (l_trackedQuest)
		{
			m_fxSetTrackedQuest.InvokeSelfOneArg(FlashArgString(GetLocStringById( l_trackedQuest.GetTitleStringId() )));
		}
	}
	
	function GetQuests()
	{
		var tempQuests					: array<CJournalBase>;
		var questTemp					: CJournalQuest;
		var i							: int;

		
		var mainArr, sideArr, monsterArr, treasureArr, ep1Arr, ep2Arr, completedArr, failedArr : array<CJournalQuest>;
		var l_questStatus			: EJournalStatus;
		var l_questType				: int;
		

		m_journalManager.GetActivatedOfType( 'CJournalQuest', tempQuests );
		
		initialTrackedQuest = m_journalManager.GetTrackedQuest();
		
		for( i = 0; i < tempQuests.Size(); i += 1 )
		{
			questTemp = (CJournalQuest)tempQuests[i];
			if( questTemp )
			{
				
				
					allQuests.PushBack(questTemp);
				
			}
		}
		
		
		
		if( allQuests.Size() > 0 )
		{
			
			for( i = 0; i < allQuests.Size(); i+= 1 )
			{
				l_questType	= allQuests[i].GetType();
				l_questStatus = m_journalManager.GetEntryStatus(allQuests[i]);

				if (l_questStatus == JS_Active)
				{
					switch (l_questType)
					{
					case 0: 
					case 1: 
						mainArr.PushBack(allQuests[i]);
						break;
					case 2: 
						sideArr.PushBack(allQuests[i]);
						break;
					case 3: 
						monsterArr.PushBack(allQuests[i]);
						break;
					case 4: 
						treasureArr.PushBack(allQuests[i]);
						break;
					case 5: 
						ep1Arr.PushBack(allQuests[i]);
						break;
					case 6: 
						ep2Arr.PushBack(allQuests[i]);
						break;
					}
				}
				else if (l_questStatus == JS_Success)
				{
					completedArr.PushBack(allQuests[i]);
				}
				else if (l_questStatus == JS_Failed)
				{
					failedArr.PushBack(allQuests[i]);
				}
			}
			
			
			mainArr = SortArrayByWorld(mainArr);
			sideArr = SortArrayByWorld(sideArr);
			monsterArr = SortArrayByWorld(monsterArr);
			treasureArr = SortArrayByWorld(treasureArr);
			ep1Arr = SortArrayByWorld(ep1Arr);
			ep2Arr = SortArrayByWorld(ep2Arr);
			completedArr = SortArrayAlphabetically(completedArr);
			failedArr = SortArrayAlphabetically(failedArr);

			
			allQuests.Clear();
			for( i = 0; i < mainArr.Size(); i+= 1 )
			{
				allQuests.PushBack(mainArr[i]);
			}
			for( i = 0; i < sideArr.Size(); i+= 1 )
			{
				allQuests.PushBack(sideArr[i]);
			}
			for( i = 0; i < monsterArr.Size(); i+= 1 )
			{
				allQuests.PushBack(monsterArr[i]);
			}
			for( i = 0; i < treasureArr.Size(); i+= 1 )
			{
				allQuests.PushBack(treasureArr[i]);
			}
			for( i = 0; i < ep1Arr.Size(); i+= 1 )
			{
				allQuests.PushBack(ep1Arr[i]);
			}
			for( i = 0; i < ep2Arr.Size(); i+= 1 )
			{
				allQuests.PushBack(ep2Arr[i]);
			}
			for( i = 0; i < completedArr.Size(); i+= 1 )
			{
				allQuests.PushBack(completedArr[i]);
			}
			for( i = 0; i < failedArr.Size(); i+= 1 )
			{
				allQuests.PushBack(failedArr[i]);
			}
		}
		
	}

	
	private function SortArrayByWorld( arr : array<CJournalQuest> ) : array<CJournalQuest>
	{
		var tempArray, curWorldArr, nonCurWorldArr : array<CJournalQuest>;
		var trackedQuest : CJournalQuest;
		var i : int;
		var currentArea	 : EAreaName;

		currentArea = theGame.GetCommonMapManager().GetCurrentJournalArea();

		for( i = 0; i < arr.Size(); i+= 1 )
		{
			if( m_journalManager.GetTrackedQuest().guid == arr[i].guid &&  m_journalManager.GetEntryStatus(arr[i]) == JS_Active )
			{
				trackedQuest = arr[i];
			}
			if(arr[i].GetWorld() == currentArea)
			{
				curWorldArr.PushBack(arr[i]);
			}
			else
			{
				nonCurWorldArr.PushBack(arr[i]);
			}
		}

		if(trackedQuest)
		{
			tempArray.PushBack(trackedQuest);
		}
		for( i = 0; i < curWorldArr.Size(); i+= 1 )
		{
			if(trackedQuest != curWorldArr[i])
			{
				tempArray.PushBack(curWorldArr[i]);
			}
		}
		for( i = 0; i < nonCurWorldArr.Size(); i+= 1 )
		{
			if(trackedQuest != nonCurWorldArr[i])
			{
				tempArray.PushBack(nonCurWorldArr[i]);
			}			
		}

		return tempArray;
	}

	private function SortArrayAlphabetically( arr : array<CJournalQuest> ) : array<CJournalQuest>
	{
		var tempArray : array<CJournalQuest>;
		var sortingArray : array<string>;
		var i, j : int;

		for( i = 0; i < arr.Size(); i+= 1 )
		{
			sortingArray.PushBack(GetLocStringById( arr[i].GetTitleStringId() ));
		}
		ArraySortStrings( sortingArray );
		for( i = 0; i < sortingArray.Size(); i+= 1 )
		{
			for( j = 0; j < arr.Size(); j+= 1 )
			{
				if( sortingArray[i] == GetLocStringById( arr[j].GetTitleStringId() ) )
				{
					tempArray.PushBack(arr[j]);
					arr.Erase(j);
					break;
				}
			}
		}

		return tempArray;
	}
	


		
	event OnObjectiveRead( tag : name )
	{
		var l_objective	: CJournalBase;
		l_objective = m_journalManager.GetEntryByTag(tag);
		m_journalManager.SetEntryUnread( l_objective, false );
		UpdateObjectives(currentTag);
	}	

	event OnObjectiveSelected( _ObjectiveID : name )
	{
	}
	
	event OnTrackQuest( tag : name )
	{
		var l_quest	: CJournalBase;
		var oldTrackedQuest : CJournalQuest;
		var l_questStatus : EJournalStatus;
		
		l_quest = m_journalManager.GetEntryByTag(tag);
		l_questStatus = m_journalManager.GetEntryStatus( l_quest );
		
		if (l_questStatus == JS_Active)
		{
			oldTrackedQuest = m_journalManager.GetTrackedQuest();
			m_journalManager.SetTrackedQuest( l_quest );
			
			HighlightAnyObjective( l_quest );
			
			OnPlaySoundEvent("gui_journal_track_quest");
			
			UpdateTwoQuests(oldTrackedQuest, (CJournalQuest)l_quest);
		}
		
		UpdateTrackedQuest();
	}
	
	protected function HighlightAnyObjective( targetEntry:CJournalBase ):void
	{
		var l_objective						: CJournalQuestObjective;
		var l_questPhase 					: CJournalQuestPhase;
		var trackedQuest					: CJournalQuest;
		var i, j							: int;
		var l_objectiveStatus				: EJournalStatus;
		
		trackedQuest = (CJournalQuest)(targetEntry);
		
		if (trackedQuest)
		{
			if (m_journalManager.GetHighlightedObjective().GetParentQuest() != trackedQuest)
			{
				for( i = 0; i < trackedQuest.GetNumChildren(); i += 1 )
				{
					l_questPhase = (CJournalQuestPhase)trackedQuest.GetChild(i);
					if(l_questPhase)
					{				
						for( j = 0; j < l_questPhase.GetNumChildren(); j += 1 )
						{
							l_objective = ( CJournalQuestObjective )l_questPhase.GetChild(j);
							l_objectiveStatus = ( m_journalManager.GetEntryStatus( l_objective ) );
							
							if (l_objectiveStatus == JS_Active)
							{
								m_journalManager.SetHighlightedObjective(l_objective);
								UpdateObjectives(trackedQuest.GetUniqueScriptTag());
								return;
							}
						}
					}
				}
			}
		}
	}
	
	event OnEntrySelected( tag : name )
	{
		var questEntry : CJournalQuest;
		
		if( tag )
		{
			super.OnEntrySelected(tag);
			
			questEntry = (CJournalQuest)m_journalManager.GetEntryByTag(tag);
			
			if (questEntry && tag != lastSelectedQuestTag)
			{
				lastSelectedQuestTag = tag;
				UpdateObjectives(tag);
			}
		}
	}
		
	event OnHighlightObjective( tag : name )
	{
		var l_objective						: CJournalQuestObjective;
		var parentQuest						: CJournalBase;
		var l_questStatus 					: EJournalStatus;
		var oldTrackedQuest 				: CJournalQuest;
		
		l_objective = (CJournalQuestObjective)m_journalManager.GetEntryByTag( tag );
		if ( l_objective && m_journalManager.GetEntryStatus( l_objective ) == JS_Active )
		{
			if (m_journalManager.GetHighlightedObjective() != l_objective)
			{
				parentQuest = l_objective.GetParentQuest();
				if (parentQuest)
				{
					l_questStatus = m_journalManager.GetEntryStatus( parentQuest );
					
					if (l_questStatus == JS_Active)
					{
						oldTrackedQuest = m_journalManager.GetTrackedQuest();
						m_journalManager.SetTrackedQuest( parentQuest );
						UpdateTwoQuests(oldTrackedQuest, (CJournalQuest)parentQuest);
					}
				}
			
				m_journalManager.SetHighlightedObjective( l_objective );
				
				OnPlaySoundEvent("gui_journal_track_quest");
				
				UpdateTrackedQuest();
			}
		}
	}		
	
	function UpdateImage( tag : name )
	{
	}
	
	private function UpdateTwoQuests( questOne : CJournalQuest, questTwo : CJournalQuest):void
	{
		var l_questsFlashArray				: CScriptedFlashArray;
		
		l_questsFlashArray = m_flashValueStorage.CreateTempFlashArray();
		
		l_questsFlashArray.PushBackFlashObject(generateFlashObjectForQuest(questOne));
		l_questsFlashArray.PushBackFlashObject(generateFlashObjectForQuest(questTwo));
		
		if( l_questsFlashArray.GetLength() > 0 )
		{
			m_flashValueStorage.SetFlashArray( DATA_BINDING_NAME, l_questsFlashArray );
			m_fxShowSecondaryModulesSFF.InvokeSelfOneArg(FlashArgBool(true));
		}
	}

	private function PopulateData()
	{
		var l_questsFlashArray		: CScriptedFlashArray;
		var i, length				: int;
		var l_quest					: CJournalQuest;
		var l_questIsTracked		: bool;
		var l_questIsSelected		: bool;
		var l_questStatus			: EJournalStatus;
		var l_Tag					: name;
		var questLevel				: int;

		l_questsFlashArray = m_flashValueStorage.CreateTempFlashArray();
		length = allQuests.Size();
		
		for( i = 0; i < length; i+= 1 )
		{	
			l_quest = allQuests[i];
			
			l_questStatus = m_journalManager.GetEntryStatus( l_quest );
			
			if( l_questStatus != JS_Inactive )
			{
				l_questsFlashArray.PushBackFlashObject( generateFlashObjectForQuest( l_quest, m_initSelection ) );
				
				l_questIsTracked = ( (m_journalManager.GetTrackedQuest().guid == l_quest.guid) && ( l_questStatus == JS_Active ) );
				l_Tag = l_quest.GetUniqueScriptTag();
				
				if( l_questIsTracked || l_questIsSelected )
				{
					OnEntrySelected(l_Tag);
				}
			}
		}

		if( l_questsFlashArray.GetLength() > 0 )
		{
			m_flashValueStorage.SetFlashArray( DATA_BINDING_NAME, l_questsFlashArray );
			m_fxShowSecondaryModulesSFF.InvokeSelfOneArg(FlashArgBool(true));
		}
		else
		{
			m_fxShowSecondaryModulesSFF.InvokeSelfOneArg(FlashArgBool(false));
		}
		
		m_initSelection = false;
	}
	
	private function GetEpTag( targetQuest : CJournalQuest ) : string
	{
		var epIndex : int;
		epIndex = targetQuest.GetContentType();
		if ( epIndex == 1 )
		{
			return "ep1tag";
		}
		else if ( epIndex == 2 )
		{
			return "ep2tag";
		}
		return "";
	}
	
	private function generateFlashObjectForQuest( targetQuest : CJournalQuest, optional initSelection : bool  ) : CScriptedFlashObject
	{
		var l_questsDataFlashObject : CScriptedFlashObject;
		var l_questStatus			: EJournalStatus;
		var j 						: int;
		var iterQuestLevels			: int;
		var questLevelsCount		: int;
		var questCount				: int;
		var questLevel				: int;
		var lvlDiff 				: int;
		var l_questWorld			: int;
		
		var l_Tag					: name;
		var l_GroupTag				: name;
		var l_questType				: int;
		var l_questIsNew			: bool;
		
		var l_areaTag				: string;
		var l_questLevel			: string;
		var l_RecommendedDiff		: string;
		var l_questTitle			: string;
		var l_dropdownLabel			: string;
		var questName				: string;
		var difficultyColor 		: string;
		var isDeadlyDiff			: bool;
		
		var l_questIsTracked		: bool;
		
		var currentArea				: EAreaName;
		var questLevels 			: C2dArray;
		
		questLevelsCount 	= theGame.questLevelsContainer.Size();
		currentArea 		= theGame.GetCommonMapManager().GetCurrentJournalArea();
		
		l_questStatus 		= m_journalManager.GetEntryStatus(targetQuest);
		
		l_Tag 				= targetQuest.GetUniqueScriptTag();
		l_GroupTag			= GetAreaName(targetQuest);
		
		l_questTitle		= GetLocStringById( targetQuest.GetTitleStringId() );
		
		l_questType			= targetQuest.GetType();
		l_questIsNew		= m_journalManager.IsEntryUnread( targetQuest );
		l_questIsTracked	= ( (m_journalManager.GetTrackedQuest().guid == targetQuest.guid) && ( l_questStatus == JS_Active ) );
		
		
		
		l_dropdownLabel = "";
		
		questName = "";
		for( iterQuestLevels = 0; iterQuestLevels < questLevelsCount; iterQuestLevels += 1 )
		{
			questLevels = theGame.questLevelsContainer[iterQuestLevels];			
			questCount = questLevels.GetNumRows();
			for( j = 0; j < questCount; j += 1 )
			{
				questName  = questLevels.GetValueAtAsName(0,j);
				if ( questName == targetQuest.baseName )
				{
					questLevel = NameToInt( questLevels.GetValueAtAsName(1,j) );
					
					if(FactsQuerySum("NewGamePlus") > 0 && questLevel > 1)
					{
						questLevel += theGame.params.GetNewGamePlusLevel();
						if ( questLevel > GetWitcherPlayer().GetMaxLevel() ) 
						{
							questLevel = GetWitcherPlayer().GetMaxLevel();
						}
					}
				}
			}
		}
		lvlDiff = questLevel - thePlayer.GetLevel();
		
		if(lvlDiff >= theGame.params.LEVEL_DIFF_HIGH && ShouldProcessTutorial('TutorialHighLevelQuests'))
		{
			GameplayFactsAdd("tut_high_level_quest");
			
			
			theGame.GetTutorialSystem().uiHandler.OnOpeningMenu( GetMenuName() );
		}
		
		if 		( lvlDiff >= theGame.params.LEVEL_DIFF_DEADLY ) { difficultyColor = "<font color='#d61010'>"; isDeadlyDiff = true; }
		else if ( lvlDiff >= theGame.params.LEVEL_DIFF_HIGH )  { difficultyColor = "<font color='#d68f29'>"; isDeadlyDiff = false;}
		else if ( lvlDiff > -theGame.params.LEVEL_DIFF_HIGH )  { difficultyColor = "<font color='#ffffff'>"; isDeadlyDiff = false; }
		else	{ difficultyColor = "<font color='#969696'>"; isDeadlyDiff = false; }		
		
		if (l_GroupTag != '')
		{
			l_areaTag = GetLocStringByKeyExt(l_GroupTag);
		}
		else
		{
			l_areaTag = "";
		}
		
		if ( questName != "" && questLevel > 1 ) 
			l_questLevel = difficultyColor + questLevel + "</font>";
			
		if( questLevel <=1)
		{
			l_RecommendedDiff =  "";
		}
		else
		{
			l_RecommendedDiff =  difficultyColor + GetLocStringByKeyExt('panel_item_required_level') + " " + questLevel + "</font>";
		}
		l_questWorld = targetQuest.GetWorld();
		
		if (l_questStatus == JS_Active)
		{
			switch (l_questType)
			{
			case 0: 
			case 1: 
				l_dropdownLabel = GetLocStringByKeyExt("panel_journal_queststatus_story");
				break;
			case 2: 
				l_dropdownLabel = GetLocStringByKeyExt("panel_journal_queststatus_side"); 
				break;
			case 3: 
				l_dropdownLabel = GetLocStringByKeyExt("panel_journal_legend_monsterhunt");
				break;
			case 4: 
				l_dropdownLabel = GetLocStringByKeyExt("panel_journal_legend_treasurehunt");
				break;
			case 5: 
				l_dropdownLabel = GetLocStringByKeyExt("panel_journal_legend_ep1");
				break;
			case 6: 
				l_dropdownLabel = GetLocStringByKeyExt("panel_journal_legend_ep2");
				break;
			}
		}
		else if (l_questStatus == JS_Success)
		{
			l_dropdownLabel = GetLocStringByKeyExt("panel_journal_legend_succed");
		}
		else if (l_questStatus == JS_Failed)
		{
			l_dropdownLabel = GetLocStringByKeyExt("panel_journal_legend_failed");
		}
		
		l_questsDataFlashObject = m_flashValueStorage.CreateTempFlashObject();
		
		
		if( l_Tag == 'None' )
		{
			LogChannel('JOURNAL_ERROR',"There is no unique script tag for quest "+l_questTitle);
		}
		
		l_questsDataFlashObject.SetMemberFlashString( "title", GetLocStringById( targetQuest.GetTitleStringId() ) );
		l_questsDataFlashObject.SetMemberFlashString( "description", GetDescription( targetQuest ) );
		
		l_questsDataFlashObject.SetMemberFlashUInt(  "tag", NameToFlashUInt(l_Tag) );
		l_questsDataFlashObject.SetMemberFlashString(  "dropDownLabel", l_dropdownLabel );
		l_questsDataFlashObject.SetMemberFlashUInt(  "dropDownTag",  NameToFlashUInt(l_GroupTag) );
		
		if (initSelection)
		{
			l_questsDataFlashObject.SetMemberFlashBool(  "dropDownOpened", l_questIsTracked );
			l_questsDataFlashObject.SetMemberFlashBool( "selected", l_questIsTracked );
			
		}
		else
		{
			l_questsDataFlashObject.SetMemberFlashBool(  "dropDownOpened", IsCategoryOpened( l_GroupTag ) );
			l_questsDataFlashObject.SetMemberFlashBool( "selected", ( l_Tag == currentTag ) );
		}
		
		l_questsDataFlashObject.SetMemberFlashInt( "isStory", l_questType ); 
		l_questsDataFlashObject.SetMemberFlashInt( "epIndex", targetQuest.GetContentType() );
		l_questsDataFlashObject.SetMemberFlashString( "iconPath", GetQuestIconByType( targetQuest.GetType(), targetQuest.GetContentType() ) );		
		l_questsDataFlashObject.SetMemberFlashBool( "isNew", l_questIsNew );
		l_questsDataFlashObject.SetMemberFlashInt( "questWorld", l_questWorld );
		l_questsDataFlashObject.SetMemberFlashInt( "curWorld", currentArea );
		
		
		l_questsDataFlashObject.SetMemberFlashInt( "status", l_questStatus );
		l_questsDataFlashObject.SetMemberFlashString( "questArea", l_GroupTag );
		
		l_questsDataFlashObject.SetMemberFlashBool( "tracked", l_questIsTracked );
		l_questsDataFlashObject.SetMemberFlashString(  "label", l_questTitle );
		l_questsDataFlashObject.SetMemberFlashString( "secondLabel", l_areaTag );
		l_questsDataFlashObject.SetMemberFlashString( "area", l_questLevel );
		l_questsDataFlashObject.SetMemberFlashString( "reqdifficulty", l_RecommendedDiff );
		l_questsDataFlashObject.SetMemberFlashBool( "isdeadlydifficulty", isDeadlyDiff );
		
		
		
		return l_questsDataFlashObject;
	}
	
	function GetQuestIconByType( type : eQuestType, optional epIndex : int ) : string
	{
		var retStr : string;
		retStr = "icons/quests/";
		if ( epIndex == 0 )
		{
			switch(type)
			{
				case Story :
					retStr += "story.png";	
					break;
				case Chapter :
					retStr += "chapter.png";	
					break;
				case Side :
					retStr += "side.png";	
					break;
				case MonsterHunt :
					retStr += "monsterhunt.png";	
					break;
				case TreasureHunt :
					retStr += "treasurehunt.png";	
					break;
			}
		}
		else if ( epIndex == 1 )
		{
			switch(type)
			{
				case Story :
				case Chapter :
				case Side :
					retStr += "quest_hos.png";
					break;
				case MonsterHunt :
					retStr += "monsterhunt_hos.png";	
					break;
				case TreasureHunt :
					retStr += "treasurehunt_hos.png";	
					break;
			}
		}
		else if ( epIndex == 2 )
		{
			switch(type)
			{
				case Story :
				case Chapter :
				case Side :
					retStr += "quest_baw.png";
					break;
				case MonsterHunt :
					retStr += "monsterhunt_baw.png";	
					break;
				case TreasureHunt :
					retStr += "treasurehunt_baw.png";	
					break;
			}
		}

		return retStr;
	}
	
	function UpdateObjectives( tag : name )
	{	
		var l_objectivesTotal				: int;
		var l_questObjectivesFlashArray		: CScriptedFlashArray;
		var l_questObjectiveDataFlashObject	: CScriptedFlashObject;
		
		var l_objective						: CJournalQuestObjective;
		var questEntry 						: CJournalQuest;
		var l_questPhase 					: CJournalQuestPhase;
		
		var l_objectiveStatus				: EJournalStatus;
		var l_objectiveTitle				: string;
		var l_objectiveProgress				: string;
		var l_objectiveIsNew				: bool;
		var l_objectiveIsTracked			: bool;
		var l_objectiveTag					: name;
		var i, j							: int;
		var locID							: int;
		var l_objectiveOrder				: int;
		var highlightedObjective			: CJournalQuestObjective;
		
		if (m_initialSelectionsToIgnore == 0)
		{
			m_initialSelectionsToIgnore = 1;
		}
		
		l_questObjectivesFlashArray = m_flashValueStorage.CreateTempFlashArray();
		
		questEntry = (CJournalQuest)m_journalManager.GetEntryByTag(tag);
		
		if (!questEntry)
		{
			return;
		}
		
		highlightedObjective = m_journalManager.GetHighlightedObjective();

		for( i = 0; i < questEntry.GetNumChildren(); i += 1 )
		{
			l_questPhase = (CJournalQuestPhase) questEntry.GetChild(i);
			if(l_questPhase)
			{				
				for( j = 0; j < l_questPhase.GetNumChildren(); j += 1 )
				{
					l_objective =( CJournalQuestObjective ) l_questPhase.GetChild(j);
					l_objectiveStatus 	= ( m_journalManager.GetEntryStatus( l_objective ) );
					if( l_objectiveStatus != JS_Inactive )
					{						
						l_questObjectiveDataFlashObject = m_flashValueStorage.CreateTempFlashObject();
						l_objectiveProgress = "";
						
						if( l_objective.GetCount() > 0 )
						{
							l_objectiveProgress =  " " + m_journalManager.GetQuestObjectiveCount( l_objective.guid ) + "/" + l_objective.GetCount();
						}
						l_objectiveTitle = GetLocStringById( l_objective.GetTitleStringId()  );
						l_objectiveIsNew = m_journalManager.IsEntryUnread( l_objective );
						l_objectiveIsTracked = ( highlightedObjective == l_objective );
						l_objectiveOrder = m_journalManager.GetEntryIndex( l_objective );
						
						
						l_objectiveTag = l_objective.GetUniqueScriptTag();
						l_questObjectiveDataFlashObject.SetMemberFlashUInt(  "tag", NameToFlashUInt(l_objectiveTag) ); 
						l_questObjectiveDataFlashObject.SetMemberFlashBool( "isNew", l_objectiveIsNew );
						l_questObjectiveDataFlashObject.SetMemberFlashBool( "tracked", l_objectiveIsTracked );
						l_questObjectiveDataFlashObject.SetMemberFlashBool( "isLegend", false );
						l_questObjectiveDataFlashObject.SetMemberFlashInt( "status", l_objectiveStatus );
						
						l_questObjectiveDataFlashObject.SetMemberFlashString(  "label", l_objectiveTitle + l_objectiveProgress );
						l_questObjectiveDataFlashObject.SetMemberFlashInt( "phaseIndex", 1 );
						l_questObjectiveDataFlashObject.SetMemberFlashInt( "objectiveIndex", l_objectiveOrder );
						l_questObjectiveDataFlashObject.SetMemberFlashBool( "isMutuallyExclusive", l_objective.IsMutuallyExclusive() );
						
						l_questObjectivesFlashArray.PushBackFlashObject(l_questObjectiveDataFlashObject);
					}
				}
			}
		}
		
		locID = questEntry.GetTitleStringId();
		m_flashValueStorage.SetFlashArray( DATA_BINDING_NAME_SUBLIST, l_questObjectivesFlashArray );
		m_flashValueStorage.SetFlashString( DATA_BINDING_NAME_SUBLIST+".questname", GetLocStringById(locID));
		
		m_fxUpdateExpansionIcon.InvokeSelfOneArg( FlashArgInt( questEntry.GetContentType() ) );
	}
	
	function GetAreaName( questEntry : CJournalQuest ) : name
	{
		var l_questArea						: name;
		
		switch ( questEntry.GetWorld() )
		{
			case AN_Undefined:
				l_questArea = 'panel_journal_filters_area_any';
				break;
			case AN_NMLandNovigrad:
				l_questArea = 'panel_journal_filters_area_no_mans_land';
				break;
			case AN_Skellige_ArdSkellig:
				l_questArea = 'panel_journal_filters_area_skellige';
				break;
			case AN_Kaer_Morhen:
				l_questArea = 'panel_journal_filters_area_kaer_morhen';
				break;
			case AN_Prologue_Village:
				l_questArea = 'panel_journal_filters_area_prolgue_village';
				break;

			
			case AN_Wyzima:
				l_questArea = 'panel_journal_filters_area_wyzima';
				break;
			case AN_Island_of_Myst:
				l_questArea = 'panel_journal_filters_area_island_of_myst';
				break;
			case AN_Spiral:
				l_questArea = 'panel_journal_filters_area_spiral';
				break;
			case AN_Prologue_Village_Winter:
				l_questArea = 'panel_journal_filters_area_prolgue_village';
				break;
			case AN_Velen:
				l_questArea = 'panel_journal_filters_area_velen';
				break;
			case (EAreaName)AN_Dlc_Bob:
				l_questArea = 'panel_journal_filters_area_bob';
				break;
		}
		return l_questArea;
	}

	function GetDescription( currentQuest : CJournalQuest ) : string
	{
		var i : int;
		var currentIndex:int;
		var str : string;
		var locStrId : int;
		var placedString : bool;
		var currentJournalDescriptionText : JournalDescriptionText;
		var journalDescriptionArray : array<JournalDescriptionText>;
		var descriptionsGroup, tmpGroup : CJournalQuestDescriptionGroup;
		var description : CJournalQuestDescriptionEntry;
		var tempStr : string;
		var tempStr2 : string;
		
		str = "";
		for( i = 0; i < currentQuest.GetNumChildren(); i += 1 )
		{
			tmpGroup = (CJournalQuestDescriptionGroup)(currentQuest.GetChild(i));
			if( tmpGroup )
			{
				descriptionsGroup = tmpGroup;
				break;
			}
		}
		
		for( i = 0; i < descriptionsGroup.GetNumChildren(); i += 1 )
		{
			description = (CJournalQuestDescriptionEntry)descriptionsGroup.GetChild(i);
			if( m_journalManager.GetEntryStatus(description) != JS_Inactive )
			{
				
				currentJournalDescriptionText.stringKey = description.GetDescriptionStringId();
				currentJournalDescriptionText.order = description.GetOrder();
				currentJournalDescriptionText.groupOrder = descriptionsGroup.GetOrder();
				currentJournalDescriptionText.currentEntry = description;
				
				if (journalDescriptionArray.Size() == 0)
				{
					journalDescriptionArray.PushBack(currentJournalDescriptionText);
				}
				else
				{
					placedString = false;
					
					for (currentIndex = 0; currentIndex < journalDescriptionArray.Size(); currentIndex += 1)
					{
						if (journalDescriptionArray[currentIndex].groupOrder > currentJournalDescriptionText.groupOrder ||
							(journalDescriptionArray[currentIndex].groupOrder <= currentJournalDescriptionText.groupOrder && 
							 journalDescriptionArray[currentIndex].order > currentJournalDescriptionText.order))
						{
							journalDescriptionArray.Insert(Max(0, currentIndex), currentJournalDescriptionText);
							placedString = true;
							break;
						}
					}
					
					if (!placedString)
					{
						journalDescriptionArray.PushBack(currentJournalDescriptionText);
					}
				}
			}
		}
		
		for ( i = 0; i < journalDescriptionArray.Size(); i += 1 )
		{
			str += GetLocStringById(journalDescriptionArray[i].stringKey) + "<br>";
		}
		
		if( str == "" || str == "<br>" )
		{
			str = GetLocStringByKeyExt("panel_journal_quest_empty_description");
		}
		
		return str;
	}
	
	function UpdateDescription( entryName : name )
	{
		var l_quest : CJournalQuest;
		var description : string;
		var title : string;
	
		
		
		l_quest = (CJournalQuest)m_journalManager.GetEntryByTag( entryName );
		description = GetDescription( l_quest );
		title = GetLocStringById( l_quest.GetTitleStringId());	

		m_fxSetTitle.InvokeSelfOneArg(FlashArgString(title));
		m_fxSetText.InvokeSelfOneArg(FlashArgString(description));
			
	}	

	function UpdateItems( tag : name )
	{
		var itemsFlashArray			: CScriptedFlashArray;
		var l_quest : CJournalQuest;
		var rewards : array< name >;
		
		l_quest = (CJournalQuest)m_journalManager.GetEntryByTag( tag );
		
		return; 
		
		rewards = m_journalManager.GetQuestRewards( l_quest );
		if( rewards.Size() < 1 )
		{
			m_flashValueStorage.SetFlashBool("journal.rewards.panel.visible",false);
			return;
		}
		m_flashValueStorage.SetFlashBool("journal.rewards.panel.visible",true);
		
		itemsFlashArray = CreateRewards( rewards );
		
		if( itemsFlashArray )
		{
			m_flashValueStorage.SetFlashArray(DATA_BINDING_NAME_SUBLIST+".reward.items", itemsFlashArray );
		}
	}
	
	private function CreateRewards( rewards : array< name > ) : CScriptedFlashArray
	{
		var l_flashArray				: CScriptedFlashArray;
		var l_flashObject				: CScriptedFlashObject;
		var i 							: int;
		var experience					: int;
		var money						: int;
		var rewrd						: SReward;
		var moneyItem					: SItemReward;
		var dm 							: CDefinitionsManagerAccessor = theGame.GetDefinitionsManager();
		var items						: array< SItemReward >;
		var multiplier					: float;
		
		experience = 0;
		money = 0;
		
		itemsNames.Clear();
		
		for ( i = 0; i < rewards.Size(); i += 1 )
		{
			if ( theGame.GetReward( rewards[ i ], rewrd ) )
			{
				multiplier = thePlayer.GetRewardMultiplier( rewards[ i ] );
				money += (int)(rewrd.gold * multiplier);
				experience += rewrd.experience;
				AppendArrayOfItemRewards( items, rewrd.items );
			}
		}
			
		if( money > 0 )
		{
			moneyItem.item = 'Orens';
			moneyItem.amount = money;	
			items.PushBack( moneyItem );
		}	
		l_flashArray = m_flashValueStorage.CreateTempFlashArray();
			
		for( i = 0; i < items.Size(); i += 1 )
		{
			l_flashObject = m_flashValueStorage.CreateTempFlashObject("red.game.witcher3.menus.common.ItemDataStub");
			l_flashObject.SetMemberFlashInt( "id", i + 1 ); 
			l_flashObject.SetMemberFlashInt( "quantity", items[ i ].amount );
			l_flashObject.SetMemberFlashString( "iconPath",  dm.GetItemIconPath( items[ i ].item ) );
			l_flashObject.SetMemberFlashInt( "gridPosition", i );
			l_flashObject.SetMemberFlashInt( "gridSize", 1 );
			l_flashObject.SetMemberFlashInt( "slotType", 1 );	
			l_flashObject.SetMemberFlashBool( "isNew", false );
			l_flashObject.SetMemberFlashBool( "needRepair", false );
			l_flashObject.SetMemberFlashInt( "actionType", IAT_None );
			l_flashObject.SetMemberFlashInt( "price", 0 ); 		
			l_flashObject.SetMemberFlashString( "userData", "");
			l_flashObject.SetMemberFlashString( "category", "" );
			l_flashArray.PushBackFlashObject(l_flashObject);
			itemsNames.PushBack(items[ i ].item);
		}
		
		m_flashValueStorage.SetFlashString( DATA_BINDING_NAME_SUBLIST+".items.experience", IntToString(experience) );
		return l_flashArray;
	}
	
	event OnGetItemData(item : int, compareItemType : int) 
	{
		
		
		var itemName 			: string;
		var category			: name;
		var typeStr				: string;
		var weight 				: float;
		
		var resultData 			: CScriptedFlashObject;
		var statsList			: CScriptedFlashArray;		
		var dm 					: CDefinitionsManagerAccessor = theGame.GetDefinitionsManager();
		item = item - 1;
		
		resultData = m_flashValueStorage.CreateTempFlashObject();
		statsList = m_flashValueStorage.CreateTempFlashArray();
		
		itemName = dm.GetItemLocalisationKeyName( itemsNames[item]);
		itemName = GetLocStringByKeyExt(itemName);
		resultData.SetMemberFlashString("ItemName", itemName);
		
		
		
		
		
		resultData.SetMemberFlashString("PriceValue", dm.GetItemPrice(itemsNames[item]));
				
		category = dm.GetItemCategory(itemsNames[item]);
		
		if( dm.ItemHasTag(itemsNames[item], 'Quest') 
			|| dm.ItemHasTag(itemsNames[item], 'AlchemyIngredient') 
			|| dm.ItemHasTag(itemsNames[item], 'CraftingIngredient') 
			|| dm.ItemHasTag(itemsNames[item], 'Potion') 
			|| dm.ItemHasTag(itemsNames[item], 'SilverOil') 
			|| dm.ItemHasTag(itemsNames[item], 'SteelOil') 
			|| category == 'petard' 
			|| category == 'bolt' )
		{
			weight = 0;
		}
		else
		{
			weight = 1; 
		}
		
		resultData.SetMemberFlashString("WeightValue", NoTrailZeros(weight));
		resultData.SetMemberFlashString("ItemRarity", "" );
		
		typeStr = GetItemCategoryLocalisedString( category );
		resultData.SetMemberFlashString("ItemType", typeStr );
		
		resultData.SetMemberFlashString("DurabilityValue", "");

		resultData.SetMemberFlashString("IconPath", dm.GetItemIconPath(itemsNames[item]) );
		resultData.SetMemberFlashString("ItemCategory", category);
		m_flashValueStorage.SetFlashObject("context.tooltip.data", resultData);
	}
	
		
	private function AppendArrayOfItemRewards( out first : array< SItemReward >, second : array< SItemReward > )
	{
		var i, s : int;
		s = second.Size();
		for( i = 0; i < s; i += 1 )
		{
			first.PushBack( second[ i ] );
		}
	}
	
	function PlayOpenSoundEvent()
	{
		
		
	}
	
	private function GetEpTextureName( epIndex : int ) : string
	{
		var audio, subtitles : string;
		var path : string;

		path = "img://icons/quests/ep_logos/";

		theGame.GetGameLanguageName( audio, subtitles );
		switch ( subtitles )
		{
		case "PL":
			return path + "ep" + epIndex + "_logo_pl.png";
		case "CZ":
			return path + "ep" + epIndex + "_logo_cz.png";
		case "RU":
			return path + "ep" + epIndex + "_logo_ru.png";
		case "ZH":
			return path + "ep" + epIndex + "_logo_ch.png";
		case "EN":
		default:
			return path + "ep" + epIndex + "_logo_en.png";
		}
		return "";	
	}
}
