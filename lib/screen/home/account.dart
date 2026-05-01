import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantify/main.dart';
import 'package:plantify/screen/account/accessibility.dart';
import 'package:plantify/screen/account/appearance.dart';
import 'package:plantify/screen/authentication/get_started.dart';
import 'package:plantify/storage/preferences.dart';
import 'package:plantify/util/image.dart';
import 'package:plantify/util/layout.dart';
import 'package:plantify/util/miscellaneous.dart';
import 'package:plantify/util/navigation.dart';
import 'package:plantify/util/snackbar.dart';
import 'package:plantify/util/text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../backend/firestore/firestore.dart';
import '../../theme/colors.dart';
import '../../theme/fonts.dart';
import '../../util/container.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Map<String, dynamic> _userData = {};
  bool _isUploadingPhoto = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await loadPreferencesOnMap('userData', {});
    setState(() => _userData = user);
  }

  // ── Profile Picture ─────────────────────────────────────────────────────────
  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 88,
    );
    return File(result!.path);
  }

  Future<void> _pickAndUploadPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked == null) return;

    setState(() => _isUploadingPhoto = true);

    try {
      final file = File(picked.path);
      final uuid = _userData['uuid'] as String? ?? '';
      final fileName = 'profile_$uuid';
      final supabase = Supabase.instance.client;

      // Upload to Supabase Storage (bucket: 'profiles')
      await supabase.storage
          .from('profiles')
          .upload(
            fileName,
            file,
            fileOptions: const FileOptions(upsert: true), // overwrite existing
          );

      // Get the public URL
      final publicUrl = supabase.storage
          .from('profiles')
          .getPublicUrl(fileName);

      // Update userData locally + SharedPreferences + Firestore
      _userData['profile_url'] = publicUrl;
      await savePreferencesOnMap('userData', _userData);
      _updateFirestore(_userData);

      setState(() {});
      _showSnackBar("Profile photo updated!");
    } catch (e) {
      debugPrint("Upload error: $e");
      _showSnackBar("Failed to upload photo.");
    } finally {
      setState(() => _isUploadingPhoto = false);
    }
  }

  void _updateFirestore(Map<String, dynamic> userData) {
    FirestoreService().updateWhere(
      collection: 'users',
      field: 'uuid',
      isEqualTo: userData['uuid'],
      newData: userData,
    );
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    // Add https:// if the scheme is missing
    String formattedUrl = url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      formattedUrl = 'https://$url';
    }

    final uri = Uri.parse(formattedUrl);

    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        // Handle failure (e.g., show a snackbar)
      }
    } catch (e) {
      // Handle the PlatformException gracefully
      debugPrint('Could not launch $formattedUrl: $e');
    }
  }

  void _openEditUsername() {
    final controller = TextEditingController(
      text: _userData['username'] as String? ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final bottomPad = MediaQuery.of(context).viewInsets.bottom;
        return Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomPad),
          decoration: BoxDecoration(
            color: colorAccent.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: UtilFlexBox(
            direction: Axis.vertical,
            gap: 16,
            children: [
              // Handle
              Center(
                child: UtilContainer(
                  width: 44,
                  height: 4,
                  borderRadius: BorderRadius.circular(100),
                  color: colorAccent.secondaryText,
                ),
              ),
              UtilText(
                "Edit Username",
                size: 28,
                family: Fonts.defaultFontSemiBold,
                color: colorAccent.primaryText,
              ),
              // Input
              Container(
                decoration: BoxDecoration(
                  color: colorAccent.cardLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                child: TextField(
                  controller: controller,
                  autofocus: true,
                  style: TextStyle(
                    fontFamily: Fonts.defaultFontRegular.fontFamily,
                    fontSize: 16,
                    color: colorAccent.primaryText,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter new username",
                    hintStyle: TextStyle(
                      fontFamily: Fonts.defaultFontExtraLight.fontFamily,
                      fontSize: 15,
                      color: colorAccent.secondaryText,
                    ),
                  ),
                ),
              ),
              // Save button
              UtilContainer(
                onTap: () async {
                  final newName = controller.text.trim();
                  if (newName.isEmpty) return;
                  Navigator.pop(context);
                  await _saveUsername(newName);
                },
                width: double.maxFinite,
                height: 56,
                borderRadius: BorderRadius.circular(100),
                color: colorAccent.secondary,
                alignment: Alignment.center,
                child: UtilText(
                  "Save",
                  family: Fonts.defaultFontRegular,
                  size: 16,
                  color: colorAccent.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveUsername(String newName) async {
    _userData['username'] = newName;
    await savePreferencesOnMap('userData', _userData);
    _updateFirestore(_userData);
    setState(() {});
    _showSnackBar("Username updated!");
  }

  void _showSnackBar(String message) {
    showUtilSnackBar(
      context,
      duration: 2000,
      animationDuration: 200,
      color: colorAccent.cardDark,
      boxShadow: [
        BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.3), blurRadius: 5),
      ],
      width: 300,
      content: UtilText(
        message,
        align: TextAlign.center,
        family: Fonts.defaultFontRegular,
        color: colorAccent.primaryText,
        size: 15,
      ),
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final String username = _userData['username'] as String? ?? '';
    final String email = _userData['email'] as String? ?? '';
    final String profileUrl = _userData['profile_url'] as String? ?? '';

    // Determine if we have a real uploaded URL or still the default placeholder
    final bool hasNetworkPhoto =
        profileUrl.startsWith('http') || profileUrl.startsWith('https');
    utilDebugPrint(hasNetworkPhoto);
    return SingleChildScrollView(
      child: UtilFlexBox(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        gap: 10,
        children: [
          // ── Account Header ───────────────────────────────────────────────
          UtilFlexBox(
            cross: CrossAxisAlignment.center,
            direction: Axis.horizontal,
            width: double.maxFinite,
            gap: 10,
            height: 100,
            children: [
              // Profile picture — tappable
              UtilContainer(
                onTap: _isUploadingPhoto ? null : _pickAndUploadPhoto,
                width: 80,
                height: 80,
                borderRadius: BorderRadius.circular(500),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Photo — network if uploaded, asset fallback otherwise
                    hasNetworkPhoto
                        ? Image.network(
                            profileUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => UtilFitImage(
                              'assets/images/misc/profile_sample.jpeg',
                              fit: BoxFit.cover,
                            ),
                          )
                        : UtilFitImage(
                            'assets/images/misc/profile_sample.jpeg',
                            fit: BoxFit.cover,
                          ),

                    // Loading overlay
                    if (_isUploadingPhoto)
                      Container(
                        color: colorAccent.secondary,
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: colorAccent.white,
                          ),
                        ),
                      ),

                    // Camera icon overlay (only when not uploading)
                    // if (!_isUploadingPhoto)
                    //   Positioned(
                    //     bottom: 0,
                    //     left: 0,
                    //     right: 0,
                    //     child: Container(
                    //       height: 26,
                    //       color: Colors.black,
                    //       alignment: Alignment.center,
                    //       child: Icon(
                    //         Icons.camera_alt_rounded,
                    //         color: colorAccent.white,
                    //         size: 15,
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
              ),

              // Username + email
              Expanded(
                child: UtilFlexBox(
                  onTap: _openEditUsername,
                  direction: Axis.vertical,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  gap: 2,
                  children: [
                    UtilText(
                      username,
                      family: Fonts.defaultFontSemiBold,
                      color: colorAccent.primaryText,
                      size: 28,
                    ),
                    UtilText(
                      email,
                      family: Fonts.defaultFontThin,
                      color: colorAccent.secondaryText,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── Settings List ────────────────────────────────────────────────
          UtilFlexBox(
            margin: EdgeInsets.symmetric(vertical: 10),
            direction: Axis.vertical,
            gap: 10,
            children: [
              SettingList(
                icon: Icons.color_lens_outlined,
                name: 'Appearance & Personalization',
                onTap: () => navigateTo(
                  context,
                  animationType: NavAnimation.slideLeft,
                  duration: preferredAnimations.getDuration(),
                  page: AppearanceScreen(),
                ),
              ),
              SettingList(
                icon: Icons.accessibility_new_outlined,
                name: 'Ease & Accessibility',
                onTap: () => navigateTo(
                  context,
                  animationType: NavAnimation.slideLeft,
                  duration: preferredAnimations.getDuration(),
                  page: AccessibilityScreen(),
                ),
              ),
              SettingList(
                icon: Icons.help_outline_rounded,
                name: 'Help & Support',
                onTap: () {
                  _launchUrl(
                    context,
                    'https://plantifyappwebsupport.netlify.app/help',
                  );
                },
              ),
              SettingList(
                icon: Icons.logout,
                name: 'Logout',
                color: colorAccent.error,
                onTap: () {
                  deletePreferences('userData');
                  savePreferencesOnBool('isLogin', false);
                  navigateTo(
                    context,
                    animationType: NavAnimation.slideLeft,
                    duration: preferredAnimations.getDuration(),
                    page: GetStartedScreen(),
                    replace: true,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SettingList — unchanged from your original
// ─────────────────────────────────────────────────────────────────────────────

class SettingList extends StatelessWidget {
  const SettingList({
    super.key,
    required this.icon,
    required this.name,
    this.color,
    this.onTap,
  });

  final String name;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return UtilFlexBox(
      direction: Axis.horizontal,
      onTap: onTap,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      gap: 10,
      cross: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 30, color: color ?? colorAccent.primaryText),
        Expanded(
          child: UtilText(
            name,
            size: 20,
            family: Fonts.defaultFontRegular,
            color: color ?? colorAccent.primaryText,
          ),
        ),
      ],
    );
  }
}
