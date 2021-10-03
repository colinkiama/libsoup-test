# libsoup-test

A libsoup server test program.

It's based on the [Valadoc Soup.Server async example](https://valadoc.org/libsoup-2.4/Soup.Server.html) however, it uses the `server.listen` method instead of the `server.listen_all`.

## How to install
This project uses [meson](https://mesonbuild.com).

Assuming that you're using meson with ninja, enter these commands terminal in the
root of the project:
```sh
meson build
cd build
ninja install
```

Then you can run the server with this command:
```sh
libsoup-test
```

If you want to uninstall the server, in the `build` directory of the project
enter this command in your terminal:
```sh
ninja uninstall
```