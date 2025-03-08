import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/constant/task.dart';
import 'package:task_management_app/models/task.dart';
import 'package:task_management_app/providers/task_provider.dart';
import 'package:task_management_app/views/components/task_card.dart';
import 'package:task_management_app/views/task_view.dart';
import 'package:task_management_app/views/welcome_view.dart';
import '../providers/auth_provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchUserTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return DefaultTabController(
      length: 4, // Jumlah tab
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Home'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                authProvider.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeView()),
                );
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                int semua = taskProvider.tasks.length;
                int belumSelesai =
                    taskProvider.tasks
                        .where((task) => task.status == TaskStatus.belumSelesai)
                        .length;
                int sedangBerjalan =
                    taskProvider.tasks
                        .where(
                          (task) => task.status == TaskStatus.sedangBerjalan,
                        )
                        .length;
                int selesai =
                    taskProvider.tasks
                        .where((task) => task.status == TaskStatus.selesai)
                        .length;

                return TabBar(
                  isScrollable: true,
                  labelColor: Colors.black,
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(text: "Semua ($semua)"),
                    Tab(text: "Belum Selesai ($belumSelesai)"),
                    Tab(text: "Sedang Berjalan ($sedangBerjalan)"),
                    Tab(text: "Selesai ($selesai)"),
                  ],
                );
              },
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildTaskList(context, "Semua"),
            _buildTaskList(context, TaskStatus.belumSelesai),
            _buildTaskList(context, TaskStatus.sedangBerjalan),
            _buildTaskList(context, TaskStatus.selesai),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          tooltip: "Tambah Tugas",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TaskView()),
            );
          },
          backgroundColor: Colors.black,
          label: const Text(
            "Tambah Tugas",
            style: TextStyle(color: Colors.white),
          ),
          icon: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, String filter) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            if (taskProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (taskProvider.errorMessage != null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    taskProvider.errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => taskProvider.fetchUserTasks(),
                    child: const Text("Coba Lagi"),
                  ),
                ],
              );
            }

            List<Task> filteredTasks = taskProvider.tasks;
            if (filter != "Semua") {
              filteredTasks =
                  filteredTasks.where((task) => task.status == filter).toList();
            }

            if (filteredTasks.isEmpty) {
              return const Center(child: Text("Tidak ada tugas tersedia."));
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return TaskTile(
                  task: task,
                  onTap: () {
                    debugPrint("Tugas: ${task.title}");
                  },
                  onEdit: () {
                    debugPrint("Edit tugas: ${task.title}");
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
