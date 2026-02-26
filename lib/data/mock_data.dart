// lib/data/mock_data.dart

import '../models/product.dart';
import '../models/notification_item.dart';

final List<Product> mockProducts = [
  Product(
    id: '1',
    title: 'iPhone 13 Pro',
    description:
        'Excellent condition iPhone 13 Pro, 256GB, Sierra Blue. Comes with original box and accessories. Battery health 94%. No scratches or dents.',
    price: 750.00,
    category: 'Electronics',
    imageUrl: 'https://picsum.photos/id/20/400/300',
    sellerName: 'Alex Johnson',
    sellerLocation: 'New York, NY',
    listingType: ListingType.sale,
    postedAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  Product(
    id: '2',
    title: 'Vintage Leather Sofa',
    description:
        'Beautiful vintage brown leather sofa, 3-seater. Minor wear consistent with age but still very comfortable and sturdy. Great for a study or living room.',
    price: 320.00,
    category: 'Furniture',
    imageUrl: 'https://picsum.photos/id/116/400/300',
    sellerName: 'Maria Garcia',
    sellerLocation: 'Los Angeles, CA',
    listingType: ListingType.exchange,
    postedAt: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  Product(
    id: '3',
    title: 'Mountain Bike Trek',
    description:
        'Trek Marlin 7 mountain bike, 2022 model, size M. Barely used, only 3 rides. 29" wheels, hydraulic disc brakes. Perfect for trails.',
    price: 680.00,
    category: 'Sports',
    imageUrl: 'https://picsum.photos/id/11/400/300',
    sellerName: 'Chris Lee',
    sellerLocation: 'Austin, TX',
    listingType: ListingType.both,
    postedAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Product(
    id: '4',
    title: 'Canon EOS R50 Camera',
    description:
        'Canon EOS R50 mirrorless camera with 18-45mm kit lens. Only 500 shutter count. Includes extra battery, 64GB SD card, and camera bag.',
    price: 620.00,
    category: 'Electronics',
    imageUrl: 'https://picsum.photos/id/250/400/300',
    sellerName: 'Sophie Turner',
    sellerLocation: 'Chicago, IL',
    listingType: ListingType.sale,
    postedAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Product(
    id: '5',
    title: 'Antique Writing Desk',
    description:
        'Gorgeous solid oak antique writing desk with brass handles. 3 drawers, leather top insert. A real statement piece. Dimensions: 120x60x78cm.',
    price: 450.00,
    category: 'Furniture',
    imageUrl: 'https://picsum.photos/id/164/400/300',
    sellerName: 'James Wright',
    sellerLocation: 'Boston, MA',
    listingType: ListingType.exchange,
    postedAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
  Product(
    id: '6',
    title: 'PlayStation 5 Console',
    description:
        'PS5 Disc Edition, like new. Comes with 2 controllers, charging dock, and 4 games including Spider-Man 2 and God of War Ragnarok.',
    price: 490.00,
    category: 'Gaming',
    imageUrl: 'https://picsum.photos/id/96/400/300',
    sellerName: 'Ryan Chen',
    sellerLocation: 'Seattle, WA',
    listingType: ListingType.both,
    postedAt: DateTime.now().subtract(const Duration(days: 4)),
  ),
  Product(
    id: '7',
    title: 'Nike Air Jordan 1 Retro',
    description:
        'Nike Air Jordan 1 Retro High OG "Chicago" colorway. Size US 10. Worn twice, in near deadstock condition. Original box included.',
    price: 280.00,
    category: 'Fashion',
    imageUrl: 'https://picsum.photos/id/133/400/300',
    sellerName: 'Dana Park',
    sellerLocation: 'Miami, FL',
    listingType: ListingType.sale,
    postedAt: DateTime.now().subtract(const Duration(days: 5)),
  ),
  Product(
    id: '8',
    title: 'Acoustic Guitar Yamaha',
    description:
        'Yamaha FG800 acoustic guitar in excellent condition. Perfect for beginners and intermediates. Includes padded gig bag, strap, tuner and picks.',
    price: 175.00,
    category: 'Music',
    imageUrl: 'https://picsum.photos/id/145/400/300',
    sellerName: 'Olivia Brown',
    sellerLocation: 'Nashville, TN',
    listingType: ListingType.both,
    postedAt: DateTime.now().subtract(const Duration(days: 6)),
  ),
];

final List<NotificationItem> mockNotifications = [
  NotificationItem(
    id: 'n1',
    title: '🔥 Flash Sale Alert!',
    body: 'iPhone 13 Pro is now 10% off. Grab it before it\'s gone!',
    receivedAt: DateTime.now().subtract(const Duration(minutes: 10)),
    isRead: false,
  ),
  NotificationItem(
    id: 'n2',
    title: '💬 New Offer Received',
    body: 'Someone made an offer on your Mountain Bike listing.',
    receivedAt: DateTime.now().subtract(const Duration(hours: 1)),
    isRead: false,
  ),
  NotificationItem(
    id: 'n3',
    title: '✅ Payment Confirmed',
    body: 'Your purchase of PS5 Console has been confirmed successfully.',
    receivedAt: DateTime.now().subtract(const Duration(hours: 3)),
    isRead: true,
  ),
  NotificationItem(
    id: 'n4',
    title: '⭐ New Items in Electronics',
    body: '5 new electronics listings were added in your area today.',
    receivedAt: DateTime.now().subtract(const Duration(days: 1)),
    isRead: true,
  ),
];

const List<String> productCategories = [
  'All',
  'Electronics',
  'Furniture',
  'Sports',
  'Gaming',
  'Fashion',
  'Music',
  'Other',
];