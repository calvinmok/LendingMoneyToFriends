



#import "FileSys.h"


Bool Path_isAbsolute(String* path)
{
	SELFTEST_START
		ASSERT(Path_isAbsolute(STR(NSHomeDirectory())));
	SELFTEST_END
	
	return [path.ns isAbsolutePath];
}


String* Path_combine(String* path, String* component)
{
	SELFTEST_START
	
	[Path_combine(STR(@"aaa"), STR(@"bbb")) assert:@"aaa/bbb"];
	[Path_combine(STR(@"aaa"), STR(@"/bbb")) assert:@"aaa/bbb"];
	[Path_combine(STR(@"aaa/"), STR(@"bbb")) assert:@"aaa/bbb"];
	[Path_combine(STR(@"aaa/"), STR(@"/bbb")) assert:@"aaa/bbb"];
	[Path_combine(STR(@"/aaa"), STR(@"bbb")) assert:@"/aaa/bbb"];
	[Path_combine(STR(@"/aaa"), STR(@"/bbb")) assert:@"/aaa/bbb"];
	[Path_combine(STR(@"/aaa/"), STR(@"bbb")) assert:@"/aaa/bbb"];
	[Path_combine(STR(@"/aaa/"), STR(@"/bbb")) assert:@"/aaa/bbb"];
	[Path_combine(STR(@"aaa"), STR(@"bbb/")) assert:@"aaa/bbb"];
	[Path_combine(STR(@"aaa"), STR(@"/bbb/")) assert:@"aaa/bbb"];
	[Path_combine(STR(@"aaa/"), STR(@"bbb/")) assert:@"aaa/bbb"];
	[Path_combine(STR(@"aaa/"), STR(@"/bbb/")) assert:@"aaa/bbb"];
	[Path_combine(STR(@"/aaa"), STR(@"bbb/")) assert:@"/aaa/bbb"];
	[Path_combine(STR(@"/aaa"), STR(@"/bbb/")) assert:@"/aaa/bbb"];
	[Path_combine(STR(@"/aaa/"), STR(@"bbb/")) assert:@"/aaa/bbb"];
	[Path_combine(STR(@"/aaa/"), STR(@"/bbb/")) assert:@"/aaa/bbb"];
	
	SELFTEST_END
	
	NSString* p = path.ns;
	NSString* c = component.ns;

	NSString* result = [p stringByAppendingPathComponent:c];
	return STR(result);	
}


String* Path_parent(String* path)
{
	return STR([path.ns stringByDeletingLastPathComponent]);
}









PathType FileManager_getPathType(String* path)
{
	ASSERT(Path_isAbsolute(path));
	
	BOOL isDir;
	BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:path.ns isDirectory:&isDir];	
	
	if (exist)
		return (isDir) ? PathType_Directory : PathType_File;
	else 
		return PathType_NotExist;		
}


StringList* FileManager_getAllItemShallow(String* path)
{
	ASSERT(Path_isAbsolute(path));

	NSError* error;
		
	NSArray* array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path.ns error:&error];
	
	StringMutableList* result = [StringMutableList create:[array count]];
	
	if (array == nil)
		return result;
	
	for (NSUInteger i = 0; i < [array count]; i++)
	{
		NSString* item = (NSString*)[array objectAtIndex:i];
		[result append:STR(item)];
	}
	
	return result;		
}

StringList* FileManager_getAllItemDeeply(String* path)
{
	ASSERT(Path_isAbsolute(path));

	StringMutableList* result = [StringMutableList create];
	
	NSDirectoryEnumerator* enumerator = [[NSFileManager defaultManager] enumeratorAtPath:path.ns];
	
	for (String* file; (file = STR([enumerator nextObject])); ) 
		[result append:file];
	
	return [result seal];	
}



Bool FileManager_createDirectory(String* path)
{
	ASSERT(Path_isAbsolute(path));

	NSError* error;
	
	BOOL success = [[NSFileManager defaultManager] 
		createDirectoryAtPath       :path.ns
		withIntermediateDirectories :YES
		attributes                  :nil
		error                       :&error];
		
	return success;
}

Bool FileManager_writeFileByData(String* path, NSData* data)
{
	ASSERT(Path_isAbsolute(path));

	BOOL success = [[NSFileManager defaultManager]
		createFileAtPath:path.ns
		contents:data
		attributes:nil];
	
	return success;
}




