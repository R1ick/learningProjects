//
//  Cards.swift
//  Cards
//
//  Created by Ярослав Антонович on 03.11.2021.
//

import UIKit
//протокол CaseIterable наделяет перечисления свойством allCases, возвращающее количество всех его элементов. Это позволяет обойти все элементы перечисления, а также выбрать случайный кейс

//типы фигуры карт
enum CardType: CaseIterable {
    case circle
    case cross
    case square
    case fill
    case empty
}

//цвета карт
enum CardColor: CaseIterable {
    case red
    case green
    case black
    case gray
    case brown
    case yellow
    case purple
    case orange
}

enum CardImage: CaseIterable {
    case picOne
    case picTwo
    case picThree
    case picFour
    case picFive
}

//игральная карточка
typealias Card = (type: CardType, color: CardColor)

//пречисления по умолчанию поддерживают сравнение

