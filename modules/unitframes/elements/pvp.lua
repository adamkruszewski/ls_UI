local _, ns = ...
local E, C, M, L = ns.E, ns.C, ns.M, ns.L
local UF = E:GetModule("UnitFrames")

-- Lua
local _G = _G

-- Mine
-- local ICON_COORDS = {48 / 128, 78 / 128, 1 / 64, 31 / 64}
-- local BANNER_COORDS = {1 / 128, 47 / 128, 1 / 64, 49 / 64}

local function Override(self, event, unit)
	if unit ~= self.unit then return end

	local pvp = self.PvP

	-- local status = "Horde"
	-- local level = 0

	local status
	local level = _G.UnitPrestige(unit)
	local factionGroup = _G.UnitFactionGroup(unit)

	if(_G.UnitIsPVPFreeForAll(unit)) then
		status = "FFA"
	elseif(factionGroup and factionGroup ~= "Neutral" and _G.UnitIsPVP(unit)) then
		if(_G.UnitIsMercenary(unit)) then
			if(factionGroup == "Horde") then
				factionGroup = "Alliance"
			elseif(factionGroup == "Alliance") then
				factionGroup = "Horde"
			end
		end

		status = factionGroup
	end

	if(status) then
		if(level > 0 and pvp.Prestige) then
			pvp:SetTexture(_G.GetPrestigeInfo(level))
			pvp:SetTexCoord(0, 1, 0, 1)
		else
			pvp:SetTexture("Interface\\AddOns\\ls_UI\\media\\pvp-banner-"..status)
			pvp:SetTexCoord(48 / 128, 78 / 128, 1 / 64, 31 / 64)
		end

		pvp.Prestige:SetTexture("Interface\\AddOns\\ls_UI\\media\\pvp-banner-"..status)
		pvp.Prestige:SetTexCoord(1 / 128, 47 / 128, 1 / 64, 49 / 64)

		pvp:Show()
		pvp.Prestige:Show()

		if pvp.Hook then
			pvp.Hook:Show()
		end
	else
		pvp:Hide()
		pvp.Prestige:Hide()

		if pvp.Hook then
			pvp.Hook:Hide()
		end
	end
end

function UF:CreatePvPIcon(parent, layer, sublayer, hook)
	local pvp = parent:CreateTexture(nil, layer, nil, sublayer)
	pvp:SetSize(30, 30)

	local banner = parent:CreateTexture(nil, layer, nil, sublayer - 1)
	banner:SetSize(46, 48)
	banner:SetPoint("TOP", pvp, "TOP", 0, 9)
	pvp.Prestige = banner

	if hook then
		hook = parent:CreateTexture(nil, layer, nil, sublayer)
		hook:SetTexture("Interface\\AddOns\\ls_UI\\media\\pvp-banner-hook")
		hook:SetSize(33, 36)
		pvp.Hook = hook
	end

	pvp.Override = Override

	return pvp
end
