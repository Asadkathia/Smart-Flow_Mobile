import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import '../../data/models/ai_models.dart';
import '../providers/ai_provider.dart';
import '../widgets/ai_message_bubble.dart';

/// AI Assistant Screen
/// 
/// Displays AI assistant chat interface for the current visit.
/// Allows text and image-based questions with multi-language speech recognition.
class AiAssistantScreen extends ConsumerStatefulWidget {
  final String? visitId;

  const AiAssistantScreen({
    super.key,
    this.visitId,
  });

  @override
  ConsumerState<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends ConsumerState<AiAssistantScreen> {
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final imagePicker = ImagePicker();
  final speech = stt.SpeechToText();
  File? selectedImage;
  bool isListening = false;
  String recognizedText = '';
  
  // Language selection state
  List<stt.LocaleName>? availableLocales;
  String? selectedLocaleId;
  bool isLoadingLocales = false;

  String get visitId => widget.visitId ?? 'default-visit';

  @override
  void initState() {
    super.initState();
    _loadAvailableLocales();
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    speech.stop();
    super.dispose();
  }

  /// Load available speech recognition locales
  Future<void> _loadAvailableLocales() async {
    setState(() {
      isLoadingLocales = true;
    });

    try {
      final locales = await speech.locales();
      
      // Get device locale as default
      final deviceLocale = Platform.localeName; // e.g., "en_US"
      final deviceLangCode = deviceLocale.split('_')[0];

      // Find best match for device locale
      String? defaultLocale;
      for (final locale in locales) {
        if (locale.localeId == deviceLocale) {
          defaultLocale = locale.localeId;
          break;
        }
      }

      // If no exact match, try language code match
      if (defaultLocale == null) {
        for (final locale in locales) {
          if (locale.localeId.startsWith(deviceLangCode)) {
            defaultLocale = locale.localeId;
            break;
          }
        }
      }

      // Fallback to English (US)
      defaultLocale ??= locales.firstWhere(
        (locale) => locale.localeId.startsWith('en'),
        orElse: () => locales.first,
      ).localeId;

      setState(() {
        availableLocales = locales;
        selectedLocaleId = defaultLocale;
        isLoadingLocales = false;
      });
    } catch (e) {
      setState(() {
        isLoadingLocales = false;
        // Fallback to en_US if loading fails
        selectedLocaleId = 'en_US';
      });
    }
  }

  /// Get display name for locale
  String _getLocaleDisplayName(stt.LocaleName locale) {
    // Map common locale IDs to friendly names
    final localeMap = {
      'en_US': 'English (US)',
      'en_GB': 'English (UK)',
      'es_US': 'Spanish (US)',
      'es_ES': 'Spanish (Spain)',
      'es_MX': 'Spanish (Mexico)',
      'ru_RU': 'Russian',
      'uz_UZ': 'Uzbek',
      'zh_CN': 'Chinese (Simplified)',
      'zh_TW': 'Chinese (Traditional)',
      'ar_SA': 'Arabic',
      'vi_VN': 'Vietnamese',
      'ko_KR': 'Korean',
      'hi_IN': 'Hindi',
      'pt_BR': 'Portuguese (Brazil)',
      'pt_PT': 'Portuguese (Portugal)',
    };

    return localeMap[locale.localeId] ?? 
           '${locale.name} (${locale.localeId})';
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(aiChatProvider(visitId));
    final isLoading = ref.watch(aiLoadingProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.auto_awesome, color: AppColors.whiteColor, size: 24.sp),
            SizedBox(width: 8.w),
            Text(
              'AI Assistant',
              style: AppTextStyles.heading4.copyWith(color: AppColors.whiteColor),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryTextColor,
        elevation: 0,
        actions: [
          // Language Selector
          if (availableLocales != null && availableLocales!.isNotEmpty)
            PopupMenuButton<String>(
              icon: Icon(Icons.language, color: AppColors.whiteColor),
              tooltip: 'Select language for speech recognition',
              onSelected: (localeId) {
                setState(() {
                  selectedLocaleId = localeId;
                });
                // Show confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Speech recognition language set to: ${_getLocaleDisplayName(availableLocales!.firstWhere((l) => l.localeId == localeId))}',
                    ),
                    duration: const Duration(seconds: 2),
                    backgroundColor: AppColors.primaryColor,
                  ),
                );
              },
              itemBuilder: (context) {
                // Build menu items
                final items = <PopupMenuEntry<String>>[];
                
                // Add selected locale first (if exists)
                if (selectedLocaleId != null) {
                  final selected = availableLocales!.firstWhere(
                    (l) => l.localeId == selectedLocaleId,
                    orElse: () => availableLocales!.first,
                  );
                  items.add(
                    PopupMenuItem(
                      value: selected.localeId,
                      child: Row(
                        children: [
                          Icon(Icons.check, size: 20, color: AppColors.primaryColor),
                          SizedBox(width: 8.w),
                          Text(
                            _getLocaleDisplayName(selected),
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  items.add(const PopupMenuDivider());
                }

                // Add other locales
                for (final locale in availableLocales!) {
                  if (locale.localeId != selectedLocaleId) {
                    items.add(
                      PopupMenuItem(
                        value: locale.localeId,
                        child: Padding(
                          padding: EdgeInsets.only(left: 28.w),
                          child: Text(_getLocaleDisplayName(locale)),
                        ),
                      ),
                    );
                  }
                }

                return items;
              },
            ),
          IconButton(
            icon: Icon(Icons.refresh, color: AppColors.whiteColor),
            onPressed: () {
              ref.read(aiChatProvider(visitId).notifier).clearConversation();
            },
            tooltip: 'Clear conversation',
          ),
        ],
      ),
      body: Column(
        children: [
          // Info Banner
          Container(
            padding: EdgeInsets.all(12.w),
            color: AppColors.primaryColor.withOpacity(0.1),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20.sp,
                  color: AppColors.primaryColor,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'AI Assistant is here to help with your current visit',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 80.sp,
                          color: AppColors.greyColor,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Ask me anything!',
                          style: AppTextStyles.heading5.copyWith(
                            color: AppColors.primaryTextColor,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Text(
                            'I can help with troubleshooting, suggestions, and analyzing images',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.secondaryTextColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if (selectedLocaleId != null && availableLocales != null)
                          Padding(
                            padding: EdgeInsets.only(top: 16.h),
                            child: Text(
                              'Speech: ${_getLocaleDisplayName(availableLocales!.firstWhere((l) => l.localeId == selectedLocaleId))}',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.secondaryTextColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.all(16.w),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return AiMessageBubble(message: messages[index]);
                    },
                  ),
          ),

          // Selected Image Preview
          if (selectedImage != null)
            Container(
              padding: EdgeInsets.all(12.w),
              color: AppColors.lightGray,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.file(
                      selectedImage!,
                      width: 60.w,
                      height: 60.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Image selected',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: AppColors.errorRed),
                    onPressed: () {
                      setState(() {
                        selectedImage = null;
                      });
                    },
                  ),
                ],
              ),
            ),

          // Message Input
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkGrey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Image Picker Button
                  IconButton(
                    onPressed: _pickImage,
                    icon: Icon(
                      Icons.image,
                      color: AppColors.primaryColor,
                    ),
                    tooltip: 'Upload image',
                  ),
                  SizedBox(width: 8.w),
                  // Voice Input Button
                  IconButton(
                    onPressed: isListening ? _stopListening : _startListening,
                    icon: Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                      color: isListening ? AppColors.errorRed : AppColors.primaryColor,
                    ),
                    tooltip: isListening 
                        ? 'Stop recording' 
                        : 'Voice input (${selectedLocaleId != null && availableLocales != null ? _getLocaleDisplayName(availableLocales!.firstWhere((l) => l.localeId == selectedLocaleId)) : "Language"})',
                  ),
                  SizedBox(width: 8.w),
                  // Text Input
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryTextColor, // Dark text for readability
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ask me anything...',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.greyColor.withOpacity(0.6), // Lighter grey for hint
                        ),
                        filled: true,
                        fillColor: AppColors.whiteColor, // White background instead of lightGray
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.r),
                          borderSide: BorderSide(
                            color: AppColors.greyColor.withOpacity(0.3), // Subtle border
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.r),
                          borderSide: BorderSide(
                            color: AppColors.greyColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.r),
                          borderSide: BorderSide(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Send Button
                  isLoading
                      ? SizedBox(
                          width: 48.w,
                          height: 48.w,
                          child: Center(
                            child: SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        )
                      : IconButton(
                          onPressed: _sendMessage,
                          icon: Icon(
                            Icons.send,
                            color: AppColors.primaryColor,
                          ),
                          iconSize: 28.sp,
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<void> _startListening() async {
    // Check if locale is selected
    if (selectedLocaleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a language first'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    bool available = await speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() {
            isListening = false;
          });
        }
      },
      onError: (error) {
        setState(() {
          isListening = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Speech recognition error: ${error.errorMsg}'),
              backgroundColor: AppColors.errorRed,
            ),
          );
        }
      },
    );

    if (available) {
      setState(() {
        isListening = true;
      });
      speech.listen(
        onResult: (result) {
          setState(() {
            recognizedText = result.recognizedWords;
            messageController.text = result.recognizedWords;
          });
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        localeId: selectedLocaleId!, // ✅ Use selected locale
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Speech recognition not available'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  void _stopListening() {
    speech.stop();
    setState(() {
      isListening = false;
    });
  }

  Future<void> _sendMessage() async {
    final messageText = messageController.text.trim();
    if (messageText.isEmpty && selectedImage == null) return;

    // Clear input immediately
    messageController.clear();
    final imageToSend = selectedImage;
    setState(() {
      selectedImage = null;
    });

    // Set loading state
    ref.read(aiLoadingProvider.notifier).state = true;

    // Send message
    await ref.read(aiChatProvider(visitId).notifier).sendMessage(
      messageText.isEmpty ? 'Analyze this image' : messageText,
      image: imageToSend,
    );

    // Clear loading state
    ref.read(aiLoadingProvider.notifier).state = false;

    // Scroll to bottom
    if (scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }
}

