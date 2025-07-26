import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/services/db.service.dart';
import 'package:line_icons/line_icons.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/core/models/pet.dart';

// ignore: must_be_immutable
class PetProfileScreen extends StatefulWidget {
  const PetProfileScreen({super.key, required this.pet});
  final Pet pet;

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  final DBService _db = DBService();
  bool isLiked = false;

  Future<void> handlePetLike(BuildContext context) async {
    if (isLiked) {
      await _db.removePetFromUserDoc(
        widget.pet.ownerId,
        'likedPets',
        widget.pet.pID!,
      );

      setState(() {
        isLiked = false;
      });
    } else {
      await _db.savePetToUserDoc(
        widget.pet.ownerId,
        'likedPets',
        widget.pet.pID!,
      );

      setState(() {
        isLiked = true;
      });
    }
  }

  Future<bool> checkIfLiked(BuildContext context) async {
    isLiked = await _db.checkIfUserHasPet(
      widget.pet.ownerId,
      widget.pet.pID!,
      'likedPets',
    );

    debugPrint(isLiked ? 'Pet liked' : 'pet un-liked');

    return isLiked;
  }

  @override
  void initState() {
    super.initState();
    checkIfLiked(context).then((liked) {
      setState(() {
        isLiked = liked;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          // Main content with scroll
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 240,
                decoration: BoxDecoration(
                  gradient: AppColorStyles.profileGradient,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: SafeArea(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              widget.pet.avatar.isNotEmpty
                                  ? NetworkImage(widget.pet.avatar)
                                  : AssetImage(
                                        widget.pet.species == PetSpecies.dog
                                            ? 'assets/images/dog.png'
                                            : widget.pet.species ==
                                                PetSpecies.cat
                                            ? 'assets/images/cat.png'
                                            : 'assets/images/placeholder.png',
                                      )
                                      as ImageProvider,
                        ),
                      ),
                      // Top bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                LineIcons.arrowLeft,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            IconButton(
                              icon: Icon(
                                LineIcons.verticalEllipsis,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: const Icon(
                                              LineIcons.heartbeat,
                                            ),
                                            title: const Text(
                                              'Mark for adoption',
                                            ),
                                            onTap: () async {
                                              Navigator.pop(context);

                                              await _db.updatePetFields(
                                                context,
                                                widget.pet.pID!,
                                                {
                                                  'status':
                                                      widget.pet.status ==
                                                              PetStatus.normal
                                                          ? 'adopted'
                                                          : 'normal',
                                                },
                                              );

                                              debugPrint(
                                                'Pet adoption triggered',
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                              LineIcons.search,
                                            ),
                                            title: const Text('Mark as Lost'),
                                            onTap: () async {
                                              Navigator.pop(context);

                                              await _db.updatePetFields(
                                                context,
                                                widget.pet.pID!,
                                                {
                                                  'status':
                                                      widget.pet.status ==
                                                              PetStatus.normal
                                                          ? 'lost'
                                                          : 'normal',
                                                },
                                              );

                                              debugPrint(
                                                'Mark as lost triggered',
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ############# Details (scrollable)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name, species, gender
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.pet.name.isNotEmpty
                                      ? widget.pet.name
                                      : 'No name given :(',
                                  style: AppTextStyles.headingMedium,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      widget.pet.species == PetSpecies.dog
                                          ? LineIcons.dog
                                          : LineIcons.cat,
                                      size: 18,
                                      color: AppColorStyles.deepPurple,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      _capitalizeFirst(widget.pet.species.name),
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColorStyles.deepPurple,
                                      ),
                                    ),
                                    const Text(' • '),
                                    Icon(
                                      widget.pet.gender.toLowerCase() == 'male'
                                          ? LineIcons.mars
                                          : widget.pet.gender.toLowerCase() ==
                                              'female'
                                          ? LineIcons.venus
                                          : LineIcons.tag,
                                      size: 18,
                                      color:
                                          widget.pet.gender.toLowerCase() ==
                                                  'male'
                                              ? Colors.blue
                                              : widget.pet.gender
                                                      .toLowerCase() ==
                                                  'female'
                                              ? Colors.pink
                                              : AppColorStyles.deepPurple,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      _capitalizeFirst(widget.pet.gender),
                                      style: AppTextStyles.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => handlePetLike(context),
                            icon: Icon(
                              isLiked ? LineIcons.heartAlt : LineIcons.heart,
                              color: isLiked ? AppColorStyles.red : null,
                            ),
                            iconSize: 28,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Attributes section: weight, color, age, breed
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildAttributeItem(
                              context,
                              LineIcons.weight,
                              '${widget.pet.weight}kg',
                            ),
                            _buildAttributeItem(
                              context,
                              LineIcons.palette,
                              _capitalizeFirst(widget.pet.color),
                            ),
                            _buildAttributeItem(
                              context,
                              LineIcons.calendar,
                              '${widget.pet.age} yrs',
                            ),
                            _buildAttributeItem(
                              context,
                              LineIcons.dna,
                              _capitalizeFirst(widget.pet.breed),
                            ),
                          ],
                        ),
                      ),
                      if (widget.pet.temperament.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        // Temperament
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children:
                              widget.pet.temperament
                                  .map(
                                    (temp) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primaryContainer,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        _capitalizeFirst(temp.name),
                                        style: AppTextStyles.bodyExtraSmall
                                            .copyWith(
                                              color:
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer,
                                            ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Text(
                        'About ${widget.pet.name}',
                        style: AppTextStyles.headingSmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.pet.bio.isNotEmpty
                            ? widget.pet.bio
                            : 'No bio available for ${widget.pet.name}',
                        style: AppTextStyles.bodyBase,
                      ),
                      const SizedBox(height: 16),

                      // Temperament section
                      const SizedBox(height: 80), // Space for button
                    ],
                  ),
                ),
              ),
            ],
          ), // Sticky Adopt button
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColorStyles.purple,
                // gradient: AppColorStyles.profileGradient,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColorStyles.lightPurple),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () {},
                child: Text(
                  'Adopt this pet',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColorStyles.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributeItem(
    BuildContext context,
    IconData icon,
    String label,
  ) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
