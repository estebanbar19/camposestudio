class ChatCompletionResponse{
  String _id;
  String _object;
  int _created;
  List<Choice> _choices;
  Usage _usage;

  ChatCompletionResponse(this._id, this._object, this._created, this._choices, this._usage);

  Usage get usage => _usage;

  List<Choice> get choices => _choices;

  int get created => _created;

  String get object => _object;

  String get id => _id;

  factory ChatCompletionResponse.fromJson(Map<String, dynamic> json) {
    String id = json['id'];
    String object = json['object'];
    int created = json['created'];
    List<Choice> choices = (json['choices'] as List).map((choiceJson) => Choice.fromJson(choiceJson)).toList();
    Usage usage = Usage.fromJson(json['usage']);
    return ChatCompletionResponse(id, object, created, choices, usage);
  }
}

class Choice{
  int _index;
  Message _message;
  String _finishReason;

  Choice(this._index, this._message, this._finishReason);

  String get finishReason => _finishReason;

  Message get message => _message;

  int get index => _index;

  factory Choice.fromJson(dynamic json){
    return Choice(json['index'] as int, Message.fromJson(json['message']), json['finish_reason'] as String);
  }
}

class Message{
  String _role;
  String _content;

  Message(this._role, this._content);

  String get content => _content;

  String get role => _role;

  factory Message.fromJson(dynamic json){
    return Message(json['role'] as String, json['content'] as String);
  }
}

class Usage {
  int _promptTokens;
  int _completionTokens;
  int _totalTokens;

  Usage(this._promptTokens, this._completionTokens, this._totalTokens);

  int get totalTokens => _totalTokens;

  int get completionTokens => _completionTokens;

  int get promptTokens => _promptTokens;

  factory Usage.fromJson(dynamic json){
    return Usage(json['prompt_tokens'] as int, json['completion_tokens'] as int, json['total_tokens'] as int);
  }
}