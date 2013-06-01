//
//  ImageViewController.m
//  SPoT
//
//  Created by David Muñoz Fernández on 18/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ImageViewController


// ---------------------------------------
//  -- Controller
// ---------------------------------------
#pragma mark - Controller

#define MAX_ZOOM_SCALE 4.0
#define MIN_ZOOM_SCALE 0.05

- (void) viewDidLoad
{
    [super viewDidLoad];
    // Añade la imagen al scrollview
    [self.scrollView addSubview:self.imageView];
    // Establece las opciones de zoom del scrollview
    self.scrollView.maximumZoomScale = MAX_ZOOM_SCALE;
    self.scrollView.minimumZoomScale = MIN_ZOOM_SCALE;
    self.scrollView.delegate = self;
    // Recarga la imagen
    [self reloadImage];
}

// Invocado acada vez que se cambia la geometría de la pantalla
- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Obtiene el zoom minimo para ver toda la imagen a lo alto y ancho
    float heigthZoomMin = self.scrollView.bounds.size.height / self.imageView.image.size.height;
    float widhtZoomMin = self.scrollView.bounds.size.width / self.imageView.image.size.width;
    
    // Escala la imagen al zoom mas grande para no dejar espacios en blanco
    self.scrollView.zoomScale = MAX(widhtZoomMin, heigthZoomMin);
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

// Carga la imagen
- (void) reloadImage
{
    // Restea el tamaño del scrollview y la imagen
    self.scrollView.contentSize = CGSizeZero;
    self.imageView.image = nil;
    
    // Obtiene el contenido de la imagen desde la URL
    NSData *imageData = [NSData dataWithContentsOfURL:self.imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    if (image){
        // Establece el tamaño del scrollview al de la imagen
        self.scrollView.contentSize = image.size;
        // Establece el tamaño de la vista de la imagen al de la imagen, y lo situa en el punto (0,0)
        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        self.imageView.image = image;
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
