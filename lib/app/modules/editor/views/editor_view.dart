import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/editor_controller.dart';

class EditorView extends GetView<EditorController> {
  const EditorView({Key? key}) : super(key: key);

  static const Color primaryColor = Color(0xFFAD141A);
  static const Color neutral100 = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFCE8EB);
  static const Color textPrimary = Color(0xFF101B2B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: neutral100,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Certificate Editor',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: neutral100,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: neutral100,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Obx(() => controller.svgContent.isEmpty
                              ? const Center(child: CircularProgressIndicator())
                              : SvgPicture.string(
                                  controller.svgContent.value,
                                  fit: BoxFit.contain,
                                )),
                        ),
                      ),
                      Positioned(
                        bottom: 24,
                        left: 24,
                        child: Text(
                          'Deselect Area',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildToolButton(
                        icon: Icons.text_fields,
                        label: 'Text',
                        onTap: () {
                          // Show text editing dialog
                          _showTextEditDialog(context);
                        },
                      ),
                      _buildToolButton(
                        icon: Icons.delete_outline,
                        label: 'Delete',
                        onTap: () {
                          controller.deleteSelectedElement();
                        },
                      ),
                      _buildToolButton(
                        icon: Icons.undo,
                        label: 'Undo',
                        onTap: () {
                          // Implement undo functionality
                        },
                      ),
                      _buildToolButton(
                        icon: Icons.redo,
                        label: 'Redo',
                        onTap: () {
                          // Implement redo functionality
                        },
                      ),
                    ],
                  ),
                ),
                Obx(() => controller.selectedElement.value != null
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            TextField(
                              decoration: const InputDecoration(
                                labelText: 'Edit Text',
                                border: OutlineInputBorder(),
                              ),
                              controller: TextEditingController(
                                text: controller.currentText.value,
                              ),
                              onChanged: (value) {
                                controller.updateSelectedElementText(value);
                              },
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: primaryColor),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: textPrimary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTextEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Text'),
        content: TextField(
          decoration: const InputDecoration(
            labelText: 'Enter text',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            // Implement add new text functionality
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement add new text functionality
              Get.back();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
