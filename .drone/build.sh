#!/bin/bash
# this is kind of an expensive check, so let's not do this twice if we
# are running more than one validate bundlescript

REPO='https://github.com/arckosfr/dockerfiles.git'
BRANCH='master'
USER='arckosfr'
DOCKER_PUSH=$1
ERROR=0

CSI="\033["
CEND="${CSI}0m"
CRED="${CSI}1;31m"
CGREEN="${CSI}1;32m"
CYELLOW="${CSI}1;33m"
CBLUE="${CSI}1;34m"

docker pull xataz/alpine:3.5
docker pull xataz/node:7

git fetch -q "$REPO" "refs/heads/$BRANCH"

mkdir .tmp
echo "" > .tmp/images.txt

for f in $(git diff HEAD~ --diff-filter=ACMRTUX --name-only | cut -d"/" -f1 | grep -v wip | grep -v unmaintained | grep -v .drone | uniq); do
    if [ -d $f ]; then
        if [ -e $f/build.sh ]; then
            chmod +x $f/build.sh
            echo 
            ./$f/build.sh ${USER}/$f
        else
            for dockerfile in $(find $f -name Dockerfile); do
                FOLDER=$(dirname $dockerfile)
                LOG_FILE="/tmp/${f}_$(date +%Y%m%d).log"
                echo -e "Build $dockerfile with context $FOLDER on tmp-build-$f [${CYELLOW}..${CEND}]"
                docker build -f $dockerfile -t tmp-build-$f $FOLDER > $LOG_FILE 2>&1
                if [ $? != 0 ]; then
                    echo -e "Build $dockerfile with context $FOLDER on tmp-build-$f [${CRED}KO${CEND}]"
                    ERROR=1
                    cat $LOG_FILE
                else
                    echo -e "Build $dockerfile with context $FOLDER on tmp-build-$f [${CGREEN}OK${CEND}]"
                    for tag in $(grep "tags=" $dockerfile | cut -d'"' -f2); do
                        echo -e "Tags tmp-build-$f to ${USER}/${f}:${tag} [${CYELLOW}..${CEND}]"
                        docker tag tmp-build-$f ${USER}/${f}:${tag}
                        if [ $? != 0 ]; then
                            echo -e "Tags tmp-build-$f to ${USER}/${f}:${tag} [${CRED}KO${CEND}]"
                            ERROR=1
                        else
                            echo -e "Tags tmp-build-$f to ${USER}/${f}:${tag} [${CGREEN}OK${CEND}]"
                            echo ${USER}/${f}:${tag} >> .tmp/images.txt
                        fi
                    done
                fi
            done
            docker images | grep tmp-build-$f > /dev/null 2>&1
            if [ $? -eq 0 ]; then docker rmi tmp-build-$f; fi
        fi
        
    fi
done

if [ ${ERROR} -gt 0 ]; then
    exit 1
fi

