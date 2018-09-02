




#import "Person.h"



String* AllPersonSetting_toData(AllPersonSetting setting)
{
	MutableString* result = [MutableString create:100];

	[result appendNS:@"Person Sorting\n"];	
	if (setting.personSorting == PersonSorting_NameAndBalance) [result appendNS:@"name and balance"];
	if (setting.personSorting == PersonSorting_BalanceAndName) [result appendNS:@"balance and name"];
	[result appendNS:@"\n"];
			
	[result appendNS:@"Exclude No Record\n"];	
	[result appendNS:(setting.excludeNoRecord) ? @"Yes" : @"No"];
	[result appendNS:@"\n"];

	return [result seal];
}

AllPersonSetting AllPersonSetting_fromData(String* data)
{
	AllPersonSetting result;
	result.personSorting = PersonSorting_NameAndBalance;
	result.excludeNoRecord = NO;

		
	StringList* allLine = [data split:STR(@"\n")];
	ForEachIndex(i, allLine)
	{
		for (Int j = 0; [allLine isValidIndex:j + 1]; j += 2)
		{
			String* key = [allLine at:j + 0];
			String* value = [allLine at:j + 1];
			
			if ([key eqNS:@"Person Sorting"])
			{
				if ([value eqNS:@"name and balance"]) result.personSorting = PersonSorting_NameAndBalance;
				if ([value eqNS:@"balance and name"]) result.personSorting = PersonSorting_BalanceAndName;
			}
			
			if ([key eqNS:@"Exclude No Record"])
			{
				if ([value eqNS:@"Yes"]) result.excludeNoRecord = Yes;
				if ([value eqNS:@"No"]) result.excludeNoRecord = No;
			}
		}
	}
	
	return result;
}







OBJECT_LIST_IMPLEMENTATION_TEMPLATE(Balance)
OBJECT_LIST_IMPLEMENTATION_TEMPLATE(Person)
OBJECT_LIST_IMPLEMENTATION_TEMPLATE(Record)


@implementation Balance

	+ (Balance*) create :(Int)i :(Double)v :(Bool)h
	{
		Balance* result = [[[Balance alloc] init] autorelease];
		result->my_prID = i;
		result->my_value = v;
		result->my_hasRecord = h;
		return result;
	}	
	
	- (void) dealloc
	{
		[super dealloc];
	}
	
	
	- (Int) prID
	{
		return my_prID;
	}
	
	- (Double) value
	{
		return my_value;
	}
	
	- (Bool) hasRecord
	{
		return my_hasRecord;
	}

@end


@implementation BalanceList(_)


	- (NubleBalance) findFirstByPRID:(Int)prID
	{
		ForEachIndex(i, self)
		{
			Balance* balance = [self at:i];
			if (balance.prID == prID)
				return Balance_toNuble(balance);
		}
		
		return Balance_nuble();
	}
	
	- (NubleDouble) findFirstValueByPRID:(Int)prID
	{
		ForEachIndex(i, self)
		{
			Balance* balance = [self at:i];
			if (balance.prID == prID)
				return Double_toNuble(balance.value);
		}
		
		return Double_nuble();
	}
	
	- (NubleInt) findFirstIndexByPRID:(Int)prID
	{
		ForEachIndex(i, self)
		{
			Balance* balance = [self at:i];
			if (balance.prID == prID)
				return Int_toNuble(i);
		}
		
		return Int_nuble();
	}
	
			
	- (Int) numberOfDigitAfterDecimalPoint
	{
		Int result = 0;
		
		ForEachIndex(i, self)
		{
			Balance* balance = [self at:i];			
			Int num = Double_numberOfDigitAfterDecimalPoint(balance.value, currencyPrecision());
			result = Int_max(result, num);
		}
		
		return result;		
	}

	
@end




