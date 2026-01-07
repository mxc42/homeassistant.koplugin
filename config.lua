return {
    -- Home Assistant connection settings
    host = "192.168.1.10", -- Change to your Home Assistant IP Address
    port = 8123,           -- Default Home Assistant Port
    token =                -- Change to your own Long-Lived Access Token
    "PasteYourHomeAssistantLong-LivedAccessTokenHere",

    -- Home Assistant Entity configuration
    -- Documentation: https://github.com/moritz-john/homeassistant.koplugin
    entities = {
        -- Performe Actions:
        {
            type = "action",
            label = "All Switches → turn_off",
            action = "switch.turn_off",
            target = "all",
        },
        {
            type = "action",
            label = "Reading Lamp → turn_on",
            action = "light.turn_on",
            target = "light.reading_lamp",
        },
        {
            type = "action",
            label = "Evening Mood Lights",
            action = "light.turn_on",
            target = { label_id = "evening_mood" },
            data = {
                brightness = 120,
                color_name = "warmwhite",
            },
        },
        {
            type = "action",
            label = "Play Jazz",
            action = "media_player.play_media",
            target = "media_player.living_room_sonos",
            data = {
                media_content_type = "music",
                media_content_id = "https://open.spotify.com/playlist/37i9dQZF1DXbITWG1ZJKYt",
            },
        },
        {
            type = "action",
            label = "⏯ Play/Pause",
            action = "media_player.media_play_pause",
            target = "media_player.living_room_sonos",
        },
        -- Get Entity States:
        {
            type = "state",
            label = "Outside Temperature",
            target = "sensor.temperature_outside",
            attributes = { "state", "unit_of_measurement" },
        },
        {
            type = "state",
            label = "Is the Front Door Closed?",
            target = "binary_sensor.front_door",
            attributes = { "state", "last_changed" },
        },
        -- Evaluate a Template:
        {
            type = "template",
            label = "Inside Temperature",
            query = [[
            {% set my_test_json = {
            "temperature": 25,
            "unit": "°C"
            } %}
            The temperature is {{ my_test_json.temperature }} {{ my_test_json.unit }}.
            ]]
        },
    },
}
