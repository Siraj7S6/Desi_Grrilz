import 'package:flutter/material.dart';
// FIX: Added 'hide Card' to prevent name conflict with the Flutter Material Card widget.
import 'package:flutter_stripe/flutter_stripe.dart' hide Card; 

// --- ASSET PATHS (Using exact casing from pubspec.yaml) ---
const String RESTAURANT_ASSET_PATH = 'assets/restaurent.JPG';
const String LOGO_ASSET_PATH = 'assets/logo.png';

// --- NETWORK IMAGE URLS FOR MENU ITEMS (to maintain stability) ---
const String RESERVATION_AMBIANCE_URL = "https://images.unsplash.com/photo-1551632759-e93540a5a679?fit=crop&w=1080&q=80"; 
const String MUTTON_SEEKH_KEBAB_URL = "https://picsum.photos/id/292/300"; 
const String CHICKEN_BOTI_URL = "https://picsum.photos/id/351/300";   
const String PANEER_TIKKA_URL = "https://picsum.photos/id/1080/300";  
const String BUTTER_NAAN_URL = "https://picsum.photos/id/21/300";     
const String BIRYANI_URL = "https://picsum.photos/id/164/300";      
const String MANGO_LASSI_URL = "https://picsum.photos/id/257/300";    

// --- CONTACT INFORMATION ---
const String RESTAURANT_EMAIL = 'reservations@desigrillz.com'; 

// --- STRIPE CONFIGURATION ---
// FIX: Using the real Publishable Key provided by the user.
const String STRIPE_PUBLISHABLE_KEY = 'pk_test_51SNYEW3UngT9uUArcsWOMklUfH1Wuwo6Vv4XAIltdP5ngYlu753vd92C0Z3L9AN4FDHcMf8vCK5si40ejTbHyNCD003KpbBB0j'; 

// --- 1. THEME AND STYLES ---

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

// --- 2. MAIN APPLICATION SETUP (FIX APPLIED HERE) ---

void main() {
  // Ensure Flutter binding is initialized first
  WidgetsFlutterBinding.ensureInitialized();
  
  // FIX: Wrap Stripe initialization in a try-catch block.
  try {
    Stripe.publishableKey = STRIPE_PUBLISHABLE_KEY;
    Stripe.merchantIdentifier = 'merchant.com.desigrillz'; // Required for Apple Pay
    Stripe.urlScheme = 'flutterstripe'; // Required for 3D Secure redirects
    print("Stripe initialization attempted successfully.");
  } catch (e) {
    // Log the error but allow the app to run
    print("WARNING: Stripe initialization failed. Payment functionality may be disabled. Error: $e");
  }
  
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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        cardColor: AppColors.surfaceDark,
        primaryColor: AppColors.primaryBronze,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryBronze,
          onPrimary: AppColors.backgroundDark,
          secondary: AppColors.accentLight,
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

// --- 3. DATA MODELS & MOCK DATA & CART MANAGER ---

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
  });
}

class CartItem {
  final MenuItem item;
  int quantity;

  CartItem({required this.item, this.quantity = 1});
}

class CartManager {
  static final ValueNotifier<List<CartItem>> cartItems = ValueNotifier([]);

  static void addToCart(MenuItem item) {
    final existingIndex = cartItems.value.indexWhere((cartItem) => cartItem.item.id == item.id);

    if (existingIndex != -1) {
      cartItems.value[existingIndex].quantity++;
    } else {
      cartItems.value.add(CartItem(item: item));
    }
    cartItems.notifyListeners();
  }

  static void updateQuantity(CartItem cartItem, int newQuantity) {
    if (newQuantity <= 0) {
      cartItems.value.removeWhere((i) => i.item.id == cartItem.item.id);
    } else {
      final index = cartItems.value.indexWhere((i) => i.item.id == cartItem.item.id);
      if (index != -1) {
        cartItems.value[index].quantity = newQuantity;
      }
    }
    cartItems.notifyListeners();
  }

  static double get cartTotal {
    return cartItems.value.fold(0.0, (total, current) => total + (current.item.price * current.quantity));
  }
  
  static int get totalItemCount {
    return cartItems.value.fold(0, (total, current) => total + current.quantity);
  }
  
