pages = {}

local textures = core.formspec_escape(defaulttexturedir)


function pages.disp_menu()
    core.update_formspec(pages.get_page(menudata.page))
end



function pages.get_page(page)

    -- intro page

    if page == "splashscreen" then

        return table.concat({
            "formspec_version[6]",
            "size[5,11]",
            "no_prepend[]",
            "real_coordinates[true]",
            "style_type[button;textcolor=#a0938e;bgimg=".. textures .."302c2e.png;bgimg_pressed=".. textures .."397b44.png;bgimg_hovered=".. textures .."71aa34.png;border=true]",
            "style_type[button:hovered,button:pressed;textcolor=#302c2e]",
            "style[TITLE;textcolor=#302c2e;border=false]",
            "bgcolor[#5a5353;both;#302c2e]",
            "image[2,1;1,1;".. textures .."minetesticon.png]",
            "image_button[.25,2.5;4.5,1;".. textures .."5a5353.png;TITLE;Play. Build. Create.]",
            "button[.5,4.5;4,1;SINGLEPLAYER;Singleplayer]",
            "button[.5,5.75;4,1;MULTIPLAYER;Join Game]",
            "button[.5,7;4,1;CONTENT;Content]",
            "button[.5,8.25;4,1;SETTINGS;Settings]",
            "button[.5,9.5;4,1;CREDITS;Credits]",
        })

    end



    -- singleplayer page

    if page == "singleplayer" then

        -- refresh games list
        setup.fetch_menu_games()

        -- games bar formspec
        local games_bar = get_games_bar_formspec(menudata.games,menudata.game_idx)
        -- data for game menu
        local game = menudata.games[menudata.game_idx]
        local game_screenshot = core.formspec_escape(game.path .. DIR_DELIM .. "screenshot.png")
        local game_overlay = core.formspec_escape(game.path .. DIR_DELIM .. "menu" .. DIR_DELIM .."overlay.png")
        local game_background = core.formspec_escape(game.path .. DIR_DELIM .. "menu" .. DIR_DELIM .."background.png")
        local game_icon = core.formspec_escape(game.menuicon_path)
        local game_content = core.get_content_info(game.path)
        local game_title = game_content.title
        local game_author = game.author 
        if game_author == "" then game_author = "Unknown" end
        local game_desc = game_content.description

        -- world data
        local worlds = core.get_worlds()
        local game_worlds = {}
        for i,world in ipairs(worlds) do
            if world.gameid == game.id then
                table.insert(game_worlds,world)
            end
        end
        local world_list = get_worldlist_formspec(game_worlds,game_icon)
        local play_button = get_play_button_formspec()
        return table.concat({

            "formspec_version[6]",
            "size[32,18]",
            "padding[.01,.01]",
            "no_prepend[]",
            "real_coordinates[true]",

            "style_type[button;textcolor=#a0938e;bgimg=".. textures .."302c2e.png;bgimg_pressed=".. textures .."397b44.png;bgimg_hovered=".. textures .."71aa34.png;border=true]",
            "style_type[button:hovered,button:hovered+pressed;textcolor=#302c2e]",
            "style[BACK;fgimg_pressed=".. textures .."back_pressed.png;fgimg_hovered=".. textures .."back_hovered.png;border=false]",
            "style[GAME_LEFT;fgimg_pressed=".. textures .."back_pressed.png;fgimg_hovered=".. textures .."back_hovered.png;border=false]",
            "style[GAME_RIGHT;fgimg_pressed=".. textures .."forward_pressed.png;fgimg_hovered=".. textures .."forward_hovered.png;border=false]",
            
            "bgcolor[#302c2e;both;#302c2e]",
            

            "image_button[0,0;1,1;".. textures .."back.png;BACK;]", -- Back Button (to splashscreen)

            "style_type[label;font_size=28,font=bold]",
            "label[1.5,.5;Choose Game ... ]", -- Games Title

            "button[28,0;4,1;CONTENT_GAMES;All Games]", -- all games button
            -- bg for game bar
            "image[0,15.5;32,2;".. textures .."5a5353.png]",

            games_bar,

            -- arrows on games bar
            "image_button[0.5,16;1,1;".. textures .."back.png;GAME_LEFT;]",
            "image_button[30.5,16;1,1;".. textures .."forward.png;GAME_RIGHT;]",
            
            -- game info view
            "image[0,2;10.1,13;".. textures .."5a5353.png]", -- description and screenshot bg
            "image[.2,2.2;9.7,12.6;".. textures .."302c2e.png]", -- description and screenshot dark bg
            
            -- try to get *some* kind of image for the game, overlay the possibilities in some semblance of a sane order
            "image[.2,2.2;9.7,6.6;"..game_screenshot.."]",
            "image[.2,2.2;9.7,6.6;"..game_overlay.."]",
            "image[.2,2.2;9.7,6.6;"..game_background.."]",
            
            "image[.2,2.2;9.7,6.6;"..textures.."screenshot_title_overlay.png]", -- gradient screenshot overlay
            "textarea[.6,10.7;9.3,3.6;;;"..game_desc.."]",
            "style_type[label;font_size=28,font=bold]",
            "label[.6,8.2;"..game_title.."]",
            "style_type[label;font_size=20,font=bold]",
            "label[.6,9;by "..game_author.."]",

            -- World selector
            "image[11,2;21,10;".. textures .."5a5353.png]", -- World selector bg
            "image[11.2,3.2;20.6,8.6;".. textures .."302c2e.png]", -- World selector dark bg
            "style_type[label;font_size=28,font=bold]",
            "label[11.6,2.6;Select World...]",

            world_list,
            play_button,

        })

    end

