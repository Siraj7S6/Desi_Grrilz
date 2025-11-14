import 'package:flutter/material.dart';

// --- 1. THEME AND STYLES ---

// A curated color palette based on the "Desi Grillz" logo's copper/bronze tones for a premium dark theme.
class AppColors {
  // Primary color: Warm bronze/copper
  static const Color primaryBronze = Color(0xFFC07A5E);
  // Accent color: Lighter shade for highlights
  static const Color accentLight = Color(0xFFF5E6CC);
  // Background color: Deep Charcoal for elegance
  static const Color backgroundDark = Color(0xFF1E1E1E);
  // Card/Surface color: Slightly lighter than background
  static const Color surfaceDark = Color(0xFF2C2C2C);
  // Text colors
  static const Color textLight = Colors.white;
  static const Color textMuted = Colors.white70;
}

// Custom text styles
class AppStyles {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryBronze,
  );
  static const TextStyle sectionHeaderStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
  );
  static const TextStyle itemTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textLight,
  );
  static const TextStyle itemPriceStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryBronze,
  );
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: AppColors.textMuted,
  );
}

// --- 2. MAIN APPLICATION SETUP ---

void main() {
  runApp(const DesiGrillzApp());
}

class DesiGrillzApp extends StatelessWidget {
  const DesiGrillzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Desi Grillz',
      theme: ThemeData(
        // Set the overall theme to dark
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        cardColor: AppColors.surfaceDark,
        primaryColor: AppColors.primaryBronze,
        // Define color scheme for Material 3 look
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryBronze,
          onPrimary: AppColors.backgroundDark,
          secondary: AppColors.accentLight,
          background: AppColors.backgroundDark,
          surface: AppColors.surfaceDark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundDark,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: AppColors.primaryBronze,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Style buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBronze,
            foregroundColor: AppColors.backgroundDark,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        // Style text inputs
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          labelStyle: AppStyles.bodyStyle.copyWith(color: AppColors.textMuted),
          hintStyle: AppStyles.bodyStyle.copyWith(color: Colors.grey),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

// --- 3. DATA MODELS & MOCK DATA ---

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
  });
}

final List<MenuItem> mockMenu = [
  MenuItem(id: '1', name: 'Mutton Seekh Kebab', description: 'Finely minced mutton skewers, charcoal grilled.', price: 18.99, category: 'Grillz'),
  MenuItem(id: '2', name: 'Chicken Boti', description: 'Tender chicken marinated overnight in secret spices.', price: 14.99, category: 'Grillz'),
  MenuItem(id: '3', name: 'Paneer Tikka', description: 'Smoked cottage cheese cubes with bell peppers.', price: 12.99, category: 'Vegetarian'),
  MenuItem(id: '4', name: 'Butter Naan', description: 'Traditional flatbread brushed with fresh butter.', price: 2.99, category: 'Breads'),
  MenuItem(id: '5', name: 'Biryani (Family)', description: 'Aromatic rice dish with marinated meat and saffron.', price: 25.99, category: 'Rice'),
  MenuItem(id: '6', name: 'Mango Lassi', description: 'Sweet yogurt drink blended with fresh mango pulp.', price: 5.99, category: 'Desserts'),
];

// --- 4. WIDGETS ---

// Menu Item Card Widget
class MenuItemCard extends StatelessWidget {
  final MenuItem item;
  const MenuItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.primaryBronze, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder for an image (optional)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.backgroundDark,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primaryBronze.withOpacity(0.5)),
              ),
              child: const Icon(Icons.restaurant_menu, color: AppColors.primaryBronze),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: AppStyles.itemTitleStyle),
                  const SizedBox(height: 4),
                  Text(item.description, style: AppStyles.bodyStyle),
                ],
              ),
            ),
            Text(
              '\$${item.price.toStringAsFixed(2)}',
              style: AppStyles.itemPriceStyle,
            ),
          ],
        ),
      ),
    );
  }
}

// --- 5. SCREENS ---

