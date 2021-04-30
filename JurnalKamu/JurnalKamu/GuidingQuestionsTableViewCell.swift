//
//  GuidingQuestionsTableViewCell.swift
//  Jurnal Kamu
//
//  Created by Rafi Zhafransyah on 07/04/21.
//

import UIKit

class GuidingQuestionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelPertanyaan: UILabel!
    @IBOutlet weak var userInputField: UITextView!
    
    var indexPath: Int?
    var delegate: GuidingQuestionsViewControllerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userInputField.layer.borderColor = UIColor.systemGray4.cgColor
        self.userInputField.layer.borderWidth = 1
        self.userInputField.layer.cornerRadius = 5
        
        self.userInputField.delegate = self
        
    }
    

    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension GuidingQuestionsTableViewCell: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewDidChange(indexPath: indexPath ?? 0, value: textView.text)
    }
}


