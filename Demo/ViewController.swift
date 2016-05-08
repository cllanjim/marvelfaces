import UIKit
import FaceTracker
import AVFoundation

class ViewController: UIViewController, FaceTrackerViewControllerDelegate {
    var spideyView = UIImageView()
    var currentEffectView = UIImageView()
    var faceTrackerViewController: FaceTrackerViewController?
    var pointViews = [UIView]()
    var player = AVAudioPlayer()
    var currentViewName = "wolverine"
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var optionsButton: UIButton!
    @IBOutlet var faceTrackerContainerView: UIView!
    @IBOutlet weak var wolverineButton: UIButton!
    @IBOutlet weak var ironmanButton: UIButton!
    @IBOutlet weak var spideyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        currentEffectView.image = UIImage(named: "wolverine")
        self.view.insertSubview(currentEffectView, aboveSubview: faceTrackerContainerView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        faceTrackerViewController!.startTracking { () -> Void in
            self.activityIndicator.stopAnimating()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources tspidey can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "embedFaceTrackerViewController") {
            faceTrackerViewController = segue.destinationViewController as? FaceTrackerViewController
            faceTrackerViewController!.delegate = self
        }
    }
    
    @IBAction func optionsButtonPressed(sender: UIButton) {
        let alert = UIAlertController()
        alert.popoverPresentationController?.sourceView = optionsButton
        
        alert.addAction(UIAlertAction(title: "Swap Camera", style: .Default, handler: { (action) -> Void in
            self.faceTrackerViewController!.swapCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func wolverineButtonPressed(sender: UIButton) {
        currentEffectView.image = UIImage(named: "wolverine")
        currentViewName = "wolverine"
    }
    
    @IBAction func ironmanButtonPressed(sender: UIButton) {
        currentEffectView.image = UIImage(named: "ironman")
        currentViewName = "ironman"
    }
    
    @IBAction func spideyButtonPressed(sender: UIButton) {
        currentEffectView.image = UIImage(named: "spidey")
        currentViewName = "spidey"
    }
    
    func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.transform)
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
    
    func faceTrackerDidUpdate(points: FacePoints?) {
        if let points = points {
            // Allocate some views for the points if needed
            if (pointViews.count == 0) {
                let numPoints = points.getTotalNumberOFPoints()
                for _ in 0...numPoints {
                    let view = UIView()
                    //view.backgroundColor = UIColor.greenColor()
                    self.view.addSubview(view)
                    
                    pointViews.append(view)
                }
            }
            
            // Set frame for each point view
            points.enumeratePoints({ (point, index) -> Void in
                let pointView = self.pointViews[index]
                let pointSize: CGFloat = 4
                
                pointView.hidden = false
                pointView.frame = CGRectIntegral(CGRectMake(point.x - pointSize / 2, point.y - pointSize / 2, pointSize, pointSize))
            })
            
            let eyeCornerDist = sqrt(pow(points.leftEye[0].x - points.rightEye[5].x, 2) + pow(points.leftEye[0].y - points.rightEye[5].y, 2))
            let eyeToEyeCenter = CGPointMake((points.leftEye[0].x + points.rightEye[5].x) / 2, (points.leftEye[0].y + points.rightEye[5].y) / 2)
            
            let viewWidth = 2.0 * eyeCornerDist
            let viewHeight = (currentEffectView.image!.size.height / currentEffectView.image!.size.width) * viewWidth
            
            currentEffectView.transform = CGAffineTransformIdentity
            
            var newPos = CGPoint()
            newPos.x  = eyeToEyeCenter.x - viewWidth / 2.15
            newPos.y = eyeToEyeCenter.y - viewWidth * 0.65
            
            print("computing face again")
            music()
            
            currentEffectView.frame = CGRectMake(newPos.x, newPos.y, viewWidth, viewHeight)
            currentEffectView.hidden = false
            
            setAnchorPoint(CGPointMake(0.5, 1.0), forView: currentEffectView)
            
            let angle = atan2(points.rightEye[5].y - points.leftEye[0].y, points.rightEye[5].x - points.leftEye[0].x)
            currentEffectView.transform = CGAffineTransformMakeRotation(angle)
            
            
        }
        else {
            currentEffectView.hidden = true
            
            for view in pointViews {
                view.hidden = true
            }
        }
    }
    
    func music() {
        
        let url:NSURL = NSBundle.mainBundle().URLForResource("The-Wolverine", withExtension: "mp3")!
        
        do { player = try AVAudioPlayer(contentsOfURL: url, fileTypeHint: nil) }
        catch let error as NSError { print(error.description) }
        
        player.numberOfLoops = 1
        player.prepareToPlay()
        player.play()
        
    }
    
}

