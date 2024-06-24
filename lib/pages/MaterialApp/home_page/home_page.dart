import 'dart:io';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:platform_convertion/controller/functionController.dart';
import 'package:platform_convertion/controller/platFormController.dart';
import 'package:platform_convertion/controller/themeController.dart';
import 'package:platform_convertion/modal/userContactModal.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:platform_convertion/extension.dart';
import 'package:url_launcher/url_launcher.dart';

class MTHomePage extends StatefulWidget {
  const MTHomePage({super.key});

  @override
  State<MTHomePage> createState() => _MTHomePageState();
}

List form = List.generate(
  5,
  (index) => GlobalKey<FormState>(),
);

class _MTHomePageState extends State<MTHomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 4, vsync: this);
    PageController pageController = PageController();

    FunctionController provider = Provider.of<FunctionController>(context);
    FunctionController nonprovider =
        Provider.of<FunctionController>(context, listen: false);

    List<Widget> allTabs = [
      // first page
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  ImagePicker picker = ImagePicker();

                  XFile? file =
                      await picker.pickImage(source: ImageSource.camera);

                  if (file != null) {
                    provider.userImage = File(file.path);
                    setState(() {});
                  }
                },
                child: CircleAvatar(
                  radius: 80,
                  foregroundImage: provider.userImage == null
                      ? null
                      : FileImage(provider.userImage!),
                  child: Icon(Icons.add_a_photo),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: form[0],
                child: TextFormField(
                  onSaved: (val) {
                    provider.userName = val;
                  },
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter Your Full Name" : null,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.face),
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: form[1],
                child: TextFormField(
                  onSaved: (val) {
                    provider.userNumber = val;
                  },
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter Your Number" : null,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.call),
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: form[2],
                child: TextFormField(
                  onSaved: (val) {
                    provider.userMsg = val;
                  },
                  validator: (val) => (val!.isEmpty) ? "Enter Your Msg" : null,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.chat),
                    labelText: 'Chat Conversation',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () async {
                    provider.pickDate(context: context);
                    Logger().i(provider.userDate);
                  },
                  icon: const Icon(
                    Icons.calendar_month,
                  ),
                  label: provider.userDate == null
                      ? const Text(
                          'Pick Date',
                        )
                      : Text('${provider.userDate?.pickDate}'),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () {
                    provider.pickTime(context: context);
                  },
                  icon: const Icon(
                    Icons.timer_outlined,
                  ),
                  label: provider.userTime == null
                      ? const Text(
                          'Pick Time',
                        )
                      : Text('${provider.userTime?.pickTime}'),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  if (form[0].currentState!.validate() &&
                      form[1].currentState!.validate() &&
                      form[2].currentState!.validate()) {
                    form[0].currentState!.save();
                    form[1].currentState!.save();
                    form[2].currentState!.save();
                  }
                  nonprovider.addContact(
                    UserContactModal(
                      userImage: provider.userImage,
                      userNumber: provider.userNumber,
                      userName: provider.userName,
                      userMsg: provider.userMsg,
                      userDate: provider.userDate,
                      userTime: provider.userTime,
                    ),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
      //secound page
      provider.allContact.isEmpty
          ? const Center(
              child: Text(
                'no any Chats yet...',
              ),
            )
          : ListView.builder(
              itemCount: provider.allContact.length,
              itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(
                  foregroundImage: provider.allContact[index].userImage == null
                      ? null
                      : FileImage(provider.allContact[index].userImage!),
                ),
                title: Text(provider.allContact[index].userName ?? 'Name'),
                subtitle: Text(provider.allContact[index].userMsg ?? 'No Msg'),
                trailing: Text(
                    '${provider.allContact[index].userDate?.pickDate},${provider.allContact[index].userTime?.pickTime}'),
              ),
            ),
      //third page
      provider.allContact.isEmpty
          ? const Center(
              child: Text(
                'no any Calls yet...',
              ),
            )
          : ListView.builder(
              itemCount: provider.allContact.length,
              itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(
                  foregroundImage: provider.allContact[index].userImage == null
                      ? null
                      : FileImage(provider.allContact[index].userImage!),
                ),
                title: Text(provider.allContact[index].userName ?? 'Name'),
                subtitle: Text(provider.allContact[index].userMsg ?? 'No Msg'),
                trailing: IconButton(
                  onPressed: () async {
                    Uri call = Uri(
                      scheme: 'tel',
                      path: nonprovider.allContact[index].userNumber,
                    );
                    await launchUrl(call);
                  },
                  icon: const Icon(
                    Icons.call,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
      //forth page
      SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(
                Icons.face,
              ),
              title: const Text('Profile'),
              subtitle: const Text('Update Profile Data'),
              trailing: Switch(
                value: Provider.of<PlatFormController>(context).isUpdate,
                onChanged: (val) {
                  Provider.of<PlatFormController>(context, listen: false)
                      .ChangeUpdate();
                },
              ),
            ),
            Visibility(
              visible: Provider.of<PlatFormController>(context).isUpdate,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      ImagePicker picker = ImagePicker();

                      XFile? file =
                          await picker.pickImage(source: ImageSource.camera);

                      if (file != null) {
                        provider.image = File(file.path);
                        setState(() {});
                      }
                    },
                    child: CircleAvatar(
                      radius: 100,
                      foregroundImage: provider.image == null
                          ? null
                          : FileImage(provider.image!),
                      child: const Icon(
                        Icons.add_a_photo,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: provider.name == null
                        ? Form(
                            key: form[3],
                            child: TextFormField(
                              onSaved: (val) {
                                provider.name = val;
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter Your name...'),
                            ),
                          )
                        : Text(provider.name!),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: provider.bio == null
                        ? Form(
                            key: form[4],
                            child: TextFormField(
                              onSaved: (val) {
                                provider.bio = val;
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter Your Bio...'),
                            ),
                          )
                        : Text(provider.bio!),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          form[3].currentState!.save();
                          form[4].currentState!.save();
                        },
                        child: const Text(
                          'SAVE',
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          provider.image = null;
                          provider.name = null;
                          provider.bio = null;
                          setState(() {});
                        },
                        child: const Text(
                          'CLEAR',
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.sunny,
              ),
              title: const Text('Theme'),
              subtitle: const Text('Change Theme'),
              trailing: Switch(
                value: Provider.of<ThemeController>(context).isdark,
                onChanged: (val) {
                  Provider.of<ThemeController>(context, listen: false)
                      .ChangeTheme();
                },
              ),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Platform Converter',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Switch(
            value: Provider.of<PlatFormController>(context).isIos,
            onChanged: (val) {
              Provider.of<PlatFormController>(context, listen: false)
                  .ChangePlatForm();
            },
          ),
        ],
        bottom: TabBar(
          controller: tabController,
          onTap: (val) {
            pageController.animateToPage(
              val,
              duration: const Duration(milliseconds: 200),
              curve: Curves.bounceIn,
            );
          },
          tabs: const [
            Tab(
              icon: Icon(Icons.add_call),
            ),
            Tab(
              child: Text('CHATS'),
            ),
            Tab(
              child: Text('CALLS'),
            ),
            Tab(
              child: Text('SETTING'),
            ),
          ],
        ),
      ),
      body: PageView.builder(
        controller: pageController,
        onPageChanged: (value) {
          tabController.animateTo(value);
        },
        itemCount: allTabs.length,
        itemBuilder: (context, index) => allTabs[index],
      ),
    );
  }
}
