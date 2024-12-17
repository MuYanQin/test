//
//  ViewController.swift
//  textreport
//
//  Created by peanut on 2024/12/17.
//

import Cocoa
import CrashReporter

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let config = PLCrashReporterConfig(signalHandlerType: .mach, symbolicationStrategy: .all)
          guard let crashReporter = PLCrashReporter(configuration: config) else {
            print("Could not create an instance of PLCrashReporter")
            return
          }

          // Enable the Crash Reporter.
          do {
              try crashReporter.enableAndReturnError()
          } catch let error {
            print("Warning: Could not enable crash reporter: \(error)")
          }

        
        if crashReporter.hasPendingCrashReport() {
          do {
            let data = try crashReporter.loadPendingCrashReportDataAndReturnError()

            // Retrieving crash reporter data.
            let report = try PLCrashReport(data: data)

            // We could send the report from here, but we'll just print out some debugging info instead.
            if let text = PLCrashReportTextFormatter.stringValue(for: report, with: PLCrashReportTextFormatiOS) {
                print(text)
            } else {
              print("CrashReporter: can't convert report to text")
            }
          } catch let error {
            print("CrashReporter failed to load and parse with error: \(error)")
          }
        }
        crashReporter.purgePendingCrashReport()
    }
}

