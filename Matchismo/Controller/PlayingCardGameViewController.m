//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by David Muñoz Fernández on 09/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardGameViewController ()

// Propiedades "heredadas"
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (nonatomic, strong) CardMatchingGame *game;

@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSegControl;
@end

@implementation PlayingCardGameViewController

// ---------------------------------------
//  -- Private methods (to implement in subclass)
// ---------------------------------------
#define MATCH_BONUS 4
#define MISMATCH_COST_BASE 2
#define FLIP_COST_BASE 1

// ---------------------------------------
//  -- Private methods (to implement in subclass)
// ---------------------------------------
#pragma mark - Private Methods to oimplement in subclass

// Actualiza los controles específicos de cada subclase
- (void) updateUISpecificCardGame
{
    // Partida empezada muestra el slider, en otro caso el segmento de tipo de juego
    [self setVisibility:self.historySlider visible:self.game.moves.count > 1];
    [self setVisibility:self.gameModeSegControl visible:self.game.moves.count <= 1];
    
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
        [cardButton setTitle:card.contents forState:UIControlStateNormal];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.unplayable;
        cardButton.alpha = (card.unplayable) ? 0.3 : 1.0;
        
        // Carga la imagen cuando está volteada, la borra EOC
        UIImage *cardBackImage = (card.isFaceUp) ? nil : [UIImage imageNamed:@"card-back.png"];
        [cardButton setImage:cardBackImage forState:UIControlStateNormal];
        // Redondea la imagen
        cardButton.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    }
}

// Devuelve el número de cartas sobre las que se buscarán coincidencias
- (int) getMatchCount
{
    return self.gameModeSegControl.selectedSegmentIndex + 2;
}

- (int) getMatchBonus
{
    return MATCH_BONUS;
}

// Cuanto mayor nº cartas, más penalización
- (int) getMisMatchPenalty
{
    return (MISMATCH_COST_BASE * ([self getMatchCount]-1));
}

// Cuanto mayor nº cartas, más coste por voltear
- (int) getFlipCost
{
    return (FLIP_COST_BASE * ([self getMatchCount]-1));
}

- (Deck *) getDeck
{
    return [[PlayingCardDeck alloc] init];
}

// ---------------------------------------
//  -- Private methods
// ---------------------------------------
#pragma mark - Private methods

// Modifica la visibilidad de un control
- (void) setVisibility:(UIControl *)control visible:(BOOL)visible
{
    control.enabled = visible;
    control.alpha = (visible) ? 1.0 : 0.0;
}

// ---------------------------------------
//  -- Actions
// ---------------------------------------
#pragma mark - Actions

// Cambia el modo de juego
- (IBAction)changeGameMode:(UISegmentedControl *)sender {
    [self startNewGame];
}

@end
