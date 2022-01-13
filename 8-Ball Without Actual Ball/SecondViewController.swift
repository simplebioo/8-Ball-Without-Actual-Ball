//
//  SecondViewController.swift
//  8-Ball Without Actual Ball
//
//  Created by Bioo on 12.01.2022.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource {

    @IBOutlet var tableViewOutlet: UITableView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var answerTextField: UITextField!
    
    var answers = ["Just do it!", "Change your mind"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AnswerCell
          
        let answer = answers[indexPath.row]
        
        cell.answerLabel.text = answer
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        guard editingStyle == .delete else { return }
        answers.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        if answerTextField.text != "" {
            answers.append(answerTextField.text!)
            tableViewOutlet.reloadData()
        }
    }
}
            
            
