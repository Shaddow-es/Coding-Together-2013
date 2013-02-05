//
//  CardGameViewController.m
//  Matchismo
//
//  Created by David Muñoz Fernández on 01/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastActionLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSegControl;

@property (nonatomic) NSInteger flipCount;
@property (nonatomic, strong) CardMatchingGame *game;

@end

@implementation CardGameViewController

// ---------------------------------------
//  -- Private methods
// ---------------------------------------
#pragma mark - Private methods

// Actualiza la interfaz con el modelo
- (void) updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
        [cardButton setTitle:card.contents forState:UIControlStateNormal];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.unplayable;
        cardButton.alpha = (card.unplayable) ? 0.3 : 1.0;
        
        // Carga la imagen cuando está volteada, la borra EOC
        UIImage *cardBackImage = (card.isFaceUp) ? nil : [UIImage imageNamed:@"cardBack.png"];
        [cardButton setImage:cardBackImage forState:UIControlStateNormal];
        // Redondea la imagen
        cardButton.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Puntos: %d", self.game.score];
    self.lastActionLabel.text = [NSString stringWithFormat:@"%@", self.game.lastAction];
}

// Inicia una nueva partida
- (void) startNewGame
{
    // Número de cartas sobre las que se busca coincidencias
    NSUInteger matchCount = self.gameModeSegControl.selectedSegmentIndex + 2;
    
    NSLog(@"Empezando partida para juego de %d cartas", matchCount);
    self.game = [[CardMatchingGame alloc]initWithCardCount:self.cardButtons.count
                                                 usingDeck:[[PlayingCardDeck alloc]init]
                                            usingMatchMode:matchCount];
    self.flipCount = 0;
    [self updateUI];
    [self.gameModeSegControl setEnabled:YES];
}

// ---------------------------------------
//  -- Actions
// ---------------------------------------
#pragma mark - Actions

// Voltea una carta
- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
    self.gameModeSegControl.enabled = NO;
}

// Baraja y empieza una partida
- (IBAction)deal:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"¿Estás seguro?"
                                                    message:@"La partida actual se perderá"
                                                   delegate:self
                                          cancelButtonTitle:@"Sí"
                                          otherButtonTitles:@"No", nil];
    [alert show];
}

// Cambia el modo de juego
- (IBAction)changeGameMode:(UISegmentedControl *)sender {
    [self startNewGame];
}

// ---------------------------------------
//  -- Controller
// ---------------------------------------
#pragma mark - Controller

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
