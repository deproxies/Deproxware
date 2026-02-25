# Deproxware

![Deproxware Banner](https://i.imgur.com/HnULDUT.png)

> **"Built to keep you looking legit while still hitting everything."**
---

## 📸 Previews

| Aimbot Configuration | ESP Visuals |
| :---: | :---: |
| ![Aimbot Menu](https://i.imgur.com/tOd9ZRp.png) | ![ESP Example](https://i.imgur.com/sviEUZp.png) |
| *Fine-tune smoothing, FOV, and targeting.* | *Clean 2D Drawing with Item ESP.* |

---

## ✨ Features

### 🎯 Advanced Aimbot
* **Input Methods:** Choose between holding a designated keybind or using an automatic toggle.
* **Visibilit Check:** Utilizes optimized raycasting against core body parts to ensure you only target visible enemies, keeping your gameplay looking natural.
* **Smoothing:** Adjustable smoothing options to mimic natural mouse movement, preventing snappy, robotic tracking.
* **Target Prioritization:** Automatically ignores teammates, protected players, and users with active forcefields. Features a Target Switch Delay to prevent the aimbot from jittering between clustered players.
* **FOV:** Visual FOV ring (with optional RGB effects) dictates the active targeting area. 
* **Aim Method Support:** Supports both Camera manipulation and raw Mouse movement (`mousemoverel`).

### 👁️ Dual-Mode ESP Library
Deproxware offers two distinct ESP rendering methods, allowing you to prioritize either aesthetic fidelity or raw performance.

* **Drawing ESP (2D - Performance Optimized)**
    * Ideal for a competitive, high-FPS environment.
    * Renders classic boxes, skeletons, health bars, and distance metrics.
    * **Advanced Item/Loot ESP:** Input custom workspace paths and comma-separated item lists to only highlight the loot you actually need.
* **Legacy Highlights (3D - Aesthetic Focus)**
    * Utilizes Roblox's native `Highlight` instances for clean, glowing outlines that render through walls.
    * Fully customizable fill and outline transparencies.
* **Nametags:** Toggle between Usernames and Display Names with customizable offsets, sizing, and stroke colors.

## 🛡️ The Protect List
Located in the **Misc Tab**, the Protect List allows you to safeguard your friends or specific players. 
* **How to use:** Input a Username or UserID.
* **Effect:** The aimbot will completely ignore these players, and they will render in a unique, high-priority color on your ESP visuals.

---

## 🛠️ Execution & Stability
* **Auto-Persistence:** Features a "Re-execute on Teleport" system. The script will automatically restart itself when you hop servers or teleport between game instances.
* **Configuration:** Integrated with the Obsidian Save Manager. All settings—including your custom Item ESP paths and Protect Lists—are saved locally and can be loaded instantly.

---

## 📖 Further  Documentation

### Aimbot Adjustments
* **Target Part:** Select `Head` for aggressive tracking, or `Torso` if you are aiming for a highly legitimate playstyle.
* **Smoothness:** Increase this value to make your aim look more human. Lower it for faster snapping.
* **FOV (Field of View):** The aimbot will only track players who enter the designated radius around your cursor.

### ESP Color Priority System
To keep visual information clear during combat, the ESP prioritizes colors in the following order:
1.  **Protected Users** (Custom Whitelist)
2.  **Teammates** (If Team Color is enabled)
3.  **Visible Enemies** (Enemies you have a clear line of sight on)
4.  **Obscured Enemies** (Enemies behind cover)

---

## 🤝 Credits & Support

**Lead Developer:** deproxies (*deproxies* on Scriptblox, RScripts, Discord etc)
* **UI Framework:** Obsidian Library
* **Testing & Suggestions:** 7stk

💬 **Need help or want to report a bug?** Join the community Discord: [https://discord.gg/D8NpxgY99c](https://discord.gg/D8NpxgY99c)
