import 'package:flutter/material.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'icon.dart' as icon;

class StorageManagement extends StatefulWidget implements Pluggable {
  final GetStorage? getStorage;
  final SharedPreferences? sharedPreferences;

  const StorageManagement({
    this.getStorage,
    this.sharedPreferences,
  });

  @override
  _StorageManagementState createState() => _StorageManagementState();

  @override
  Widget buildWidget(BuildContext? context) => this;

  @override
  ImageProvider<Object> get iconImageProvider => MemoryImage(icon.iconBytes);

  @override
  String get name => 'Storage management';

  @override
  String get displayName => 'Storage management';

  @override
  void onTrigger() {}
}

class _StorageManagementState extends State<StorageManagement> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: widget.getStorage != null
          ? _buildGetStorageData(widget.getStorage!)
          : widget.sharedPreferences != null
              ? _buildSharedPrefsData(widget.sharedPreferences!)
              : Text('No storage item'),
    );
  }

  _buildGetStorageData(GetStorage getStorage) {
    List<String> keys = getStorage.listenable.value.keys.toList();
    return ListView.separated(
      itemCount: keys.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GetStorageItem(valueKey: keys[index], getStorage: getStorage);
      },
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.black,
        );
      },
    );
  }

  _buildSharedPrefsData(SharedPreferences sharedPreferences) {
    Set<String> keys = sharedPreferences.getKeys();
    return ListView.separated(
      itemCount: keys.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SharedPrefsItem(
            valueKey: keys.elementAt(index), getStorage: sharedPreferences);
      },
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.black,
        );
      },
    );
  }
}

class GetStorageItem extends StatefulWidget {
  final GetStorage getStorage;
  final String valueKey;
  const GetStorageItem({
    key,
    required this.valueKey,
    required this.getStorage,
  });

  @override
  State<GetStorageItem> createState() => _GetStorageItemState();
}

class _GetStorageItemState extends State<GetStorageItem> {
  late TextEditingController textEditingController;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    var value = widget.getStorage.read(widget.valueKey)?.toString() ?? '';
    textEditingController = TextEditingController(text: value);
    super.initState();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.valueKey),
        SizedBox(width: 6),
        Flexible(
          child: TextField(
            controller: textEditingController,
            focusNode: focusNode,
            decoration: InputDecoration(
                border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            )),
          ),
        ),
        SizedBox(width: 6),
        InkWell(
          child: SizedBox(
            height: 30,
            width: 30,
            child: isLoading ? CircularProgressIndicator() : Icon(Icons.check),
          ),
          onTap: () async {
            focusNode.unfocus();
            if (widget.getStorage.read(widget.valueKey) !=
                textEditingController.text) {
              try {
                setState(() {
                  isLoading = true;
                });
                await widget.getStorage
                    .write(widget.valueKey, textEditingController.text);
                Fluttertoast.showToast(msg: 'Success');
              } catch (e) {
                Fluttertoast.showToast(msg: 'Error $e');
              } finally {
                setState(() {
                  isLoading = false;
                });
              }
            }
          },
        ),
      ],
    );
  }
}

class SharedPrefsItem extends StatefulWidget {
  final SharedPreferences getStorage;
  final String valueKey;
  const SharedPrefsItem({
    key,
    required this.valueKey,
    required this.getStorage,
  });

  @override
  State<SharedPrefsItem> createState() => _SharedPrefsItemState();
}

class _SharedPrefsItemState extends State<SharedPrefsItem> {
  late TextEditingController textEditingController;
  final FocusNode focusNode = FocusNode();

  bool isLoading = false;

  dynamic valueType;
  @override
  void initState() {
    valueType = widget.getStorage.get(widget.valueKey);
    textEditingController = TextEditingController(text: valueType.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.valueKey),
        SizedBox(width: 6),
        Flexible(
          child: TextField(
            controller: textEditingController,
            focusNode: focusNode,
            decoration: InputDecoration(
                border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            )),
          ),
        ),
        SizedBox(width: 6),
        InkWell(
          child: SizedBox(
            height: 30,
            width: 30,
            child: isLoading ? CircularProgressIndicator() : Icon(Icons.check),
          ),
          onTap: () async {
            focusNode.unfocus();
            if (widget.getStorage.get(widget.valueKey) !=
                textEditingController.text) {
              try {
                setState(() {
                  isLoading = true;
                });
                if (valueType is String) {
                  await widget.getStorage
                      .setString(widget.valueKey, textEditingController.text);
                } else if (valueType is bool) {
                  await widget.getStorage.setBool(
                      widget.valueKey, bool.parse(textEditingController.text));
                } else if (valueType is double) {
                  await widget.getStorage.setDouble(widget.valueKey,
                      double.parse(textEditingController.text));
                } else if (valueType is int) {
                  await widget.getStorage.setInt(
                      widget.valueKey, int.parse(textEditingController.text));
                }
                Fluttertoast.showToast(msg: 'Success');
              } catch (e) {
                Fluttertoast.showToast(msg: 'Error $e');
              } finally {
                setState(() {
                  isLoading = false;
                });
              }
            }
          },
        ),
      ],
    );
  }
}
