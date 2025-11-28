import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../viewmodels/sharing_viewmodel.dart';

class SharingView extends StatefulWidget {
  const SharingView({Key? key}) : super(key: key);

  @override
  State<SharingView> createState() => _SharingViewState();
}

class _SharingViewState extends State<SharingView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SharingViewModel>().loadUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Compartilhar Conquistas',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer<SharingViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Seção de Perfil
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.teal[100],
                          shape: BoxShape.circle,
                        ),
                        child: viewModel.userPhotoUrl.isNotEmpty
                            ? ClipOval(
                          child: Image.network(
                            viewModel.userPhotoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.account_circle,
                                size: 100,
                                color: Colors.teal[700],
                              );
                            },
                          ),
                        )
                            : Icon(
                          Icons.account_circle,
                          size: 100,
                          color: Colors.teal[700],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nome e Estatísticas
                      Text(
                        viewModel.userName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                viewModel.totalPoints.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.teal[700],
                                ),
                              ),
                              Text(
                                'Pontos',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 24),
                          Column(
                            children: [
                              Text(
                                viewModel.completedHabits.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.teal[700],
                                ),
                              ),
                              Text(
                                'Hábitos',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 24),
                          Column(
                            children: [
                              Text(
                                viewModel.currentStreak.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.orange,
                                ),
                              ),
                              Text(
                                'Dias',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Seção de Compartilhamentos Rápidos
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Compartilhamentos Rápidos',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _ShareButton(
                        icon: Icons.check_circle,
                        label: 'Progresso',
                        color: Colors.teal,
                        onTap: () => viewModel.shareProgress(context),
                      ),
                      _ShareButton(
                        icon: Icons.emoji_events,
                        label: 'Conquistas',
                        color: Colors.amber,
                        onTap: () => viewModel.shareAchievements(context),
                      ),
                      _ShareButton(
                        icon: Icons.local_fire_department,
                        label: 'Sequência',
                        color: Colors.orange,
                        onTap: () => viewModel.shareStreak(context),
                      ),
                      _ShareButton(
                        icon: Icons.star,
                        label: 'Pontos',
                        color: Colors.purple,
                        onTap: () => viewModel.sharePoints(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Seção de Redes Sociais
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Conectar Redes Sociais',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _SocialNetworkTile(
                        icon: Icons.facebook,
                        label: 'Facebook',
                        isConnected: viewModel.isFacebookConnected,
                        onTap: () => viewModel.connectFacebook(context),
                      ),
                      const SizedBox(height: 8),
                      _SocialNetworkTile(
                        icon: Icons.public,
                        label: 'Twitter/X',
                        isConnected: viewModel.isTwitterConnected,
                        onTap: () => viewModel.connectTwitter(context),
                      ),
                      const SizedBox(height: 8),
                      _SocialNetworkTile(
                        icon: Icons.camera_alt,
                        label: 'Instagram',
                        isConnected: viewModel.isInstagramConnected,
                        onTap: () => viewModel.connectInstagram(context),
                      ),
                      const SizedBox(height: 8),
                      _SocialNetworkTile(
                        icon: Icons.mail,
                        label: 'WhatsApp',
                        isConnected: viewModel.isWhatsappConnected,
                        onTap: () => viewModel.shareViaWhatsapp(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Seção de Histórico
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Histórico de Compartilhamentos',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                if (viewModel.shareHistory.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Nenhum compartilhamento ainda',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.shareHistory.length,
                      itemBuilder: (context, index) {
                        final share = viewModel.shareHistory[index];
                        // ✅ Usa ?? para valores padrão
                        final type = share['type'] ?? 'Compartilhamento';
                        final platform = share['platform'] ?? 'desconhecido';
                        final date = share['date'] ?? 'Data desconhecida';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getSocialIcon(platform),
                                color: Colors.teal[700],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      type,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      date,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }

  IconData _getSocialIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'facebook':
        return Icons.facebook;
      case 'twitter':
        return Icons.public;
      case 'instagram':
        return Icons.camera_alt;
      case 'whatsapp':
        return Icons.mail;
      default:
        return Icons.share;
    }
  }
}

// Widget para botão de compartilhamento rápido
class _ShareButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ShareButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para rede social
class _SocialNetworkTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isConnected;
  final VoidCallback onTap;

  const _SocialNetworkTile({
    required this.icon,
    required this.label,
    required this.isConnected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isConnected ? Colors.teal[200]! : Colors.grey[300]!,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.teal[700], size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isConnected ? Colors.green[100] : Colors.grey[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                isConnected ? 'Conectado' : 'Conectar',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isConnected ? Colors.green[700] : Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}