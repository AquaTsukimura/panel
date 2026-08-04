--[[
    *************************************************************************************************
    *                                                                                               *
    *                               The LuaU Porters C - 2025 LuaU Functions                        *
    *                                    for Lua Programming Language                               *
    *                                                                                               *
    *************************************************************************************************

    LICENSE AGREEMENT AND USAGE TERMS

    This software is the intellectual property of The LuaU Porters, created in the year 2025.
    By using, modifying, or distributing this code, you agree to the following terms and conditions:

    1. Grant of License:
       The author grants you a non-exclusive, worldwide, royalty-free license to use, copy,
       modify, merge, publish, distribute, sublicense, and/or sell copies of this software, 
       provided that the original author is credited and this license is included in all copies 
       or substantial portions of the Software.

    2. No Warranty:
       This software is provided "as-is", without warranty of any kind, express or implied,
       including but not limited to the warranties of merchantability, fitness for a particular purpose,
       and non-infringement. In no event shall the author or copyright holders be liable for any claim,
       damages, or other liability, whether in an action of contract, tort, or otherwise, arising from,
       out of, or in connection with the software or the use or other dealings in the software.

    3. Limitation of Liability:
       In no event shall the author or contributors be held liable for any damages arising from the use
       of this software, even if advised of the possibility of such damages.

    4. Redistribution:
       You may distribute copies of the software in source or binary form, provided that you include
       this license and give appropriate credit to the original author(s). You may not sublicense or
       distribute this software under different terms or conditions than those specified herein.

    5. Modification:
       You are encouraged to modify and adapt this software to suit your needs. When you do so,
       please clearly indicate the modifications made and retain this license notice in all copies.

    6. Attribution:
       Proper attribution to "The LuaU Porters" is required when publishing or distributing derived works.
       You should include a statement like: "This work is based on code provided by The LuaU Porters."

    7. Trademarks:
       The names of the authors or contributors may not be used to endorse or promote products derived
       from this software without specific prior written permission.

    8. Termination:
       This license is effective until terminated. Your rights under this license will terminate automatically
       if you fail to comply with any of its terms. Upon termination, you must cease all use, copying, modification,
       and distribution of the software and destroy all copies in your possession.

    9. No Patent Rights:
       This license does not grant you any rights to use any patents that may be infringed by the use or distribution
       of the software.

    10. Entire Agreement:
        This license constitutes the entire agreement between the parties concerning the subject matter hereof
        and supersedes all prior agreements or understandings, whether written or oral.

    DISCLAIMER:
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND. THE AUTHORS DISCLAIM ALL WARRANTIES,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
    AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT, OR OTHERWISE, ARISING FROM, OUT OF, OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

    *************************************************************************************************

    DESCRIPTION:
    This module provides a function `export_type` which enables runtime type enforcement for Lua functions.
    Wrap your functions with `export_type` and specify the expected argument types in a table.
    This helps catch argument type errors early during development or debugging.

    USAGE EXAMPLE:
        local wrappedFunction = export_type(myFunction, {"string", "number"})
        wrappedFunction("hello", 42) -- valid call
        wrappedFunction(123, "world") -- raises an error indicating type mismatch

    AUTHOR:
        The LuaU Porters

    YEAR:
        2025

    *************************************************************************************************
]]

local function fixEnv()
   _ENV = _ENV or {}
   _G = _G or {}
   if #_ENV <= 0 and #_G > 0 then
      _ENV = _G
   end
   if #_G <= 0 and #_ENV > 0 then
      _G = _ENV
   end
end
fixEnv()

local function getname(func)
    local info = debug.getinfo(func, "n")
    local name = info and info.name
    if not name or name == "" then
        return "<anonymous>"
    end
    return name
end

function fexport_type(fn, paramtype)
    if type(fn) ~= "function" or type(paramtype) ~= "table" then
        error("ExportTypeLua: Invalid arguments to export_type")
    end

    local inferred_name = getname(fn)

    local wrapper = function(...)
        local args = {...}
        for i, kind in ipairs(paramtype) do
            local arg = args[i]
            if type(arg) ~= kind then
                error("ExportTypeLua: Received unknown arguments to function '" .. inferred_name .. "'. Expected " .. kind .. " but got " .. type(arg), 2)
            end
        end
        return fn(...)
    end

    local i = 1
    while true do
        local name, val = debug.getlocal(2, i)
        if not name then break end
        if val == fn then
            debug.setlocal(2, i, wrapper)
            if inferred_name == "<anonymous>" and not name:find("^%(") then
                inferred_name = name
            end
        end
        i = i + 1
    end

    local caller_info = debug.getinfo(2, "f")
    if caller_info and caller_info.func then
        local u_idx = 1
        while true do
            local name, val = debug.getupvalue(caller_info.func, u_idx)
            if not name then break end
            if val == fn then
                debug.setupvalue(caller_info.func, u_idx, wrapper)
                if inferred_name == "<anonymous>" then
                    inferred_name = name
                end
            end
            u_idx = u_idx + 1
        end
    end

    local env = _ENV or _G
    if env then
        for k, v in pairs(env) do
            if v == fn then
                env[k] = wrapper
                if inferred_name == "<anonymous>" then
                    inferred_name = k
                end
            end
        end
    end

    return wrapper
end
