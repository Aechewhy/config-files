-- Type definitions for LuaLS

--- @meta _

--- Talisman
--- @class Big

--- Talisman
---
--- @param x number|Big|nil
--- @param y number|Big|nil Exponent - optional
---
--- @return Big
--- @nodiscard
function to_big(x, y) end

--- Talisman
---
--- @param num number|Big
---
--- @return number
--- @nodiscard
function to_number(num) end

--- Talisman
---
--- @param num number|Big
---
--- @return boolean
--- @nodiscard
function is_number(num) end

--- @param x number|Big
--- @param y number|Big
---
--- @return number|Big
--- @nodiscard
function math.max(x, y) end

--- @param x number|Big
--- @param y number|Big
---
--- @return number|Big
--- @nodiscard
function math.min(x, y) end

--- @param x number|Big
---
--- @return number|Big
--- @nodiscard
function math.sqrt(x) end

--- @param x number|Big
---
--- @return number|Big
--- @nodiscard
function math.abs(x) end

--- @param x number|Big
---
--- @return number|Big
--- @nodiscard
function math.floor(x) end

--- @param x number|Big
---
--- @return number|Big
--- @nodiscard
function math.ceil(x) end

--- @param x number|Big
---
--- @return number|Big
--- @nodiscard
function math.log10(x) end

--- @param x number|Big
---
--- @return number|Big
--- @nodiscard
function math.log(x) end
