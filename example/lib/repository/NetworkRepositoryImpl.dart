
import 'package:connectivity/connectivity.dart';
import 'NetworkRepository.dart';

class NetworkRepositoryImpl extends NetworkRepository {
  @override
  Future<ConnectivityResult> checkConnection() async {
    return Connectivity().checkConnectivity();
  }
}
