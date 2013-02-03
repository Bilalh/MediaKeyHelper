//
//  MediaKeys.m
//  MediaKeys Helper Plus
//
//  Copyright 2012 Bilal Syed Hussain
//  Licensed under the Apache License, Version 2.0
//
//

#import "MediaKeys.h"

@implementation MediaKeys

+ (void) toogle
{
    NSString *s;
    if ([self isFluidAppRunning]){ // playpause.scpt
        s = @"osascript -e \'activate application \"Anime\"\' -e \'tell application \"System Events\"\' -e \'\' -e \'set boundss to \"\"\' -e \'tell application \"Anime\"\' -e \'set boundss to get bounds of window 1\' -e \'end tell\' -e \'\' -e \'tell process \"Anime\"\' -e \'set com to \"/usr/local/bin/cliclick  \" & (get (item 1 of boundss) + 38) & \" \" & (get (item 4 of boundss) - 15)\' -e \'do shell script com\' -e \'end tell\' -e \'\' -e \'\' -e \'\' -e \'end tell\'";
    }else if ([self isMPlayerRunning] || [self processIsRunning:@"mpv"] || [self processIsRunning:@"mplayer2"]){
        s = @"echo 'pause' > ~/.mplayer/pipe";
    }else{
        return;
    }
    system([s UTF8String]);

}

+ (void) next
{
    NSString *s;
    if ([self isFluidAppRunning] ){ // clickhide.scpt
        s =@"osascript -e \'activate application \"Anime\"\' -e \'tell application \"System Events\"\' -e \'\' -e \'set boundss to \"\"\' -e \'tell application \"Anime\"\' -e \'set boundss to get bounds of window 1\' -e \'end tell\' -e \'\' -e \'tell process \"Anime\"\' -e \'set com to \"/usr/local/bin/cliclick -r \" & (get (item 1 of boundss) + 38) & \" \" & (get (item 4 of boundss) - 15)\' -e \'do shell script com\' -e \'\' -e \'keystroke \"h\" using {command down}\' -e \'end tell\' -e \'\' -e \'end tell\'";
    }else if ([self isMPlayerRunning] || [self processIsRunning:@"mpv"] || [self processIsRunning:@"mplayer2"]){
        s = @"echo 'pt_step 1' > ~/.mplayer/pipe";
    }
    
    system([s UTF8String]);
}

+ (void) previous
{
    NSString *s;
    if ([self isFluidAppRunning]){ // back.scpt
        s = @"osascript -e \'activate application \"Anime\"\' -e \'tell application \"System Events\"\' -e \'\' -e \'set boundss to \"\"\' -e \'tell application \"Anime\"\' -e \'set boundss to get bounds of window 1\' -e \'end tell\' -e \'\' -e \'tell process \"Anime\"\' -e \'set com to \"/usr/local/bin/cliclick \" & (get (item 1 of boundss) + 15) & \" \" & (get (item 4 of boundss) - 15)\' -e \'do shell script com\' -e \'end tell\' -e \'\' -e \'\' -e \'\' -e \'end tell\'";
    }else if ([self isMPlayerRunning] || [self processIsRunning:@"mpv"] || [self processIsRunning:@"mplayer2"]){
        s = @"echo 'pt_step -1' > ~/.mplayer/pipe";
    }
    
    system([s UTF8String]);
    
}

+ (BOOL) isFluidAppRunning
{
    return [self isAppRunning:@"com.fluidapp.FluidApp.Anime"];
}

+ (BOOL) isMPlayerRunning
{
    return [self isAppRunning:@"com.google.code.mplayerosx-builds.git"]
        || [self isAppRunning:@"org.mpv-player.standalone"];
}

// Method to see if fluid is running
+ (BOOL) isAppRunning:(NSString*)name
{
    NSArray* ra = [NSRunningApplication runningApplicationsWithBundleIdentifier:name];
    if([ra count]){
        return true;
    }else{
        return false;
    }
    
}

// from http://collinhenderson.com/post/23804377536/cocoa-snippet-check-if-process-is-running
+(BOOL)processIsRunning:(NSString *)aProcess{
    NSTask* task = [[NSTask alloc] init];
    [task setLaunchPath: @"/usr/bin/top"];
    
    NSArray* arguments = [NSArray arrayWithObjects: @"-s", @"1",@"-l",@"3600",@"-stats",@"pid,cpu,time,command", nil];
    
    [task setArguments: arguments];
    
    NSPipe* pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    [task setStandardInput:[NSPipe pipe]];
    
    [task launch];
    
    NSData* processData = [[[task standardOutput]fileHandleForReading]availableData];
    NSString* processes = [[NSString alloc]initWithData:processData encoding:NSUTF8StringEncoding];
    if ([processes rangeOfString:aProcess].location != NSNotFound) {
        return TRUE;
    }
    else {
        return FALSE;
    }
}

@end