// Main Screen with Navigation
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    MenuScreen(),
    ReservationScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            label: 'Reserve',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryBronze,
        unselectedItemColor: AppColors.textMuted,
        backgroundColor: AppColors.surfaceDark,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// 5.1 Home Screen
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 250.0,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: const Text('Desi Grillz', style: TextStyle(color: AppColors.accentLight)),
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Background image placeholder
                Image.asset(
                  'assets/logo.png', // Using the logo as the main visual on the AppBar
                  fit: BoxFit.cover,
                  color: AppColors.backgroundDark.withOpacity(0.7),
                  colorBlendMode: BlendMode.darken,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback for when the asset isn't correctly added
                    return Container(
                      color: AppColors.surfaceDark,
                      child: Center(child: Text("Logo Placeholder", style: AppStyles.titleStyle.copyWith(fontSize: 20))),
                    );
                  },
                ),
                // Logo in the center for branding
                Center(
                  child: Image.asset(
                    'assets/logo.png',
                    height: 120,
                    width: 120,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Welcome to Desi Grillz', style: AppStyles.titleStyle),
                    SizedBox(height: 16),
                    Text(
                      'Experience the true flavor of charcoal-grilled, authentic South Asian cuisine. Our passion is the perfect kebab, marinated in traditional spices and cooked to smoky perfection. From our family to yours, welcome to a culinary journey.',
                      style: AppStyles.bodyStyle,
                    ),
                    SizedBox(height: 32),
                    // Contact Info
                    Text('Find Us', style: AppStyles.sectionHeaderStyle),
                    SizedBox(height: 12),
                    ContactInfoTile(icon: Icons.location_on, text: '123 Grill Street, Flavor City'),
                    ContactInfoTile(icon: Icons.phone, text: '+1 (555) 123-4567'),
                    ContactInfoTile(icon: Icons.access_time, text: 'Mon - Sun: 5:00 PM - 11:00 PM'),
                    SizedBox(height: 32),
                    // Call to Action
                    Center(
                      child: CallToActionButton(label: 'View Menu', targetIndex: 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Reusable contact tile for clean layout
class ContactInfoTile extends StatelessWidget {
  final IconData icon;
  final String text;
  const ContactInfoTile({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryBronze, size: 20),
          const SizedBox(width: 12),
          Text(text, style: AppStyles.bodyStyle.copyWith(color: AppColors.accentLight)),
        ],
      ),
    );
  }
}

// Reusable button to switch tabs
class CallToActionButton extends StatelessWidget {
  final String label;
  final int targetIndex;
  const CallToActionButton({super.key, required this.label, required this.targetIndex});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Find the parent MainScreen state and change the tab
        final parentState = context.findAncestorStateOfType<_MainScreenState>();
        if (parentState != null) {
          parentState._onItemTapped(targetIndex);
        }
      },
      child: Text(label),
    );
  }
}

// 5.2 Menu Screen
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Group menu items by category
    final Map<String, List<MenuItem>> groupedMenu = {};
    for (var item in mockMenu) {
      if (!groupedMenu.containsKey(item.category)) {
        groupedMenu[item.category] = [];
      }
      groupedMenu[item.category]!.add(item);
    }

    // Convert the map to a list of widgets (headers + item cards)
    final List<Widget> menuWidgets = [];
    groupedMenu.forEach((category, items) {
      menuWidgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
          child: Text(category, style: AppStyles.sectionHeaderStyle),
        ),
      );
      for (var item in items) {
        menuWidgets.add(MenuItemCard(item: item));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Menu'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: menuWidgets,
      ),
    );
  }
}

// 5.3 Reservation Screen
class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _guestsController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // Simple state for success message
  bool _reservationSuccess = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryBronze,
              onPrimary: AppColors.backgroundDark,
              surface: AppColors.surfaceDark,
              onSurface: AppColors.textLight,
            ),
            dialogBackgroundColor: AppColors.backgroundDark,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryBronze,
              onPrimary: AppColors.backgroundDark,
              surface: AppColors.surfaceDark,
              onSurface: AppColors.textLight,
            ),
            dialogBackgroundColor: AppColors.backgroundDark,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  void _submitReservation() {
    if (_formKey.currentState!.validate()) {
      // Logic to send reservation data (name, guests, date, time)
      
      // Simulate API call success
      setState(() {
        _reservationSuccess = true;
        _nameController.clear();
        _guestsController.clear();
        _timeController.clear();
        _dateController.clear();
      });

      // Hide success message after a few seconds
      Future.delayed(const Duration(seconds: 4), () {
        if(mounted) {
          setState(() {
            _reservationSuccess = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _guestsController.dispose();
    _timeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Table'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Make a Reservation',
                style: AppStyles.sectionHeaderStyle,
              ),
              const SizedBox(height: 16),
              if (_reservationSuccess)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 10),
                      Text('Reservation Confirmed! We look forward to seeing you.', style: AppStyles.bodyStyle),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person, color: AppColors.primaryBronze),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _guestsController,
                decoration: const InputDecoration(
                  labelText: 'Number of Guests',
                  prefixIcon: Icon(Icons.group, color: AppColors.primaryBronze),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid number of guests';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        prefixIcon: Icon(Icons.calendar_today, color: AppColors.primaryBronze),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Select a date';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _timeController,
                      readOnly: true,
                      onTap: () => _selectTime(context),
                      decoration: const InputDecoration(
                        labelText: 'Time',
                        prefixIcon: Icon(Icons.schedule, color: AppColors.primaryBronze),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Select a time';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitReservation,
                    child: const Text('Confirm Reservation'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}