--[[
    E2 Tool Core Extension by staticdehydration
    Contact: staticdehydration@gmail.com
    My Steam Page: https://steamcommunity.com/id/staticdehydration/
]]

if E2Lib == nil then return end

E2Lib.RegisterExtension(
    "toolapi", 
    false, 
    "Allows E2 chips to gather and use information about tools.",
    "Can be used to detect presence of tool addons and select toolmodes for players."
)

util.AddNetworkString("e2_toolapi_select_tool")

local PlayerMetaTable = FindMetaTable("Player")
function PlayerMetaTable.SetTool(player, mode)
    net.Start("e2_toolapi_select_tool")
        net.WriteString(mode)
    net.Send(player)
end

local wire_e2_toolapi_set_adminonly = CreateConVar("wire_e2_toolapi_set_adminonly", "1", FCVAR_ARCHIVE)
local wire_e2_toolapi_adminonly = CreateConVar("wire_e2_toolapi_adminonly", "0", FCVAR_ARCHIVE)

ToolCore = {}

function ToolCore.PlayerHasTool(player, mode)
    if not IsValid(player) then
        return false
    end

    return player:GetTool(mode) != nil
end

function ToolCore.GetPlayerTool(player, mode)
    if not IsValid(player) then
        return nil
    end

    return player:GetTool(mode)
end

function ToolCore.SetPlayerTool(player, mode)
    if not IsValid(player) then
        return false
    end

    player:SetTool(mode)

    return true
end

-----------------------------------------------------------

local RegisteredChips = {}

registerCallback("destruct", function(self)
    RegisteredChips[self.entity] = nil
end)

local function Expression2ToolClock(player)
    for k, entity in pairs(RegisteredChips) do 
        if IsValid(entity) and entity.player == player then
            entity.context.data.toolrun = true
            entity:Execute()
            entity.context.data.toolrun = nil
        end
    end
end

-----------------------------------------------------------

hook.Add("PlayerSwitchWeapon", "e2_toolapi_switch_weapon", function(player, oldWeapon, newWeapon)
    local newWeaponClass = newWeapon:GetClass()
    if newWeaponClass == "gmod_tool" then
        Expression2ToolClock(player)
    end
end)

-----------------------------------------------------------
__e2setcost(1)

e2function void runOnTool(activate)
    if activate != 0 then
        RegisteredChips[self.entity] = self.entity
    else
        RegisteredChips[self.entity] = nil
    end
end

e2function number toolClk()
    return self.data.toolrun and 1 or 0
end

-----------------------------------------------------------

local function makeE2Tool(mode, prettyName, category, holder)
    if mode == nil and prettyName == nil and category == nil and holder == nil then
        return {
            "nil",
            "None",
            "none",
            NULL
        }
    end

    return {
        mode,
        prettyName,
        category,
        holder
    }
end

local function isE2ToolValid(v)
    return v[1] != nil and v[2] != nil and v[3] != nil and v[4] != nil and #v == 4
end

local function isE2ToolEqual(left, right)
    return left[1] == right[1] and
                left[2] == right[2] and
                    left[3] == right[3] and
                        left[4] == right[4]
end

-----------------------------------------------------------

local function isAuthorizedForCall(caller, isSetFunc)
    caller = caller.player or caller

    if wire_e2_toolapi_adminonly:GetInt() == 1 and not caller:IsSuperAdmin() then
        return false
    end

    if isSetFunc and wire_e2_toolapi_set_adminonly:GetInt() == 1 and not caller:IsSuperAdmin() then
        return false
    end

    return true
end

-----------------------------------------------------------
__e2setcost(2)

registerType("gtool", "xgt", makeE2Tool(),
    function(self, input)
        return makeE2Tool(input[1], input[2], input[3], input[4])
    end,

    nil,

    function(retval)
        if not istable(retval) then 
            error("Return value is not a table, but a "..type(retval).."!", 0)
        end

        if not isE2ToolValid(retval) then
            error("Return value is not a valid E2 tool!", 0)
        end
    end,

    function(v)
        return not istable(v) or not isE2ToolValid(v)
    end
)

-----------------------------------------------------------
__e2setcost(1)

e2function number operator_is(gtool t)
    return isE2ToolValid(t)
end

