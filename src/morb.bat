mkdir build
nasm -fobj test.asm -o build/test.o
nasm -fobj string/string.asm -o build/string.o
nasm -fobj window/window.asm -o build/window.o
nasm -fobj game_loop/game_loop.asm -o build/game_loop.o
nasm -fobj opengl/opengl.asm -o build/opengl.asm
alink.exe -subsys console -oPE build/test.o build/string.o build/window.o build/game_loop.o build/opengl.asm glfw3dll.lib -o build/test.exe
copy glfw3.dll build
cd build
del *.o
test.exe
cd ..