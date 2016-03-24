#!/usr/bin/env bash
#
# create PetaLinux BSP
#

function do_file_cleanup ()
{
	rm -fr ${CLEANUP_LIST}
}

function add_to_cleanup ()
{
	CLEANUP_LIST="${CLEANUP_LIST} $@"
}

function fail_exit ()
{
	echo "Error: $@"
	exit 255
}

# Install a cleanup handler
trap do_file_cleanup EXIT KILL QUIT SEGV INT HUP TERM

rootdir=$(dirname $(readlink -f "$0"))

if ! which petalinux-package > /dev/null; then
	echo "Error: Please source PetaLinux Tools before using this script"
fi

if ! which bootgen > /dev/null; then
	echo "Error: Please source Vivado before using this script"
fi

workdir=${rootdir}/projects
release_dir=${rootdir}/releases

[ -d ${release_dir} ] || mkdir -p ${release_dir}
pushd $workdir > /dev/null
for d in $(find ${workdir} -maxdepth 2 -name ".petalinux" -type d); do
	proj_dir=$(echo $d | sed "s:/.petalinux::g")
	if [ -f "${proj_dir}/config.project" ]; then
		if echo $proj_dir | grep '.old$' > /dev/null; then
			continue
		fi
		echo "##### Found bsp: ${proj_dir}"
		proj_name=$(basename ${proj_dir})
		if [ -d ${proj_dir}/hardware/ ]; then
			hw_proj=$(find ${proj_dir}/hardware/ -mindepth 1 -maxdepth 1 -type d | tail -1)
			hw_opt=" --hwsource ${hw_proj}"
		fi
		# update prebuilt images
		hdf_file=${proj_dir}/subsystems/linux/hw-description/system.hdf
		# extract hdf
		tmp_dir=$(mktemp -d)
		add_to_cleanup $tmp_dir
		fn=$(unzip -l ${hdf_file} | awk '{print $NF}' | grep ".bit")
		unzip -o $hdf_file $fn -d $tmp_dir > /dev/null
		petalinux-package --force --boot --u-boot \
			--fpga ${tmp_dir}/${fn} \
			-o $proj_dir/images/linux/BOOT.BIN \
			-p $proj_dir || fail_exit "Unable to create boot.bin"
		# update boot.bin
		petalinux-package --prebuilt --force -p $proj_dir || \
			fail_exit "Unable to update prebuilt"

		petalinux-package --force --bsp -p ${proj_dir} \
			-o ${release_dir}/${proj_name}.bsp ${hw_opt} $@ || \
			fail_exit "Fail to create BSP - ${proj_name}.bsp"
	fi
done
popd >/dev/null