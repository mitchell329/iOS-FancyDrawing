//
//  ViewController.swift
//  DrawTemplate
//
//  Created by Shuai Yuan on 24/08/16.
//  Copyright © 2016 Mitchell. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var drawView: UIView!
    @IBOutlet weak var lineWidthPicker: UIPickerView!
    
    @IBOutlet weak var btnMagenta: UIButton!
    @IBOutlet weak var btnYellow: UIButton!
    @IBOutlet weak var btnCyan: UIButton!
    @IBOutlet weak var btnOrange: UIButton!
    @IBOutlet weak var btnBrown: UIButton!
    @IBOutlet weak var btnPurple: UIButton!
    @IBOutlet weak var btnBlack: UIButton!
    
    @IBOutlet weak var btnEclipse: UIButton!
    @IBOutlet weak var btnRect: UIButton!
    @IBOutlet weak var btnTriangle: UIButton!
    @IBOutlet weak var btnLine: UIButton!
    @IBOutlet weak var btnFreeDraw: UIButton!
    @IBOutlet weak var btnEraser: UIButton!
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnLineWidth: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    
    let BORDERWIDTH: CGFloat = 3.0
    let DEFAULTOPACITY: Float = 0.5
    let defaultLineWidth: CGFloat = 3.0
    let eraserWidth: CGFloat = 20.0
    let deleteAlertTitle = "Confirm Delete"
    let deleteAlertMessage = "Are you sure you want to delete all the drawing?"
    let saveAlertTitle = "Awesome!"
    let saveAlertMessage = "Your drawing has been saved."
    let alertOKTitle = "OK"
    let alertConfirmTitle = "Confirm"
    let alertCancelTitle = "Cancel"
    
    var startPoint: CGPoint = CGPointZero
    var drawLayer: CAShapeLayer?
    var drawColor: CGColorRef = UIColor.magentaColor().CGColor
    var selectedTag: Int = 0
    var drawShape: Int = 0
    var drawFreePath: UIBezierPath = UIBezierPath()
    var lineWidth: CGFloat?
    
    var colorButtons = [UIButton]()
    var shapeButtons = [UIButton]()
    var functionButtons = [UIButton]()
    var lineWidthData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        colorButtons = [btnMagenta, btnYellow, btnCyan, btnOrange, btnBrown, btnPurple, btnBlack]
        shapeButtons = [btnEclipse, btnRect, btnTriangle, btnLine, btnFreeDraw, btnEraser]
        functionButtons = [btnLineWidth, btnDelete, btnSave]
        lineWidthData = ["1.0", "3.0", "6.0", "9.0", "12.0", "15.0"]
        lineWidth = defaultLineWidth
        
        //Initialize buttons
        for button in colorButtons
        {
            button.layer.borderColor = UIColor.whiteColor().CGColor
            button.layer.borderWidth = BORDERWIDTH
        }
        
        btnMagenta.layer.borderColor = UIColor.blueColor().CGColor
        btnMagenta.layer.borderWidth = BORDERWIDTH
        
        btnEclipse.layer.backgroundColor = UIColor.lightGrayColor().CGColor
        btnDelete.enabled = false
        btnSave.enabled = false
        
        //Initialize UIPickerViewDelegate and UIPickerViewDataSource
        self.lineWidthPicker.delegate = self
        self.lineWidthPicker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    enum Color : Int
    {
        case Magenta = 0
        case Yellow
        case Cyan
        case Orange
        case Brown
        case Purple
        case Black
    }
    
    enum Shape : Int
    {
        case Eclipse = 0
        case Rect
        case Triangle
        case Line
        case FreeDraw
        case Eraser
        
    }
    
    enum Function : Int
    {
        case LineWidth = 0
        case Delete
        case Save
    }
    
    //Define columns in LineWidthPicker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Define rows in LineWidthPicker
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lineWidthData.count
    }
    
    //Define available values in LineWidthPicker
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lineWidthData[row]
    }
    
    //Set lineWidth as selected value in LineWidthPicker
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        lineWidth = CGFloat((lineWidthData[row] as NSString).floatValue)
    }
    
    //Set drawing color according to the color button clicked by user
    @IBAction func selectColor(sender: UIButton)
    {
        switch sender.tag
        {
        case Color.Magenta.rawValue:
            drawColor = UIColor.magentaColor().CGColor
            
        case Color.Yellow.rawValue:
            drawColor = UIColor.yellowColor().CGColor
            
        case Color.Cyan.rawValue:
            drawColor = UIColor.cyanColor().CGColor
            
        case Color.Orange.rawValue:
            drawColor = UIColor.orangeColor().CGColor
            
        case Color.Brown.rawValue:
            drawColor = UIColor.brownColor().CGColor
            
        case Color.Purple.rawValue:
            drawColor = UIColor.purpleColor().CGColor
            
        case Color.Black.rawValue:
            drawColor = UIColor.blackColor().CGColor
            
        default:
            drawColor = UIColor.magentaColor().CGColor
            
        }
        
        setButtonBorder(sender.tag)
        selectedTag = sender.tag
    }
    
    //Retrieve color settings according to passed parameter
    func retrieveColor(colorTag: Int)
    {
        switch colorTag
        {
        case Color.Magenta.rawValue:
            drawColor = UIColor.magentaColor().CGColor
            
        case Color.Yellow.rawValue:
            drawColor = UIColor.yellowColor().CGColor
            
        case Color.Cyan.rawValue:
            drawColor = UIColor.cyanColor().CGColor
            
        case Color.Orange.rawValue:
            drawColor = UIColor.orangeColor().CGColor
            
        case Color.Brown.rawValue:
            drawColor = UIColor.brownColor().CGColor
            
        case Color.Purple.rawValue:
            drawColor = UIColor.purpleColor().CGColor
            
        case Color.Black.rawValue:
            drawColor = UIColor.blackColor().CGColor
            
        default:
            drawColor = UIColor.magentaColor().CGColor
        }
        
        setButtonBorder(colorTag)
    }
    
    //Set drawing shape according to the shape button clicked by user
    //Eraser is treated as a freedraw shape with the background color of the drawview
    @IBAction func selectShape(sender: UIButton)
    {
        switch sender.tag
        {
        case Shape.Eclipse.rawValue:
            drawShape = Shape.Eclipse.rawValue
            retrieveColor(selectedTag)
            
        case Shape.Rect.rawValue:
            drawShape = Shape.Rect.rawValue
            retrieveColor(selectedTag)
            
        case Shape.Triangle.rawValue:
            drawShape = Shape.Triangle.rawValue
            retrieveColor(selectedTag)
            
        case Shape.Line.rawValue:
            drawShape = Shape.Line.rawValue
            retrieveColor(selectedTag)
            
        case Shape.FreeDraw.rawValue:
            drawShape = Shape.FreeDraw.rawValue
            retrieveColor(selectedTag)
            
        case Shape.Eraser.rawValue:
            drawShape = Shape.Eraser.rawValue
            drawColor = (drawView.backgroundColor?.CGColor)!
            
        default:
            drawShape = Shape.Eclipse.rawValue
            retrieveColor(selectedTag)
        }
        
        setButtonBackground(sender.tag)
    }
    
    //Implement delete, save or set line width function
    @IBAction func selectFunction(sender: UIButton) {
        switch sender.tag
        {
        case Function.Delete.rawValue:
            sender.layer.backgroundColor = UIColor.lightGrayColor().CGColor
            
            deleteWithAlert()
            
        case Function.LineWidth.rawValue:
            if self.lineWidthPicker.hidden == true
            {
                sender.layer.backgroundColor = UIColor.lightGrayColor().CGColor
                lineWidthPicker.hidden = false
            }
            else
            {
                sender.layer.backgroundColor = UIColor.clearColor().CGColor
                lineWidthPicker.hidden = true
            }
            
        case Function.Save.rawValue:
            sender.layer.backgroundColor = UIColor.lightGrayColor().CGColor
            saveWithAlert()
            
        default: break
        }
    }
    
    //When the delete button is clicked, popup an alert message to ask user to confirm the deletion. If confirmed, the drawview will be cleared
    func deleteWithAlert() {
        let alert = UIAlertController(title: deleteAlertTitle, message: deleteAlertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let actionConfirm = UIAlertAction(title: alertConfirmTitle, style: UIAlertActionStyle.Default, handler: {action in self.deleteConfirmed()})
        let actionCancel = UIAlertAction(title: alertCancelTitle, style: UIAlertActionStyle.Default, handler: {action in self.deleteCancel()})
        alert.addAction(actionConfirm)
        alert.addAction(actionCancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //Implement the confirm action of delete alert
    func deleteConfirmed() {
        for layer: CALayer in drawView.layer.sublayers! {
            layer.removeFromSuperlayer()
        }
        btnDelete.enabled = false
        btnDelete.layer.backgroundColor = UIColor.clearColor().CGColor
    }
    
    //Implement cancel action of delete alert
    func deleteCancel() {
        btnDelete.layer.backgroundColor = UIColor.clearColor().CGColor
    }
    
    //When the save button is clicked, popup an alert message to tell user that the drawing has been saved.
    func saveWithAlert() {
        UIGraphicsBeginImageContext(drawView.bounds.size)
        drawView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        let alert = UIAlertController(title: saveAlertTitle, message: saveAlertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let actionOK = UIAlertAction(title: alertOKTitle, style: UIAlertActionStyle.Default, handler: {action in self.saveOK()})
        alert.addAction(actionOK)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //When user clicks on the OK button of the save alert, disable the save button
    func saveOK() {
        btnSave.enabled = false
        btnSave.layer.backgroundColor = UIColor.clearColor().CGColor
    }
    
    //Draw in the drawview according to pre-selected color and shape. Drawing is limited in the drawview. Once user drawed something, the save button and delete button will be enabled
    @IBAction func drawingPanHandler(sender: UIPanGestureRecognizer)
    {
        let drawPath = UIBezierPath()
        
        if sender.state == .Began {
            startPoint = sender.locationInView(sender.view)
            initializeDrawLayer(startPoint)
        }
        else if sender.state == .Changed {
            let translation = sender.translationInView(sender.view)
            switch drawShape
            {
            case Shape.Eclipse.rawValue:
                drawLayer?.fillColor = drawColor
                if sender.locationInView(sender.view).y < sender.view?.frame.height {
                    drawLayer?.path = (UIBezierPath(ovalInRect: CGRectMake(startPoint.x, startPoint.y, translation.x, translation.y))).CGPath
                }
                
            case Shape.Rect.rawValue:
                drawLayer?.fillColor = drawColor
                if sender.locationInView(sender.view).y < sender.view?.frame.height {
                    drawLayer?.path = (UIBezierPath(rect: CGRectMake(startPoint.x, startPoint.y, translation.x, translation.y))).CGPath
                }
                
            case Shape.Line.rawValue:
                if sender.locationInView(sender.view).y < sender.view?.frame.height {
                    drawPath.moveToPoint(startPoint)
                    drawPath.addLineToPoint(sender.locationInView(sender.view))
                    drawPath.closePath()
                    
                    drawLayer?.path = drawPath.CGPath
                }
                
            case Shape.FreeDraw.rawValue, Shape.Eraser.rawValue:
                if sender.locationInView(sender.view).y < sender.view?.frame.height {
                    
                    drawFreePath.addLineToPoint(sender.locationInView(sender.view))
                    
                    drawLayer?.path = drawFreePath.CGPath
                }
                
            case Shape.Triangle.rawValue:
                if sender.locationInView(sender.view).y < sender.view?.frame.height {
                    let point2: CGPoint = sender.locationInView(sender.view)
                    let point3: CGPoint = CalcPoint(point2)
                    drawPath.moveToPoint(startPoint)
                    drawPath.addLineToPoint(point2)
                    drawPath.addLineToPoint(point3)
                    drawPath.closePath()
                    drawLayer?.fillColor = drawColor
                    drawLayer?.path = drawPath.CGPath
                }
            default: break
            }
        }
        else if sender.state == .Ended {
            drawFreePath = UIBezierPath()
            btnDelete.enabled = true
            btnSave.enabled = true
        }
    }
    
    //Once user begins to draw, set the color and line width to the selected value, then add a sublayer to the drawview
    func initializeDrawLayer(point: CGPoint)
    {
        drawLayer = CAShapeLayer()
        drawLayer?.fillColor = UIColor.clearColor().CGColor
        drawLayer?.opacity = DEFAULTOPACITY
        drawLayer?.strokeColor = drawColor
        drawLayer?.lineWidth = lineWidth!
        
        if drawShape == Shape.Eraser.rawValue {
            drawLayer?.opacity = 1
            drawLayer?.lineWidth = eraserWidth
        }
        
        drawView.layer.addSublayer(drawLayer!)
        drawFreePath.moveToPoint(point)
    }
    
    //Set border for color buttons. The selected color button will have a border of blue. Only one color button has a blue border.
    func setButtonBorder(colorTag:Int)
    {
        for button in colorButtons
        {
            if button.tag == colorTag
            {
                button.layer.borderColor = UIColor.blueColor().CGColor
                for button in functionButtons
                {
                    button.layer.borderColor = UIColor.clearColor().CGColor
                }
            }
            else
            {
                button.layer.borderColor = UIColor.whiteColor().CGColor
            }
        }
    }
    
    //Set background color for shape buttons.
    func setButtonBackground(shapeTag:Int)
    {
         for button in shapeButtons
         {
            if button.tag == shapeTag
            {
                button.layer.backgroundColor = UIColor.lightGrayColor().CGColor
                for button in functionButtons
                {
                    button.layer.backgroundColor = UIColor.clearColor().CGColor
                }
            }
            else
            {
                button.layer.backgroundColor = UIColor(white: 1, alpha: 0).CGColor
            }
        }
    }
    
    //Calculate the 3rd point of the triangle when user select to draw a triangle shape
    func CalcPoint(givenPoint: CGPoint) -> CGPoint
    {
        var point: CGPoint = CGPoint()
        if givenPoint.x < startPoint.x
        {
            point.x = startPoint.x - givenPoint.x
        }
        else
        {
            point.x = givenPoint.x - (givenPoint.x - startPoint.x) * 2
        }
        point.y = givenPoint.y
        
        return point
    }
    
 }

