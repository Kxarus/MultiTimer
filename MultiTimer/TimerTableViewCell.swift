//
//  TimerTableViewCell.swift
//  MultiTimer
//
//  Created by Roman Kiruxin on 10.09.2021.
//

import UIKit

class TimerTableViewCell: UITableViewCell {
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel(frame: CGRect(x: 4, y: 7, width: 100, height: 30))
        nameLabel.backgroundColor = .green
        nameLabel.textColor = .black
        return nameLabel
    }()
    
    lazy var labelTimer: UILabel = {
        let labelTimer = UILabel(frame: CGRect(x: 195, y: 7, width: 100, height: 30))
        labelTimer.backgroundColor = .green
        labelTimer.textColor = .black
        labelTimer.textAlignment = .center
        return labelTimer
    }()
    
    lazy var buttonPause: UIButton = {
        let img = UIImage(systemName: "pause.circle.fill")
        let buttonPause = UIButton.systemButton(with: img!, target: self, action: #selector(clickPause))
        buttonPause.frame = CGRect(x: 140, y: 7, width: 50, height: 30)
        
        return buttonPause
    }()
    
    var timer: Timer?
    var state = true

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(nameLabel)
        addSubview(labelTimer)
        addSubview(buttonPause)
    }
    
    @objc func clickPause(sender: UIButton) {
        if state == true {
            state = false
            buttonPause.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        } else {
            state = true
            buttonPause.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        }
    }
    
    var tableView:UITableView? {
            return superview as? UITableView
        }

    var indexPath:IndexPath? {
        return tableView?.indexPath(for: self)
    }

    func stringTimeToSecond(stringTime: String) -> Int {

        let mas : [String] = stringTime.components(separatedBy: ":")

        let h = Int(mas[0])
        let m = Int(mas[1])
        let s = Int(mas[2])

        let sec = h! * 3600 + m! * 60 + s!

        return sec
    }
    
    func secondsToHoursMinutesSeconds(seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func stringSecondsToHoursMinutesSeconds(seconds: Int) -> String {
        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: seconds)
      return "\(h):\(m):\(s)"
    }

    func updateTimer() {
        
        if state == true {
            var seconds = stringTimeToSecond(stringTime: labelTimer.text!)

            if seconds != 0 {
                seconds -= 1
                labelTimer.text = stringSecondsToHoursMinutesSeconds(seconds: seconds)//
            } else {
                state = false //
            }
            //labelTimer.text = stringSecondsToHoursMinutesSeconds(seconds: seconds)
        } else {
            return
        }
    }

}
