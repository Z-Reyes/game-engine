# game-engine
A student game engine that I made for Dr. Mailler's Game Engine Design course.
It supports the following features:
- Multiple shaders for objects across a rendering call.
- Model importing via Assimp.
- Real-time physics via the bullet physics library.
- Audio loading and playback (including listener positions) via OpenAL.
- Multiple lights and materials for shapes.
- Basic Keyframe animation support.
- Custom model format (with the .zShape extension)

Here is the source code for my project of Spring 2019. In the class, we were allowed
to use 3D models from online sources, but I've removed them for this repository due to their size
as well as potential copyright issues. As such, the project won't work out of the box (the main file acts as a scene loader for the project). I do have my zShape file format for default shapes as part of the project for people to look at.

I've also included a couple default shaders that were used for my project. I don't have a lot of experience with GLSL so this code is mainly placeholder code from other sources.
