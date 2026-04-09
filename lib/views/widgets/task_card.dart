import 'package:flutter/material.dart';
import 'package:practice/models/task.dart';
import 'package:practice/views/dialogs/delete_task_dialog.dart';
import 'package:practice/views/dialogs/edit_task_dialog.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required TaskModel this.activityModel,
    required this.onEdit,
    required this.onDelete,
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
  })  : activityModel = null,
        onEdit = null,
        onDelete = null;

  final TaskModel? activityModel;
  final Future<void> Function({
    required TaskModel original,
    required String title,
    required int points,
  })? onEdit;
  final Future<void> Function(TaskModel activityModel)? onDelete;

  final String? title;
  final int? points;
  final bool? isSelected;
  final ValueChanged<bool>? onToggleSelected;
  final Widget? selectableTrailing;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    if (widget.activityModel == null) {
      return _buildSelectableCard();
    }
    return _buildTaskCard(context);
  }

  Widget _buildSelectableCard() {
    return Card(
      child: InkWell(
        onTap: () => widget.onToggleSelected?.call(!(widget.isSelected ?? false)),
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
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
    final activityModel = widget.activityModel!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        child: Row(
          children: [
            Checkbox(
              value: _isChecked,
              onChanged: (value) {
                setState(() {
                  _isChecked = value ?? false;
                });
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                activityModel.title,
                style: const TextStyle(fontSize: 25),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              activityModel.points.toString(),
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              onSelected: (String value) {
                if (value == 'edit') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => EditTaskDialog(
                      activityModel: activityModel,
                      onSubmit: widget.onEdit!,
                    ),
                  );
                } else if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => DeleteTaskDialog(
                      activityModel: activityModel,
                      onConfirm: widget.onDelete!,
                    ),
                  );
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
    );
  }
}