@implementation Person
	
	+ (Person*) create :(Int)i :(String*)fn :(String*)ln
	{
		return [Person create :i :fn :ln :NSData_nuble()];
	}
	
	+ (Person*) create :(Int)i :(String*)fn :(String*)ln :(NubleNSData)im
	{
		Person* result = [[[Person alloc] init] autorelease];
		result->my_prID = i;
		result->my_firstName = [[fn toSealed] retain];
		result->my_lastName = [[ln toSealed] retain];
		
		if (im.hasVar)
			result->my_image = UIImage_toNuble([[UIImage imageWithData:im.vd] retain]);
		else
			result->my_image = UIImage_nuble();

		return result;
	}
	
	- (void) dealloc
	{
		[my_firstName release];
		[my_lastName release];
		
		if (my_image.hasVar)
			[my_image.vd release];
		
		[super dealloc];
	}
	
	- (Int) prID { return my_prID; }
	
	- (String*) firstName { return my_firstName; }
	
	- (String*) lastName { return my_lastName; }
		
	- (NubleUIImage) image
	{
		return my_image;
	}
	

	- (String*) name :(NameFormat)nameFormat
	{
		MutableString* result = [MutableString create:20];
		
		if (nameFormat == NameFormat_LastNameAndFirstName)
		{
			[result append:self.lastName];
			[result append:STR(@" ")];
			[result append:self.firstName];
		}
		else
		{
			[result append:self.firstName];
			[result append:STR(@" ")];
			[result append:self.lastName];
		}
		
		return [result seal];
	}			

	- (Bool) eq:(Person*)other
	{
		if (self.prID != other.prID) return No;
		if ([self.firstName eq:other.firstName] == No) return No;
		if ([self.lastName eq:other.lastName] == No) return No;
		return Yes;
	}

@end


@implementation PersonList(_)

	- (NublePerson) findByPRID:(Int)prID
	{
		ForEachIndex(i, self)
		{
			Person* person = [self at:i];
			if (person.prID == prID)
				return Person_toNuble(person);
		}
		
		return Person_nuble();
	}
	
	- (NubleInt) findFirstIndexByPRID:(Int)prID
	{
		ForEachIndex(i, self)
		{
			Person* person = [self at:i];
			if (person.prID == prID)
				return Int_toNuble(i);
		}
		
		return Int_nuble();		
	}
	
	- (Bool) containPerson:(Person*)person
	{
		ForEachIndex(i, self)
		{
			if ([[self at:i] eq:person])
				return Yes;
		}
		
		return No;
	}
	
	
	- (CGFloat) maxImageWidth
	{
		CGFloat result = 0.0f;
		
		ForEachIndex(i, self)
		{
			NubleUIImage image = [self at:i].image;
			
			if (image.hasVar) 
			{
				CGFloat w = image.vd.size.width;
				if (w > result)
					result = w;
			}
		}
		
		return result;
	}
	
	- (PersonList*) findAll:(Person_Predicate)predicate
	{
		PersonMutableList* result = [PersonMutableList create:10];
		
		ForEachIndex(i, self)
		{
			Person* person = [self at:i];
			if (predicate(person))
				[result append:person];
		}
		
		return [result seal];
	}
	
	
@end






@implementation Record


	+ (Record*) create :(Int)key :(String*)n :(Double)a :(DT2001)dt
	{
		return [Record create :key :No :n :a :dt];
	}
	
	+ (Record*) create :(Int)key :(Bool)i :(String*)n :(Double)a :(DT2001)dt
	{
		Record* result = [[[Record alloc] init] autorelease];
		result->my_key = key;
		result->my_hasImage = i;
		result->my_name = [[n toSealed] retain];
		result->my_amount = a;
		result->my_dateTime = dt;
		return result;
	}
	
	- (void) dealloc
	{
		[my_name release];
		[super dealloc];
	}
	
	
	- (Int) key { return my_key; }
	
	- (Bool) hasImage { return my_hasImage; }
	
	- (String*) name { return my_name; }
	
	- (Double) amount { return my_amount; }

	- (DT2001) dateTime { return my_dateTime; }
	

	- (Bool) eq :(Record*)other
	{
		if (self.key != other.key) return No;
		if (self.dateTime != other.dateTime) return No;
		if ([self.name eq:other.name] == No) return No;
		if (self.amount != other.amount) return No;
		return Yes;
	}

@end


