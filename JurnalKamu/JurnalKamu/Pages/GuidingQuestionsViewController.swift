//
//  GuidingQuestionsViewController.swift
//  Jurnal Kamu
//
//  Created by Rafi Zhafransyah on 08/04/21.
//

import UIKit
import CoreData

class GuidingQuestionsViewController: UIViewController {
    
    // Guiding Questions
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var simpanButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        simpanButton.layer.cornerRadius = 8
        simpanButton.layer.masksToBounds = true
        
//        titleTextField.delegate = self
        titleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for index in 0 ..< 3 {
            let cellRow = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! GuidingQuestionsTableViewCell
            cellRow.userInputField.resignFirstResponder()
        }
        titleTextField.resignFirstResponder()
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        jurnalInput.title = titleTextField.text ??
            ""
        validateJurnal(jurnal: jurnalInput)
    }
    
    
    func validateJurnal(jurnal: Jurnal){
        if !jurnal.title.isEmpty {
            //simpanButton.isHidden = false
            if jurnal.answers.count == 3 {
                if !jurnal.answers[0].isEmpty && !jurnal.answers[1].isEmpty && !jurnal.answers[2].isEmpty {
                    simpanButton.isHidden = false
                }else{
                    simpanButton.isHidden = true
                }
            }else{
                simpanButton.isHidden = true
            }
        }else{
            simpanButton.isHidden = true
        }
    }
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func insertData(){
        let entry = JournalEntry(context: self.context)
        entry.title = jurnalInput.title
        entry.answers = jurnalInput.answers
        entry.moodValue = jurnalInput.moodValue
        entry.dateCreated = Date()
        
        
        //saving to the data core using managed object context
        do {
            try! self.context.save()
        } catch {
        }
        
        jurnalInput = Jurnal(title: "", dateCreated: Date(), answers: ["", "", ""], moodValue: 0.0, questions: ["Question1", "Question2", "Question3"])
        //no need reload function because all the data were in the main page
    }
    
    
    @IBAction func simpanButtonAction() {
        let alert = UIAlertController(title: "Simpan Jurnal?", message: "Anda tidak bisa mengubah isi jurnal ini setelah menyimpan", preferredStyle: .alert)
        
        //        batal button
        alert.addAction(UIAlertAction(title: "Batal", style: .cancel, handler: {action in
            print("tapped Batal")
        }))
        
        //        hapus button
        alert.addAction(UIAlertAction(title: "Simpan", style: .default, handler: {action in
            self.insertData()
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true)
    }

    
}

extension GuidingQuestionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jurnalInput.questions.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customViewCell") as! GuidingQuestionsTableViewCell
        
        cell.labelPertanyaan.text = jurnalInput.questions[indexPath.row]
        cell.userInputField.text = jurnalInput.answers[indexPath.row] 
        cell.indexPath = indexPath.row
        cell.delegate = self
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
    
}

extension GuidingQuestionsViewController: GuidingQuestionsViewControllerDelegate{
    func textViewDidChange(indexPath: Int, value: String) {
        jurnalInput.answers[indexPath] = value
        validateJurnal(jurnal: jurnalInput)
    }
}

protocol GuidingQuestionsViewControllerDelegate {
    func textViewDidChange(indexPath: Int, value: String)
 }
