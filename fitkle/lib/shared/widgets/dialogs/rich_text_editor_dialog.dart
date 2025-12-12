import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/shared/widgets/buttons/app_icon_button.dart';

/// Opens a full-screen rich text editor dialog
Future<String?> showRichTextEditorDialog({
  required BuildContext context,
  required String title,
  String? initialText,
}) async {
  return await Navigator.of(context).push<String>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => RichTextEditorDialog(
        title: title,
        initialText: initialText,
      ),
    ),
  );
}

class RichTextEditorDialog extends StatefulWidget {
  final String title;
  final String? initialText;

  const RichTextEditorDialog({
    super.key,
    required this.title,
    this.initialText,
  });

  @override
  State<RichTextEditorDialog> createState() => _RichTextEditorDialogState();
}

class _RichTextEditorDialogState extends State<RichTextEditorDialog> {
  late QuillController _controller;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Initialize controller with existing text or empty document
    final doc = Document();
    if (widget.initialText != null && widget.initialText!.isNotEmpty) {
      doc.insert(0, widget.initialText!);
    }
    _controller = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _getPlainText() {
    return _controller.document.toPlainText().trim();
  }

  void _handleSave() {
    final text = _getPlainText();
    Navigator.of(context).pop(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppTheme.card,
        elevation: 0,
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.background,
            shape: BoxShape.circle,
          ),
          child: AppIconButton(
            icon: Icons.close,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: _handleSave,
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '완료',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Toolbar
          Container(
            decoration: BoxDecoration(
              color: AppTheme.card,
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.border.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: QuillToolbar.simple(
              controller: _controller,
              config: const QuillSimpleToolbarConfig(
                showBoldButton: true,
                showItalicButton: true,
                showUnderLineButton: true,
                showStrikeThrough: true,
                showListBullets: true,
                showListNumbers: true,
                showListCheck: true,
                showQuote: true,
                showIndent: true,
                showLink: true,
                showCodeBlock: false,
                showInlineCode: false,
                showColorButton: false,
                showBackgroundColorButton: false,
                showClearFormat: true,
                showHeaderStyle: true,
                multiRowsDisplay: false,
              ),
            ),
          ),

          // Editor
          Expanded(
            child: Container(
              color: AppTheme.background,
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.border.withValues(alpha: 0.5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: QuillEditor.basic(
                    controller: _controller,
                    focusNode: _focusNode,
                    config: const QuillEditorConfig(
                      placeholder: '이벤트에 대한 설명을 입력하세요...\n\n• 어떤 이벤트인지\n• 무엇을 할 예정인지\n• 참가자들에게 알려주고 싶은 내용',
                      autoFocus: true,
                      expands: false,
                      scrollable: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
