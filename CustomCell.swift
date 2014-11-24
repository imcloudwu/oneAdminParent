//
//  CustomCell.swift
//  App
//
//  Created by Cloud on 10/23/14.
//  Copyright (c) 2014 Cloud. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var unit: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView.layer.borderWidth = 2
        cellView.layer.borderColor = Global.GreenColor.CGColor
        
        cellView.layer.cornerRadius = 5
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class AbsenceCell: UITableViewCell {
    
    @IBOutlet weak var absenceType: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var period: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        absenceType.layer.cornerRadius = 5
        absenceType.layer.masksToBounds = true
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class MeritCell: UITableViewCell {
    
    @IBOutlet weak var A: UILabel!
    @IBOutlet weak var B: UILabel!
    @IBOutlet weak var C: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var reason: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        A.layer.cornerRadius = 10
        A.layer.masksToBounds = true
        B.layer.cornerRadius = 10
        B.layer.masksToBounds = true
        C.layer.cornerRadius = 10
        C.layer.masksToBounds = true
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class DemeritCell: UITableViewCell {
    
    @IBOutlet weak var A: UILabel!
    @IBOutlet weak var B: UILabel!
    @IBOutlet weak var C: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var reason: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        A.layer.cornerRadius = 10
        A.layer.masksToBounds = true
        B.layer.cornerRadius = 10
        B.layer.masksToBounds = true
        C.layer.cornerRadius = 10
        C.layer.masksToBounds = true
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class SMScoreCell: UITableViewCell {
    
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var credit: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var type: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView.layer.cornerRadius = 5
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
