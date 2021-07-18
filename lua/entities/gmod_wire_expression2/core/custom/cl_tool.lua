if E2Helper == nil then return end

net.Receive("e2_toolapi_select_tool", function(packetSize)
    RunConsoleCommand("gmod_tool", net.ReadString())
end)

E2Helper.Descriptions["runOnTool(n)"] = "If n is 1, this chip gets executed every time the owner picks up their toolgun."
E2Helper.Descriptions["toolClk()"] = "Returns 1 if this chip was executed by owner picking up their toolgun."

E2Helper.Descriptions["getMode(xgt:)"] = "Returns mode of the given tool."
E2Helper.Descriptions["getCategory(xgt:)"] = "Returns category of the given tool."
E2Helper.Descriptions["getHolder(xgt:)"] = "Returns the player that held this tool when it was created."
E2Helper.Descriptions["getPrettyName(xgt:)"] = "Returns the display name of the given tool."
E2Helper.Descriptions["getToolMode(xgt)"] = "Returns mode of the given tool."
E2Helper.Descriptions["getToolCategory(xgt)"] = "Returns category of the given tool."
E2Helper.Descriptions["getToolHolder(xgt)"] = "Returns the player that held this tool when it was created."
E2Helper.Descriptions["getToolPrettyName(xgt)"] = "Returns the display name of the given tool."

E2Helper.Descriptions["playerHasTool(exgt)"] = "Returns 1 if given player has the given tool, 0 otherwise."
E2Helper.Descriptions["playerHasTool(es)"] = "Returns 1 if given player has the tool with given mode, 0 otherwise."
E2Helper.Descriptions["hasTool(e:xgt)"] = "Returns 1 if given player has the given tool, 0 otherwise."
E2Helper.Descriptions["hasTool(e:s)"] = "Returns 1 if given player has the tool with given mode, 0 otherwise."

E2Helper.Descriptions["getPlayerTool(es)"] = "Returns the tool the given player is currently holding if its mode is equal to the given mode. Default tool structure is returned if function fails."
E2Helper.Descriptions["getPlayerTool(e)"] = "Returns the tool the given player is currently holding. Default tool structure is returned if function fails."
E2Helper.Descriptions["getTool(e:s)"] = "Returns the tool the given player is currently holding if its mode is equal to the given mode. Default tool structure is returned if function fails."
E2Helper.Descriptions["getTool(e:)"] = "Returns the tool the given player is currently holding. Default tool structure is returned if function fails."

E2Helper.Descriptions["setPlayerTool(exgt)"] = "Forces the given player to change their tool to the given tool. Returns 1 if succeeded, 0 otherwise."
E2Helper.Descriptions["setPlayerTool(es)"] = "Forces the given player to change their tool to the tool with the given mode. Returns 1 if succeeded, 0 otherwise."
E2Helper.Descriptions["setTool(e:xgt)"] = "Forces the given player to change their tool to the given tool. Returns 1 if succeeded, 0 otherwise."
E2Helper.Descriptions["setTool(e:s)"] = "Forces the given player to change their tool to the tool with the given mode. Returns 1 if succeeded, 0 otherwise."
