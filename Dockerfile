FROM ghcr.io/cirruslabs/flutter:3.24.0 AS build
WORKDIR /app

# Cache deps layer
COPY pubspec.* ./
RUN flutter pub get

# Copy source and generate Riverpod code-gen files before building
COPY . .
RUN dart run build_runner build --delete-conflicting-outputs

# Build web release
RUN flutter build web --release --base-href /

FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
# SPA fallback so Flutter's client-side router doesn't 404 on refresh / deep links
RUN printf 'server { listen 80; root /usr/share/nginx/html; index index.html; location / { try_files $uri $uri/ /index.html; } }\n' > /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
