//
//  ViewController.swift
//  Fitbod
//
//  Created by Sang Saephan on 11/16/17.
//  Copyright © 2017 Sang Saephan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var components = [[String]]()
    var maxRep = Dictionary<String,Int>()
    var maxRepArray = [String]()
    var maxRepAtDate = Dictionary<String,[Any]>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let path = Bundle.main.path(forResource: "workoutData", ofType: "txt")
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path!) {

            do {
                
                let fullText = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
                let readings = fullText.components(separatedBy: "\n") as [String]
                
                // Break up each line into components (date, name, exercise, etc.)
                for i in 0..<readings.count - 1 {
                    components.append(readings[i].components(separatedBy: ",") as [String])
                }
                
            } catch let error as Error {
                print("Error: \(error)")
            }

        }
        
        determineMaxRepForExercise()
        determineMaxRepAtDate()
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maxRep.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as! ExerciseCell
        cell.selectionStyle = .none
        
        cell.exerciseLabel.text = maxRepArray[indexPath.row]
        cell.weightLabel.text = "\(maxRep["\(maxRepArray[indexPath.row])"]!)"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Prepare data to pass to the next view
        let exercise = maxRepArray[indexPath.row]
        let weight = "\(maxRep["\(maxRepArray[indexPath.row])"]!)"
        var exerciseDates = Dictionary<String, [Any]>()
        
        for item in maxRepAtDate where item.value[0] as! String == exercise {
            exerciseDates[item.key] = [item.value[0], item.value[1]]
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        performSegue(withIdentifier: "plotVC", sender: [exercise, weight, exerciseDates])
        
    }
    
    func determineMaxRepAtDate() {
        
        // For each date at each exercise, determine the max rep
        for exercise in maxRepArray {
            
            for item in components where item[1] == exercise {
                
                let currentMaxRep = calculateOneRepMax(weight: Int(item[4])!, rep: Int(item[3])!)
                
                if let max = maxRepAtDate["\(item[0])"] {
                    
                    if (max[1] as! Int) < currentMaxRep {
                        maxRepAtDate["\(item[0])"] = [exercise, currentMaxRep]
                    }
                    
                } else {
                    maxRepAtDate["\(item[0])"] = [exercise, currentMaxRep]
                }
                
            }
            
        }
        
    }
    
    func determineMaxRepForExercise() {
        
        for item in components {

            let currentMaxRep = calculateOneRepMax(weight: Int(item[4])!, rep: Int(item[3])!)

            if let max = maxRep["\(item[1])"] {

                // If the current max rep is greater than the previous, replace it as the max rep
                if max < currentMaxRep {
                    maxRep["\(item[1])"] = currentMaxRep
                }

            } else {
                maxRep["\(item[1])"] = currentMaxRep
            }

        }

        maxRepArray = maxRep.keys.sorted()
        
    }

    func calculateOneRepMax(weight: Int, rep: Int) -> Int {
        // Brzycki formula for one-rep max
        return Int(Double(weight) / (1.0278 - (0.0278 * Double(rep))))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "plotVC" {
            
            if let destinationController = segue.destination as? PlotViewController {
                
                if let details = sender as? [Any] {
                    destinationController.details = [details[0] as! String, details[1] as! String]
                    destinationController.maxRepAtDate = details[2] as! Dictionary<String, [Any]>
                }
                
            }
            
        }
        
    }

}

