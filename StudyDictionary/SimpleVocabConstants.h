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

// Developer Information
#define kDeveloperWebsite   @"http://www.simplevocablists.com"
#define kDeveloperEmail     @"support@simplevocablists.com"
#define kDeveloperTwitter   @"@test"

// Error Messages

// Default Cell Texts
#define kAddListText        @"Add New List"
#define kDefaultListText    @"Recent Words"
#define kBlankListText      @"Unnamed Word List"

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