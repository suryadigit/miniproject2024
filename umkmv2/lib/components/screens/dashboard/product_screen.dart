// ignore_for_file: deprecated_member_use, sort_child_properties_last, use_build_context_synchronously, unrelated_type_equality_checks
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/product_controllers.dart';
import '../../models/model_product.dart';
import '../fitures/add_form.dart';
import '../message/inbox_screen.dart';
import '../history/history_screen.dart';
import '../profiles/profile_screen.dart';
import '../fitures/detail_product.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late TextEditingController _searchController;
  int _selectedIndex = 0;
  List<ProductModel> _searchResults = [];
  bool _isLoading = true;
  late bool _isConnected;
  bool _isTextObscured = true;
  List<String> imageUrls = [
    'https://images.tokopedia.net/img/cache/730/kjjBfF/2021/6/15/616df725-64b7-4de8-b6c7-4d8d9fff7a68.png.webp',
    'https://images.tokopedia.net/img/cache/730/kjjBfF/2021/6/14/658ede0f-7236-425e-bef3-a498a6c14912.jpg.webp',
    'https://images.tokopedia.net/img/cache/730/kjjBfF/2022/2/11/4ccd283c-c4f6-4f47-886b-ad8ae8471568.jpg.webp',
  ];
  List<String> targetUrls = [
    'https://assets.tokopedia.net/asts/edukasi/Seller-Deck-Tokopedia-Display-Network.pdf',
    'https://seller.tokopedia.com/edu/tips-dekorasi-toko/',
    'https://www.tokopedia.com/help/article/bagaimana-cara-mengatur-dekorasi-toko',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onTextChanged);
    final productController =
        Provider.of<ProductController>(context, listen: false);
    productController.addListener(_onProductsChanged);
    productController.getProducts();
    _isLoading = true;
    _isConnected = true;
    _checkInternetConnection();
  }

  void _checkInternetConnection() {
    Connectivity().checkConnectivity().then((connectivityResult) {
      if (connectivityResult == ConnectivityResult.none) {
        setState(() {
          _isConnected = false;
        });
      } else {
        setState(() {
          _isConnected = true;
        });
      }
    });
  }

  void _onProductsChanged() {
    setState(() {
      _searchResults =
          Provider.of<ProductController>(context, listen: false).products!;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    String query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _searchResults.addAll(
            Provider.of<ProductController>(context, listen: false).products!);
      });
    } else {
      setState(() {
        _searchResults = Provider.of<ProductController>(context, listen: false)
            .products!
            .where((product) => product.title.toLowerCase().contains(query))
            .toList();
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/backgroundsed.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 9),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Cari produk...',
                            hintStyle: const TextStyle(color: Colors.green),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0.0),
                          prefixIcon:const Icon(Icons.search, size: 18, color: Colors.green),
                          ),
                          style: const TextStyle(
                            fontFamily: 'Schyler',
                            fontSize: 12,
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          Positioned(
                            right: 0,
                            child: TextButton(
                              onPressed: () {
                                _searchController.clear();
                              },
                              child: const Text(
                                'Batal',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productController = Provider.of<ProductController>(context);
    return Scaffold(
      appBar: _selectedIndex == 0 ? _buildAppBar() : null,
      body: RefreshIndicator(
          color: Colors.green,
          onRefresh: () async {
            productController.getProducts();
            setState(() {
              _isLoading = true;
            });
          },
          child: _selectedIndex == 0
              ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      CarouselSlider(
                        items: _isLoading
                            ? _buildShimmerCarousel()
                            : _buildCarouselItems(),
                        options: CarouselOptions(
                          height: 139,
                          autoPlay: true,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 22.0, vertical: 8.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 176, 234),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(56, 0, 0, 0),
                              blurRadius: 2,
                              offset: Offset(0, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: SvgPicture.asset(
                                'assets/svg/wallet.svg',
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isTextObscured ? "Rp 3.000.000" : "Rp --------",
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: Icon(
                                _isTextObscured
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                                size: 16,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isTextObscured = !_isTextObscured;
                                });
                              },
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(
                                Icons.compare_arrows,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.qr_code_scanner_rounded,
                                  color: Colors.black),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      _isLoading
                          ? _buildShimmerList()
                          : _buildProductList(productController),
                      if (!_isConnected)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Tidak ada koneksi internet',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              : _selectedIndex == 1
                  ? const InboxScreen()
                  : _selectedIndex == 2
                      ? const AddProductForm()
                      : _selectedIndex == 3
                          ? const HistoryScreen()
                          : const ProfileScreen()),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              alignment: Alignment.topRight,
              children: [
                const Icon(Icons.chat_rounded),
                CustomPaint(
                  painter: AiBadge(colors: [
                    Colors.blue,
                    Colors.purple,
                    Colors.red,
                  ]),
                  size: const Size(15, 15),
                ),
              ],
            ),
            label: 'Pesan',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 45,
              height: 45,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              child: const Icon(
                Icons.add,
                size: 40,
                color: Colors.white,
              ),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.history_sharp),
            label: 'History',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Akun',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        onTap: _onItemTapped,
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  List<Shimmer> _buildShimmerCarousel() {
    return imageUrls.map((url) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          color: Colors.white.withOpacity(0.5),
        ),
      );
    }).toList();
  }

  List<Widget> _buildCarouselItems() {
    return imageUrls.map((url) {
      return GestureDetector(
        onTap: () {
          String targetUrl = targetUrls[imageUrls.indexOf(url)];
          launch(targetUrl);
        },
        child: Image.network(url),
      );
    }).toList();
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          color: const Color.fromARGB(255, 255, 255, 255),
          child: ListTile(
            title: Shimmer.fromColors(
              baseColor: Colors.green[100]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                color: Colors.white,
                height: 20.0,
                width: double.infinity,
              ),
            ),
            subtitle: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.green[100]!,
              child: Container(
                color: Colors.white,
                height: 16.0,
                width: double.infinity,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductList(ProductController productController) {
    return RefreshIndicator(
      color: Colors.green,
      onRefresh: () async {
        productController.getProducts();
      },
      child: _searchResults.isEmpty
          ? _buildEmptyListPlaceholder()
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _searchController.text.isNotEmpty
                  ? _searchResults.length
                  : productController.products?.length ?? 0,
              itemBuilder: (context, index) {
                final product = _searchController.text.isNotEmpty
                    ? _searchResults[index]
                    : productController.products![index];
                return _buildProductCard(product, _searchController);
              },
            ),
    );
  }

  Widget _buildEmptyListPlaceholder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/nodata.svg',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'Gelap nih, engga ada data!!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
      ProductModel product, TextEditingController searchController) {
    final dateFormatter = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
    dateFormatter.format(product.created);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 2,
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          product.title,
          style:
              const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          ('Stok Tersedia: ${product.stock} pcs'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: SvgPicture.asset('assets/svg/expand_circle_right.svg',
                  height: 24, width: 24, color: Colors.grey),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(
                      id: product.id,
                      title: product.title,
                      created: product.created,
                      price: product.price,
                      description: product.description,
                      stock: product.stock,
                      productCode: product.productCode,
                    ),
                  ),
                );
                const Divider();
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                bool confirmDelete = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Theme(
                       
                        data: Theme.of(context).copyWith(
                        
                          dialogTheme: DialogTheme(
                            backgroundColor:
                                const Color.fromARGB(226, 255, 255, 255),  
                            shape: RoundedRectangleBorder(
                             
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            titleTextStyle: const TextStyle(
                        
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        child: AlertDialog(
                          title: const Text("Konfirmasi Hapus", style: TextStyle(color: Colors.black)),
                          content: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 12.0),  
                            child: Text(
                                "Apakah Anda yakin ingin menghapus produk ini?"),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("Batal",style: TextStyle(
                              color: Colors.blue
                              )),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            TextButton(
                              child: const Text("Hapus", style: TextStyle(
                              color: Colors.red
                              ),),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ],
                        ));
                  },
                );

                if (confirmDelete == true) {
                  await Provider.of<ProductController>(context, listen: false)
                      .deleteProduct(product.id);

                  Provider.of<ProductController>(context, listen: false)
                      .getProducts();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AiBadge extends CustomPainter {
  final List<Color> colors;

  AiBadge({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final Rect rect = Offset.zero & size;
    paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: colors,
    ).createShader(rect);
    final path = Path();
    final centerX = size.width / 1;
    final centerY = size.height / 5;
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius / 2;
    path.moveTo(centerX, centerY - outerRadius);
    path.lineTo(centerX + innerRadius * 0.8, centerY - innerRadius * 0.6);
    path.lineTo(centerX + outerRadius, centerY);
    path.lineTo(centerX + innerRadius * 0.6, centerY + innerRadius * 0.8);
    path.lineTo(centerX, centerY + outerRadius);
    path.lineTo(centerX - innerRadius * 0.6, centerY + innerRadius * 0.8);
    path.lineTo(centerX - outerRadius, centerY);
    path.lineTo(centerX - innerRadius * 0.8, centerY - innerRadius * 0.6);
    path.lineTo(centerX, centerY - outerRadius);
    path.close();
    canvas.drawCircle(
        Offset(centerX, centerY), outerRadius, Paint()..color = Colors.white);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
