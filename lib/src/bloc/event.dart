class Event {
  EventType type;

  Event(EventType this.type);

  factory Event.add() => Event(EventType.ADD);
  factory Event.delete() => Event(EventType.DELETE);
  factory Event.error() => Event(EventType.ERROR);
}

enum EventType { ADD, DELETE, ERROR }
