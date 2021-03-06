local _, ns = ...
local E, C, M, L = ns.E, ns.C, ns.M, ns.L
local B = E:GetModule("Blizzard")

local PlayerPowerBarAlt = PlayerPowerBarAlt

local function ClearAllPointsHook(self)
	self:SetPoint("BOTTOM", LSPowerBarAltHolder, "BOTTOM", 0, 0)
end

function B:HandlePowerBarAlt()
	local holder = CreateFrame("Frame", "LSPowerBarAltHolder", UIParent)
	holder:SetSize(64, 64)
	holder:SetPoint("BOTTOM", 0, 230)
	E:CreateMover(holder)

	PlayerPowerBarAlt:SetParent(holder)
	PlayerPowerBarAlt:ClearAllPoints()
	PlayerPowerBarAlt:SetPoint("BOTTOM", holder, "BOTTOM", 0, 0)
	PlayerPowerBarAlt.ignoreFramePositionManager = true

	hooksecurefunc(PlayerPowerBarAlt, "ClearAllPoints", ClearAllPointsHook)
end
