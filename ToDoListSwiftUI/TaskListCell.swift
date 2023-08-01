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
                }
                HStack(alignment: .top) {
                    Text(task.desc)
                        .foregroundColor(.gray)
                        .font(.custom("AppleSDGothicNeo-Bold", size: 18))
                    Spacer()
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
