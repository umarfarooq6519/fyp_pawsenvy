import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:fyp_pawsenvy/core/models/pet.dart';
import 'package:fyp_pawsenvy/core/router/routes.dart';
import 'package:fyp_pawsenvy/core/services/db.service.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/presentation/widgets/profiles/pet/pet_profile_medium.dart';
import 'package:fyp_pawsenvy/providers/user.provider.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';

class PetPartnerFinder extends StatefulWidget {
  const PetPartnerFinder({super.key});

  @override
  State<PetPartnerFinder> createState() => _PetPartnerFinderState();
}

class _PetPartnerFinderState extends State<PetPartnerFinder> {
  late DBService _db;
  late AppUser? _appUser;

  // Step management
  int currentStep = 0;
  Pet? selectedPet;
  final PageController _pageController = PageController();

  // Step titles
  static const List<String> stepTitles = ['Choose Pet', 'Find Partners'];

  late List<String> petIDs;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _db = Provider.of<DBService>(context, listen: false);
    _appUser = context.watch<UserProvider>().user;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectPet(Pet pet) {
    setState(() {
      selectedPet = pet;
    });
    _goToNextStep();
  }

  void _goToNextStep() {
    if (currentStep < stepTitles.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousStep() {
    if (currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    petIDs = _appUser?.ownedPets ?? [];

    return Scaffold(
      appBar: AppBar(
        leading:
            currentStep > 0
                ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _goToPreviousStep,
                )
                : null,
      ),
      body: Column(
        children: [
          // Step indicator
          _buildStepIndicator(),

          // Page content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  currentStep = index;
                });
              },
              children: [_buildChoosePetStep(), _buildPotentialPartnersStep()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: FlutterStepIndicator(
        height: 28,
        list: stepTitles,
        onChange: (int index) {
          if (index < currentStep) {
            // Allow going back to previous steps
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        page: currentStep,
        positiveColor: AppColorStyles.deepPurple,
        negativeColor: AppColorStyles.lightGrey,
        progressColor: AppColorStyles.deepPurple,
        positiveCheck: const Icon(Icons.check, color: Colors.white, size: 16),
        division: 2,
      ),
    );
  }

  Widget _buildChoosePetStep() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 20),
          child: Column(
            children: [
              Text(
                'Choose Your Pet to Begin\nPartner Search',
                style: AppTextStyles.headingMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        StreamBuilder<List<Pet>>(
          stream: _db.getPetsStreamByIDs(petIDs),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No pets found'));
            }

            final pets = snapshot.data!;
            return Column(
              children: [
                SizedBox(
                  height: 420,
                  child: Swiper(
                    loop: pets.length < 2 ? false : true,
                    itemBuilder: (BuildContext context, int index) {
                      final Pet pet = pets[index];
                      return GestureDetector(
                        onTap: () => _selectPet(pet),
                        child: PetProfileMedium(pet: pet),
                      );
                    },
                    itemCount: pets.length,
                    viewportFraction: 0.77,
                    scale: 0.9,
                    layout: SwiperLayout.DEFAULT,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildPotentialPartnersStep() {
    if (selectedPet == null) {
      return const Center(child: Text('No pet selected'));
    }

    final searchSpecies =
        selectedPet!.species == PetSpecies.dog
            ? PetSpecies.dog.name
            : PetSpecies.cat.name;
    final searchGender = selectedPet!.gender == 'male' ? 'female' : 'male';

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 20),
          child: Column(
            children: [
              Text('Potential Partners', style: AppTextStyles.headingLarge),
              const SizedBox(height: 3),
              Text(
                'Data based on species and gender',
                style: AppTextStyles.headingSmall.copyWith(
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        StreamBuilder<List<Pet>>(
          stream: _db.getPartnerFinderListing(
            species: searchSpecies,
            gender: searchGender,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No pets found 💔'));
            }

            final pets = snapshot.data!;
            return Column(
              children: [
                SizedBox(
                  height: 420,
                  child: Swiper(
                    loop: pets.length < 2 ? false : true,
                    itemBuilder: (BuildContext context, int index) {
                      final Pet pet = pets[index];
                      return GestureDetector(
                        onTap:
                            () => context.push(Routes.petProfile, extra: pet),
                        child: PetProfileMedium(pet: pet),
                      );
                    },
                    itemCount: pets.length,
                    viewportFraction: 0.77,
                    scale: 0.9,
                    layout: SwiperLayout.DEFAULT,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