Bool FileManager_writeFileByUTF8(String* path, String* data)
{
	ASSERT(Path_isAbsolute(path));

	NSError* error;
	
	BOOL success = [data.ns 
		writeToFile	:path.ns 
		atomically	:YES 
		encoding	:NSUTF8StringEncoding 
		error		:&error];
	
	return success;
}

String* FileManager_readFileByUTF8(String* path)
{
	ASSERT(Path_isAbsolute(path));
	
	NSError* error;
	NSString* result = [NSString stringWithContentsOfFile:path.ns encoding:NSUTF8StringEncoding error:&error];
	
	return STR(result);	
}





Bool FileManager_removeDeeply(String* path)
{	
	ASSERT(Path_isAbsolute(path));

	NSError* error;
	BOOL success = [[NSFileManager defaultManager] removeItemAtPath :path.ns error:&error];
		
	return success;
}


/*

void HomeFileSys_selfTest(void)
{	
	ASSERT(HomeFileSys_createDirectory(STR(@"MyAppSelfTest")) );
	
	[HomeFileSys_getAllItemDeeply(STR(@"MyAppSelfTest")).debugInfo assert:@""];

	ASSERT(HomeFileSys_writeFileByData(STR(@"MyAppSelfTest/a/a/a/1"), [NSData data]) == No);
	ASSERT(HomeFileSys_writeFileByData(STR(@"MyAppSelfTest/1"), [NSData data]));
	
	[HomeFileSys_getAllItemDeeply(STR(@"MyAppSelfTest")).debugInfo assert:@"1"];
		
	HomeFileSys_createDirectory(STR(@"MyAppSelfTest/a"));
	HomeFileSys_writeFileByData(STR(@"MyAppSelfTest/a/1"), [NSData data]);
	HomeFileSys_createDirectory(STR(@"MyAppSelfTest/a/a"));
	HomeFileSys_writeFileByData(STR(@"MyAppSelfTest/a/a/1"), [NSData data]);
	HomeFileSys_writeFileByData(STR(@"MyAppSelfTest/a/a/2"), [NSData data]);
	
	[HomeFileSys_getAllItemDeeply(STR(@"MyAppSelfTest")).debugInfo assert:@"1,a,a/1,a/a,a/a/1,a/a/2"];

	ASSERT(HomeFileSys_removeDeeply(STR(@"MyAppSelfTest/a")));
 
	[HomeFileSys_getAllItemDeeply(STR(@"MyAppSelfTest")).debugInfo assert:@"1"];



}
*/






@implementation PrivateFileSys


	
	+ (PrivateFileSys*) createFromDocuments:(String*)subBase
	{
		NSFileManager* fileManager = [NSFileManager defaultManager];
		
		NSArray* paths = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];

		ASSERT([paths count] > 0); 

		PrivateFileSys* result = [[[PrivateFileSys alloc] init] autorelease];		
		result->my_base = [Path_combine(STR([[paths objectAtIndex:0] path]), subBase) retain];
		return result;					
	}
	
	
	- (void) dealloc
	{
		[my_base release];
		[super dealloc];
	}
	
	
	- (StringList*) getAllItemDeeply
	{
		return FileManager_getAllItemDeeply(my_base);
	}
	
	- (StringList*) getAllItemShallow
	{
		return FileManager_getAllItemShallow(my_base);
	}
		
	
	- (PathType) getPathType :(String*)path
	{
		return FileManager_getPathType(Path_combine(my_base, path));
	}
	
	
	
	- (Bool) createDirectory:(String*)path
	{
		return FileManager_createDirectory(Path_combine(my_base, path));
	}
	
	
	
	- (String*) readFile :(String*)path
	{
		return FileManager_readFileByUTF8(Path_combine(my_base, path));
	}
	
	- (void) writeFile :(String*)path :(String*)data
	{
		FileManager_writeFileByUTF8(Path_combine(my_base, path), data);
	}
	
	
	
	- (NSData*) readData :(String*)path
	{
		return [NSData dataWithContentsOfFile:Path_combine(my_base, path).ns];		
	}
	
	- (void) writeData :(String*)path :(NSData*)data
	{
		[data writeToFile:Path_combine(my_base, path).ns atomically:YES];
	}
	
	
	
	- (void) removeDeeply :(String*)path
	{
		FileManager_removeDeeply(Path_combine(my_base, path));
	}
    
    - (void) removeAll
    {
		FileManager_removeDeeply(my_base);
    }
    

@end






