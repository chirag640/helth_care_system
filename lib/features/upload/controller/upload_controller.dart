import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Upload document data model
class UploadDocument {
  final String id;
  final String fileName;
  final String filePath;
  final String uploadType;
  final DateTime uploadedAt;

  UploadDocument({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.uploadType,
    required this.uploadedAt,
  });
}

/// Upload state
class UploadState {
  final List<UploadDocument> uploadedDocuments;
  final bool isLoading;
  final String? error;

  UploadState({
    this.uploadedDocuments = const [],
    this.isLoading = false,
    this.error,
  });

  UploadState copyWith({
    List<UploadDocument>? uploadedDocuments,
    bool? isLoading,
    String? error,
  }) {
    return UploadState(
      uploadedDocuments: uploadedDocuments ?? this.uploadedDocuments,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Upload controller
class UploadController extends StateNotifier<UploadState> {
  UploadController() : super(UploadState()) {
    _loadUploadedDocuments();
  }

  /// Load uploaded documents (dummy data)
  Future<void> _loadUploadedDocuments() async {
    state = state.copyWith(isLoading: true);

    await Future.delayed(const Duration(milliseconds: 500));

    final dummyDocuments = [
      UploadDocument(
        id: '1',
        fileName: 'Fiver and cold.pdf',
        filePath: 'assets/images/sample_document.png',
        uploadType: 'Prescription',
        uploadedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      UploadDocument(
        id: '2',
        fileName: 'Blood Test Report.pdf',
        filePath: 'assets/images/sample_document.png',
        uploadType: 'Lab Test',
        uploadedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    state = state.copyWith(
      uploadedDocuments: dummyDocuments,
      isLoading: false,
    );
  }

  /// Upload a new document
  Future<void> uploadDocument({
    required String fileName,
    required String filePath,
    required String uploadType,
  }) async {
    state = state.copyWith(isLoading: true);

    await Future.delayed(const Duration(seconds: 1));

    final newDocument = UploadDocument(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fileName: fileName,
      filePath: filePath,
      uploadType: uploadType,
      uploadedAt: DateTime.now(),
    );

    state = state.copyWith(
      uploadedDocuments: [newDocument, ...state.uploadedDocuments],
      isLoading: false,
    );
  }

  /// Delete a document
  Future<void> deleteDocument(String documentId) async {
    state = state.copyWith(isLoading: true);

    await Future.delayed(const Duration(milliseconds: 500));

    final updatedDocuments =
        state.uploadedDocuments.where((doc) => doc.id != documentId).toList();

    state = state.copyWith(
      uploadedDocuments: updatedDocuments,
      isLoading: false,
    );
  }

  /// Reload documents
  Future<void> refreshDocuments() async {
    await _loadUploadedDocuments();
  }
}

/// Upload controller provider
final uploadControllerProvider =
    StateNotifierProvider<UploadController, UploadState>((ref) {
  return UploadController();
});
