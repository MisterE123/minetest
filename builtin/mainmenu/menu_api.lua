-- This Function
--Copyright (C) 2014 sapier
--Copyright (C) 2022 MisterE
--This program is free software; you can redistribute it and/or modify
--it under the terms of the GNU Lesser General Public License as published by
--the Free Software Foundation; either version 2.1 of the License, or
--(at your option) any later version.
--
--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU Lesser General Public License for more details.
--
--You should have received a copy of the GNU Lesser General Public License along
--with this program; if not, write to the Free Software Foundation, Inc.,
--51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.




-- Generally useful formspec and other functions
menu_api = {}

-- This Function MIT by Rubenwardy
--- Creates a scrollbaroptions for a scroll_container
--
-- @param visible_l the length of the scroll_container and scrollbar
-- @param total_l length of the scrollable area
-- @param scroll_factor as passed to scroll_container
function menu_api.make_scrollbaroptions_for_scroll_container(visible_l, total_l, scroll_factor,arrows)
    assert(total_l >= visible_l)
    arrows = arrows or "default"
    local thumb_size = (visible_l / total_l) * (total_l - visible_l)
    local max = total_l - visible_l
    return ("scrollbaroptions[min=0;max=%f;thumbsize=%f;arrows=%s]"):format(max / scroll_factor, thumb_size / scroll_factor,arrows)
end


-- Returns a list with input elements as indexes
-- Useful for testing if an element is contained in a list
function menu_api.switch_list_index_and_element(list) 
    local ret = {}
    for i,j in pairs(list) do 
        ret[j]=i 
    end
    return ret
end



-- returns mapgens for game and any disallowed mapgen settings
function menu_api.get_game_mapgen_params(game)
    if game ~= nil then
        local mapgens = core.get_mapgen_names()
        local disallowed_mapgen_settings = {}

        local gameconfig = Settings(game.path.."/game.conf")

        local allowed_mapgens = (gameconfig:get("allowed_mapgens") or ""):split()
        for key, value in pairs(allowed_mapgens) do
            allowed_mapgens[key] = value:trim()
        end

        local disallowed_mapgens = (gameconfig:get("disallowed_mapgens") or ""):split()
        for key, value in pairs(disallowed_mapgens) do
            disallowed_mapgens[key] = value:trim()
        end

        if #allowed_mapgens > 0 then
            for i = #mapgens, 1, -1 do
                if table.indexof(allowed_mapgens, mapgens[i]) == -1 then
                    table.remove(mapgens, i)
                end
            end
        end

        if #disallowed_mapgens > 0 then
            for i = #mapgens, 1, -1 do
                if table.indexof(disallowed_mapgens, mapgens[i]) > 0 then
                    table.remove(mapgens, i)
                end
            end
        end

        local ds = (gameconfig:get("disallowed_mapgen_settings") or ""):split()
        for _, value in pairs(ds) do
            disallowed_mapgen_settings[value:trim()] = true
        end

        return mapgens,disallowed_mapgen_settings
    end
end





function menu_api.table_to_flags(ftable)
	-- Convert e.g. { jungles = true, caves = false } to "jungles,nocaves"
	local str = {}
	for flag, is_set in pairs(ftable) do
		str[#str + 1] = is_set and flag or ("no" .. flag)
	end
	return table.concat(str, ",")
end






