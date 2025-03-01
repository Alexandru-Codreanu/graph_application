import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../controllers/graph_controller.dart';
import '../../controllers/operations.dart';
import 'simple_option_button.dart';
import 'options_holder.dart';

class FileInputOption extends StatefulWidget {
  final GraphController controller;

  const FileInputOption({
    super.key,
    required this.controller,
  });

  @override
  State<FileInputOption> createState() => _FileInputOptionState();
}

class _FileInputOptionState extends State<FileInputOption> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([widget.controller.fileNotifier, widget.controller.isLoadingNotifier]),
      builder: (context, child) => OptionsHolder(
        title: "Graph from file input",
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Column(
            children: [
              IgnorePointer(
                ignoring: widget.controller.isLoading,
                child: DropTarget(
                  enable: !widget.controller.isLoading,
                  onDragDone: (detail) {
                    widget.controller.file = detail.files.first;
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: MouseRegion(
                      cursor: widget.controller.isLoading ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            allowedExtensions: ['xml', 'json'],
                          );

                          if (result == null) {
                            return;
                          }

                          widget.controller.file = result.files.first.xFile;
                        },
                        child: Container(
                          height: 75,
                          width: 160,
                          color: widget.controller.isLoading ? Color.lerp(Colors.blueGrey, Colors.blue, 0.25) : Color.lerp(Colors.white, Colors.blue, 0.75),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(widget.controller.file == null ? Icons.file_upload : Icons.file_present),
                                Text(widget.controller.file == null ? "Drop file here" : widget.controller.file!.name),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SimpleOptionButton(
                icon: Icons.import_export_sharp,
                label: "Parse",
                onTap: widget.controller.file == null || widget.controller.isLoading
                    ? null
                    : () async {
                        widget.controller.isLoading = true;
                        if (widget.controller.file!.name.split('.').last == 'json') {
                          widget.controller.graph = await compute(
                            IsolateOperations.graphFromJson,
                            await compute(IsolateOperations.decodeJson, widget.controller.file!),
                          );
                          widget.controller.isLoading = false;
                          return;
                        }

                        if (widget.controller.file!.name.split('.').last == 'xml') {
                          widget.controller.graph = await compute(
                            IsolateOperations.graphFromJson,
                            await compute(IsolateOperations.convertXMLtoJson, widget.controller.file!),
                          );
                          widget.controller.isLoading = false;
                          return;
                        }
                      },
              ),
              Builder(
                builder: (context) {
                  if (widget.controller.file == null || widget.controller.isLoading) {
                    return const SimpleOptionButton(
                      icon: Icons.cancel_outlined,
                      label: "Remove File",
                    );
                  }

                  return SimpleOptionButton(
                    icon: Icons.cancel_outlined,
                    label: "Remove File",
                    onTap: () {
                      widget.controller.file = null;
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