  static void clearCart() {
    cartItems.value = [];
    cartItems.notifyListeners();
  }
}


final List<MenuItem> mockMenu = [
  MenuItem(id: '1', name: 'Mutton Seekh Kebab', description: 'Finely minced mutton skewers, charcoal grilled.', price: 18.99, category: 'Grillz', imageUrl: MUTTON_SEEKH_KEBAB_URL),
  MenuItem(id: '2', name: 'Chicken Boti', description: 'Tender chicken marinated overnight in secret spices.', price: 14.99, category: 'Grillz', imageUrl: CHICKEN_BOTI_URL),
  MenuItem(id: '3', name: 'Paneer Tikka', description: 'Smoked cottage cheese cubes with bell peppers.', price: 12.99, category: 'Vegetarian', imageUrl: PANEER_TIKKA_URL),
  MenuItem(id: '4', name: 'Butter Naan', description: 'Traditional flatbread brushed with fresh butter.', price: 2.99, category: 'Breads', imageUrl: BUTTER_NAAN_URL),
  MenuItem(id: '5', name: 'Biryani (Family)', description: 'Aromatic rice dish with marinated meat and saffron.', price: 25.99, category: 'Rice', imageUrl: BIRYANI_URL),
  MenuItem(id: '6', name: 'Mango Lassi', description: 'Sweet yogurt drink blended with fresh mango pulp.', price: 5.99, category: 'Desserts', imageUrl: MANGO_LASSI_URL),
];

// --- 4. WIDGETS ---

// Menu Item Card Widget (Displays food image)
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display Network Image (Food Image)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                width: 70, 
                height: 70,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 70,
                    height: 70,
                    color: AppColors.backgroundDark,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryBronze,
                        strokeWidth: 2,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if the image fails to load (due to network restrictions)
                  return Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primaryBronze.withOpacity(0.5)),
                    ),
                    child: const Icon(Icons.fastfood, color: AppColors.primaryBronze),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: AppStyles.itemTitleStyle),
                  const SizedBox(height: 4),
                  Text(item.description, style: AppStyles.bodyStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            
            // Price and Add to Cart Button Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: AppStyles.itemPriceStyle,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {
                      CartManager.addToCart(item);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${item.name} added to cart!'),
                          duration: const Duration(seconds: 1),
                          backgroundColor: AppColors.primaryBronze.withOpacity(0.8),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      minimumSize: Size.zero,
                    ),
                    child: const Text('ADD', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
        final parentState = context.findAncestorStateOfType<_MainScreenState>();
        if (parentState != null) {
          parentState._onItemTapped(targetIndex);
          // Close the drawer if the button is pressed from within the drawer on mobile
          if (Scaffold.of(context).isDrawerOpen) {
             Navigator.pop(context);
          }
        }
      },
      child: Text(label),
    );
  }
}

