//
//  KitchenSinkViewController.m
//  KitchenSink
//
//  Created by David Muñoz Fernández on 10/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "KitchenSinkViewController.h"
#import "AskerViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "CMMotionManager+Shared.h"

@interface KitchenSinkViewController () <UIActionSheetDelegate,
UIImagePickerControllerDelegate, UINavigationControllerDelegate,
UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *kitchenSink;
// weak pq todos los NSTimer tienen un puntero strong por el sistema
//  (al igual que los uicontrol por los storyboard)
@property (weak, nonatomic) NSTimer *drainTimer;
// Para evitar en el ipad que se puedan abrir más de un actionsheet
@property (weak, nonatomic) UIActionSheet *sinkControlActionSheet;
@property (strong, nonatomic) UIPopoverController *imagePickerPopover;

@end

@implementation KitchenSinkViewController

#define SINK_CONTROL @"Controles de la cesta"
#define SINK_CONTROL_STOP_DRAIN @"Parar vaciado"
#define SINK_CONTROL_UNSTOP_DRAIN @"Continuar vaciado"
#define SINK_CONTROL_CANCEL @"Cancelar"
#define SINK_CONTROL_EMPTY @"Cesta vacía"

- (IBAction)controlSink:(UIBarButtonItem *)sender {
    if (!self.sinkControlActionSheet) {
        // Según si está el timer funcionando o no, se muestra el mensaje de parar vaciado o arrancarlo
        NSString *drainButton = self.drainTimer ? SINK_CONTROL_STOP_DRAIN : SINK_CONTROL_UNSTOP_DRAIN;
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:SINK_CONTROL
                                                                 delegate:self
                                                        cancelButtonTitle:SINK_CONTROL_CANCEL
                                                   destructiveButtonTitle:SINK_CONTROL_EMPTY
                                                        otherButtonTitles:drainButton, nil];
        [actionSheet showFromBarButtonItem:sender animated:YES];
        self.sinkControlActionSheet = actionSheet; 
    }
}

- (IBAction)takeFoodPhoto:(UIBarButtonItem *)sender {
    [self presentImagePicker:UIImagePickerControllerSourceTypeCamera sender:sender];
}

- (IBAction)addFoodPhoto:(UIBarButtonItem *)sender {
    [self presentImagePicker:UIImagePickerControllerSourceTypeSavedPhotosAlbum sender:sender];
}

- (void) presentImagePicker:(UIImagePickerControllerSourceType)sourceType sender:(UIBarButtonItem *)sender
{
    if (!self.imagePickerPopover && [UIImagePickerController isSourceTypeAvailable:sourceType]) {
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        if ([availableMediaTypes containsObject:(NSString *)kUTTypeImage]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = sourceType;
            picker.mediaTypes = @[(NSString *)kUTTypeImage];
            picker.allowsEditing = YES;
            picker.delegate = self;
            // muestra el picker
            if ((sourceType != UIImagePickerControllerSourceTypeCamera) &&
                (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
                // popover
                self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:picker];
                [self.imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                self.imagePickerPopover.delegate = self;
            } else {
                // modal
                [self presentViewController:picker animated:YES completion:nil];
            }
        }
    }
}

// Cancelado popover
- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePickerPopover = nil;
}

// Cancelado el modal de la selección de foto
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#define MAX_IMAGE_WIDTH 200

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    if (image) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        CGRect frame = imageView.frame;
        if (frame.size.width > MAX_IMAGE_WIDTH) {
            frame.size.height = (frame.size.height / frame.size.width) * MAX_IMAGE_WIDTH;
            frame.size.width = MAX_IMAGE_WIDTH;
        }
        imageView.frame = frame;
        [self setRandomLocationForView:imageView];
        [self.kitchenSink addSubview:imageView];
    }
    // cancela el picker de fotos
    if (self.imagePickerPopover) {
        // popover
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
    } else {
        // Modal
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        // Elimina todas las subvistas de la cesta (las comidas)
        [self.kitchenSink.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    } else {
        NSString *choice = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([choice isEqualToString:SINK_CONTROL_STOP_DRAIN]){
            [self stopDrainTimer];
        } else if ([choice isEqualToString:SINK_CONTROL_UNSTOP_DRAIN]){
            [self startDrainTimer];
        }
    }
}


#define DISH_CLEAN_INTERVAL 2.0

- (void) cleanDish
{
    // Si está en la pantalla
    if (self.kitchenSink.window) {
        [self addFood:nil];
        [self performSelector:@selector(cleanDish) withObject:nil afterDelay:DISH_CLEAN_INTERVAL];
    }
}


#define DRAIN_DURATION 3.0
#define DRAIN_DELAY 1.0

- (void) startDrainTimer
{
    self.drainTimer = [NSTimer scheduledTimerWithTimeInterval:DRAIN_DURATION/3 target:self selector:@selector(drain:) userInfo:nil repeats:YES];
}

// El método invocado por el selector de NSTimer siempre lleva un argumento (NSTimer)
- (void) drain:(NSTimer *)timer
{
    [self drain];
}

- (void) stopDrainTimer
{
    [self.drainTimer invalidate];
    self.drainTimer = nil;
}

- (void) viewDidAppear:(BOOL)animated
{
    // Importante arrancar los timers, coremotion solo cuando es visible
    [super viewDidAppear:animated];
    [self startDrainTimer];
    [self cleanDish];
    
    [self startDrift];
}

- (void) viewWillDisappear:(BOOL)animated
{
    // Importante parar los timers, coremotion cuando no va a ser visible
    [super viewWillDisappear:animated];
    [self stopDrainTimer];
    
    [self stopDrift];
}

#pragma mark - Drift

