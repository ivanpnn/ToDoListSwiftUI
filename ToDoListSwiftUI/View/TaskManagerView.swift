//
//  TaskManagerView.swift
//  ToDoListSwiftUI
//
//  Created by MacBook Noob on 26/07/23.
//

import SwiftUI
import Combine

struct TaskManagerView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var showError = false
    @State var errorMessage: String = "Unknown error"
    @State var date = Date.now
    @State var taskTitleField: String = ""
    @State var taskDescriptionField: String = ""
    
    var task: TaskEntityList?
    var titleBar: String  = String()
    var isEditMode: Bool = false

    @ObservedObject var vm: CoreDataManager
    
    @StateObject var errorHandling = ErrorHandling.shared
    
    public init(task: TaskEntityList?, vm: CoreDataManager) {
        self.task = task
        self.vm = vm
        
        if self.task != nil {
            self.titleBar = "Edit Task"
            _taskTitleField = State(initialValue: task!.title)
            _taskDescriptionField = State(initialValue: task!.desc)
            _date = State(initialValue: task!.dueDate)
            isEditMode = true
        } else {
            self.titleBar = "New Task"
        }
    }
        
    var body: some View {
        NavigationView {
            ScrollView (.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 15.0) {
                    // Task Name Section
                    Text("Task Name")
                        .font(.subheadline)
                        .padding(.bottom, -10.0)
                    TextField("Enter your task name", text: $taskTitleField)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(5)
                        .onReceive(Just(taskTitleField)) { _ in
                            limitTextOnTitle(24)
                        }
                    
                    // Task Description Section
                    Text("Task Description")
                        .font(.subheadline)
                        .padding(.bottom, -10.0)
                    TextField("Enter your task description", text: $taskDescriptionField)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(5)
                        .onReceive(Just(taskDescriptionField)) { _ in
                            limitTextOnDescription(120)
                        }
                        
                    // Task Date Section
                    Text("Date")
                        .font(.subheadline)
                        .padding(.bottom, -10.0)
                    DatePicker("Enter your due date", selection: $date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .frame(maxHeight: 400)
                    Divider()
                    
                    Button(action: addTask) {
                        Text("Save")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color.cyan)
                            .cornerRadius(5)
                            .foregroundColor(Color.white)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 30)
                .navigationBarTitle(titleBar, displayMode: .inline)
                .navigationBarItems(trailing:
                  Button(action: closeView) {
                    Image(systemName: "xmark")
                  })
            }
        }
        .alert(errorMessage, isPresented: $showError) {
            Button("Ok", role: .cancel) {}
        }
        .alert(errorHandling.localizedError, isPresented: $errorHandling.hasError) {
            Button("Ok") {
                errorHandling.dismissButton()
            }
        }
    }
}

extension TaskManagerView {
    private func addTask() {
        if isEditMode {
            guard task != nil else {
                showError(DataError.unknownError)
                return
            }
            do {
                try vm.updateTask(task: task!, title: taskTitleField, desc: taskDescriptionField, dueDate: date, taskDone: task!.taskDone)
                closeView()
            } catch {
                showError(error)
            }
        } else {
            do {
                try vm.createTask(title: taskTitleField, desc: taskDescriptionField, dueDate: date)
                closeView()
            } catch {
                showError(error)
            }
        }
    }
    
    private func showError(_ error: Error) {
        self.showError = true
        self.errorMessage = error.localizedDescription
    }
    
    private func closeView() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func limitTextOnDescription(_ upper: Int) {
        if taskDescriptionField.count > upper {
            taskDescriptionField = String(taskDescriptionField.prefix(upper))
        }
    }
    
    private func limitTextOnTitle(_ upper: Int) {
        if taskTitleField.count > upper {
            taskTitleField = String(taskTitleField.prefix(upper))
        }
    }
    
}

struct TaskManagerView_Previews: PreviewProvider {
    static var previews: some View {
        TaskManagerView(task: TaskEntityList(), vm: CoreDataManager())
    }
}

