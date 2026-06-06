import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:practice/models/task.dart';
import 'package:practice/views/dialogs/delete_task_dialog.dart';
import 'package:practice/views/dialogs/edit_task_dialog.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required TaskModel this.taskModel,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleComplete,
  })  : title = null,
        points = null,
        isSelected = null,
        onToggleSelected = null,
        selectableTrailing = null;

  const TaskCard.selectable({
    super.key,
    required this.title,
    required this.points,
    required this.isSelected,
    required this.onToggleSelected,
    this.selectableTrailing,
  })  : taskModel = null,
        onEdit = null,
        onDelete = null,
        onToggleComplete = null;

  final TaskModel? taskModel;
  final Future<void> Function({
    required TaskModel original,
    required String title,
    required int points,
  })? onEdit;
  final Future<void> Function(TaskModel taskModel)? onDelete;
  final Future<void> Function({
    required TaskModel task,
    required bool isCompleted,
  })? onToggleComplete;

  final String? title;
  final int? points;
  final bool? isSelected;
  final ValueChanged<bool>? onToggleSelected;
  final Widget? selectableTrailing;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    if (widget.taskModel == null) {
      return _buildSelectableCard();
    }
    return _buildTaskCard(context);
  }

  Widget _buildSelectableCard() {
    return Card(
      child: InkWell(
        onTap: () =>
            widget.onToggleSelected?.call(!(widget.isSelected ?? false)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: Row(
            children: [
              Checkbox(
                value: widget.isSelected ?? false,
                onChanged: (value) {
                  widget.onToggleSelected?.call(value ?? false);
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.title ?? '',
                  style: const TextStyle(fontSize: 25),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                (widget.points ?? 0).toString(),
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              if (widget.selectableTrailing != null) ...[
                const SizedBox(width: 12),
                widget.selectableTrailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context) {
    final taskModel = widget.taskModel!;
    return Slidable(
      key: ValueKey(taskModel.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          CustomSlidableAction(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            onPressed: (_) => _showDeleteDialog(context, taskModel),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 45,
                width: 70,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      '削除',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: Row(
            children: [
              Checkbox(
                value: taskModel.isCompleted,
                onChanged: (value) async {
                  final next = value ?? false;
                  if (next == taskModel.isCompleted) {
                    return;
                  }
                  await widget.onToggleComplete!(
                    task: taskModel,
                    isCompleted: next,
                  );
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  taskModel.title,
                  style: const TextStyle(fontSize: 25),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                taskModel.points.toString(),
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                onSelected: (String value) {
                  if (value == 'edit') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => EditTaskDialog(
                        taskModel: taskModel,
                        onSubmit: widget.onEdit!,
                      ),
                    );
                  } else if (value == 'delete') {
                    _showDeleteDialog(context, taskModel);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text('編集'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('削除', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    TaskModel taskModel,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) => DeleteTaskDialog(
        taskModel: taskModel,
        onConfirm: widget.onDelete!,
      ),
    );
  }
}
