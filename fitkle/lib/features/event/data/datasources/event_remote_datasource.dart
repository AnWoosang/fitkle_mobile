import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fitkle/core/error/exceptions.dart';
import 'package:fitkle/core/utils/logger.dart';
import 'package:fitkle/features/event/data/models/event_model.dart';

abstract class EventRemoteDataSource {
  Future<List<EventModel>> getEvents({String? category, String? searchQuery, bool? isGroupEvent});
  Future<EventModel> getEventById(String eventId);
  Future<List<EventModel>> getUpcomingEvents();
  Future<List<EventModel>> getEventsByHost(String hostId);
  Future<EventModel> createEvent(EventModel event);
  Future<EventModel> updateEvent(EventModel event);
  Future<void> deleteEvent(String eventId);
  Future<void> joinEvent(String eventId, String userId);
  Future<void> leaveEvent(String eventId, String userId);
}

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final SupabaseClient supabaseClient;

  EventRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<EventModel>> getEvents({String? category, String? searchQuery, bool? isGroupEvent}) async {
    try {
      var query = supabaseClient.from('event').select();

      // Filter by category (skip if null or 'ALL')
      if (category != null && category.isNotEmpty && category != 'ALL') {
        query = query.eq('category', category);
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
        'Fetching events - category: $category, search: $searchQuery, isGroupEvent: $isGroupEvent',
        tag: 'EventDataSource',
      );

      final response = await query.order('created_at', ascending: false);

      Logger.response(
        200,
        'Supabase REST API /rest/v1/event',
        data: {
          'count': (response as List).length,
          'sample': response.take(2).toList(), // Show first 2 items as sample
        },
      );

      Logger.debug(
        'Raw response sample: ${response.take(1).toList()}',
        tag: 'EventDataSource',
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
  Future<List<EventModel>> getUpcomingEvents() async {
    try {
      final response = await supabaseClient
          .from('event')
          .select()
          .order('date', ascending: true)
          .limit(20);

      return (response as List).map((json) => EventModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Failed to fetch upcoming events: ${e.toString()}');
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
}
