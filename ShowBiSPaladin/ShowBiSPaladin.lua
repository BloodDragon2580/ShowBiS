local myName, me = ...
local L = me.L

ShowBiSPaladin = {}

ShowBiSPaladin["PALADINHoly"] = L["PALADINHoly"]
ShowBiSPaladin["PALADINProtection"] = L["PALADINProtection"]
ShowBiSPaladin["PALADINRetribution"] = L["PALADINRetribution"]

function ShowBiSPaladinFrameOnEvent(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "ShowBiSPaladin" then
		self:UnregisterEvent("ADDON_LOADED")
		PaperDollFrame:HookScript("OnShow", function() ShowBiSPaladinFrameUpdate(self) end)
	end
	if event == "SPELLS_CHANGED" and IsAddOnLoaded("ShowBiSPaladin") then
		ShowBiSPaladinFrameUpdate(self)
	end
end

function ShowBiSPaladinFrameCreate(frame)
	if PaperDollFrame:IsVisible() then
		frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
						   edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
						   tile = true,
						   tileSize = 16,
						   edgeSize = 16, 
						   insets = {left = 1,
									 right = 1,
									 top = 1,
									 bottom = 1}}) 
		frame:SetBackdropColor(0, 0, 0, 1)
		frame:SetFrameStrata("TOOLTIP")
		frame:SetWidth(PaperDollFrame:GetWidth() - 50) 
		if frame == PaperDollFrame then
			frame:SetHeight(150)
		else
			frame:SetHeight(500) --High text
			frame:SetWidth(550) --Width text
		end
		ShowBiSPaladinText:ClearAllPoints()
		ShowBiSPaladinText:SetAllPoints(frame) 
		ShowBiSPaladinText:SetJustifyH("CENTER")
		ShowBiSPaladinText:SetJustifyV("CENTER")

		frame:SetPoint("BOTTOMRIGHT", PaperDollFrame, "TOPRIGHT",550,- 440) -- witdh x High Position
		frame:SetParent(PaperDollFrame)
		frame:Show()
--------------- Frame Move ---------------
		frame:RegisterForDrag("LeftButton","RightButton");
		frame:EnableMouse(true);
		frame:SetMovable(true);
		frame:SetScript("OnMouseDown",OnMouseDown);
		frame:SetScript("OnMouseUp",OnMouseUp);
		frame:SetScript("OnHide",OnHide);
--------------- Frame Move ---------------
		return true
	end
	return false
end

--------------- Frame Move ---------------
function OnMouseDown(self)
    self:StartMoving();
    self.isMoving = true;
    self.hasMoved = false;
end
function OnMouseUp(self)
    if ( self.isMoving ) then
        self:StopMovingOrSizing();
        self.isMoving = false;
        self.hasMoved = true;
    end
end
 
function OnHide(self)       
    if ( self.isMoving ) then
        self:StopMovingOrSizing();
        self.isMoving = false;
    end
end
--------------- Frame Move ---------------

function GetSpecializationName(id)
	local spec = ""
	if id == 65 then 
		spec = "Holy"
	elseif id == 66 then 
		spec = "Protection"
	elseif id == 70 then 
		spec = "Retribution"
	end
	return spec
end

function ShowBiSPaladinFrameUpdate(frame)
	if ShowBiSPaladinFrameCreate(frame) then
		local temp, class = UnitClass("player")
		local spec = GetSpecializationInfo(GetSpecialization())
		spec = GetSpecializationName(spec)
		local text = ShowBiSPaladin[class .. spec];
		ShowBiSPaladinText:SetText(text)
	end
end

local ShowBiSPaladinFrame = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate");
ShowBiSPaladinText = ShowBiSPaladinFrame:CreateFontString(nil, "OVERLAY", "GameFontWhite")
ShowBiSPaladinFrame:RegisterEvent("ADDON_LOADED")
ShowBiSPaladinFrame:RegisterEvent("SPELLS_CHANGED")
ShowBiSPaladinFrame:SetScript("OnEvent", ShowBiSPaladinFrameOnEvent)
