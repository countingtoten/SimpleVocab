//
//  SimpleVocabAPIConstants.h
//  SimpleVocab
//
//  Created by James Weinert on 6/4/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#define WORDNIK_API_KEY @"bd96bdcc1a0e2abe410050b634807facc67143ae8e00d7267"

#define kDefaultQueueIdentifier "com.weinertworks.queue"

#define kPartsOfSpeechArrayInOrderOfImportance ([NSArray arrayWithObjects:@"noun", @"verb", @"adjective", @"adverb", nil])

#define kDefaultFontSize        20
#define kFlashCardFrontFontSize  40
#define kFlashCardCornerRadius  25
#define kFlashCardBackTextBorder  10
#define kFlashCardEdgeBorder    20

// Hint Text
#define kAddWordToListText  @"Add a word to the list"

// Developer Information
#define kDeveloperWebsite   @"http://www.vocablistcreator.com"
#define kDeveloperEmail     @"support@vocablistcreator.com"
#define kDeveloperTwitter   @"@VocabLists"

// View Titles
#define kSearchTitleText        @"Dictionary"
#define kWordListsTitleText     @"Word Lists"
#define kSelectFlashCardsTitleText  @"Select Flash Cards"
#define kContactTitleText       @"Contact"

// Cell Texts
#define kAddListCellText        @"Add New List"
#define kDefaultListCellText    @"Recent Words"
#define kBlankCellText          @"Unnamed Word List"
#define kEmailCellText          @"Email"
#define kTwitterCellText        @"Twitter"
#define kWebCellText            @"Web"

// Segues
#define kSearchToDefinitionSegue        @"WordDefinitionFromSearchSegue"
#define kListToListContentsSegue        @"ListContentsSegue"
#define kDefinitionToListContentsSegue  @"WordDefinitionFromListContentsSegue"
#define kDefinitionToListModalSegue     @"ListModalViewSegue"
#define kFlashToFlashSelectSegue        @"FlashCardsSelect"

// Cell Identifiers
#define kSearchResultsCellIdentifier    @"SearchResultsCell"
#define kListCellIdentifier             @"ListCell"
#define kAddListCellIdentifier          @"AddListCell"
#define kListContentsCellIdentifier     @"ListContentsCell"
#define kFlashCardSelectCellIdentifier  @"FlashCardCell"
#define kWebSiteCellIdentifier          @"ContactWebsiteCell"
#define kEmailCellIdentifier            @"ContactEmailCell"
#define kTwitterCellIdentifier          @"ContactTwitterCell"

// Core Data
// App Settings
#define kAppSettingsEntityName      @"Settings"
#define kAddWordToList              @"showAddWordToList"
#define kEditWordList               @"showEditWordList"

// SearchBarContents
#define kSearchBarEntityName    @"SearchBarContents"
#define kSearchStringKey        @"savedSearchString"
#define kSearchWasActiveKey     @"searchWasActive"

// Word
#define kWordEntityName @"Word"
#define kWordKey        @"word"
#define kCountKey       @"lookupCount"

// List
#define kListEntityName @"List"
#define kListKey        @"listName"

// AllLists
#define kAllListsEntityName @"AllLists"

// Status Messages
#define kStatusCopiedCoreDataFile   @"Status 1: Vocab List database copied to documents directory"

// Error Messages
#define kErrorCoreDataLoad              @"Error 1: unable to load data %@ %@"
#define kErrorCoreDataSave              @"Error 2: unable to save Vocab List %@ %@"
#define kErrorPersistentStore           @"Error 3: unable to open Vocab List data %@ %@"
#define kErrorSearchBarContentsLoad     @"Error 4: unable to load serach history"
#define kErrorSearchBarContentsSave     @"Error 5: unable to save serach history"
#define kErrorSettingsLoad              @"Error 6: unable to load app settings"
#define kErrorSettingsSave              @"Error 7: unable to save app settings"

#define kErrorFlashCardLoad             @"Error 8: unable to read flash card %@ %@"

#define kErrorCommitAdd                 @"Error 9: unable to add list %@ %@"
#define kErrorCommitDelete              @"Error 10: unable to delete list %@ %@"
#define kErrorCommitEditTemplate        @"Error 11: unable to edit list in template %@ %@"
#define kErrorCommitEditView            @"Error 12: unable to edit list in view %@ %@"
#define kErrorCommitEditModal           @"Error 13: unable to edit list modal view %@ %@"
#define kErrorCommitEditContents        @"Error 14: unable to edit list contents view %@ %@"

#define kErrorWordCountSave             @"Error 15: unable to save word count %@ %@"
