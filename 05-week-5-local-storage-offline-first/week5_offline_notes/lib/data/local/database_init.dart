import 'database_init_stub.dart'
    if (dart.library.html) 'database_init_web.dart'
    if (dart.library.io) 'database_init_io.dart'
    as platform;

void initializeLocalDatabase() => platform.initializeLocalDatabase();
