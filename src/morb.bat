mkdir build
nasm -fobj test.asm -o build/test.o
nasm -fobj string/string.asm -o build/string.o
nasm -fobj window.asm -o build/window.o
alink.exe -subsys console -oPE build/test.o build/string.o build/window.o glfw3dll.lib -o build/test.exe
cd build
del test.o
del string.o
del window.o
copy glfw3.dll build
test.exe
cd ..