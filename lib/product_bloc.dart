// En entrée
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yuka/network/api_product.dart';

import 'network/network_api.dart';

abstract class ProductEvent {}

class FetchProductEvent extends ProductEvent {
  final String barcode;

  FetchProductEvent(this.barcode);
}

class ProductFetchedEvent extends ProductEvent {
  final APIProduct product;

  ProductFetchedEvent(this.product);
}

// En sortie
abstract class ProductState {
  final APIProduct? product;

  ProductState(this.product);
}

class InitialState extends ProductState {
  InitialState() : super(null);
}

class ProductLoadingState extends ProductState {
  ProductLoadingState() : super(null);
}

class ProductAvailableState extends ProductState {
  ProductAvailableState(APIProduct product) : super(product);
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final BehaviorSubject<APIProduct> _subject = BehaviorSubject<APIProduct>();
  // Donner la valeur initiale
  ProductBloc() : super(InitialState());

  fetchProduct(String barcode) {
    add(FetchProductEvent(barcode));
  }

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is FetchProductEvent) {
      yield ProductLoadingState();
      String barcode = event.barcode;

      // Requête
      //yield ProductAvailableState(Product(
      //  barcode: barcode,
      //  name: 'Petits pois et carottes',
      //  brands: <String>['Cassegrain'],
      //));
      OpenFoodFactsAPI api = OpenFoodFactsAPI(
        Dio(),
        baseUrl: 'https://api.formation-android.fr/v2',
      );

      api.findProductWithResponse(barcode: barcode).then((response) => {
            add(ProductFetchedEvent(APIProduct.fromJson(
                response.toJson()['response'] as Map<String, dynamic>)))
          });
    }

    if (event is ProductFetchedEvent) {
      _subject.sink.add(event.product);
      yield ProductAvailableState(event.product);
    }
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<APIProduct> get subject => _subject;
}

final bloc = ProductBloc();
