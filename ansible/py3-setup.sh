declare -A OsInstaller;
OsInstaller[/etc/debian_version]="apt -y install"
OsInstaller[/etc/centos-release]="yum -y install"
OsInstaller[/etc/fedora-release]="dnf -y install"

for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        package_manager=${OsInstaller[$f]}
    fi
done

sudo $package_manager python3
