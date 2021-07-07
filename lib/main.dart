import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
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

  Widget _details = ProductDetails();
  Widget _informations = ProductInformation();

  Widget getBody(APIProduct product) {
    if (this.currentTab == ProductDetailsCurrentTab.SUMMARY) {
      return SizedBox.expand(
        child: ProductHolder(
          product: product,
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
                child: _details,
              )
            ],
          ),
        ),
      );
    } else if (this.currentTab == ProductDetailsCurrentTab.INFO) {
      return SizedBox.expand(
        child: ProductHolder(
          product: product,
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
                child: _informations,
              )
            ],
          ),
        ),
      );
    } else if (this.currentTab == ProductDetailsCurrentTab.NUTRITION) {
      return SizedBox.expand(
        child: ProductHolder(
          product: product,
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
                child: _informations,
              )
            ],
          ),
        ),
      );
    } else if (this.currentTab == ProductDetailsCurrentTab.NUTRITIONAL_VALUES) {
      return SizedBox.expand(
        child: ProductHolder(
          product: product,
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
                child: _details,
              )
            ],
          ),
        ),
      );
    }
    return SizedBox.expand(
      child: ProductHolder(
        product: product,
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
              child: _details,
            )
          ],
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => bloc,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => HomePage()));
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  print(
                      'https://fr.openfoodfacts.org/produit/${widget.barcode}');
                  Share.share(
                      'https://fr.openfoodfacts.org/produit/${widget.barcode}',
                      subject: 'Miam');
                },
              ),
            ],
          ),
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
              return this.getBody(state.product!);
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          }),
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: getItems(),
              currentIndex: currentTab.index,
              onTap: (int index) {
                this.onTapHandler(index);
              },
              unselectedItemColor: AppColors.gray2,
              selectedItemColor: AppColors.primaryColor),
        ));
  }
}

enum ProductDetailsCurrentTab { SUMMARY, INFO, NUTRITION, NUTRITIONAL_VALUES }

class ProductImage extends StatelessWidget {
  const ProductImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    APIProduct? product = ProductHolder.of(context)?.product;
    String? url = product?.pictures?.product;

    if (url != null) {
      String urlB = url;
      return Container(
        width: double.infinity,
        child: Image.network(urlB),
      );
    }

    return Container(
      width: double.infinity,
      height: 300,
      color: AppColors.blue,
    );
  }
}

class ProductInformation extends StatelessWidget {
  const ProductInformation({Key? key}) : super(key: key);

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
              ],
            ),
          ),
        ),
      ),
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
        Text(product.altName ?? ''),
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
    APIProduct? product = ProductHolder.of(context)?.product;

    if (product == null) {
      return SizedBox();
    }

    APIProductNutriscore? nutriScore = product.nutriScore;
    if (nutriScore != null) {
      String nutriScoreImage = AppImages.nutriscoreA;

      switch (nutriScore) {
        case APIProductNutriscore.A:
          {
            nutriScoreImage = AppImages.nutriscoreA;
          }
          break;

        case APIProductNutriscore.B:
          {
            nutriScoreImage = AppImages.nutriscoreB;
          }
          break;

        case APIProductNutriscore.C:
          {
            nutriScoreImage = AppImages.nutriscoreC;
          }
          break;

        case APIProductNutriscore.D:
          {
            nutriScoreImage = AppImages.nutriscoreD;
          }
          break;

        case APIProductNutriscore.E:
          {
            nutriScoreImage = AppImages.nutriscoreE;
          }
          break;
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nutri-Score'),
          Image.asset(nutriScoreImage),
        ],
      );
    }

    return SizedBox();
  }
}

class ProductInfoNova extends StatelessWidget {
  const ProductInfoNova({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    APIProduct? product = ProductHolder.of(context)?.product;

    if (product == null) {
      return SizedBox();
    }

    APIProductNovaScore? novaScore = product.novaScore;
    if (novaScore != null) {
      String groupText = 'Groupe Inconnu';

      switch (novaScore) {
        case APIProductNovaScore.Group1:
          {
            groupText = 'Groupe 1';
          }
          break;

        case APIProductNovaScore.Group2:
          {
            groupText = 'Groupe 2';
          }
          break;

        case APIProductNovaScore.Group3:
          {
            groupText = 'Groupe 3';
          }
          break;

        case APIProductNovaScore.Group4:
          {
            groupText = 'Groupe 4';
          }
          break;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Groupe Nova'),
          Text(groupText),
        ],
      );
    }

    return SizedBox();
  }
}

class ProductInfoLine2 extends StatelessWidget {
  const ProductInfoLine2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    APIProduct? product = ProductHolder.of(context)?.product;

    if (product == null) {
      return SizedBox();
    }

    APIProductEcoScore? ecoScore = product.ecoScore;
    if (ecoScore != null) {
      IconData ecoScoreIcon = AppIcons.ecoscore_a;

      switch (ecoScore) {
        case APIProductEcoScore.A:
          {
            ecoScoreIcon = AppIcons.ecoscore_a;
          }
          break;

        case APIProductEcoScore.B:
          {
            ecoScoreIcon = AppIcons.ecoscore_b;
          }
          break;

        case APIProductEcoScore.C:
          {
            ecoScoreIcon = AppIcons.ecoscore_c;
          }
          break;

        case APIProductEcoScore.D:
          {
            ecoScoreIcon = AppIcons.ecoscore_d;
          }
          break;

        case APIProductEcoScore.E:
          {
            ecoScoreIcon = AppIcons.ecoscore_e;
          }
          break;
      }

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('EcoScore'),
            Row(
              children: [
                Icon(ecoScoreIcon),
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

    return SizedBox();
  }
}

class ProductFields extends StatelessWidget {
  const ProductFields({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    APIProduct? product = ProductHolder.of(context)?.product;

    if (product == null) {
      return SizedBox();
    }

    String? quantity = product.quantity;
    List<String>? manufacturingCountries = product.manufacturingCountries;
    if (quantity != null && manufacturingCountries != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProductField(
            label: 'Quantité',
            value: quantity,
            divider: true,
          ),
          ProductField(
            label: 'Vendu',
            value: manufacturingCountries.join(',').toString(),
            divider: false,
          ),
        ],
      );
    }

    return SizedBox();
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
