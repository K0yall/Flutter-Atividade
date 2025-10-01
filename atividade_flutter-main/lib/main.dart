import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dark Styled Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1C1C1E),
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _drawerController;

  @override
  void initState() {
    super.initState();
    _drawerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _drawerController.dispose();
    super.dispose();
  }

  bool get isDrawerOpen => _drawerController.value == 1.0;

  void toggleDrawer() {
    if (isDrawerOpen) {
      _drawerController.reverse();
    } else {
      _drawerController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: toggleDrawer,
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _drawerController,
            color: Colors.deepPurpleAccent,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.videogame_asset, color: Colors.deepPurpleAccent),
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildContent(),
          _buildDrawer(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D0D0F), Color(0xFF1E1E20)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.deepPurpleAccent, Colors.indigoAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 12,
                offset: Offset(0, 6),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.star, size: 60, color: Colors.white),
              SizedBox(height: 16),
              Text(
                "Bem-vindo!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Explore o menu para navegar",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return AnimatedBuilder(
      animation: _drawerController,
      builder: (context, child) {
        final slide =
            (1.0 - _drawerController.value) * MediaQuery.of(context).size.width;
        return Transform.translate(
          offset: Offset(slide, 0),
          child: _drawerController.value == 0
              ? const SizedBox()
              : const DarkMenu(),
        );
      },
    );
  }
}

class DarkMenu extends StatefulWidget {
  const DarkMenu({super.key});

  @override
  State<DarkMenu> createState() => _DarkMenuState();
}

class _DarkMenuState extends State<DarkMenu>
    with SingleTickerProviderStateMixin {
  final List<String> menuItems = const [
    "Explorar Jogos",
    "Favoritos",
    "Notificações",
    "Configurações",
    "Sair"
  ];

  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1E1E20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DrawerHeader(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.deepPurpleAccent,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
          ),
          ...menuItems.asMap().entries.map((entry) {
            final index = entry.key;
            final title = entry.value;
            final interval = Interval(
              index * 0.1,
              1.0,
              curve: Curves.easeOutBack,
            );
            return AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                final opacity =
                    interval.transform(_animController.value).clamp(0.0, 1.0);
                final offset =
                    (1 - opacity) * 50; // desliza da direita p/ esquerda
                return Opacity(
                  opacity: opacity,
                  child: Transform.translate(
                    offset: Offset(offset, 0),
                    child: child,
                  ),
                );
              },
              child: ListTile(
                title: Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18, letterSpacing: 1)),
                leading: const Icon(Icons.arrow_right,
                    color: Colors.deepPurpleAccent),
                onTap: () {},
              ),
            );
          }),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.deepPurpleAccent, Colors.indigoAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                label: const Text(
                  "Iniciar",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
    );
  }
}
