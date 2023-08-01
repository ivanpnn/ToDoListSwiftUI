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
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 20.0) {
                    Text(task.title)
                        .foregroundColor(.black)
                        .overlay(
                            Capsule().stroke(.black, lineWidth: 0.75)
                                .padding(-5)
                        )
                    if !task.isFault {
                        Text("Due: \(task.dueDate , formatter: itemFormatter)")
                            .padding(1)
                            .foregroundColor(.black)
                    }
                }
                Spacer()
                Text(task.desc)
                    .font(.footnote)
                    .foregroundColor(.black)
                    .frame(minWidth: 62)
                    .multilineTextAlignment(.trailing)
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
