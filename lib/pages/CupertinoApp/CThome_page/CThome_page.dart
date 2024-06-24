import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:platform_convertion/controller/functionController.dart';
import 'package:platform_convertion/controller/themeController.dart';
import 'package:platform_convertion/modal/userContactModal.dart';
import 'package:platform_convertion/pages/MaterialApp/home_page/home_page.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controller/platFormController.dart';
import 'package:platform_convertion/extension.dart';

class CTHomePage extends StatefulWidget {
  const CTHomePage({super.key});

  @override
  State<CTHomePage> createState() => _CTHomePageState();
}

class _CTHomePageState extends State<CTHomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    FunctionController provider = Provider.of<FunctionController>(context);
    FunctionController nonprovider =
        Provider.of<FunctionController>(context, listen: false);
    PageController pageController = PageController();
    CupertinoTabController cupertinoTabController = CupertinoTabController();

    List<Widget> allTabs = [
      //add contact
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 100, 16, 0),
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
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CupertinoColors.activeBlue.withOpacity(0.3),
                    image: DecorationImage(
                      image: provider.userImage == null
                          ? FileImage(File('lib/assets/Ecommerce.png'))
                          : FileImage(provider.userImage!),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: provider.userImage == null
                      ? const Icon(CupertinoIcons.person_add)
                      : null,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: form[0],
                child: CupertinoTextFormFieldRow(
                  onSaved: (val) {
                    provider.userName = val;
                  },
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter Your Full Name" : null,
                  prefix: const Icon(CupertinoIcons.profile_circled),
                  placeholder: 'Full Name',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: form[1],
                child: CupertinoTextFormFieldRow(
                  keyboardType: TextInputType.phone,
                  onSaved: (val) {
                    provider.userNumber = val;
                  },
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter Your Number" : null,
                  prefix: const Icon(CupertinoIcons.phone),
                  placeholder: 'Phone Number',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: form[2],
                child: CupertinoTextFormFieldRow(
                  onSaved: (val) {
                    provider.userMsg = val;
                  },
                  validator: (val) => (val!.isEmpty) ? "Enter Your Msg" : null,
                  prefix: const Icon(CupertinoIcons.chat_bubble_text_fill),
                  placeholder: 'Chat Conversation',
                ),
              ),
              CupertinoButton(
                child: const Row(
                  children: [
                    Icon(
                      CupertinoIcons.calendar,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Pick Date',
                    ),
                  ],
                ),
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                      actions: [
                        Container(
                          color: CupertinoColors.white.withOpacity(0.4),
                          height: 200,
                          width: 500,
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            onDateTimeChanged: (DateTime value) {
                              setState(() {
                                provider.userDate = value;
                              });
                            },
                          ),
                        ),
                        //done
                        CupertinoButton(
                          child: Text('👍 Done'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        //cancel
                        CupertinoButton(
                          child: const Text(
                            '❌ Cancel',
                            style: TextStyle(
                              color: CupertinoColors.destructiveRed,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              CupertinoButton(
                child: const Row(
                  children: [
                    Icon(
                      CupertinoIcons.time_solid,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Pick Time',
                    ),
                  ],
                ),
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                      actions: [
                        Container(
                          color: CupertinoColors.white.withOpacity(0.4),
                          height: 200,
                          width: 500,
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            onDateTimeChanged: (value) {
                              setState(() {
                                provider.userTime =
                                    TimeOfDay.fromDateTime(value);
                              });
                            },
                          ),
                        ),
                        // done
                        CupertinoButton(
                          child: const Text('👍 Done'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        //cancel
                        CupertinoButton(
                          child: const Text(
                            '❌ Cancel',
                            style: TextStyle(
                              color: CupertinoColors.destructiveRed,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              CupertinoButton(
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
      // all chats
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 100, 16, 0),
        child: provider.allContact.isEmpty
            ? const Center(
                child: Text(
                  'no any Chats yet...',
                ),
              )
            : CupertinoListSection(
                header: const Text('All Chats'),
                children: List.generate(
                  provider.allContact.length,
                  (index) => CupertinoListTile(
                    leadingSize: 40,
                    leading: CircleAvatar(
                      backgroundColor:
                          CupertinoColors.activeBlue.withOpacity(0.4),
                      foregroundImage: provider.allContact[index].userImage ==
                              null
                          ? null
                          : FileImage(provider.allContact[index].userImage!),
                    ),
                    title: Text(provider.allContact[index].userName ?? 'Name'),
                    subtitle:
                        Text(provider.allContact[index].userMsg ?? 'No Msg'),
                    trailing: Text(
                        '${provider.allContact[index].userDate?.pickDate},${provider.allContact[index].userTime?.pickTime}'),
                  ),
                ),
              ),
      ),
      //all calls
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 100, 16, 0),
        child: provider.allContact.isEmpty
            ? const Center(
                child: Text(
                  'no any Calls yet...',
                ),
              )
            : CupertinoListSection(
                header: const Text('All Chats'),
                children: List.generate(
                  provider.allContact.length,
                  (index) => CupertinoListTile(
                    leadingSize: 40,
                    leading: CircleAvatar(
                      backgroundColor:
                          CupertinoColors.activeBlue.withOpacity(0.4),
                      foregroundImage: provider.allContact[index].userImage ==
                              null
                          ? null
                          : FileImage(provider.allContact[index].userImage!),
                    ),
                    title: Text(provider.allContact[index].userName ?? 'Name'),
                    subtitle:
                        Text(provider.allContact[index].userMsg ?? 'No Msg'),
                    trailing: CupertinoButton(
                      onPressed: () async {
                        Uri call = Uri(
                          scheme: 'tel',
                          path: nonprovider.allContact[index].userNumber,
                        );
                        await launchUrl(call);
                      },
                      child: const Icon(CupertinoIcons.phone),
                    ),
                  ),
                ),
              ),
      ),
      //profile
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 100, 16, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CupertinoListTile(
                leading: const Icon(
                  CupertinoIcons.profile_circled,
                ),
                title: const Text('Profile'),
                subtitle: const Text('Update Profile Data'),
                trailing: CupertinoSwitch(
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
                        radius: 80,
                        backgroundColor:
                            CupertinoColors.activeBlue.withOpacity(0.4),
                        foregroundImage: provider.image == null
                            ? null
                            : FileImage(provider.image!),
                        child: const Icon(CupertinoIcons.person_add),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: provider.name == null
                          ? Form(
                              key: form[3],
                              child: CupertinoTextFormFieldRow(
                                onSaved: (val) {
                                  provider.name = val;
                                },
                                placeholder: 'Enter Your name...',
                              ),
                            )
                          : Text(provider.name!),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: provider.bio == null
                          ? Form(
                              key: form[4],
                              child: CupertinoTextFormFieldRow(
                                onSaved: (val) {
                                  provider.bio = val;
                                },
                                placeholder: 'Enter Your Bio...',
                              ),
                            )
                          : Text(provider.bio!),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CupertinoButton(
                          onPressed: () {
                            form[3].currentState!.save();
                            form[4].currentState!.save();
                            setState(() {});
                          },
                          child: const Text(
                            'SAVE',
                          ),
                        ),
                        CupertinoButton(
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
              CupertinoListTile(
                leading: const Icon(
                  CupertinoIcons.sun_min_fill,
                ),
                title: const Text('Theme'),
                subtitle: const Text('Change Theme'),
                trailing: CupertinoSwitch(
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
      ),
    ];

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Add Contact',
            icon: Icon(CupertinoIcons.person_add),
          ),
          BottomNavigationBarItem(
            label: 'CHATS',
            icon: Icon(CupertinoIcons.chat_bubble_text),
          ),
          BottomNavigationBarItem(
            label: 'CALLS',
            icon: Icon(CupertinoIcons.phone),
          ),
          BottomNavigationBarItem(
            label: 'SETTING',
            icon: Icon(CupertinoIcons.settings),
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: const Text(
            'Platform Converter',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: CupertinoSwitch(
            value: Provider.of<PlatFormController>(context).isIos,
            onChanged: (val) {
              Provider.of<PlatFormController>(context, listen: false)
                  .ChangePlatForm();
            },
          ),
        ),
        child: allTabs[index],
      ),
      controller: cupertinoTabController,
    );
  }
}
