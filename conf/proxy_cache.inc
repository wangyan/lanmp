proxy_cache lanmp;
proxy_cache_key "$scheme://$host$request_uri";
proxy_cache_valid 200 301 302 304 1d;