registerOperator("ass", -- Very funny.
    "xgt", "xgt",
    function(self, args)
        local op1, op2, scope = args[2], args[3], args[4]
        local rv2 = op2[1](self, op2)

        self.Scopes[scope][op1] = rv2
        self.Scopes[scope].vclk[op1] = true

        return rv2
    end
)

e2function number operator==(gtool lhs, gtool rhs)
    return isE2ToolEqual(lhs, rhs)
end

e2function number operator!=(gtool lhs, gtool rhs)
    return not isE2ToolEqual(lhs, rhs)
end

-----------------------------------------------------------
__e2setcost(1)

e2function string gtool:getMode()
    if not isAuthorizedForCall(self, false) then return "" end
    
    return this[1]
end

e2function string gtool:getPrettyName()
    if not isAuthorizedForCall(self, false) then return "" end
    
    return this[2]
end

e2function string gtool:getCategory()
    if not isAuthorizedForCall(self, false) then return "" end

    return this[3]
end

e2function entity gtool:getHolder()
    if not isAuthorizedForCall(self, false) then return NULL end

    return this[4]
end

e2function string getToolMode(gtool t)
    if not isAuthorizedForCall(self, false) then return "" end

    return t[1]
end

e2function string getToolPrettyName(gtool t)
    if not isAuthorizedForCall(self, false) then return "" end

    return t[2]
end

e2function string getToolCategory(gtool t)
    if not isAuthorizedForCall(self, false) then return "" end

    return t[3]
end

e2function entity getToolHolder(gtool t)
    if not isAuthorizedForCall(self, false) then return NULL end

    return t[4]
end

-----------------------------------------------------------
__e2setcost(2)

e2function number playerHasTool(entity player, gtool target)
    if not isAuthorizedForCall(self, false) then return 0 end

    return ToolCore.PlayerHasTool(player, target[1])
end

e2function number playerHasTool(entity player, string mode)
    if not isAuthorizedForCall(self, false) then return 0 end

    return ToolCore.PlayerHasTool(player, mode)
end

e2function number entity:hasTool(gtool target)
    if not isAuthorizedForCall(self, false) then return 0 end

    return ToolCore.PlayerHasTool(this, target[1])
end

e2function number entity:hasTool(string mode)
    if not isAuthorizedForCall(self, false) then return 0 end

    return ToolCore.PlayerHasTool(this, mode)
end

-----------------------------------------------------------

local function luaToolToE2Tool(player, mode)
    local luaTool = ToolCore.GetPlayerTool(player, mode)
    if luaTool == nil then
        return makeE2Tool()
    end

    local e2Tool = makeE2Tool(luaTool.Mode, luaTool.Name, luaTool.Category, player)
    return e2Tool
end

-----------------------------------------------------------

__e2setcost(5)

e2function gtool getPlayerTool(entity player, string mode)
    if not isAuthorizedForCall(self, false) then return makeE2Tool() end

    return luaToolToE2Tool(player, mode)
end

e2function gtool getPlayerTool(entity player)
    if not isAuthorizedForCall(self, false) then return makeE2Tool() end

    return luaToolToE2Tool(player)
end

e2function gtool entity:getTool(string mode)
    if not isAuthorizedForCall(self, false) then return makeE2Tool() end

    return luaToolToE2Tool(this, mode)
end

e2function gtool entity:getTool()
    if not isAuthorizedForCall(self, false) then return makeE2Tool() end

    return luaToolToE2Tool(this)
end

-----------------------------------------------------------
__e2setcost(15)

e2function number setPlayerTool(entity player, gtool target)
    if not isAuthorizedForCall(self, false) then return 0 end

    return ToolCore.SetPlayerTool(player, target[1])
end

e2function number setPlayerTool(entity player, string mode)
    if not isAuthorizedForCall(self, false) then return 0 end

    return ToolCore.SetPlayerTool(player, mode)
end

e2function number entity:setTool(gtool target)
    if not isAuthorizedForCall(self, false) then return 0 end

    return ToolCore.SetPlayerTool(this, target[1])
end

e2function number entity:setTool(string mode)
    if not isAuthorizedForCall(self, false) then return 0 end

    return ToolCore.SetPlayerTool(this, mode)
end

-----------------------------------------------------------
