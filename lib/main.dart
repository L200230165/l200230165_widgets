import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

/// MODEL
class Flower {
  String name;
  String latin;
  String meaning;
  String image;
  bool isAsset;
  Color color;
  bool isFavorite;

  Flower(
      this.name,
      this.latin,
      this.meaning,
      this.image,
      this.isAsset,
      this.color, {
        this.isFavorite = false,
      });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flowers Dictionary',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  String nama = "";
  String latin = "";
  String makna = "";
  String imageUrl = "";

  bool showOnlyFavorite = false;

  List<Flower> flowers = [
    Flower("Mawar", "Rosa", "Cinta",
        "assets/images/mawar.jpg", true, Colors.pink.shade100),
    Flower("Tulip", "Tulipa", "Cinta sempurna",
        "assets/images/tulip.jpg", true, Colors.orange.shade100),
    Flower("Lily", "Lilium", "Kemurnian",
        "assets/images/lily.jpg", true, Colors.purple.shade100),
    Flower("Matahari", "Helianthus", "Energi",
        "assets/images/sunflower.jpg", true, Colors.yellow.shade200),
  ];

  @override
  Widget build(BuildContext context) {
    int gridCount =
    MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4;

    List<Flower> displayedFlowers = showOnlyFavorite
        ? flowers.where((f) => f.isFavorite).toList()
        : flowers;

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: Text("🌸 Flowers Dictionary"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "about") showAbout();
              if (value == "info") showInfo();
              if (value == "favorite") toggleFavoriteView();
              if (value == "exit") exitApp();
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: "about", child: Text("Tentang")),
              PopupMenuItem(value: "info", child: Text("Info")),
              PopupMenuItem(value: "favorite", child: Text("Favorit")),
              PopupMenuItem(value: "exit", child: Text("Keluar")),
            ],
          )
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// LOGO
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.pink.shade100,
                      child: Icon(Icons.local_florist,
                          size: 40, color: Colors.pink),
                    ),
                    SizedBox(height: 10),
                    Text("Flowers Dictionary",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))
                  ],
                ),
              ),

              SizedBox(height: 20),

              /// RICHTEXT
              RichText(
                text: TextSpan(
                  text: "Worldwide ",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  children: [
                    TextSpan(
                        text: "Flowers",
                        style: TextStyle(color: Colors.pink)),
                    TextSpan(
                        text: " Dictionary",
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              SizedBox(height: 20),

              /// FORM
              Form(
                key: _formKey,
                child: Column(
                  children: [

                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Nama Bunga",
                          border: OutlineInputBorder()),
                      validator: (v) =>
                      v!.isEmpty ? "Wajib diisi" : null,
                      onSaved: (v) => nama = v!,
                    ),

                    SizedBox(height: 10),

                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Nama Latin",
                          border: OutlineInputBorder()),
                      validator: (v) =>
                      v!.isEmpty ? "Wajib diisi" : null,
                      onSaved: (v) => latin = v!,
                    ),

                    SizedBox(height: 10),

                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Makna",
                          border: OutlineInputBorder()),
                      validator: (v) =>
                      v!.isEmpty ? "Wajib diisi" : null,
                      onSaved: (v) => makna = v!,
                    ),

                    SizedBox(height: 10),

                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "URL Gambar (opsional)",
                          border: OutlineInputBorder()),
                      onSaved: (v) => imageUrl = v ?? "",
                    ),

                    SizedBox(height: 10),

                    ElevatedButton(
                      child: Text("Tambah"),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          setState(() {
                            flowers.add(
                              Flower(
                                nama,
                                latin,
                                makna,
                                imageUrl.isEmpty
                                    ? "assets/images/mawar.jpg"
                                    : imageUrl,
                                imageUrl.isEmpty,
                                Colors.pink.shade100,
                              ),
                            );
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              /// GRID
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: displayedFlowers.length,
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final flower = displayedFlowers[index];
                  return GestureDetector(
                    onTap: () => showDetail(flower),
                    child: WhimsyCard(
                      flower: flower,
                      onFavoriteToggle: () {
                        setState(() {
                          flower.isFavorite = !flower.isFavorite;
                        });
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// DETAIL POPUP (EDIT + HAPUS + FAVORIT)
  void showDetail(Flower flower) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(flower.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            flower.isAsset
                ? Image.asset(flower.image, height: 100)
                : Image.network(
              flower.image,
              height: 100,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.broken_image),
            ),
            SizedBox(height: 10),
            Text("Latin: ${flower.latin}"),
            Text("Makna: ${flower.meaning}"),
          ],
        ),
        actions: [

          TextButton(
            child: Text(flower.isFavorite
                ? "Hapus dari Favorit"
                : "Tambah ke Favorit"),
            onPressed: () {
              setState(() {
                flower.isFavorite = !flower.isFavorite;
              });
              Navigator.pop(context);
            },
          ),

          TextButton(
            child: Text("Edit"),
            onPressed: () {
              Navigator.pop(context);
              showEditDialog(flower);
            },
          ),

          TextButton(
            child: Text("Hapus",
                style: TextStyle(color: Colors.red)),
            onPressed: () {
              setState(() {
                flowers.remove(flower);
              });
              Navigator.pop(context);
            },
          ),

          TextButton(
              child: Text("Tutup"),
              onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  /// EDIT
  void showEditDialog(Flower flower) {
    final _editKey = GlobalKey<FormState>();

    String namaE = flower.name;
    String latinE = flower.latin;
    String maknaE = flower.meaning;
    String imageE = flower.image;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Bunga"),
        content: Form(
          key: _editKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              TextFormField(
                initialValue: flower.name,
                onSaved: (v) => namaE = v!,
              ),

              TextFormField(
                initialValue: flower.latin,
                onSaved: (v) => latinE = v!,
              ),

              TextFormField(
                initialValue: flower.meaning,
                onSaved: (v) => maknaE = v!,
              ),

              TextFormField(
                initialValue: flower.isAsset ? "" : flower.image,
                onSaved: (v) => imageE = v ?? "",
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text("Simpan"),
            onPressed: () {
              _editKey.currentState!.save();

              setState(() {
                flower.name = namaE;
                flower.latin = latinE;
                flower.meaning = maknaE;
                flower.image = imageE.isEmpty
                    ? "assets/images/mawar.jpg"
                    : imageE;
                flower.isAsset = imageE.isEmpty;
              });

              Navigator.pop(context);
            },
          ),
          TextButton(
              child: Text("Batal"),
              onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  /// MENU
  void showAbout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Tentang"),
        content: Text(
            "Aplikasi ini adalah kamus bunga untuk menyimpan temuan bunga dari internet."),
      ),
    );
  }

  void showInfo() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Aplikasi masih dalam pengembangan")));
  }

  void toggleFavoriteView() {
    setState(() {
      showOnlyFavorite = !showOnlyFavorite;
    });
  }

  void exitApp() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Keluar"),
        content: Text("Yakin mau keluar?"),
        actions: [
          TextButton(
              child: Text("Batal"),
              onPressed: () => Navigator.pop(context)),
          TextButton(
              child: Text("Keluar"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }
}

/// CARD
class WhimsyCard extends StatelessWidget {
  final Flower flower;
  final VoidCallback onFavoriteToggle;

  const WhimsyCard({
    required this.flower,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: flower.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Stack(
        children: [

          Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(20)),
                  child: flower.isAsset
                      ? Image.asset(flower.image,
                      fit: BoxFit.cover,
                      width: double.infinity)
                      : Image.network(
                    flower.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) =>
                        Icon(Icons.broken_image),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  flower.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          /// ❤️ FAVORITE ICON
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              icon: Icon(
                flower.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: flower.isFavorite
                    ? Colors.red
                    : Colors.grey,
              ),
              onPressed: onFavoriteToggle,
            ),
          ),
        ],
      ),
    );
  }
}