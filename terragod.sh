#!/bin/bash

# Who would win, 100 devops professionals or one gorilla

for dir in */; do
	for file in "${dir}"/*.tf; do
		#echo "${file}"__in__"${dir//\//}.tf"
		ln -s "${file}" "${file##*/}"__in__"${dir//\//}".tf
	done

	for file in "${dir}"/*.auto.tfvars; do
		#echo "${file}"__in__"${dir//\//}.auto.tfvars"
		ln -s "${file}" "${file##*/}"__in__"${dir//\//}".auto.tfvars
	done
done

ls -l | wc -l

#terraform init -upgrade
terraform apply

find . -maxdepth 1 -iname '*__in__*.tf' -type l -exec rm "{}" \;
find . -maxdepth 1 -iname '*__in__*.auto.tfvars' -type l -exec rm "{}" \;
