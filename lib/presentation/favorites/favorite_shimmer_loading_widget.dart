import 'package:flutter/material.dart';

class ShimmerLoadingList extends StatelessWidget {
  const ShimmerLoadingList({super.key});
  Widget _buildShimmerItem() {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 1500),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, double value, child) {
        return Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment(-2.0 + (value * 4), 0),
                  end: Alignment(-1.0 + (value * 4), 0),
                  colors: [
                    Colors.grey[900]!,
                    Colors.grey[800]!,
                    Colors.grey[900]!,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: LinearGradient(
                        begin: Alignment(-2.0 + (value * 4), 0),
                        end: Alignment(-1.0 + (value * 4), 0),
                        colors: [
                          Colors.grey[900]!,
                          Colors.grey[800]!,
                          Colors.grey[900]!,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                            begin: Alignment(-2.0 + (value * 4), 0),
                            end: Alignment(-1.0 + (value * 4), 0),
                            colors: [
                              Colors.grey[900]!,
                              Colors.grey[800]!,
                              Colors.grey[900]!,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 60,
                        height: 12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                            begin: Alignment(-2.0 + (value * 4), 0),
                            end: Alignment(-1.0 + (value * 4), 0),
                            colors: [
                              Colors.grey[900]!,
                              Colors.grey[800]!,
                              Colors.grey[900]!,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  begin: Alignment(-2.0 + (value * 4), 0),
                  end: Alignment(-1.0 + (value * 4), 0),
                  colors: [
                    Colors.grey[900]!,
                    Colors.grey[800]!,
                    Colors.grey[900]!,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int listSize = 5;
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: listSize,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, __) => _buildShimmerItem(),
    );
  }
}
