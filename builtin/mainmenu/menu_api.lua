
-- Generally useful formspec functions
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