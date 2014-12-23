import UIKit

class MsgView: UIViewController{
    
//    var subject:String!
//    var content:String!
    
    var obj:Msg!
    
    
//    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var unit: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    //@IBOutlet weak var sv: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sv.contentSize = CGSize(width: 335, height: 700)
        //Global.AdjustView(sv)
        
        subject.layer.cornerRadius = 5
        subject.layer.masksToBounds = true
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = true
        
//        let screenSize: CGRect = UIScreen.mainScreen().bounds
//        let screenHeight = screenSize.height;
//        
//        if screenHeight >= 736{
//            sv.frame.offset(dx: 19, dy: 0)
//       }
//        else if screenHeight <= 568{
//            sv.frame.offset(dx: -28, dy: 0)
//        }
        
        schoolName.text = obj.SchoolName
        unit.text = obj.Unit
        date.text = obj.Date
        subject.text = obj.Subject
        textView.text = obj.Content
        
        
        self.navigationItem.title = "所有訊息"
//        textView.text = content
        //textView.text = Global.Msg
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
}