end




function get_play_button_formspec()

    local fs = ""
    -- play button area
    fs = fs .. "image[11,12.5;21,2.5;".. textures .."5a5353.png]"


    fs = fs .. "style[PLAY;font_size=*2;textcolor=#302c2e;bgimg=".. textures .."71aa34.png;bgimg_pressed=".. textures .."71aa34.png;bgimg_hovered=".. textures .."b6d53c.png]"
    fs = fs .. "style[OPEN_HOST_MENU;font_size=*2;textcolor=#302c2e;bgimg=".. textures .."host_server.png;bgimg_pressed=".. textures .."host_server.png;bgimg_hovered=".. textures .."host_server_hovered.png]"
    fs = fs .. "style[CLOSE_HOST_MENU;font_size=*2;textcolor=#302c2e;bgimg=".. textures .."host_server.png;bgimg_hovered=".. textures .."host_server_hovered.png]"
    fs = fs .. "style[HELP_START_SERVER;bgimg=".. textures .."help_dark.png;bgimg_hovered=".. textures .."help_hovered.png;bgimg_pressed=".. textures .."help_pressed.png]"

    -- fs = fs .. "style_type[button:hovered,button:hovered+pressed;textcolor=#302c2e]"

    if menudata.host_server_collapsed == "true" then
        -- hide server hosting stuff
        fs = fs .. "button[11.2,12.7;1,2.1;OPEN_HOST_MENU;>]"
        fs = fs .. "button[12.2,12.7;19.6,2.1;PLAY;PLAY]"
    else 
        -- show server hosting stuff
        fs = fs .. "button[22.2,12.7;1,2.1;CLOSE_HOST_MENU;<]"
        fs = fs .. "button[23.2,12.7;8.6,2.1;PLAY;HOST SERVER]"
        fs = fs .."style_type[label;font_size=*.75;font=bold]"
        -- player name
        fs = fs .."style[PLAYER_NAME;border=true;font=bold]"
        fs = fs .. "image[11.2,12.7;5,.7;".. textures .."302c2e.png]"
        fs = fs .. "field[11.3,12.7;4.9,.7;PLAYER_NAME;;"..menudata.playername.."]"  
        fs = fs .. "label[11.3,13.6;Player Name (Required)]"
        -- password
        fs = fs .."style[PLAYER_PW;border=true;font=bold]"
        fs = fs .. "image[11.2,13.8;5,.7;".. textures .."302c2e.png]"
        fs = fs .. "pwdfield[11.3,13.8;4.9,.7;PLAYER_PW;]"  
        fs = fs .. "label[11.3,14.7;Password (Optional)]"
        -- port
        fs = fs .."style[PORT;border=true;font=bold]"
        fs = fs .. "image[16.4,12.7;5,.7;".. textures .."302c2e.png]"
        fs = fs .. "field[16.5,12.7;4.9,.7;PORT;;30000]"  
        fs = fs .. "label[16.5,13.6;Port]"
        --make public checkbox; TODO: Implement with server_announce setting in input handler
        fs = fs .. "checkbox[16.5,14.15;MAKE_PUBLIC;;false]"
        fs = fs .. "label[17,14.15;Make Public]"
        --help button
        fs = fs .. "button[20.8,13.9;.5,.5;HELP_START_SERVER;]"
    end

    return fs
end




