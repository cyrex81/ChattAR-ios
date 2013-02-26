//
//  ChatPointsStorage.m
//  Chattar
//
//  Created by kirill on 2/26/13.
//
//

#import "ChatPointsStorage.h"

@implementation ChatPointsStorage

-(void)showFriendsDataFromStorage{
    NSMutableArray *friendsIds = [[[DataManager shared].myFriendsAsDictionary allKeys] mutableCopy];
    [friendsIds addObject:[DataManager shared].currentFBUserId];// add me
    
    // Chat points
    //
    [[DataManager shared].chatPoints removeAllObjects];
    //
    // add only friends QB points
    for(UserAnnotation *mapAnnotation in [DataManager shared].allChatPoints){
        if([friendsIds containsObject:[mapAnnotation.fbUser objectForKey:kId]]){
            [[DataManager shared].chatPoints addObject:mapAnnotation];
        }
    }
    [friendsIds release];
    //
    // add all checkins
    for(UserAnnotation *checkinAnnotatin in [DataManager shared].allCheckins){
        if(![[DataManager shared].chatPoints containsObject:checkinAnnotatin]){
            [[DataManager shared].chatPoints addObject:checkinAnnotatin];
        }
    }
}

-(void)showWorldDataFromStorage{
    [[DataManager shared].chatPoints removeAllObjects];
    //
    // 2. add Friends from FB
    [[DataManager shared].chatPoints addObjectsFromArray:[DataManager shared].allChatPoints];
    
    // add all checkins
    for(UserAnnotation *checkinAnnotatin in [DataManager shared].allCheckins){
        if(![[DataManager shared].chatPoints containsObject:checkinAnnotatin]){
            [[DataManager shared].chatPoints addObject:checkinAnnotatin];
        }
    }
}

-(void)refreshDataFromStorage{
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey: @"createdAt" ascending: NO] autorelease];
	NSArray* sortedArray = [[DataManager shared].chatPoints sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
	[[DataManager shared].chatPoints removeAllObjects];
	[[DataManager shared].chatPoints addObjectsFromArray:sortedArray];
}

-(UserAnnotation*)retrieveDataFromStorageWithIndex:(NSInteger)index{
    return [[DataManager shared].chatPoints objectAtIndex:index];
}

-(NSInteger)storageCount{
    return [DataManager shared].chatPoints.count;
}

-(void)addDataToStorage:(UserAnnotation *)newData{
    [[DataManager shared].chatPoints addObject:newData];
}

-(void)removeLastObjectFromStorage{
    if ([DataManager shared].chatPoints.count != 0) {
        [[DataManager shared].chatPoints removeLastObject];
    }
}

-(void)clearStorage{
    [[DataManager shared].allChatPoints removeAllObjects];
    [[DataManager shared].chatPoints removeAllObjects];
    [[DataManager shared].chatMessagesIDs removeAllObjects];
    
    [[DataManager shared].myFriends removeAllObjects];
    [[DataManager shared].myPopularFriends removeAllObjects];
    [[DataManager shared].myFriendsAsDictionary removeAllObjects];
}

-(void)insertObjectToAllData:(UserAnnotation *)object atIndex:(NSInteger)index{
    if (index >= 0 && index < [DataManager shared].allChatPoints.count) {
        [[DataManager shared].allChatPoints insertObject:object atIndex:index];
    }
}

-(void)insertObjectToPartialData:(UserAnnotation *)object atIndex:(NSInteger)index{
    if (index >= 0 && index < [DataManager shared].chatPoints.count) {
        [[DataManager shared].chatPoints insertObject:object atIndex:index];
    }
}

@end
