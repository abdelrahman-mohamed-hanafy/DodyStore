import 'OfferActionType.dart';

class OfferModel {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final String buttonText;
  final int discount;
  final int priority;
  final bool isActive;
  final DateTime? startDate;
  final DateTime? endDate;
  final OfferActionType actionType;
  final String? actionId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OfferModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    required this.buttonText,
    required this.discount,
    required this.priority,
    required this.isActive,
    required this.startDate,
    required this.endDate,
    required this.actionType,
    required this.actionId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'],
      buttonText: json['button_text'] ?? 'Shop Now',
      discount: json['discount'] ?? 0,
      priority: json['priority'] ?? 1,
      isActive: json['is_active'] ?? true,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : null,
      actionType:
      OfferActionTypeExtension.fromString(json['action_type']),
      actionId: json['action_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'image_url': imageUrl,
      'button_text': buttonText,
      'discount': discount,
      'priority': priority,
      'is_active': isActive,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'action_type': actionType.value,
      'action_id': actionId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  OfferModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    String? imageUrl,
    String? buttonText,
    int? discount,
    int? priority,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    OfferActionType? actionType,
    String? actionId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OfferModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      buttonText: buttonText ?? this.buttonText,
      discount: discount ?? this.discount,
      priority: priority ?? this.priority,
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      actionType: actionType ?? this.actionType,
      actionId: actionId ?? this.actionId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get hasDiscount => discount > 0;

  bool get hasAction => actionType != OfferActionType.none;

  bool get isExpired =>
      endDate != null && endDate!.isBefore(DateTime.now());
}