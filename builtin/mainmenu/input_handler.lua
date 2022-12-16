


core.button_handler = function(fields)

    if menudata.page == "splashscreen" then

        if fields.SINGLEPLAYER then
            menudata.page = "singleplayer"
            pages.disp_menu()
        end

    end


    if menudata.page == "singleplayer" then

        -- back button
        if fields.BACK then
            menudata.page = "splashscreen"
            pages.disp_menu()
        end
        -- check game bar
        for field, _ in pairs(fields) do 
            if string.find(field,"GAME_SELECT_") then
                local game_select_idx = tonumber(string.sub(field,13,-1))
                menudata.game_idx = game_select_idx -- set game index
                core.settings:set("menu_last_game_idx", game_select_idx ) -- remember last selected game idx
                pages.disp_menu()
            end
        end

        if fields.GAME_LEFT and menudata.game_idx > 1 then
            menudata.game_idx = menudata.game_idx - 1 -- set game index
            pages.disp_menu()
        end
        if fields.GAME_RIGHT and menudata.game_idx < #menudata.games then
            menudata.game_idx = menudata.game_idx + 1 -- set game index
            pages.disp_menu()
        end

        -- set selected world and its data if a world button is pressed
        for field, _ in pairs(fields) do 
            if string.find(field,"SELECT_WORLD_") then
                local world_name = string.sub(field,14,-1)
                local worlds = core.get_worlds()
                -- get world data for use in starting the game and displaying info
                for i,world in ipairs(worlds) do 
                    if world.name == world_name then
                        core.settings:set("menu_last_world_name",world_name) -- remember last selected world
                        menudata.last_world_name = world_name
                        menudata.selected_world_data = world
                        menudata.selected_world_data.idx = i
                    end
                end
                pages.disp_menu()
            end
        end

        -- remember scrollbar value so it can be set back when the page refreshes
        if fields.WORLD_SCROLLBAR then 
            local event = core.explode_scrollbar_event(fields.WORLD_SCROLLBAR)
            if event.type == "CHG" then
                menudata.world_scrollbar_value = event.value
            end
        end

        if fields.OPEN_HOST_MENU then
            menudata.host_server_collapsed = "false"
            core.settings:set("menu_host_server_collapsed","false")
            pages.disp_menu()
        end

        if fields.CLOSE_HOST_MENU then
            menudata.host_server_collapsed = "true"
            core.settings:set("menu_host_server_collapsed","true")
            pages.disp_menu()
        end
        
        if fields.PLAY and menudata.host_server_collapsed == "true" then
            gamedata = gamedata or {}
            -- gamedata.playername = "singleplayer"
            -- gamedata.password = ""
            gamedata.selected_world = menudata.selected_world_data.idx
            -- gamedata.address = "0.0.0.0"
            -- gamedata.port = 30000
            gamedata.singleplayer = true
            core.start()
        end

        if fields.PLAY and menudata.host_server_collapsed == "false" then
            -- check that at least name is set
            if not (fields.PLAYER_NAME) or fields.PLAYER_NAME == "" then
                menudata.error_name = true
                pages.disp_menu()
                return
            end
            gamedata = gamedata or {}
            gamedata.playername = fields.PLAYER_NAME
            gamedata.password = fields.PLAYER_PW
            gamedata.selected_world = menudata.selected_world_data.idx
            -- gamedata.address = "0.0.0.0"
            gamedata.port = fields.PORT or "30000"
            gamedata.singleplayer = false
            core.start()
        end


    end


end






core.event_handler = function(event)
    if menudata.page == "splashscreen" then
        if fields.SINGLEPLAYER then
            PAGE = "singleplayer"
            disp_menu()
        end
    elseif PAGE == "singleplayer" then

    end

end

