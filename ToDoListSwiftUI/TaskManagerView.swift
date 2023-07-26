//
//  TaskManagerView.swift
//  ToDoListSwiftUI
//
//  Created by MacBook Noob on 26/07/23.
//

import SwiftUI

struct TaskManagerView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var showError = false
    @State var errorMessage: String = "Unknown error"
    @State var date = Date.now
    @State var taskNameField: String = ""
    @State var taskDescriptionField: String = ""
    
    @ObservedObject var vm: ViewModel
        
    var body: some View {
        NavigationView {
            ScrollView (.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 15.0) {
                    Text("Task Name")
                        .font(.subheadline)
                        .padding(.bottom, -10.0)
                    TextField("Enter your task name", text: $taskNameField)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(5)
                    Text("Task Description")
                        .font(.subheadline)
                        .padding(.bottom, -10.0)
                    TextField("Enter your task description", text: $taskDescriptionField)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(5)
                        
                    
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
                .navigationBarTitle("New Task", displayMode: .inline)
                .navigationBarItems(trailing:
                  Button(action: closeView) {
                    Image(systemName: "xmark")
                  })
            }
        }
        .alert(errorMessage, isPresented: $showError) {
            Button("Ok", role: .cancel) {}
        }
    }
}

extension TaskManagerView {
    private func addTask() {
        vm.createTask(title: taskNameField, desc: taskDescriptionField, dueDate: date)
        closeView()
    }
    
    private func showError(_ error: Error) {
        self.showError = true
        self.errorMessage = error.localizedDescription
    }
    
    private func closeView() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
}

struct TaskManagerView_Previews: PreviewProvider {
    static var previews: some View {
        TaskManagerView(vm: ViewModel())
    }
}

