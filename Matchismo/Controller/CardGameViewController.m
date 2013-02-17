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
#import "CardMatchingGame.h"

@interface CardGameViewController () <UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastActionLabel;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;

@property (nonatomic) NSInteger flipCount;
@property (nonatomic, strong) CardMatchingGame *game;
@end

@implementation CardGameViewController


// ---------------------------------------
//  -- UICollectionViewDataSource methods
// ---------------------------------------
#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.startingCardCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCard" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card animate:NO];
    return cell;
}


// ---------------------------------------
//  -- Abstract methods
// ---------------------------------------
#pragma mark - Abstract Methods


// Crea una nueva baraja de cartas
- (Deck *)createDeck
{
    @throw [NSException exceptionWithName:@"Método abstracto no implementado"
                                   reason:@"Estás invocando al método abstracto 'createDeck'!"
                                 userInfo:nil];
}

// Actualiza una celda con el contenido de una carta
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate
{
    @throw [NSException exceptionWithName:@"Método abstracto no implementado"
                                   reason:@"Estás invocando al método abstracto 'updateCell'!"
                                 userInfo:nil];
}

// ---------------------------------------
//  -- Public methods
// ---------------------------------------
#pragma mark - Public Methods

// Inicia una nueva partida
- (void) startNewGame
{
    
    self.game = [[CardMatchingGame alloc]initWithCardCount:self.startingCardCount
                                                 usingDeck:[self createDeck]
                                                 matchMode:self.matchCount
                                                matchBonus:self.matchBonus
                                            mismatchPenaly:self.mismatchPenalty
                                                  flipCost:self.flipCost];
    self.flipCount = 0;
    [self updateUI];
}

// ---------------------------------------
//  -- Actions
// ---------------------------------------
#pragma mark - Actions

// Voltea una carta
- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath){
        
        if (!self.game.isGameOver){
            // Operaciones a realizar durante la transacción
            [self.game flipCardAtIndex:indexPath.item];
            self.flipCount++;
            [self updateUI];
        }
        
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
        self.historySlider.alpha = 1.0;
    }
    
    // Actualiza las cartas
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card animate:YES];
    }
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
