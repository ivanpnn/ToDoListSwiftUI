//
//  TaskListCell.swift
//  ToDoListSwiftUI
//
//  Created by MacBook Noob on 01/08/23.
//

import SwiftUI

struct TaskListCell: View {
    
    @ObservedObject var task: TaskEntityList
    @ObservedObject var vm: ViewModel
    @State private var showTaskManagerView = false

    var body: some View {
        Button {
            showTaskManagerView = true
        } label: {
            VStack (spacing: 10) {
                HStack(alignment: .top) {
                    Text(task.title)
                        .foregroundColor(.black)
                        .font(.custom("AppleSDGothicNeo-Bold", size: 24))
                    Spacer()
                    Toggle("", isOn: $task.taskDone)
                        .toggleStyle(CheckboxToggleStyle(block: {
                            do {
                                try vm.updateTask(task: task, title: task.title, desc: task.desc, dueDate: task.dueDate, taskDone: !task.taskDone)
                            } catch {
                                ErrorHandling.shared.handle(error: error)
                            }
                        }))
                }
                HStack(alignment: .center) {
                    Text(task.desc)
                        .foregroundColor(.gray)
                        .font(.custom("AppleSDGothicNeo-Bold", size: 18))
                    Spacer()
                    if task.taskDone {
                        Text("Completed!")
                            .foregroundColor(.green)
                            .font(.custom("AppleSDGothicNeo-Bold", size: 18))
                            .transition(.scale)
                    }
                }
                if !task.isFault {
                    HStack{
                        Text("\(task.dueDate , formatter: itemFormatter)")
                            .padding(0)
                            .foregroundColor(.gray)
                            .font(.custom("Futura-Medium", size: 14))
                        Spacer()
                        Text("\(task.dueDate , formatter: timeFormatter)")
                            .padding(0)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.gray)
                            .font(.custom("Futura-Medium", size: 15))
                    }
                }
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button (role: .destructive) {
                withAnimation(.easeInOut) {
                    vm.deleteTask(task: task)
                }
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
        }
        .sheet(isPresented: $showTaskManagerView) {
            TaskManagerView(task: task, vm: vm)
        }
    }
}

struct TaskListCell_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let task = TaskEntityList(context: context)
        task.title = "A task"
        task.desc = "A Task Description"
        task.dueDate = Date()
        
        return TaskListCell(task: task, vm: ViewModel()).previewLayout(.sizeThatFits).padding()
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()

private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter
}()

struct CheckboxToggleStyle: ToggleStyle {
    var block: ()->(Void)
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 5.0)
                .stroke(lineWidth: 2)
                .frame(width: 25, height: 25)
                .cornerRadius(5.0)
                .overlay {
                    Image(systemName: configuration.isOn ?"checkmark" : "")
                }
                .onTapGesture {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.25, blendDuration: 0.25)) {
//                        configuration.isOn.toggle()
                        self.block()
                    }
                }
            configuration.label
        }
    }
}
