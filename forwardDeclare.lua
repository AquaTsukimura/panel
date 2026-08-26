local function declare(name)
  if not _G[name] then
    _G[name] = function(...)
      MsgSender.sendMsg("The function '" .. name .. "' has not been implemented yet.")
      MsgSender.sendMsg("Have you tried updating the MPanel BlockmanGO Apk?")
      MsgSender.sendMsg("Please check for updates in the official discord server.")
    end
  end
end

local funcs = {
  "Effect", "drop", "respawn", "rage_bypass", "updPk", "Attack", 
  "RG_Tick", "AsyncGet", "step", "web", "splash", "splashnolag",
  "loadk", "loadfilen", "reloadb", "SyncCurPos", "doTeleportPk",
  "entity", "eat", "AsyncPost"
}
for i = 1, #funcs do
  local name = funcs[i]
  if name then
    declare(name);
  end
end
