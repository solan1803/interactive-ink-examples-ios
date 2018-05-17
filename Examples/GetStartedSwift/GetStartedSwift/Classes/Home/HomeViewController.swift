// Copyright MyScript. All right reserved.

import UIKit
import Antlr4

class HomeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
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
    @IBOutlet weak var settingsBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var highlightSwitch: UISwitch!
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionary(forKey: "InjectionCandidates")
        injectionList = []
        for k in (dictionary?.keys)! {
            let w = Word(label: k, candidates: dictionary![k] as! [String])
            injectionList.append(w)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        loadBarButtonItem.isEnabled = false
        loadBarButtonItem.isEnabled = true
        convertBarButtonItem.isEnabled = false
        convertBarButtonItem.isEnabled = true
        settingsBarButtonItem.isEnabled = false
        settingsBarButtonItem.isEnabled = true
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
            //print(exportJSON)
            wordsList = []
            if let jsonObj = exportJSON as? [String: Any] {
                if let children = jsonObj["children"] as? [[String: Any]] {
                    let completeLabel = "\(children[0]["label"]!)"
                    if let words = children[0]["words"] as? [[String: Any]] {
                        var candidateWords = "";
                        var lineOfWords : [Word] = []
                        for var w in words {
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
                                            newWord.injectCandidates(startIndex: 0)
                                            lineOfWords.append(newWord)
                                            let candidatesOnOneLine = newWord.candidates.joined(separator: " ")
                                            candidateWords += "\(candidatesOnOneLine) \n "
                                        } else {
                                            let newWord = Word(label: label as! String, candidates: [])
                                            newWord.injectCandidates(startIndex: 0)
                                            lineOfWords.append(newWord)
                                            let candidatesOnOneLine = newWord.candidates.joined(separator: " ")
                                            candidateWords += "no candidate words but has injected candidates: \(candidatesOnOneLine) \n"
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
    
    func preprocessBracketsFix() -> String {
        var errorsMessage = ""
        for (index, eachLine) in wordsList.enumerated() {
            var leftBracketCount = 0
            var rightBracketCount = 0
            var leftSquareBracketCount = 0
            var rightSquareBracketCount = 0
            // may also need angle brackets in here
            
            // Increment counts
            for w in eachLine {
                // what if a label has more than one occurrence of a bracket?
                leftBracketCount = leftBracketCount + w.label.components(separatedBy: "(").count - 1
                rightBracketCount = rightBracketCount + w.label.components(separatedBy: ")").count - 1
                leftSquareBracketCount = leftSquareBracketCount + w.label.components(separatedBy: "[").count - 1
                rightSquareBracketCount = rightSquareBracketCount + w.label.components(separatedBy: "]").count - 1
            }
            
            if leftBracketCount != rightBracketCount {
                errorsMessage += "Line \(index): LeftBracketCount(\(leftBracketCount)), RightBracketCount(\(rightBracketCount)) \n"
                // Let's attempt to fix mismatch of only one bracket
                let missingBracket = leftBracketCount > rightBracketCount ? ")" : "("
                for w in eachLine {
                    // The word may already have a bracket, we need to check candidates to see if it has two brackets
                    for c in w.candidates {
                        // e.g. "test(" will have count of 2
                        if c.components(separatedBy: missingBracket).count - 1 == w.label.components(separatedBy: missingBracket).count - 1 + 1 {
                            errorsMessage += "Could replace \(w.label) with \(c) \n"
                        }
                    }
                }
            }
            
            if leftSquareBracketCount != rightSquareBracketCount {
                errorsMessage += "Line \(index): LeftSquareBracketCount(\(leftSquareBracketCount)), RightSquareBracketCount(\(rightSquareBracketCount)) \n"
                let missingBracket = leftSquareBracketCount > rightSquareBracketCount ? "]" : "["
                for w in eachLine {
                    // The word may already have a bracket, we need to check candidates to see if it has two brackets
                    for c in w.candidates {
                        // e.g. "test(" will have count of 2
                        if c.components(separatedBy: missingBracket).count - 1 == w.label.components(separatedBy: missingBracket).count - 1 + 1 {
                            errorsMessage += "Could replace \(w.label) with \(c) \n"
                        }
                    }
                }
            }
        }
        return errorsMessage
    }
    
    func preprocessMyScriptRecognition() -> String {
        var preprocessMessage = "PREPROCESS ERRORS AT LINES: \n"
        preprocessMessage += preprocessBracketsFix()
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
                        // this may be a contender for adding to the user defined list of injection candidates
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
                var tokenList = ""
                for t in tokens.getTokens() {
                    tokenList += "\(lexer.getVocabulary().getSymbolicName(t.getType()) ?? "") "
                    if t.getText() == "{" || t.getText() == "}" || t.getText() == ";" {
                        tokenList += "\n"
                    }
                }
                result = "Token List: \(tokenList) \n Parse Tree: \n \(printStr) \n Final Output: \n \(treeString)"
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
    
    var highlightWordViews: [[HighlightWordView]] = []
    var selectedHighlightWordRow = -1
    var selectedHighlightWordCol = -1
    
    @IBAction func addHighlightViews(_ sender: Any) {
        do {
            let export = try editorViewController.editor.export_(nil, mimeType: IINKMimeType.JIIX)
            let exportJSON = export.toJSON()
            print(exportJSON)
            if let _ = sender as? UIBarButtonItem {
                if highlightSwitch.isOn {
                    print("turn off switch")
                    highlightSwitch.setOn(false, animated: true)
                } else {
                    print("turn on switch")
                    highlightSwitch.setOn(true, animated: true)
                }
            }
            if highlightSwitch.isOn {
                let myNewView=UIView(frame: CGRect(x: 24*5.2, y: 16.2+135, width: 10.8*5, height: 7.9*5))
                
                // Change UIView background colour
                myNewView.backgroundColor=UIColor.lightGray
                
                // Change UIView Border Color to Red
                myNewView.layer.borderWidth=2
                myNewView.layer.borderColor = UIColor.red.cgColor
                
                myNewView.alpha = 0.5
                
                let tap = HighlightWordTapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
                tap.row = 0
                tap.col = 0
                myNewView.addGestureRecognizer(tap)
                // Add UIView as a Subview
                self.view.addSubview(myNewView)
                
                let w = Word(label: "test", candidates: ["test1", "test2", "test3"])
                
                let hwv = HighlightWordView(word: w, view: myNewView)
                
                highlightWordViews.append([hwv])
            } else {
                for line in highlightWordViews {
                    for hwv in line {
                        hwv.view.removeFromSuperview()
                    }
                }
                highlightWordViews = []
            }
        } catch {
            print("Error trying to highlight")
        }
        
    }
    
    @objc func handleTap(sender: HighlightWordTapGestureRecognizer) {
        print("Tapped")
        selectedHighlightWordRow = sender.row
        selectedHighlightWordCol = sender.col
        highlightWordViews[sender.row][sender.col].view.layer.borderColor = UIColor.blue.cgColor
        
        let correctionView = UIView(frame: CGRect(x: 700, y: 500, width: 200, height: 200))
        correctionView.backgroundColor=UIColor.green
        correctionView.layer.borderWidth=2
        correctionView.layer.borderColor = UIColor.red.cgColor
        correctionView.alpha = 0.5
        
        let dropdown = UIPickerView(frame: CGRect(x: 0, y: 0, width: 150, height: 100))
        dropdown.delegate = self
        dropdown.dataSource = self
        
        let closeButton = UIButton(frame: CGRect(x: 0, y: 100, width: 70, height: 30))
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(handleCloseButton(sender:)), for: .touchUpInside)
        
        correctionView.addSubview(dropdown)
        correctionView.addSubview(closeButton)
        // Add UIView as a Subview
        highlightWordViews[sender.row][sender.col].view.superview?.addSubview(correctionView)
    }
    
    @objc func handleCloseButton(sender: UIButton) {
        // remove correctionView
        sender.superview?.removeFromSuperview()
        // set border color of clicked word back to red
        highlightWordViews[selectedHighlightWordRow][selectedHighlightWordCol].view.layer.borderColor = UIColor.red.cgColor
        // set selectedWord indexes back to default -1
        selectedHighlightWordRow = -1
        selectedHighlightWordRow = -1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return highlightWordViews[selectedHighlightWordRow][selectedHighlightWordCol].word.candidates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return highlightWordViews[selectedHighlightWordRow][selectedHighlightWordCol].word.candidates[row]
    }
    
}

public class HighlightWordTapGestureRecognizer: UITapGestureRecognizer {
    var row = -1
    var col = -1
}

public class HighlightWordView {
    var word: Word
    var view: UIView
    
    init(word w: Word, view v: UIView) {
        word = w
        view = v
    }
}

public var injectionList: [Word] = []
    //[
//    Word(label: "C", candidates: ["("]),
//    Word(label: "D", candidates: ["1)", "))"])
//]

public class Word {
    
    var label: String
    var candidates: [String]
    
    init(label l: String, candidates c: [String]) {
        label = l
        candidates = c
    }
    
    public func injectCandidates(startIndex: Int) {
        // This looks like its going to be really expensive, so maybe only call this when you realise a bracket mismatch.
        for (injIndex, i) in injectionList.enumerated() {
            if (injIndex >= startIndex) {
                let indices = label.indicesOf(string: i.label)
                if indices.count > 0 {
                    for index in indices {
                        for c in i.candidates {
                            // Create prefix, add replacement, join suffix, create word, inject that word, add candidates of that
                            let prefix = label.prefix(index)
                            let suffix = label.suffix(label.count - index-1)
                            let newString = prefix + c + suffix
                            let newWord = Word(label: String(newString), candidates: [])
                            newWord.injectCandidates(startIndex: injIndex + 1)
                            candidates.append(newWord.label)
                            candidates.append(contentsOf: newWord.candidates)
                        }
                    }
                }
            }
        }
    }
}

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
    
    func indicesOf(string: String) -> [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex
        
        while searchStartIndex < self.endIndex,
            let range = self.range(of: string, range: searchStartIndex..<self.endIndex),
            !range.isEmpty
        {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }
        
        return indices
    }
}

