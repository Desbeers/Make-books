//  SharedFunctions.swift
//  Make books
//
//  Copyright © 2020 Nick Berendsen. All rights reserved.

import SwiftUI

// MARK: - Fuctions

// GetDocumentsDirectory()
// ----------
// Returns the users Documents directory.
// Used when no folders are selected by the user.

func GetDocumentsDirectory() -> String {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
}

// GetLastPath(path)
// -----------------
// Gets the full path to the folder
// Returns the last path

func GetLastPath(_ path: String) -> String {
    let lastPath = (URL(fileURLWithPath: path).lastPathComponent)
    return lastPath
}

// GetArgs(path)
// -------------------
// Gets the full book object
// Returns a string with arguments

func GetArgs(_ books: Books, _ pathBooks: String, _ pathExport: String, _ pdfPaper: String, _ pdfFont: String) -> String {
    var makeArgs = ""
    makeArgs += "--paper " + pdfPaper + " "
    makeArgs += "--font " + pdfFont + " "
    makeArgs += "--books \"" + pathBooks + "\" "
    makeArgs += "--export \"" + pathExport + "\" "
    for option in books.optionsMake {
        if option.isSelected == true {
            makeArgs += " " + option.make + " "
        }
    }
    return (makeArgs)
}

// ApplyTheme(scheme)
// -------------------
// Gets selected theme
// Set the window appearance

func ApplyTheme(_ appTheme: String) {
    switch appTheme {
        case "dark":
            NSApp.appearance = NSAppearance(named: .darkAqua)
        case "light":
            NSApp.appearance = NSAppearance(named: .aqua)
        default:
            NSApp.appearance = nil
    }
}

// Folder selector
// ---------------

/// Books folder selection
func SelectBooksFolder(_ books: Books) {
    let base = UserDefaults.standard.object(forKey: "pathBooks") as? String ?? GetDocumentsDirectory()
    let dialog = NSOpenPanel();
    dialog.showsResizeIndicator = true;
    dialog.showsHiddenFiles = false;
    dialog.canChooseFiles = false;
    dialog.canChooseDirectories = true;
    dialog.directoryURL = URL(fileURLWithPath: base)
    dialog.message = "Select the folder with your books"
    dialog.prompt = "Select"
    dialog.beginSheetModal(for: NSApp.keyWindow!) { (result) in
        if result == NSApplication.ModalResponse.OK {
            let result = dialog.url
            /// Save the url
            UserDefaults.standard.set(result!.path, forKey: "pathBooks")
            /// Refresh the list of songs
            books.bookList = GetBooksList()
            /// Clear the selected book (if any)
            books.bookSelected = nil
        }
    }
}
/// Export folder selection
func SelectExportFolder() {
    let base = UserDefaults.standard.object(forKey: "pathExport") as? String ?? GetDocumentsDirectory()
    let dialog = NSOpenPanel();
    dialog.showsResizeIndicator = true;
    dialog.showsHiddenFiles  = false;
    dialog.canChooseFiles = false;
    dialog.canChooseDirectories = true;
    dialog.directoryURL = URL(fileURLWithPath: base)
    dialog.message = "Select the export folder for your books"
    dialog.prompt = "Select"
    dialog.beginSheetModal(for: NSApp.keyWindow!) { (result) in
        if result == NSApplication.ModalResponse.OK {
            let result = dialog.url
            UserDefaults.standard.set(result!.path, forKey: "pathExport")
        }
    }
}

// GetCover(path)
// --------------
// Gets path to cover
// Returns the cover image
// Defaults to a cover in the Assets bundle

func GetCover(cover: String) -> NSImage {
    let url = URL(fileURLWithPath: cover)
    let imageData = try! Data(contentsOf: url)
    return NSImage(data: imageData)!
}
