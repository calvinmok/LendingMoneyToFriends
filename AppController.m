





#import "AppController.h"






@implementation AppFileSys

	+ (AppFileSys*) create :(String*)base
	{
		AppFileSys* result = [[[AppFileSys alloc] init] autorelease];		
		result->my_fileSys = [[PrivateFileSys createFromDocuments:base] retain];
		return result;	
	}
	
	- (void) dealloc
	{
		[my_fileSys release];
		[super dealloc];
	}
	

	- (void) _writeAllItem :(String*)fileName :(StringList*)allNameItem
	{
		MutableString* result = [MutableString create:100];
		
		ForEachIndex(i, allNameItem)
		{
			if (result.length > 0)
				[result appendChar:CHAR(\n)];
				
			[result append:[allNameItem at:i]];
		}
		
		[my_fileSys writeFile :fileName :result];
	}
	
	- (StringMutableList*) _readAllItem :(String*)fileName
	{
		StringMutableList* result = [StringMutableList create];
		
		if ([my_fileSys getPathType:fileName] == PathType_File)
		{		
			String* data = [my_fileSys readFile :fileName];	
			StringList* allLine = [data split:STR(@"\n")];
		
			ForEachIndex(i, allLine)
			{
				String* line = [allLine at:i];
				[result append:line];
			}
		}
		
		return result;
	}



	- (void) writeSetting :(AllPersonSetting)allPersonSetting
	{
		String* data = AllPersonSetting_toData(allPersonSetting);
		[my_fileSys writeFile :STR(@"setting") :data];		
	}
	
	- (AllPersonSetting) readSetting
	{
		String* data = [my_fileSys readFile :STR(@"setting")];	
		return AllPersonSetting_fromData(data);
	}
		
	
	- (IntList*) readAllPRID
	{
		IntMutableList* result = [IntMutableList create];
		
		StringList* allItem = [my_fileSys getAllItemShallow];
		ForEachIndex(i, allItem)
		{
			String* item = [allItem at:i];
			if ([my_fileSys getPathType:item] != PathType_Directory)
				continue;
			
			NubleInt prID = Int_parse(item);
			if (prID.hasVar == No)
				continue;
			
			[result append:prID.vd];
		}
		
		return [result seal];		
	}
	
	
	- (void) writeImage :(Int)prID :(Int)recordKey :(UIImage*)original :(UIImage*)thumbnail
	{
		String* directory = Int_print(prID);
		
		if ([my_fileSys getPathType:directory] != PathType_Directory)
			[my_fileSys createDirectory:directory];
        
        {
            String* file = String_concat(Int_print(recordKey), STR(@"_original"));
            String* path = Path_combine(directory, file);
            NSData* data = UIImageJPEGRepresentation(original, 0.9f);
            [my_fileSys writeData :path :data];	
        }
        {
            String* file = String_concat(Int_print(recordKey), STR(@"_thumbnail"));
            String* path = Path_combine(directory, file);
            NSData* data = UIImageJPEGRepresentation(thumbnail, 0.5f);
            [my_fileSys writeData :path :data];	
        }
	}
		
	- (void) removeImage :(Int)prID :(Int)recordKey
	{
        {
            String* file = String_concat(Int_print(recordKey), STR(@"_original"));
            String* path = Path_combine(Int_print(prID), file);
		
            if ([my_fileSys getPathType:path] == PathType_File)
                [my_fileSys removeDeeply:path];
        }
        {
            String* file = String_concat(Int_print(recordKey), STR(@"_thumbnail"));
            String* path = Path_combine(Int_print(prID), file);
		
            if ([my_fileSys getPathType:path] == PathType_File)
                [my_fileSys removeDeeply:path];
        }
	}
    

	- (NubleUIImage) readOriginal :(Int)prID :(Int)recordKey
	{
		String* file = String_concat(Int_print(recordKey), STR(@"_original"));
		String* path = Path_combine(Int_print(prID), file);
				
		if ([my_fileSys getPathType:path] != PathType_File)
			return UIImage_nuble();
			
		NSData* data = [my_fileSys readData :path];
		return UIImage_toNuble([UIImage imageWithData:data]);	
	}    

	- (NubleUIImage) readThumbnail :(Int)prID :(Int)recordKey
	{
		String* file = String_concat(Int_print(recordKey), STR(@"_thumbnail"));
		String* path = Path_combine(Int_print(prID), file);
				
		if ([my_fileSys getPathType:path] != PathType_File)
			return UIImage_nuble();
			
		NSData* data = [my_fileSys readData :path];
		return UIImage_toNuble([UIImage imageWithData:data]);	
	}    
	
    
    
	
	- (void) writeAllRecord :(Int)prID :(RecordList*)allRecord :(NubleRecord)exceptRecord
	{
		String* directory = Int_print(prID);
		
		if ([my_fileSys getPathType:directory] != PathType_Directory)
			[my_fileSys createDirectory:directory];
		
		String* path = Path_combine(directory, STR(@"record"));
		String* data = [allRecord toData :currencyPrecision() :exceptRecord];		
		[my_fileSys writeFile :path :data];
	}

	- (RecordList*) readAllRecord :(Int)prID
	{
		String* path = Path_combine(Int_print(prID), STR(@"record"));

		String* data = String_empty();
		if ([my_fileSys getPathType:path] == PathType_File)
			data = [my_fileSys readFile:path];		
		
		return [RecordList fromData:data];
	}
	
	- (void) removePerson :(Int)prID
	{
		String* path = Int_print(prID);
		if ([my_fileSys getPathType:path] == PathType_Directory)
			[my_fileSys removeDeeply:path];
	}
	
	
	
	- (void) insertNameItem:(String*)item
	{
		StringMutableList* allItem = [self readAllNameItem];
		
		[allItem removeMatch:^(String* s) { return [s eq:item]; }];
		[allItem insert:item];
		
		while (allItem.count > 30) 
			[allItem removeLast];

		[self _writeAllItem :STR(@"name") :allItem];
	}
	
	- (void) removeNameItem:(String*)item
	{
		StringMutableList* allItem = [self readAllNameItem];		
		[allItem removeMatch:^(String* s) { return [s eq:item]; }];
		[self _writeAllItem :STR(@"name") :allItem];
	}
	
	- (StringMutableList*) readAllNameItem
	{	
		StringMutableList* result = [self _readAllItem :STR(@"name")];
		
		if (result.count == 0)
		{
			[result append:STR(@"The list will be updated after record is saved.")];
		}
		
		return result;
	}
	
	
	
	- (void) insertAmountItem:(String*)item
	{
		NubleDouble d = Double_parse(item);
		if (d.hasVar == NO)
			return;
		
		StringMutableList* allItem = [self readAllAmountItem];

		[allItem removeMatch:^(String* s) { return Double_parseEqual(s, d.vd); }];
		[allItem insert:item];
		
		while (allItem.count > 30) 
			[allItem removeLast];

		[self _writeAllItem :STR(@"amount") :allItem];
	}
	
	- (void) removeAmountItem:(String*)item
	{
		NubleDouble d = Double_parse(item);
		if (d.hasVar == NO)
			return;
			
		StringMutableList* allItem = [self readAllAmountItem];		
		[allItem removeMatch:^(String* s) { return Double_parseEqual(s, d.vd);; }];
		[self _writeAllItem :STR(@"amount") :allItem];
	}
		
	- (StringMutableList*) readAllAmountItem
	{
		StringMutableList* allItem = [self _readAllItem :STR(@"amount")];
		
		Int numberOfDigit = 0;
		DoubleMutableList* allNumber = [DoubleMutableList create];		
		ForEachIndex(i, allItem)
		{
			String* item = [allItem at:i];
			NubleDouble d = Double_parse(item);
			if (d.hasVar)
			{
				numberOfDigit = Int_max(numberOfDigit, Double_numberOfDigitAfterDecimalPoint(d.vd, currencyPrecision()));
				[allNumber append:d.vd];
			}
		}
		
		[allItem removeAll];
		
		ForEachIndex(i, allNumber)
		{
			Double d = [allNumber at:i];
			String* s = Double_printFixed(d, numberOfDigit);
			[allItem append:s];
		}

		return allItem;
	}
	
	

