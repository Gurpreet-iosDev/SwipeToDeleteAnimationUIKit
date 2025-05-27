//
//  ViewController.swift
//  Swipe-delete
//
//  Created by Gurpreet on 27/05/25.
//

import UIKit

class ViewController: UIViewController {

    let cardView = UIView()
    var originalCenter: CGPoint = .zero
    var undoButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCard()
    }

    func setupCard() {
        cardView.frame = CGRect(x: 40, y: 350, width: view.frame.width - 80, height: 150)
        cardView.backgroundColor = .systemBlue
        cardView.layer.cornerRadius = 16
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.3
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 8
        view.addSubview(cardView)

        originalCenter = cardView.center

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        cardView.addGestureRecognizer(panGesture)
    }

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            cardView.center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
        case .ended:
            let velocity = gesture.velocity(in: view)
            let shouldDismiss = abs(translation.x) > 120 || abs(velocity.x) > 500
            
            if shouldDismiss {
                let offScreenX = translation.x > 0 ? view.frame.width + 200 : -200
                UIView.animate(withDuration: 0.3, animations: {
                    self.cardView.center.x = offScreenX
                    self.cardView.alpha = 0
                }, completion: { _ in
                    self.cardView.removeFromSuperview()
                    self.showUndoButton()
                })
            } else {
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: 0.6,
                               initialSpringVelocity: 1.0,
                               options: [.curveEaseOut],
                               animations: {
                    self.cardView.center = self.originalCenter
                }, completion: nil)
            }
        default:
            break
        }
    }

    func showUndoButton() {
        let button = UIButton(type: .system)
        button.setTitle("Undo", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemRed
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.frame = CGRect(x: 100, y: 400, width: view.frame.width - 200, height: 50)
        button.addTarget(self, action: #selector(undoAction), for: .touchUpInside)
        view.addSubview(button)
        undoButton = button
    }

    @objc func undoAction() {
        undoButton?.removeFromSuperview()
        setupCard()
    }
}
