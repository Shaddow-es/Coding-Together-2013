//
//  SetCardView.m
//  SuperSetCard
//
//  Created by David Muñoz Fernández on 17/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

// ---------------------------------------
//  -- Constantes
// ---------------------------------------

#define ROUNDED_CARD_RADIUS 13.0    // Tamaño en grados de los bordes redondeados de la carta

// ---------------------------------------
//  -- UIView lifecycle methods
// ---------------------------------------
#pragma mark - UIView lifecycle methods

- (void)drawRect:(CGRect)rect
{
    // Dibuja el fondo de la carta (blanco)
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:ROUNDED_CARD_RADIUS];
    [roundedRect addClip]; //no dibuja fuera de los bordes redondeados
    
    // Color de fondo según si está seleccionada
    if (self.isSelected){
        [[UIColor lightGrayColor] setFill];
    } else {
        [[UIColor whiteColor] setFill];
    }
    UIRectFill(self.bounds);
    // Borde negro
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    [self drawSetCard];
}
// ---------------------------------------
//  -- Private methods
// ---------------------------------------
#pragma mark - Private methods

// Dibuja la carta
- (void)drawSetCard
{
    switch (self.symbol) {
        case SetCardSymbolTypeDiamond:
            [self drawDiamond];
            break;
        case SetCardSymbolTypeSquiggle:
            [self drawSquiggle];
            break;
        case SetCardSymbolTypeOval:
            [self drawOval];
            break;
    }
}

#define SQUIGGLE_LONG_DIAGONAL_DELTA_X_RATIO 0.594
#define SQUIGGLE_DIAGONAL_DELTA_Y_RATIO 0.12
#define SQUIGGLE_SHORT_DIAGONAL_DELTA_X_RATIO 0.462
#define SQUIGGLE_CONTROL_DELTA_X_RATIO 0.132
#define SQUIGGLE_CONTROL_DELTA_Y_RATIO 0.16
#define SQUIGGLE_LINE_WIDTH 2.0

- (void)drawSquiggle
{
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGSize shortDiagonal = CGSizeMake(middle.x * SQUIGGLE_SHORT_DIAGONAL_DELTA_X_RATIO, middle.y * SQUIGGLE_DIAGONAL_DELTA_Y_RATIO);
    CGSize longDiagonal = CGSizeMake(middle.x * SQUIGGLE_LONG_DIAGONAL_DELTA_X_RATIO, middle.y * SQUIGGLE_DIAGONAL_DELTA_Y_RATIO);
    CGPoint point1 = CGPointMake(middle.x - longDiagonal.width, middle.y - longDiagonal.height);
    CGPoint point2 = CGPointMake(middle.x + shortDiagonal.width, middle.y - shortDiagonal.height);
    CGPoint point3 = CGPointMake(middle.x + longDiagonal.width, middle.y + longDiagonal.height);
    CGPoint point4 = CGPointMake(middle.x - shortDiagonal.width, middle.y + shortDiagonal.height);
    CGSize controlDelta = CGSizeMake(middle.x * SQUIGGLE_CONTROL_DELTA_X_RATIO, middle.y * SQUIGGLE_CONTROL_DELTA_Y_RATIO);
    CGPoint curve1cp1 = CGPointMake(point1.x+controlDelta.width, point1.y-controlDelta.height);
    CGPoint curve1cp2 = CGPointMake(point2.x-controlDelta.width, point2.y+controlDelta.height);
    CGPoint curve2cp1 = CGPointMake(point2.x+controlDelta.width, point2.y-controlDelta.height);
    CGPoint curve2cp2 = CGPointMake(point3.x+controlDelta.width, point3.y-controlDelta.height);
    CGPoint curve3cp1 = CGPointMake(point3.x-controlDelta.width, point3.y+controlDelta.height);
    CGPoint curve3cp2 = CGPointMake(point4.x+controlDelta.width, point4.y-controlDelta.height);
    CGPoint curve4cp1 = CGPointMake(point4.x-controlDelta.width, point4.y+controlDelta.height);
    CGPoint curve4cp2 = CGPointMake(point1.x-controlDelta.width, point1.y+controlDelta.height);
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    path.lineWidth = SQUIGGLE_LINE_WIDTH;
    [path moveToPoint:point1];
    [path addCurveToPoint:point2 controlPoint1:curve1cp1 controlPoint2:curve1cp2];
    [path addCurveToPoint:point3 controlPoint1:curve2cp1 controlPoint2:curve2cp2];
    [path addCurveToPoint:point4 controlPoint1:curve3cp1 controlPoint2:curve3cp2];
    [path addCurveToPoint:point1 controlPoint1:curve4cp1 controlPoint2:curve4cp2];
    [path closePath];
    
    [self repeatSymbols:path];
}

#define OVAL_CONTROL_WIDTH_RATIO 0.75
#define OVAL_HEIGHT_RATIO 0.20
#define OVAL_LINE_WITDH_RATIO 0.40
#define OVAL_LINE_WIDTH 2.0

