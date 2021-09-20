//
//  ViewController.swift
//  MultiTimer
//
//  Created by Roman Kiruxin on 10.09.2021.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    var tableViewTimers = UITableView()
    var labelAddTimer = UILabel()
    var tfNameTimer = UITextField()
    var tfTimeInSeconds = UITextField()
    var buttonAdd = UIButton()
    
    var timers = [Timers]()
    var newTimers = [Timers]()
    
    var nameTimer = ""
    var timerTime = ""
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Label "добавления таймеров"
        setLabelAddTimer()
        
        //TF "название таймера"
        setTFNameTimer()
        
        //TF "время в секундах"
        setTFTimeInSeconds()
        
        //Кнопка "добавить"
        setButtonAdd()
        
        //TableView "таймеры"
        setTableView()
        
        
    }
    
    func setTableView() {
        tableViewTimers.frame = CGRect(x: 40, y: 330, width: 300, height: 350)
        tableViewTimers.backgroundColor = .green
        
        tableViewTimers.dataSource = self
        tableViewTimers.delegate = self
        
        self.view.addSubview(tableViewTimers)
        
        tableViewTimers.register(TimerTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func setLabelAddTimer() {
        let labelAddTimer: UILabel = UILabel()
        labelAddTimer.frame = CGRect(x: 90, y: 120, width: 200, height: 21)
        labelAddTimer.backgroundColor = .gray
        labelAddTimer.translatesAutoresizingMaskIntoConstraints = false
        
        labelAddTimer.textColor = .black
        labelAddTimer.textAlignment = .center
        labelAddTimer.text = "Добавление таймеров"
        
        self.view.addSubview(labelAddTimer)
        
        let topAnchor = labelAddTimer.topAnchor.constraint(equalTo: view.topAnchor, constant: 120)
        let leftAnchor = labelAddTimer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 90)
        
        NSLayoutConstraint.activate([topAnchor, leftAnchor])
        
        labelAddTimer.widthAnchor.constraint(equalToConstant: 200).isActive = true
        labelAddTimer.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
    }
    
    func setTFNameTimer() {
        let tfNameTimer: UITextField = UITextField()
        tfNameTimer.frame = CGRect(x: 40, y: 170, width: 200, height: 30)
        tfNameTimer.backgroundColor = .orange
        tfNameTimer.layer.cornerRadius = 5
        tfNameTimer.keyboardType = UIKeyboardType.default
        tfNameTimer.returnKeyType = UIReturnKeyType.done
        tfNameTimer.placeholder = "Название таймера"
        tfNameTimer.clearButtonMode = UITextField.ViewMode.whileEditing
        tfNameTimer.delegate = self
        tfNameTimer.addTarget(self, action: #selector(typingNameTimer), for: .editingChanged)
        self.view.addSubview(tfNameTimer)
    }
    
    func setTFTimeInSeconds() {
        let tfTimeInSeconds: UITextField = UITextField()
        tfTimeInSeconds.frame = CGRect(x: 40, y: 210, width: 200, height: 30)
        tfTimeInSeconds.backgroundColor = .orange
        tfTimeInSeconds.layer.cornerRadius = 5
        tfTimeInSeconds.keyboardType = .numberPad
        tfTimeInSeconds.returnKeyType = UIReturnKeyType.done
        tfTimeInSeconds.placeholder = "Время в секундах"
        tfTimeInSeconds.clearButtonMode = UITextField.ViewMode.whileEditing
        tfTimeInSeconds.delegate = self
        tfTimeInSeconds.addTarget(self, action: #selector(typingTimerTime), for: .editingChanged)
        self.view.addSubview(tfTimeInSeconds)
    }
    
    func setButtonAdd() {
        let buttonAdd = UIButton(type: .system)
        buttonAdd.frame = CGRect(x: 40, y: 270, width: 300, height: 50)
        buttonAdd.backgroundColor = .blue
        buttonAdd.setTitle("Добавить", for: .normal)
        buttonAdd.addTarget(self, action: #selector(clickAdd), for: .touchUpInside)
        self.view.addSubview(buttonAdd)
    }
    
    @objc func typingNameTimer(sender: UITextField) {
        if let typedText = sender.text {
            nameTimer = typedText
        }
    }
    
    func secondsToHoursMinutesSeconds(seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func stringSecondsToHoursMinutesSeconds(seconds: Int) -> String {
        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: seconds)
      return "\(h):\(m):\(s)"
    }
    
    func stringTimeToSecond(stringTime: String) -> Int {
        let mas : [String] = stringTime.components(separatedBy: ":")

        let h = Int(mas[0])
        let m = Int(mas[1])
        let s = Int(mas[2])

        let sec = h! * 3600 + m! * 60 + s!

        return sec
    }
    
    @objc func typingTimerTime(sender: UITextField) {
        
        if let typedText = sender.text {
            timerTime = stringSecondsToHoursMinutesSeconds(seconds: Int(typedText) ?? 0)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true;
        }
    
    @objc func clickAdd(sender: UIButton) {
        
        self.view.endEditing(true)
        if timerTime == "" {
            let alert = UIAlertController(title: "Ошибка ввода!", message: "Введите время таймера", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {
            timers.append(Timers(name: nameTimer, time: timerTime))
            createTimer()
            
            newTimers = timers.sorted{stringTimeToSecond(stringTime: $0.time) > stringTimeToSecond(stringTime: $1.time) }

            var indexNewTimer = 0

            for i in newTimers {
                if timerTime != i.time {
                    indexNewTimer += 1
                } else {
                    break
                }
            }

            let indexPath = IndexPath(row: indexNewTimer, section: 0)

            self.tableViewTimers.beginUpdates()
            self.tableViewTimers.insertRows(at: [indexPath], with: .top)
            self.tableViewTimers.endUpdates()
            
            for view in self.view.subviews {
                if let textField = view as? UITextField {
                    textField.text = ""
                }
            }
            
            nameTimer = ""
            timerTime = ""
            
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newTimers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TimerTableViewCell
        
        cell.selectionStyle = .none
        cell.nameLabel.text = newTimers[indexPath.row].name
        cell.labelTimer.text = newTimers[indexPath.row].time

        return cell
    }
}

// MARK: - Timer
extension ViewController {
    
    func createTimer() {
      if timer == nil {
        let timer = Timer(timeInterval: 1.0,
          target: self,
          selector: #selector(updateTimer),
          userInfo: nil,
          repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        timer.tolerance = 0.1

        self.timer = timer
      }
    }
    
    @objc func updateTimer() {
      guard let visibleRowsIndexPaths = tableViewTimers.indexPathsForVisibleRows else {
        return
      }
      
      for indexPath in visibleRowsIndexPaths {
        if let cell = tableViewTimers.cellForRow(at: indexPath) as? TimerTableViewCell {
          cell.updateTimer()
          
            if cell.labelTimer.text == "0:0:0" {
                newTimers.remove(at: indexPath.row)
                self.tableViewTimers.beginUpdates()
                self.tableViewTimers.deleteRows(at: [indexPath], with: .top)
                self.tableViewTimers.endUpdates()
            }
        }
      }
    }
}



