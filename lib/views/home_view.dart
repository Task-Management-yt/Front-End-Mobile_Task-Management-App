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
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

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
            preferredSize: const Size.fromHeight(100),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Cari tugas...",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon:
                          searchQuery.isNotEmpty
                              ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    searchQuery = "";
                                  });
                                },
                              )
                              : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Consumer<TaskProvider>(
                  builder: (context, taskProvider, child) {
                    List<Task> filteredTasks = _filterTasks(taskProvider.tasks);

                    int semua = filteredTasks.length;
                    int belumSelesai =
                        filteredTasks
                            .where(
                              (task) => task.status == TaskStatus.belumSelesai,
                            )
                            .length;
                    int sedangBerjalan =
                        filteredTasks
                            .where(
                              (task) =>
                                  task.status == TaskStatus.sedangBerjalan,
                            )
                            .length;
                    int selesai =
                        filteredTasks
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
              ],
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

  /// Fungsi untuk memfilter tugas berdasarkan kata kunci pencarian
  List<Task> _filterTasks(List<Task> tasks) {
    if (searchQuery.isEmpty) return tasks;
    return tasks.where((task) {
      return task.title!.toLowerCase().contains(searchQuery) ||
          task.description!.toLowerCase().contains(searchQuery);
    }).toList();
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

            // Filter berdasarkan pencarian
            // filteredTasks =
            //     filteredTasks
            //         .where(
            //           (task) => task.title!.toLowerCase().contains(searchQuery),
            //         )
            //         .toList();            // Fitur Pencarian
            if (searchQuery.isNotEmpty) {
              filteredTasks =
                  filteredTasks.where((task) {
                    return task.title!.toLowerCase().contains(searchQuery) ||
                        task.description!.toLowerCase().contains(searchQuery);
                  }).toList();
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
                    // debugPrint("Tugas: ${task.title}");
                    _dialogBuilder(context, task);
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

Future<void> _dialogBuilder(BuildContext context, Task task) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(task.title!),
        content: Text(
          'Deskripsi : ${task.description!}\n'
          'Status    : ${task.status!}\n'
          'Deadline  : ${task.deadline!}',
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Tutup'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Edit'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TaskView(task: task)),
              );
            },
          ),
        ],
      );
    },
  );
}