#define DRIFT_HZ 10
#define DRIFT_RATE 10

- (void) startDrift
{
    CMMotionManager *motionManager = [CMMotionManager sharedMotionManager];
    if ([motionManager isAccelerometerAvailable]) {
        [motionManager setAccelerometerUpdateInterval:1/DRIFT_HZ];
        [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *data, NSError *error) {
            for (UIView *view in self.kitchenSink.subviews) {
                CGPoint center = view.center;
                center.x += data.acceleration.x * DRIFT_RATE;
                center.y += data.acceleration.y * DRIFT_RATE;
                view.center = center;
                
                if (!CGRectContainsRect(self.kitchenSink.bounds, view.frame) &&
                    !CGRectIntersectsRect(self.kitchenSink.bounds, view.frame)) {
                    [view removeFromSuperview];
                }
            }
        }];
    }
}

- (void) stopDrift
{
    [[CMMotionManager sharedMotionManager] stopAccelerometerUpdates];
}

- (void) drain
{
    for (UIView *view in self.kitchenSink.subviews) {
        CGAffineTransform transform = view.transform;
        if (CGAffineTransformIsIdentity(transform)){
            // Queremos que gire 360º, por eso hacemos la transformación en 3 fases
            //  Con 1 fase el inicio y el fin sería el mismo lugar, por tanto no habría animación
            //  Con 2 fases una vez que estamos a mitad de la rotación, se podría ir al inicio por el mismo lado que vino
            //  Con 3 fases nos aseguramos que hace el giro completo y siempre en el mismo sentido
            [UIView animateWithDuration:DRAIN_DURATION delay:DRAIN_DELAY options:UIViewAnimationOptionCurveEaseIn animations:^{
                // 2*PI -> toda la cirfunferencia
                view.transform = CGAffineTransformRotate(CGAffineTransformScale(transform, 0.7, 0.7), 2*M_PI/3);
            } completion:^(BOOL finished) {
                if (finished) {
                    // Animamos el siguiente tercio (2/3)
                    [UIView animateWithDuration:DRAIN_DURATION delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        view.transform = CGAffineTransformRotate(CGAffineTransformScale(transform, 0.4, 0.4), -2*M_PI/3);
                    } completion:^(BOOL finished) {
                        if (finished) {
                            // Animamos el último tercio (3/3)
                            [UIView animateWithDuration:DRAIN_DURATION delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                                view.transform = CGAffineTransformScale(transform, 0.1, 0.1);
                            } completion:^(BOOL finished) {
                                if (finished) {
                                    // Elimina la vista
                                    [view removeFromSuperview];
                                }
                            }];
                        }
                    }];
                }
            }];
        }
    }
}


#define MOVE_DURATION 3.0

- (IBAction)tap:(UITapGestureRecognizer *)sender
{
    CGPoint tapLocation = [sender locationInView:self.kitchenSink];
    for (UIView *view in self.kitchenSink.subviews) {
        if (CGRectContainsPoint(view.frame, tapLocation)) {
            [UIView animateWithDuration:MOVE_DURATION delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self setRandomLocationForView:view];
                view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.99, 0.99);
            } completion: ^(BOOL finished){
                view.transform = CGAffineTransformIdentity;
                
            }];
        }
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Ask"]) {
        AskerViewController *asker = segue.destinationViewController;
        asker.question = @"¿Qué comida quieres en la cesta?";
    }
}

- (IBAction) cancelAsking:(UIStoryboardSegue *)segue
{
}

- (IBAction) doneAsking:(UIStoryboardSegue *)segue
{
    AskerViewController *asker = segue.sourceViewController;
    [self addFood:asker.answer];
    NSLog(@"%@", asker.answer);
}


#define BLUE_FOOD @"Gelatina"
#define GREEN_FOOD @"Lechuga"
#define ORANGE_FOOD @"Naranja"
#define RED_FOOD @"Tomate"
#define PURPLE_FOOD @"Berenjena"
#define BROWN_FOOD @"Patata"

- (void) addFood:(NSString *)food
{
    UILabel *foodLabel = [[UILabel alloc] init];
    
    // Diccionario estático con un listado de comidas y colores
    static NSDictionary *foods = nil;
    if (!foods) {
        foods = @{ BLUE_FOOD: [UIColor blueColor],
                   GREEN_FOOD: [UIColor greenColor],
                   ORANGE_FOOD: [UIColor orangeColor],
                   RED_FOOD: [UIColor redColor],
                   PURPLE_FOOD: [UIColor purpleColor],
                   BROWN_FOOD: [UIColor brownColor] };
    }
    
    if (![food length]){
        // No se ha elegido comida, selecciona una aleatoria y le asocia el color
        food = [[foods allKeys] objectAtIndex:arc4random()%[foods count]];
        foodLabel.textColor = [foods objectForKey:food];
    }
    
    foodLabel.text = food;
    foodLabel.font = [UIFont systemFontOfSize:46];
    foodLabel.backgroundColor = [UIColor clearColor];
    
    // Tamaño intrínseco de la vista al contenido del botón
    [foodLabel sizeToFit];
    
    [self setRandomLocationForView:foodLabel];
    [self.kitchenSink addSubview:foodLabel];
}

- (void) setRandomLocationForView:(UIView *)view
{
    // Establece el tamaño y la posición del botón (aleatoria)
    CGRect sinkBounds = CGRectInset(self.kitchenSink.bounds, view.frame.size.width/2, view.frame.size.height/2);
    CGFloat x = arc4random() % (int) sinkBounds.size.width + view.frame.size.width/2;
    CGFloat y = arc4random() % (int) sinkBounds.size.height + view.frame.size.height/2;
    view.center = CGPointMake(x, y);
}

@end
