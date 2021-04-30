//
//  detailJournalTableViewTableViewCell.swift
//  Mini Challenge 01
//
//  Created by Reynald Daffa Pahlevi on 05/04/21.
//

import UIKit

class detailJournalTableViewTableViewCell: UITableViewCell {

    @IBOutlet weak var labelPertanyaan: UILabel!
    @IBOutlet weak var textFieldJawaban: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textFieldJawaban.isEditable = false
        textFieldJawaban.isScrollEnabled = false
//        textFieldJawaban.sizeToFit()
//        textFieldJawaban.translatesAutoresizingMaskIntoConstraints = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
