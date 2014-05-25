//
//  AESymptomDataBaseManager.m
//  AutoExpert
//
//  Created by Solo on 5/25/14.
//  Copyright (c) 2014 Opensoft. All rights reserved.
//

#import "AESymptomDataBaseManager.h"

#define NEW_SYPMTOM_STRING @"Symptom"
#define SYMPTOM_INDEX_STRING @"Index:"
#define SYMPTOM_CATEGORY_STRING @"Category:"
#define SYMPTOM_NAME_STRING @"Name:"
#define SYMPTOM_CAUSES_STRING @"Causes:"
#define SYMPTOM_MODELS_STRING @"Models:"

#define SEPARATOR @";"




static AESymptomDataBaseManager *sharedDataManager = nil;

@implementation AESymptomDataBaseManager
+ (id)sharedManager {
    if(sharedDataManager == nil)
        sharedDataManager = [[AESymptomDataBaseManager alloc] init];
    return sharedDataManager;
}

- (id)init{
    if( self = [super init]){
        [self loadSymptoms];
    }
    return self;
}

- (void)loadSymptoms{
    NSLog(@"Loading symptoms database..");
    self.symptoms = [[NSMutableArray alloc] init];
    
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SymptomsDataBase" ofType:@"txt"];
    if ([filemgr fileExistsAtPath: path ] == YES)
//        NSLog (@"File exists %@", path );
        ;
    else
        NSLog (@"File not found");
    
    NSString *dataBase = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    // first, separate by new line
    NSArray* allLinedStrings = [dataBase componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for(int i = 0; i < [allLinedStrings count]; i++){
        if([[allLinedStrings objectAtIndex:i] isEqualToString:NEW_SYPMTOM_STRING]){
            int index = [[allLinedStrings objectAtIndex:i + 2] intValue];
//            NSLog(@"index : %d", index);
            int categoryIndex = [AESymptomDataBaseManager symptomCategoryIndexForName:[allLinedStrings objectAtIndex:i + 4]];
//            NSLog(@"Category : %d", categoryIndex);
            NSString *name = [allLinedStrings objectAtIndex:i + 6];
//            NSLog(@"Name : %@",name);
            NSArray *causes = [[allLinedStrings objectAtIndex:i + 8] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:SEPARATOR]];
//            NSLog(@"Causes[0] : %@", causes[0]);
            
            NSArray *models = [[allLinedStrings objectAtIndex:i + 10] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:SEPARATOR]];
//            NSLog(@"Models[0] : %@", models[0]);
            
            [self.symptoms addObject:[[AESymptom alloc] initWithName:name
                                                               index:index
                                                       categoryIndex:categoryIndex
                                                              causes:causes
                                                              models:models]];
            i += 10;
        }
    }
    
    NSLog(@"Symptoms loaded");
}

+ (SymptomCategoryIndex)symptomCategoryIndexForName:(NSString *)name{
    SymptomCategoryIndex result = 0;
    for(int i = 0; i < NUMBER_OF_SYMPTOM_CATEGORIES; ++i){
        if([name isEqualToString:[AESymptomDataBaseManager nameForSymptomCategoryIndex:i]]){
            result = i;
        }
    }
    return result;
}

+ (NSString *)nameForSymptomCategoryIndex:(SymptomCategoryIndex)symptomCategoryIndex{
    NSString *result;
    switch (symptomCategoryIndex) {
        case engine:
            result = @"Двигатель";
            break;
        case coolingSystem:
            result = @"Система охлаждения";
            break;
        case fuelSystem:
            result = @"Топливная система";
            break;
        case clutch:
            result = @"Сцепление";
            break;
        case transmission:
            result = @"Коробка передач";
            break;
        case suspension:
            result = @"Подвеска";
            break;
        case steering:
            result = @"Рулевое управление";
            break;
            
        default:
            break;
    }
    return result;
}

+ (NSMutableArray *)symptomCategoriesArray{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(int i = 0; i < NUMBER_OF_SYMPTOM_CATEGORIES; ++i){
        [result addObject:[AESymptomDataBaseManager nameForSymptomCategoryIndex:i]];
    }
    return result;
}

- (NSMutableArray *)symptomsForCategoryIndex:(SymptomCategoryIndex)index{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(AESymptom *symptom in self.symptoms){
        if(symptom.categoryIndex == index){
            [result addObject:symptom];
        }
    }
    return result;
}

- (AESymptom *)symptomForName:(NSString *)name{
    for (AESymptom *symptom in self.symptoms){
        if([symptom.name isEqualToString:name]){
            return symptom;
        }
    }
    NSLog(@"-symptomForName ERROR: symptom '%@' not found", name);
    return nil;
}

@end