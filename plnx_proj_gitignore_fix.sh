#!/usr/bin/env bash
#
# create PetaLinux BSP
#

workdir=$(dirname $(readlink -f "$0"))/projects

if ! which petalinux-package > /dev/null; then
	echo "Error: Please source PetaLinux Tools before using this script"
fi

pushd $workdir > /dev/null
for d in $(find ${workdir} -maxdepth 2 -name ".petalinux" -type d); do
	proj_dir=$(echo $d | sed "s:/.petalinux::g")
	if [ -f "${proj_dir}/config.project" ]; then
		if echo $proj_dir | grep '.old$' > /dev/null; then
			continue
		fi
		echo "Updating .gitignore for ${proj_dir}"
		cat > ${proj_dir}/.gitignore <<_EOF
**/config.old
/build/
/images/
/.petalinux/*
!.petalinux/metadata
*.o
*.jou
*.log
_EOF
	fi
done
popd > /dev/null