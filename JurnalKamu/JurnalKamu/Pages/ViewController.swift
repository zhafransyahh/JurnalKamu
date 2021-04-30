//
//  ViewController.swift
//  JurnalKamu
//
//  Created by Adhella Subalie on 02/04/21.
//

import UIKit
import CoreData

//datatype to store the day sections with each of its entries
struct DaySection {
   var day: Date //1 januari
   var entries: [JournalEntry] //entries yang 1 januari
}

var temp:JournalEntry = JournalEntry()

class ViewController: UIViewController {
   @IBOutlet var titletable :UITableView!
   @IBOutlet var segmentedControl :UISegmentedControl!
   @IBOutlet weak var searchDate: UITextField!
   var datePicker: UIDatePicker!
   
   //to declare the context for persistent container (kek decodernya perhaps?)
   var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
   var data:[JournalEntry] = []//source data
   var recentData:[JournalEntry] = []//a variable to store the day sections with each of its entries
   var sections :[DaySection] = []
   var isEmpty = false
   
   override func viewDidLoad() {
      super.viewDidLoad()
      loadSetup()
   }
   
   
   override func viewDidAppear(_ animated: Bool) {
      navigationController?.navigationBar.barStyle = .default
   }
   
   //supaya kalo balik ke halaman ini ke reload lagi semua
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.viewDidLoad()
      
   }
   
   func loadSetup(){
      navbarSetup()
      segmentedControlSetup()
      tableSetup()
      setupDatePicker()
      fetchEntryData()
      sections = loadSection(isRecent: true)
   
   }
   
   func fetchEntryData(){
      do {
         let request = JournalEntry.fetchRequest() as NSFetchRequest<JournalEntry>
         
         let sort = NSSortDescriptor(key: "dateCreated", ascending: false)
         request.sortDescriptors = [sort]
         
         self.data = try context.fetch(request)
         
         //kyk masukin thread dari bg process ke main process but idk yet
         DispatchQueue.main.async {
            self.titletable.reloadData()
         }
      } catch  {
      }
      
      if data.count==0{
         isEmpty = true
      }
      else{
         isEmpty = false
      }
      
   }
   
   func navbarSetup(){
      //        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle")!,
      //                                          style: .plain,
      //                                          target: self,
      //                                          action: #selector(action(_:)))
      //        navigationItem.rightBarButtonItem?.setTitlePositionAdjustment(.init(horizontal: -100, vertical: -20), for: UIBarMetrics.default)
      //        navigationItem.rightBarButtonItem = addButton
      navigationController?.hidesBarsOnSwipe = true
   }
   
   func tableSetup(){
      titletable.sectionHeaderHeight = 0
      titletable.sectionFooterHeight = 0
      
      // Remove space at top and bottom of tableView.
      titletable.tableHeaderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: CGFloat.leastNormalMagnitude)))
      titletable.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: CGFloat.leastNormalMagnitude)))
      
      
      titletable.delegate = self
      titletable.dataSource = self
   }
   
   func segmentedControlSetup(){
      segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
      segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 0.66, green: 0.32, blue: 0.43, alpha: 1)], for: UIControl.State.normal)
   }
   
   @IBAction func didChangeSegment(_ sender: UISegmentedControl){
      fetchEntryData()
      if sender.selectedSegmentIndex == 0{
//         titletable.y
         sections = loadSection(isRecent: true)
         searchDate.isHidden = true
      }else{
         sections = loadSection(isRecent: false)
         searchDate.isHidden = false
      }
      
      titletable.reloadData()
   }
   
   
   //Loading section for the table to display
   // 2 param: database => source database, isRecent => take last 7 days data or not
   func loadSection(isRecent:Bool)->[DaySection] {
      var localData = self.data
      
      if isRecent{
         localData = getLast7Days()
      }else{
         //            localData = self.data[0..<n]
      }
      
      let groups = Dictionary(grouping: localData) { (d) in
         return d.getDay(date: d.dateCreated!)
      }
      
      var temp = groups.map(DaySection.init(day:entries:))
      return temp.sorted {
         $0.day > $1.day
      }
      
   }
   
   
   //function to gather all of the entries that were created in the last 7 days
   //param: database => JournalEntry array
   func getLast7Days()->[JournalEntry]{
      var tempData:[JournalEntry] = []
      if !isEmpty{
         var interval:Int = 0
         let limit = data.count - 1
         var counter = 0
         repeat{
            interval = data[counter].getDayIntervalFromToday()
            
            if interval < 7{
               tempData.append(data[counter])
            }
            counter += 1;
         }while interval < 7 && counter <= limit
      }
      return tempData
   }
   
   
   
   public func deleteEntry(toBeDeleted:JournalEntry){
      let alert = UIAlertController(title: "Delete Entry", message: "Setelah di delete, tidak bisa dibalikin loh", preferredStyle: .alert)
      
      alert.addAction(UIAlertAction(title: "Batal", style: .cancel, handler: {action in
         print("tapped Batal")
      }))
      
      alert.addAction(UIAlertAction(title: "Hapus", style: .destructive, handler: { action in
         //            let toBeDeleted = self.data[index] // nanti ganti jadi where Date is date
         
         self.context.delete(toBeDeleted)
         
         do{
            try! self.context.save()
         }catch{
         }
         
         self.didChangeSegment(self.segmentedControl)
      }))
      
      present(alert, animated: true)
   }
   
