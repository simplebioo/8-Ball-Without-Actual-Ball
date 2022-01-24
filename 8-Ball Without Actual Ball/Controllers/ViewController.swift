//
//  ViewController.swift
//  8-Ball Without Actual Ball
//
//  Created by Bioo on 11.01.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var textView: UITextView!
    @IBOutlet var shakeLabel: UILabel!
    
    var answers: [Answers] = []
    
    private let defaultString = "Come on! Ask your question?"
    
    private let networkManager = NetworkManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Answers> = Answers.fetchRequest()
        
        do {
            answers = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        
        view.backgroundColor = .yellow
        
        shakeLabel.isHidden = true
        
        textView.delegate = self
        textView.backgroundColor = .white
        textView.textColor = UIColor.lightGray
        textView.layer.cornerRadius = 15
        textView.layer.masksToBounds = true
     
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            shakeLabel.isHidden = false
        }
    }
    
    private func textViewDidEndEditing(_textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = defaultString
            textView.textColor = UIColor.lightGray
        }
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        if Reachability.isConnectedToNetwork(),textView.text != defaultString, !textView.text.trimmingCharacters(in: .whitespaces).isEmpty {
            
            networkManager.fetch { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let answer):
                    DispatchQueue.main.async { [weak self] in
                        self?.shakeLabel.textColor = .red
                        self?.shakeLabel.text = answer.magic.answer
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            if textView.text != defaultString, !textView.text.trimmingCharacters(in: .whitespaces).isEmpty {
            DispatchQueue.main.async { [weak self] in
                self?.shakeLabel.textColor = .red
                self?.shakeLabel.text = self?.answers.randomElement()?.answer ?? "Please enter default answers"
            }
        }
      }
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if textView.text.isEmpty {
            textView.text = defaultString
            textView.textColor = UIColor.lightGray
            shakeLabel.isHidden = true
        }
    }
}


