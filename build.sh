#!/bin/bash
# this is kind of an expensive check, so let's not do this twice if we
# are running more than one validate bundlescript

REPO='https://github.com/arckosfr/dockerfiles.git'
BRANCH='master'
USER='arckosfr'
DOCKER_PUSH=$1

CSI="\033["
CEND="${CSI}0m"
CRED="${CSI}1;31m"
CGREEN="${CSI}1;32m"
CYELLOW="${CSI}1;33m"
CBLUE="${CSI}1;34m"

HEAD="$(git rev-parse --verify HEAD)"

git fetch -q "$REPO" "refs/heads/$BRANCH"
UPSTREAM="$(git rev-parse --verify FETCH_HEAD)"

COMMIT_DIFF="$UPSTREAM...$HEAD"

validate_diff() {
	if [ "$UPSTREAM" != "$HEAD" ]; then
		git diff "$COMMIT_DIFF" "$@"
	else
		git diff HEAD~ "$@"
	fi
}

build_image() {
  image_name=$1
  image_dir=$2
  tags_list=${latest-$(grep 'tags=' $image_dir/Dockerfile | cut -d'"' -f2)}


  for tag in $tags_list; do
    echo -e "${CBUILD}Build ${USER}/${image_name}:${tag} on ${image_dir}${CEND}"
    docker build -t ${USER}/${image_name}:${tag} ${image_dir}
    if [ $? == 0 ]; then
      echo -e "${CGREEN}                       ---                                   "
      echo -e "Successfully built ${USER}/${image_name}:${tag} with context ${image_dir}"
      echo -e "                       ---                                   ${CEND}"
      if [ "$DOCKER_PUSH" == "push" ]; then
        echo -e "${CYELLOW}Push ${USER}/${image_name}:${tag}${CEND}"
        docker push ${USER}/${image_name}:${tag}
        echo -e "${CYELLOW}                       ---                                   "
        echo -e "Successfully push ${USER}/${image_name}:${tag}"
        echo -e "                       ---                                   ${CEND}"
      fi
    else
      echo -e "${CRED}                       ---                                   "
      echo -e "Failed built ${USER}/${image_name}:${tag} with context ${image_dir}"
      echo -e "                       ---                                   ${CEND}"
      exit 1
    fi
  done
}


# get the dockerfiles changed
IFS=$'\n'
files=( $(validate_diff --diff-filter=ACMRTUX --name-only -- '*Dockerfile') )
unset IFS

# build the changed dockerfiles
for f in "${files[@]}"; do
    image=${f%Dockerfile}
    base=${image%%\/*}
    build_dir=$(dirname $f)

		if [ -e ${build_dir}/custom.sh ]; then
			echo -e "${CBLUE}                       ---                                   "
			echo -e "Build ${build_dir} with custom.sh"
			echo -e "                       ---                                   ${CEND}"
			chmod +x ${build_dir}/custom.sh
			./${build_dir}/custom.sh $DOCKER_PUSH
			if [ $? == 0 ]; then
				echo -e "${CGREEN}                       ---                                   "
				echo -e "Successfully built ${build_dir} with custom.sh"
				echo -e "                       ---                                   ${CEND}"
			else
				echo -e "${CRED}                       ---                                   "
	      echo -e "Failed built ${build_dir} with custom.sh"
	      echo -e "                       ---                                   ${CEND}"
	      exit 1
			fi
	  else
    	build_image ${base} ${build_dir}
	  fi
done
