import 'package:arunaapp/menu_user/services/school_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


// No shared header here; using a custom app bar per spec

class UpdateAccountPage extends StatefulWidget {
  const UpdateAccountPage({super.key});

  @override
  State<UpdateAccountPage> createState() => _UpdateAccountPageState();
}

class _UpdateAccountPageState extends State<UpdateAccountPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _phoneController = TextEditingController();
  // View-only fields
  final _roleViewController = TextEditingController();
  final _schoolNameViewController = TextEditingController();
  final _classNameViewController = TextEditingController();

  final SchoolService _schoolService = SchoolService();

  String _role = '';
  String? _schoolId;
  String? _selectedClassId;

  bool _loading = false;
  String? _error;
  DateTime? _selectedDob;

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final data = doc.data();
      if (data != null) {
        _firstNameController.text = (data['first_name'] as String?) ?? '';
        _lastNameController.text = (data['last_name'] as String?) ?? '';
        _emailController.text = user.email ?? (data['email'] as String? ?? '');
        _phoneController.text = (data['phone'] as String?) ?? '';
        final String? dob = (data['date_of_birth'] as String?);
        if (dob != null && dob.isNotEmpty) {
          _dateOfBirthController.text = dob;
          _selectedDob = DateTime.parse(dob);
        }

        // View-only: role, school name, class name
        final String role = (data['role'] as String?)?.trim() ?? '';
        _role = role;
        _roleViewController.text = _roleLabel(role);

        final String? schoolId = (data['school_id'] as String?)?.trim();
        _schoolId = (schoolId != null && schoolId.isNotEmpty) ? schoolId : null;
        if (schoolId != null && schoolId.isNotEmpty) {
          try {
            final schoolDoc = await FirebaseFirestore.instance
                .collection('schools')
                .doc(schoolId)
                .get();
            final Map<String, dynamic>? sData = schoolDoc.data();
            final String sName = (sData?['name'] as String?)?.trim() ?? '';
            _schoolNameViewController.text = sName.isEmpty ? '-' : sName;
          } catch (_) {
            _schoolNameViewController.text = '-';
          }
        } else {
          _schoolNameViewController.text = '-';
        }

        final String? classId = (data['class_id'] as String?)?.trim();
        _selectedClassId = (classId != null && classId.isNotEmpty)
            ? classId
            : null;
        if (classId != null && classId.isNotEmpty) {
          try {
            final classDoc = await FirebaseFirestore.instance
                .collection('classes')
                .doc(classId)
                .get();
            final Map<String, dynamic>? cData = classDoc.data();
            final String cName = (cData?['name'] as String?)?.trim() ?? '';
            _classNameViewController.text = cName.isEmpty ? '-' : cName;
          } catch (_) {
            _classNameViewController.text = '-';
          }
        } else {
          _classNameViewController.text = '-';
        }
      }
      if (mounted) setState(() {});
    } catch (_) {}
  }

  String _roleLabel(String role) {
    switch (role) {
      case 'student':
        return 'Siswa';
      case 'teacher':
        return 'Guru';
      case 'admin':
        return 'Admin';
      case 'root':
        return 'Sudo';
      default:
        return role.isEmpty ? '-' : role;
    }
  }

  String _formatDate(DateTime date) {
    String two(int v) => v < 10 ? '0$v' : '$v';
    return '${date.year}-${two(date.month)}-${two(date.day)}';
  }

  Future<void> _pickDateOfBirth(DateTime? initial) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = initial ?? DateTime(now.year - 18);
    final DateTime firstDate = DateTime(1900);
    final DateTime lastDate = now;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Select date of birth',
    );
    if (picked != null) {
      setState(() {
        _selectedDob = picked;
        _dateOfBirthController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _save() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // Compose full display name
      final String fullName =
          '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'
              .trim();

      // Update Firebase Auth display name
      await user.updateDisplayName(fullName);

      // Update Firestore profile fields
      final updates = <String, Object?>{
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'display_name': fullName,
        'date_of_birth': _dateOfBirthController.text.trim(),
        'phone': _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        'class_id': _role == 'student' ? _selectedClassId : null,
        'updated_at': FieldValue.serverTimestamp(),
      };
      updates.removeWhere(
        (key, value) => value == null || (value is String && value.isEmpty),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(updates, SetOptions(merge: true));

      // Ensure in-memory user is refreshed
      await user.reload();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Akun berhasil diperbarui')),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3B83A7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B83A7),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Text(
          'Perbarui Akun',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'Nama Depan',
                filled: true,
                fillColor: const Color(0xFF6EC1E4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Nama Belakang',
                filled: true,
                fillColor: const Color(0xFF6EC1E4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              readOnly: true,
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: const Color(0xFF6EC1E4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _roleViewController,
              readOnly: true,
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Peran',
                filled: true,
                fillColor: const Color(0xFF6EC1E4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _schoolNameViewController,
              readOnly: true,
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Sekolah',
                filled: true,
                fillColor: const Color(0xFF6EC1E4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_role == 'student')
              (_schoolId == null || _schoolId!.isEmpty)
                  ? DropdownButtonFormField<String>(
                      initialValue: null,
                      decoration: InputDecoration(
                        labelText: 'Kelas',
                        filled: true,
                        fillColor: const Color(0xFF6EC1E4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      hint: const Text('Tidak ada sekolah terpilih'),
                      isExpanded: true,
                      items: const <DropdownMenuItem<String>>[],
                      onChanged: null,
                    )
                  : StreamBuilder<List<SchoolClass>>(
                      stream: _schoolService.watchClasses(schoolId: _schoolId),
                      builder:
                          (
                            BuildContext context,
                            AsyncSnapshot<List<SchoolClass>> snapshot,
                          ) {
                            final bool loading =
                                snapshot.connectionState ==
                                ConnectionState.waiting;
                            final List<SchoolClass> classes =
                                snapshot.data ?? const <SchoolClass>[];
                            final bool hasSelectedInList = classes.any(
                              (SchoolClass c) => c.id == _selectedClassId,
                            );
                            final String? effectiveValue = hasSelectedInList
                                ? _selectedClassId
                                : null;
                            return DropdownButtonFormField<String>(
                              initialValue: effectiveValue,
                              decoration: InputDecoration(
                                labelText: 'Kelas',
                                filled: true,
                                fillColor: const Color(0xFF6EC1E4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              hint: const Text('Pilih kelas'),
                              isExpanded: true,
                              items: classes
                                  .map(
                                    (SchoolClass c) => DropdownMenuItem<String>(
                                      value: c.id,
                                      child: Text(c.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (loading || classes.isEmpty)
                                  ? null
                                  : (String? value) {
                                      setState(() {
                                        _selectedClassId = value;
                                        // Update view-only controller for non-student view consistency later
                                        final SchoolClass selected = classes
                                            .firstWhere(
                                              (SchoolClass c) => c.id == value,
                                              orElse: () => const SchoolClass(
                                                id: '',
                                                schoolId: '',
                                                name: '',
                                              ),
                                            );
                                        _classNameViewController.text =
                                            (selected.name).isEmpty
                                            ? '-'
                                            : selected.name;
                                      });
                                    },
                            );
                          },
                    )
            else
              TextField(
                controller: _classNameViewController,
                readOnly: true,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Kelas',
                  filled: true,
                  fillColor: const Color(0xFF6EC1E4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            TextField(
              controller: _dateOfBirthController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Tanggal Lahir',
                hintText: 'YYYY-MM-DD',
                filled: true,
                fillColor: const Color(0xFF6EC1E4),
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onTap: () => _pickDateOfBirth(_selectedDob),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'No. HP',
                filled: true,
                fillColor: const Color(0xFF6EC1E4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF3B83A7),
                ),
                onPressed: _loading ? null : _save,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF3B83A7),
                          ),
                        ),
                      )
                    : const Text(
                        'Simpan Perubahan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
