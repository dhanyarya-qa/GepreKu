import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/service_request.dart';
import 'auth_provider.dart';

// Service Requests Stream Provider
final serviceRequestsProvider = StreamProvider.family<List<ServiceRequest>, String>((ref, outletId) {
  return FirebaseFirestore.instance
      .collection('service_requests')
      .where('outlet_id', isEqualTo: outletId)
      .where('status', isEqualTo: 'pending')
      .orderBy('created_at', descending: false)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return ServiceRequest.fromJson({
        'id': doc.id,
        ...doc.data(),
      });
    }).toList();
  });
});

// Service Request Service
final serviceRequestServiceProvider = Provider<ServiceRequestService>((ref) {
  return ServiceRequestService(ref);
});

class ServiceRequestService {
  final Ref ref;
  
  ServiceRequestService(this.ref);
  
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  
  // Create Service Request
  Future<void> createServiceRequest({
    required ServiceCategory category,
  }) async {
    // TODO: Get table_id and outlet_id from session
    final tableId = 'table_01'; // Placeholder
    final outletId = 'outlet_001'; // Placeholder
    
    await _firestore.collection('service_requests').add({
      'outlet_id': outletId,
      'table_id': tableId,
      'category': category.name,
      'status': ServiceStatus.pending.name,
      'created_at': FieldValue.serverTimestamp(),
      'completed_at': null,
    });
  }
  
  // Mark Service Request as Completed
  Future<void> completeServiceRequest(String requestId) async {
    await _firestore.collection('service_requests').doc(requestId).update({
      'status': ServiceStatus.completed.name,
      'completed_at': FieldValue.serverTimestamp(),
    });
  }
}
