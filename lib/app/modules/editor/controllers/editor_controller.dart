import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:xml/xml.dart';
import 'package:path_provider/path_provider.dart';

class EditorController extends GetxController {
  final svgContent = ''.obs;
  final selectedElement = Rxn<XmlElement>();
  final elements = <XmlElement>[].obs;
  String? tempFilePath;

  // Track editing state
  final isEditing = false.obs;
  final currentText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadSvgFile();
  }

  Future<void> loadSvgFile() async {
    try {
      final String svgPath = Get.arguments as String;
      final bytes = await rootBundle.load(svgPath);
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_certificate.svg');
      await tempFile.writeAsBytes(bytes.buffer.asUint8List());
      tempFilePath = tempFile.path;

      final String content = await tempFile.readAsString();
      svgContent.value = content;

      // Parse SVG and extract text elements
      final document = XmlDocument.parse(content);
      elements.value = document.findAllElements('text').toList();
    } catch (e) {
      print('Error loading SVG: $e');
      Get.snackbar(
        'Error',
        'Failed to load certificate template: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void selectElement(XmlElement? element) {
    selectedElement.value = element;
    if (element != null) {
      final tspans = element.findElements('tspan');
      currentText.value = tspans.isNotEmpty ? tspans.first.text : element.text;
    } else {
      currentText.value = '';
    }
  }

  Future<void> deleteSelectedElement() async {
    if (selectedElement.value == null) return;

    try {
      final document = XmlDocument.parse(svgContent.value);
      final elementToDelete = document.findAllElements('text').firstWhere(
            (element) => element.toString() == selectedElement.value.toString(),
          );

      elementToDelete.remove();

      // Update SVG content and elements list
      final newContent = document.toXmlString(pretty: true);
      svgContent.value = newContent;
      elements.value = document.findAllElements('text').toList();

      // Save changes to temporary file
      await File(tempFilePath!).writeAsString(newContent);

      // Clear selection
      selectElement(null);
    } catch (e) {
      print('Error deleting element: $e');
      Get.snackbar(
        'Error',
        'Failed to delete element: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateSelectedElementText(String newText) async {
    if (selectedElement.value == null) return;

    try {
      final document = XmlDocument.parse(svgContent.value);
      final elementToUpdate = document.findAllElements('text').firstWhere(
            (element) => element.toString() == selectedElement.value.toString(),
          );

      final tspans = elementToUpdate.findElements('tspan');
      if (tspans.isNotEmpty) {
        for (var tspan in tspans) {
          tspan.children.clear();
          tspan.children.add(XmlText(newText));
        }
      } else {
        elementToUpdate.children.clear();
        elementToUpdate.children.add(XmlText(newText));
      }

      // Update SVG content and elements list
      final newContent = document.toXmlString(pretty: true);
      svgContent.value = newContent;
      elements.value = document.findAllElements('text').toList();

      // Save changes to temporary file
      await File(tempFilePath!).writeAsString(newContent);

      // Update current text
      currentText.value = newText;
    } catch (e) {
      print('Error updating text: $e');
      Get.snackbar(
        'Error',
        'Failed to update text: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void startEditing() {
    isEditing.value = true;
  }

  void stopEditing() {
    isEditing.value = false;
  }

  @override
  void onClose() {
    if (tempFilePath != null) {
      File(tempFilePath!)
          .delete()
          .catchError((e) => print('Error deleting temp file: $e'));
    }
    super.onClose();
  }
}
