local myName, me = ...
local L = me.L

ShowBiSEvoker = {}

ShowBiSEvoker["EVOKERDevastation"] =  L["EVOKERDevastation"]
ShowBiSEvoker["EVOKERPreservation"] = L["EVOKERPreservation"]

function ShowBiSEvokerFrameOnEvent(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "ShowBiSEvoker" then
		self:UnregisterEvent("ADDON_LOADED")
		PaperDollFrame:HookScript("OnShow", function() ShowBiSEvokerFrameUpdate(self) end)
	end
	if event == "SPELLS_CHANGED" and IsAddOnLoaded("ShowBiSEvoker") then
		ShowBiSEvokerFrameUpdate(self)
	end
end

function ShowBiSEvokerFrameCreate(frame)
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
		ShowBiSEvokerText:ClearAllPoints()
		ShowBiSEvokerText:SetAllPoints(frame) 
		ShowBiSEvokerText:SetJustifyH("CENTER")
		ShowBiSEvokerText:SetJustifyV("CENTER")

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
	if id == 1467 then 
		spec = "Devastation"
	elseif id == 1468 then 
		spec = "Preservation"
	end
	return spec
end

function ShowBiSEvokerFrameUpdate(frame)
	if ShowBiSEvokerFrameCreate(frame) then
		local temp, class = UnitClass("player")
		local spec = GetSpecializationInfo(GetSpecialization())
		spec = GetSpecializationName(spec)
		local text = ShowBiSEvoker[class .. spec];
		ShowBiSEvokerText:SetText(text)
	end
end

local ShowBiSEvokerFrame = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate");
ShowBiSEvokerText = ShowBiSEvokerFrame:CreateFontString(nil, "OVERLAY", "GameFontWhite")
ShowBiSEvokerFrame:RegisterEvent("ADDON_LOADED")
ShowBiSEvokerFrame:RegisterEvent("SPELLS_CHANGED")
ShowBiSEvokerFrame:SetScript("OnEvent", ShowBiSEvokerFrameOnEvent)
