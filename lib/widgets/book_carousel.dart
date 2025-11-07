/// Book Carousel Widget
/// Displays an automatic carousel of book cards with hover pause and fade effects
/// Student: HE HUALIANG (230263367)

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class BookCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> books;
  final Duration autoScrollDuration;
  final Duration transitionDuration;

  const BookCarousel({
    super.key,
    required this.books,
    this.autoScrollDuration = const Duration(seconds: 3),
    this.transitionDuration = const Duration(milliseconds: 500),
  });

  @override
  State<BookCarousel> createState() => _BookCarouselState();
}

class _BookCarouselState extends State<BookCarousel> {
  late PageController _pageController;
  Timer? _autoScrollTimer;
  bool _isHovering = false;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.3);
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(widget.autoScrollDuration, (timer) {
      if (!_isHovering && widget.books.isNotEmpty && mounted) {
        final currentPageIndex = _pageController.page?.round() ?? _currentPage;
        final nextPage = (currentPageIndex + 1) % widget.books.length;
        _pageController.animateToPage(
          nextPage,
          duration: widget.transitionDuration,
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onHover(bool isHovering) {
    setState(() {
      _isHovering = isHovering;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.books.isEmpty) {
      return const SizedBox.shrink();
    }

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: Container(
        height: 320,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Colors.transparent,
              Colors.transparent,
              Theme.of(context).scaffoldBackgroundColor,
            ],
            stops: const [0.0, 0.1, 0.9, 1.0],
          ),
        ),
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemCount: widget.books.length,
          itemBuilder: (context, index) {
            return AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                double value = 1.0;
                if (_pageController.position.haveDimensions) {
                  value = (_pageController.page ?? 0.0) - index;
                  value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
                }

                return Center(
                  child: SizedBox(
                    height: Curves.easeInOut.transform(value) * 300,
                    child: child,
                  ),
                );
              },
              child: _buildBookCard(widget.books[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    // Get book status from API response (0 = available, not 0 = borrowed/reserved)
    final status = book['status'] ?? 0;
    final isAvailable = (status is int ? status : int.tryParse(status.toString())) == 0;
    final firstLetter = (book['title'] ?? 'U')[0].toUpperCase();

    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Book cover or first letter
          Expanded(
            child: Container(
              color: Colors.primaries[
                  firstLetter.codeUnitAt(0) % Colors.primaries.length],
              child: book['coverUrl'] != null
                  ? Image.network(book['coverUrl'], fit: BoxFit.cover)
                  : Center(
                      child: Text(
                        firstLetter,
                        style: const TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ),

          // Book info
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book['title'] ?? 'Unknown',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  book['authors'] ?? 'Unknown',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Status tag
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isAvailable
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isAvailable ? 'Available' : 'Borrowed',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isAvailable
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
