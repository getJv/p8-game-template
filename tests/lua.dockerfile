# docker run --rm -v ${PWD}:/app getjv/lua lua vendor/tests/utils_spec.lua

# docker build -t getjv/lua -f vendor/tests/lua.dockerfile .
# Minimal Alpine-based image with Lua + luaunit via wget
FROM alpine:3.20

# Install Lua and tools, fetch luaunit
RUN apk add --no-cache lua5.4 wget ca-certificates \
 && update-ca-certificates \
 && mkdir -p /usr/share/lua/5.4 \
 && wget -O /usr/share/lua/5.4/luaunit.lua https://raw.githubusercontent.com/bluebird75/luaunit/master/luaunit.lua \
 && ln -s /usr/bin/lua5.4 /usr/bin/lua

# Working directory where the repo will be mounted
WORKDIR /app

CMD ["lua"]




