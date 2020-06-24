#!/bin/bash

build() {

    usage() {
        printf -v text "%s" \
            "build [OPTION...]\n" \
            "    -d, --distro           specify distro pattern, e.g. \"deb\" would match debian8 and debian10\n" \
            "    -p, --package          cpan package to build, e.g. JSON::XS\n" \
            "    -v, --version          build the specified Version of the package. Defaults to latest\n" \
            "    -i, --docker-image     only build the docker images\n" \
            "    -h, --help             shows this help message\n"
        printf "$text"
    }

    filter-distros() {
        if [ "$DISTRO" ]; then
            for elem in "${distros[@]}"; do [[ $elem =~ $DISTRO ]] && with_distros+=("$elem"); done
        else
            for elem in "${distros[@]}"; do with_distros+=("$elem"); done
        fi
    }

    check-params() {
        if [ -z "$PACKAGE" ] && [ -z "$IS_DOCKER_IMAGE" ]; then
            echo "CPAN Module name missing."
            exit 1
        elif [ ${#with_distros[@]} -eq 0 ]; then
            echo "Distro pattern resulted in an empty list."
            exit 1
        fi
    }

    move-packages() {
        mkdir -p ./builds/$distro_basename/$distro_version
        build_packages=$(find ./distros/$distro_basename/$distro_version/ -name "*.deb" -o -name "*.rpm")
        if [[ "$build_packages" ]]; then
            echo $build_packages | xargs cp -t ./builds/$distro_basename/$distro_version/
        else
            echo "Could not find any packages."
            exit 1
        fi
    }

    # install-signing-key() {
    #     mkdir "./distros/"
    # }

    IS_DOCKER_IMAGE=0
    distros=(debian8 debian9 debian10 redhat7)

    OPTS=`getopt -o d:p:v:ih --long distro:,package:,version:,docker-image,help -- "$@"`
    if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi

    eval set -- "$OPTS"

    while true; do
        case "$1" in
            -d | --distro )
                DISTRO=$2
                shift 2 ;;
            -p | --package )
                PACKAGE=$2
                shift 2 ;;
            -v | --version )
                VERSION=$2
                shift 2 ;;
            -i | --docker-image )
                IS_DOCKER_IMAGE=1
                shift ;;
            -h | --help )
                usage
                return
                shift ;;
            -- )
                shift
                break ;;
            * )
                break ;;
        esac
    done

   # install-signing-key

    filter-distros

    check-params

    rm -rf ./builds/*
    echo "Using distros: ${with_distros[@]}"

    for distro in "${with_distros[@]}"; do
        echo "Building for distro: $distro"
        [[ $distro =~ ^([a-z]+)([0-9]+)$ ]] && distro_basename="${BASH_REMATCH[1]}" && distro_version="${BASH_REMATCH[2]}"
        docker build -t qwiki-$distro_basename-$distro_version -f ./distros/$distro_basename/$distro_version/Dockerfile ./distros/$distro_basename
        if [[ "$IS_DOCKER_IMAGE" = 0 ]]; then
            docker run -v $(pwd)/distros/$distro_basename/$distro_version/build:/opt/build -it --rm qwiki-$distro_basename-$distro_version $PACKAGE $VERSION
            move-packages
        else
            echo "Done building docker images."
            exit 0
        fi
    done
    echo "Done building packages. You'll find them in the builds/ folder."
}

build $@
