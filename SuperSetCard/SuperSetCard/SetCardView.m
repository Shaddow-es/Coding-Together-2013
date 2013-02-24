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
    
    // Fondo blanco
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    // Borde negro
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    
    // Dibuja la figura
    switch (self.symbol) {
        case SetCardSymbolTypeDiamond:
            [self drawDiamond:CGPointMake([self horizontalSpace], [self verticalSpace])];
            break;
        case SetCardSymbolTypeSquiggle:
            [self drawSquiggle:CGPointMake([self horizontalSpace], [self verticalSpace])];
            break;
        case SetCardSymbolTypeOval:
            [self drawOval:CGPointMake([self horizontalSpace], [self verticalSpace])];
            break;
        default:
            break;
    }
}


// ---------------------------------------
//  -- Private methods
// ---------------------------------------
#pragma mark - Private methods

- (void)drawDiamond:(CGPoint)drawPoint
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:CGPointMake(drawPoint.x, drawPoint.y + ([self figureHeight] / 2) )];
    [path addLineToPoint:CGPointMake(drawPoint.x + ([self figureWidth] / 2), drawPoint.y + 0)];
    [path addLineToPoint:CGPointMake(drawPoint.x + [self figureWidth], drawPoint.y + ([self figureHeight] / 2) )];
    [path addLineToPoint:CGPointMake(drawPoint.x + ([self figureWidth] / 2), drawPoint.y + [self figureHeight])];
    
    [path closePath];
    [self setAttributesToDraw:path];
}


- (void)drawOval:(CGPoint)drawPoint
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    CGFloat quarterFigureWidth = [self figureWidth] / 4;
    
    [path moveToPoint:CGPointMake(drawPoint.x + quarterFigureWidth, drawPoint.y)];
    [path addLineToPoint:CGPointMake(drawPoint.x + (3 * quarterFigureWidth), drawPoint.y)];
    
    [path addQuadCurveToPoint:CGPointMake(drawPoint.x + (3 * quarterFigureWidth), drawPoint.y + [self figureHeight])
                 controlPoint:CGPointMake(drawPoint.x + (4 * quarterFigureWidth), drawPoint.y + [self figureHeight] / 2)];
    
    [path addLineToPoint:CGPointMake(drawPoint.x + quarterFigureWidth, drawPoint.y + [self figureHeight])];
    
    [path addQuadCurveToPoint:CGPointMake(drawPoint.x + quarterFigureWidth, drawPoint.y)
                 controlPoint:CGPointMake(drawPoint.x, drawPoint.y + [self figureHeight] / 2)];
    
    [self setAttributesToDraw:path];
}

- (void)drawSquiggle:(CGPoint)drawPoint
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    CGFloat quarterFigureWidth = [self figureWidth] / 4;
    CGFloat quarterFigureHeight = [self figureHeight] / 4;
    
    [path moveToPoint:CGPointMake(drawPoint.x, drawPoint.y + (2 * quarterFigureHeight))];
    
    [path addCurveToPoint:CGPointMake(drawPoint.x + [self figureWidth], drawPoint.y)
            controlPoint1:CGPointMake(drawPoint.x + (1.5 * quarterFigureWidth), drawPoint.y - quarterFigureHeight * 2)
            controlPoint2:CGPointMake(drawPoint.x + (2 * quarterFigureWidth), drawPoint.y + quarterFigureHeight * 2.5)
     ];
    
    [path moveToPoint:CGPointMake(drawPoint.x + [self figureWidth], drawPoint.y)];
    [path addLineToPoint:CGPointMake(drawPoint.x + [self figureWidth], drawPoint.y + (2 * quarterFigureHeight) )];
//        //-----
//    
//    [path addCurveToPoint:CGPointMake(drawPoint.x, drawPoint.y + [self figureHeight] )
//            controlPoint1:CGPointMake(drawPoint.x + [self figureWidth] - (3.5 * quarterFigureWidth), drawPoint.y - quarterFigureHeight * 0)
//            controlPoint2:CGPointMake(drawPoint.x + (2 * quarterFigureWidth), drawPoint.y + quarterFigureHeight * 4.5)
//     ];
//    
//    
//    [path addLineToPoint:CGPointMake(drawPoint.x, drawPoint.y + (2 * quarterFigureHeight))];
//    
    //-----
    
    
    [path moveToPoint:CGPointMake(drawPoint.x , drawPoint.y + [self figureHeight] )];
    [path addLineToPoint:CGPointMake(drawPoint.x, drawPoint.y + (2 * quarterFigureHeight))];
    
    
    [path moveToPoint:CGPointMake(drawPoint.x , drawPoint.y + [self figureHeight] )];
    [path addCurveToPoint:CGPointMake(drawPoint.x + [self figureWidth], drawPoint.y + (2 * quarterFigureHeight) )
            controlPoint1:CGPointMake(drawPoint.x + (1.5 * quarterFigureWidth), drawPoint.y - quarterFigureHeight * 0)
            controlPoint2:CGPointMake(drawPoint.x + (2 * quarterFigureWidth), drawPoint.y + quarterFigureHeight * 4.5)
     ];
    
    
    // Pinta el rectangulo que falta
    [path moveToPoint:CGPointMake(drawPoint.x, drawPoint.y + (2 * quarterFigureHeight))];
    [path addLineToPoint:CGPointMake(drawPoint.x + [self figureWidth], drawPoint.y)];
    [path addLineToPoint:CGPointMake(drawPoint.x + [self figureWidth], drawPoint.y + (2 * quarterFigureHeight) )];
    [path addLineToPoint:CGPointMake(drawPoint.x , drawPoint.y + [self figureHeight] )];
    
    
    [self setAttributesToDraw:path];
}

// Devuelve el color de las figuras
- (UIColor *) getColor
{
    UIColor *color;
    switch (self.color) {
        case SetCardColorTypeGreen:
            color = [UIColor greenColor];
            break;
        case SetCardColorTypeRed:
            color = [UIColor redColor];
            break;
        case SetCardColorTypePurple:
            color = [UIColor purpleColor];
            break;
        default:
            break;
    }
    return color;
}

- (void)setAttributesToDraw:(UIBezierPath *)path
{
    UIColor *color = [self getColor];
    if (self.shade == SetCardShadeTypeSolid) {
//        [color setFill];
//        [path fill];
    } else if (self.shade == SetCardShadeTypeStriped) {
        color = [color colorWithAlphaComponent:0.3];
//        [color setFill];
//        [path fill];
    } else if (self.shade == SetCardShadeTypeOpen) {
        
    }
    
    [color setFill];
    [path fill];
    
    [color setStroke];
    [path stroke];
}

#define HORIZONTAL_SPACE_PCT    0.10
#define VERTICAL_SPACE_PCT      0.10
#define FIGURE_HEIGHT_PCT       0.20

- (CGFloat)horizontalSpace
{
    return self.bounds.size.width * HORIZONTAL_SPACE_PCT;
}

- (CGFloat)verticalSpace
{
    return self.bounds.size.height * VERTICAL_SPACE_PCT;
}

- (CGFloat)figureWidth
{
    return self.bounds.size.width * (1 - (HORIZONTAL_SPACE_PCT * 2));
}

- (CGFloat)figureHeight
{
    return self.bounds.size.height * FIGURE_HEIGHT_PCT;
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
@end
