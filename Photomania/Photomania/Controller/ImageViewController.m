//
//  ImageViewController.m
//  Shutterbug
//
//  Created by David Muñoz Fernández on 01/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation ImageViewController

// ---------------------------------------
//  -- Controller
// ---------------------------------------
#pragma mark - Controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    // establece las propiedades necesarias para hacer zoom en scrollview
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
    // resetea la imagen
    [self resetImage];
}


// ---------------------------------------
//  -- Private methods
// ---------------------------------------
#pragma mark - Private Methods

- (void) resetImage
{
    if (self.scrollView) {
        // resetea el scrollview y el imageview
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        [self.spinner startAnimating];
        NSURL *imageURL = self.imageURL;
        dispatch_queue_t imageFetcherQ = dispatch_queue_create("image fetcher", NULL);
        dispatch_async(imageFetcherQ, ^{
            [NSThread sleepForTimeInterval:2.0];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            if (self.imageURL == imageURL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image) {
                        // La imagen se ha cargado correctamente
                        //self.scrollView.zoomScale = 1.0;
                        self.scrollView.contentSize = image.size;
                        self.imageView.image = image;
                        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                        // Escala la imagen para mostrar el máximo alto posible
                        CGRect imgHeightFrame = CGRectMake(0, 0, 0, image.size.height);
                        // Escala la imagen para mostrar el máximo alto posible
                        [self.scrollView zoomToRect:imgHeightFrame animated:NO];
                    }
                    [self.spinner stopAnimating];
                });
            }
        });
    }
}

// ---------------------------------------
//  -- Protocol UIScrollViewDelegate
// ---------------------------------------
#pragma mark - Protocol UIScrollViewDelegate

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

// ---------------------------------------
//  -- Getters & Setters
// ---------------------------------------
#pragma mark - Getters & Setters

- (void) setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}

- (UIImageView *) imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imageView;

}

@end
