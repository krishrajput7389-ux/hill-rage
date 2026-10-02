# Hill Rage - Physics Driving Game 🚗

A 2D physics-based endless driving game built from scratch using **Godot 4**. 

**🎮 [PLAY THE GAME HERE ON ITCH.IO] https://krishrajput7389.itch.io/hill-rage **

## 🌟 Features
* **Dynamic Physics Engine:** Real-time torque and suspension balancing using RigidBody2D nodes.
* **Procedural Generation:** The track chunks are infinitely generated using sine wave math functions.
* **Audio Engineering:** Features dynamic engine pitch-scaling based on the car's angular velocity and seamless background music shuffling.
* **Custom Start Interface & UI:** Animated 1000m milestone popups and real-time distance tracking.

## 🛠️ Tech Stack
* **Game Engine:** Godot 4
* **Language:** GDScript
* **Target:** HTML5 / Web (Exported with SharedArrayBuffer support)

## 🎮 How to Play

The goal is simple: **Drive as far as you can without flipping your car.** The track generates endlessly, so no two runs are ever exactly the same.

### Controls:
*   **Accelerate / Lean Forward:** Press `D` or `Right Arrow` ➡️
*   **Brake / Reverse / Lean Back:** Press `A` or `Left Arrow` ⬅️

### The Catch (Physics!):
This isn't just about speed; it's about balance. The car is completely driven by torque physics. If you hit a steep hill too fast and tilt past **105 degrees**, you're WASTED and your run is over. 

## 🛠️ Behind the Scenes (Tech Stuff)

*   **Engine:** Built using [Godot 4](https://godotengine.org/).
*   **Infinite Track:** The hills are generated endlessly using sine wave math, making the terrain continuously unpredictable.
*   **Suspension:** I used `PinJoint2D` nodes to give the car a heavy, bouncy suspension feel when landing heavy jumps.
*   **Movement:** 100% torque-driven physics applied directly to the RigidBody2D wheels.
