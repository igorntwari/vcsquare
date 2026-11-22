
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/user_model.dart';
import '../../../shared/widgets/avatars/user_avatar.dart';

class NewChatSheet extends StatefulWidget {
  const NewChatSheet({super.key, required this.people});

  final List<UserModel> people;

  @override
  State<NewChatSheet> createState() => _NewChatSheetState();
}

class _NewChatSheetState extends State<NewChatSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();

    final shown = widget.people.where((u) {
      return q.isEmpty ||
          u.name.toLowerCase().contains(q) ||
          u.handle.toLowerCase().contains(q);
    }).toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.7,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search students',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            Expanded(
              child: shown.isEmpty
                  ? const Center(child: Text('No students found'))
                  : ListView.builder(
                      itemCount: shown.length,
                      itemBuilder: (context, i) {
                        final user = shown[i];

                        return ListTile(
                          leading: UserAvatar(
                            size: AppSizes.avatarMd,
                            imagePath: user.avatarPath,
                          ),
                          title: Text(user.name),
                          subtitle: Text(user.handle),
                          onTap: () => Navigator.of(context).pop(user),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

