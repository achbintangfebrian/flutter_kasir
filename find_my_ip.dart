import 'dart:io';

/// Simple tool to help find your local IP address for API configuration
void main() async {
  print('=== Finding Your Local IP Address ===\n');
  
  try {
    // Get all network interfaces
    final interfaces = await NetworkInterface.list();
    
    print('Available network interfaces:');
    print('----------------------------------------');
    
    for (final interface in interfaces) {
      print('${interface.name}:');
      
      for (final addr in interface.addresses) {
        // Only show IPv4 addresses that are not loopback
        if (addr.type == InternetAddressType.IPv4 && 
            !addr.address.startsWith('127.')) {
          print('  IPv4: ${addr.address}');
        }
      }
      print('');
    }
    
    print('💡 TIPS FOR API CONFIGURATION:');
    print('----------------------------');
    print('1. For Android Emulator, use: http://10.0.2.2/your_backend_folder/api');
    print('2. For Physical Android Device, use one of the IPs above:');
    print('   Example: http://[IP_FROM_ABOVE]/your_backend_folder/api');
    print('3. For Browser/Web, use: http://localhost/your_backend_folder/api');
    print('');
    print('⚠️  Make sure your backend server is running and both devices');
    print('   are on the same network (for physical device testing).');
    
  } catch (e) {
    print('Error retrieving network interfaces: $e');
    print('');
    print('Alternative method for finding your IP address:');
    print('Windows: Run "ipconfig" in Command Prompt');
    print('Mac/Linux: Run "ifconfig" or "ip addr show" in Terminal');
  }
}