- (void)drawOval
{
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGSize delta = CGSizeMake(middle.x * OVAL_LINE_WITDH_RATIO, middle.y * OVAL_HEIGHT_RATIO);
    CGSize control = CGSizeMake(middle.x * OVAL_CONTROL_WIDTH_RATIO, middle.y * OVAL_HEIGHT_RATIO);
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    path.lineWidth = OVAL_LINE_WIDTH;
    [path moveToPoint:CGPointMake(middle.x + delta.width, middle.y - delta.height)];
    [path addCurveToPoint:CGPointMake(middle.x + delta.width, middle.y + delta.height) controlPoint1:CGPointMake(middle.x + control.width , middle.y - control.height) controlPoint2:CGPointMake(middle.x + control.width , middle.y + control.height)];
    [path addLineToPoint:CGPointMake(middle.x - delta.width, middle.y + delta.height)];
    [path addCurveToPoint:CGPointMake(middle.x - delta.width, middle.y - delta.height) controlPoint1:CGPointMake(middle.x - control.width, middle.y + control.height) controlPoint2:CGPointMake(middle.x - control.width, middle.y - control.height)];
    [path closePath];
    
    [self repeatSymbols:path];
}

#define SYMBOL_HEIGHT_RATIO 0.20
#define SYMBOL_WIDTH_RATIO 0.66
#define DIAMOND_LINE_WIDTH 2.0

- (void)drawDiamond
{
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGSize delta = CGSizeMake(middle.x * SYMBOL_WIDTH_RATIO, middle.y * SYMBOL_HEIGHT_RATIO);
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    path.lineWidth = DIAMOND_LINE_WIDTH;
    [path moveToPoint:CGPointMake(middle.x, middle.y + delta.height)];
    [path addLineToPoint:CGPointMake(middle.x + delta.width, middle.y)];
    [path addLineToPoint:CGPointMake(middle.x, middle.y - delta.height)];
    [path addLineToPoint:CGPointMake(middle.x - delta.width, middle.y)];
    [path closePath];
    
    [self repeatSymbols:path];
}

// Obtiene el color de las figura
- (UIColor *) getColor
{
    UIColor *color;
    switch (self.color) {
        case SetCardColorTypeGreen:
            color = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0];
            break;
        case SetCardColorTypeRed:
            color = [UIColor redColor];
            break;
        case SetCardColorTypePurple:
            color = [UIColor purpleColor];
            break;
    }
    return color;
}

#define SYMBOL_OFFSET_RATIO 0.28

// Dibuja los símbolos de la figura
- (void)repeatSymbols:(UIBezierPath *)path
{
    // Obtiene el color de la figura
    UIColor *symbolStrokecolor = [self getColor];
    [symbolStrokecolor setStroke];
    
    // Color en formato array de CGFloat para el dibujar el patrón
    CGFloat symbolFillColor[4];
    [symbolStrokecolor getRed:&symbolFillColor[0] green:&symbolFillColor[1] blue:&symbolFillColor[2] alpha:&symbolFillColor[3]];
    
    // Establece el relleno en función del tipo
    switch (self.shade) {
        case SetCardShadeTypeStriped:
            patternPainting(symbolFillColor);
            break;
        case SetCardShadeTypeSolid:
            [symbolStrokecolor setFill];
            break;
        default:
            break;
    }
    
    // Dibuja las figuras
    CGFloat verticalOffset = self.bounds.size.height*SYMBOL_OFFSET_RATIO;
    switch (self.number) {
        case 2: {
            [self drawSymbol:path verticalOffset:-verticalOffset/2];
            [self drawSymbol:path verticalOffset:verticalOffset];
            break;
        } case 3: {
            [self drawSymbol:path verticalOffset:-verticalOffset];
            [self drawSymbol:path verticalOffset:verticalOffset];
            [self drawSymbol:path verticalOffset:verticalOffset];
            break;
        } default: {
            [self drawSymbol:path verticalOffset:0];
            break;
        }
    }
}

- (void)drawSymbol:(UIBezierPath *)path verticalOffset:(CGFloat)verticalOffset
{
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, verticalOffset);
    [path applyTransform:transform];
    [path stroke];
    [path fill];
}


// ---------------------------------------
// -- Dibujando con patrones - Funciones C
// ---------------------------------------

#define PATTERN_WIDTH 8.0
#define PATTERN_HEIGHT 1.0
#define PATTERN_PAINTED_WIDTH 3.0

// Patrón de dibujo (rallado)
static void drawPattern (void *info, CGContextRef context)
{
    CGFloat *fillColorRGBcomponents = info;
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextSetRGBFillColor (context, *fillColorRGBcomponents++, *fillColorRGBcomponents++, *fillColorRGBcomponents++, *fillColorRGBcomponents);
    CGContextFillRect(context, CGRectMake(0.0, 0.0, PATTERN_PAINTED_WIDTH, PATTERN_HEIGHT));
    CGContextFillPath(context);
}

// Pinta el relleno en base a un patrón
void patternPainting (void *info)
{
    CGPatternRef pattern;
    CGColorSpaceRef patternSpace;
    static const CGPatternCallbacks callbacks = {0, &drawPattern, NULL};
    
    patternSpace = CGColorSpaceCreatePattern (NULL);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorSpace (context, patternSpace);
    CGColorSpaceRelease (patternSpace);
    
    CGFloat alpha = 1.0; // opaque pattern
    
    pattern = CGPatternCreate(info, CGRectMake(0, 0, PATTERN_WIDTH, PATTERN_HEIGHT),
                              CGAffineTransformIdentity, PATTERN_WIDTH, PATTERN_HEIGHT,
                              kCGPatternTilingConstantSpacing,
                              true, &callbacks);
    CGContextSetFillPattern (context, pattern, &alpha);
    CGPatternRelease (pattern);
}

// ---------------------------------------
//  -- Getters & Setters
// ---------------------------------------
#pragma mark - Getters & Setters

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setSymbol:(SetCardSymbolType)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setShade:(SetCardShadeType)shade
{
    _shade = shade;
    [self setNeedsDisplay];
}

- (void)setColor:(SetCardColorType)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self setNeedsDisplay];
}
@end
