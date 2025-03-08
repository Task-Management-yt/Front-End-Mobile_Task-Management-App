import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/models/task.dart';
import 'package:task_management_app/providers/task_provider.dart';
import 'package:task_management_app/constant/task.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/views/components/button.dart';
import 'package:task_management_app/views/home_view.dart';

class TaskView extends StatefulWidget {
  final Task? task; // Jika null, berarti tambah tugas

  const TaskView({super.key, this.task});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedStatus = TaskStatus.belumSelesai;
  DateTime? _selectedDeadline;
  String? _deadlineError;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      // Jika mode edit, isi dengan data tugas
      _titleController.text = widget.task!.title!;
      _descriptionController.text = widget.task!.description ?? "";
      _selectedStatus = widget.task!.status!;
      _selectedDeadline = widget.task!.deadline;
    }
  }

  /// 📅 Fungsi untuk menampilkan Date Picker
  Future<void> _pickDeadline() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now(),
      firstDate: DateTime(1),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDeadline = pickedDate;
        _deadlineError = null;
      });
    }
  }

  void _saveTask() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Judul tugas tidak boleh kosong!")),
      );
      return;
    }

    if (_selectedDeadline == null) {
      setState(() {
        _deadlineError = "Deadline harus dipilih!";
      });
      return;
    }

    if (widget.task == null) {
      // Mode tambah tugas
      Task newTask = Task(
        title: _titleController.text,
        description: _descriptionController.text,
        status: _selectedStatus,
        deadline: _selectedDeadline,
      );
      taskProvider.addTask(newTask);
    } else {
      // Mode edit tugas
      Task updatedTask = Task(
        id: widget.task!.id,
        title: _titleController.text,
        description: _descriptionController.text,
        status: _selectedStatus,
        deadline: _selectedDeadline,
      );

      taskProvider.updateTask(updatedTask);
    }

    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      barrierDismissible: false,
      builder:
          (BuildContext context) => AlertDialog(
            title: const Text('Berhasil!'),
            content: Text(
              widget.task == null
                  ? 'Tugas berhasil disimpan'
                  : 'Tugas berhasil diedit',
            ),
            actions: <Widget>[
              TextButton(
                onPressed:
                    () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeView()),
                    ),
                child: const Text('Ok'),
              ),
            ],
          ),
    ); // Kembali ke halaman sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? "Tambah Tugas" : "Edit Tugas"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Judul Tugas",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Deskripsi",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(
                    value: TaskStatus.belumSelesai,
                    child: Text("Belum Selesai"),
                  ),
                  DropdownMenuItem(
                    value: TaskStatus.sedangBerjalan,
                    child: Text("Sedang Berjalan"),
                  ),
                  DropdownMenuItem(
                    value: TaskStatus.selesai,
                    child: Text("Selesai"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: _pickDeadline,
                child: InputDecorator(
                  decoration: InputDecoration(
                    errorText: _deadlineError,
                    labelText: "Deadline",
                    border: const OutlineInputBorder(),
                  ),
                  child: Text(
                    _selectedDeadline == null
                        ? "Pilih Tanggal"
                        : DateFormat("dd MMM yyyy").format(_selectedDeadline!),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              widget.task != null
                  ? Center(
                    child: MyButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text("Hapus Tugas"),
                                content: const Text(
                                  "Apakah Anda yakin ingin menghapus tugas ini?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Batal"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      taskProvider.deleteTask(widget.task!);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const HomeView(),
                                        ),
                                      );
                                    },
                                    child: const Text("Hapus"),
                                  ),
                                ],
                              ),
                        );
                      },
                      text: "Hapus",
                      backgroundColor: Colors.red,
                    ),
                  )
                  : SizedBox(),
              const SizedBox(height: 20),
              Center(
                child: MyButton(
                  onPressed: () => _saveTask(),
                  text: widget.task != null ? "Edit" : "Simpan",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
