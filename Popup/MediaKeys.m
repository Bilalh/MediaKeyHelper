//
//  MediaKeys.m
//  MediaKeys Helper Plus
//
//  Copyright 2012-2013 Bilal Syed Hussain
//  Licensed under the Apache License, Version 2.0
//
//

#import "MediaKeys.h"


static int mplayer_paused()
{
	FILE *fd;
	const char filename[] = "/Users/bilalh/.mplayer/output";
	const long max_len = 150+ 1;
	char buff[max_len + 1];
    
	if ((fd = fopen(filename, "rb")) != NULL)  {
		fseek(fd, -max_len, SEEK_END);
		fread(buff, max_len-1, 1, fd);
		fclose(fd);
        
		buff[max_len-1] = '\0';
		char *last_newline = strrchr(buff, '\n');
		char *last_line = last_newline+1;
		
		int res = strncmp("ANS_pause=", last_line, 10);
		printf("captured: [%s], %d\n", last_line, res);
		if (res == 0){
			bool paused = (last_line[10] == 'y');
			printf("paused %d\n", paused);
			return paused;
		}
	}
	return -1;
}


@implementation MediaKeys

+ (void) toogle
{
    if ([self isFluidAppRunning]){ // playpause.scpt
        char *s = "osascript -e \'activate application \"Anime\"\' -e \'tell application \"System Events\"\' -e \'\' -e \'set boundss to \"\"\' -e \'tell application \"Anime\"\' -e \'set boundss to get bounds of window 1\' -e \'end tell\' -e \'\' -e \'tell process \"Anime\"\' -e \'set com to \"/usr/local/bin/cliclick  \" & (get (item 1 of boundss) + 38) & \" \" & (get (item 4 of boundss) - 15)\' -e \'do  shell script com\' -e \'end tell\' -e \'\' -e \'\' -e \'\' -e \'end tell\'";
        system(s);
    }else if (  [self isMPlayerRunning] || [self isMPVRunning] || [self processIsRunning:@"mpv"]
             || [self processIsRunning:@"mplayer2"]){
        system("echo 'get_property pause'  > ~/.mplayer/pipe ");
        usleep(10);
        
        int paused = mplayer_paused();
        // toogle pause
        usleep(100 );
        system("echo 'pause' > ~/.mplayer/pipe");
        
        // hide/unhide as needed
        if (paused == 1){
            system("osascript -e \'tell application \"Finder\" to set visible of process \"mpv\" to true\'");
        }else if (paused == 0){
            system("osascript -e \'tell application \"Finder\" to set visible of process \"mpv\" to false\'");
        }
        
    }
}

+ (void) toogleWithCommand
{
    NSString *s;
    if (  [self isMPlayerRunning] || [self isMPVRunning] || [self processIsRunning:@"mpv"]
       || [self processIsRunning:@"mplayer2"]){
        s = @"echo 'cycle ontop' > ~/.mplayer/pipe";
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
    }else if ([self isMPVRunning]) {
        s = @"echo 'seek 10' > ~/.mplayer/pipe";

    }else if ([self isMPlayerRunning] || [self processIsRunning:@"mpv"] || [self processIsRunning:@"mplayer2"]){
        s = @"echo 'pt_step 1' > ~/.mplayer/pipe";
    }
    
    system([s UTF8String]);
}

+ (void) nextWithShift
{
    NSString *s;
    if ([self isMPVRunning]) {
        s = @"echo 'seek 30' > ~/.mplayer/pipe";
        
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
    }else if ([self isMPVRunning]) {
        s = @"echo 'seek -10' > ~/.mplayer/pipe";
        
    }else if ([self isMPlayerRunning] || [self processIsRunning:@"mpv"] || [self processIsRunning:@"mplayer2"]){
        s = @"echo 'pt_step -1' > ~/.mplayer/pipe";
    }
    
    system([s UTF8String]);
    
}

+ (void) previousWithShift
{
    NSString *s;
    if ([self isMPVRunning]) {
        s = @"echo 'seek -30' > ~/.mplayer/pipe";
        
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
    return [self isAppRunning:@"com.google.code.mplayerosx-builds.git"];
}
+ (BOOL) isMPVRunning
{
    return [self isAppRunning:@"io.mpv"];
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
