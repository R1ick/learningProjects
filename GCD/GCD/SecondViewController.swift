//
//  SecondViewController.swift
//  GCD
//
//  Created by Ярослав Антонович on 05.01.2022.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var imageURL: URL?
    fileprivate var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            imageView.image = newValue
            imageView.sizeToFit()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
        delay(3) {
            self.loginAlert()
        }
    }
    
    fileprivate func delay(_ delay: Int, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            closure()
        }
    }
    
    fileprivate func loginAlert() {
        let alert = UIAlertController(title: "Зарегистрированы?", message: "Введите ваш логин и пароль", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { (usernameTF) in
            usernameTF.placeholder = "Введите логин"
        }
        alert.addTextField { (userpasswordTF) in
            userpasswordTF.placeholder = "Введите пароль"
            userpasswordTF.isSecureTextEntry = true
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func fetchImage() {
        imageURL = URL(string: "https://www.i-igrushki.ru/upload/iblock/c04/c04c663ede8c702ef2a39bd47bbf851b.jpg")
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            guard let url = self.imageURL, let imageData = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: imageData)
            }
        }
    }
}
