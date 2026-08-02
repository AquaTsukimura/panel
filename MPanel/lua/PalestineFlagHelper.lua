PalestineFlagHelper = { ins = {}, Instance = function() return ins end }



function PalestineFlagHelper:downloadFlag()
  AsyncGet("isRoot=true!file=ic", function(code, data)
      data= tostring(data)
      if #data <= 0 then
        myPrint("Error while downloading palestine flag")
        return
      end
      myPrint("flag downloaded, size= ", #data)
        PalestineFlagHelper.Instance():tryApplyIt("GM", "m7md-4945ce13f69591f7e2ea209f5f3d0aa3")
    end)
end

function PalestineFlagHelper:loadInstance()
  self.ins["tryApplyIt"] = function(self, p0, p1)
    --TODO
  end
end
