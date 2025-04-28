import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../configs/app_config.dart';
import '../../../features/home/domain/entities/video_item_entity.dart';
import '../../../features/search/domain/entities/search_video_entity.dart';
import '../../exceptions/http_exception.dart';
import '../../utils/constants/response_code.dart';
import '../../utils/constants/response_message.dart';

abstract class ApiDataSource {
  Future<List<SearchVideoEntity>> fetchSearchVideos(String query);
  Future<List<VideoItemEntity>> fetchTrendingVideos();
  Future<List<VideoItemEntity>> fetchVideosByCategory(String categoryId);
  List<T> handleResponse<T>(
      http.Response response, T Function(Map<String, dynamic>) fromJson);
  HttpException handleError(int statusCode, String message);
}

class ApiRemoteDataSource implements ApiDataSource {
  final String _baseUrl = AppConfig.apiBaseUrl;
  final String _apiKey = AppConfig.apiKey;

  /// Fetches a list of videos based on the search query.
  ///
  /// - [query]: The search keyword.
  /// - Returns: A list of `SearchVideoEntity` if successful.
  /// - Throws: `HttpException` if there is an API error.
  @override
  Future<List<SearchVideoEntity>> fetchSearchVideos(String query) async {
    final uri =
        "$_baseUrl/search?part=snippet&type=video&q=$query&maxResults=10&key=$_apiKey";
    final url = Uri.parse(uri);

    try {
      final response = await http.get(url);
      return handleResponse<SearchVideoEntity>(
          response, SearchVideoEntity.fromJson);
    } catch (e) {
      throw handleError(
          ResponseCode.internalServerError, ResponseMessage.invalidFormat);
    }
  }

  /// Fetches a list of trending videos.
  ///
  /// - Returns: A list of `VideoItemEntity` containing popular videos.
  /// - Throws: `HttpException` if there is an API error.
  @override
  Future<List<VideoItemEntity>> fetchTrendingVideos() async {
    final uri =
        "$_baseUrl/videos?part=snippet&chart=mostPopular&maxResults=10&key=$_apiKey";
    final url = Uri.parse(uri);

    try {
      final response = await http.get(url);
      return handleResponse<VideoItemEntity>(
          response, VideoItemEntity.fromJson);
    } catch (e) {
      throw handleError(
          ResponseCode.internalServerError, ResponseMessage.invalidFormat);
    }
  }

  /// Fetches a list of videos filtered by a specific category.
  ///
  /// - [categoryId]: The ID of the category.
  /// - Returns: A list of `VideoItemEntity` for the specified category.
  /// - Throws: `HttpException` if there is an API error.
  @override
  Future<List<VideoItemEntity>> fetchVideosByCategory(String categoryId) async {
    final uri =
        "$_baseUrl/videos?part=snippet&chart=mostPopular&maxResults=10&videoCategoryId=$categoryId&key=$_apiKey";
    final url = Uri.parse(uri);

    try {
      final response = await http.get(url);
      return handleResponse<VideoItemEntity>(
          response, VideoItemEntity.fromJson);
    } catch (e) {
      throw handleError(
          ResponseCode.internalServerError, ResponseMessage.invalidFormat);
    }
  }

  /// Processes the HTTP response, converts JSON into a list of the specified entity type.
  ///
  /// - [response]: The HTTP response object.
  /// - [fromJson]: A function that converts a JSON map into the corresponding entity.
  /// - Returns: A list of objects of type `T`.
  /// - Throws: `HttpException` if the response contains an error or is invalid.
  @override
  List<T> handleResponse<T>(
      http.Response response, T Function(Map<String, dynamic>) fromJson) {
    switch (response.statusCode) {
      case ResponseCode.success:
        final Map<String, dynamic> data = json.decode(response.body);

        if (!data.containsKey("items")) {
          throw handleError(
              ResponseCode.internalServerError, ResponseMessage.invalidFormat);
        }

        final List<dynamic> items = data["items"];
        return items.map((item) => fromJson(item)).toList();

      case ResponseCode.badRequest:
        throw handleError(ResponseCode.badRequest, ResponseMessage.badRequest);
      case ResponseCode.unauthorized:
        throw handleError(
            ResponseCode.unauthorized, ResponseMessage.unauthorized);
      case ResponseCode.forbidden:
        throw handleError(ResponseCode.forbidden, ResponseMessage.forbidden);
      case ResponseCode.notFound:
        throw handleError(ResponseCode.notFound, ResponseMessage.notFound);
      case ResponseCode.internalServerError:
        throw handleError(
            ResponseCode.internalServerError, ResponseMessage.serverError);
      default:
        throw handleError(response.statusCode, ResponseMessage.unknownError);
    }
  }

  /// Creates and returns an `HttpException` based on the provided status code and message.
  ///
  /// - [statusCode]: The HTTP status code indicating the type of error.
  /// - [message]: A descriptive error message.
  /// - Returns: An `HttpException` with the error details.
  @override
  HttpException handleError(int statusCode, String message) {
    return HttpException(message, statusCode: statusCode);
  }
}