function get_worldlist_formspec(worlds,game_icon)
    
    local entryheight = 2
    local selected_world_name = menudata.last_world_name
    local toggle = true
    local fs = ""
    local bg_color_1 = textures.."7d7071.png"
    local bg_color_2 = textures.."5a5353.png"
    local bg_color_selected = textures .. "397b44.png"
    local container_len = 8.6
    local total_l = entryheight*(#worlds + 1)
    local scroll_factor = .1
    local scroll_value = menudata.world_scrollbar_value or 0


    fs = fs .. "scroll_container[18.2,3.2;13.8,"..container_len..";WORLD_SCROLLBAR;vertical;"..scroll_factor.."]"
    for i,world in ipairs(worlds) do
        local entry_y = (i-1)*entryheight
        if world.name == selected_world_name then -- color the button dark green if the world is selected
            fs = fs .. "style_type[button;bgimg=".. textures .."397b44.png;bgimg_pressed=".. textures .."397b44.png;bgimg_hovered=".. textures .."397b44.png;border=true]"
        elseif toggle then
            fs = fs .. "style_type[button;bgimg=".. bg_color_1 ..";bgimg_pressed=".. textures .."397b44.png;bgimg_hovered=".. textures .."71aa34.png;border=true]"
        else
            fs = fs .. "style_type[button;bgimg=".. bg_color_2 ..";bgimg_pressed=".. textures .."397b44.png;bgimg_hovered=".. textures .."71aa34.png;border=true]"
        end
        fs = fs .. "style_type[button:hovered,button:hovered+pressed;textcolor=#302c2e]"
        fs = fs .. "button[0,"..entry_y..";13.5,"..entryheight..";SELECT_WORLD_"..world.name..";]" -- select world buttons
        
        fs = fs .. "image["..(3.5-entryheight)/2 ..","..entry_y..";"..entryheight..","..entryheight..";"..game_icon..";]" -- TODO: replace with actual world screenshot!
        fs = fs .. "image[0,"..entry_y..";3.5,"..entryheight..";no_screenshot.png;]" -- TODO: replace with actual world screenshot, shrink icon above!
        
        fs = fs .."style_type[label;font_size=23;font=bold]"
        fs = fs .. "label[4,"..entry_y+.5 ..";".. world.name .."]"

        toggle = not(toggle)
    end
    

    worlds = worlds or {}
    local entry_y = (#worlds)*entryheight
    fs = fs .. "style_type[button;font=bold;font_size=52;bgimg=".. textures .."302c2e.png;bgimg_pressed=".. textures .."397b44.png;bgimg_hovered=".. textures .."71aa34.png;border=true]"
    fs = fs .. "button[0,"..entry_y..";13.5,"..entryheight..";NEW_WORLD;+]" -- New world button at end of list


    fs = fs .. "scroll_container_end[]"
    if total_l > container_len then    
        fs = fs .. menu_api.make_scrollbaroptions_for_scroll_container(container_len, total_l, scroll_factor,"hide")
        fs = fs .. "scrollbar[31.7,3.2;.1,"..container_len..";vertical;WORLD_SCROLLBAR;"..scroll_value.."]"
    end

    return fs
end









function get_games_bar_formspec(games_list, current_index)
    local bar_x = 0
    local bar_y = 15.5
    local bar_w = 32
    local bar_h = 2

    local num_games_visible = 7 
    local num_games_visible_to_either_side = math.floor(num_games_visible)
    local fs = ""
    local disp_counter = 0
    for i = current_index - num_games_visible_to_either_side,current_index + num_games_visible_to_either_side do 
        
        if games_list[i] then

            local rect_w = bar_w/num_games_visible
            local rect_h = bar_h
            local rect_x = bar_x + rect_w*disp_counter - bar_w/1.75
            local rect_y = bar_y
            local icon_x = rect_x + (rect_w - rect_h)/2
            local game_icon = core.formspec_escape(games_list[i].menuicon_path)
            local game_overlay = core.formspec_escape(games_list[i].path .. DIR_DELIM .. "menu" .. DIR_DELIM .."overlay.png")
            local game_bg = core.formspec_escape(games_list[i].path .. DIR_DELIM .. "screenshot.png")
            local button_selector = "GAME_SELECT_".. i

            fs = fs .. table.concat({"image[",rect_x,",",rect_y,";",rect_w,",",rect_h,";", textures .."no_screenshot.png","]"}) -- game icon overlay
            fs = fs .. table.concat({"image[",rect_x,",",rect_y,";",rect_w,",",rect_h,";",game_overlay,"]"}) -- game icon overlay
            fs = fs .. table.concat({"image[",rect_x,",",rect_y,";",rect_w,",",rect_h,";",game_bg,"]"}) -- game bg
            if i ~= current_index then 
                fs = fs .. table.concat({"image[",rect_x,",",rect_y,";",rect_w,",",rect_h,";",textures .."darken.png","]"}) -- game bg
            end
            fs = fs .. table.concat({"image[",rect_x,",",rect_y+rect_h-rect_h/3,";",rect_h/3,",",rect_h/3,";",game_icon,"]"}) -- game icon overlay
            fs = fs .. table.concat({"style[",button_selector,";","fgimg_pressed=".. textures .."gamebar_bg_pressed.png;fgimg_hovered=".. textures .."gamebar_bg_hovered.png;border=false]"}) -- game button hover style
            fs = fs .. table.concat({"image_button[",rect_x,",",rect_y,";",rect_w,",",rect_h,";",textures.."gamebar_bg.png",";",button_selector,";]"}) -- game button
        end

        disp_counter = disp_counter + 1
    end
    return fs
end


