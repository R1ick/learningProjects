//
//  Cards.swift
//  Cards
//
//  Created by Ярослав Антонович on 03.11.2021.
//

import UIKit


protocol FlippableView: UIView {
    var isFlipped: Bool { get set }
    var flipCompletionHandler: ((FlippableView) -> Void)? { get set }
    func flip()
}

class CardView<ShapeType: ShapeLayerProtocol>: UIView, FlippableView {
    //цвет фигуры
    var color: UIColor!
    
    var isFlipped: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var flipCompletionHandler: ((FlippableView) -> Void)?
    var cornerRadius = 20
    func flip() {
        //определяем между какими представлениями осуществить переход
        let fromView = isFlipped ? frontSideView : backSideView
        let toView = isFlipped ? backSideView : frontSideView
        //запускаем анимированный переход
        UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionFlipFromTop], completion: {_ in
            //обработчик переворота
            self.flipCompletionHandler?(self)
        })
        isFlipped = !isFlipped
    }
    
    
    //внутренний отступ представления
    private let margin: Int = 10
    
    //hgедставление с лицевой стороной карты
    lazy var frontSideView: UIView = self.getFrontSideView()
    //представление с обратной стороной карты
    lazy var backSideView: UIView = self.getBackSideView()
    
    //возвращает представление для лицевой стороны карточки
    private func getFrontSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .white
        
        let shapeView = UIView(frame: CGRect(x: margin, y: margin, width: Int(self.bounds.width) - margin * 2, height: Int(self.bounds.height) - margin * 2))
        view.addSubview(shapeView)
        
        //создание слоя с фигурой
        let shapeLayer = ShapeType(size: shapeView.frame.size, fillColor: color.cgColor)
        shapeView.layer.addSublayer(shapeLayer)
        //скругляем углы корневого слоя
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        
        return view
    }
    
    //возвращает вью для обратной стороны карточки
    private func getBackSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        
        view.backgroundColor = .white
        
        //выбор случайного узора рубашки
        switch ["circle", "line"].randomElement() {
        case "circle":
            let layer = BackSideCircle(size: self.bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        case "line":
            let layer = BackSideLine(size: self.bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        default:
            break
        }
        //скругляем углы корневого вью
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        
        return view
    }
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.color = color
        setupBorders()
    }
    override func draw(_ rect: CGRect) {
        //удаляем добавленные ранее дочерние представления
        backSideView.removeFromSuperview()
        frontSideView.removeFromSuperview()
        
        //добавляем новые представления
        if isFlipped {
            self.addSubview(backSideView)
            self.addSubview(frontSideView)
        } else {
            self.addSubview(frontSideView)
            self.addSubview(backSideView)
        }
    }
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(self.responderChain())
    }
     */
    
   /* //обработка касаний на карточки
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan Card")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesMoved Card")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesEnded Card")
    }
    */
    //перемещение карточек
    private var anchorPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        anchorPoint.x = touches.first!.location(in: window).x - frame.minX
        anchorPoint.y = touches.first!.location(in: window).y - frame.minY
        //сохраняем исходные координаты
        startTouchPoint = frame.origin
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.frame.origin.x = touches.first!.location(in: window).x - anchorPoint.x
        self.frame.origin.y = touches.first!.location(in: window).y - anchorPoint.y
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.frame.origin == startTouchPoint {
            flip()
        }
        if self.frame.origin.y < 0 || self.frame.origin.y > 575 {
            UIView.animate(withDuration: 0.5, animations: { self.frame.origin = self.startTouchPoint })
        }
        if self.frame.origin.x < 5 || self.frame.origin.x > 310 {
            UIView.animate(withDuration: 0.5, animations: { self.frame.origin = self.startTouchPoint })
        }
       
        
    }
    //конец перемещения
    //
    private var startTouchPoint: CGPoint!
   
  
    private func setupBorders() {
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not benn implemented")
    }
}
 
//Self.self позволяет получить название типа данных рассматриваемого значения
extension UIResponder {
    func responderChain() -> String {
        guard let next = next else {
            return String(describing: Self.self)
        }
        return String(describing: Self.self) + " -> " + next.responderChain()
    }
}




//Назначение и удаление элемента первым ответчиком при появлении сцены
/*
 overrided func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    textField.becomeFirstResponder  -- назначить первым ответчиком текстовое поле
    textField.resignFirstResponder -- убрать первый ответчик
 */

