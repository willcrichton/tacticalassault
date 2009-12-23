local meta = FindMetaTable("Player")
if !meta then return end

function meta:SetSquad(squad)
	self._Squad = squad
end

function meta:GetSquad() 
	return self._Squad or false
end

function meta:SetLeader()
	self._Lead = true
end

function meta:RemoveLeader()
	self._Lead = false
end

function meta:IsLeader()
	return self._Lead or false
end