//
//  ViewController.swift
//  blurViewTest
//
//  Created by Changyul Seo on 2020/11/05.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay

class ViewController: UIViewController {

    @IBOutlet weak var colorHeight: NSLayoutConstraint!
    @IBOutlet var colorViews: [UIView]!
    
    @IBOutlet var sliders:[UISlider]!
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for (index,slider) in sliders.enumerated() {
            colorViews[index].alpha = CGFloat(slider.value)
            slider.rx.value.bind { [unowned self](value) in
                colorViews[index].alpha = CGFloat(value)
                colorViews[index].isHidden = value == 0
                fixHeight()
            }.disposed(by: disposeBag)
        }
        fixHeight()
    }

    var oldCount:Int? = nil
    func fixHeight() {
        for view in colorViews {
            if let v = view.subviews.first {
                v.layer.cornerRadius = v.frame.width / 2
            }
        }
        let count = colorViews.filter { (view) -> Bool in
            return view.alpha > 0
        }.count
        if oldCount == count {
            return
        }
        if count == 0 {
            return
        }
        
        let h = UIScreen.main.bounds.height  / CGFloat(count) + 20
        colorHeight.constant = h
        UIView.animate(withDuration: 0.25) {[weak self] in
            self?.view.layoutIfNeeded()
        }
        oldCount = count
        
    }

}

