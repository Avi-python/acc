import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/transaction.dart';

// TODO : let user input these messages, and store
final String NOTION_INTEGRATION_TOKEN = dotenv.env['NOTION_INTEGRATION_TOKEN']!;
final String NOTION_DATABASE_ID = dotenv.env['NOTION_DATABASE_ID']!;
final String NOTION_URL = "https://api.notion.com/v1";

class NotionService {

  final Logger _logger;

  NotionService(this._logger);

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $NOTION_INTEGRATION_TOKEN',
    'Content-Type': 'application/json',
    'Notion-Version': '2022-06-28', // Notion API 版本
  };

  Future<String> createNotionEntry(Transaction transaction) async {
    final url = Uri.parse('$NOTION_URL/pages');

    final body = jsonEncode({
      'parent': {'database_id': NOTION_DATABASE_ID},
      'properties': {
        'Name': {
          'title': [
            {
              'text': {'content': transaction.name}
            }
          ]
        },
        'Amount': {
          'number': transaction.amount,
        },
        'Type': {
          'select': {'name': transaction.type.name}
        },
        'Category': {
          'select': {'name': transaction.category}
        },
        'DeviceCreatedAt': {
          'date': {'start': transaction.createdAt.toIso8601String()}
        },
        'Notes': {
          'rich_text': [
            {
              'text': {'content': transaction.notes ?? ''}
            }
          ]
        },
        'LocalId': {
          'rich_text': [
            {
              'text': {'content': transaction.id}
            }
          ]
        },
      }
    });

    final response = await http.post(url, headers: _headers, body: body);

    if(response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _logger.i('✅ Notion entry created successfully');
      return data['id'];
    } else {
      _logger.e('❌ Failed to create Notion entry:');
      throw Exception('Failed to create Notion entry: ${response.body}');
    }
  }

  Future<void> updateNotionEntry(String notionId, Transaction transaction) async {
    final url = Uri.parse('$NOTION_URL/pages/$notionId');

    final body = {
      'properties': {
        'Name': {
          'title': [
            {
              'text': {'content': transaction.name}
            }
          ]
        },
        'Amount': {
          'number': transaction.amount,
        },
        'Type': {
          'select': {'name': transaction.type.name}
        },
        'Category': {
          'select': {'name': transaction.category}
        },
        'Notes': {
          'rich_text': [
            {
              'text': {'content': transaction.notes ?? ''}
            }
          ]
        },
        'LocalId': {
          'rich_text': [
            {
              'text': {'content': transaction.id}
            }
          ]
        },
      }
    };

    final response = await http.patch(
      url,
      headers: _headers,
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      _logger.e('❌ Failed to update Notion entry:');
      throw Exception('Failed to update transaction: ${response.body}');
    }
  }

  // Delete transaction from Notion (archive)
  Future<void> deleteNotionEntry(String notionId) async {
    final url = Uri.parse('$NOTION_URL/pages/$notionId');

    final body = {'archived': true};

    final response = await http.patch(
      url,
      headers: _headers,
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      _logger.e('❌ Failed to delete Notion entry:');
      throw Exception('Failed to delete transaction: ${response.body}');
    }
  }

  // Fetch all transactions from Notion
  Future<List<Map<String, dynamic>>> fetchAllEntries() async {
    final url = Uri.parse('$NOTION_URL/databases/$NOTION_DATABASE_ID/query');

    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode({}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['results']);
    } else {
      throw Exception('Failed to fetch transactions: ${response.body}');
    }
  }

}

