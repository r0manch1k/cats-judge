# set -euxo pipefail

apt-get update
apt-get install cpanminus build-essential libfile-copy-recursive-perl libxml-parser-perl fpc -y
cpanm --installdeps .
cat /root/.cpanm/work/1616219390.20031/build.log

# Configure proxy properly!
# Replace delphi with fpc
