//
//  AddTaskView.swift
//  SwiftUI-MVVM
//
//  Created by DREAMWORLD on 16/02/24.
//

import SwiftUI

struct AddTaskView: View {
    
    @ObservedObject var taskViewModel: TaskViewModel
    @State private var task : Task = Task.createEmptyTask()
    @Binding var showAddTaskView: Bool
    @Binding var refreshTaskList: Bool
    @State private var showDirtyCheckAlert: Bool = false
    
    var pickerDateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let currentDateComponent = calendar.dateComponents([.day, .month, .year, .hour, .minute],
                                                           from: Date())
        let startDateComponent = DateComponents (year: currentDateComponent.year, month:
                                                        currentDateComponent.month, day: currentDateComponent.day, hour:
                                                        currentDateComponent.hour, minute: currentDateComponent.minute)
        let endDateComponent = DateComponents (year: 2024, month: 12, day: 31)
        return calendar.date(from: startDateComponent)! ... calendar.date (from: endDateComponent)!
    }
    
    var body: some View {
        NavigationStack{
            List {
                Section {
                    TextField("Task name", text: $task.name)
                    TextEditor(text: $task.description)
                } header: {
                    Text(verbatim: "Task detail")
                }
                
                Section {
                    DatePicker("Task date", selection: $task.finishDate, in: pickerDateRange)
                } header: {
                    Text(verbatim: "Task date/time")
                }
            }.navigationTitle("Add Task")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            if(!task.name.isEmpty) {
                                // show alert
                                showDirtyCheckAlert.toggle()
                            }else{
                                showAddTaskView.toggle()
                            }
                        } label: {
                            Text("Cancel")
                        }.alert("Save Task",
                                isPresented: $showDirtyCheckAlert) {
                            Button {
                                showAddTaskView.toggle()
                            } label: {
                                Text("Cancel")
                            }
                            Button {
                                AddTask()
                            } label: {
                                Text("Save")
                            }
                        } message: {
                            Text("Would you like to save the task?")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            AddTask()
                        } label: {
                            Text("Add")
                        }
                        .disabled(task.name.isEmpty)
                    }
                }
                .alert("Task Error",
                       isPresented: $taskViewModel.showError,
                       actions: {
                    Button(action: {}) {
                        Text("Ok")
                    }
                },
                       message: {
                    Text(taskViewModel.errorMessage)
                })
        }
        .onDisappear(){
            refreshTaskList.toggle()
        }
    }
    
    private func AddTask() {
        if(taskViewModel.addTask (task: task)) {
            showAddTaskView.toggle()
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView(taskViewModel: TaskViewModelFactory.createTaskViewModel(), showAddTaskView: .constant(false), refreshTaskList: .constant(false))
    }
}