// --- 5. SCREENS (Refactored to remove Scaffold/AppBar) ---

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // The pages now only return the body content, as the main screen manages the Scaffold/AppBar/Navigation.
  static const List<Widget> _pages = <Widget>[
    HomePage(),        // Index 0
    MenuScreen(),      // Index 1
    CartScreen(),      // Index 2
    ContactScreen(),   // Index 3
    ReservationScreen(), // Index 4
  ];
  
  // NEW: Navigation Items Data Structure
  final List<Map<String, dynamic>> _navItems = [
    {'label': 'Home', 'icon': Icons.home},
    {'label': 'Menu', 'icon': Icons.menu_book},
    {'label': 'Cart', 'icon': Icons.shopping_cart},
    {'label': 'Contact', 'icon': Icons.info},
    {'label': 'Reserve', 'icon': Icons.table_chart},
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  // Custom Cart Icon with Badge (must be accessible here)
  Widget _buildCartIconWithBadge({bool isDrawer = false}) {
    return ValueListenableBuilder<List<CartItem>>(
      valueListenable: CartManager.cartItems,
      builder: (context, cartItems, child) {
        final count = CartManager.totalItemCount;
        
        // Icon color logic for Drawer/Navigation Rail
        final color = isDrawer 
            ? (_selectedIndex == 2 ? AppColors.backgroundDark : AppColors.primaryBronze)
            : AppColors.primaryBronze;
            
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(Icons.shopping_cart, color: color),
            if (count > 0)
              Positioned(
                right: -8,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.surfaceDark, width: 1.5),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    count > 9 ? '9+' : '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
          ],
        );
      },
    );
  }
  
  // Drawer widget for mobile
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.surfaceDark,
      child: Column(
        children: <Widget>[
          // Drawer Header
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.backgroundDark),
            child: Row(
              children: [
                // Logo placeholder
                Image.asset(
                  LOGO_ASSET_PATH, 
                  height: 60, 
                  width: 60, 
                  fit: BoxFit.contain, 
                  errorBuilder: (context, error, stack) => const Icon(Icons.star, size: 40, color: AppColors.primaryBronze)
                ),
                const SizedBox(width: 12),
                const Text('Desi Grillz', style: AppStyles.titleStyle),
              ],
            ),
          ),
          // Navigation List Tiles
          ..._navItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = index == _selectedIndex;
            
            Widget iconWidget = item['icon'] == Icons.shopping_cart 
                ? _buildCartIconWithBadge(isDrawer: true) // Pass isDrawer=true for specific icon coloring
                : Icon(item['icon'], color: isSelected ? AppColors.backgroundDark : AppColors.primaryBronze);

            return ListTile(
              leading: iconWidget,
              title: Text(item['label'] as String, style: AppStyles.itemTitleStyle.copyWith(color: isSelected ? AppColors.backgroundDark : AppColors.textLight)),
              selected: isSelected,
              selectedColor: AppColors.backgroundDark,
              selectedTileColor: AppColors.primaryBronze,
              onTap: () {
                _onItemTapped(index);
                Navigator.pop(context); // Close the drawer
              },
            );
          }),
          const Spacer(),
          // Footer
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Authentic Indian & Pakistani Grillz',
              style: AppStyles.bodyStyle,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }


  // Refactored MainScreen build method to use LayoutBuilder for responsiveness
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        // Adjusting the breakpoint for responsiveness
        // Use 800 for the threshold to switch to permanent NavigationRail
        final bool isDesktop = width >= 800;


        // Desktop/Web View (Navigation Rail)
        if (isDesktop) {
          return Scaffold(
            appBar: AppBar(
              // Title on the main app bar
              title: Text(_navItems[_selectedIndex]['label'] as String),
              // Optional: Add a subtle logo to the AppBar on desktop
              leading: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Image.asset(LOGO_ASSET_PATH, height: 40, width: 40, errorBuilder: (context, error, stack) => const Icon(Icons.star, color: AppColors.primaryBronze)),
              ),
            ),
            body: Row(
              children: <Widget>[
                // Permanent Navigation Rail for Wide Screens
                NavigationRail(
                  backgroundColor: AppColors.surfaceDark,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) => _onItemTapped(index),
                  labelType: NavigationRailLabelType.all,
                  selectedIconTheme: const IconThemeData(color: AppColors.primaryBronze),
                  unselectedIconTheme: const IconThemeData(color: AppColors.textMuted),
                  selectedLabelTextStyle: AppStyles.bodyStyle.copyWith(color: AppColors.primaryBronze, fontWeight: FontWeight.bold),
                  unselectedLabelTextStyle: AppStyles.bodyStyle.copyWith(color: AppColors.textMuted),
                  destinations: _navItems.map((item) {
                    return NavigationRailDestination(
                      icon: item['icon'] == Icons.shopping_cart 
                          ? _buildCartIconWithBadge()
                          : Icon(item['icon']),
                      selectedIcon: Icon(item['icon']),
                      label: Text(item['label'] as String),
                    );
                  }).toList(),
                ),
                const VerticalDivider(thickness: 1, width: 1, color: AppColors.surfaceDark),
                // Page Content
                Expanded(child: _pages[_selectedIndex]),
              ],
            ),
          );
        }

        // Mobile/Tablet View (AppBar + Drawer)
        return Scaffold(
          appBar: AppBar(
            title: Text(_navItems[_selectedIndex]['label'] as String),
            // The leading hamburger icon is automatically displayed when the drawer is present.
          ),
          drawer: _buildDrawer(), // Hamburger icon appears automatically
          body: _pages[_selectedIndex],
        );
      },
    );
  }
}

