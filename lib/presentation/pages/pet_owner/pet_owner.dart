import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/presentation/pages/pet_owner/screens/complete_user_profile/complete_user_profile.dart';
import 'package:fyp_pawsenvy/presentation/pages/common/pets_screen.dart';
import 'package:fyp_pawsenvy/presentation/pages/pet_owner/screens/owner_reminders.dart';
import 'package:fyp_pawsenvy/presentation/pages/pet_owner/screens/community.dart';
import 'package:fyp_pawsenvy/presentation/widgets/common/expandable_fab.dart';
import 'package:fyp_pawsenvy/presentation/widgets/common/app_drawer.dart';
import 'package:fyp_pawsenvy/providers/user.provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class PetOwner extends StatefulWidget {
  const PetOwner({super.key});

  @override
  State<PetOwner> createState() => _PetOwnerState();
}

class _PetOwnerState extends State<PetOwner> {
  int _selectedScreen = 0;

  // TensorFlow Lite variables
  Interpreter? _interpreter;
  List<String>? _labels;

  final List<Widget> _screens = [
    OwnerDashboard(),
    OwnerReminders(),
    PetsScreen(),
  ];

  bool _isProfileComplete(AppUser user) {
    final defaultDob = Timestamp(0, 0).toDate();
    final isLocationSet =
        user.location.latitude != 0 || user.location.longitude != 0;

    return user.name.trim().isNotEmpty &&
        user.phone.trim().isNotEmpty &&
        user.avatar.trim().isNotEmpty &&
        user.bio.trim().isNotEmpty &&
        user.gender != Gender.undefined &&
        user.dob != defaultDob &&
        isLocationSet;
  }

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final appUser = userProvider.user;

