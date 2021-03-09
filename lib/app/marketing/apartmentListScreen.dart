import 'package:flutter/material.dart';

import '../../util/index.dart' show Http, AppTheme, TextStyleHelpers;
import '../../models/index.dart' show ApartmentServicesModel;
import '../../widgets/index.dart'
    show BotigaAppBar, SearchBar, LoaderOverlay, Toast;

import 'apartmentDetailScreen.dart';

class ApartmentListScreen extends StatefulWidget {
  @override
  _ApartmentListScreenState createState() => _ApartmentListScreenState();
}

class _ApartmentListScreenState extends State<ApartmentListScreen> {
  final List<ApartmentServicesModel> _apartments = [];
  String _query = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 300), () => _getApartments());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar('Apartments'),
      body: SafeArea(
        child: Container(
          color: AppTheme.backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SearchBar(
                placeholder: 'Filter',
                onSubmit: (value) {
                  setState(() {
                    _query = value;
                    _getApartments();
                  });
                },
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: LoaderOverlay(
                  isLoading: _isLoading,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: ListView.builder(
                      itemCount: _apartments.length + 1,
                      itemBuilder: (context, index) {
                        return index < _apartments.length
                            ? _apartmentTile(index)
                            : _missingApartmentMessage();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _apartmentTile(int index) {
    final apartment = _apartments[index];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ApartmentDetailScreen(apartment),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.0),
          Text(
            apartment.name,
            style: AppTheme.textStyle.w500.color100.size(17.0).lineHeight(1.3),
          ),
          SizedBox(height: 8.0),
          Text(
            '${apartment.area}, ${apartment.city}, ${apartment.state} - ${apartment.pincode}',
            style: AppTheme.textStyle.w500.color50.size(13.0).lineHeight(1.5),
          ),
          SizedBox(height: 20.0),
          Divider(
            thickness: 1.0,
            color: AppTheme.dividerColor,
          ),
        ],
      ),
    );
  }

  Widget _missingApartmentMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0),
        Text(
          'Don’t find your apartment?',
          style: AppTheme.textStyle.w500.color100.size(13.0).lineHeight(1.5),
        ),
        SizedBox(height: 8.0),
        Text(
          'Please stay tuned, we are expanding rapidly to apartments.',
          style: AppTheme.textStyle.w500.color50.size(13.0).lineHeight(1.5),
        ),
        SizedBox(height: 100.0),
      ],
    );
  }

  Future<void> _getApartments() async {
    setState(() => _isLoading = true);
    try {
      final json =
          await Http.get('/api/services/apartments/search?text=$_query');
      _apartments.clear();
      json.forEach(
        (apartment) => _apartments.add(
          ApartmentServicesModel.fromJson(apartment),
        ),
      );
    } catch (error) {
      Toast(message: Http.message(error)).show(context);
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
