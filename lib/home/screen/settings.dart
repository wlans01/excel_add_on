import 'package:desktop_drop/desktop_drop.dart';
import 'package:excel_add_on/common/component/custom_textformfield.dart';
import 'package:excel_add_on/common/provider/validate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cross_file/cross_file.dart';
import '../../common/component/global_dialog.dart';
import '../../common/const/style.dart';
import '../../common/const/text.dart';
import '../provider/files_provider.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController _upController;
  late TextEditingController _downController;
  late TextEditingController _leftController;
  late TextEditingController _rightController;
  bool _dragging = false;

  Offset? offset;

  void validateAndCut({required bool isAdd}) async {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      if (isAdd) {
        try {
          ref.read(filesProvider.notifier).addAll(
                up: int.parse(_upController.text),
                down: int.parse(_downController.text),
                left: int.parse(_leftController.text),
                right: int.parse(_rightController.text),
              );
          GlobalDialog.errorDialog(
              subtitle: sponsor, title: '합치기 완료', context: context);
        } catch (e) {
          GlobalDialog.errorDialog(
              subtitle: e.toString(), context: context, title: '에러');
        }
      } else {
        try {
          ref.read(filesProvider.notifier).cutFirstFiled(
                up: int.parse(_upController.text),
                down: int.parse(_downController.text),
                left: int.parse(_leftController.text),
                right: int.parse(_rightController.text),
              );
        } catch (e) {
          GlobalDialog.errorDialog(
              subtitle: e.toString(), context: context, title: '에러');
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _upController = TextEditingController();
    _downController = TextEditingController();
    _leftController = TextEditingController();
    _rightController = TextEditingController();
  }

  @override
  void dispose() {
    _upController.dispose();
    _downController.dispose();
    _leftController.dispose();
    _rightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(filesProvider);
    return Row(
      children: [
        Stack(
          children: [
            Neumorphic(
              child: Container(
                  padding: const EdgeInsets.all(DEFAULT_PADDING),
                  width: 250,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "데이터 자르기",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: DEFAULT_PADDING),
                          Neumorphic(
                            style: NeumorphicStyle(depth: -4),
                            child: CustomTextFormField(
                              funValidator:
                                  ref.read(numValidateProvider).upValidate,
                              controller: _upController,
                              hintText: "Min Col : 0",
                            ),
                          ),
                          const SizedBox(
                            height: DEFAULT_PADDING,
                          ),
                          Neumorphic(
                            style: NeumorphicStyle(depth: -4),
                            child: CustomTextFormField(
                              funValidator:
                                  ref.read(numValidateProvider).downValidate,
                              controller: _downController,
                              hintText: 'Max Col : ${state.col}',
                            ),
                          ),
                          const SizedBox(
                            height: DEFAULT_PADDING,
                          ),
                          Neumorphic(
                            style: NeumorphicStyle(depth: -4),
                            child: CustomTextFormField(
                              funValidator:
                                  ref.read(numValidateProvider).upValidate,
                              controller: _leftController,
                              hintText: "Min Row : 0",
                            ),
                          ),
                          const SizedBox(
                            height: DEFAULT_PADDING,
                          ),
                          Neumorphic(
                            style: NeumorphicStyle(depth: -4),
                            child: CustomTextFormField(
                              funValidator:
                                  ref.read(numValidateProvider).rightValidate,
                              controller: _rightController,
                              hintText: ' Max Row : ${state.row}',
                            ),
                          ),
                          const SizedBox(
                            height: DEFAULT_PADDING,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              NeumorphicButton(
                                onPressed: () {
                                  setState(() {
                                    _upController.text = '0';
                                    _downController.text = '${state.col}';
                                    _leftController.text = '0';
                                    _rightController.text = '${state.row}';
                                  });
                                },
                                child: const Text('최댓값'),
                              ),
                              NeumorphicButton(
                                onPressed: () {
                                  setState(() {
                                    _upController.text = '';
                                    _downController.text = '';
                                    _leftController.text = '';
                                    _rightController.text = '';
                                  });
                                },
                                child: Text(
                                  '지우기',
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: DEFAULT_PADDING,
                          ),
                          NeumorphicButton(
                              onPressed: () {
                                validateAndCut(isAdd: false);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.cut_outlined),
                                  SizedBox(
                                    width: DEFAULT_PADDING,
                                  ),
                                  Text('자르기'),
                                ],
                              )),
                        ],
                      ),
                    ),
                  )),
            ),
            state.files.isEmpty
                ? Container(
                    width: 250,
                    height: double.infinity,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: Image.asset(
                          'assets/images/img.png',
                          fit: BoxFit.cover,
                        )),
                  )
                : Container()
          ],
        ),
        const SizedBox(
          width: DEFAULT_PADDING,
        ),
        DropTarget(
          onDragDone: (detail) async {
            ref.read(filesProvider.notifier).fileAdd(detail);
          },
          onDragUpdated: (details) {
            setState(() {
              offset = details.localPosition;
            });
          },
          onDragEntered: (detail) {
            setState(() {
              _dragging = true;
              offset = detail.localPosition;
            });
          },
          onDragExited: (detail) {
            setState(() {
              _dragging = false;
              offset = null;
            });
          },
          child: SizedBox(
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Neumorphic(
                  child: Container(
                    height: 100,
                    width: 300,
                    color: _dragging
                        ? Colors.blue.withOpacity(0.4)
                        : Colors.black26,
                    child: const Center(
                      child: Text(
                        "Drop files here",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: DEFAULT_PADDING,
                ),
                Expanded(
                  child: Neumorphic(
                    style: NeumorphicStyle(depth: -4),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: DEFAULT_PADDING),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Neumorphic(
                              child: SizedBox(
                                width: 150,
                                height: 45,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Files',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: DEFAULT_PADDING,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        ref
                                            .read(filesProvider.notifier)
                                            .removeAll();
                                      },
                                      icon: Icon(
                                        Icons.cancel_outlined,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ...state.files.map(buildFiles).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: DEFAULT_PADDING,
                ),
                NeumorphicButton(
                  onPressed: () {
                    validateAndCut(isAdd: true);

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.download),
                      SizedBox(
                        width: DEFAULT_PADDING,
                      ),
                      Text('합치기'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFiles(XFile file) => Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: DEFAULT_PADDING, vertical: 10),
        child: Neumorphic(
          child: ListTile(
            leading: const SizedBox(
              width: 60,
              child: Icon(
                Icons.text_snippet,
                size: 40,
                color: Colors.green,
              ),
            ),
            title: Text(file.path.split('\\').last),
            trailing: IconButton(
              onPressed: () {
                ref.read(filesProvider.notifier).fileRemove(file);
              },
              icon: Icon(
                Icons.cancel_outlined,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ),
      );
}
