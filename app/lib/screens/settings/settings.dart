import 'package:dashboard/api/api.dart';
import 'package:dashboard/manager/manager.dart';
import 'package:dashboard/screens/settings/desktop/settings.dart';
import 'package:dashboard/updater/updater.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:dashboard/theme/theme.dart';
import 'package:dashboard/widgets/settings/settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String appVersion = '';
  String appBuild = '';
  late BackupRestoreManager _backupRestoreManager;

  // Metodo para exibir a versao
  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((packageInfo) {
      setState(() {
        appVersion = packageInfo.version;
        appBuild = packageInfo.buildNumber;
      });
    });

    _backupRestoreManager = BackupRestoreManager(
      context: context,
      apiUrl: apiUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return _buildSmallScreenLayout(context);
        } else {
          return _buildLargeScreenLayout(context);
        }
      },
    );
  }

  Widget _buildSmallScreenLayout(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configurações',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            title: 'Personalização',
            icon: Icons.color_lens,
            children: [
              ThemeSettings(themeModel: themeModel),
            ],
          ),
          _buildCard(
            title: 'Backup e Restauração',
            icon: Icons.backup,
            children: [
              _buildElevatedButton(
                text: 'Fazer Backup',
                icon: Icons.cloud_upload,
                onPressed: _backupRestoreManager.backup,
              ),
              _buildElevatedButton(
                text: 'Restaurar Backup',
                icon: Icons.cloud_download,
                onPressed: _backupRestoreManager.restore,
              ),
            ],
          ),
          _buildCard(
            title: 'Informações do Sistema',
            icon: Icons.info,
            children: [
              _buildInfoRow('Versão', '$appVersion | Build: ($appBuild)'),
            ],
          ),
          _buildCard(
            title: 'Atualizações',
            icon: Icons.update,
            children: [
              ListTile(
                subtitle: const Text("Toque para buscar novas versões"),
                onTap: () {
                  Updater.checkForUpdates(context);
                },
              ),
            ],
          ),
          _buildCard(
            title: 'Outros',
            icon: Icons.library_books,
            children: [
              ListTile(
                title: const Text("Licenças"),
                subtitle: const Text(
                    "Softwares de terceiros usados na construção da plataforma"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LicensePage(
                        applicationName: "Dashboard",
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLargeScreenLayout(BuildContext context) {
    return const SettingsScreenDesktop();
  }

  Widget _buildCard(
      {required String title,
      required IconData icon,
      required List<Widget> children}) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildElevatedButton(
      {required String text,
      required IconData icon,
      required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, [String value = '']) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          if (value.isNotEmpty)
            Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
