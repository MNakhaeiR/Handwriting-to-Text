import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _apiKeyController = TextEditingController();
  bool _isDarkMode = false;
  String _selectedLanguage = 'fa';
  int _imageQuality = 85;
  int _maxImageSize = 1024;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _apiKeyController.text = prefs.getString('api_key') ?? '';
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
      _selectedLanguage = prefs.getString('language') ?? 'fa';
      _imageQuality = prefs.getInt('image_quality') ?? 85;
      _maxImageSize = prefs.getInt('max_image_size') ?? 1024;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_key', _apiKeyController.text);
    await prefs.setBool('dark_mode', _isDarkMode);
    await prefs.setString('language', _selectedLanguage);
    await prefs.setInt('image_quality', _imageQuality);
    await prefs.setInt('max_image_size', _maxImageSize);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تنظیمات ذخیره شد'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تنظیمات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // API Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'تنظیمات API',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _apiKeyController,
                    decoration: const InputDecoration(
                      labelText: 'کلید API OpenRouter',
                      hintText: 'sk-or-v1-...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.key),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'برای دریافت کلید API به openrouter.ai مراجعه کنید',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Image Processing Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'تنظیمات پردازش تصویر',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Image Quality
                  Row(
                    children: [
                      const Expanded(
                        child: Text('کیفیت تصویر:'),
                      ),
                      Text('$_imageQuality%'),
                    ],
                  ),
                  Slider(
                    value: _imageQuality.toDouble(),
                    min: 50,
                    max: 100,
                    divisions: 10,
                    onChanged: (value) {
                      setState(() {
                        _imageQuality = value.round();
                      });
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Max Image Size
                  Row(
                    children: [
                      const Expanded(
                        child: Text('حداکثر اندازه تصویر:'),
                      ),
                      Text('${_maxImageSize}px'),
                    ],
                  ),
                  Slider(
                    value: _maxImageSize.toDouble(),
                    min: 512,
                    max: 2048,
                    divisions: 6,
                    onChanged: (value) {
                      setState(() {
                        _maxImageSize = value.round();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // App Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'تنظیمات برنامه',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Dark Mode
                  SwitchListTile(
                    title: const Text('حالت تیره'),
                    subtitle: const Text('فعال‌سازی تم تیره'),
                    value: _isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value;
                      });
                    },
                  ),
                  
                  // Language Selection
                  ListTile(
                    title: const Text('زبان'),
                    subtitle: Text(_selectedLanguage == 'fa' ? 'فارسی' : 'English'),
                    trailing: DropdownButton<String>(
                      value: _selectedLanguage,
                      items: const [
                        DropdownMenuItem(
                          value: 'fa',
                          child: Text('فارسی'),
                        ),
                        DropdownMenuItem(
                          value: 'en',
                          child: Text('English'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedLanguage = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // About
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'درباره برنامه',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('نسخه: 1.0.0'),
                  const SizedBox(height: 8),
                  const Text('برنامه استخراج متن از دست‌نوشته فارسی'),
                  const SizedBox(height: 8),
                  const Text('با استفاده از هوش مصنوعی OpenRouter'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
