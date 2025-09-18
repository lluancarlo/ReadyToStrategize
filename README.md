# RTS Prototype – Godot 4.5

This project is a **small prototype of a Real-Time Strategy (RTS) game**, built with the [Godot Engine 4.5](https://godotengine.org/).  
It demonstrates the **basic core mechanics of RTS games**:

- **Select a unit** with **Left Click (LMB)**  
- **Move the selected unit** to a location with **Right Click (RMB)**

---

## 🎮 Features
- Simple unit selection system  
- Unit movement using the mouse  
- Click-to-move mechanics on a 2D/3D grid (depending on your project setup)  
- Minimal and modular design, intended for learning and prototyping  

---

## 🛠️ Requirements
- [Godot Engine 4.5](https://godotengine.org/download)  
- Any OS supported by Godot (Windows, Linux, macOS)  

---

## 🚀 Getting Started
1. Clone or download this repository:
   ```
   git clone https://github.com/yourusername/godot-rts-prototype.git
   ```
2. Open **Godot 4.5**  
3. Click **Import Project** and select the `project.godot` file  
4. Run the project (F5)  

---

## 🎮 Controls
| Action        | Key / Mouse             |
|---------------|-------------------------|
| Select unit   | **Left Mouse Button**   |
| Move unit     | **Right Mouse Button**  |

---

## 📂 Project Structure
```
res://
│── project.godot        # Godot project file
│── characters/          # Characters script
│── components/          # Components scripts
│── controllers/         # Core gameplay scripts
│── globals/             # Globals scripts
│── game.tscn            # Main scene
└── game.tscn            # Project icon
```

---

## 📌 Notes
- This is a **learning prototype**, not a full RTS game  
- The project is intended as a **foundation for expanding** into a larger RTS (e.g. adding multiple unit types, buildings, resource management, etc.)  

---

## 📜 License
This project is released under the **MIT License**.  
You are free to use, modify, and distribute it.
