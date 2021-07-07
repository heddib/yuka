import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yuka/app_colors.dart';
import 'package:yuka/app_icons.dart';
import 'package:yuka/network/api_product.dart';
import 'package:yuka/product_bloc.dart';
import 'package:yuka/res/resources.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          primaryColorDark: AppColors.primaryDarkColor,
          accentColor: AppColors.accentColor),
      home: HomePage(),
    );
  }
}

/*
 * product: Product(
    barcode: '266616155156615',
    name: 'Petits pois et carottes',
    altName: 'Petits pois et carottes à l\étuvée avec garniture',
    brands: ['Cassegrain'],
    nutriScore: ProductNutriscore.A,
    manufacturingCountries: ['France'],
    ecoScore: ProductEcoScore.D,
    novaScore: ProductNovaScore.Group1,
    quantity: '200g (égoutté 130g)')
 */

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return Theme(
      data: Theme.of(context).copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.white,
          elevation: 0.0,
          centerTitle: false,
          iconTheme: IconTheme.of(context).copyWith(
            color: primaryColor,
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Mes scans',
            style: TextStyle(color: primaryColor),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        DetailsScreen(barcode: '5000159484695')));
              },
              padding: const EdgeInsets.fromLTRB(0, 8.0, 15.0, 8.0),
              icon: const Icon(
                AppIcons.barcode,
              ),
            )
          ],
        ),
        body: Center(
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SvgPicture.asset(
                  AppVectorialImages.illEmpty,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  'Vous n\'avez pas encore\nscanné de produit',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            DetailsScreen(barcode: '5000159484695')));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Commencer'.toUpperCase(),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        const Icon(
                          Icons.arrow_right_alt,
                        ),
                      ],
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    primary: AppColors.blue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(22.0),
                      ),
                    ),
                    backgroundColor: AppColors.yellow,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailsScreen extends StatefulWidget {
  final String barcode;
  const DetailsScreen({Key? key, required this.barcode}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  ProductAvailableState? productAvailableState;

  @override
  void initState() {
    bloc.fetchProduct(widget.barcode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => bloc,
        child: Scaffold(
          body:
              BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
            if (state is ProductLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ProductAvailableState) {
              print(state.product?.name);
              productAvailableState = state;
              return SizedBox.expand(
                child: ProductHolder(
                  product: state.product,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 0,
                        right: 0,
                        child: ProductImage(),
                      ),
                      Positioned(
                        left: 0.0,
                        right: 0.0,
                        top: 250.0,
                        bottom: 0.0,
                        child: ProductDetails(),
                      )
                    ],
                  ),
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          }),
          bottomNavigationBar: ProductDetailsBottomNavigationBar(),
        ));
  }
}

class ProductDetailsBottomNavigationBar extends StatefulWidget {
  const ProductDetailsBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _ProductDetailsBottomNavigationBarState createState() =>
      _ProductDetailsBottomNavigationBarState();
}

class _ProductDetailsBottomNavigationBarState
    extends State<ProductDetailsBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: getItems(),
        currentIndex: currentTab.index,
        onTap: (int index) {
          this.onTapHandler(index);
        },
        unselectedItemColor: AppColors.gray2,
        selectedItemColor: AppColors.primaryColor);
  }

  ProductDetailsCurrentTab currentTab = ProductDetailsCurrentTab.SUMMARY;

  void onTapHandler(int index) {
    this.setState(() {
      this.currentTab = ProductDetailsCurrentTab.values[index];
    });
  }

  List<BottomNavigationBarItem> getItems() {
    List<BottomNavigationBarItem> items =
        List<BottomNavigationBarItem>.empty(growable: true);

    ProductDetailsCurrentTab.values.forEach((element) {
      switch (element) {
        case ProductDetailsCurrentTab.SUMMARY:
          {
            items.add(BottomNavigationBarItem(
                icon: Icon(AppIcons.tab_barcode), label: "Fiche"));
          }
          break;

        case ProductDetailsCurrentTab.INFO:
          {
            items.add(BottomNavigationBarItem(
                icon: Icon(AppIcons.tab_fridge), label: "Caractéristiques"));
          }
          break;

        case ProductDetailsCurrentTab.NUTRITION:
          {
            items.add(BottomNavigationBarItem(
                icon: Icon(AppIcons.tab_nutrition), label: "Nutrition"));
          }
          break;

        case ProductDetailsCurrentTab.NUTRITIONAL_VALUES:
          {
            items.add(BottomNavigationBarItem(
                icon: Icon(AppIcons.tab_array), label: "Tableau"));
          }
          break;
      }
    });

    return items;
  }
}

enum ProductDetailsCurrentTab { SUMMARY, INFO, NUTRITION, NUTRITIONAL_VALUES }

class ProductImage extends StatelessWidget {
  const ProductImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    APIProduct? product = ProductHolder.of(context)?.product;
    print(product?.picture);

    return Container(
      width: double.infinity,
      child: Image.network(''),
    );
  }
}

class ProductDetails extends StatelessWidget {
  const ProductDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.only(
      topLeft: Radius.circular(16.0),
      topRight: Radius.circular(16.0),
    );

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: borderRadius,
      ),
      child: SingleChildScrollView(
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductTitle(),
                const SizedBox(
                  height: 10.0,
                ),
                ProductInfo(),
                const SizedBox(
                  height: 10.0,
                ),
                ProductFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductHolder extends InheritedWidget {
  final APIProduct? product;

  const ProductHolder({
    required this.product,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  static ProductHolder? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ProductHolder>();
  }

  @override
  bool updateShouldNotify(ProductHolder old) => product != old.product;
}

class ProductTitle extends StatelessWidget {
  const ProductTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    APIProduct? product = ProductHolder.of(context)?.product;

    if (product == null) {
      return SizedBox();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name ?? '',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(product.brands?.join(',') ?? ''),
        const SizedBox(
          height: 8.0,
        ),
        Text('Ligne 3'),
      ],
    );
  }
}

class ProductInfo extends StatelessWidget {
  const ProductInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.gray1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ProductInfoLine1(),
          Divider(),
          ProductInfoLine2(),
        ],
      ),
    );
  }
}

class ProductInfoLine1 extends StatelessWidget {
  const ProductInfoLine1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 45,
            child: ProductInfoNutriScore(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(),
          ),
          Expanded(
            flex: 55,
            child: ProductInfoNova(),
          ),
        ],
      ),
    );
  }
}

class ProductInfoNutriScore extends StatelessWidget {
  const ProductInfoNutriScore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nutri-Score'),
        Image.asset(AppImages.nutriscoreA),
      ],
    );
  }
}

class ProductInfoNova extends StatelessWidget {
  const ProductInfoNova({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Groupe Nova'),
        Text('Lorem ipsum'),
      ],
    );
  }
}

class ProductInfoLine2 extends StatelessWidget {
  const ProductInfoLine2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('EcoScore'),
          Row(
            children: [
              Icon(AppIcons.ecoscore_a),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Text('Impact environnemental'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ProductFields extends StatelessWidget {
  const ProductFields({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProductField(
          label: 'Quantité',
          value: '200g',
          divider: true,
        ),
        ProductField(
          label: 'Vendu',
          value: 'France',
          divider: false,
        ),
      ],
    );
  }
}

class ProductField extends StatelessWidget {
  final String label;
  final String value;
  final bool divider;

  ProductField({
    required this.label,
    required this.value,
    this.divider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                // flex: 1,
                child: Text(label),
              ),
              Expanded(
                // flex: 1,
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
