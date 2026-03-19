import 'package:postgres/postgres.dart';

class DatabaseService {
  static Future<void> connectToDB() async {
    try {
      final conn = await Connection.open(
        Endpoint(
          host: 'ep-sparkling-poetry-ad50abej-pooler.c-2.us-east-1.aws.neon.tech',
          database: 'neondb',
          username: 'neondb_owner',
          password: 'npg_CKaqtSPY8e3T',
        ),
        settings: const ConnectionSettings(
          sslMode: SslMode.require, // Required for Neon
        ),
      );

      print('Connected to Neon Database successfully!');

      // Example Query
      // var results = await conn.execute('SELECT * FROM properties');

      await conn.close();
    } catch (e) {
      print('Database connection error: $e');
    }
  }
}