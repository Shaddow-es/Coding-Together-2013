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
    return [self.game numberOfCardsInPlay];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self collectionViewCellIdentifier] forIndexPath:indexPath];
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

// Devuelve un string con formato con el contenido de la carta (para el histórico)
- (NSAttributedString *) cardAsAttributedString:(Card *)card
{
    @throw [NSException exceptionWithName:@"Método abstracto no implementado"
                                   reason:@"Estás invocando al método abstracto 'cardAsAttributedString'!"
                                 userInfo:nil];
}

// Devuelve el identificador de la celda (UICollectionViewCell)
- (NSString *)collectionViewCellIdentifier
{
    @throw [NSException exceptionWithName:@"Método abstracto no implementado"
                                   reason:@"Estás invocando al método abstracto 'collectionViewCellIdentifier'!"
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
                                                  flipCost:self.flipCost
                                               newCardCost:self.newCardCost
                                               removeCards:self.removeCards];
    self.flipCount = 0;
    [self.cardCollectionView reloadData];
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

#define MORE_DEAL_CARD_COUNT 3
- (IBAction)dealMoreCards:(UIButton *)sender
{
    if (![self.game playMoreCards:MORE_DEAL_CARD_COUNT]) {
        // No había cartas suficientes
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Baraja agotada"
                                                        message:@"No hay más cartas en la baraja"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        // Añade las cartas puestas en juego a la colección
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (int i=1; i<=MORE_DEAL_CARD_COUNT; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.game numberOfCardsInPlay]-i inSection:0];
            [indexPaths addObject:indexPath];
        }
        [self.cardCollectionView insertItemsAtIndexPaths:indexPaths];

        // Realiza scroll a las nuevas cartas puestas en juego
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.game numberOfCardsInPlay]-1 inSection:0];
        [self.cardCollectionView scrollToItemAtIndexPath:indexPath
                                        atScrollPosition:UICollectionViewScrollPositionBottom
                                                animated:YES];
        [self updateUI];
    }
}


// ---------------------------------------
//  -- Private methods
// ---------------------------------------
#pragma mark - Private Methods

- (void) updateUI
{
    self.scoreLabel.text = [NSString stringWithFormat:@"Puntos: %d", self.game.score];
    CardMove *cardMove = [self.game.moves lastObject];
    self.lastActionLabel.attributedText = [self cardMoveToAttributedString:cardMove];
    
    // Si hubo un match, elimina las cartas de la colección y del modelo
    if (self.removeCards && (cardMove.type == CardMoveTypeMatch) ) {
        NSArray *indexPaths = [self.game indexesOfCards:cardMove.cards];
        [self.cardCollectionView deleteItemsAtIndexPaths:indexPaths];
        [self.game removeCards:cardMove.cards];
    }
    
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
        // Solo anima el volteo si está configurado así en las preferencias
        [self updateCell:cell usingCard:card animate:[GameSettings isFlipAnimated]];
    }
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
    } else if (cardMove.type == CardMoveTypePlayMoreCards) {
        NSString *str = [NSString stringWithFormat:@"Añadidas %d cartas en juego", [cardMove.cards count] ];
        [cardAttributtedString appendAttributedString:[self stringToLabelAttributedString:str]];
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
