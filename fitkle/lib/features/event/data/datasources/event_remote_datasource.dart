import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fitkle/core/error/exceptions.dart';
import 'package:fitkle/core/utils/logger.dart';
import 'package:fitkle/features/event/data/models/event_model.dart';

abstract class EventRemoteDataSource {
  Future<List<EventModel>> getEvents({
    String? category,
    String? searchQuery,
    bool? isGroupEvent,
    int limit = 30,
    int offset = 0,
  });
  Future<EventModel> getEventById(String eventId);
  Future<List<EventModel>> getUpcomingEventsByMember(String memberId);
  Future<List<EventModel>> getEventsByHost(String hostId);
  Future<EventModel> createEvent(EventModel event);
  Future<EventModel> updateEvent(EventModel event);
  Future<void> deleteEvent(String eventId);
  Future<void> joinEvent(String eventId, String userId);
  Future<void> leaveEvent(String eventId, String userId);
  Future<void> incrementViewCount(String eventId);
}

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final SupabaseClient supabaseClient;

  EventRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<EventModel>> getEvents({
    String? category,
    String? searchQuery,
    bool? isGroupEvent,
    int limit = 30,
    int offset = 0,
  }) async {
    try {
      var query = supabaseClient.from('event').select();

      // Filter by category (skip if null or 'ALL')
      // Note: category parameter is already a UUID from EventCategoryService conversion
      if (category != null && category.isNotEmpty && category != 'ALL') {
        query = query.eq('event_category_id', category);
      }

      // Filter by search query
      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.ilike('title', '%$searchQuery%');
      }

      // Filter by group_id presence (group event vs personal event)
      if (isGroupEvent != null) {
        if (isGroupEvent) {
          // Group events: group_id is NOT null
          query = query.not('group_id', 'is', null);
        } else {
          // Personal events: group_id IS null
          query = query.isFilter('group_id', null);
        }
      }

      Logger.info(
        'Fetching events - category: $category, search: $searchQuery, isGroupEvent: $isGroupEvent, limit: $limit, offset: $offset',
        tag: 'EventDataSource',
      );

      final response = await query
          .order('datetime', ascending: false)
          .range(offset, offset + limit - 1);

      Logger.response(
        200,
        'Supabase REST API /rest/v1/event',
        data: {
          'count': (response as List).length,
          'offset': offset,
          'limit': limit,
        },
      );

      return response.map((json) => EventModel.fromJson(json)).toList();
    } catch (e) {
      Logger.error(
        'Failed to fetch events from Supabase',
        tag: 'EventDataSource',
        error: e,
      );
      throw ServerException('Failed to fetch events: ${e.toString()}');
    }
  }

  @override
  Future<EventModel> getEventById(String eventId) async {
    try {
      final response = await supabaseClient
          .from('event')
          .select()
          .eq('id', eventId)
          .single();

      return EventModel.fromJson(response);
    } catch (e) {
      throw NotFoundException('Event not found: ${e.toString()}');
    }
  }

  @override
  Future<List<EventModel>> getUpcomingEventsByMember(String memberId) async {
    try {
      final now = DateTime.now().toUtc().toIso8601String();

      Logger.info(
        'Fetching upcoming events for member: $memberId',
        tag: 'EventDataSource',
      );

      // 1. event_participant 테이블에서 해당 멤버가 참여한 이벤트 ID 조회
      final participantResponse = await supabaseClient
          .from('event_participant')
          .select('event_id')
          .eq('member_id', memberId)
          .isFilter('deleted_at', null);

      final eventIds = (participantResponse as List)
          .map((p) => p['event_id'] as String)
          .toList();

      Logger.debug(
        'Found ${eventIds.length} event participations for member',
        tag: 'EventDataSource',
      );

      if (eventIds.isEmpty) {
        return [];
      }

      // 2. event 테이블에서 해당 이벤트들 중 datetime이 현재 이후인 것만 조회
      final eventResponse = await supabaseClient
          .from('event')
          .select()
          .inFilter('id', eventIds)
          .gte('datetime', now)
          .isFilter('deleted_at', null)
          .order('datetime', ascending: true)
          .limit(20);

      Logger.response(
        200,
        'Supabase REST API - getUpcomingEventsByMember',
        data: {
          'count': (eventResponse as List).length,
          'memberId': memberId,
        },
      );

      return eventResponse.map((json) => EventModel.fromJson(json)).toList();
    } catch (e) {
      Logger.error(
        'Failed to fetch upcoming events for member',
        tag: 'EventDataSource',
        error: e,
      );
      throw ServerException('Failed to fetch upcoming events by member: ${e.toString()}');
    }
  }

  @override
  Future<List<EventModel>> getEventsByHost(String hostId) async {
    try {
      final response = await supabaseClient
          .from('event')
          .select()
          .eq('host_id', hostId)
          .order('created_at', ascending: false);

      return (response as List).map((json) => EventModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Failed to fetch events by host: ${e.toString()}');
    }
  }

  @override
  Future<EventModel> createEvent(EventModel event) async {
    try {
      final response = await supabaseClient
          .from('event')
          .insert(event.toJson())
          .select()
          .single();

      return EventModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to create event: ${e.toString()}');
    }
  }

  @override
  Future<EventModel> updateEvent(EventModel event) async {
    try {
      final response = await supabaseClient
          .from('event')
          .update(event.toJson())
          .eq('id', event.id)
          .select()
          .single();

      return EventModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to update event: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    try {
      await supabaseClient.from('event').delete().eq('id', eventId);
    } catch (e) {
      throw ServerException('Failed to delete event: ${e.toString()}');
    }
  }

  @override
  Future<void> joinEvent(String eventId, String userId) async {
    try {
      await supabaseClient.from('event_participant').insert({
        'event_id': eventId,
        'user_id': userId,
        'status': 'confirmed',
      });
    } catch (e) {
      throw ServerException('Failed to join event: ${e.toString()}');
    }
  }

  @override
  Future<void> leaveEvent(String eventId, String userId) async {
    try {
      await supabaseClient
          .from('event_participant')
          .delete()
          .eq('event_id', eventId)
          .eq('user_id', userId);
    } catch (e) {
      throw ServerException('Failed to leave event: ${e.toString()}');
    }
  }

  @override
  Future<void> incrementViewCount(String eventId) async {
    try {
      // Get current view_count and increment
      final response = await supabaseClient
          .from('event')
          .select('view_count')
          .eq('id', eventId)
          .single();

      final currentCount = (response['view_count'] as num?)?.toInt() ?? 0;

      await supabaseClient
          .from('event')
          .update({'view_count': currentCount + 1})
          .eq('id', eventId);

      Logger.info(
        'Incremented view count for event $eventId: ${currentCount + 1}',
        tag: 'EventDataSource',
      );
    } catch (e) {
      // Don't throw - view count increment failure shouldn't break the app
      Logger.warning(
        'Failed to increment view count for event $eventId: $e',
        tag: 'EventDataSource',
      );
    }
  }
}
