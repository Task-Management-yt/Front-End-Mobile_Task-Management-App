import 'package:flutter/material.dart';
import 'package:task_management_app/constant/task.dart';
import 'package:task_management_app/models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  const TaskTile({Key? key, required this.task, this.onTap, this.onEdit})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Jarak antar kartu
      child: Card(
        elevation: 4, // Efek shadow agar lebih elegan
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Membuat sudut membulat
        ),
        child: InkWell(
          onTap: onTap, // Aksi saat ditekan
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Indikator status tugas (ikon di kiri)
                Column(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          task.status == TaskStatus.selesai
                              ? Colors.green
                              : task.status == TaskStatus.sedangBerjalan
                              ? Colors.orange
                              : Colors.grey,
                      child: Icon(
                        task.status == TaskStatus.selesai
                            ? Icons.check_circle
                            : task.status == TaskStatus.sedangBerjalan
                            ? Icons.hourglass_empty
                            : Icons.error,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${task.status}",
                      style: TextStyle(fontSize: 8, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(width: 12), // Jarak antara icon dan teks
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 4),
                      Text(
                        "Deadline: ${task.deadline}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                // Ikon edit atau hapus di kanan
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEdit, // Aksi edit tugas
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
