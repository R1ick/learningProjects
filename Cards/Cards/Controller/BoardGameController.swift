//
//  BoardGameController.swift
//  Cards
//
//  Created by Ярослав Антонович on 03.11.2021.
//

import UIKit
import CoreData



class BoardGameController: UIViewController, UpdatingDataController {
    var i: Int = 0
    
    
    var updatingData = [Result(name: "Test name", points: 90)]
    var completionHandler: ((String) -> Void)?
    
    var endData = [Result(name: "", points: 0)]
  
    
//    var updatedData: [Result] = [Result(name: "Test name", points: 90)]
    let storyboardInstance = UIStoryboard(name: "Main", bundle: nil)
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        print("BGC result.count = \(self.updatingData.count)")
        if self.i >= 2 {
        print("BGC mas item = \(self.updatingData[self.i - 1].userName ?? " ") has points = \(self.updatingData[self.i - 1].points),\n BGC mas item 2 = \(self.updatingData[self.i - 2].userName ?? " ") has points = \(self.updatingData[self.i - 2].points)")
        } else {
            print("BGC mas item = \(self.updatingData[self.i - 1].userName ?? " ") has points = \(self.updatingData[self.i - 1].points)")
        }
        self.endData[0].userName = self.updatingData[self.i - 1].userName
    }
    //MARK: свойства контроллера
    
    //количество пар уникальных карточек
    var cardsPairsCounts = 9
    //cущность игра
    lazy var game: Game = getNewGame()
    
    //MARK: генерация игры
    private func getNewGame() -> Game {
        let game = Game()
        game.cardsCount = self.cardsPairsCounts
        game.generateCards()
        return game
    }
    
    //MARK: кнопка для запуска/перезапуска игры
    lazy var startButtonView = getStartButtonView()
    
    private func getStartButtonView() -> UIButton {
        //1 - создаем кнопку
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        //2 - изменение положения кнопки
        button.center.x = 110
        
        //получаем доступ к текущему окну
        let window = UIApplication.shared.windows[0]
        //определим отступ сверху от границ окна до Safe Area
        let topPadding = window.safeAreaInsets.top
        //устанавливаем координату Y кнопки в соответствии с отступом
        button.frame.origin.y = topPadding + 50
        
        //3 - настраиваем внешний вид кнопки
        //устанавливаем текст
        button.setTitle("Начать игру", for: .normal)
        //устанавливаем цвет текста для обычного (не нажатого) состояния
        button.setTitleColor(.black, for: .normal)
        //устаналиваем цвет текста для нажатого состояния
        button.setTitleColor(.gray, for: .highlighted)
        //устанавливаем фоновый цвет
        button.backgroundColor = .systemGray4
        //скругляем углы
        button.layer.cornerRadius = 10
        
        //подключаем обработчик нажатия на кнопку
        button.addTarget(nil, action: #selector(startGame(_:)), for: .touchUpInside)
        /*
        button.addAction(UIAction(title: "", handler: { action in
            print("Button was pressed")
        }), for: .touchUpInside)
        */
        return button
         
    }
    
    //Кнопка переворота всех карточек
    lazy var flipButtonView = getFlipButtonView()
    
    private func getFlipButtonView() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 180, height: 50))
        button.center.x = 310
        let window = UIApplication.shared.windows[0]
        let topPadding = window.safeAreaInsets.top
        button.frame.origin.y = topPadding + 50
        button.setTitle("Перевернуть все", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        button.addTarget(nil, action: #selector(flipAllCards(_:)), for: .touchUpInside)
        
        return button
    }
    

    
    @objc func flipAllCards(_ sender: UIButton) {

//        for card in cardViews {
//            UIView.animate(withDuration: 0.5, animations: {
//                (card as! FlippableView).flip()
//            })
//        }

    }
    
    //MARK: loadView
    //загрузка вьюшек из состава сцены происходит тут
    override func loadView() {
        super.loadView()
        
        //добавим кнопку на сцену
        view.addSubview(startButtonView)
        view.addSubview(flipButtonView)
        
        //добавляем игровое поле на сцену
        view.addSubview(boardGameView)
    }
   
   // Метод нажатия на кнопку
  //  для iOS 13 и ниже
    @objc func startGame(_ sender: UIButton) { // метод из objective-c
        game = getNewGame()
        let cards = getCardBy(modelData: game.cards)
        placeCardsOnBoard(cards)
       
    }
    var flipCount: Int = 0
    
    //MARK: Игровое поле
    lazy var boardGameView = getBoardGameView()
    
    private func getBoardGameView() -> UIView {
        //отступ игрового поля от ближайших элементов
        let margin: CGFloat = 10
        
        let boardView = UIView()
        //указываем координаты
        // х
        boardView.frame.origin.x = margin
        // y
        let window = UIApplication.shared.windows[0]
        let topPadding = window.safeAreaInsets.top
        boardView.frame.origin.y = topPadding + startButtonView.frame.height + margin + 50
        
        //рассчитываем ширину
        boardView.frame.size.width = UIScreen.main.bounds.width - margin * 2
        //рвссчитываем высоту
        // с учетом нижнего отступа
        let bottomPadding = window.safeAreaInsets.bottom
        boardView.frame.size.height = UIScreen.main.bounds.height - boardView.frame.origin.y - margin - bottomPadding
        
        //изменяем стиль игрового поля
        boardView.layer.cornerRadius = 5
        boardView.backgroundColor = #colorLiteral(red: 0.112869747, green: 0.4232245684, blue: 0.4763563871, alpha: 1)
       
        
        return boardView
    }
    
    var count = 20
    //MARK: генерация массива карточек
    private func getCardBy(modelData: [Card]) -> [UIView] {
        //количество переворотов
       
        
        //хранилище для представлений карточек
        var cardViews = [UIView]()
        //фабрика карточек
        let cardViewFactory = CardViewFactory()
        //перебираем массив карточек в Модели
        for (index, modelCard) in modelData.enumerated() {
            //добавляем первый экземпляр карты
            let cardOne = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            cardOne.tag = index
            cardViews.append(cardOne)
            
            //добавляем второй экземпляр карты
            let cardTwo = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            cardTwo.tag = index
            cardViews.append(cardTwo)
        }
        
       
        //добавляем всем картам обработчик переворота
        for card in cardViews {
            (card as! FlippableView).flipCompletionHandler = { [self] flippedCard in
                //переносим карточку вверх иерархии
                flippedCard.superview?.bringSubviewToFront(flippedCard)
                
               
                //добавляем или удаляем карточку
                if flippedCard.isFlipped {
                    self.flippedCards.append(flippedCard)
                } else {
                    if let cardIndex = self.flippedCards.firstIndex(of: flippedCard) {
                        self.flippedCards.remove(at: cardIndex)
                    }
                }
                
                //если перевернуто 2 карточки
                if self.flippedCards.count > 2 {
                    print("Перевернуто больше двух карточек")
                    self.flippedCards = []
                    
                } else if self.flippedCards.count == 2 {
                    
                    //получаем карточки из данных модели
                    let firstCard = game.cards[self.flippedCards.first!.tag]
                    let secondCard = game.cards[self.flippedCards.last!.tag]
                    
                    //если карточки одинаковые
                    if game.checkCards(firstCard, secondCard) {
                        //сперва анимированно скрываем их
                        UIView.animate(withDuration: 0.3, animations: {
                            self.flippedCards.first!.layer.opacity = 0
                            self.flippedCards.last!.layer.opacity = 0
                            //после чего удаляем из иерархии
                        }, completion: { _ in
                            self.flippedCards.first!.removeFromSuperview()
                            self.flippedCards.last!.removeFromSuperview()
                            self.flippedCards = []
                            flipCount += 1
                            self.count -= 2
                            print(flipCount)
                            print("Koli4estvo \(self.count)")
                            checkCount()
                            
                           
                        })
                        //в ином случае
                    } else {
                        //переворачиваем карточки рубашкой вверх
                        for card in self.flippedCards {
                            (card as! FlippableView).flip()
                            flipCount += 1
                            print(flipCount)
                            print("Koli4estvo \(count)")
                            checkCount()
                            
                        }
                    }
                }
            }
            
        }
        return cardViews
    }
    
    
    //размеры карточек
    private var cardSize: CGSize {
        CGSize(width: 80, height: 120)
    }
    
    //предельные координаты размещения карточки
    private var cardMaxXCoordinate: Int {
        Int(boardGameView.frame.width - cardSize.width)
    }
    private var cardMaxYCoordinate: Int {
        Int(boardGameView.frame.height - cardSize.height)
    }
    
    //MARK: игральные карточки
    var cardViews = [UIView]()
    
    //MARK: checkCount()
    
    
    
    private func checkCount() {
        guard let resultViewController = self.storyboardInstance.instantiateViewController(withIdentifier: "resultTable") as? ResultTableViewController else { return }
        if count < 1 {
            let alert = UIAlertController(title: "Игра завершена", message: "Количество переворотов: \(flipCount)", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: {_ in
                let newAlert = UIAlertController(title: "Warning", message: "Начать заново?", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Да", style: .default, handler: { [self] _ in
                    self.game = self.getNewGame()
                    let cards = self.getCardBy(modelData: game.cards)
                    self.placeCardsOnBoard(cards)
                    
                })
                let noAction = UIAlertAction(title: "Нет", style: .default, handler: {  _ in
                    
                    self.navigationController?.pushViewController(resultViewController, animated: true)
                    
                })
                newAlert.addAction(yesAction)
                newAlert.addAction(noAction)
                self.present(newAlert, animated: true)
            })
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
            
            
            
        }
        self.updatingData[i - 1].points = Int16(flipCount)
        print("flips = \(self.updatingData[i - 1].points)")
        self.endData = self.updatingData
        
        
        
        resultViewController.updatingData = [Result(name: self.endData[self.i - 1].userName ?? "some", points: Int16(flipCount))]
        resultViewController.i = self.i
        resultViewController.updatingData = self.endData
        print(self.endData[i - 1].userName)
    }
//
//    private func saveWithClosure() {
//        let updatedData = result[0].userName ?? ""
//        completionHandler?(updatedData)
//    }
    
    private func placeCardsOnBoard(_ cards: [UIView]) {
        flipCount = 0
        count = 20
        
        //удаляем все имеющиеся на игровом поле карточки
        for card in cardViews {
            card.removeFromSuperview()
        }
        cardViews = cards.shuffled()
        
        //перебираем карточки
        var defX = 20
        var defY = 20
        var i = 1
        for card in cardViews {
            
           //для каждой карточки генерируем случайные координаты
           // let randomXCoordinate = Int.random(in: 0...cardMaxXCoordinate)
           // let randomYCoordinate = Int.random(in: 0...cardMaxYCoordinate)
            card.frame.origin = CGPoint(x: defX, y: defY)
            //размещаем карточку на игровом поле
            boardGameView.addSubview(card)
            
            if i % 4 == 0 {
                defX = 20
                defY += 120
            } else { defX += 90
                }
            i += 1
        }
        defY += 20
    }
    
    private var flippedCards = [UIView]()
    
    
   
    //MARK: С.Р. 1 - Возврат карточек в игровое поле
    
}
