//
//  PreferencesViewController.swift
//  Cards
//
//  Created by Ярослав Антонович on 06.12.2021.
//

import UIKit

class PreferencesViewController: UIViewController {

    //аутлеты форм
    @IBOutlet weak var lineSwitch: UISwitch!
    @IBOutlet weak var circleSwitch: UISwitch!
    @IBOutlet weak var emptySwitch: UISwitch!
    @IBOutlet weak var squareSwitch: UISwitch!
    @IBOutlet weak var rectangleSwitch: UISwitch!
    
    var forms = [CardType]()
    
    
    //аутлеты цветов
    @IBOutlet weak var redSwitch: UISwitch!
    @IBOutlet weak var purpleSwitch: UISwitch!
    @IBOutlet weak var yellowSwitch: UISwitch!
    @IBOutlet weak var greenSwitch: UISwitch!
    @IBOutlet weak var blackSwitch: UISwitch!
    @IBOutlet weak var orangeSwitch: UISwitch!
    @IBOutlet weak var brownSwitch: UISwitch!
    @IBOutlet weak var graySwitch: UISwitch!
    
    var colors = [CardColor]()
    
    var finalCards = [Card](repeating: (type: Cards.CardType.square, color: Cards.CardColor.red), count: 10)
    

    func setPrefs() {
        
        if lineSwitch.isOn {
            self.forms.append(.cross)
        }
        if circleSwitch.isOn {
            self.forms.append(.circle)
        }
        if emptySwitch.isOn {
            self.forms.append(.empty)
        }
        if squareSwitch.isOn {
            self.forms.append(.square)
        }
        if rectangleSwitch.isOn {
            self.forms.append(.fill)
        }
        
        if redSwitch.isOn {
            self.colors.append(.red)
        }
        if purpleSwitch.isOn {
            self.colors.append(.purple)
        }
        if yellowSwitch.isOn {
            self.colors.append(.yellow)
        }
        if greenSwitch.isOn {
            self.colors.append(.green)
        }
        if blackSwitch.isOn {
            self.colors.append(.black)
        }
        if orangeSwitch.isOn {
            self.colors.append(.orange)
        }
        if brownSwitch.isOn {
            self.colors.append(.brown)
        }
        if graySwitch.isOn {
            self.colors.append(.gray)
        }
    }
    
    func getCardsFromPrefs() -> [Card] {
        var cards = [Card](repeating: (type: Cards.CardType.square, color: Cards.CardColor.red), count: 10)
        
        setPrefs()
        
        for i in 0...9 {
            cards[i] 
        }
        cards.append((type: forms.randomElement()!, color: colors.randomElement()!))
        print(cards)
        
        self.finalCards = cards
        return cards
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPrefs()
        getCardsFromPrefs()
        
    }
}
