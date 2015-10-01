local _, ns = ...
local E, M = ns.E, ns.M
local COLORS = M.colors

local unpack = unpack

local PRESETS = {
	["14"] = {
		capSize = {14, 22},
		textHeight = 12,
	},
	["12"] = {
		capSize = {12, 20},
		textHeight = 10,
	},
}

function E:HandleStatusBar(bar, addBorder, preset, cascade)
	local children = {bar:GetChildren()}
	local regions = {bar:GetRegions()}

	local sbt = bar.GetStatusBarTexture and bar:GetStatusBarTexture()

	-- print("====", bar:GetName(), #children, #regions, "====")

	local texture, layer, background, text, sb

	for _, region in next, regions do
		if region:IsObjectType("Texture") then
			texture, layer = region:GetTexture(), region:GetDrawLayer()
			if layer == "BACKGROUND" then
				if texture and strfind(texture, "Color") then
					background = region
				elseif texture and strfind(texture, "Background") then
					background = region
				else
					E:AlwaysHide(region)
				end
			else
				if region ~= sbt then
					E:AlwaysHide(region)
				end
			end
		elseif region:IsObjectType("FontString") then
			text = region
		end
	end

	local tbackground, ttext, tstatusbar

	for _, child in next, children do
		if child:IsObjectType("StatusBar") then
			tbackground, ttext, tsbt = self:HandleStatusBar(child, nil, nil, true)
		end
	end

	background = background or tbackground
	text = text or ttext
	sbt = sbt or tsbt
	sb = sbt:GetParent()

	-- print(cascade and "CASCADE!!" or "")
	-- print("|cffffff7fBG|r", not not background, "|cffffff7fTEXT|r", not not text, "|cffffff7fSBT|r", not not sbt, "|cffffff7fSB|r", not not sb)

	if not cascade then
		local PRESET = PRESETS[preset or "14"]

		bar.ignoreFramePositionManager = true
		bar:SetSize(166, tonumber(preset or "14"))

		if not background then
			background = bar:CreateTexture(nil, "BACKGROUND", nil, 0)
		end

		background:SetTexture(unpack(COLORS.darkgray))
		background:SetAllPoints()

		if text then
			text:SetFont(M.font, PRESET.textHeight)
			text:SetWordWrap(false)
			text:SetJustifyV("MIDDLE")
			text:SetDrawLayer("OVERLAY", 1)
			text:ClearAllPoints()
			text:SetPoint("TOPLEFT", 1, 0)
			text:SetPoint("BOTTOMRIGHT", -1, 0)
			text:SetShadowColor(0, 0, 0)
			text:SetShadowOffset(1, -1)
			bar.Text = text
		end

		sbt:SetDrawLayer("BACKGROUND", 1)
		sbt:SetTexture("Interface\\BUTTONS\\WHITE8X8")
		bar.Texture = sbt

		if sb ~= bar then
			sb:SetAllPoints()
		end

		local gloss = bar:CreateTexture(nil, "OVERLAY", nil, 0)
		gloss:SetTexture("Interface\\AddOns\\oUF_LS\\media\\statusbar_horizontal")
		gloss:SetTexCoord(0, 1, 0 / 64, 20 / 64)
		gloss:SetAllPoints()

		if addBorder then
			local capWidth, capHeight = unpack(PRESET.capSize)

			local fgLeft = bar:CreateTexture(nil, "OVERLAY", nil, 0)
			fgLeft:SetTexture("Interface\\AddOns\\oUF_LS\\media\\statusbar_horizontal")
			fgLeft:SetTexCoord(0 / 32, 14 / 32, 33 / 64, 55 / 64)
			fgLeft:SetSize(capWidth, capHeight)
			fgLeft:SetPoint("RIGHT", bar, "LEFT", 3, 0)

			local fgMiddleTop = bar:CreateTexture(nil, "OVERLAY", nil, 0)
			fgMiddleTop:SetTexture("Interface\\AddOns\\oUF_LS\\media\\statusbar_horizontal")
			fgMiddleTop:SetTexCoord(0, 1, 20 / 64, 23 / 64)
			fgMiddleTop:SetHeight(3)
			fgMiddleTop:SetPoint("BOTTOMLEFT", bar, "TOPLEFT", 0, 0)
			fgMiddleTop:SetPoint("BOTTOMRIGHT", bar, "TOPRIGHT", 0, 0)

			local fgMiddleBottom = bar:CreateTexture(nil, "OVERLAY", nil, 0)
			fgMiddleBottom:SetTexture("Interface\\AddOns\\oUF_LS\\media\\statusbar_horizontal")
			fgMiddleBottom:SetTexCoord(0, 1, 23 / 64, 20 / 64)
			fgMiddleBottom:SetHeight(3)
			fgMiddleBottom:SetPoint("TOPLEFT", bar, "BOTTOMLEFT", 0, 0)
			fgMiddleBottom:SetPoint("TOPRIGHT", bar, "BOTTOMRIGHT", 0, 0)

			local fgRight = bar:CreateTexture(nil, "OVERLAY", nil, 0)
			fgRight:SetTexture("Interface\\AddOns\\oUF_LS\\media\\statusbar_horizontal")
			fgRight:SetTexCoord(18 / 32, 32 / 32, 33 / 64, 55 / 64)
			fgRight:SetSize(capWidth, capHeight)
			fgRight:SetPoint("LEFT", bar, "RIGHT", -3, 0)
		end
	else
		return background, text, sbt
	end
end

function E:CreateStatusBar(parent, name, width, preset, addBorder)
	local PRESET = PRESETS[preset]

	local bar = CreateFrame("StatusBar", name, parent)
	bar:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8")
	bar:GetStatusBarTexture():SetDrawLayer("BACKGROUND", 1)
	bar:SetSize(width, tonumber(preset))

	local bg = bar:CreateTexture(nil, "BACKGROUND", nil, 0)
	bg:SetTexture(unpack(COLORS.darkgray))
	bg:SetAllPoints()
	bar.Bg = bg

	local text = E:CreateFontString(bar, PRESET.textHeight, nil, true)
	text:SetDrawLayer("OVERLAY", 1)
	text:SetPoint("TOPLEFT", 1, 0)
	text:SetPoint("BOTTOMRIGHT", -1, 0)
	bar.Text = text

	local gloss = bar:CreateTexture(nil, "OVERLAY", nil, 0)
	gloss:SetTexture("Interface\\AddOns\\oUF_LS\\media\\statusbar_horizontal")
	gloss:SetTexCoord(0, 1, 0 / 64, 20 / 64)
	gloss:SetAllPoints()

	if addBorder then
		local capWidth, capHeight = unpack(PRESET.capSize)

		local fgLeft = bar:CreateTexture(nil, "OVERLAY", nil, 0)
		fgLeft:SetTexture("Interface\\AddOns\\oUF_LS\\media\\statusbar_horizontal")
		fgLeft:SetTexCoord(0 / 32, 14 / 32, 33 / 64, 55 / 64)
		fgLeft:SetSize(capWidth, capHeight)
		fgLeft:SetPoint("RIGHT", bar, "LEFT", 3, 0)

		local fgMiddleTop = bar:CreateTexture(nil, "OVERLAY", nil, 0)
		fgMiddleTop:SetTexture("Interface\\AddOns\\oUF_LS\\media\\statusbar_horizontal")
		fgMiddleTop:SetTexCoord(0, 1, 20 / 64, 23 / 64)
		fgMiddleTop:SetHeight(3)
		fgMiddleTop:SetPoint("BOTTOMLEFT", bar, "TOPLEFT", 0, 0)
		fgMiddleTop:SetPoint("BOTTOMRIGHT", bar, "TOPRIGHT", 0, 0)

		local fgMiddleBottom = bar:CreateTexture(nil, "OVERLAY", nil, 0)
		fgMiddleBottom:SetTexture("Interface\\AddOns\\oUF_LS\\media\\statusbar_horizontal")
		fgMiddleBottom:SetTexCoord(0, 1, 23 / 64, 20 / 64)
		fgMiddleBottom:SetHeight(3)
		fgMiddleBottom:SetPoint("TOPLEFT", bar, "BOTTOMLEFT", 0, 0)
		fgMiddleBottom:SetPoint("TOPRIGHT", bar, "BOTTOMRIGHT", 0, 0)

		local fgRight = bar:CreateTexture(nil, "OVERLAY", nil, 0)
		fgRight:SetTexture("Interface\\AddOns\\oUF_LS\\media\\statusbar_horizontal")
		fgRight:SetTexCoord(18 / 32, 32 / 32, 33 / 64, 55 / 64)
		fgRight:SetSize(capWidth, capHeight)
		fgRight:SetPoint("LEFT", bar, "RIGHT", -3, 0)
	end

	return bar
end
