//
//  ExecutionCode.swift
//  GetStartedSwift
//
//  Created by Solan Manivannan on 30/05/2018.
//  Copyright © 2018 MyScript. All rights reserved.
//

import Foundation

func executeCodeOnServer(codeBody: String)->String {
    // Create code file to be sent to server
    var codeString = "public class JavaTest { \n"
    codeString = codeString + codeBody
    codeString = codeString + "}"
    print(codeString)
    
    let fileManager = FileManager.default
    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    do {
        // Store code file in a subdirectory
        try? FileManager.default.createDirectory(atPath: documentsURL.appendingPathComponent("CodeFiles").path, withIntermediateDirectories: true)
        try codeString.write(to: documentsURL.appendingPathComponent("CodeFiles").appendingPathComponent("JavaTest.java"), atomically: false, encoding: String.Encoding.utf8)
    } catch {
        print("Error trying to write file \(error.localizedDescription)")
    }
    
    // Retrieve Server Settings
    let defaults = UserDefaults.standard
    var serverSettings: Dictionary<String, String> = [:]
    if let d = defaults.dictionary(forKey: "ServerSettings") {
        serverSettings = d as! Dictionary<String, String>
    } else {
        return "No Server Settings!"
    }
    // Start SSH session and transfer codefile through SFTP
    var outputText = ""
    let session = NMSSHSession(host: serverSettings["IP-ADDRESS"], andUsername: serverSettings["Username"])
    session?.connect()
    if (session?.isConnected)! {
        outputText = outputText + "Session connected \n"
        session?.authenticate(byPassword: serverSettings["Password"])
        if (session?.isAuthorized)! {
            outputText = outputText + "Authentication succeeded \n"
            session?.sftp.connect()
            if (session?.sftp.isConnected)! {
                outputText = outputText + "SFTP connected \n"
                let writeSuccess = session?.sftp.writeFile(atPath: documentsURL.appendingPathComponent("CodeFiles").appendingPathComponent("JavaTest.java").path, toFileAtPath: "JavaTest.java")
                outputText = outputText + "Copy codefile: \(writeSuccess!) \n"
            }
            session?.sftp.disconnect()
            // Compile JavaTest.java
            outputText = outputText + "Compiling JavaTest.java \n"
            // Errors from compiling are redirected from stderr to stdout so that we dont have to wait for the error object to populate.
            var response = session?.channel.execute("javac JavaTest.java 2>&1", error: nil, timeout: 50)
            if let r = response {
                if (r == "") {
                    outputText = outputText + "Compilation succeeded! \n"
                    response = session?.channel.execute("java JavaTest", error: nil, timeout: 50)
                    outputText = outputText + "Running... \n"
                    outputText = outputText + "Output: \(response ?? "")"
                } else {
                    // Print compilation errors
                    outputText = outputText + "\(r) \n"
                }
            }
        }
    }
    session?.disconnect()
    return outputText
}

