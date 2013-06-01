//
//  ImageViewController.m
//  SPoT
//
//  Created by David Muñoz Fernández on 18/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "ImageViewController.h"
#import "NetworkManager.h"
#import "NSDataCache.h"

@interface ImageViewController () <UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarButton;

@end

@implementation ImageViewController


// ---------------------------------------
//  -- Controller
// ---------------------------------------
#pragma mark - Controller

#define MAX_ZOOM_SCALE 4.0

- (void) viewDidLoad
{
    [super viewDidLoad];
    // Establece el título del barButton en iPad con el título del controlador
    self.titleBarButton.title = self.title;
    // Añade la imagen al scrollview
    [self.scrollView addSubview:self.imageView];
    // Establece las opciones de zoom del scrollview
    self.scrollView.maximumZoomScale = MAX_ZOOM_SCALE;
    self.scrollView.delegate = self;
    // Recarga la imagen
    [self reloadImage];
}

// Invocado acada vez que se cambia la geometría de la pantalla
- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setZoomOptionsToScrollView];
}


// ---------------------------------------
//  -- Protocol UIScrollViewDelegate
// ---------------------------------------
#pragma mark - Protocol UIScrollViewDelegate

// Devuelve la vista que será escalada
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

// ---------------------------------------
//  -- Privated methods
// ---------------------------------------
#pragma mark - privated methods

// Establece las opciones de zoom del scrollview
- (void) setZoomOptionsToScrollView
{
    // Obtiene el zoom minimo para ver toda la imagen a lo alto y ancho
    if (self.imageView.image) {
        float heigthZoomMin = self.scrollView.bounds.size.height / self.imageView.image.size.height;
        float widhtZoomMin = self.scrollView.bounds.size.width / self.imageView.image.size.width;
        
        // Establece el zoom mínimo al mismo tamaño (así nunca aparecerán blancos)
        self.scrollView.minimumZoomScale = MAX(widhtZoomMin, heigthZoomMin);
        // Escala la imagen al zoom mas grande para no dejar espacios en blanco
        self.scrollView.zoomScale = MAX(widhtZoomMin, heigthZoomMin);
    }
}


#define QUEUE_IMAGE_FETCHER "image fetcher"

// Carga la imagen
- (void) reloadImage
{
    if (self.imageURL){
        // Pone en marcha el relojito del activity indicator
        [self.activityIndicator startAnimating];
        
        // Restea el tamaño del scrollview y la imagen
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        // Obtiene el contenido de la imagen desde la URL (en otro thread)
        dispatch_queue_t imageFetcherQ = dispatch_queue_create(QUEUE_IMAGE_FETCHER, NULL);
        dispatch_async(imageFetcherQ, ^{
            // Comprueba si existe la imagen en la cache
            NSData *imageData = [[NSDataCache sharedNSDataCache] getData:self.imageURL];
            if (!imageData){
                [NetworkManager downloadStarted];
                imageData = [NSData dataWithContentsOfURL:self.imageURL];
                [NetworkManager downloadFinished];
                // Guarda la imagen en la cache
                [[NSDataCache sharedNSDataCache] addData:imageData withKey:self.imageURL];
            }
            UIImage *image = [UIImage imageWithData:imageData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // A ejecutar en el trhead principal (Cambios UI)
                if (image){
                    // Establece el tamaño del scrollview al de la imagen
                    self.scrollView.contentSize = image.size;
                    // Establece el tamaño de la vista de la imagen al de la imagen, y lo situa en el punto (0,0)
                    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                    self.imageView.image = image;
                    
                    [self setZoomOptionsToScrollView];
                }
                // Actualizada UI tras la descarga -> para el spinner activity indicator
                [self.activityIndicator stopAnimating];
            });
        });
    }
}

// ---------------------------------------
//  -- Getters/Setters methods
// ---------------------------------------
#pragma mark - getters/setters methods

- (UIImageView *) imageView
{
    if (!_imageView){
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end
