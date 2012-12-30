#import "MenubarController.h"
#import "PanelController.h"
#import "SPMediaKeyTap.h"

@interface ApplicationDelegate : NSObject <NSApplicationDelegate, PanelControllerDelegate>{
    SPMediaKeyTap *keyTap;
}

@property (nonatomic, strong) MenubarController *menubarController;
@property (nonatomic, strong, readonly) PanelController *panelController;

- (IBAction)togglePanel:(id)sender;

@end
