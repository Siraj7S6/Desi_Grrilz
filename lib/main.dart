import 'package:flutter/material.dart';

// --- NETWORK IMAGE URLS ---
// Using stable placeholder URLs for restaurant and food images
// NOTE: RESTAURANT_LOGO_URL is now LOCAL: 'assets/logo.png'
const String RESTAURANT_AMBIANCE_URL = "https://images.unsplash.com/photo-1517248135460-4c125d0337f7?fit=crop&w=1080&q=80"; // The main restaurant ambiance image
const String RESERVATION_AMBIANCE_URL = "https://images.unsplash.com/photo-1551632759-e93540a5a679?fit=crop&w=1080&q=80"; // Updated for better stability

// --- CONTACT INFORMATION ---
const String RESTAURANT_EMAIL = 'reservations@desigrillz.com'; // New Email Address

// --- UPDATED FOOD DISH URLS FOR MAXIMUM STABILITY (Using simple picsum.photos links) ---
const String MUTTON_SEEKH_KEBAB_URL = "https://picsum.photos/id/292/300"; // Ultra-stable placeholder
const String CHICKEN_BOTI_URL = "https://picsum.photos/id/351/300";   // Ultra-stable placeholder
const String PANEER_TIKKA_URL = "https://picsum.photos/id/1080/300";  // Ultra-stable placeholder
const String BUTTER_NAAN_URL = "https://picsum.photos/id/21/300";     // Ultra-stable placeholder
const String BIRYANI_URL = "https://picsum.photos/id/164/300";      // Ultra-stable placeholder
const String MANGO_LASSI_URL = "https://picsum.photos/id/257/300";    // Ultra-stable placeholder

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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        cardColor: AppColors.surfaceDark,
        primaryColor: AppColors.primaryBronze,
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
        }
      },
      child: Text(label),
    );
  }
}

// --- 5. SCREENS ---

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Updated to include ContactScreen and shift ReservationScreen
  static const List<Widget> _pages = <Widget>[
    HomePage(),        // Index 0
    MenuScreen(),      // Index 1
    CartScreen(),      // Index 2
    ContactScreen(),   // Index 3 (NEW)
    ReservationScreen(), // Index 4 (Shifted)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  List<BottomNavigationBarItem> _buildBottomNavigationBarItems() {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.menu_book),
        label: 'Menu',
      ),
      // Cart Tab with live count badge
      BottomNavigationBarItem(
        label: 'Cart',
        icon: ValueListenableBuilder<List<CartItem>>(
          valueListenable: CartManager.cartItems,
          builder: (context, cartItems, child) {
            final count = CartManager.totalItemCount;
            
            return Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart),
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
        ),
      ),
      // NEW Contact Tab
      const BottomNavigationBarItem(
        icon: Icon(Icons.info),
        label: 'Contact',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.table_chart),
        label: 'Reserve',
      ),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _buildBottomNavigationBarItems(),
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryBronze,
        unselectedItemColor: AppColors.textMuted,
        backgroundColor: AppColors.surfaceDark,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Essential for 5 items
      ),
    );
  }
}

// 5.1 Home Screen (Cleaned up, no 'Find Us' section)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 300.0, // Increased height for better visual impact
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: const Text('Desi Grillz', style: TextStyle(color: AppColors.accentLight, shadows: [Shadow(color: AppColors.backgroundDark, blurRadius: 4)])),
            background: Stack(
              fit: StackFit.expand,
              children: [
                // 1. Network Image for the restaurant ambiance (Primary visual element)
                Image.network(
                  RESTAURANT_AMBIANCE_URL,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
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
                      color: AppColors.surfaceDark,
                      child: Center(child: Text("Desi Grillz Ambiance Loading Failed", style: AppStyles.bodyStyle)),
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
                // 3. Circular Logo in the center (Image.asset)
                Center(
                  child: Container(
                    width: 130, // Slightly larger logo
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBronze.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ],
                      border: Border.all(color: AppColors.primaryBronze, width: 4),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => 
                           const Icon(Icons.star, size: 80, color: AppColors.primaryBronze),
                      ),
                    ),
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
                    // Call to Action
                    Center(
                      child: CallToActionButton(label: 'View Menu', targetIndex: 1),
                    ),
                    SizedBox(height: 16),
                    // Second Call to Action for Contact (New)
                    Center(
                      child: CallToActionButton(label: 'Contact & Location', targetIndex: 3),
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

// 5.2 Menu Screen
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

// 5.3 Cart Screen
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Order'),
      ),
      body: ValueListenableBuilder<List<CartItem>>(
        valueListenable: CartManager.cartItems,
        builder: (context, cartItems, child) {
          if (cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: AppColors.textMuted),
                  const SizedBox(height: 16),
                  Text('Your cart is empty', style: AppStyles.sectionHeaderStyle.copyWith(color: AppColors.textMuted)),
                  const SizedBox(height: 8),
                  const Text('Start adding delicious grillz from the menu!', style: AppStyles.bodyStyle),
                  const SizedBox(height: 24),
                  CallToActionButton(label: 'Browse Menu', targetIndex: 1),
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
                decoration: BoxDecoration(
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
                          // Mock checkout process
                          CartManager.cartItems.value = [];
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Order Placed Successfully!'),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.green,
                            ),
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
      ),
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

// 5.4 NEW Contact Screen
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Get in Touch', style: AppStyles.titleStyle),
            const SizedBox(height: 16),
            const Text(
              'We are here to answer any questions you may have about our menu, services, or large group bookings. Reach out to us via phone, email, or stop by our location during business hours.',
              style: AppStyles.bodyStyle,
            ),
            const SizedBox(height: 32),
            const Text('Our Details', style: AppStyles.sectionHeaderStyle),
            const SizedBox(height: 16),
            // Contact Information
            const ContactInfoTile(icon: Icons.phone, text: '+1 (555) 123-4567'),
            const ContactInfoTile(icon: Icons.email, text: RESTAURANT_EMAIL),
            const ContactInfoTile(icon: Icons.location_on, text: '123 Grill Street, Flavor City'),
            const SizedBox(height: 32),
            const Text('Hours of Operation', style: AppStyles.sectionHeaderStyle),
            const SizedBox(height: 16),
            const ContactInfoTile(icon: Icons.access_time, text: 'Mon - Sun: 5:00 PM - 11:00 PM'),
            const SizedBox(height: 48),
            // Call to action to reserve a table (Target Index 4)
            Center(
              child: CallToActionButton(label: 'Book a Table Now', targetIndex: 4), 
            ),
          ],
        ),
      ),
    );
  }
}

// 5.5 Reservation Screen (Shifted to index 4)
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