        // Show loading if user data is not available yet
        if (appUser == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Check profile completeness in real-time
        if (!_isProfileComplete(appUser)) {
          return CompleteUserProfile(
            isProfileIncomplete: true,
            onProfileComplete: () {
              // The Consumer will automatically rebuild when UserProvider updates
            },
          );
        }

        return _buildPetOwnerInterface(context, appUser);
      },
    );
  }

  Widget _buildPetOwnerInterface(BuildContext context, AppUser user) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        drawer: const AppDrawer(),
        appBar: _appBar(context, user),
        body: _screens[_selectedScreen],
        floatingActionButton:
            _selectedScreen == 1
                ? ExpandableFab(
                  distance: 60,
                  children: [
                    ActionButton(
                      onPressed: () {},
                      icon: const Icon(LineIcons.calendar),
                      label: 'Add Booking',
                      backgroundColor: Colors.orange.shade200,
                      iconColor: AppColorStyles.black,
                    ),
                    ActionButton(
                      onPressed: () {},
                      icon: const Icon(LineIcons.bell),
                      label: 'Add Reminder',
                      backgroundColor: Colors.deepOrange.shade200,
                      iconColor: AppColorStyles.black,
                    ),
                  ],
                )
                : null,
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: _bottomNav(),
        ),
      ),
    );
  }

  GNav _bottomNav() {
    return GNav(
      gap: 6,
      backgroundColor: Colors.transparent,
      color: Colors.black,
      activeColor: Colors.black,
      iconSize: 22,
      tabBackgroundColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      selectedIndex: _selectedScreen,
      onTabChange: (index) {
        setState(() {
          _selectedScreen = index;
        });
      },
      textStyle: AppTextStyles.bodyExtraSmall,
      tabActiveBorder: Border.all(color: AppColorStyles.grey, width: 1),
      tabs: [
        const GButton(icon: LineIcons.users, text: 'Dashboard'),
        const GButton(icon: LineIcons.calendar, text: 'Calendar'),
        GButton(
          icon: Icons.person_outline,
          text: 'Your Pets',
          leading: const CircleAvatar(
            radius: 11,
            backgroundImage: AssetImage('assets/images/person1.png'),
          ),
        ),
      ],
    );
  }

  //  ##################################################################################################################################################

  AppBar _appBar(BuildContext context, AppUser user) {
    return AppBar(
      toolbarHeight: kToolbarHeight + 4,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      scrolledUnderElevation: 0,
      leadingWidth: 78,
      leading: Padding(
        padding: const EdgeInsets.only(left: 25),
        child: Builder(
          builder:
              (context) => InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColorStyles.deepPurple,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage:
                        user.avatar.isNotEmpty
                            ? NetworkImage(user.avatar)
                            : const AssetImage('assets/images/person1.png')
                                as ImageProvider,
                    backgroundColor: AppColorStyles.lightGrey,
                  ),
                ),
              ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: Row(
            children: [
              IconButton(
                onPressed: () => predictBreed(),
                icon: const Icon(LineIcons.camera, size: 26),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(LineIcons.bell, size: 26),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ############### Image picker
  final picker = ImagePicker();
  Future<XFile?> pickImageFromGallery() async {
    return await picker.pickImage(source: ImageSource.gallery);
  } // ############### Load model

  Future<void> loadModel() async {
    try {
      debugPrint("Starting to load TensorFlow Lite model...");

      // Load the TensorFlow Lite model
      _interpreter = await Interpreter.fromAsset(
        'assets/ai_modules/dog_breed_model.tflite',
      );
      debugPrint(
        "Model interpreter loaded successfully from: assets/ai_modules/dog_breed_model.tflite",
      );

      // Load labels
      debugPrint("Loading labels from: assets/ai_modules/labels.txt");
      final labelsData = await rootBundle.loadString(
        'assets/ai_modules/labels.txt',
      );
      _labels =
          labelsData.split('\n').where((label) => label.isNotEmpty).toList();
      debugPrint("Labels loaded successfully with ${_labels?.length} labels");

      debugPrint("Model setup complete!");
      if (_labels != null && _labels!.isNotEmpty) {
        debugPrint("First few labels: ${_labels?.take(5).join(', ')}");
      }
    } catch (e) {
      debugPrint("Error loading model: $e");
      debugPrint("Stack trace: ${StackTrace.current}");

      // Reset variables on error
      _interpreter = null;
      _labels = null;
    }
  }

  // ############### Preprocess image
  Float32List preprocessImage(String imagePath) {
    final imageFile = File(imagePath);
    final image = img.decodeImage(imageFile.readAsBytesSync())!;

    // Resize image to model input size (typically 224x224 for most models)
    final resized = img.copyResize(image, width: 224, height: 224);

    // Convert to Float32List and normalize
    final input = Float32List(1 * 224 * 224 * 3);
    int pixelIndex = 0;

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = resized.getPixel(x, y);
        input[pixelIndex++] = pixel.r / 255.0;
        input[pixelIndex++] = pixel.g / 255.0;
        input[pixelIndex++] = pixel.b / 255.0;
      }
    }

    return input; // <-- Return the Float32List directly
  }

  Future<Map<String, dynamic>?> classifyImage(String imagePath) async {
    if (_interpreter == null || _labels == null) {
      debugPrint("Model not loaded");
      return null;
    }

    try {
      // Input is now the correctly formatted Float32List
      final Float32List input = preprocessImage(imagePath);

      final outputTensor = _interpreter!.getOutputTensor(0);
      final outputShape = outputTensor.shape;
      final numClasses = outputShape.last;

      debugPrint("Model output shape: $outputShape");
      debugPrint("Number of classes from model: $numClasses");
      debugPrint("Number of labels loaded: ${_labels!.length}");

      final output = Float32List(numClasses).reshape([1, numClasses]);

      // Pass the input directly to the interpreter
      _interpreter!.run(input.reshape([1, 224, 224, 3]), output);

      debugPrint("Raw model output: ${output.first}");

      // Find the class with highest confidence
      double maxConfidence = -1;
      int maxIndex = -1;

      // We search in output.first because output shape is [1, 120]
      for (int i = 0; i < output.first.length; i++) {
        if (output.first[i] > maxConfidence) {
          maxConfidence = output.first[i];
          maxIndex = i;
        }
      }

      if (maxIndex == -1 || maxConfidence <= 0.0) {
        debugPrint("No confident prediction found.");
        return {'label': 'Unknown', 'confidence': 0.0};
      }

      if (maxIndex >= _labels!.length) {
        debugPrint(
          "Warning: Predicted class index ($maxIndex) exceeds available labels (${_labels!.length})",
        );
        return {
          'label': 'Unknown (index: $maxIndex)',
          'confidence': maxConfidence,
        };
      }

      return {'label': _labels![maxIndex], 'confidence': maxConfidence};
    } catch (e) {
      debugPrint("Error during classification: $e");
      return null;
    }
  }

  // ############### Finally predict breed
  void predictBreed() async {
    // Check if model is loaded, if not try to load it
    if (_interpreter == null || _labels == null) {
      debugPrint("Model not loaded, attempting to load...");
      await loadModel();

      // If still not loaded, show error
      if (_interpreter == null || _labels == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to load AI model. Please try again."),
            ),
          );
        }
        return;
      }
    }

    final image = await pickImageFromGallery();
    if (image == null) {
      debugPrint("Pick image failed");
      return;
    }

    final result = await classifyImage(image.path);
    if (result != null) {
      final breed = result['label'];
      final confidence = result['confidence'];

      debugPrint("Breed: $breed, Confidence: $confidence");

      // Update state and display in UI
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Breed: $breed, Confidence: ${(confidence * 100).toStringAsFixed(1)}%",
            ),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to classify image")),
        );
      }
    }
  }
}