// 5.1 Home Screen (FIX: Changed from CustomScrollView with SliverAppBar to a standard ListView)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Media query to determine the height for the header image
    final double screenHeight = MediaQuery.of(context).size.height;
    final double headerHeight = screenHeight * 0.35; // 35% of screen height for a dominant header

    return ListView(
      padding: EdgeInsets.zero, // Remove padding to let the header go edge-to-edge
      children: <Widget>[
        // --- 1. Header Area ---
        Container(
          height: headerHeight,
          color: AppColors.backgroundDark,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Background Image
              Image.asset(
                RESTAURANT_ASSET_PATH,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.surfaceDark,
                    child: const Center(child: Text("Restaurant Ambiance (Asset not found)", style: AppStyles.bodyStyle)),
                  );
                },
              ),
              // 2. Overlay for better text visibility and blending
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [AppColors.backgroundDark.withOpacity(0.9), AppColors.backgroundDark.withOpacity(0.5), Colors.transparent],
                    stops: const [0.0, 0.4, 0.7],
                  ),
                ),
              ),
              // 3. Circular Logo in the center
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                     Container(
                      width: 100, // Reduced size for a cleaner look
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBronze.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                        border: Border.all(color: AppColors.primaryBronze, width: 3),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          LOGO_ASSET_PATH, 
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                             const Icon(Icons.star, size: 60, color: AppColors.primaryBronze),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Desi Grillz', style: AppStyles.titleStyle.copyWith(fontSize: 24, color: AppColors.accentLight, shadows: [const Shadow(color: AppColors.backgroundDark, blurRadius: 4)])),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // --- 2. Body Content ---
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
              // Call to action buttons for easy navigation on Home page
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(child: CallToActionButton(label: 'View Menu', targetIndex: 1)),
                  SizedBox(width: 16),
                  Expanded(child: CallToActionButton(label: 'Reserve Table', targetIndex: 4)),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}


// 5.2 Menu Screen (Removed Scaffold/AppBar)
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<MenuItem>> groupedMenu = {};
    for (var item in mockMenu) {
      if (!groupedMenu.containsKey(item.category)) {
        groupedMenu[item.category] = [];
      }
      groupedMenu[item.category]!.add(item);
    }

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

    // Return only the body content
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: menuWidgets,
    );
  }
}

// 5.3 Cart Screen (Removed Scaffold/AppBar)
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CartItem>>(
      valueListenable: CartManager.cartItems,
      builder: (context, cartItems, child) {
        if (cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_cart_outlined, size: 80, color: AppColors.textMuted),
                const SizedBox(height: 16),
                Text('Your cart is empty', style: AppStyles.sectionHeaderStyle.copyWith(color: AppColors.textMuted)),
                const SizedBox(height: 8),
                const Text('Start adding delicious grillz from the menu!', style: AppStyles.bodyStyle),
                const SizedBox(height: 24),
                const CallToActionButton(label: 'Browse Menu', targetIndex: 1),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartItems[index];
                  return CartItemTile(cartItem: cartItem);
                },
              ),
            ),
            // Total and Checkout Area
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: AppColors.surfaceDark,
                border: Border(top: BorderSide(color: AppColors.primaryBronze)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal', style: AppStyles.itemTitleStyle),
                      Text('\$${CartManager.cartTotal.toStringAsFixed(2)}', style: AppStyles.itemTitleStyle.copyWith(color: AppColors.primaryBronze)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // NAVIGATE TO NEW CHECKOUT SCREEN
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                        );
                      },
                      child: const Text('Proceed to Checkout'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// Widget for displaying and managing individual cart items
class CartItemTile extends StatelessWidget {
  final CartItem cartItem;
  const CartItemTile({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      color: AppColors.surfaceDark,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cartItem.item.name, style: AppStyles.itemTitleStyle.copyWith(fontSize: 16)),
                  Text('\$${cartItem.item.price.toStringAsFixed(2)} each', style: AppStyles.bodyStyle),
                ],
              ),
            ),
            
            // Quantity controls
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryBronze.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 18, color: AppColors.primaryBronze),
                    onPressed: () => CartManager.updateQuantity(cartItem, cartItem.quantity - 1),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('${cartItem.quantity}', style: AppStyles.itemTitleStyle.copyWith(fontSize: 16)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 18, color: AppColors.primaryBronze),
                    onPressed: () => CartManager.updateQuantity(cartItem, cartItem.quantity + 1),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Total price for item
            Text(
              '\$${(cartItem.item.price * cartItem.quantity).toStringAsFixed(2)}',
              style: AppStyles.itemPriceStyle,
            ),
          ],
        ),
      ),
    );
  }
}

