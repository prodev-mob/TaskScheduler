//
//  TaskDetailView.swift
//  SwiftUI-MVVM
//
//  Created by DREAMWORLD on 16/02/24.
//

import SwiftUI



struct TaskDetailView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @Binding var selectedTask: Task
    @Binding var showTaskDetailView: Bool
    @Binding var refreshTaskList: Bool
    @State private var showDeleteAlert: Bool = false
    
    var body: some View {
        NavigationStack{
            List {
                Section {
                    TextField("Task name", text: $selectedTask.name)
                    TextEditor(text: $selectedTask.description)
                    Toggle("Mark complete", isOn: $selectedTask.isCompleted)
                } header: {
                    Text(verbatim: "Task detail")
                }
                
                Section {
                    DatePicker("Task date", selection: $selectedTask.finishDate)
                } header: {
                    Text(verbatim: "Task date/time")
                }
                
                Section {
                    Button {
                        showDeleteAlert.toggle()
                    } label: {
                        Text("Delete")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .frame(maxWidth:.infinity, alignment:.center)
                    }.alert("Delete Task?", isPresented: $showDeleteAlert) {
                        Button {
                            showTaskDetailView.toggle()
                        } label: {
                            Text("No")
                        }
                        Button(role: .destructive) {
                            if (taskViewModel.deleteTask(task:  selectedTask)) {
                                showTaskDetailView.toggle()
                            }
                        } label: {
                            Text("Yes")
                        }
                    } message: {
                        Text("Would you like to delete the task \(selectedTask.name)?")
                    }
                }
                
            }.navigationTitle("Task Detail")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            print("cancel tapped")
                            showTaskDetailView.toggle()
                        } label: {
                            Text("Cancel")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            if(taskViewModel.updateTask(task: selectedTask)){
                                showTaskDetailView.toggle()
                                
                            }
                        } label: {
                            Text("Update")
                        }
                        .disabled(selectedTask.name.isEmpty)
                    }
                }
                .alert("Task Error",
                       isPresented: $taskViewModel.showError,
                       actions: {
                    Button(action: {
                        print("error showed")
                    }) {
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
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(taskViewModel: TaskViewModelFactory.createTaskViewModel(),
                       selectedTask: .constant(Task.createEmptyTask()), showTaskDetailView: .constant(false), refreshTaskList: .constant(false))
    }
}
