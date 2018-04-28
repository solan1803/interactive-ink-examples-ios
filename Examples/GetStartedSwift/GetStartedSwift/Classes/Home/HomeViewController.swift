// Copyright MyScript. All right reserved.

import UIKit
import Antlr4

class HomeViewController: UIViewController {
    
    @IBOutlet weak var inputTypeSegmentedControl: UISegmentedControl!
    
    weak var editorViewController: EditorViewController!
    
    private var contentPackage: IINKContentPackage? = nil
    
    private var documentTitleText: String = "" {
        didSet {
            documentTitleButton.setTitle(documentTitleText, for: UIControlState.normal)
            self.title = documentTitleText
        }
    }
    
    private let documentTitleButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
    
    @IBOutlet weak var loadBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var convertBarButtonItem: UIBarButtonItem!
    
    override func viewWillDisappear(_ animated: Bool) {
        loadBarButtonItem.isEnabled = false
        loadBarButtonItem.isEnabled = true
        convertBarButtonItem.isEnabled = false
        convertBarButtonItem.isEnabled = true
    }
    
    @objc func renameTitle() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Rename file", message: "Change name to: ", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            //getting the input values from user
            if let filename = alertController.textFields?[0].text {
                // check if file already exists with that title
                do {
                    let fullPath = FileManager.default.pathForFile(inDocumentDirectory: filename) + ".iink"
                    if !FileManager.default.fileExists(atPath: fullPath) {
                        let oldPath = URL(fileURLWithPath: FileManager.default.pathForFile(inDocumentDirectory: self.documentTitleText) + ".iink")
                        let newPath = URL(fileURLWithPath: fullPath)
                        try FileManager.default.moveItem(at: oldPath, to: newPath)
                        
                        if FileManager.default.fileExists(atPath: fullPath) {
                            self.loadContent(withFileURL: String(fullPath))
                        }
                    }
                } catch {
                    print("ERROR with renaming file")
                    print(error)
                }
            }
            
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        editorViewController = childViewControllers.first as! EditorViewController
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if (appDelegate.engine == nil)
            {
                let alert = UIAlertController(title: "Certificate error",
                                              message: appDelegate.engineErrorMessage,
                                              preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK",
                                              style: UIAlertActionStyle.default,
                                              handler: {(action: UIAlertAction) -> Void in
                                                  exit(1)
                                              }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            editorViewController.engine = appDelegate.engine
        }
        
        editorViewController.inputMode = .forcePen  // We want the Pen mode for this GetStarted sample code. It lets the user use either its mouse or fingers to draw.
        // If you have got an iPad Pro with an Apple Pencil, please set this value to InputModeAuto for a better experience.
        
        inputTypeSegmentedControl.selectedSegmentIndex = Int(editorViewController.inputMode.rawValue)

        do {
            if let package = try createPackage(packageName: "New") {
                contentPackage = package
                try editorViewController.editor.part = package.getPartAt(0)
            }
        } catch {
            print("Error while creating package : " + error.localizedDescription)
        }
        
        documentTitleButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        documentTitleButton.addTarget(self, action: #selector(self.renameTitle), for: UIControlEvents.touchUpInside)
        self.navigationItem.titleView = documentTitleButton;
    }
    
    // MARK: - Create package

    func createPackage(packageName: String) throws -> IINKContentPackage? {
        // Create a new content package with name
        var resultPackage: IINKContentPackage?
        let fullPath = FileManager.default.pathForFile(inDocumentDirectory: packageName) + ".iink"
        if let engine = (UIApplication.shared.delegate as? AppDelegate)?.engine {
            if !FileManager.default.fileExists(atPath: fullPath) {
                resultPackage = try engine.createPackage(fullPath.decomposedStringWithCanonicalMapping)
                
                // Add a blank page type Text Document
                if let part = try resultPackage?.createPart("Text Document") /* Options are : "Diagram", "Drawing", "Math", "Text Document", "Text" */ {
                    documentTitleText = packageName
                }
            } else {
                resultPackage = try engine.openPackage(fullPath)
            }
        }
        return resultPackage
    }
    
    // MARK: - Buttons actions

    @IBAction func clearButtonWasTouchedUpInside(_ sender: Any) {
        editorViewController.editor.clear()
    }
    
    @IBAction func undoButtonWasTouchedUpInside(_ sender: Any) {
        editorViewController.editor.undo()
    }
    
    @IBAction func redoButtonWasTouchedUpInside(_ sender: Any) {
        editorViewController.editor.redo()
    }
    
    private var wordsList: [[Word]] = []
    
     func convertButtonWasTouchedUpInside() -> String {
        do {
            //let supportedTargetStates = editorViewController.editor.getSupportedTargetConversionState(nil)
            let export = try editorViewController.editor.export_(nil, mimeType: IINKMimeType.JIIX)
            let exportJSON = export.toJSON()
            print(exportJSON)
            wordsList = []
            if let jsonObj = exportJSON as? [String: Any] {
                if let children = jsonObj["children"] as? [[String: Any]] {
                    let completeLabel = "\(children[0]["label"]!)"
                    if let words = children[0]["words"] as? [[String: Any]] {
                        var candidateWords = "";
                        var lineOfWords : [Word] = []
                        for w in words {
                            if let label = w["label"] {
                                if label as? String != " " {
                                    if label as? String == "\n" {
                                        wordsList.append(lineOfWords)
                                        lineOfWords = []
                                        candidateWords += "NEWLINE \n"
                                    } else {
                                        candidateWords += "(label: \(label))    "
                                        if let candidates = w["candidates"] {
                                            let newWord = Word(label: label as! String, candidates: candidates as! [String])
                                            lineOfWords.append(newWord)
                                            let candidatesOnOneLine = (candidates as? [String])?.joined(separator: " ");
                                            candidateWords += "\(candidatesOnOneLine ?? "could not join candidate words") \n "
                                        } else {
                                            let newWord = Word(label: label as! String, candidates: [])
                                            lineOfWords.append(newWord)
                                            candidateWords += "no candidate words \n"
                                        }
                                    }
                                }
                            } else {
                                candidateWords += "ERROR: no label \n"
                            }
                            
                        }
                        // Remember to add last line of words to wordlist
                        wordsList.append(lineOfWords)
                        let preprocessErrors = preprocessMyScriptRecognition()
                        var preprocessRecognition = ""
                        for eachLine in wordsList {
                            for w in eachLine {
                                preprocessRecognition += w.label
                                preprocessRecognition += " "
                            }
                            preprocessRecognition += "\n "
                        }
                        let result = getParseTree(completeLabel)
                        return "MyScript Recognition: \n \(completeLabel) \n PreProcessing Stage: \n \(preprocessRecognition) \n Candidates: \n \(candidateWords) \n PreProcessResult: \(preprocessErrors) \n \(result)"
                        //outputConvertedCode.text = "Label: \(label) Candidates: \(candidateWords)"
                    }
                }
            }
            // try editorViewController.editor.convert(nil, targetState: supportedTargetStates[0].value)
        } catch {
            print("Error while converting : " + error.localizedDescription)
        }
        return ""
    }
    
    func preprocessMyScriptRecognition() -> String {
        var preprocessMessage = "PREPROCESS ERRORS AT LINES: \n"
        for (index, eachLine) in wordsList.enumerated() {
            // Each line of code should end with a { or a ; (we are excluding short if-statements)
            // Otherwise line of code should only have one character the closing curly brace }
            // This is forcing the code to be in a certain style!
            // Also this analysis wont work if the user writes one line of code over multiple lines????
            if eachLine.last?.label != "{" && eachLine.last?.label != ";" &&
                !(eachLine.last?.label == "}" && eachLine.count == 1) {
                if eachLine.count == 1 && eachLine.last?.label.count == 1 && eachLine.last?.label != "}" {
                    // If there is only one character on the line it has to be }
                    preprocessMessage += "Line \(index) - If only one character on line then has to be } \n"
                    eachLine.last?.label = "}"
                } else {
                    // Loop through candidates and see if { or ; comes first and use this as label
                    var fixed = false
                    for c in (eachLine.last?.candidates)! {
                        if c == "{" || c == ";" {
                            preprocessMessage += "Line \(index) - Fix last character should be '{' or ';', we made it \(c) \n"
                            eachLine.last?.label = c
                            fixed = true
                            break
                        }
                    }
                    if !fixed {
                        preprocessMessage += "Line \(index) - Could not fix last character to be { or ; since not in candidates \n"
                        // maybe could look at first word to categorise the line to see if it should end in a '{'.... looking at first word wont help in categorising start of function
                        // ... may as well fix inside ANTLR in the match function when trying to match { but failing!
                    }
                }
            }
        }
        return preprocessMessage
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showConversion":
                let output = convertButtonWasTouchedUpInside()
                if let covc = segue.destination as? ConvertedOutputViewController {
                    covc.convertedText = output
                }
            default: break
            }
        }
    }

    func getParseTree(_ sourceCode: String) -> String {
        let input = ANTLRInputStream(sourceCode);
        var result = "";
        /* Create a lexer that feeds off of input CharStream */
        let lexer = Java9Lexer(input);
        
        /* Create a buffer of tokens pulled from the lexer */
        let tokens = CommonTokenStream(lexer);
        
        /* Create a parser that feeds off the tokens buffer */
        if let parser = try? Java9Parser(tokens) {
            /* Generate AST, begin parsing at the program rule */
            if let tree = try? parser.classBodyDeclaration() {
                let printStr = Java9PrintRulesWalker(parser).visit(tree) ?? ""
                print("\(printStr)")
                let treeString = tree.getText()
                result = "Parse Tree: \n \(printStr) \n Final Output: \n \(treeString)"
            }
        }
        return result
    }
    
    // MARK: - Segmented control actions
    
    @IBAction func inputTypeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        guard let inputMode = InputMode(rawValue: UInt(sender.selectedSegmentIndex)) else {
            return
        }
        editorViewController.inputMode = inputMode
    }
    
    @IBAction func saveContent(_ sender: UIBarButtonItem) {
        do {
            try contentPackage?.save()
        } catch {
            print("Error trying to save")
        }
    }
    
    public func loadContent(withFileURL fileURL: String) {
        if let engine = (UIApplication.shared.delegate as? AppDelegate)?.engine {
            if FileManager.default.fileExists(atPath: fileURL) {
                do {
                    let package = try engine.openPackage(fileURL)
                    contentPackage = package
                    documentTitleText = String(fileURL[fileURL.index(fileURL.startIndex, offsetBy: 87)...fileURL.index(fileURL.endIndex, offsetBy: -6)])
                    //editorViewController.editor.clear()
                    try editorViewController.editor.part = package.getPartAt(0)
                } catch {
                    print("ERROR: loadContent")
                }
            }
        }
    }
    
    private func printFilesInDocumentsDirectory() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            print(fileURLs)
            // process files
        } catch {
            print("Error while enumerating files: \(error.localizedDescription)")
        }
    }
    
}

public class Word {
    var label: String
    var candidates: [String]
    
    init(label l: String, candidates c: [String]) {
        label = l
        candidates = c
    }
}

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}

