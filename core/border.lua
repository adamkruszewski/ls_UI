-- Based on code from oUF_Phanx by Phanx <addons@phanx.net>

local _, ns = ...
local E, C, M, L = ns.E, ns.C, ns.M, ns.L

-- Lua
local _G = _G
local type, pairs = type, pairs

-- Mine
local sections = {"TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT", "TOP", "BOTTOM", "LEFT", "RIGHT"}

local function SetBorderColor(self, r, g, b, a)
	local t = self.borderTextures
	if not t then return end

	for _, tex in pairs(t) do
		tex:SetVertexColor(r or 1, g or 1, b or 1, a or 1)
	end
end

local function GetBorderColor(self)
	return self.borderTextures and self.borderTextures.TOPLEFT:GetVertexColor()
end

function E:CreateBorder(object, offset)
	if type(object) ~= "table" or not object.CreateTexture or object.borderTextures then return end

	local t = {}
	offset = offset or 0

	for i = 1, #sections do
		local x = object:CreateTexture(nil, "OVERLAY", nil, 1)
		x:SetTexture("Interface\\AddOns\\ls_UI\\media\\border-"..sections[i], i > 4 and true or nil)
		t[sections[i]] = x
	end

	t.TOPLEFT:SetSize(8, 8)
	t.TOPLEFT:SetPoint("BOTTOMRIGHT", object, "TOPLEFT", 4 + offset, -4 - offset)

	t.TOPRIGHT:SetSize(8, 8)
	t.TOPRIGHT:SetPoint("BOTTOMLEFT", object, "TOPRIGHT", -4 - offset, -4 - offset)

	t.BOTTOMLEFT:SetSize(8, 8)
	t.BOTTOMLEFT:SetPoint("TOPRIGHT", object, "BOTTOMLEFT", 4 + offset, 4 + offset)

	t.BOTTOMRIGHT:SetSize(8, 8)
	t.BOTTOMRIGHT:SetPoint("TOPLEFT", object, "BOTTOMRIGHT", -4 - offset, 4 + offset)

	t.TOP:SetHeight(8)
	t.TOP:SetHorizTile(true)
	t.TOP:SetPoint("TOPLEFT", t.TOPLEFT, "TOPRIGHT", 0, 2)
	t.TOP:SetPoint("TOPRIGHT", t.TOPRIGHT, "TOPLEFT", 0, 2)

	t.BOTTOM:SetHeight(8)
	t.BOTTOM:SetHorizTile(true)
	t.BOTTOM:SetPoint("BOTTOMLEFT", t.BOTTOMLEFT, "BOTTOMRIGHT", 0, -2)
	t.BOTTOM:SetPoint("BOTTOMRIGHT", t.BOTTOMRIGHT, "BOTTOMLEFT", 0, -2)

	t.LEFT:SetWidth(8)
	t.LEFT:SetVertTile(true)
	t.LEFT:SetPoint("TOPLEFT", t.TOPLEFT, "BOTTOMLEFT", -2, 0)
	t.LEFT:SetPoint("BOTTOMLEFT", t.BOTTOMLEFT, "TOPLEFT", -2, 0)

	t.RIGHT:SetWidth(8)
	t.RIGHT:SetVertTile(true)
	t.RIGHT:SetPoint("TOPRIGHT", t.TOPRIGHT, "BOTTOMRIGHT", 2, 0)
	t.RIGHT:SetPoint("BOTTOMRIGHT", t.BOTTOMRIGHT, "TOPRIGHT", 2, 0)

	object.borderTextures = t
	object.SetBorderColor = SetBorderColor
	object.GetBorderColor = GetBorderColor
end
