# Q.wiki Perl Dependency Builder

Dockerfiles to create docker images for various OS's which are able to create distribution perl-packages
from CPAN.

## Usage

Create a distribution package using the build script. The packages will be moved to the `builds/` folder.

Run

```
$ ./build.sh --help
```

to gather more information.

## Examples

```
$ ./build.sh -p Data::Pageset
```

* Creates an rpm and deb package to install the Perl Lib `Data::Pageset` (latest) on RedHat7, Debian8,
Debian10 and Debian10.

```
$ ./build.sh -p JSON::XS -d debian10 -v 4.0
```

* Creates an deb package to install the Perl Lib `Data::Pageset` (Version 4.0) on Debian10.

```
$ ./build.sh --docker-image -d deb
```

* Builds the Docker images for Debian8, Debian9 and Debian10.
