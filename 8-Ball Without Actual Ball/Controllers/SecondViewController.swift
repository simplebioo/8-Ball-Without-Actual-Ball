//
//  SecondViewController.swift
//  8-Ball Without Actual Ball
//
//  Created by Bioo on 12.01.2022.
//

import UIKit
import CoreData

class SecondViewController: UIViewController, UITableViewDataSource {

    @IBOutlet var tableViewOutlet: UITableView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var answerTextField: UITextField!
    
    private var answers: [Answers] = []
    
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AnswerCell
          
        let answer = answers[indexPath.row]
        
        cell.answerLabel.text = answer.answer
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard editingStyle == .delete else { return }
        let answer = answers.remove(at: indexPath.row)
        
        context.delete(answer)
        
        do {
            try context.save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func saveAnswer(withTitle title: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Answers", in: context) else { return }
        
        let answerObject = Answers(entity: entity, insertInto: context)
        
        answerObject.answer = title
        
        do {
            try context.save()
            answers.append(answerObject)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        if answerTextField.text != "", !answerTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            saveAnswer(withTitle: answerTextField.text!)
            tableViewOutlet.reloadData()
        }
    }
}

            
            
