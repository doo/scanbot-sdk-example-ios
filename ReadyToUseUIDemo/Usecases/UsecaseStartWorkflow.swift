//
//  UsecaseStartWorkflow.swift
//  ReadyToUseUIDemo
//
//  Created by Dmytro Makarenko on 4/15/19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class UsecaseStartWorkflow: Usecase {
    
    override func start(presenter: UIViewController) {
        
        super.start(presenter: presenter)
        
        let dialog = UIAlertController(title: "Select a Workflow", message: nil, preferredStyle: .actionSheet)
        
        WorkflowFactory
            .allWorkflows()
            .forEach { workflow in
                let action = UIAlertAction(title: workflow.name,
                                           style: .default,
                                           handler: { _ in self.showWorkflow(workflow, on: presenter) })
                dialog.addAction(action)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            dialog.dismiss(animated: true, completion: nil)
        }
        dialog.addAction(cancel)
        
        dialog.popoverPresentationController?.sourceView = presenter.view
        dialog.popoverPresentationController?.sourceRect = CGRect(x: presenter.view.center.x,
                                                                  y: presenter.view.center.y,
                                                                  width: 0,
                                                                  height: 0)
        dialog.popoverPresentationController?.permittedArrowDirections = []
        
        presenter.present(dialog, animated: true)
    }
    
    func showWorkflow(_ workflow: SBSDKUIWorkflow, on presenter: UIViewController) {
        let config = SBSDKUIWorkflowScannerConfiguration.default()
        let controller = SBSDKUIWorkflowScannerViewController
            .createNew(with: workflow,
                       configuration: config,
                       delegate: self)!
        
        self.presentViewController(controller)
    }
        
    func showErrorAlert(title: String, message: String?, on viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        viewController.present(alert, animated: true)
    }
    
}

extension UsecaseStartWorkflow: SBSDKUIWorkflowScannerViewControllerDelegate {
    func workflowScanViewController(_ viewController: SBSDKUIWorkflowScannerViewController,
                                    didFailStepValidation step: SBSDKUIWorkflowStep,
                                    with result: SBSDKUIWorkflowStepResult) {
        if !step.runsContinuousValidation {
            self.showErrorAlert(title: "Step validation failed",
                                message:result.validationError?.localizedDescription,
                                on:viewController)
        }
    }
    
    func workflowScanViewController(_ viewController: SBSDKUIWorkflowScannerViewController,
                                    didFailWorkflowValidation workflow: SBSDKUIWorkflow,
                                    with results: [SBSDKUIWorkflowStepResult],
                                    validationError error: Error) {
        self.showErrorAlert(title: "Workflow validation failed",
                            message:error.localizedDescription,
                            on:viewController)
    }
    
    func workflowScanViewController(_ viewController: SBSDKUIWorkflowScannerViewController,
                                    didFinish workflow: SBSDKUIWorkflow,
                                    with results: [SBSDKUIWorkflowStepResult]) {
        if let navigationController = self.presenter as? UINavigationController, !results.isEmpty {
            viewController.dismiss(animated: true) {
                let controller = WorkflowResultsViewController.make(with: results)
                navigationController.pushViewController(controller, animated: true)
            }
        }
    }
}
