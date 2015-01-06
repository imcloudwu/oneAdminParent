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
        
//        cellView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
//        
//        subject.autoresizingMask = UIViewAutoresizing.FlexibleWidth
//        
//        content.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
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
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        cellView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
//        absenceType.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
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
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        cellView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
//        date.autoresizingMask = UIViewAutoresizing.FlexibleWidth
//        reason.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
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
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        cellView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
//        date.autoresizingMask = UIViewAutoresizing.FlexibleWidth
//        reason.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
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

class SHSMScoreCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var credit: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var type: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView.layer.frame.size.width = self.contentView.layer.frame.size.width
        //cellView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
        type.bounds = cellView.bounds
        //type.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin|UIViewAutoresizing.FlexibleWidth
        
        cellView.layer.cornerRadius = 5
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class JHSMScoreTitleCell: UITableViewCell {
    
    @IBOutlet weak var domain: UILabel!
    @IBOutlet weak var credit: UILabel!
    @IBOutlet weak var score: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor(red: 217.0/255.0, green: 1, blue: 196.0/255.0, alpha: 0.8)
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class JHSMScoreCell: UITableViewCell {
    
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var credit: UILabel!
    @IBOutlet weak var score: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class SHExamScoreCell: UITableViewCell {
    
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var state: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class JHExamScoreCell: UITableViewCell {
    
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var assignmentScore: UILabel!
    @IBOutlet weak var avg: UILabel!
    @IBOutlet weak var credit: UILabel!
    @IBOutlet weak var titleA: UILabel!
    @IBOutlet weak var titleB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class ExamScoreTitleCell: UITableViewCell {
    
    @IBOutlet weak var domain: UILabel!
    @IBOutlet weak var score: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor(red: 217.0/255.0, green: 1, blue: 196.0/255.0, alpha: 0.8)
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}


