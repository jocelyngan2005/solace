import 'package:flutter/material.dart';

class SoundtrackLibrary extends StatefulWidget {
  final String? selectedSoundtrack;
  final Set<String> favoriteSoundtracks;
  final Function(String?) onSoundtrackSelected;
  final Function(Set<String>) onFavoritesUpdated;

  const SoundtrackLibrary({
    super.key,
    this.selectedSoundtrack,
    this.favoriteSoundtracks = const {},
    required this.onSoundtrackSelected,
    required this.onFavoritesUpdated,
  });

  @override
  State<SoundtrackLibrary> createState() => _SoundtrackLibraryState();
}

class _SoundtrackLibraryState extends State<SoundtrackLibrary> {
  String? selectedSoundtrack;
  final TextEditingController _searchController = TextEditingController();
  List<SoundtrackItem> filteredSoundtracks = [];
  Set<String> favoriteSoundtracks = {};
  bool showFavoritesOnly = false;

  final List<SoundtrackItem> soundtracks = [
    SoundtrackItem(
      id: 'none',
      name: 'No Sound',
      description: 'Pure silence for focused breathing',
      icon: Icons.volume_off,
      color: Colors.grey,
    ),
    SoundtrackItem(
      id: 'mountain_stream',
      name: 'Mountain Stream',
      description: 'Gentle water flowing over stones',
      icon: Icons.water,
      color: Colors.teal,
    ),
    SoundtrackItem(
      id: 'zen_garden',
      name: 'Zen Garden',
      description: 'Peaceful meditation sounds',
      icon: Icons.spa,
      color: Colors.orange,
    ),
    SoundtrackItem(
      id: 'chirping_birds',
      name: 'Chirping Birds',
      description: 'Peaceful bird songs from a morning forest',
      icon: Icons.park,
      color: Colors.green,
    ),
    SoundtrackItem(
      id: 'starry_night',
      name: 'Starry Night',
      description: 'Calm nighttime ambience',
      icon: Icons.nights_stay,
      color: Colors.indigo,
    ),
    SoundtrackItem(
      id: 'ocean',
      name: 'Ocean Waves',
      description: 'Gentle waves lapping against the shore',
      icon: Icons.waves,
      color: Colors.blue,
    ),
    SoundtrackItem(
      id: 'rain',
      name: 'Rain Drops',
      description: 'Soft rainfall on leaves and windows',
      icon: Icons.grain,
      color: Colors.indigo,
    ),
    SoundtrackItem(
      id: 'forest',
      name: 'Forest Ambience',
      description: 'Deep woods with rustling leaves',
      icon: Icons.forest,
      color: Colors.brown,
    ),
    SoundtrackItem(
      id: 'wind',
      name: 'Gentle Wind',
      description: 'Soft breeze through open meadows',
      icon: Icons.air,
      color: Colors.cyan,
    ),
    SoundtrackItem(
      id: 'fireplace',
      name: 'Fireplace',
      description: 'Crackling fire for cozy relaxation',
      icon: Icons.fireplace,
      color: Colors.orange,
    ),
  ];

  @override
  void initState() {
    super.initState();
    favoriteSoundtracks = widget.favoriteSoundtracks;
    selectedSoundtrack = widget.selectedSoundtrack;
    filteredSoundtracks = soundtracks; // Initialize with all soundtracks
    _searchController.addListener(() {
      _filterSoundtracks(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterSoundtracks(String query) {
    setState(() {
      List<SoundtrackItem> baseList = soundtracks;
      
      // First filter by favorites if showing favorites only
      if (showFavoritesOnly) {
        baseList = soundtracks.where((soundtrack) =>
            favoriteSoundtracks.contains(soundtrack.id)).toList();
      }
      
      // Then filter by search query
      if (query.isEmpty) {
        filteredSoundtracks = baseList;
      } else {
        filteredSoundtracks = baseList.where((soundtrack) {
          return soundtrack.name.toLowerCase().contains(query.toLowerCase()) ||
                 soundtrack.description.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _toggleFavorite(String soundtrackId) {
    setState(() {
      if (favoriteSoundtracks.contains(soundtrackId)) {
        favoriteSoundtracks.remove(soundtrackId);
      } else {
        favoriteSoundtracks.add(soundtrackId);
      }
      // Notify parent widget about favorites update
      widget.onFavoritesUpdated(favoriteSoundtracks);
      // Refresh the filtered list if showing favorites only
      if (showFavoritesOnly) {
        _filterSoundtracks(_searchController.text);
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filterSoundtracks('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Soundtrack Library',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
            ),
            onPressed: () {
              setState(() {
                showFavoritesOnly = !showFavoritesOnly;
                _filterSoundtracks(_searchController.text);
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32), 
              // Header
              Center(
              child: Text(
                'Select Soundscapes',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                ),
              ),
              ),
              
              const SizedBox(height: 20), 
              
              // Search Bar
              Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                Icon(Icons.search, color:Theme.of(context).colorScheme.onSurface, size: 16),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search soundscapes...',
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                    onChanged: _filterSoundtracks,
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  GestureDetector(
                    onTap: _clearSearch,
                    child: Icon(
                      Icons.clear,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 16,
                    ),
                  ),
                ],
              ),
              ),
              
              const SizedBox(height: 80),
              
              // Soundtrack waves, currently just dots
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(20, (index) {
                return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.outline,
                ),
                );
              }),
              ),
              
              const SizedBox(height: 80),
              
              // Soundtrack horizontal scrollable chips
              SizedBox(
              height: 48,
              child: filteredSoundtracks.isEmpty
                ? Center(
                    child: Text(
                      'No soundscapes found',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  )
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredSoundtracks.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                    final soundtrack = filteredSoundtracks[index];
                    final isSelected = selectedSoundtrack == soundtrack.id;
                return GestureDetector(
                  onTap: () {
                  setState(() {
                    selectedSoundtrack = soundtrack.id;
                  });
                  },
                  child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                      ? Theme.of(context).colorScheme.tertiary
                      : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                    color: isSelected
                      ? Theme.of(context).colorScheme.tertiary.withOpacity(0.5)
                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                    ),
                    boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    Icon(
                      soundtrack.icon, 
                      color: isSelected
                        ? Theme.of(context).colorScheme.surface
                        : soundtrack.color,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      soundtrack.name,
                      style: TextStyle(
                      color: isSelected
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      ),
                    ),
                    ],
                  ),
                  ),
                );
                },
              ),
              ),
              
              // Spacer to push button to bottom
              const Spacer(),

              // Continue Button at the bottom
              SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                Navigator.pop(context, selectedSoundtrack);
                },
                style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onSurface,
                foregroundColor: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
                ),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
                ),
              ),
              ),
            ],
            
          ),
        ),
      ),
    );
  }
}

class SoundtrackItem {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  SoundtrackItem({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}
