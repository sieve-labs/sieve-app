import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'dart:convert';
import '../models/gallery_section.dart';
import '../widgets/graph_paper_background.dart';
import '../widgets/animated_buttons.dart';
import '../widgets/image_shimmer.dart';
import '../theme/app_theme.dart';
import '../screens/full_screen_image_screen.dart';

class GalleryScreen extends ConsumerStatefulWidget {
  const GalleryScreen({super.key});

  @override
  ConsumerState<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen>
    with TickerProviderStateMixin {
  List<GallerySection> _sections = [];
  String? _selectedAlbumLabel;
  Set<String> _selectedAlbumLabels = {};
  Set<File> _selectedFiles = {};
  bool _isAlbumSelectionMode = false;
  bool _isSelectionMode = false;
  Map<String, Map<String, dynamic>> _metadata = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGallery();
  }

  Future<void> _loadGallery() async {
    setState(() => _isLoading = true);

    try {
      // Load gallery data (existing implementation)
      // ... existing _loadGallery logic ...
    } finally {
      setState(() => _isLoading = false);
    }
  }
