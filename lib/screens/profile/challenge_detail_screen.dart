import 'package:flutter/material.dart';
import '../../data/weekly_challenges.dart';
import '../../data/weekly_challenge_service.dart';
import '../../widgets/dashboard_card.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final WeeklyChallenge challenge;
  final WeeklyChallengeService challengeService;
  final VoidCallback? onUpdate;

  const ChallengeDetailScreen({
    super.key,
    required this.challenge,
    required this.challengeService,
    this.onUpdate,
  });

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  late WeeklyChallenge _challenge;

  @override
  void initState() {
    super.initState();
    _challenge = widget.challenge;
  }

  void _refreshChallenge() {
    final updatedChallenge = widget.challengeService.getChallenge(_challenge.id);
    if (updatedChallenge != null) {
      setState(() {
        _challenge = updatedChallenge;
      });
      widget.onUpdate?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_challenge.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_challenge.status == ChallengeStatus.inProgress)
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: _showChallengeOptions,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            _buildHeaderCard(),
            
            const SizedBox(height: 16),

            // Progress Card (if active)
            if (_challenge.status == ChallengeStatus.inProgress) ...[
              _buildProgressCard(),
              const SizedBox(height: 16),
            ],

            // Description Card
            _buildDescriptionCard(),
            
            const SizedBox(height: 16),

            // Tasks Card
            _buildTasksCard(),
            
            const SizedBox(height: 16),

            // Tips Card
            _buildTipsCard(),
            
            const SizedBox(height: 16),

            // Action Buttons
            _buildActionButtons(),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _challenge.primaryColor.withOpacity(0.1),
              _challenge.accentColor.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _challenge.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _challenge.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _challenge.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _challenge.description,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Challenge Info Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildInfoChip(
                  _challenge.typeLabel,
                  _challenge.primaryColor,
                  Icons.category,
                ),
                _buildInfoChip(
                  _challenge.difficultyLabel,
                  _getDifficultyColor(_challenge.difficulty),
                  Icons.signal_cellular_alt,
                ),
                _buildInfoChip(
                  '${_challenge.durationDays} days',
                  Colors.blue,
                  Icons.schedule,
                ),
                _buildInfoChip(
                  '${_challenge.xpReward} XP',
                  Colors.amber,
                  Icons.star,
                ),
              ],
            ),

            // Status Info
            if (_challenge.status != ChallengeStatus.notStarted) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getStatusColor(_challenge.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getStatusIcon(_challenge.status),
                      color: _getStatusColor(_challenge.status),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getStatusText(_challenge.status),
                      style: TextStyle(
                        color: _getStatusColor(_challenge.status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (_challenge.status == ChallengeStatus.inProgress && 
                        _challenge.daysRemaining > 0) ...[
                      const Spacer(),
                      Text(
                        '${_challenge.daysRemaining} days left',
                        style: TextStyle(
                          color: _challenge.daysRemaining <= 2 
                            ? Colors.red 
                            : Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return DashboardCard(
      title: '📈 Progress',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_challenge.currentProgress} / ${_challenge.targetCount}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${(_challenge.progressPercentage * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _challenge.primaryColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          LinearProgressIndicator(
            value: _challenge.progressPercentage,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(_challenge.primaryColor),
            minHeight: 8,
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _updateProgress,
                  icon: const Icon(Icons.add),
                  label: const Text('Update Progress'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _challenge.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _showProgressHistory,
                icon: const Icon(Icons.history),
                label: const Text('History'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return DashboardCard(
      title: '📖 About This Challenge',
      child: Text(
        _challenge.detailedDescription,
        style: const TextStyle(
          fontSize: 16,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildTasksCard() {
    return DashboardCard(
      title: '✅ Daily Tasks',
      child: Column(
        children: _challenge.tasks.map((task) => _buildTaskItem(task)).toList(),
      ),
    );
  }

  Widget _buildTaskItem(ChallengeTask task) {
    final isCompleted = task.isCompleted;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCompleted 
          ? Colors.green.withOpacity(0.1) 
          : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCompleted 
            ? Colors.green.withOpacity(0.3) 
            : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _toggleTaskCompletion(task),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : Colors.transparent,
                border: Border.all(
                  color: isCompleted ? Colors.green : Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isCompleted
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  )
                : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    decoration: isCompleted 
                      ? TextDecoration.lineThrough 
                      : TextDecoration.none,
                  ),
                ),
                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    task.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      decoration: isCompleted 
                        ? TextDecoration.lineThrough 
                        : TextDecoration.none,
                    ),
                  ),
                ],
                if (isCompleted && task.completedDate != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Completed ${_formatDate(task.completedDate!)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return DashboardCard(
      title: '💡 Tips for Success',
      child: Column(
        children: _challenge.tips.map((tip) => _buildTipItem(tip)).toList(),
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: _challenge.primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    switch (_challenge.status) {
      case ChallengeStatus.notStarted:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _startChallenge,
            style: ElevatedButton.styleFrom(
              backgroundColor: _challenge.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Start Challenge',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        );
      
      case ChallengeStatus.inProgress:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _abandonChallenge,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Abandon Challenge'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _updateProgress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _challenge.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Update Progress'),
              ),
            ),
          ],
        );
      
      case ChallengeStatus.completed:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                'Challenge Completed! 🎉',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildInfoChip(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(ChallengeDifficulty difficulty) {
    switch (difficulty) {
      case ChallengeDifficulty.beginner:
        return Colors.green;
      case ChallengeDifficulty.intermediate:
        return Colors.orange;
      case ChallengeDifficulty.advanced:
        return Colors.red;
    }
  }

  Color _getStatusColor(ChallengeStatus status) {
    switch (status) {
      case ChallengeStatus.notStarted:
        return Colors.grey;
      case ChallengeStatus.inProgress:
        return Colors.blue;
      case ChallengeStatus.completed:
        return Colors.green;
      case ChallengeStatus.expired:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(ChallengeStatus status) {
    switch (status) {
      case ChallengeStatus.notStarted:
        return Icons.hourglass_empty;
      case ChallengeStatus.inProgress:
        return Icons.play_arrow;
      case ChallengeStatus.completed:
        return Icons.check_circle;
      case ChallengeStatus.expired:
        return Icons.access_time;
    }
  }

  String _getStatusText(ChallengeStatus status) {
    switch (status) {
      case ChallengeStatus.notStarted:
        return 'Not Started';
      case ChallengeStatus.inProgress:
        return 'In Progress';
      case ChallengeStatus.completed:
        return 'Completed';
      case ChallengeStatus.expired:
        return 'Expired';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    
    if (diff == 0) {
      return 'today';
    } else if (diff == 1) {
      return 'yesterday';
    } else {
      return '${diff} days ago';
    }
  }

  Future<void> _startChallenge() async {
    final success = await widget.challengeService.startChallenge(_challenge.id);
    
    if (success) {
      _refreshChallenge();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Started "${_challenge.title}" challenge!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not start challenge. You may have too many active challenges.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updateProgress() async {
    final result = await widget.challengeService.updateProgress(
      _challenge.id,
      context: context,
    );
    
    if (result.success) {
      _refreshChallenge();
      
      if (result.challengeCompleted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 Challenge "${_challenge.title}" completed!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Progress updated!'),
          ),
        );
      }
    }
  }

  Future<void> _abandonChallenge() async {
    final shouldAbandon = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Abandon Challenge?'),
        content: const Text(
          'Are you sure you want to abandon this challenge? Your progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Abandon'),
          ),
        ],
      ),
    );

    if (shouldAbandon == true) {
      final success = await widget.challengeService.abandonChallenge(_challenge.id);
      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Challenge abandoned'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _toggleTaskCompletion(ChallengeTask task) async {
    if (_challenge.status != ChallengeStatus.inProgress) return;
    
    final success = await widget.challengeService.updateTaskCompletion(
      _challenge.id,
      task.id,
      !task.isCompleted,
    );
    
    if (success) {
      _refreshChallenge();
    }
  }

  void _showProgressHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Progress History'),
        content: const Text(
          'Progress history feature coming soon! This will show your daily progress and completion times.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showChallengeOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.pause),
              title: const Text('Pause Challenge'),
              subtitle: const Text('Temporarily pause this challenge'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement pause functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pause feature coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Challenge'),
              subtitle: const Text('Share with friends for motivation'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement share functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Share feature coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Abandon Challenge'),
              subtitle: const Text('Permanently abandon this challenge'),
              onTap: () {
                Navigator.pop(context);
                _abandonChallenge();
              },
            ),
          ],
        ),
      ),
    );
  }
}
