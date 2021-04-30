//
//  EmotionSelectionViewController.swift
//  Jurnal Kamu
//
//  Created by Rafi Zhafransyah on 08/04/21.
//

import UIKit


var jurnalInput = Jurnal(title: "", dateCreated: Date(), answers: ["", "", ""], moodValue: 0.0, questions: ["Apa yang kamu rasakan?","Apa penyebabnya menurut kamu?", "Apa yang kira-kira dapat kamu lakukan untuk mengatasi itu?"])

class EmotionSelectionViewController: UIViewController {
    
    @IBOutlet weak var emojiCaption: UILabel!
    @IBOutlet weak var bigEmoji: UILabel!
    @IBOutlet weak var convoCaption: UILabel!
    @IBOutlet weak var circleButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }

    
    //Function Slider
    @IBAction func sliderDidSlide(_ sender: UISlider){
        let value = sender.value //butuh ini
        var emoji = ""
        var emojiCap = ""
        var convoCap = ""
        
        if value >= 0.8 {
            emoji = "😊"
            emojiCap = "Sangat Baik"
        }else if value >= 0.6{
            emoji = "🙂"
            emojiCap = "Baik"
        }else if value >= 0.4{
            emoji = "😐"
            emojiCap = "Biasa Aja"
        }else if value >= 0.2{
            emoji = "🙁"
            emojiCap = "Buruk"
        }else{
            emoji = "☹️"
            emojiCap = "Sangat Buruk"
        }
        
        if value >= 0.66 {
            convoCap = "Wah jadi ikut senang! Sekarang ceritain yuk kenapa kabarmu sangat baik!"
        }else if value <= 0.66 && value >= 0.33{
            convoCap = "Oke, cerita yuk!"
        }else if value <= 0.33{
            convoCap = "Pasti sulit buat kamu ya? Ceritain aja yuk, kamu pasti bisa kok melalui semua ini!"
        }
        
        bigEmoji.text = emoji
        emojiCaption.text = emojiCap
        convoCaption.text = convoCap
        
        jurnalInput.moodValue = value
        
    }
    
    
    // Ya ini yang dibawah dah apa yak gatau juga
    override func viewDidLoad() {
        super.viewDidLoad()
        circleButton.layer.cornerRadius = circleButton.frame.width / 2
        circleButton.layer.masksToBounds = true
        
        
    }
    
}


