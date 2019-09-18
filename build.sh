#!/bin/bash

build() {

    usage() {
        printf -v text "%s" \
            "build [OPTION...]\n" \
            "    -d, --distro       specify distro pattern" \
            "    -p, --package      cpan package to build\n" \
            "    -v, --version      build specified Version. Defaults to latest\n" \
            "    -i, --images       only build the docker images\n" \
            "    -h, --help         shows this help message\n"
        printf "$text"
    }

    IMAGES=false

    OPTS=`getopt -o d:p:v:ih --long distro:,package:,version:,images,help -- "$@"`
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
            -i | --images )
                IMAGES=true
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

    distros=(debian8 debian10 redhat7)

    if [ "$DISTRO" ]; then
        for elem in "${distros[@]}"; do [[ $elem =~ $DISTRO ]] && with+=("$elem"); done
    else
        for elem in "${distros[@]}"; do with+=("$elem"); done
    fi

    if [ -z "$PACKAGE" ]; then
        echo "CPAN Module name missing."
        exit 1
    elif [ ${#with[@]} -eq 0 ]; then
        echo "Distro pattern resulted in an empty list."
        exit 1
    fi

    rm -rf ./builds/*
    echo "Using distros: ${with[@]}"

    for distro in "${with[@]}"; do
        echo "Building for distro: $distro"
        docker build -t qwiki-$distro -f ./$distro/Dockerfile ./$distro
        if [[ "$IMAGES" = false ]]; then
            docker run -v $(pwd)/$distro/build:/opt/build -it --rm qwiki-$distro $PACKAGE $VERSION
            mkdir -p ./builds/$distro
            find ./$distro/ -name "*.deb" | xargs cp -t ./builds/$distro/
            find ./$distro/ -name "*.rpm" | xargs cp -t ./builds/$distro/
        fi
    done
    echo "Done building packages. You can find them in the builds folder."
}

build $@