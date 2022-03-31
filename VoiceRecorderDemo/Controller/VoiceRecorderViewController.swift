//
//  ViewController.swift
//  VoiceRecorderDemo
//
//  Created by F_Sur on 31/03/2022.
//

import UIKit
import AVFoundation

class VoiceRecorderViewController: UIViewController {
    
    // Recoding Variables
    var recordingSesion: AVAudioSession!
    var voiceRecorder: AVAudioRecorder!
    var voicePlayer: AVAudioPlayer?
    
    // filename for saving
    lazy var numberOfRcorders: Int = 0
    lazy var voicRecordedNames: [String] = [String]()

    
    // View Variables
    var tableview: UITableView!
    var currentIndexPath: IndexPath?
    
    lazy var voiceRecorderBtn: UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
        btn.isHidden = false
        btn.imageView?.contentMode = .scaleAspectFit
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var recordVoiceTimerLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = #colorLiteral(red: 0.3529411765, green: 0.368627451, blue: 0.4039215686, alpha: 1)
        lb.font = UIFont(name: "Arial", size: headerSize3)
        lb.font = UIFont.systemFont(ofSize: headerSize3, weight: .bold)
        lb.textAlignment = .left
//        lb.text = makeDateFormating(date: Date())
        lb.clipsToBounds = true
        lb.adjustsFontSizeToFitWidth = true
        lb.numberOfLines = 1
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    lazy var recorderStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNav()
        initialTableView()
        initialView()
        configView()
        initialData()
    
    }
}

// MARK: - Initial & config View

extension VoiceRecorderViewController {
    
    func configNav() {
        navigationController?.navigationBar.barTintColor = MainColor
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        let titleTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: headerSize1)] as [NSAttributedString.Key: Any]
        
            navigationController?.navigationBar.titleTextAttributes = titleTextAttribute
         title = "Voice Recorder"
    }
    
    func initialView() {
        voiceRecorderBtn.setImage(UIImage(systemName: "mic.circle"), for: .normal)
        voiceRecorderBtn.addTarget(self, action: #selector(voiceRecorderBtnPressed), for: .touchUpInside)
        
    }

    func configView() {
        view.addSubview(tableview)
        view.addSubview(recorderStackView)
        
        recorderStackView.backgroundColor = SecondaryColor
        recorderStackView.addArrangedSubview(recordVoiceTimerLabel)
        recorderStackView.addArrangedSubview(voiceRecorderBtn)
        
//        recordVoiceTimerLabel.text = makeDateFormating(date: Date())
        
        // voiceRecorderBtn
        voiceRecorderBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        voiceRecorderBtn.contentVerticalAlignment = .fill
        voiceRecorderBtn.contentHorizontalAlignment = .fill
        
        //
        recorderStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        recorderStackView.isLayoutMarginsRelativeArrangement = true
//        recorderStackView.layer.cornerRadius = 5
        
        
        NSLayoutConstraint.activate([
            
            voiceRecorderBtn.heightAnchor.constraint(equalToConstant: 60),
            voiceRecorderBtn.widthAnchor.constraint(equalToConstant: 60),
            
            tableview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableview.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tableview.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            recorderStackView.topAnchor.constraint(equalTo: self.tableview.bottomAnchor, constant: 5),
            recorderStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            recorderStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            recorderStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    func initialData() {
        voicePlayer?.delegate = self

        
        if let number: Int = UserDefaults.standard.integer(forKey: K.SavingNumberOfRecords) as? Int {
            numberOfRcorders = number
        }
        if let voiceNames: [String] = UserDefaults.standard.stringArray(forKey: K.VoiceRecorderNames) {
            voicRecordedNames = voiceNames
        }
        recordingSesion = AVAudioSession.sharedInstance()
        
        AVAudioSession.sharedInstance().requestRecordPermission { hasPersmission in
            if hasPersmission {
                print("Accepted")
            } else {

            }
        }
    }
}

// MARK: - TableView

extension VoiceRecorderViewController: UITableViewDelegate, UITableViewDataSource {

    
    // Initial TableView
    func initialTableView() {
        
        tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
//        tableview.separatorStyle = .none
        tableview.register(VoiceTVCell.self, forCellReuseIdentifier: VoiceTVCell.Cell_ID_Voice)
        tableview.translatesAutoresizingMaskIntoConstraints = false
                
    }
    
    // Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voicRecordedNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: VoiceTVCell.Cell_ID_Voice, for: indexPath) as! VoiceTVCell
        cell.recordedVoiceName.text = voicRecordedNames[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        currentIndexPath = indexPath
        playRecordedVoice(indexPath)
    }
}

// MARK: - Voice Recorder

extension VoiceRecorderViewController: AVAudioRecorderDelegate, AVAudioPlayerDelegate{

    @objc func voiceRecorderBtnPressed() {
        
        // check already voice recoder is recording or not
        if voiceRecorder == nil {
            numberOfRcorders += 1
            let currentNameFile = "\(numberOfRcorders) - \(makeDateFormating(date: Date()))"
            let fileName = getDirectory().appendingPathComponent("\(currentNameFile).mp4")
            let settingsOfAudioRecorder = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            // Start recording
            do {
                voiceRecorder = try AVAudioRecorder(url: fileName, settings: settingsOfAudioRecorder)
                voiceRecorder.delegate = self
                voiceRecorder.record()
                
                voiceRecorderBtn.backgroundColor = .red
                
                // Store record in the device
                UserDefaults.standard.setValue(numberOfRcorders, forKey: K.SavingNumberOfRecords)
                voicRecordedNames.append(currentNameFile)
                UserDefaults.standard.setValue(voicRecordedNames, forKey: K.VoiceRecorderNames)
            } catch  {
                self.presentAlert(title: "Ups...!", message: "Recording is failed", options: "Ok") { _ in
                    print(error.localizedDescription)
                }
            }
            
            
        } else {
            // Stoppin voice recorder
            voiceRecorder.stop()
            voiceRecorder = nil
            voiceRecorderBtn.backgroundColor = .none
            tableview.reloadData()
        }
    }
    
    // Play voice record
    fileprivate func playRecordedVoice(_ indexPath: IndexPath) {
        let fileName = getDirectory().appendingPathComponent("\(voicRecordedNames[indexPath.row]).mp4")
        
        do {
            voicePlayer =  try AVAudioPlayer(contentsOf: fileName)
            voicePlayer?.play()
//            let cell = self.tableview.cellForRow(at: indexPath) as! VoiceTVCell
//            cell.voicePalyBtn.setImage(UIImage(systemName: "stop.circle"), for: .normal)
//            tableview.reloadData()
            
        } catch  {
            presentAlert(title: "Ups...!", message: "Can not play audoi.!", options: "Ok") { _ in
                print("Failed to play audio.!")
            }
        }
    }
    
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        if let SafeCurrentIndexPath = currentIndexPath {
//        let cell = self.tableview.cellForRow(at: SafeCurrentIndexPath) as? VoiceTVCell
//            cell?.voicePalyBtn.setImage(UIImage(systemName: "play.circle"), for: .normal)
//            tableview.reloadData()
//        }
//    }
    
}

// MARK: - Helper Funcations

extension VoiceRecorderViewController {
    
    func getDirectory() -> URL{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
     }
    
   
}
 
