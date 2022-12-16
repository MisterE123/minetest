--Minetest
--Copyright (C) 2014 sapier
--Copyright (C) 2022 MisterE
--
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

local menupath = core.get_mainmenu_path()
local basepath = core.get_builtin_path()


if core.settings:get_bool("use_legacy_menu") == true then
	dofile(menupath.. DIR_DELIM .. "legacy_menu" .. DIR_DELIM .. "init.lua")
else
	defaulttexturedir = core.get_texturepath_share() .. DIR_DELIM .. "base" ..
						DIR_DELIM .. "pack" .. DIR_DELIM

	dofile(menupath .. DIR_DELIM .. "setup.lua")
	dofile(menupath .. DIR_DELIM .. "menu_api.lua")
	dofile(menupath .. DIR_DELIM .. "input_handler.lua")
	dofile(menupath .. DIR_DELIM .. "pages.lua")
	pages.disp_menu()
end