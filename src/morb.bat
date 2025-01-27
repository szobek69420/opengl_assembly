cls
mkdir build
nasm -fobj test.asm -o build/test.o
nasm -fobj string/string.asm -o build/string.o
nasm -fobj window/window.asm -o build/window.o
nasm -fobj game_loop/game_loop.asm -o build/game_loop.o
nasm -fobj opengl/opengl.asm -o build/opengl.o
nasm -fobj shader/shader.asm -o build/shader.o
nasm -fobj kuba/kuba.asm -o build/kuba.o
nasm -fobj utils/console.asm -o build/console.o
nasm -fobj utils/memory.asm -o build/memory.o
nasm -fobj utils/file.asm -o build/file.o
alink.exe -subsys console -oPE ^
build/test.o ^
build/string.o ^
build/window.o ^
build/game_loop.o ^
build/opengl.o ^
build/shader.o ^
build/kuba.o ^
build/console.o ^
build/memory.o ^
build/file.o ^
glfw3dll.lib ^
-o build/test.exe
copy glfw3.dll build
cd build
del *.o
test.exe
del test.exe
cd ..