rm -rf build
meson build --prefix=/usr
cd build
cp -r ../data/* ./
ninja
./com.github.abbysoft-team.compose

