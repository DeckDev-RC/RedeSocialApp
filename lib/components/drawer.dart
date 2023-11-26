import 'package:app_2/components/my_list_tile.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final Function()? onProfileTap;
  final Function()? onSignOut;
  final Function()? onUsersTap;
  const MyDrawer({
    super.key,
    required this.onProfileTap,
    required this.onSignOut,
    required this.onUsersTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //cabeçalho
              DrawerHeader(
                child: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  size: 64,
                ),
              ),

              const SizedBox(height: 25),

              //home list tile
              MyListTile(
                icon: Icons.home,
                text: 'H O M E',
                onTap: () => Navigator.pop(context),
              ),

              //perfil list tile
              MyListTile(
                icon: Icons.person,
                text: 'P E R F I L',
                onTap: onProfileTap,
              ),

              MyListTile(
                icon: Icons.group,
                text: 'U S U Á R I O S',
                onTap: onUsersTap,
              )
            ],
          ),

          //logout list tile
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(
              icon: Icons.logout,
              text: 'S A I R',
              onTap: onSignOut,
            ),
          ),
        ],
      ),
    );
  }
}
