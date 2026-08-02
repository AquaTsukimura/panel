--MPanel.onGameLoaded

if not myPrint then
  print("fked")
  os.exit()
end

isLuaReady = true
if not BaseMain then
  isLuaReady = false
end

CGame.registerV = function(ev, cb)
  local mpane_ev = ev:gsub("^MPanel%.", "")
  
  mpane_ev = mpane_ev:gsub("(%a)(%w*)", function(first, rest)
      return first:upper() .. rest
  end)
  
  mpane_ev = mpane_ev:gsub("%.", "")

  local mpane_evobj = CEvents[mpane_ev]
  
  if not mpane_evobj then
    myPrint("m7md: not found in CEvents: " .. tostring(mpane_ev))
    CEvents[mpane_ev] = IScriptEvent.new()
    mpane_evobj = CEvents[mpane_ev]
  end

  mpane_evobj:unregisterAll()
  Listener.registerCallBack(mpane_evobj, function(...) cb(...) end)
end

CGame.registerV("MPanel.game.ready.event", function(...)
    myPrint("game ready")
    if not ({Game or {}})[1].Instance then
      ({Game or {init = function(self)myPrint("not init")end}})[1]:init()
    end
  end)
