//
//  HomeView.swift
//  SwiftUI-MVVM
//
//  Created by DREAMWORLD on 10/01/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var taskViewModel: TaskViewModel = TaskViewModelFactory.createTaskViewModel()
    @State private var pickerTitles: [String] = ["Active", "Completed"]
    @State private var selectedPickerTitle: String = "Active"
    @State private var isActive: Bool = true
    @State private var showAddTaskView: Bool = false
    @State private var showTaskDetailView: Bool = false
    @State private var selectedTask: Task = Task(id: UUID(), name: "", description: "", isCompleted: false, finishDate: Date())
    @State private var refreshTaskList: Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            //MARK: Picker
            Picker("Picker filter", selection: $selectedPickerTitle) {
                ForEach(pickerTitles, id: \.self) {
                    Text($0)
                }
            }
            .padding(.horizontal, 10.0)
            .pickerStyle(.segmented)
            .onChange(of: selectedPickerTitle) { newValue in
                selectedPickerTitle = newValue
                isActive = newValue == "Active" ? true : false
                taskViewModel.getTasks(isCompleted: isActive)
            }
            
            //MARK: List
            List(taskViewModel.tasks, id: \.id) { task in
                VStack(alignment: .leading) {
                    Text(task.name)
                        .font(.title)
                    HStack {
                        Text(task.description)
                            .font(.subheadline)
                            .lineLimit(2)
                        Spacer()
                        Text(task.finishDate.toString())
                            .font(.subheadline)
                    }
                }.onTapGesture {
                    selectedTask = task
                    showTaskDetailView.toggle()
                }
            }.onAppear{
                taskViewModel.getTasks(isCompleted: true)
            }
            .onChange(of: refreshTaskList, perform: { _ in
                taskViewModel.getTasks(isCompleted: selectedPickerTitle == "Active")
            }).listStyle(.plain)
                .navigationTitle("Home")
            
            //MARK: ToolBar
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showAddTaskView.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                        .sheet(isPresented: $showAddTaskView) {
                            AddTaskView(taskViewModel: taskViewModel, showAddTaskView: $showAddTaskView,
                                        refreshTaskList: $refreshTaskList)
                        }
                        
                        .sheet(isPresented: $showTaskDetailView) {
                            TaskDetailView(taskViewModel: taskViewModel, selectedTask: $selectedTask, showTaskDetailView: $showTaskDetailView,refreshTaskList: $refreshTaskList)
                        }
                    }
                }
            
                .alert("Task Error",
                       isPresented: $taskViewModel.showError,
                       actions: {
                    Button(action: {
//                        selectedPickerTitle = isActive == true ? "Completed" : "Active"
                    }) {
                        Text("Ok")
                    }
                },
                       message: {
                    Text(taskViewModel.errorMessage)
                })
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
