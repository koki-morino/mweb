Compile protos for Go:
$ protoc --proto_path=. --go_out=../api/ *.proto

Compile protos for Dart:
$ dart pub global activate protoc_plugin
$ protoc --proto_path=. --dart_out=../app/lib/protos/ *.proto

Dart also needs to compile third-party protos (e.g. google/protobuf/empty.proto)
when you use them.
