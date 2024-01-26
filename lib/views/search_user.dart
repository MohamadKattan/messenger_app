import 'package:flutter/material.dart';
import 'package:messenger_test/components%20/ctm_appbar.dart';
import 'package:messenger_test/components%20/ctm_progress.dart';
import 'package:messenger_test/utils/constants.dart';

import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../components /ctm_txt.dart';
import '../controllers /search_users.dart';

class SearchUsersScreen extends StatefulWidget {
  const SearchUsersScreen({super.key});

  @override
  State<SearchUsersScreen> createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends State<SearchUsersScreen> {
  late TextEditingController _searchUser;
  @override
  void initState() {
    _searchUser = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchUser.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchUsers = context.watch<SearchUsersController>();
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          txtTitle: txtSearchUser,
          context: context,
          bgColor: txtColorWhite,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(mainPadding),
              child: CustomTxt(
                writeNameSearch,
                txtAlign: TextAlign.start,
                fSzie: 16,
                color: txtColorBlack,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(mainPadding),
              child: TextField(
                controller: _searchUser,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  icon: Icon(Icons.search, size: 24.0),
                  labelText: typeName,
                ),
                onChanged: (value) {
                  if (value.length > 5) {
                    SearchUsersController().startSearchUser(value, context);
                  }
                },
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: searchUsers.listusers.length,
                  itemBuilder: (_, i) {
                    if (searchUsers.isSearching) {
                      return const Center(
                          child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: CustomProgressIndicator(),
                      ));
                    }
                    if (searchUsers.listusers.isEmpty) {
                      return CustomTxt('No new users yet ...');
                    }
                    final color =
                        Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                            .withOpacity(1.0);
                    return Container(
                      margin: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(mainRadius),
                          border: Border.all()),
                      child: ListTile(
                        onTap: () async {
                          String? id = searchUsers.listusers[i].userId;
                          String? name = searchUsers.listusers[i].userName;
                          bool? online = searchUsers.listusers[i].userOnLine;
                          await SearchUsersController().checkIfUserInMyChat(
                              id: id,
                              context: context,
                              name: name,
                              isOn: online);
                        },
                        leading: CircleAvatar(
                          radius: 25.0,
                          backgroundColor: color,
                          child: CustomTxt(
                            searchUsers.listusers[i].userName != null
                                ? searchUsers.listusers[i].userName![0]
                                    .toUpperCase()
                                : "null",
                            fSzie: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        title: CustomTxt(
                          searchUsers.listusers[i].userName ?? 'null',
                          color: txtColorBlack,
                          fSzie: 18,
                          fontWeight: FontWeight.bold,
                          txtAlign: TextAlign.start,
                        ),
                        subtitle:
                            Text(searchUsers.listusers[i].userMail ?? 'null'),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