func executeCodeOnLeetCode(codeBody: String, filename: String, outputTextField: UITextView!) {
    // Get Leetcode Login Details
    var login = ""
    var password = ""
    let defaults = UserDefaults.standard
    if let d = defaults.dictionary(forKey: "LeetCodeDetails") {
        let leetcodeDetails = d as! Dictionary<String, String>
        login = leetcodeDetails["login"]!
        password = leetcodeDetails["password"]!
    }
    
    // Get leetcode problem id and build complete codestring
    var id = ""
    var codeString = ""
    var problemURL = ""
    if let d = defaults.dictionary(forKey: "FileSettings") {
        var allFileSettings = d as! Dictionary<String, Dictionary<String, String>>
        if let fs = allFileSettings[filename] {
            id = fs["id"]!
            let index = Int(id)! - 1
            codeString = LEETCODE_DATA[index][6] + codeBody + LEETCODE_DATA[index][7]
            problemURL = LEETCODE_DATA[index][2]
        }
    }
    
    let defaultSession = URLSession(configuration: .default)
    let url = URL(string: "https://leetcode.com/accounts/login/")
    let task = defaultSession.dataTask(with: url!) {(data, response, error) in
        var csrfToken = ""
        if let httpResponse = response as? HTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: response!.url!)
            csrfToken = cookies[0].value
            print("csrfToken set to: \(csrfToken)")
            DispatchQueue.main.async {
                outputTextField.text = outputTextField.text + "GET https://leetcode.com/accounts/login/ STATUS \(httpResponse.statusCode)\n"
            }
        }
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("content-type", forHTTPHeaderField: "application/x-www-form-urlencoded")
        request.httpBody = "login=\(login)&password=\(password)&csrfmiddlewaretoken=\(csrfToken)".data(using: .utf8)
        request.setValue("https://leetcode.com/accounts/login/", forHTTPHeaderField: "referer")
        let signInTask = defaultSession.dataTask(with: request) {(data, response, error) in
            print(response!)
            if let httpResponse = response as? HTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: response!.url!)
                if cookies.count > 1 {
                    csrfToken = cookies[1].value
                }
                print("csrfToken set to: \(csrfToken)")
                DispatchQueue.main.async {
                    outputTextField.text = outputTextField.text + "POST https://leetcode.com/accounts/login/ STATUS \(httpResponse.statusCode)\n"
                }
            }
            // Submit code for a specific problem
            let problemTask = defaultSession.dataTask(with: URL(string: "https://leetcode.com\(problemURL)/description/")!) {(data, response, error) in
                print(response!)
                if let httpResponse = response as? HTTPURLResponse {
                    DispatchQueue.main.async {
                        outputTextField.text = outputTextField.text + "GET https://leetcode.com\(problemURL)/description/ STATUS \(httpResponse.statusCode)\n"
                    }
                }
                let submitDictionary = ["data_input": "",
                                        "judge_type": "large",
                                        "lang" : "java",
                                        "question_id" : id,
                                        "test_mode" : "false",
                                        "typed_code" : codeString]
                var submitRequest = URLRequest(url: URL(string: "https://leetcode.com\(problemURL)/submit/")!)
                submitRequest.httpMethod = "POST"
                guard let httpBody = try? JSONSerialization.data(withJSONObject: submitDictionary, options: []) else {
                    return
                }
                submitRequest.setValue(csrfToken, forHTTPHeaderField: "x-csrftoken")
                submitRequest.setValue("https://leetcode.com\(problemURL)/description/", forHTTPHeaderField: "referer")
                submitRequest.httpBody = httpBody
                print(httpBody)
                let submitTask = defaultSession.dataTask(with: submitRequest) {(data, response, error) in
                    print(response!)
                    if let httpResponse = response as? HTTPURLResponse {
                        DispatchQueue.main.async {
                            outputTextField.text = outputTextField.text + "POST https://leetcode.com\(problemURL)/submit/ STATUS \(httpResponse.statusCode)\n"
                        }
                    }
                    let jsonString = String(data: data!, encoding: .utf8)?.toJSON() as? [String: Int]
                    let submissionId = jsonString!["submission_id"]
                    DispatchQueue.main.async {
                        outputTextField.text = outputTextField.text + "submission_id: " + String(describing: submissionId) + "\nRetrieving Submission in 5 seconds\n"
                    }
                    var retrieveSubmissionRequest = URLRequest(url: URL(string: "https://leetcode.com/submissions/detail/\(submissionId!)/check/")!)
                    retrieveSubmissionRequest.httpMethod = "GET"
                    let retrieveSubmissionTask1 = defaultSession.dataTask(with: retrieveSubmissionRequest) {(data, response,  error) in
                        print(response!)
                        if let httpResponse = response as? HTTPURLResponse {
                            DispatchQueue.main.async {
                                outputTextField.text = outputTextField.text + "GET https://leetcode.com/submissions/detail/\(submissionId!)/check/ STATUS \(httpResponse.statusCode)\n"
                            }
                        }
                        let submissionString1 = String(data: data!, encoding: .utf8)?.toJSON() as? [String: Any]
                        print(submissionString1!)
                        DispatchQueue.main.async {
                            outputTextField.text = outputTextField.text + String(data: data!, encoding: .utf8)!
                        }
                    }
                    sleep(5) // wait before retrieving submission results
                    retrieveSubmissionTask1.resume()
                }
                submitTask.resume()
            }
            problemTask.resume()
        }
        signInTask.resume()
    }
    task.resume()
}
