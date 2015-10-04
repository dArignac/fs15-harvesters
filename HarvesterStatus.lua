HarvesterStatus = {
	saveAndLoadFunctionsOverwritten = false;
	hasMouseCursorActive = false;
	canScroll = false;
	fileFound = false;
	showWarning = true;
	debug = true;
	modDir = g_currentModDirectory;
	imgDir = g_currentModDirectory .. 'res/';
	
	version = "1.0";
	author = "darignac";
	scriptName = "harvesterstatus";
};

-- px are in targetSize for 1920x1080
local function pxToNormal(px, dimension)
	local ret;
	if dimension == 'x' then
		ret = (px / 1920);
	else
		ret = (px / 1080);
	end;

	return ret;
end;

local modItem = ModsUtil.findModItemByModName(HarvesterStatus.modName);
if modItem and modItem.version and modItem.author then
	HarvesterStatus.version, HarvesterStatus.author = modItem.version, modItem.author;
end;

addModEventListener(HarvesterStatus);

function HarvesterStatus:loadMap()
	if self.initialized then
		return;
	end;
	
	self.inputModifier = self:getKeyIdOfModifier(InputBinding.HARVESTER_STATUS_HUD);
	self.helpButtonText = g_i18n:getText('HARVESTER_STATUS_HUD_SHOW');
	
	self.gui = {
		width = pxToNormal(200, 'x');
		height = pxToNormal(100, 'y');
	};
	
	local horizontalMargin = pxToNormal(16, 'x');
	self.gui.x1 = 1 - self.gui.width - horizontalMargin;
	self.gui.x2 = self.gui.x1 + self.gui.width;
	self.gui.y1 = pxToNormal(390, 'y');
	self.gui.y2 = self.gui.y1 + self.gui.height;
	
	local gfxPath = Utils.getFilename('white.png', HarvesterStatus.imgDir);
	self.gui.background = Overlay:new('hsBackground', gfxPath, self.gui.x1, self.gui.y1, self.gui.width, self.gui.height);
	
	self.initialized = true;
	print(('## HarvesterStatus v%s by %s loaded'):format(HarvesterStatus.version, HarvesterStatus.author));
end;

function HarvesterStatus:deleteMap()
	self.initialized = false;
end;

function HarvesterStatus:update()
	if g_currentMission.paused or g_gui.currentGui ~= nil then
    return;
  end;

	if InputBinding.hasEvent(InputBinding.HARVESTER_STATUS_HUD) then
		self:setHudState(self:loopNumberSequence(self.gui.hudState + 1, HarvesterStatus.HUDSTATE_INTERACTIVE, HarvesterStatus.HUDSTATE_CLOSED));
	end;

	if g_currentMission.showHelpText and (self.inputModifier == nil or Input.isKeyPressed(self.inputModifier)) then
		g_currentMission:addHelpButtonText(self.helpButtonText, InputBinding.HARVESTER_STATUS_HUD);
	end;
end;

function HarvesterStatus:draw()
	local g = self.gui;
	g.background:render();
end;

function HarvesterStatus:getKeyIdOfModifier(binding)
	if InputBinding.actions[binding] == nil then
		return nil;
	end;
	if #(InputBinding.actions[binding].keys1) <= 1 then
		return nil;
	end;
	-- Check if first key in key-sequence is a modifier key (LSHIFT/RSHIFT/LCTRL/RCTRL/LALT/RALT)
	if Input.keyIdIsModifier[ InputBinding.actions[binding].keys1[1] ] then
		return InputBinding.actions[binding].keys1[1]; -- Return the keyId of the modifier key
	end;
	return nil;
end

function HarvesterStatus:mouseEvent(posX, posY, isDown, isUp, mouseButton)
  return;
end

function HarvesterStatus:keyEvent(unicode, sym, modifier, isDown)
  return;
end;