// Copyright MyScript. All right reserved.

import UIKit
import Antlr4
import Highlightr

class HomeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var inputTypeSegmentedControl: UISegmentedControl!
    
    weak var editorViewController: EditorViewController!
    
    private var contentPackage: IINKContentPackage? = nil
    
    var documentTitleText: String = "New" {
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
    @IBOutlet weak var annotationLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var candidatesPickerView: UIPickerView!
    @IBOutlet weak var otherTextField: UITextField!
    @IBOutlet weak var outputTextField: UITextView!
    @IBOutlet weak var spacePickerView: UIPickerView!
    @IBOutlet weak var bottomRightView: UIView!
    
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
            if let package = try createPackage(packageName: documentTitleText) {
                contentPackage = package
                try editorViewController.editor.part = package.getPartAt(0)
            }
        } catch {
            print("Error while creating package : " + error.localizedDescription)
        }
        
        documentTitleButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        documentTitleButton.addTarget(self, action: #selector(self.renameTitle), for: UIControlEvents.touchUpInside)
        self.navigationItem.titleView = documentTitleButton;
        
        candidatesPickerView.delegate = self
        candidatesPickerView.dataSource = self
        spacePickerView.delegate = self
        spacePickerView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // print a line of code
//        let codeString = "public static void main(String[] args) { \nSystem.out.println(\"test\"); \n}"
//        generateHandwritingFromString(forCode: codeString)
        
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
                // file exists, so call loadContent which will also load bounding box, it will also set the contentPackage
                loadContent(withFileURL: String(fullPath))
                resultPackage = contentPackage
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
    
    func getNewWordsList() -> [[Word]] {
        do {
            let export = try editorViewController.editor.export_(nil, mimeType: IINKMimeType.JIIX)
            let exportJSON = export.toJSON()
            //print(exportJSON)
            var newWordsList: [[Word]] = []
            if let jsonObj = exportJSON as? [String: Any] {
                if let children = jsonObj["children"] as? [[String: Any]] {
                    if let words = children[0]["words"] as? [[String: Any]] {
                        var lineOfWords : [Word] = []
                        for var w in words {
                            if let label = w["label"] {
                                if label as? String != " " {
                                    if label as? String == "\n" {
                                        newWordsList.append(lineOfWords)
                                        lineOfWords = []
                                    } else {
                                        if let candidates = w["candidates"] {
                                            let newWord = Word(label: label as! String, candidates: candidates as! [String])
                                            newWord.injectCandidates(startIndex: 0)
                                            lineOfWords.append(newWord)
                                            if let boundingBox = w["bounding-box"] as? [String: Any] {
                                                newWord.x = boundingBox["x"] as! Double
                                                newWord.y = boundingBox["y"] as! Double
                                                newWord.width = boundingBox["width"] as! Double
                                                newWord.height = boundingBox["height"] as! Double
                                            }
                                        } else {
                                            let newWord = Word(label: label as! String, candidates: [])
                                            newWord.injectCandidates(startIndex: 0)
                                            lineOfWords.append(newWord)
                                            if let boundingBox = w["bounding-box"] as? [String: Any] {
                                                newWord.x = boundingBox["x"] as! Double
                                                newWord.y = boundingBox["y"] as! Double
                                                newWord.width = boundingBox["width"] as! Double
                                                newWord.height = boundingBox["height"] as! Double
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        // Remember to add last line of words to wordlist
                        newWordsList.append(lineOfWords)
                        let _ = preprocessMyScriptRecognition()
                        heuristicsProcessingPostLexer(newWordsList: newWordsList)
                        return newWordsList
                    }
                }
            }
        } catch {
            print("Error while converting : " + error.localizedDescription)
        }
        return [[]]
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
                var potentialFixes = 0
                var indexOfWordFix = 0
                var candidateFix = ""
                for (wIndex, w) in eachLine.enumerated() {
                    // The word may already have a bracket, we need to check candidates to see if it has two brackets
                    for c in w.candidates {
                        // e.g. "test(" will have count of 2
                        if c.components(separatedBy: missingBracket).count - 1 == w.label.components(separatedBy: missingBracket).count - 1 + 1 {
                            errorsMessage += "Could replace \(w.label) with \(c) \n"
                            potentialFixes = potentialFixes + 1
                            indexOfWordFix = wIndex
                            candidateFix = c
                        }
                    }
                }
                if potentialFixes == 1 {
                    errorsMessage += "Replaced \(eachLine[indexOfWordFix].label) with \(candidateFix) \n"
                    eachLine[indexOfWordFix].fixProviders.append(FixProvider.BracketsMismatchingFix(eachLine[indexOfWordFix].label))
                    eachLine[indexOfWordFix].label = candidateFix
                }
            }
            
            if leftSquareBracketCount != rightSquareBracketCount {
                errorsMessage += "Line \(index): LeftSquareBracketCount(\(leftSquareBracketCount)), RightSquareBracketCount(\(rightSquareBracketCount)) \n"
                let missingBracket = leftSquareBracketCount > rightSquareBracketCount ? "]" : "["
                var potentialFixes = 0
                var indexOfWordFix = 0
                var candidateFix = ""
                for (wIndex, w) in eachLine.enumerated() {
                    // The word may already have a bracket, we need to check candidates to see if it has two brackets
                    for c in w.candidates {
                        // e.g. "test(" will have count of 2
                        if c.components(separatedBy: missingBracket).count - 1 == w.label.components(separatedBy: missingBracket).count - 1 + 1 {
                            errorsMessage += "Could replace \(w.label) with \(c) \n"
                            potentialFixes = potentialFixes + 1
                            indexOfWordFix = wIndex
                            candidateFix = c
                        }
                    }
                }
                if potentialFixes == 1 {
                    errorsMessage += "Replaced \(eachLine[indexOfWordFix].label) with \(candidateFix) \n"
                    eachLine[indexOfWordFix].fixProviders.append(FixProvider.BracketsMismatchingFix(eachLine[indexOfWordFix].label))
                    eachLine[indexOfWordFix].label = candidateFix
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
                    eachLine.last?.fixProviders.append(FixProvider.HeuristicsFix((eachLine.last?.label)!))
                    eachLine.last?.label = "}"
                } else {
                    // Loop through candidates and see if { or ; comes first and use this as label
                    var fixed = false
                    for c in (eachLine.last?.candidates)! {
                        if c == "{" || c == ";" {
                            preprocessMessage += "Line \(index) - Fix last character should be '{' or ';', we made it \(c) \n"
                            eachLine.last?.fixProviders.append(FixProvider.HeuristicsFix((eachLine.last?.label)!))
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
    
    func heuristicsProcessingPostLexer(newWordsList: [[Word]]) {
        var codeString = ""
        for eachLine in newWordsList {
            for w in eachLine {
                codeString += w.label + " "
            }
            codeString += "\n"
        }
        let input = ANTLRInputStream(codeString)
        /* Create a lexer that feeds off of input CharStream */
        let lexer = Java9Lexer(input)
        let allTokens = try! lexer.getAllTokens()
        var indexInCurrentWord = 0
        var flattenWordsList = newWordsList.flatMap {$0}
        var wordIndex = 0
        var currentWord = flattenWordsList[wordIndex]
        for i in 0..<allTokens.count {
            let t = allTokens[i]
            if t.getType() == Java9Parser.Tokens.IF.rawValue || t.getType() == Java9Parser.Tokens.FOR.rawValue
                || t.getType() == Java9Parser.Tokens.SWITCH.rawValue || t.getType() == Java9Parser.Tokens.WHILE.rawValue {
                // shift
                if (t.getText()?.count)! >= currentWord.label.count - indexInCurrentWord {
                    // overflows onto next bounding box
                    var indexInToken = 0
                    while (t.getText()?.count)! - indexInToken >= currentWord.label.count - indexInCurrentWord  {
                        indexInToken = currentWord.label.count - indexInCurrentWord + indexInToken
                        // move to next Word object
                        indexInCurrentWord = 0
                        wordIndex = wordIndex + 1
                        currentWord = flattenWordsList[wordIndex]
                    }
                    // complete partial overflow in current word
                    indexInCurrentWord = indexInCurrentWord + (t.getText()?.count)! - indexInToken
                } else {
                    indexInCurrentWord = indexInCurrentWord + (t.getText()?.count)!
                }
                // next token must be a '('
                if i+1 < allTokens.count && allTokens[i+1].getType() != Java9Parser.Tokens.LPAREN.rawValue {
                    // change next letter to '(' and SKIP rest of token
                    let i = currentWord.label.index(currentWord.label.startIndex, offsetBy: indexInCurrentWord)
                    currentWord.fixProviders.append(.HeuristicsFix(currentWord.label))
                    currentWord.label = currentWord.label.replacingCharacters(in: i...i, with: "(")
                }
            } else {
                // shift
                if (t.getText()?.count)! >= currentWord.label.count - indexInCurrentWord {
                    // overflows onto next bounding box
                    var indexInToken = 0
                    while (t.getText()?.count)! - indexInToken >= currentWord.label.count - indexInCurrentWord  {
                        indexInToken = currentWord.label.count - indexInCurrentWord + indexInToken
                        // move to next Word object
                        indexInCurrentWord = 0
                        wordIndex = wordIndex + 1
                        if (wordIndex < flattenWordsList.count) {
                            currentWord = flattenWordsList[wordIndex]
                        }
                    }
                    // complete partial overflow in current word
                    indexInCurrentWord = indexInCurrentWord + (t.getText()?.count)! - indexInToken
                } else {
                    indexInCurrentWord = indexInCurrentWord + (t.getText()?.count)!
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showConversion":
                if let covc = segue.destination as? ConvertedOutputViewController {
                    covc.convertedText = ""
                }
            case "settingsSegue":
                if let settingsController = segue.destination as? SettingsTableViewController {
                    settingsController.filename = documentTitleText
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
            // Save wordsList data
            let jsonData: Data? = try? JSONEncoder().encode(wordsList)
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            do {
                try? FileManager.default.createDirectory(atPath: documentsURL.appendingPathComponent("WordsListData").path, withIntermediateDirectories: true)
                try jsonData?.write(to: documentsURL.appendingPathComponent("WordsListData").appendingPathComponent(documentTitleText + ".json"))
            } catch {
                print("Error trying to save wordsList file \(error.localizedDescription)")
            }
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
                    // load saved wordsList
                    let fileManager = FileManager.default
                    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let wordsListPath = documentsURL.appendingPathComponent("WordsListData").appendingPathComponent(documentTitleText + ".json")
                    let strPath = String(describing: wordsListPath)
                    let range = strPath.index(strPath.startIndex, offsetBy:7)
                    if fileManager.fileExists(atPath: String(strPath[range...].removingPercentEncoding!)) {
                        let data = try Data(contentsOf: wordsListPath)
                        if let newWordsList: [[Word]] = try? JSONDecoder().decode([[Word]].self, from: data) {
                            wordsList = newWordsList
                        }
                    }
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
    
    // MARK: BOTTOM RIGHT UI FOR HIGHLIGHTING
    
    var highlightWordViews: [[HighlightWordView]] = []
    var selectedHighlightWord: (Int, Int)? {
        didSet {
            if let newSelected = selectedHighlightWord {
                // animate bottom right UI view
                UIView.animate(withDuration: 0.5, animations: {self.bottomRightView.backgroundColor = UIColor(red: 147/255, green: 248/255, blue: 249/255, alpha: 1.0)})
                UIView.animate(withDuration: 0.5, animations: {self.bottomRightView.backgroundColor = UIColor.white})
                // update bottom right UI of screen
                wordLabel.text = "Label: \(highlightWordViews[newSelected.0][newSelected.1].word.label)"
                var annotation = "Annotation: "
                for (fIndex, fix) in highlightWordViews[newSelected.0][newSelected.1].word.fixProviders.enumerated() {
                    var toLabel = highlightWordViews[newSelected.0][newSelected.1].word.label
                    if (fIndex != highlightWordViews[newSelected.0][newSelected.1].word.fixProviders.count-1) {
                        let nextFix = highlightWordViews[newSelected.0][newSelected.1].word.fixProviders[fIndex + 1]
                        switch (nextFix) {
                        case .BracketsMismatchingFix(let s):
                            toLabel = s
                        case .HeuristicsFix(let s):
                            toLabel = s
                        case .ANTLRFix(let s):
                            toLabel = s
                        case .UserFix(let s):
                            toLabel = s
                        case .MachineLayerFix(let s):
                            toLabel = s
                        }
                    }
                    switch (fix) {
                    case.BracketsMismatchingFix(let s):
                        annotation = annotation + "BracketsMismatching fix from \(s) to \(toLabel)\n"
                    case .HeuristicsFix(let s):
                        annotation = annotation + "Heuristics fix from \(s) to \(toLabel)\n"
                    case .ANTLRFix(let s):
                        annotation = annotation + "ANTLR fix from \(s) to \(toLabel)\n"
                    case .UserFix(let s):
                        annotation = annotation + "UserFix from \(s) to \(toLabel)\n"
                    case .MachineLayerFix(let s):
                        annotation = annotation + "ML fix from \(s) to \(toLabel)\n"
                    }
                }
                annotationLabel.text = annotation
                otherTextField.text = ""
                candidatesPickerView.reloadAllComponents()
                // set space picker selected value
                var row = 0
                switch highlightWordViews[newSelected.0][newSelected.1].word.nextSpace {
                case .NO_SPACE:
                    row = 0
                case .ADD_SPACE:
                    row = 1
                case .DELETE_SPACE:
                    row = 2
                }
                spacePickerView.selectRow(row, inComponent: 0, animated: false)
            } else {
                // reset bottom right UI to default
                wordLabel.text = "Label: "
                annotationLabel.text = "Annotation: "
                otherTextField.text = ""
                candidatesPickerView.reloadAllComponents()
                spacePickerView.selectRow(0, inComponent: 0, animated: false)
            }
            if let old = oldValue{
                highlightWordViews[old.0][old.1].view.layer.borderColor = UIColor.red.cgColor
            }
        }
    }
    
    @IBAction func addHighlightViews(_ sender: Any) {
        if highlightSwitch.isOn {
            for (lineIndex, line) in wordsList.enumerated() {
                var lineOfHighlightedWords: [HighlightWordView] = []
                for (wordIndex, w) in line.enumerated() {
                    let yOffset = lineIndex * 38 + 135
                    let highlightWordView=UIView(frame: CGRect(x: w.x*5.2, y: (w.y+Double(yOffset)), width: w.width*5, height: w.height*5))
                    if w.fixProviders.count == 0 {
                        highlightWordView.backgroundColor = UIColor.lightGray
                    } else if w.fixProviders.count == 1 {
                        let onlyFix = w.fixProviders[0]
                        switch (onlyFix) {
                        case.BracketsMismatchingFix:
                            highlightWordView.backgroundColor = UIColor.orange
                        case .HeuristicsFix:
                            highlightWordView.backgroundColor = UIColor.yellow
                        case .ANTLRFix:
                            highlightWordView.backgroundColor = UIColor.magenta
                        case .UserFix:
                            highlightWordView.backgroundColor = UIColor.purple
                        case .MachineLayerFix:
                            highlightWordView.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 233/255, alpha: 1.0)
                        }
                    } else {
                        // more than one fix provider triggered
                        highlightWordView.backgroundColor = UIColor.green
                    }
                    highlightWordView.layer.borderWidth=3
                    highlightWordView.layer.borderColor = UIColor.red.cgColor
                    highlightWordView.alpha = 0.5
                    
                    let tap = HighlightWordTapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
                    tap.row = lineIndex
                    tap.col = wordIndex
                    highlightWordView.addGestureRecognizer(tap)
                    self.view.addSubview(highlightWordView)
                    
                    let hwv = HighlightWordView(word: w, view: highlightWordView)
                    
                    lineOfHighlightedWords.append(hwv)
                }
                highlightWordViews.append(lineOfHighlightedWords)
            }
        } else {
            for line in highlightWordViews {
                for hwv in line {
                    hwv.view.removeFromSuperview()
                }
            }
            selectedHighlightWord = nil
            highlightWordViews = []
        }
        syntaxHighlight()
    }
    
    func syntaxHighlight() {
        let highlightr = Highlightr()
        highlightr?.setTheme(to: "paraiso-dark")
        var codeBody = ""
        for eachLine in highlightWordViews {
            for hwv in eachLine {
                codeBody = codeBody + "\(hwv.word.label) "
            }
            codeBody = codeBody + "\n"
        }
        // check type (leetcode or custom)
        var type = "custom" // default to custom
        let defaults = UserDefaults.standard
        if let d = defaults.dictionary(forKey: "FileSettings") {
            var allFileSettings = d as! Dictionary<String, Dictionary<String, String>>
            if let fs = allFileSettings[documentTitleText] {
                type = fs["type"]!
            }
        }
        var code = ""
        if type == "custom" {
            code = codeBody
            code = getFinalCodeString(code)
        } else if type == "leetcode" {
            if let d = defaults.dictionary(forKey: "FileSettings") {
                var allFileSettings = d as! Dictionary<String, Dictionary<String, String>>
                if let fs = allFileSettings[documentTitleText] {
                    let id = fs["id"]!
                    let index = Int(id)! - 1
                    code = LEETCODE_DATA[index][6] + getFinalCodeString(codeBody) + LEETCODE_DATA[index][7]
                }
            }
        }
        
        // You can omit the second parameter to use automatic language detection.
        let highlightedCode = highlightr?.highlight(code, as: "java")
        outputTextField.attributedText = highlightedCode
    }
    
    func getFinalCodeString(_ code: String)->String {
        // Join identifier tokens e.g. get Least Numbers = getLeastNumbers
        let input = ANTLRInputStream(code)
        let lexer = Java9Lexer(input)
        let allTokens = try! lexer.getAllTokens()
        var code = ""
        var currentLine = 1
        var i = 0
        for _ in 0..<allTokens.count {
            if i >= allTokens.count {
                break
            }
            let t = allTokens[i]
            if t.getLine() > currentLine {
                currentLine = currentLine + 1
                code = code + "\n"
            }
            // if sequence of identifiers not beginning with "String"
            if t.getType() == Java9Parser.Tokens.Identifier.rawValue && t.getText() != "String" {
                code = code + t.getText()!
                i = i + 1
                while (i < allTokens.count && allTokens[i].getType() == Java9Parser.Tokens.Identifier.rawValue) {
                    code = code + allTokens[i].getText()!
                    i = i + 1
                }
                code = code + " "
            } else if t.getType() == Java9Parser.Tokens.LBRACK.rawValue {
                // remove space previously inserted
                code = String(code[..<code.index(code.endIndex, offsetBy: -1)])
                code = code + t.getText()!
                i = i + 1
            } else if t.getType() == Java9Parser.Tokens.DOT.rawValue {
                code = String(code[..<code.index(code.endIndex, offsetBy: -1)])
                code = code + t.getText()!
                i = i + 1
            } else if t.getType() == Java9Parser.Tokens.ADD.rawValue {
                code = String(code[..<code.index(code.endIndex, offsetBy: -1)])
                code = code + t.getText()!
                code = code + " "
                i = i + 1
            } else {
                code = code + t.getText()!
                code = code + " "
                i = i + 1
            }
        }
        // handle forced spaces
        var currentIndexInCode = 0
        var currentIndexInWord = 0
        var currentWord = 0
        let flattenedWordsList = wordsList.flatMap {$0}
        for c in code {
            if currentWord >= flattenedWordsList.count {
                break
            }
            currentIndexInCode = currentIndexInCode + 1
            if c != " " && c != "\n" {
                let w = flattenedWordsList[currentWord]
                assert(c == w.label[w.label.index(w.label.startIndex, offsetBy: currentIndexInWord)])
                currentIndexInWord = currentIndexInWord + 1
                if (currentIndexInWord == w.label.count) {
                    currentIndexInWord = 0
                    currentWord = currentWord + 1
                    if w.nextSpace == .ADD_SPACE {
                        code.insert(" ", at: code.index(code.startIndex, offsetBy: currentIndexInCode))
                        currentIndexInCode = currentIndexInCode + 1
                    } else if w.nextSpace == .DELETE_SPACE {
                        code.remove(at: code.index(code.startIndex, offsetBy: currentIndexInCode))
                        currentIndexInCode = currentIndexInCode - 1
                    }
                }
            }
        }
        return code
    }
    
    @objc func handleTap(sender: HighlightWordTapGestureRecognizer) {
        print("Tapped")
        selectedHighlightWord = (sender.row, sender.col)
        // when tap on highlightword, change border color to blue to indicate to the user that they have clicked on it.
        highlightWordViews[sender.row][sender.col].view.layer.borderColor = UIColor.blue.cgColor
    }
    
    @IBAction func saveHighlightWordChanges(_ sender: Any) {
        if let selectedWord = selectedHighlightWord {
            // if 'other' textfield is not empty then replace label with this
            // else replace label with candidatePicker
            let w = highlightWordViews[selectedWord.0][selectedWord.1].word
            w.fixProviders.append(FixProvider.UserFix(w.label))
            if highlightWordViews[selectedWord.0][selectedWord.1].word.fixProviders.count > 1 {
                highlightWordViews[selectedWord.0][selectedWord.1].view.backgroundColor = UIColor.green
            } else {
                highlightWordViews[selectedWord.0][selectedWord.1].view.backgroundColor = UIColor.purple
            }
            let otherField = otherTextField.text
            if otherField != "" {
                w.label = otherField!
            } else {
                let selectedRow = candidatesPickerView.selectedRow(inComponent: 0)
                w.label = w.candidates[selectedRow]
            }
            // Reset bottom right UI and also force set border color to blue
            selectedHighlightWord = selectedWord
            highlightWordViews[selectedWord.0][selectedWord.1].view.layer.borderColor = UIColor.blue.cgColor
            // Update syntaxHighlighted code for change.
            syntaxHighlight()
        }
    }
    
    @IBAction func cancelSelectedHighlightWord(_ sender: Any) {
        selectedHighlightWord = nil
    }
    
    // MARK: CANDIDATES_PICKER_VIEW METHODS
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 1 {
            return 1
        } else if pickerView.tag == 2 {
            return 1
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            if let selectedWord = selectedHighlightWord {
                return highlightWordViews[selectedWord.0][selectedWord.1].word.candidates.count
            } else {
                return 0
            }
        } else if pickerView.tag == 2 {
            return 3
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            if let selectedWord = selectedHighlightWord {
                return highlightWordViews[selectedWord.0][selectedWord.1].word.candidates[row]
            } else {
                return nil
            }
        } else if pickerView.tag == 2 {
            return [SPACE_TYPE.NO_SPACE.rawValue, SPACE_TYPE.ADD_SPACE.rawValue, SPACE_TYPE.DELETE_SPACE.rawValue][row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 2, let selectedWord = selectedHighlightWord {
            let w = highlightWordViews[selectedWord.0][selectedWord.1].word
            let selectedSpaceRow = spacePickerView.selectedRow(inComponent: 0)
            w.nextSpace = [SPACE_TYPE.NO_SPACE, SPACE_TYPE.ADD_SPACE, SPACE_TYPE.DELETE_SPACE][selectedSpaceRow]
            syntaxHighlight()
        }
    }
    
    @IBAction func executeCode(_ sender: UIBarButtonItem) {
        // First check type of file (leetcode or custom)
        let defaults = UserDefaults.standard
        var type = "custom" // default to custom
        if let d = defaults.dictionary(forKey: "FileSettings") {
            var allFileSettings = d as! Dictionary<String, Dictionary<String, String>>
            if let fs = allFileSettings[documentTitleText] {
                type = fs["type"]!
            }
        }
        // Join together final string to represent code
        var codeString = ""
        for eachLine in wordsList {
            for w in eachLine {
                codeString = codeString + w.label + " "
            }
            codeString = codeString + "\n"
        }
        codeString = getFinalCodeString(codeString)
        // Handover execution to specific functinos
        if type == "custom" {
            outputTextField.text = executeCodeOnServer(codeBody: codeString)
        } else if type == "leetcode" {
            executeCodeOnLeetCode(codeBody: codeString, filename: documentTitleText, outputTextField: outputTextField)
        }
    }
    
    @IBAction func convert2ButtonPressed(_ sender: UIBarButtonItem) {
        print("convert2ButtonPressed")
        var newWordsList = getNewWordsList()
        for (lineIndex, eachLine) in newWordsList.enumerated()  {
            for (wIndex, newW) in eachLine.enumerated() {
                for oldW in wordsList.flatMap({$0}) {
                    if newW.width == oldW.width && newW.height == oldW.height && newW.originalLabel == oldW.originalLabel {
                        let newWord = newWordsList[lineIndex][wIndex]
                        newWordsList[lineIndex][wIndex] = oldW
                        newWordsList[lineIndex][wIndex].x = newWord.x
                        newWordsList[lineIndex][wIndex].y = newWord.y
                        break
                    }
                }
            }
        }
        wordsList = newWordsList
    }
    
    // MARK: GENERATE STROKES PROGRAMATICALLY
    
    @IBAction func generateHandwritingButtonClicked(_ sender: UIBarButtonItem) {
        //generateHandwritingOnSeparateLinesFromCharArray(array: [",", "&"])
        generateHandwritingFromString(forCode: "ListNode dummyHead = new ListNode(0);\nListNode p = l1, q = l2, curr = dummyHead;\nint carry = 0;\nwhile (p != null || q != null) {\nint x = (p != null) ? p.val : 0;\nint y = (q != null) ? q.val : 0;\nint sum = carry + x + y;\ncarry = sum / 10;\ncurr.next = new ListNode(sum % 10);\ncurr = curr.next;\nif (p != null) {\np = p.next;\n}\nif (q != null) {\nq = q.next;\n}\n}\nif (carry > 0) {\ncurr.next = new ListNode(carry);\n}\nreturn dummyHead.next;")
    }
    
    func generateHandwritingFromString(forCode code: String) {
        var prevChar = ""
        var h_spacing = 0.0
        var v_spacing = 0.0
        for (cIndex, character) in code.enumerated() {
            if cIndex > 0 && prevChar != " " && prevChar != "\n" {
                h_spacing = h_spacing + HANDWRITTEN_CHARACTERS[prevChar]!.getWidth()-1.4
            } else if prevChar == " " {
                h_spacing = h_spacing + 4
            } else if prevChar == "\n" {
                v_spacing = v_spacing + 48
                h_spacing = 0.0
            }
            if character != " " && character != "\n" {
                for stroke in 0..<HANDWRITTEN_CHARACTERS[String(character)]!.getXArrays().count {
                    if let mCount = HANDWRITTEN_CHARACTERS[String(character)]?.getXArrays()[stroke].count, let xArray = HANDWRITTEN_CHARACTERS[String(character)]?.getXArrays()[stroke],
                        let yArray = HANDWRITTEN_CHARACTERS[String(character)]?.getYArrays()[stroke], let forcesArray = HANDWRITTEN_CHARACTERS[String(character)]?.getForceArrays()[stroke] {
                        for i in 0..<mCount {
                            if i == 0 {
                                // pen down
                                editorViewController.editor.pointerDown(CGPoint(x: xArray[i]*5.2 + h_spacing*5.2, y: yArray[i]*5.2 + v_spacing), at: -1, force: Float(forcesArray[i]), type: IINKPointerType.pen, pointerId: -1, error: nil)
                            } else if i == forcesArray.count - 1 {
                                // pen up
                                try! editorViewController.editor.pointerUp(CGPoint(x: xArray[i]*5.2 + h_spacing*5.2, y: yArray[i]*5.2 + v_spacing), at: -1, force: Float(forcesArray[i]), type: IINKPointerType.pen, pointerId: -1)
                            } else {
                                // pen move
                                try! editorViewController.editor.pointerMove(CGPoint(x: xArray[i]*5.2 + h_spacing*5.2, y: yArray[i]*5.2 + v_spacing), at: -1, force: Float(forcesArray[i]), type: IINKPointerType.pen, pointerId: -1)
                            }
                        }
                    }
                }
            }
            prevChar = String(character)
        }
    }
    
    func generateHandwritingOnSeparateLinesFromCharArray(array: [String]) {
        var yOffset = 48.0
        for (index, character) in array.enumerated() {
            for stroke in 0..<HANDWRITTEN_CHARACTERS[character]!.getXArrays().count {
                if let mCount = HANDWRITTEN_CHARACTERS[character]?.getXArrays()[stroke].count, let xArray = HANDWRITTEN_CHARACTERS[character]?.getXArrays()[stroke],
                    let yArray = HANDWRITTEN_CHARACTERS[character]?.getYArrays()[stroke], let forcesArray = HANDWRITTEN_CHARACTERS[character]?.getForceArrays()[stroke] {
                    yOffset = Double((index + 1)*48)
                    for i in 0..<mCount {
                        if i == 0 {
                            // pen down
                            editorViewController.editor.pointerDown(CGPoint(x: xArray[i]*5.2, y: yArray[i]*5.2 + yOffset), at: -1, force: Float(forcesArray[i]), type: IINKPointerType.pen, pointerId: -1, error: nil)
                        } else if i == forcesArray.count - 1 {
                            // pen up
                            try! editorViewController.editor.pointerUp(CGPoint(x: xArray[i]*5.2, y: yArray[i]*5.2 + yOffset), at: -1, force: Float(forcesArray[i]), type: IINKPointerType.pen, pointerId: -1)
                        } else {
                            // pen move
                            try! editorViewController.editor.pointerMove(CGPoint(x: xArray[i]*5.2, y: yArray[i]*5.2 + yOffset), at: -1, force: Float(forcesArray[i]), type: IINKPointerType.pen, pointerId: -1)
                        }
                    }
                }
            }
        }

    }
    
    // MARK: KEYBOARD SHIFT VIEW
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
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

public class Word: Codable {
    
    var label: String
    var originalLabel: String
    var candidates: [String]
    public var x = 0.0
    public var y = 0.0
    public var width = 0.0
    public var height = 0.0
    public var fixProviders: [FixProvider] = []
    public var nextSpace: SPACE_TYPE = .NO_SPACE
    
    init(label l: String, candidates c: [String]) {
        label = l
        originalLabel = l
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

public enum SPACE_TYPE: String, Codable {
    case NO_SPACE = "No Space"
    case ADD_SPACE = "Add Space"
    case DELETE_SPACE = "Delete Space"
}

public enum FixProvider {
    case BracketsMismatchingFix(String)
    case HeuristicsFix(String)
    case ANTLRFix(String)
    case UserFix(String)
    case MachineLayerFix(String)
}

extension FixProvider: Codable {
    enum CodingKeys: String, CodingKey {
        case BracketsMismatchingFix, HeuristicsFix, ANTLRFix, UserFix, MachineLayerFix
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let stringValue = try container.decodeIfPresent(String.self, forKey: .BracketsMismatchingFix) {
            self = .BracketsMismatchingFix(stringValue)
        } else if let stringValue = try container.decodeIfPresent(String.self, forKey: .HeuristicsFix) {
            self = .HeuristicsFix(stringValue)
        } else if let stringValue = try container.decodeIfPresent(String.self, forKey: .ANTLRFix) {
            self = .ANTLRFix(stringValue)
        } else if let stringValue = try container.decodeIfPresent(String.self, forKey: .UserFix) {
            self = .UserFix(stringValue)
        } else {
            self = .MachineLayerFix(try container.decode(String.self, forKey: .MachineLayerFix))
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .BracketsMismatchingFix(let value):
            try container.encode(value, forKey: .BracketsMismatchingFix)
        case .HeuristicsFix(let value):
            try container.encode(value, forKey: .HeuristicsFix)
        case .ANTLRFix(let value):
            try container.encode(value, forKey: .ANTLRFix)
        case .UserFix(let value):
            try container.encode(value, forKey: .UserFix)
        case .MachineLayerFix(let value):
            try container.encode(value, forKey: .MachineLayerFix)
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

