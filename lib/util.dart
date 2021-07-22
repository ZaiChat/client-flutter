
import 'package:uuid/uuid.dart';

final UuidGenerator = Uuid();

UuidValue randomUuid() => UuidGenerator.v1obj();

