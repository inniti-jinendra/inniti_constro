import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Riverpod provider to hold the image file
final capturedImageProvider = StateProvider<File?>((ref) => null);
