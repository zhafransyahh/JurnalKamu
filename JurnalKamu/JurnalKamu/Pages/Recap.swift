//
//  ViewController.swift
//  Mini Challenge 01
//
//  Created by Reynald Daffa Pahlevi on 05/04/21.
//

import UIKit
import CoreData

class RecapController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonHapus: UIButton!
    @IBOutlet weak var judul:UILabel!
    @IBOutlet weak var mood:UILabel!
    @IBOutlet weak var tanggal:UILabel!
    
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // coba dijadiin satu array aja
//    let dataDummy: DetailJurnal = DetailJurnal(title: "Dimarahin Boss", dataCreated: Date(),
    
//     answers: [
//        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
//        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
//        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."],
//     moodValue: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // table view setting
        tableView.delegate = self
        tableView.dataSource = self
        
        setupHeader()
        
        //button hapus setting
        buttonHapus.layer.masksToBounds = true
        buttonHapus.layer.cornerRadius = 8.0
        buttonHapus.setTitle("Hapus", for: .normal)
        
        //text fields setting
        
    }
    
    
    @IBAction func backToMain(sender: AnyObject) {
        self.navigationController?.popToRootViewController(animated: true)

    }
    
    func setupHeader(){
        judul.text = temp.title
        mood.text = getMood(value: temp.moodValue)
        tanggal.text = "hai"
//            "\(getDay(date: temp.dateCreated!))"
    }
    
    @IBAction func didTapButton() {
        showAlert()
    }
    
    func getDay(date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    func getMood(value:Float)->String{
        var emojiCap = ""
        
        if value >= 0.8 {
            emojiCap = "Sangat Baik 😊"
        }else if value >= 0.6{
            emojiCap = "Baik 🙂"
        }else if value >= 0.4{
            emojiCap = "Biasa Aja 😐"
            
        }else if value >= 0.2{
            emojiCap = "Buruk 🙁"
        }else{
            emojiCap = "Sangat Buruk ☹️"
        }
        
        return emojiCap
    }
    
 
    
    func showAlert(){
        let alert = UIAlertController(title: "Hapus Jurnal", message: "Apakah kamu yakin ingin menghapus jurnal ini?", preferredStyle: .alert)
//        batal button
        alert.addAction(UIAlertAction(title: "Batal", style: .cancel, handler: {action in
            print("tapped Batal")
        }))
        
//        hapus button
        alert.addAction(UIAlertAction(title: "Hapus", style: .destructive, handler: {action in
            self.context.delete(temp)
            
            do{
                try! self.context.save()
            }catch{
            }
            
            self.navigationController?.popToRootViewController(animated: true)
            
        }))
        
        present(alert, animated: true)
    }
    

}

extension RecapController: UITableViewDelegate, UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return temp.answers!.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temp.answers!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customViewCell") as! detailJournalTableViewTableViewCell
        cell.labelPertanyaan.text = jurnalInput.questions[indexPath.row]
        cell.textFieldJawaban.text = temp.answers?[indexPath.row]
//        cell.labelPertanyaan.text = dataDummy.que
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240.0
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 8
//    }
    
    
 // Do Something Here Later
}

