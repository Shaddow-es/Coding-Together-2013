//
//  CardGameViewController.m
//  Matchismo
//
//  Created by David Muñoz Fernández on 01/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMove.h"
#import "GameSettings.h"

@interface CardGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastActionLabel;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;

@property (nonatomic) NSInteger flipCount;
@property (nonatomic, strong) CardMatchingGame *game;
@end

@implementation CardGameViewController

// ---------------------------------------
//  -- Constantes
// ---------------------------------------

#define DEFAULT_MATCH_MODE 2
#define DEFAULT_MATCH_BONUS  4
#define DEFAULT_MISMATCH_PENALTY 2
#define DEFAULT_FLIP_COST 2

// ---------------------------------------
//  -- Public methods
// ---------------------------------------
#pragma mark - Public Methods

// Inicia una nueva partida
- (void) startNewGame
{
    
    self.game = [[CardMatchingGame alloc]initWithCardCount:self.cardButtons.count
                                                 usingDeck:[self getDeck]
                                                 matchMode:[self getMatchCount]
                                                matchBonus:[self getMatchBonus]
                                           mismatchPenaly:[self getMisMatchPenalty]
                                                  flipCost:[self getFlipCost]];
    self.flipCount = 0;
    [self updateUI];
}

// ---------------------------------------
//  -- Actions
// ---------------------------------------
#pragma mark - Actions

// Voltea una carta
- (IBAction)flipCard:(UIButton *)sender
{
    if (!self.game.isGameOver){
        if ([[[GameSettings alloc] init] isFlipAnimated]){
            // Animando el volteo de la carta
            [UIView transitionWithView:sender
                              duration:0.30
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{}
                            completion:NULL];
        }
        
        // Operaciones a realizar durante la transacción
        [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
        self.flipCount++;
        [self updateUI];
    }
}

// Baraja y empieza una partida
- (IBAction)deal:(UIButton *)sender {
    if (self.game.isGameOver) {
        [self startNewGame];
    } else {
        // Si el juego no ha acabado pedimos confirmación
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"¿Estás seguro?"
                                                        message:@"La partida actual se perderá"
                                                       delegate:self
                                              cancelButtonTitle:@"Sí"
                                              otherButtonTitles:@"No", nil];
        [alert show];
    }
}

// Se mueve por el slider del historíco de jugadas
- (IBAction)travelHistory:(UISlider *)sender {
    sender.alpha = (sender.value == sender.maximumValue) ? 1.0 : 0.5;
    CardMove *cardMove = [self.game.moves objectAtIndex:floor(sender.value - 1)];
    self.lastActionLabel.attributedText = [self cardMoveToAttributedString:cardMove];
}


// ---------------------------------------
//  -- Private methods
// ---------------------------------------
#pragma mark - Private Methods

// Actualiza la interfaz genérica de un juego de cartas con el modelo
//  - Última puntuación
//  - Puntuación
- (void) updateUI
{
    self.scoreLabel.text = [NSString stringWithFormat:@"Puntos: %d", self.game.score];
    self.lastActionLabel.attributedText = [self cardMoveToAttributedString:[self.game.moves lastObject]];
    
    // Actualiza el slider
    self.historySlider.maximumValue = [self.game.moves count];
    // Añade animación al slider cuando no estuviese al final
    if (self.historySlider.value == self.historySlider.maximumValue - 1) {
        self.historySlider.value = self.historySlider.maximumValue;
    } else {
        [self.historySlider setValue: self.historySlider.maximumValue animated:YES];
    }
    
    // Actualiaciones de UI específicas de subclases
    [self updateUISpecificCardGame];
}

// Devuelve un string con formato con el contenido de la carta
- (NSAttributedString *) cardAsAttributedString:(Card *)card
{
    NSString *str = [NSString stringWithFormat:@"%@ ", card.contents];
    return [[NSMutableAttributedString alloc] initWithString:str];
}

// Devuelve un string con formato con un array de cartas
- (NSAttributedString *) cardsAsAttributedString:(NSArray *)cards
{
    NSMutableAttributedString *cardAttributtedString = [self stringToLabelAttributedString:@" "];
    for (Card *card in cards) {
        [cardAttributtedString appendAttributedString:[self cardAsAttributedString:card]];
        [cardAttributtedString appendAttributedString:[self stringToLabelAttributedString:@" "]];
    }
    return cardAttributtedString;
}

