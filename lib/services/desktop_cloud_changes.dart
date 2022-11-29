import 'dart:convert';
import 'dart:io';

import 'package:copypaste/main.dart';
import 'package:http/http.dart' as http;

class DesktopCloudChanges {
  static Future getCloudDocuments() async {
    await Future.delayed(const Duration(seconds: 2));

    // curl   'https://firestore.googleapis.com/v1/projects/copypaste-85843/databases/(default)/documents/users/kiniyan002%40gmail.com/text?key=AIzaSyCeIRVm7445etJK1CK5RsvM8YlpEzl1yY0'   --header 'Authorization: Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6ImE5NmFkY2U5OTk5YmJmNWNkMzBmMjlmNDljZDM3ZjRjNWU2NDI3NDAiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vY29weXBhc3RlLTg1ODQzIiwiYXVkIjoiY29weXBhc3RlLTg1ODQzIiwiYXV0aF90aW1lIjoxNjY5NTA2NTM1LCJ1c2VyX2lkIjoiYWJTcDZGSk1VVldXanh1aFp5WThCY1VPbkg2MyIsInN1YiI6ImFiU3A2RkpNVVZXV2p4dWhaeVk4QmNVT25INjMiLCJpYXQiOjE2Njk1MDY1MzUsImV4cCI6MTY2OTUxMDEzNSwiZW1haWwiOiJraW5peWFuMDAyQGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJlbWFpbCI6WyJraW5peWFuMDAyQGdtYWlsLmNvbSJdfSwic2lnbl9pbl9wcm92aWRlciI6InBhc3N3b3JkIn19.iCOjk79Txf_r9ZJ3eJqyY32GWFi11UUHowqZK5HntNSbXFLYEBvsCJI2-jk7G0BcD-MOxJrdjyOlIbgKiQNrvzSxYHo8sl6Nq6jrL0hTRkjiRT8EO4HmLt1fqaCY9ERy3U-4AnNF_uhyEz-ddXbda_fVNYhfZC1Cv2IvJ7cz2NdXid3ZOzC0wGp6SHQNXPLDqkSN4yKW-GPZ12qAoRcSuDQE8KIvrBdUS4pi5ytCfD0BYmHQmAwbpRqx_S15kJQKUO5xRN6tSYVJkW5qt7I8cVBlrsGc2VMmF9XP8jSudeRCHMp3szf37qDBUnTLcJ7b87UJq2gYU09RcEpH7hps1A'   --header 'Accept: application/json'
    String url =
        'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/$userEmail/text?key=$apiKey';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $userToken",
        HttpHeaders.acceptHeader: "application/json"
      },
    );

    print("URL: ${Uri.parse(url)}");
    print("Headers: ${response.headers}");
    print("Request: ${response.request.toString()}");
    print("Headers: ${response.request?.headers.toString()}");
    print("Status: ${response.statusCode}");
    print("Body: ${response.body}");
  }

  static Future listenToCloudDocuments() async {
    await Future.delayed(const Duration(seconds: 2));

    String url =
        'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents:listen?key=$apiKey';
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $userToken",
        HttpHeaders.acceptHeader: "application/json",
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
      },
      body: {
        "addTarget": {
          "targetId": 2,
          "once": false,
          "query": {
            "parent":
                "projects/copypaste-85843/databases/(default)/documents/users/kiniyan002@gmail.com",
            "structuredQuery": {
              "select": {"fields": []},
              "from": [
                {"collectionId": "text", "allDescendants": false}
              ],
              "orderBy": [
                {
                  "field": {"fieldPath": "text/time"},
                  "direction": "DESCENDING"
                }
              ]
            }
          },
          "readTime": DateTime.now().toString()
        }
      },
      // encoding:
    );

    print("URL: ${Uri.parse(url)}");
    print("Headers: ${response.headers}");
    print("Request: ${response.request.toString()}");
    print("Headers: ${response.request?.headers.toString()}");
    print("Status: ${response.statusCode}");
    print("Body: ${response.body}");
  }

  static Future sendDocumentToCloud({
    required String newData,
    required String deviceName,
  }) async {
    // curl   'https://firestore.googleapis.com/v1/projects/copypaste-85843/databases/(default)/documents/users/kiniyan002%40gmail.com/text?key=AIzaSyCeIRVm7445etJK1CK5RsvM8YlpEzl1yY0'   --header 'Authorization: Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6ImE5NmFkY2U5OTk5YmJmNWNkMzBmMjlmNDljZDM3ZjRjNWU2NDI3NDAiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vY29weXBhc3RlLTg1ODQzIiwiYXVkIjoiY29weXBhc3RlLTg1ODQzIiwiYXV0aF90aW1lIjoxNjY5NTA2NTM1LCJ1c2VyX2lkIjoiYWJTcDZGSk1VVldXanh1aFp5WThCY1VPbkg2MyIsInN1YiI6ImFiU3A2RkpNVVZXV2p4dWhaeVk4QmNVT25INjMiLCJpYXQiOjE2Njk1MDY1MzUsImV4cCI6MTY2OTUxMDEzNSwiZW1haWwiOiJraW5peWFuMDAyQGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJlbWFpbCI6WyJraW5peWFuMDAyQGdtYWlsLmNvbSJdfSwic2lnbl9pbl9wcm92aWRlciI6InBhc3N3b3JkIn19.iCOjk79Txf_r9ZJ3eJqyY32GWFi11UUHowqZK5HntNSbXFLYEBvsCJI2-jk7G0BcD-MOxJrdjyOlIbgKiQNrvzSxYHo8sl6Nq6jrL0hTRkjiRT8EO4HmLt1fqaCY9ERy3U-4AnNF_uhyEz-ddXbda_fVNYhfZC1Cv2IvJ7cz2NdXid3ZOzC0wGp6SHQNXPLDqkSN4yKW-GPZ12qAoRcSuDQE8KIvrBdUS4pi5ytCfD0BYmHQmAwbpRqx_S15kJQKUO5xRN6tSYVJkW5qt7I8cVBlrsGc2VMmF9XP8jSudeRCHMp3szf37qDBUnTLcJ7b87UJq2gYU09RcEpH7hps1A'   --header 'Accept: application/json'
    String url =
        'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/$userEmail/text?key=$apiKey';
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $userToken",
        HttpHeaders.acceptHeader: "application/json",
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: json.encode({
        "fields": {
          "data": {
            "stringValue": newData,
          },
          "device": {
            "stringValue": deviceName,
          },
          "time": {
            "timestampValue": DateTime.now().toUtc().toIso8601String(),
          },
        },
      }),
    );

    print("URL: ${Uri.parse(url)}");
    print("Headers: ${response.headers}");
    print("Request: ${response.request.toString()}");
    print("Headers: ${response.request?.headers.toString()}");
    print("Status: ${response.statusCode}");
    print("Body: ${response.body}");
  }
}
