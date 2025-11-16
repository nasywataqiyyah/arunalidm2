import 'package:cloud_firestore/cloud_firestore.dart';

class School {
  const School({
    required this.id,
    required this.name,
    this.address,
    this.city,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String? address;
  final String? city;
  final String? type;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  factory School.fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
    final Map<String, dynamic> data = document.data() ?? <String, dynamic>{};
    return School(
      id: document.id,
      name: (data['name'] as String?)?.trim() ?? '',
      address: (data['address'] as String?)?.trim(),
      city: (data['city'] as String?)?.trim(),
      type: (data['type'] as String?)?.trim(),
      createdAt: data['created_at'] is Timestamp
          ? data['created_at'] as Timestamp
          : null,
      updatedAt: data['updated_at'] is Timestamp
          ? data['updated_at'] as Timestamp
          : null,
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'name': name,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }
}

class SchoolClass {
  const SchoolClass({
    required this.id,
    required this.schoolId,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String schoolId;
  final String name;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  factory SchoolClass.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final Map<String, dynamic> data = document.data() ?? <String, dynamic>{};
    return SchoolClass(
      id: document.id,
      schoolId: (data['school_id'] as String?)?.trim() ?? '',
      name: (data['name'] as String?)?.trim() ?? '',
      createdAt: data['created_at'] is Timestamp
          ? data['created_at'] as Timestamp
          : null,
      updatedAt: data['updated_at'] is Timestamp
          ? data['updated_at'] as Timestamp
          : null,
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'school_id': schoolId,
      'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }
}

class SchoolService {
  SchoolService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _schoolsCollection =>
      _firestore.collection('schools');

  CollectionReference<Map<String, dynamic>> get _classesCollection =>
      _firestore.collection('classes');

  Future<List<School>> fetchSchools({int? limit}) async {
    Query<Map<String, dynamic>> query = _schoolsCollection.orderBy(
      'name',
      descending: false,
    );
    if (limit != null) {
      query = query.limit(limit);
    }
    final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
    return snapshot.docs
        .map(
          (DocumentSnapshot<Map<String, dynamic>> d) => School.fromDocument(d),
        )
        .where((School s) => s.name.isNotEmpty)
        .toList(growable: false);
  }

  Stream<List<School>> watchSchools({int? limit}) {
    Query<Map<String, dynamic>> query = _schoolsCollection.orderBy(
      'name',
      descending: false,
    );
    if (limit != null) {
      query = query.limit(limit);
    }
    return query.snapshots().map(
      (QuerySnapshot<Map<String, dynamic>> snapshot) => snapshot.docs
          .map(
            (DocumentSnapshot<Map<String, dynamic>> d) =>
                School.fromDocument(d),
          )
          .where((School s) => s.name.isNotEmpty)
          .toList(growable: false),
    );
  }

  Future<School?> getSchoolById(String id) async {
    final String normalizedId = id.trim();
    if (normalizedId.isEmpty) return null;
    final DocumentSnapshot<Map<String, dynamic>> doc = await _schoolsCollection
        .doc(normalizedId)
        .get();
    if (!doc.exists) return null;
    return School.fromDocument(doc);
  }

  Future<List<SchoolClass>> fetchClasses({String? schoolId, int? limit}) async {
    Query<Map<String, dynamic>> query = _classesCollection;
    if (schoolId != null && schoolId.trim().isNotEmpty) {
      query = query.where('school_id', isEqualTo: schoolId.trim());
    }
    query = query.orderBy('name');
    if (limit != null) {
      query = query.limit(limit);
    }
    final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
    return snapshot.docs
        .map(
          (DocumentSnapshot<Map<String, dynamic>> d) =>
              SchoolClass.fromDocument(d),
        )
        .where((SchoolClass c) => c.name.isNotEmpty && c.schoolId.isNotEmpty)
        .toList(growable: false);
  }

  Stream<List<SchoolClass>> watchClasses({String? schoolId, int? limit}) {
    Query<Map<String, dynamic>> query = _classesCollection;
    if (schoolId != null && schoolId.trim().isNotEmpty) {
      query = query.where('school_id', isEqualTo: schoolId.trim());
    }
    query = query.orderBy('name');
    if (limit != null) {
      query = query.limit(limit);
    }
    return query.snapshots().map(
      (QuerySnapshot<Map<String, dynamic>> snapshot) => snapshot.docs
          .map(
            (DocumentSnapshot<Map<String, dynamic>> d) =>
                SchoolClass.fromDocument(d),
          )
          .where((SchoolClass c) => c.name.isNotEmpty && c.schoolId.isNotEmpty)
          .toList(growable: false),
    );
  }

  Future<SchoolClass?> getClassById(String id) async {
    final String normalizedId = id.trim();
    if (normalizedId.isEmpty) return null;
    final DocumentSnapshot<Map<String, dynamic>> doc = await _classesCollection
        .doc(normalizedId)
        .get();
    if (!doc.exists) return null;
    return SchoolClass.fromDocument(doc);
  }
}
