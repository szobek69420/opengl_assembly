mkdir build
nasm -fobj test.asm -o build/test.o
nasm -fobj string/string.asm -o build/string.o
alink.exe -subsys console -oPE build/test.o build/string.o glfw3dll.lib -o build/test.exe
cd build
del test.o
del string.o
test.exe
cd ..