/// DATE PICKER SECTION

   
   // CARA NGAPUS ???
   func textFieldShouldClear(_ textField: UITextField) -> Bool{
      if textField == searchDate{
         self.didChangeSegment(self.segmentedControl)
         searchDate.resignFirstResponder() //nurunin date wheeel
         searchDate.endEditing(true)
      }
      
      return true
   }
   
   func setupDatePicker(){
      self.datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 200))
      datePicker.datePickerMode = .date
      datePicker.addTarget(self, action: #selector(self.dateChanged), for: .valueChanged)
      searchDate.isHidden = true
      
      searchDate.placeholder = "Cari Jurnal"
      //searchDateBar.placeholder = "Cari Jurnal"
      
      searchDate.clearButtonMode = .always
      
      // style date picker jadi wheels
      if #available(iOS 13.4, *){
         datePicker.preferredDatePickerStyle = .wheels
      }
      
      // muncul date picker saat text field di klik
      self.searchDate.inputView = datePicker
      
      // button
      let toolBar:UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
      
      let spaceButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
      
      let doneButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.tapOnDoneButton))
      
      
      toolBar.setItems([spaceButton, doneButton], animated: true)
      /// muncul "done" button
      self.searchDate.inputAccessoryView = toolBar
   }
   
   @objc func dateChanged(_ sender: UIDatePicker){
      let dateFormat = DateFormatter()
      dateFormat.dateStyle = .medium
      let dateQuery = datePicker.date// current date or replace with a specific date
      let calendar = Calendar.current
      let startTime = calendar.startOfDay(for: dateQuery)
      let endTime = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: dateQuery)
//      var a = "asd"
      do {
         let request = JournalEntry.fetchRequest() as NSFetchRequest<JournalEntry>
         let sort = NSSortDescriptor(key: "dateCreated", ascending: false)
         let predicate = NSPredicate(format: "(dateCreated >= %@) AND (dateCreated <= %@)", startTime as CVarArg, endTime! as CVarArg)
         request.predicate = predicate
         request.sortDescriptors = [sort]
         
         self.data = try context.fetch(request)
         
         if self.data.count == 0{
            isEmpty = true
         }else{
            isEmpty = false
         }
         
         //kyk masukin thread dari bg process ke main process but idk yet
         DispatchQueue.main.async {
            self.sections = self.loadSection(isRecent: false)
            self.titletable.reloadData()
         }
      } catch  {
      }
      
      self.searchDate.text  = dateFormat.string(from: datePicker.date)
      
   }
   
   @objc func tapOnDoneButton(){
      searchDate.resignFirstResponder()
      
      if !searchDate.hasText{
         self.didChangeSegment(self.segmentedControl) //reload data
         searchDate.resignFirstResponder() //nurunin date wheeel
         searchDate.endEditing(true)
      }
   }
}

//extension to handle interaction with cells on the table, such as tapping and stuff
extension ViewController :UITableViewDelegate{
   //function that determines what happens if you select a certain row at certain index
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let section = self.sections[indexPath.section]
      temp = section.entries[indexPath.row]
   }
   
   
   func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
      let section = self.sections[indexPath.section]
      let tobedeleted = section.entries[indexPath.row]
      let delete = UITableViewRowAction(style: .destructive, title: "Hapus") { (action, indexPath) in
         self.deleteEntry(toBeDeleted:tobedeleted)
      }
      return [delete]
   }
}



//extension to handle datasource such as where it came from and how it's going to be processed or shown
extension ViewController :UITableViewDataSource{
   
   
   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      if !isEmpty{
         let section = self.sections[section]
         
         if segmentedControl.selectedSegmentIndex == 0{
            return section.entries[0].getSectionTitle(isDate: false)
         }
         return section.entries[0].getSectionTitle(isDate: true)
      } else{
         return nil
      }
      
      
   }
   
   func numberOfSections(in tableView: UITableView) -> Int {
      if isEmpty{
         return 1
      }
      return self.sections.count;
   }
   //MUST HAVE FUNCTION 1/2 = this function returns how many rows are going to be shown
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if isEmpty{
         return 1
      }
      let section = self.sections[section]
      return section.entries.count
   }
   //MUST HAVE FUNCTION 2/2 = this function basically returns a template cell (that can be determined at the storyboard, the prototype cell thingy) at IndexPath
   //But you need to define the prototype cell name, make its identifier. Here i refer to the cell as "cellie". You can do this at the storyboard
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //dequeue basically intialize an already made template of cell
      var c = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
      var title:String = "Sepertinya tidak ada apapun disini!💀"
      if !isEmpty{
         c = tableView.dequeueReusableCell(withIdentifier: "cellie", for: indexPath)
         let section = self.sections[indexPath.section]
         title = section.entries[indexPath.row].title!
      }
      
      c.textLabel?.text = title
      
      return c
   }
   
   
   
}
