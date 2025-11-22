
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/buttons/app_text_button.dart';
import 'group_recommended_groups.dart';

class GroupReviewsTab extends StatelessWidget {
  const GroupReviewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual data from GroupEntity
    final reviews = _getDummyReviews();
    final ratingStats = _calculateRatingStats(reviews);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        // Ratings Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ratings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.foreground,
                ),
              ),
              const SizedBox(height: 16),
              _buildRatingsCard(ratingStats),
            ],
          ),
        ),
        const SizedBox(height: 32),
        // Reviews Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.foreground,
                ),
              ),
              AppTextButton(
                text: 'See all',
                onPressed: () {
                  // TODO: Navigate to all reviews
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildReviewsList(reviews),
        const SizedBox(height: 24),
        const GroupRecommendedGroups(),
      ],
    );
  }

  Widget _buildRatingsCard(Map<String, dynamic> stats) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Average Rating
          Column(
            children: [
              Text(
                stats['average'].toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.foreground,
                ),
              ),
              const SizedBox(height: 8),
              _buildStars(stats['average']),
              const SizedBox(height: 4),
              Text(
                '${stats['total']} ratings',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.mutedForeground,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          // Rating Distribution
          Expanded(
            child: Column(
              children: [
                for (int i = 5; i >= 1; i--)
                  _buildRatingBar(
                    stars: i,
                    count: stats['distribution'][i] ?? 0,
                    total: stats['total'],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star : Icons.star_border,
          size: 16,
          color: Colors.red,
        );
      }),
    );
  }

  Widget _buildRatingBar({
    required int stars,
    required int count,
    required int total,
  }) {
    final percentage = total > 0 ? (count / total * 100) : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Star label
          SizedBox(
            width: 48,
            child: Row(
              children: [
                Text(
                  '$stars',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.foreground,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.star,
                  size: 12,
                  color: AppTheme.mutedForeground,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Progress bar
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppTheme.muted,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Count
          SizedBox(
            width: 32,
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.mutedForeground,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsList(List<Map<String, dynamic>> reviews) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: reviews.take(3).map((review) => _buildReviewCard(review)).toList(),
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: review['color'] as Color,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    review['initial'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.foreground,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Name and rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.foreground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < review['rating']
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 12,
                              color: Colors.red,
                            );
                          }),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          review['date'],
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review['text'],
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.mutedForeground,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // TODO: Remove dummy data when API is ready
  List<Map<String, dynamic>> _getDummyReviews() {
    return [
      {
        'name': 'Sarah Johnson',
        'initial': 'S',
        'color': Colors.pink.shade200,
        'rating': 5,
        'date': 'October 15, 2024',
        'text':
            'Amazing experience! The atmosphere was so welcoming and I met so many interesting people from different countries. The conversation cards made it easy to break the ice.',
      },
      {
        'name': 'Kim Min-ji',
        'initial': '김',
        'color': Colors.purple.shade200,
        'rating': 5,
        'date': 'October 12, 2024',
        'text':
            'Great way to practice English and make friends! The organizers are super friendly and make everyone feel included. Highly recommend!',
      },
      {
        'name': 'Alex Martinez',
        'initial': 'A',
        'color': Colors.blue.shade200,
        'rating': 4,
        'date': 'October 8, 2024',
        'text':
            'Really enjoyed the event. The venue was perfect and the activities were well-organized. Looking forward to the next one!',
      },
    ];
  }

  Map<String, dynamic> _calculateRatingStats(List<Map<String, dynamic>> reviews) {
    final distribution = <int, int>{};
    var totalRating = 0.0;

    for (var review in reviews) {
      final rating = review['rating'] as int;
      distribution[rating] = (distribution[rating] ?? 0) + 1;
      totalRating += rating;
    }

    // Add dummy data to match the design
    distribution[5] = 10;
    distribution[4] = 4;
    distribution[3] = 2;
    distribution[2] = 0;
    distribution[1] = 0;

    final total = distribution.values.fold(0, (sum, count) => sum + count);
    final average = total > 0 ? (10 * 5 + 4 * 4 + 2 * 3) / total : 0.0;

    return {
      'average': average,
      'total': total,
      'distribution': distribution,
    };
  }
}
