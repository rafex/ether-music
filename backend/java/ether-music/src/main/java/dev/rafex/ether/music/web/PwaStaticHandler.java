package dev.rafex.ether.music.web;

import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Request;
import org.eclipse.jetty.server.Response;
import org.eclipse.jetty.util.Callback;

public final class PwaStaticHandler extends Handler.Abstract {

    // language=json
    private static final String MANIFEST = """
            {
              "name": "Ether Music",
              "short_name": "Ether ♪",
              "description": "Generador de melodías algorítmicas via REST y Web Audio",
              "start_url": "/",
              "scope": "/",
              "display": "standalone",
              "orientation": "any",
              "background_color": "#090b0f",
              "theme_color": "#00e5ff",
              "categories": ["music", "entertainment"],
              "icons": [
                { "src": "/icons/icon.svg", "sizes": "any", "type": "image/svg+xml", "purpose": "any" },
                { "src": "/icons/icon-maskable.svg", "sizes": "any", "type": "image/svg+xml", "purpose": "maskable" }
              ]
            }
            """;

    private static final String ICON_SVG = """
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 192 192">
              <rect width="192" height="192" fill="#090b0f"/>
              <rect x="18" y="86" width="14" height="20" rx="3" fill="#00e5ff"/>
              <rect x="40" y="66" width="14" height="60" rx="3" fill="#00e5ff"/>
              <rect x="62" y="76" width="14" height="40" rx="3" fill="#00e5ff"/>
              <rect x="84" y="52" width="14" height="88" rx="3" fill="#00e5ff"/>
              <rect x="106" y="76" width="14" height="40" rx="3" fill="#00e5ff"/>
              <rect x="128" y="66" width="14" height="60" rx="3" fill="#00e5ff"/>
              <rect x="150" y="80" width="14" height="32" rx="3" fill="#ff6b35"/>
            </svg>
            """;

    private static final String ICON_MASKABLE_SVG = """
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 192 192">
              <rect width="192" height="192" fill="#090b0f"/>
              <rect x="28" y="86" width="12" height="20" rx="3" fill="#00e5ff"/>
              <rect x="48" y="70" width="12" height="52" rx="3" fill="#00e5ff"/>
              <rect x="68" y="78" width="12" height="36" rx="3" fill="#00e5ff"/>
              <rect x="88" y="58" width="12" height="76" rx="3" fill="#00e5ff"/>
              <rect x="108" y="78" width="12" height="36" rx="3" fill="#00e5ff"/>
              <rect x="128" y="70" width="12" height="52" rx="3" fill="#00e5ff"/>
              <rect x="148" y="82" width="12" height="28" rx="3" fill="#ff6b35"/>
            </svg>
            """;

    // language=javascript
    private static final String SERVICE_WORKER = """
            const CACHE = 'ether-music-v1';
            const SHELL = ['/'];

            self.addEventListener('install', (e) => {
              e.waitUntil(caches.open(CACHE).then((c) => c.addAll(SHELL)));
              self.skipWaiting();
            });

            self.addEventListener('activate', (e) => {
              e.waitUntil(
                caches.keys().then((keys) =>
                  Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k)))
                )
              );
              self.clients.claim();
            });

            self.addEventListener('fetch', (e) => {
              if (e.request.method !== 'GET') return;

              const url = new URL(e.request.url);

              if (url.pathname === '/') {
                e.respondWith(
                  caches.match(e.request).then((cached) =>
                    fetch(e.request)
                      .then((res) => {
                        caches.open(CACHE).then((c) => c.put(e.request, res.clone()));
                        return res;
                      })
                      .catch(() => cached)
                  )
                );
                return;
              }

              if (url.pathname.startsWith('/api/songs')) {
                e.respondWith(
                  caches.open(CACHE).then((cache) =>
                    cache.match(e.request).then((cached) => {
                      const net = fetch(e.request).then((res) => {
                        if (res.ok) cache.put(e.request, res.clone());
                        return res;
                      }).catch(() => cached);
                      return net;
                    })
                  )
                );
                return;
              }

              if (url.pathname.startsWith('/api/')) {
                e.respondWith(fetch(e.request));
                return;
              }

              e.respondWith(
                caches.match(e.request).then((cached) => cached || fetch(e.request))
              );
            });
            """;

    @Override
    public boolean handle(final Request request, final Response response, final Callback callback) {
        final var path = request.getHttpURI().getPath();
        return switch (path) {
            case "/manifest.json" -> {
                ResponseWriters.plainJson(response, callback, 200, MANIFEST);
                yield true;
            }
            case "/sw.js" -> {
                response.getHeaders().put("service-worker-allowed", "/");
                ResponseWriters.js(response, callback, 200, SERVICE_WORKER);
                yield true;
            }
            case "/icons/icon.svg" -> {
                ResponseWriters.svgIcon(response, callback, 200, ICON_SVG);
                yield true;
            }
            case "/icons/icon-maskable.svg" -> {
                ResponseWriters.svgIcon(response, callback, 200, ICON_MASKABLE_SVG);
                yield true;
            }
            default -> false;
        };
    }
}
