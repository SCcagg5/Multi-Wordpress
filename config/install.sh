#!/bin/sh
export LANG=C.UTF-8

cmd=('-n' '-c')
CMD=('--new' '--color')
new="off"
color="off"

check_arg ()
{
    N="\\033[00m"
    R=$N
    G=$N
    B=$N
    verbose="off"
    color="off"
    local err=0
    for arg in "$@"
    do
	size=$(echo -n "$arg" | wc -c)
	if [ "$(echo "$arg" | head -c 2)" = '--' ]
	then
		array_contains "$arg" "${CMD[@]}"
	else
		for ((i=2;i<=size;i+=1))
		do
      letter="-$(echo "$arg" | head -c $i | tail -c 1)"
			array_contains "$letter" "${cmd[@]}"
		done
	fi
    done
    if [ "$err" = "1" ]
    then
	exit
    fi
}

error()
{
    err="1"
    error=$1
    error_nb=$2
    if [ "$verbose" = "on" ]
    then
		printf "$B$Tab   -> %s %s$N: " "$RERROR" "$error_nb"
		printf "$R%s$N$New" "$error"
    else
		printf "$R%s$N$New" "$error"
    fi
}

array_contains () {
    local seeking=$1; shift
    local in=1
    for element; do
        if [[ "$element" == "$seeking" ]]; then
            in=0
		add "$seeking"
            break
        fi
    done
    return $in
}

add () {
	local arg=$1
	if [ "$arg" = "-c" ] || [ "$arg" = "--color" ]
	then
	    color="on"
	    R="\\033[31m"
	    G="\\033[32m"
	    B="\\033[34m"
	fi
  if [ "$arg" = "-n" ] || [ "$arg" = "--new" ]
	then
	    new="on"
	fi
}


install ()
{
apt-get install curl git -y > /dev/null
git clone https://github.com/SCcagg5/Multi-Wordpress ~/sources_wp_multi > /dev/null
curl https://get.docker.com/ -o docker.sh > /dev/null
bash docker.sh > /dev/null
rm docker.sh > /dev/null
apt-get install docker-compose -y > /dev/null
cp ~/sources_wp_multi/project/nginx ~/nginx -r
cd ~/nginx
docker-compose up -d
cd -
}

add_wp ()
{
  for arg in "$@"
  do
    domain=$(echo $arg | grep -P '(?=^.{4,253}$)(^(?:[a-zA-Z0-9](?:(?:[a-zA-Z0-9\-]){0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$)')
    if [[ $domain != "" ]];
    then
      cp ~/sources_wp_multi/project/base_wp ~/$domain -r
      cp ~/$domain/sample.env ~/$domain/.env
      echo "VIRTUAL_HOST=$domain" >> ~/$domain/.env
      cd ~/$domain
      docker-compose up -d
      cd -
    fi
  done
}


check_arg "$@"
if [ "$new" = "on" ]
  then
    install
fi
add_wp "$@"
rm -rf ~/sources_wp_multi
