
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ZBarcodeScannerViewController"
#import "ZBarScanner.h"
#import "ZBarSDK.h"

@interface ZBarScanner () <ZBarReaderDelegate>

@end

@implementation ZBarScanner

NSString* callbackId;
SystemSoundID _soundFileObject;
bool isScannerActive = false;

- (void)startScanning:(CDVInvokedUrlCommand*)command
{
    callbackId = command.callbackId;
    NSDictionary *options = [command.arguments objectAtIndex: 0];
    [self.commandDelegate runInBackground:^{
        if(!isScannerActive)
        {
            //ZBarReaderViewController *reader = [ZBarReaderViewController new];
            ZBarcodeScannerViewController *reader = [ZBarcodeScannerViewController new];
            reader.readerDelegate = self;
            reader.supportedOrientationsMask = ZBarOrientationMaskAll;
            reader.showsZBarControls = false;
            UIView *scannerOverlayView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];

            scannerOverlayView.autoresizesSubviews = YES;
            scannerOverlayView.autoresizingMask    = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            scannerOverlayView.opaque              = NO;

            /*UIToolbar* toolbar = [[UIToolbar alloc] init];
            toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
            [toolbar setBarStyle:UIBarStyleBlack];
            toolbar.translucent = YES;
            id cancelButton = [[UIBarButtonItem alloc]
                               initWithTitle: options[@"cancelText"]
                               style: UIBarButtonItemStylePlain
                               target:(id)self
                               action:@selector(cancelButtonPressed:)
                               ];
            toolbar.items = [NSArray arrayWithObjects:cancelButton, nil];
            toolbar.tintColor = [UIColor whiteColor];
            [toolbar sizeToFit];
            CGFloat toolbarHeight  = [toolbar frame].size.height;
            CGFloat rootViewHeight = CGRectGetHeight(scannerOverlayView.bounds);
            CGFloat rootViewWidth  = CGRectGetWidth(scannerOverlayView.bounds);
            CGRect  rectArea       = CGRectMake(0, rootViewHeight - toolbarHeight, rootViewWidth, toolbarHeight);
            [toolbar setFrame:rectArea];
            [scannerOverlayView addSubview: toolbar];*/

            UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(scannerOverlayView.frame.size.width/2 - 32, scannerOverlayView.frame.size.height - 64 , 64, 64)];
            [btnCancel setImage:[UIImage imageNamed:@"cancel-scanning.png"] forState:UIControlStateNormal];
            [btnCancel addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            btnCancel.tintColor = [UIColor blackColor];
            [scannerOverlayView addSubview:btnCancel];

            int laserViewMargin = 20;
            UIView* laserView = [[UIView alloc] initWithFrame:CGRectMake(laserViewMargin, scannerOverlayView.frame.size.height/2 - laserViewMargin, scannerOverlayView.frame.size.width - laserViewMargin * 2, 3)];
            laserView.backgroundColor = [UIColor greenColor];
            laserView.layer.shadowColor = laserView.backgroundColor.CGColor;
            laserView.layer.shadowOffset = CGSizeMake(0.10, 0.10);
            laserView.layer.shadowOpacity = 0.6;
            laserView.layer.shadowRadius = 1.5;
            laserView.alpha = 0.6;
            if (![[scannerOverlayView subviews] containsObject:laserView]) [scannerOverlayView addSubview:laserView];

            //[UIView animateWithDuration:0.2 animations:^{
                //laserView.alpha = 1.0;
            //}];

            reader.cameraOverlayView = scannerOverlayView;

            ZBarImageScanner *scanner = reader.scanner;

            [scanner setSymbology: ZBAR_I25
                           config: ZBAR_CFG_ENABLE
                               to: 0];

            CFURLRef soundFileURLRef  = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("ZBarScanner.bundle/beep"), CFSTR ("caf"), NULL);
            AudioServicesCreateSystemSoundID(soundFileURLRef, &_soundFileObject);

            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.viewController presentViewController:reader animated:YES completion:nil];
            });
            isScannerActive = true;

            /*[UIView animateWithDuration:4.0 delay:0.0 options: UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionCurveEaseInOut animations:^{
             NSLog(@"animating...");
             laserView.frame = CGRectMake(0, scannerOverlayView.frame.size.height, scannerOverlayView.frame.size.width, 3);
             } completion:^(BOOL done){
             laserView.frame = CGRectMake(0, 0, scannerOverlayView.frame.size.width, 3);
             }];*/
        }
    }];
}

- (void)cancelButtonPressed:(id)sender
{
    //dispatch_sync(dispatch_get_main_queue(), ^{
      //[self.viewController dismissViewControllerAnimated:YES completion:nil];
      [self.viewController dismissModalViewControllerAnimated: YES];
    //});
    [self sendResult: @"canceled"];
}

- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // just grab the first barcode
        break;

    AudioServicesPlaySystemSound(_soundFileObject);
    NSLog(@"result: %@", symbol.data);
    [self sendResult: symbol.data];

    //dispatch_sync(dispatch_get_main_queue(), ^{
        //[reader dismissViewControllerAnimated:NO completion:nil];
        [reader dismissModalViewControllerAnimated: YES];
    //});
}

- (void)sendResult:(NSString*) str
{
    //NSMutableDictionary *jsonObj = [[NSMutableDictionary alloc] init];
    //[jsonObj setValue: str forKey: @"text"];
    //CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:jsonObj];
    isScannerActive = false;
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:str];
    [self.commandDelegate sendPluginResult:result callbackId: callbackId];
}

- (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;

    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }

    return topController;
}


- (void)dealloc
{
    AudioServicesRemoveSystemSoundCompletion(_soundFileObject);
    AudioServicesDisposeSystemSoundID(_soundFileObject);
}

@end
