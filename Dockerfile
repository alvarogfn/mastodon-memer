# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.12)
FROM dart:3.1.0 AS build

# Resolve app dependencies.
WORKDIR /app

ENV accessToken=accessToken

COPY pubspec.* ./
RUN dart pub get

# Copy app source code and AOT compile it.
COPY . .
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
RUN dart compile exe bin/memerly.dart -o bin/main

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/main /app/bin/

CMD ["/app/bin/main"]
