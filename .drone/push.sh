#!/bin/sh

if [ -e .tmp/images.txt ]; then
    for image in $(cat .tmp/images.txt); do
        docker push $image
    done
fi