// Payment Method Enum
enum PaymentMethod { pay, cod }

// 5.4 NEW Checkout Screen (Keeps Scaffold/AppBar as it's a separate route)
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  
  PaymentMethod? _paymentMethod = PaymentMethod.pay; // Default to Pay Now for easier testing
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
  
  // --- STRIPE PAYMENT FUNCTION ---
  Future<void> _handleStripePayment(double amount) async {
    if (amount <= 0) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Backend Simulation: Create a Payment Intent
      // --------------------------------------------------------------------------------
      // IMPORTANT: These are MOCK values. A real application MUST replace these 
      // with real secrets returned from your secure backend server after creating 
      // a PaymentIntent, Ephemeral Key, and Customer ID. The app will fail here
      // until you connect it to a functional backend API.
      const String clientSecret = 'client_secret_mock_test_token_'; // REPLACE WITH REAL VALUE FROM BACKEND
      const String ephemeralKey = 'ek_mock_test_token';             // REPLACE WITH REAL VALUE FROM BACKEND
      const String customerId = 'cus_mock_test_id';                  // REPLACE WITH REAL VALUE FROM BACKEND
      // --------------------------------------------------------------------------------

      // 2. Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: const SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Desi Grillz',
          customerId: customerId,
          customerEphemeralKeySecret: ephemeralKey,
          style: ThemeMode.dark,
          // Optional: Force card payment method for simplicity
          billingDetails: BillingDetails(
            email: RESTAURANT_EMAIL,
            address: Address(
              country: 'US',
              line1: '123 Test St',
              line2: null, 
              city: 'Test City',
              postalCode: '10001',
              state: 'NY',
            ),
          ),
        ),
      );

      // 3. Display Payment Sheet and await confirmation
      await Stripe.instance.presentPaymentSheet();
      
      // If successful (no exception thrown), we proceed to finalize order
      _finalizeOrder('Online Payment (Stripe)');

    } on Exception catch (e) {
      String message = 'Payment failed. Please try again.';
      if (e is StripeException) {
        // This is where you will likely see an error due to the mock secrets
        message = 'Stripe Error: ${e.error.localizedMessage}. Check clientSecret and Ephemeral Key.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if(mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Finalizes the order, common to both COD and successful Stripe payment
  void _finalizeOrder(String paymentText) {
     final total = CartManager.cartTotal;
     
     // 1. Clear Cart
     CartManager.clearCart(); 

     // 2. Show success message
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text('Order placed successfully! Total: \$${total.toStringAsFixed(2)}. Payment via: $paymentText'),
         duration: const Duration(seconds: 4),
         backgroundColor: Colors.green,
       ),
     );

     // 3. Navigate back to cart screen
     Navigator.of(context).pop();
  }

  void _placeOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_paymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a payment method.'),
          backgroundColor: Colors.red.withOpacity(0.8),
        ),
      );
      return;
    }
    
    // Check if loading to prevent double-tap
    if (_isLoading) return;

    if (_paymentMethod == PaymentMethod.cod) {
      _finalizeOrder('Cash on Delivery');
    } else if (_paymentMethod == PaymentMethod.pay) {
      final amount = CartManager.cartTotal;
      if (amount > 0) {
        await _handleStripePayment(amount);
      } else {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content: const Text('Cart is empty. Cannot process payment.'),
             backgroundColor: Colors.red.withOpacity(0.8),
           ),
         );
      }
    }
  }

  Widget _buildPaymentButton({
    required PaymentMethod method,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _paymentMethod == method;
    return Expanded(
      child: OutlinedButton.icon(
        icon: Icon(icon, color: isSelected ? AppColors.backgroundDark : AppColors.primaryBronze),
        label: Text(label),
        onPressed: () {
          setState(() {
            _paymentMethod = method;
          });
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.primaryBronze : AppColors.surfaceDark,
          foregroundColor: isSelected ? AppColors.backgroundDark : AppColors.primaryBronze,
          side: BorderSide(color: AppColors.primaryBronze, width: isSelected ? 2 : 1),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Delivery Information', style: AppStyles.sectionHeaderStyle),
              const SizedBox(height: 16),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person, color: AppColors.primaryBronze),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone Field
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone, color: AppColors.primaryBronze),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 10) {
                    return 'Please enter a valid phone number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Address Field
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Delivery Address',
                  prefixIcon: Icon(Icons.location_on, color: AppColors.primaryBronze),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your delivery address.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Order Summary (Sticky)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primaryBronze),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Order Total:', style: AppStyles.itemTitleStyle),
                    Text('\$${CartManager.cartTotal.toStringAsFixed(2)}', style: AppStyles.itemPriceStyle.copyWith(fontSize: 20)),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              const Text('Payment Method', style: AppStyles.sectionHeaderStyle),
              const SizedBox(height: 16),

              // Payment Buttons
              Row(
                children: [
                  _buildPaymentButton(
                    method: PaymentMethod.pay,
                    label: 'Pay Now (Stripe)',
                    icon: Icons.payment,
                  ),
                  const SizedBox(width: 16),
                  _buildPaymentButton(
                    method: PaymentMethod.cod,
                    label: 'Cash on Delivery',
                    icon: Icons.money,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Place Order Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: _isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.backgroundDark, strokeWidth: 2)) 
                    : const Icon(Icons.shopping_bag),
                  onPressed: _isLoading ? null : _placeOrder,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  label: Text(
                    _isLoading 
                      ? 'PROCESSING PAYMENT...' 
                      : 'PLACE ORDER', 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // PCI Compliance Warning
              const Text(
                'Note: "Pay Now" uses Stripe’s secure payment sheet to handle card details. A real implementation requires a secure backend to generate the Client Secret.',
                style: AppStyles.bodyStyle,
                textAlign: TextAlign.center,
              )
              
            ],
          ),
        ),
      ),
    );
  }
}

