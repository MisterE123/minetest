setup = {}
gamedata = {}
menudata = {}

---------------------   FUNCTIONS    ------------------------

function setup.fetch_menu_games()
    menudata.games = core.get_games()
    menudata.game_idx = menudata.game_idx or tonumber(core.settings:get("menu_last_game_idx")) or 1
    -- check that game exists
    if not(menudata.games[menudata.game_idx]) then
        menudata.game_idx = 1
    end
end



--------------------- SET FIRST PAGE ------------------------
local page_to_open = "splashscreen"
if core.settings:get_bool("menu_open_game_at_last_page") == true then
    page_to_open = core.settings:get("menu_last_page") or "splashscreen"
    
    --TODO sanitize last_page input 


end
menudata.page = page_to_open

--------------------- SET FIRST GAME ------------------------

setup.fetch_menu_games()
--------------------- SET selected world --------------------

menudata.last_world_name = core.settings:get("menu_last_world_name")
if menudata.last_world_name then 
    for i,world in ipairs(core.get_worlds()) do
        if world.name == menudata.last_world_name then
            menudata.selected_world_data = world
            menudata.selected_world_data.idx = i
        end
    end
end

-- remember if host server is collapsed

menudata.host_server_collapsed = core.settings:get("menu_host_server_collapsed") or "true"

-- recall player name
menudata.playername = core.settings:get("menu_playername") or ""