@end








@implementation AppController


	+ (AppController*) create 
	{
		AppController* result = [[[AppController alloc] init] autorelease];		
		[result _creating];
		return result;
	}

	- (void) _creating
	{
		my_fileSys = [[AppFileSys create:STR(@"1")] retain];
	
		my_ui = [[UI create :self :[my_fileSys readSetting]] retain];
		[my_ui setNameSetting :AddressBook_getNameSetting()];
	
		PersonList* abPersonList = [self readAllPersonFromAddressBook];
	
		BalanceMutableList* balanceList = [BalanceMutableList create];
		
		ForEachIndex(i, abPersonList)
		{
			Int prID = [abPersonList at:i].prID;
			RecordList* list = [my_fileSys readAllRecord:prID];
			Balance* balance = [Balance create :prID :list.balance :list.count > 0];
			[balanceList append:balance];
		}
		
		IntList* allPRID = [my_fileSys readAllPRID];
		ForEachIndex(i, allPRID)
		{
			Int prID = [allPRID at:i];
			if ([abPersonList findByPRID:prID].hasVar == No)
				[my_fileSys removePerson:prID];
		}		
		
		[my_ui updateAllPersonAndBalance :abPersonList :balanceList];
	}
	
	- (void) dealloc
	{
		[my_fileSys release];
		[my_ui release];
		[super dealloc];
	}



	- (void) reloadAddressBook
	{
		PersonList* abPersonList = [self readAllPersonFromAddressBook];
		
		Bool isChanged = (abPersonList.count != my_ui.originAllPersonCount);		
		if (isChanged == NO)
		{
			ForEachIndex(i, abPersonList)
			{
				Person* abPerson = [abPersonList at:i];
				NublePerson person = [my_ui findPersonByPRID:abPerson.prID];
				
				if (person.hasVar == No || [abPerson isEqual:person.vd] == No)
				{
					isChanged = Yes;
					break;					
				}
			}
		}
		
		[my_ui setNameSetting :AddressBook_getNameSetting()];
		
		if (isChanged)
		{
			[my_ui updateAllPerson :abPersonList];
			
			IntList* allPRID = [my_fileSys readAllPRID];
			ForEachIndex(i, allPRID)
			{
				Int prID = [allPRID at:i];
				if ([abPersonList findByPRID:prID].hasVar == NO)
					[my_fileSys removePerson:prID];
			}
		}
	}


	- (void) UI_clear
    {
        [my_fileSys->my_fileSys removeAll];
    }
	
	- (NubleUIImage) UI_readOriginal :(Person*)person :(Record*)record
	{
		ASSERT(record.hasImage);
		return [my_fileSys readOriginal :person.prID :record.key];
	}
    
	- (NubleUIImage) UI_readThumbnail :(Person*)person :(Record*)record
	{
		ASSERT(record.hasImage);
		return [my_fileSys readThumbnail :person.prID :record.key];
	}
	
    
	
	- (StringList*) UI_getAllNameItem
	{
		return [my_fileSys readAllNameItem];
	}
	
	- (StringList*) UI_getAllAmountItem
	{
		return [my_fileSys readAllAmountItem];
	}
		
	

	- (void) UI_allPersonSettingChanged:(AllPersonSetting)allPersonSetting
	{
		[my_fileSys writeSetting :allPersonSetting];
	}
		


	- (void) UI_personSelected
	{
		RecordList* recordList = [my_fileSys readAllRecord:my_ui.selectedPerson.vd.prID];
		[my_ui updateAllRecord:recordList];
	}
	
	- (void) UI_personUnselected 
	{

	}
	

	- (void) UI_recordSelected 
	{
	}
	
	- (void) UI_recordUnselected
	{
	}
	

	- (void) UI_recordSubmitted	
		:(NubleRecord)oldRecord 
        :(Bool)imageChanged :(NubleUIImage)original :(NubleUIImage)thumbnail 
        :(String*)name :(Double)amount :(DT2001)dateTime
	{
		Int prID = my_ui.selectedPerson.vd.prID;
        
        Bool hasImage = (original.hasVar && thumbnail.hasVar);
	
		Record* newRecord;
		
		if (oldRecord.hasVar)
		{
			if (imageChanged && oldRecord.vd.hasImage)
				[my_fileSys removeImage :prID :oldRecord.vd.key];
			
			newRecord = [Record create :oldRecord.vd.key :hasImage :name :amount :dateTime];
			[my_ui modifySingleRecordWithoutModifySingleRecordViewController:newRecord];
		}
		else
		{
			newRecord = [Record create :my_ui.allRecord.newKey :hasImage :name :amount :dateTime];
			[my_ui insertSingleRecord:newRecord];
		}
		
		Balance* newBalance = [Balance create :prID :my_ui.allRecord.balance :my_ui.allRecord.count > 0];
		[my_ui setSingleBalance :newBalance];
		
		[my_fileSys writeAllRecord :prID :my_ui.allRecord :Record_nuble()];
		
		if (imageChanged && hasImage)
			[my_fileSys writeImage :prID :newRecord.key :original.vd :thumbnail.vd];
			
		[my_fileSys insertNameItem:name];
		[my_fileSys insertAmountItem:Double_printFloating(amount, currencyPrecision())];
	}
    


	
	- (void) UI_recordDeleting:(Record*)record
	{
		Int prID = my_ui.selectedPerson.vd.prID;
		
		[my_fileSys writeAllRecord :prID :my_ui.allRecord :Record_toNuble(record)];
		
		if (record.hasImage)
			[my_fileSys removeImage :prID :record.key];

		[my_ui deleteSingleRecord:record];		

		Balance* balance = [Balance create :prID :my_ui.allRecord.balance :my_ui.allRecord.count > 0];
		[my_ui setSingleBalance :balance];
	}

	- (void) UI_itemDeleted :(RecordItemType)type :(String*)item
	{
		if (type == RecordItemType_Name)
			[my_fileSys removeNameItem:item];
		
		if (type == RecordItemType_Amount)
			[my_fileSys removeAmountItem:item];
	}




	- (PersonList*) readAllPersonFromAddressBook
	{
		PersonMutableList* result = [PersonMutableList create];
		
		AddressBookPersonList* list = [[AddressBook create] getAllPerson];
		ForEachIndex(i, list)
		{
			AddressBookPerson* abPerson = [list at:i];
			String* firstName = abPerson.firstName;
			String* lastName = abPerson.lastName;
			NubleNSData imageData = abPerson.imageData;
			
			Person* person = [Person create :abPerson.recordID :firstName :lastName :imageData];			
			[result append:person];
		}
		
		return result;
	}
	
	
@end






