import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData fusionBlue = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.white,
        brightness: Brightness.light,
        dynamicSchemeVariant: DynamicSchemeVariant.neutral,
      ),
      applyElevationOverlayColor: false,
      scaffoldBackgroundColor: Colors.white,
      //text
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
            color: Colors.blueAccent,
            fontSize: 14,
            fontWeight: FontWeight.bold),
        displayMedium: TextStyle(
            color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: Colors.black87, fontSize: 12),
        labelMedium: TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
      ),

      //List Tile
      listTileTheme: const ListTileThemeData(
          iconColor: Colors.blueAccent,
          minVerticalPadding: 5,
          titleTextStyle:
              TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
          subtitleTextStyle:
              TextStyle(color: Colors.grey, fontStyle: FontStyle.normal),
          contentPadding: EdgeInsets.all(10)),

      //Dropdown Menu
      dropdownMenuTheme: DropdownMenuThemeData(
          menuStyle: MenuStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.white))),

      //Input
      inputDecorationTheme: const InputDecorationTheme(
          prefixIconColor: Colors.black87,
          floatingLabelStyle: TextStyle(color: Colors.blueAccent),
          labelStyle: TextStyle(color: Colors.grey),
          errorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent))),

      //Tab Menu
      tabBarTheme: const TabBarThemeData(
          labelColor: Colors.blueAccent,
          indicatorColor: Colors.blueAccent,
          unselectedLabelColor: Colors.grey),

      //Card View
      cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: Colors.black12, width: 1),
          )),

      //App Bar
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
              fontSize: 20)),

      //Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.blue))),
      //Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blueAccent),

      //Button Navi Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          elevation: 0.0,
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.blueAccent
          ),
      useMaterial3: true);
}
