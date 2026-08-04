function EntityPlayer:Sync()
  self:setVelocity({x = 0, y = 0, z = 0})
  self:moveEntity({x = 0, y = 0, z = 0})
end