@implementation RecordList(_)

	- (Double) balance
	{
		Double result = 0.0;
		
		ForEachIndex(i, self)
		{
			Record* record = [self at:i];
			result += record.amount;
		}
		
		return result;
	}
	
	- (Int) newKey
	{
		Int max = 0 - 1;
		ForEachIndex(i, self)
		{
			Record* record = [self at:i];
			max = Int_max(max, record.key);
		}
		
		return max + 1;
	}

	- (Int) numberOfDigitAfterDecimalPoint
	{
		Int result = 0;
		
		ForEachIndex(i, self)
		{
			Record* record = [self at:i];
			Int num = Double_numberOfDigitAfterDecimalPoint(record.amount, currencyPrecision());
			result = Int_max(result, num);
		}
		
		return result;		
	}

	
	
	- (NubleRecord) findFirstByKey :(Int)key
	{
		ForEachIndex(i, self)
		{
			Record* record = [self at:i];
			if (record.key == key)
				return Record_toNuble(record);
		}
		
		return Record_nuble();
	}

	- (NubleInt) findFirstIndexByKey :(Int)key
	{
		ForEachIndex(i, self)
		{
			Record* record = [self at:i];
			if (record.key == key)
				return Int_toNuble(i);
		}
		
		return Int_nuble();
	}
	

	- (String*) toData :(Int)precision :(NubleRecord)exceptRecord
	{
		MutableString* result = [MutableString create:10];
		
		ForEachIndex(i, self)
		{		
			Record* record = [self at:i];
			
			if (exceptRecord.hasVar)
				if (record == exceptRecord.vd)
					continue;
			
			[result append:STR(@"k\t")];
			[result append:Int_print(record.key)];
			[result append:STR(@"\t")];

			[result append:STR(@"i\t")];
			[result append:Bool_print(record.hasImage)];
			[result append:STR(@"\t")];
			
			[result append:STR(@"n\t")];
			[result append:record.name];
			[result append:STR(@"\t")];
						
			[result append:STR(@"a\t")];
			[result append:Double_printFloating(record.amount, precision)];
			[result append:STR(@"\t")];

			[result append:STR(@"d\t")];
			[result append:DT2001_printYMDHM(record.dateTime)];
			[result append:STR(@"\t")];			
			
			[result append:STR(@"\n")];
		}
		
		return [result seal];
	}
	
	+ (RecordList*) fromData:(String*)data
	{
		RecordMutableList* result = [RecordMutableList create];
		
		StringList* allLine = [data split:STR(@"\n")];
		ForEachIndex(i, allLine)
		{
			String* line = [allLine at:i];
			if (line.length == 0)
				continue;
			
			Bool i = No;
			NubleInt k = Int_nuble();
			NubleDT2001 d = DT2001_nuble();
			NubleString n = String_nuble();
			NubleDouble a = Double_nuble();
			
			StringList* allItem = [line split:STR(@"\t")];
			for (Int j = 0; j < allItem.count - 1; j += 2)
			{
				String* key = [allItem at:j + 0];
				String* value = [allItem at:j + 1];
				
				if ([key eq:STR(@"k")]) k = Int_parse(value);
				if ([key eq:STR(@"i")]) i = Bool_varOr(Bool_parse(value), i);
				if ([key eq:STR(@"n")]) n = String_toNuble(value);
				if ([key eq:STR(@"a")]) a = Double_parse(value);
				if ([key eq:STR(@"d")]) d = DT2001_parse(value);
			}
			
			if (k.hasVar && n.hasVar && a.hasVar && d.hasVar)
			{
				Record* record = [Record create :k.vd :i :n.vd :a.vd :d.vd];
				[result append:record];
			}
		}
		
		return [result seal];
	}
	
@end

@implementation RecordMutableList(_)

	- (void) sortByDateTimeRevOrder
	{
		[self mergeSort:^(Record* x, Record* y) 
		{
			NubleBool result = nubleNot(DT2001_isSmallerXY(x.dateTime, y.dateTime)); 			
			return (result.hasVar) ? result : nubleNot(Int_isSmallerXY(x.key, y.key));
		}];
	}

@end