// 5.5 Contact Screen (Removed Scaffold/AppBar)
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Get in Touch', style: AppStyles.titleStyle),
          SizedBox(height: 16),
          Text(
            'We are here to answer any questions you may have about our menu, services, or large group bookings. Reach out to us via phone, email, or stop by our location during business hours.',
            style: AppStyles.bodyStyle,
          ),
          SizedBox(height: 32),
          Text('Our Details', style: AppStyles.sectionHeaderStyle),
          SizedBox(height: 16),
          // Contact Information
          ContactInfoTile(icon: Icons.phone, text: '+1 (555) 123-4567'),
          ContactInfoTile(icon: Icons.email, text: RESTAURANT_EMAIL),
          ContactInfoTile(icon: Icons.location_on, text: '123 Grill Street, Flavor City'),
          SizedBox(height: 32),
          Text('Hours of Operation', style: AppStyles.sectionHeaderStyle),
          SizedBox(height: 16),
          ContactInfoTile(icon: Icons.access_time, text: 'Mon - Sun: 5:00 PM - 11:00 PM'),
          SizedBox(height: 48),
          // Call to action to reserve a table (Target Index 4)
          Center(
            child: CallToActionButton(label: 'Book a Table Now', targetIndex: 4), 
          ),
        ],
      ),
    );
  }
}

// 5.6 Reservation Screen (Removed Scaffold/AppBar)
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
            ), dialogTheme: const DialogThemeData(backgroundColor: AppColors.backgroundDark),
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
            ), dialogTheme: const DialogThemeData(backgroundColor: AppColors.backgroundDark),
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
      setState(() {
        _reservationSuccess = true;
        _nameController.clear();
        _guestsController.clear();
        _timeController.clear();
        _dateController.clear();
      });

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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Reservation Ambiance Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                RESERVATION_AMBIANCE_URL,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 180,
                    color: AppColors.surfaceDark,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBronze),
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    color: AppColors.surfaceDark,
                    child: const Center(child: Text("Reserved Table View", style: AppStyles.bodyStyle)),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
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
                }
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
    );
  }
}