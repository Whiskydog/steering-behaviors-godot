# steering-behaviors-godot

<p align="center">
  <img src="https://i.imgur.com/nr6IaIO.png">
</p>

---

Steering behaviors implementation in Godot Engine. Mainly for self-educational purposes.

This Godot project showcases some of the Steering Behaviors introduced by [Craig W. Reynolds](https://www.red3d.com/cwr/) in his paper [Steering Behaviors For Autonomous Characters](https://www.red3d.com/cwr/steer/gdc99/).

Daniel Shiffman's [The Nature of Code](https://natureofcode.com/book/) was also of great help.

With this project, I hope to help developers gain some insight into steering behaviors, and/or help them implement them in the Godot Engine.

## Debug Menu

Press **F5** to bring up the *Debug Menu*, where you can change between the available Steering Behaviors Test Scenes.

You also get information about the steering agent's velocity and orientation as a black line and a small 2D gizmo.

## Steering Behaviors

Implemented behaviors are:

- Seek

- Flee

- Arrive

- Wander

- Pursuit

- Evade

- Obstacle Avoidance

- Containment

- Follow Flow Field

- Follow Path (just use [Godot's Path Following](https://docs.godotengine.org/en/stable/classes/class_pathfollow2d.html))

- Flock

- Separation
  
Please refer to Reynold's paper for detailed information on these behaviors.
