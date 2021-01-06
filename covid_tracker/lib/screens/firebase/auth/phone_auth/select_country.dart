import 'package:covid_tracker/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid_tracker/models/country.dart';
import 'package:covid_tracker/providers/countries.dart';
import 'package:covid_tracker/widgets/auth_widgets.dart';
import 'package:provider/provider.dart';

class SelectCountry extends StatelessWidget {
  static const routeName = '/select_country';
  @override
  Widget build(BuildContext context) {
    final countriesProvider = Provider.of<CountryProvider>(context);
    return Scaffold(
      backgroundColor: DarkTheme.background,
      appBar: AppBar(
        title: Text(
          'Search your country',
          style: TextStyle(
              color: DarkTheme.primaryText, fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              CupertinoIcons.left_chevron,
              color: DarkTheme.primary,
            ),
            onPressed: () => Navigator.of(context).pop()),
        backgroundColor: DarkTheme.appBar,
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 60.0),
          child:
              SearchCountryTF(controller: countriesProvider.searchController),
        ),
      ),
      body: CupertinoScrollbar(
        child: ListView.builder(
          itemCount: countriesProvider.searchResults.length,
          itemBuilder: (BuildContext context, int i) {
            return SelectableWidget(
              country: countriesProvider.searchResults[i],
              selectThisCountry: (Country c) {
                print(i);
                countriesProvider.selectedCountry = c;
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
    );
  }
}
