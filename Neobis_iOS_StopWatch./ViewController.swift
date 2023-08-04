//
//  ViewController.swift
//  Neobis_iOS_StopWatch.
//
//  Created by Bermet Toichubekova on 31/7/23.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var imageTimerStopWatch: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var segmentStopWatch: UISegmentedControl!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timePicker: UIPickerView!
    
    
    var timer = Timer()
    var timerStopwatch = Timer()
    var countTimerLaunch = 0
    var remainingTime: TimeInterval = 0
    var isTimerRunning = false
    var isStopwatchMode = false
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentStopWatch.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        updateImageForSegment(segmentIndex: segmentStopWatch.selectedSegmentIndex)
        timePicker.delegate = self
        timePicker.dataSource = self
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return 24
        case 1: return 60
        case 2: return 60
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(format: "%02d", row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        hours = pickerView.selectedRow(inComponent: 0)
        minutes = pickerView.selectedRow(inComponent: 1)
        seconds = pickerView.selectedRow(inComponent: 2)
        
        updateLabel()
    }
    
    func updateLabel() {
        let hoursString = String(format: "%02d", Int(remainingTime) / 3600)
        let minutesString = String(format: "%02d", (Int(remainingTime) % 3600) / 60)
        let secondsString = String(format: "%02d", Int(remainingTime) % 60)
        
        let timeString = "\(hoursString):\(minutesString): \(secondsString)"
        timerLabel.text = timeString
    }
    
    func startStopWatch() {
        if !isTimerRunning {
        remainingTime = TimeInterval(hours * 3600 + minutes * 60 + seconds)
        timerStopwatch.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        isTimerRunning = true
        }
    }
    
    func pauseStopWatch() {
        timerStopwatch.invalidate()
        isTimerRunning = false
        
    }
    
    func resetStopWatch() {
        timerStopwatch.invalidate()
        isTimerRunning = false
        
    }
    
    @objc func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
            updateLabel()
        } else {
            pauseStopWatch()
        }
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        updateImageForSegment(segmentIndex: sender.selectedSegmentIndex)
    }
    
    func updateImageForSegment(segmentIndex: Int) {
        isStopwatchMode = segmentStopWatch.selectedSegmentIndex == 1
        if isStopwatchMode {
            imageTimerStopWatch.image = UIImage(systemName: "stopwatch")
            imageTimerStopWatch.tintColor = .black
            timePicker.isHidden = false
        } else {
            imageTimerStopWatch.image = UIImage(systemName: "timer")
            imageTimerStopWatch.tintColor = .black
            timePicker.isHidden = true
        }
    }
    
    @IBAction func Stopwatch(_ sender: Any) {
        segmentedControlValueChanged(segmentStopWatch)
        
    }
    
    func startTimer() {
        if !isTimerRunning {
            isTimerRunning = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(action), userInfo: nil, repeats: true)
        }
    }
    
    @objc func action() {
        
        if isTimerRunning {
            countTimerLaunch += 1
            let time = hours(seconds: countTimerLaunch)
            let timerString = formatTime(hours: time.0, minute: time.1, second: time.2)
            timerLabel.text = timerString
        }
    }
    
    
    func hours(seconds: Int) -> (Int, Int ,Int) {
        return ((seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }
    
    func formatTime(hours: Int, minute: Int, second: Int) -> String {
        let timerString = String(format: "%02d:%02d:%02d", hours, minute, second)
        return timerString
    }
    
    func pauseTimer() {
        timer.invalidate()
        isTimerRunning = false
        
    }
    
    func resetTimer() {
        timer.invalidate()
        countTimerLaunch = 0
        timerLabel.text = "00:00:00"
        
    }
    
    
    
    @IBAction func startButton(_ sender: Any) {
        isStopwatchMode = segmentStopWatch.selectedSegmentIndex == 1
        if isStopwatchMode {
            startStopWatch()
        } else {
            startTimer()
        }
    }
    @IBAction func pauseButton(_ sender: Any) {
        pauseTimer()
    }
    @IBAction func stopButton(_ sender: Any) {
        resetTimer()
    }
}



