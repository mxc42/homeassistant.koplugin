# homeassistant.koplugin

This [KOReader](https://koreader.rocks/) plugin lets you control Home Assistant entities without leaving your current book!

<p align="center">
  Jump to the <a href="#installation">Installation</a> section
</p>

<p align="center">
<img src="assets/homeassistant_koplugin_screenshots.png"  alt="homeassistant.koplugin screenshots" />
  <i>homeassistant.koplugin menu (via Tools) [left] & as a QuickMenu gesture [right]</i>
</p>

## Features

- Control any number of Home Assistant entities from KOReader 
- Action support with custom data attributes e.g.:  
  - `light.turn_on` with brightness and color 
  - `media_player.play_media` with specific content
- Advanced targeting: single/multiple entities, areas or labels
- Entity state queries with customizable attributes e.g.:
  - `sensor.temperature_outside`: "state", "unit_of_measurement"
- Lightweight, unobtrusive interface  
- Simple text-based configuration  
- Success/error notifications

## How it Works:
Each entry in `config.lua` represents **one menu item / gesture action**.

There are two types of entries:

1. **Action entries (POST requests)**
   - Used to *control* Home Assistant entities
   - Require an `action`
   - May include `data`
   - Sent to `/api/services/{domain}/{action}`

2. **State query entries (GET requests)**
   - Used to *read* entity state and attributes
   - Must NOT include `action`
   - Use `attributes` to control output
   - Sent to `/api/states/{entity_id}`

## Installation
### Step 1: Download the Plugin
Download the latest release and unpack `homeassistant_koreader_plugin.zip`:  
https://github.com/moritz-john/homeassistant.koplugin/releases

### Step 2: Edit `config.lua`
>[!warning]
> Be aware of proper indentations, `{}` and `,` otherwise you will get syntax errors

#### Connection Settings
Edit the connection settings:

```lua
-- Home Assistant connection settings
host = "192.168.1.10",  -- Change to your Home Assistant IP Address
port = 8123,            -- Default Home Assistant Port
token =                 -- Change to your own Long-Lived Access Token
"PasteYourHomeAssistantLong-LivedAccessTokenHere",
```

>[!tip] 
> **How to create a Long-Lived Access Token:**   
> [**Home Assistant**](https://my.home-assistant.io/redirect/profile): *Profile → Security (scroll down) → Long-lived access tokens → Create token*  
> _Copy the token now - you won’t be able to view it again._

### Controlling Entities (Actions)
Let's start with a simple example: "turn on a light".  
The entry in `config.lua` would look like this:

```lua
{
    label = "Reading Lamp: turn_on",  -- (required)
    action = "light.turn_on",         -- (required)    
    target = "light.reading_lamp",    -- (required)
    data = {}                         -- (optional)
},    
```

The syntax in `config.lua` is loosely based on the YAML action syntax in Home Assistant.

#### Adding Data to Actions
You can add additional data to your action. In this example we add the data attributes `brightness` and `rgb_color` to [action light.turn_on](https://www.home-assistant.io/integrations/light/#action-lightturn_on):

```lua
{
    label = "Reading Lamp: turn blue", 
    action = "light.turn_on",           
    target = "light.reading_lamp", 
    data = {
        brightness = 90,
        rgb_color = { 0, 0, 255 },
    },
},
```

**Finding Available Action Attributes:**

To discover what additional data you can send with an action:

1) Go to your **Home Assistant instance > Developer Tools > Actions**  
   Play around with an action call, then click on "Go to YAML mode"

2) Check the official Home Assistant integration documentation:    
   [Light](https://www.home-assistant.io/integrations/light/), [Fan](https://www.home-assistant.io/integrations/fan/), [Media player](https://www.home-assistant.io/integrations/media_player/) or [Climate](https://www.home-assistant.io/integrations/climate/)

> [!TIP]
> Take a look at the [example section](#examples), to see what's possible with `homeassistant.koplugin`

#### Targeting Entities, Areas, or Labels
You may target multiple entities, areas, or labels - but do not mix them.

| Target Scope          | Example `config.lua` Syntax                         |
| :-------------------- | :-------------------------------------------------- |
| **Single Entity**     | `target = "light.reading_lamp",`                    |
| **Multiple Entities** | `target = {"light.lamp_1", "light.lamp_2"},`        |
| **Area**              | `target = { area_id = "living_room" },`             |
| **Label**            | `target = { label_id = {"nook", "desk"} },`         |
| **Special Case**      | `target = "all",`                                   |
| **Unsupported**       | `target = { entity_id = "lamp", area_id = "room" }` |

You can either use one single line or indentations:

**Example:**
```lua
{
    label = "Reading Lamp: turn blue",
    action = "light.turn_on",
    target = {
        area_id = {
            "living_room",
            "bed_room",
        },
    },
},
```

### Getting Entity States (Queries)
To retrieve an entity's state and attributes, omit the `action` field.  
The `attributes` array defines which state attributes will be displayed in the result pop-up.

```lua
{
    label = "Temperature Living Room",
    target = "sensor.living_room_temperature",
    attributes = { "state", "unit_of_measurement", "device_class" },
},
```
Result:

<img src="assets/temperature_example.png"  alt="homeassistant.koplugin screenshots" style="width:50%; height:auto;"/>

<br>

>[!NOTE]
> **State Query Limitations:**  
> Most states and attributes can be queried, but some complex nested JSON responses may not display properly.  
> States can only be retrieved by **a single entity_id** as `target`.  
>  Area and label targeting is **not supported** for state queries.  

**Finding Available States & Attributes:**

Go to **Home Assistant instance > Developer Tools > States**  
Select an entity and check the "State" and "Attributes" sections.

### Step 3: Copy Files to Your Device
After editing `config.lua`, copy the files to your KOReader device:

1. Copy the entire `homeassistant.koplugin` folder into `koreader/plugins/`

2. Copy the `icons` folder to `koreader/`  
(This provides the Home Assistant icon used in notifications)

### Step 4: Restart KOReader
The plugin appears under **Tools → Page 2 → Home Assistant** or can be called from KOReader gestures.

## Examples
### Actions (POST Requests)

**Turn off all switches:**
```lua
{
    label = "All Switches: turn_off",
    target = "all",
    action = "switch.turn_off",
},
```

**Play a specific movie with Jellyfin:**
```lua
{
    label = "Play Favourite Movie",
    target = "media_player.jellyfin_living_room",
    action = "media_player.play_media",
    data = {
        media = {
            media_content_id = "b594b3cf9c9a6778d0422b542ff654b8",
            media_content_type = "movie",
        }
    },
},
```
**Play music through Spotify on your Sonos speaker:**
```lua
{
    label = "Play Music",
    action = "media_player.play_media",
    target = "media_player.sonos",
    data = {
        media_content_id = "https://open.spotify.com/album/abcdefghij0123456789YZ",
        media_content_type = "music",
    },
}
```
> [!NOTE]
> The Jellyfin example uses the nested `media = {}` format matching Home Assistant's YAML structure, while the Spotify example uses a flat structure.  
> Both work.

**Set standing desk height:**
```lua
{
    label = "Set Desk Height to 80cm",
    target = "number.upsy_desky_target_desk_height",
    action = "number.set_value",    
    data = {
        value = 80.0
    },
},
```
**Quit Kodi on a specific device:**
```lua
{
    label = "Quit Kodi",
    target = "media_player.mac_mini",
    action = "kodi.call_method",
    data = {
        method = "Application.Quit"
    },

},
```

**Example YAML to `conifg.lua` syntax with ALL the data:**
<details>

In theory you can take the data part (!) from a Home Assistant YAML action and "convert" it into the LUA syntax required in `config.lua`:

<img src="assets/yaml_play_media.png" alt="homeassistant.koplugin used in a QuickMenu" style="width:80%; height:auto;"/>


```lua
{
    label = "Play Nobody 2",
    action = "media_player.play_media",
    target = "media_player.firefox",
    data = {
        media = {
            media_content_id = "b594b3cf9c9a6778d0422b542ff654b8",
            media_content_type = "movie",
            metadata = {
                title = "Nobody 2",
                thumbnail = "http://192.168.10.12:8096//Items/b594b3cf9c9a6778d0422b542ff654b8/Images/Primary?MaxWidth=600&format=jpg&api_key=1f14dc0c0e5f4c9597156f186508316e",
                media_class = "movie",
                children_media_class = nil,
                navigateIds = {
                    {},
                    {
                        media_content_type = "collection",
                        media_content_id = "f137a2dd21bbc1b99aa5c0f6bf02a805",
                    },
                },
                browse_entity_id = "media_player.firefox",
            },
        },
    },
},
```

>[!Note]
> I don't see myself using `homeassistant.koplugin` in such capacities - ever, but it's possible!
</details>

### States (GET Requests)

**Get information about the currently playing song:**
```lua
{
    label = "What's playing?",
    target = "media_player.jellyfin_firefox",
    attributes = { "media_title", "media_artist", "media_duration"},
},
```

Result:

<img src="assets/what_is_playing.png"  alt="homeassistant.koplugin screenshots" style="width:50%; height:auto;"/>

<br>

**Check if the light in the shed was left on:**

```lua
{
    label = "Shed Light on?",
    target = "light.shed_ceiling_light",
    attributes = { "state", "brightness", "last_changed" },
},
```
Result:

<img src="assets/light_left_on.png"  alt="homeassistant.koplugin screenshots" style="width:50%; height:auto;"/>

<br>

## Gestures
You can trigger your Home Assistant entities directly through KOReader gestures.  
Each gesture can be assigned to any entity you have configured in `config.lua`.

For any chosen gesture, you will find your entities in:  
**General▸ → Pages 1–X [find your Home Assistant entity]**

The actions will be named after your entity `label`.

A complete gesture example:  
**Settings → Taps and gestures → Gesture manager▸**  
**Long-press on corner▸ → Bottom Left → General▸ → Page 1–X: Toggle: Reading Lamp**

### QuickMenu

The simplest way to access your Home Assistant entities is through a [QuickMenu](https://koreader.rocks/user_guide/#L2-quickmenu).

1) Add as many entities as you want to a gesture (e.g. **Long-press on corner▸ → Bottom Left**)  
2) Select **Show as QuickMenu** in **Long-press on corner▸ → Bottom Left → Page 2**.

Result:

<p align="center">
<img src="assets/homeassistant_koplugin_gesture_quick_menu.gif" alt="homeassistant.koplugin used in a QuickMenu" style="width:70%; height:auto;"/>
</p>

## Requirements
- KOReader 2024.x or newer (tested with: 2025.10 "Ghost" on a Kindle Basic 2024)  
- Home Assistant instance with a Long-Lived Access Token
- HTTP access to Home Assistant (HTTPS currently not supported - use on local network)

## Screenshots
<p align="center">
<img src="assets/tools_menu_entry.png"  alt="Home Assistant menu entry under Tools" style="width:70%; height:auto;"/>
</p>

<p align="center">
<img src="assets/error_message.png"  alt="Error notification" style="width:70%; height:auto;"/>
</p>

[homeassistant.koplugin Repository](https://github.com/moritz-john/homeassistant.koplugin)  
[KOReader Website](https://koreader.rocks/)

[Home Assistant: REST API](https://developers.home-assistant.io/docs/api/rest/)  
[Home Assistant: Services](https://data.home-assistant.io/docs/services/)  
[Home Assistant: Performing actions](https://www.home-assistant.io/docs/scripts/perform-actions/)


