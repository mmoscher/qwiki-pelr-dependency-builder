# Q.wiki Perl Dependency Builder

Dockerfiles to create docker images for various OS's which are able to create distribution packages.

## Usage

Create a distribution packages using the build script. The packages will be moved to the `builds/` folder.

Call

```
$ ./build.sh --help
```

to get more information.

## Examples

```
$ ./build.sh -p Data::Pageset
```

* Creates an rpm and deb package to install the Perl Lib `Data::Pageset` (latest) on RedHat7, Debian8 and Debian10.

```
$ ./build.sh -p JSON::XS -d debian10 -v 4.0
```

* Creates an deb package to install the Perl Lib `Data::Pageset` (Version 4.0) on Debian10.

```
$ ./build.sh --images -d deb
```

* Builds the Docker images for Debian10 and Debian8.