// Dado un string formatea el string para poder ser visualizado en el label del histórico
- (NSMutableAttributedString *) stringToLabelAttributedString:(NSString *)str
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range = NSMakeRange(0, [str length]);
    [attributedString addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor whiteColor]
                                  range:range];
    return attributedString;
    
}

- (NSAttributedString *) cardMoveToAttributedString:(CardMove *)cardMove
{
    NSMutableAttributedString *cardAttributtedString = [[NSMutableAttributedString alloc] init];
    
    if (cardMove.type == CardMoveTypeGameStarted){
        [cardAttributtedString appendAttributedString:[self stringToLabelAttributedString:@"Empezar partida"]];
    } else if (cardMove.type == CardMoveTypeGameFinished){
        [cardAttributtedString appendAttributedString:[self stringToLabelAttributedString:@"Juego acabado!"]];
    } else if (cardMove.type == CardMoveTypeFlipUp) {
        NSAttributedString *astrStart = [self stringToLabelAttributedString:@"Volteada "];
        NSString *strEnd = [NSString stringWithFormat:@" restados %d puntos", cardMove.score];
        NSAttributedString *astrEnd = [self stringToLabelAttributedString:strEnd];
                                       
        [cardAttributtedString appendAttributedString:astrStart];
        [cardAttributtedString appendAttributedString:[self cardsAsAttributedString:cardMove.cards]];
        [cardAttributtedString appendAttributedString:astrEnd];
    } else if (cardMove.type == CardMoveTypeMatch) {
        NSAttributedString *astrStart = [self stringToLabelAttributedString:@"Coincidencia "];
        NSString *strEnd = [NSString stringWithFormat:@" para %d puntos", cardMove.score];
        NSAttributedString *astrEnd = [self stringToLabelAttributedString:strEnd];
        
        [cardAttributtedString appendAttributedString:astrStart];
        [cardAttributtedString appendAttributedString:[self cardsAsAttributedString:cardMove.cards]];
        [cardAttributtedString appendAttributedString:astrEnd];
    } else if (cardMove.type == CardMoveTypeMismatch) {
        NSString *strEnd = [NSString stringWithFormat:@" no coinciden! %d puntos de penalización", cardMove.score];
        NSAttributedString *astrEnd = [self stringToLabelAttributedString:strEnd];
        
        [cardAttributtedString appendAttributedString:[self cardsAsAttributedString:cardMove.cards]];
        [cardAttributtedString appendAttributedString:astrEnd];
    }
    
    return cardAttributtedString;
}


// ---------------------------------------
//  -- Private methods (to implement in subclass)
// ---------------------------------------
#pragma mark - Private Methods to oimplement in subclass

// Actualiza los controles específicos de cada subclase
- (void) updateUISpecificCardGame
{
    // Nada que hacer en la clase genérica
}

- (int) getMatchCount
{
    return DEFAULT_MATCH_MODE;
}

- (int) getMatchBonus
{
    return DEFAULT_MATCH_BONUS;
}

- (int) getMisMatchPenalty
{
    return DEFAULT_MISMATCH_PENALTY;
}

- (int) getFlipCost
{
    return DEFAULT_FLIP_COST;
}

- (Deck *) getDeck
{
    return [[Deck alloc] init];
}

// ---------------------------------------
//  -- Controller
// ---------------------------------------
#pragma mark - Controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load background image
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"table-background"]];
    [self startNewGame];
}

// ---------------------------------------
//  -- Delegados
// ---------------------------------------
#pragma mark - Delegados

// Delegado ejecutado cuando se clickea una opción en la alerta
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // Si confirma
    if (buttonIndex == 0) {
        [self startNewGame];
    }
}

// ---------------------------------------
//  -- Getters & Setters
// ---------------------------------------
#pragma mark - Getters & Setters

- (void) setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void) setFlipCount:(NSInteger)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Volteos: %d", self.flipCount];
}

- (CardMatchingGame *) game
{
    if (!_game) {
        [self startNewGame];
    }
    return _game;
}
@end
