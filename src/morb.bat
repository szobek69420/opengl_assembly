cls
mkdir build
nasm -fobj test.asm -o build/test.o
nasm -fobj string/string.asm -o build/string.o
nasm -fobj window/window.asm -o build/window.o
nasm -fobj player/player.asm -o build/player.o
nasm -fobj game_loop/game_loop.asm -o build/game_loop.o
nasm -fobj camera/camera.asm -o build/camera.o
nasm -fobj input/input.asm -o build/input.o
nasm -fobj glfw/glfw.asm -o build/glfw.o
nasm -fobj opengl/opengl.asm -o build/opengl.o
nasm -fobj shader/shader.asm -o build/shader.o
nasm -fobj kuba/kuba.asm -o build/kuba.o
nasm -fobj utils/console.asm -o build/console.o
nasm -fobj utils/memory.asm -o build/memory.o
nasm -fobj utils/file.asm -o build/file.o
nasm -fobj glm3/vec3.asm -o build/vec3.o
nasm -fobj glm3/vec4.asm -o build/vec4.o
nasm -fobj glm3/mat3.asm -o build/mat3.o
nasm -fobj glm3/mat4.asm -o build/mat4.o
nasm -fobj player/player.asm -o build/player.o
alink.exe -subsys console -oPE ^
build/test.o ^
build/string.o ^
build/window.o ^
build/player.o ^
build/game_loop.o ^
build/camera.o ^
build/input.o ^
build/glfw.o ^
build/opengl.o ^
build/shader.o ^
build/kuba.o ^
build/player.o ^
build/mat4.o ^
build/mat3.o ^
build/vec4.o ^
build/vec3.o ^
build/console.o ^
build/memory.o ^
build/file.o ^
glfw3dll.lib ^
-o build/test.exe
copy build\test.exe ..\game_files
cd build
del *.o
del test.exe
cd ..
cd ..
cd game_files
test.exe
cd ..
cd src