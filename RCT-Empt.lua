--[[
	---------------------------------------------------------
	Empty Battery Alarm announces if you have an empty
	battery before flight. (Or other operation)
	
	Settings: Select sensor, working time, alarm-threshold 
	and audio-file to be played if battery is empty.
	
	Localisation-file has to be as /Apps/Lang/RCT-Empt.jsn
	
	Spanish translation courtesy from César Casado
	Italian translation courtesy from Fabrizio Zaini 
	---------------------------------------------------------
	Empty Battery Alarm is a part of RC-Thoughts Jeti Tools.
	---------------------------------------------------------
	Released under MIT-license by Tero @ RC-Thoughts.com 2016
	---------------------------------------------------------
--]]
collectgarbage()
----------------------------------------------------------------------
-- Locals for the application
local senso1, senso2, senso3, time1, time2, time3 
local senid1, senid2, senid3, alarm1, alarm2, alarm3
local sid1, sparam1, sid2, sparam2, sid3, sparam3
local senpa1, senpa2, senpa3, vFile1, vFile2, vfile3
local repeat1, repeat2, repeat3
local vFile1Played, vFile2Played, vFile3Played
local sensoLalist1 = {"..."}
local sensoIdlist1 = {"..."}
local sensoPalist1 = {"..."}
local repeatlist = {}
----------------------------------------------------------------------
-- Read translations
local function setLanguage()
    local lng=system.getLocale()
    local file = io.readall("Apps/Lang/RCT-Empt.jsn")
    local obj = json.decode(file)
    if(obj) then
        trans3 = obj[lng] or obj[obj.default]
    end
end
--------------------------------------------------------------------------------
-- Read available sensors for user to select
local sensors = system.getSensors()
for i,sensor in ipairs(sensors) do
	if (sensor.label ~= "") then
		table.insert(sensoLalist1, string.format("%s", sensor.label))
		table.insert(sensoIdlist1, string.format("%s", sensor.id))
		table.insert(sensoPalist1, string.format("%s", sensor.param))
	end
end
----------------------------------------------------------------------
-- Store settings when changed by user
local function sensor1Changed(value)
	senso1=value
	senid1=value
	senpa1=value
	system.pSave("senso1",value)
	system.pSave("senid1",value)
	system.pSave("senpa1",value)
	sid1 = string.format("%s", sensoIdlist1[senid1])
	sparam1 = string.format("%s", sensoPalist1[senpa1])
	if (sid1 == "...") then
		sid1 = 0
		sparam1 = 0
	end
	system.pSave("sid1", sid1)
	system.pSave("sparam1", sparam1)
end

local function sensor2Changed(value)
	senso2=value
	senid2=value
	senpa2=value
	system.pSave("senso2",value)
	system.pSave("senid2",value)
	system.pSave("senpa2",value)
	sid2 = string.format("%s", sensoIdlist1[senid2])
	sparam2 = string.format("%s", sensoPalist1[senpa2])
	if (sid2 == "...") then
		sid2 = 0
		sparam2 = 0
	end
	system.pSave("sid2", sid2)
	system.pSave("sparam2", sparam2)
end

local function sensor3Changed(value)
	senso3=value
	senid3=value
	senpa3=value
	system.pSave("senso3",value)
	system.pSave("senid3",value)
	system.pSave("senpa3",value)
	sid3 = string.format("%s", sensoIdlist1[senid3])
	sparam3 = string.format("%s", sensoPalist1[senpa3])
	if (sid3 == "...") then
		sid3 = 0
		sparam3 = 0
	end
	system.pSave("sid3", sid3)
	system.pSave("sparam3", sparam3)
end

local function time1Changed(value)
	time1=value
	system.pSave("time1",value)
end

local function time2Changed(value)
	time2=value
	system.pSave("time2",value)
end

local function time3Changed(value)
	time3=value
	system.pSave("time3",value)
end

local function alarm1Changed(value)
	alarm1=value
	system.pSave("alarm1",value)
end

local function alarm2Changed(value)
	alarm2=value
	system.pSave("alarm2",value)
end

local function alarm3Changed(value)
	alarm3=value
	system.pSave("alarm3",value)
end

local function vFile1Changed(value)
	vFile1=value
	system.pSave("vFile1",value)
end

local function vFile2Changed(value)
	vFile2=value
	system.pSave("vFile2",value)
end

local function vFile3Changed(value)
	vFile3=value
	system.pSave("vFile3",value)
end

local function repeat1Changed(value)
	repeat1=value
	system.pSave("repeat1",value)
end

local function repeat2Changed(value)
	repeat2=value
	system.pSave("repeat2",value)
end

local function repeat3Changed(value)
	repeat3=value
	system.pSave("repeat3",value)
end
----------------------------------------------------------------------
-- Draw the main form (Application inteface)
local function initForm()
	form.addRow(1)
	form.addLabel({label="---     RC-Thoughts Jeti Tools      ---",font=FONT_BIG})
	
	-- Battery 1
	form.addRow(1)
	form.addLabel({label=trans3.batte1,font=FONT_BOLD})
	
	form.addRow(2)
	form.addLabel({label=trans3.sensorSelect})
	form.addSelectbox(sensoLalist1,senso1,true,sensor1Changed)
	
	form.addRow(2)
	form.addLabel({label=trans3.selTime})
	form.addIntbox(time1,0,60,0,0,1,time1Changed)
	
	form.addRow(2)
	form.addLabel({label=trans3.alarmThr})
	form.addIntbox(string.format("%.1f",alarm1),0,1000,0,1,1,alarm1Changed)
	
	form.addRow(2)
	form.addLabel({label=trans3.selAudio})
	form.addAudioFilebox(vFile1,vFile1Changed)
	
	form.addRow(2)
	form.addLabel({label=trans3.rpt,width=200})
	form.addSelectbox(repeatlist,repeat1,false,repeat1Changed)
	
	-- Battery 2
	form.addRow(1)
	form.addLabel({label=trans3.batte2,font=FONT_BOLD})
	
	form.addRow(2)
	form.addLabel({label=trans3.sensorSelect})
	form.addSelectbox(sensoLalist1,senso2,true,sensor2Changed)
	
	form.addRow(2)
	form.addLabel({label=trans3.selTime})
	form.addIntbox(time2,0,60,0,0,1,time2Changed)
	
	form.addRow(2)
	form.addLabel({label=trans3.alarmThr})
	form.addIntbox(string.format("%.1f",alarm2),0,1000,0,1,1,alarm2Changed)
	
	form.addRow(2)
	form.addLabel({label=trans3.selAudio})
	form.addAudioFilebox(vFile2,vFile2Changed)
	
	form.addRow(2)
	form.addLabel({label=trans3.rpt,width=200})
	form.addSelectbox(repeatlist,repeat2,false,repeat2Changed)
	
	-- Battery 3
	form.addRow(1)
	form.addLabel({label=trans3.batte3,font=FONT_BOLD})
	
	form.addRow(2)
	form.addLabel({label=trans3.sensorSelect})
	form.addSelectbox(sensoLalist1,senso3,true,sensor3Changed)
	
	form.addRow(2)
	form.addLabel({label=trans3.selTime})
	form.addIntbox(time3,0,60,0,0,1,time3Changed)
	
	form.addRow(2)
	form.addLabel({label=trans3.alarmThr})
	form.addIntbox(string.format("%.1f",alarm3),0,1000,0,1,1,alarm3Changed)
	
	form.addRow(2)
	form.addLabel({label=trans3.selAudio})
	form.addAudioFilebox(vFile3,vFile3Changed)
	
	form.addRow(2)
	form.addLabel({label=trans3.rpt,width=200})
	form.addSelectbox(repeatlist,repeat3,false,repeat3Changed)
	
	form.addRow(1)
	form.addLabel({label="Powered by RC-Thoughts.com - v."..emptVersion.." ",font=FONT_MINI, alignRight=true})
    collectgarbage()
end
----------------------------------------------------------------------
-- Runtime functions
local function loop()
	local tCurrent = system.getTime()
	local sense1 = system.getSensorByID(sid1, sparam1)
	if(sense1 and sense1.valid) then
		if(tInit1 and tInit1 > 1) then
			else
			tInit1 = system.getTime()
			tStart1 = (tInit1 + 3)
			tStop1 = (tStart1 + 60)
			tPlay1 = (tInit1 + time1)
		end
		if (tStart1 <= tCurrent and tStop1 >= tCurrent) then
			if(sense1.value <= alarm1) then
				if(tCurrent >= tPlay1 and vFile1played ~= 1) then
					if (repeat1 == 2) then
						system.messageBox(trans3.sysWarn1,5)
						system.playFile(vFile1,AUDIO_AUDIO_QUEUE)
						system.playFile(vFile1,AUDIO_AUDIO_QUEUE)
						system.playFile(vFile1,AUDIO_AUDIO_QUEUE)
						vFile1played = 1
						else
						system.messageBox(trans3.sysWarn1,5)
						system.playFile(vFile1,AUDIO_AUDIO_QUEUE)
						vFile1played = 1
					end
				end
			end
			else
			vFile1played = 0
		end
		else
		vFile1played = 0
		tInit1 = 0
	end
	--- Battery 2
	local sense2 = system.getSensorByID(sid2, sparam2)
	if(sense2 and sense2.valid) then
		if(tInit2 and tInit2 > 1) then
			else
			tInit2 = system.getTime()
			tStart2 = (tInit2 + 3)
			tStop2 = (tStart2 + 60)
			tPlay2 = (tInit2 + time2)
		end
		if (tStart2 <= tCurrent and tStop2 >= tCurrent) then
			if(sense2.value <= alarm2) then
				if(tCurrent >= tPlay2 and vFile2played ~= 1) then
					if (repeat2 == 2) then
						system.messageBox(trans3.sysWarn2,5)
						system.playFile(vFile2,AUDIO_AUDIO_QUEUE)
						system.playFile(vFile2,AUDIO_AUDIO_QUEUE)
						system.playFile(vFile2,AUDIO_AUDIO_QUEUE)
						vFile2played = 1
						else
						system.messageBox(trans3.sysWarn2,5)
						system.playFile(vFile2,AUDIO_AUDIO_QUEUE)
						vFile2played = 1
					end
				end
			end
			else
			vFile2played = 0
		end
		else
		vFile2played = 0
		tInit2 = 0
	end
	--- Battery 3
	local sense3 = system.getSensorByID(sid3, sparam3)
	if(sense3 and sense3.valid) then
		if(tInit3 and tInit3 > 1) then
			else
			tInit3 = system.getTime()
			tStart3 = (tInit3 + 3)
			tStop3 = (tStart3 + 60)
			tPlay3 = (tInit3 + time3)
		end
		if (tStart3 <= tCurrent and tStop3 >= tCurrent) then
			if(sense3.value <= alarm3) then
				if(tCurrent >= tPlay3 and vFile3played ~= 1) then
					if (repeat3 == 2) then
						system.messageBox(trans3.sysWarn3,5)
						system.playFile(vFile3,AUDIO_AUDIO_QUEUE)
						system.playFile(vFile3,AUDIO_AUDIO_QUEUE)
						system.playFile(vFile3,AUDIO_AUDIO_QUEUE)
						vFile3played = 1
						else
						system.messageBox(trans3.sysWarn3,5)
						system.playFile(vFile3,AUDIO_AUDIO_QUEUE)
						vFile3played = 1
					end
				end
			end
			else
			vFile3played = 0
		end
		else
		vFile3played = 0
		tInit3 = 0
	end
    collectgarbage()
end
----------------------------------------------------------------------
-- Application initialization
local function init()
	system.registerForm(1,MENU_APPS,trans3.appName,initForm)
	senso1 = system.pLoad("senso1",0)
	senid1 = system.pLoad("senid1",0)
	senpa1 = system.pLoad("senpa1",0)
	sid1 = system.pLoad("sid1",0)
	sparam1 = system.pLoad("sparam1",0)
	senso2 = system.pLoad("senso2",0)
	senid2 = system.pLoad("senid2",0)
	senpa2 = system.pLoad("senpa2",0)
	sid2 = system.pLoad("sid2",0)
	sparam2 = system.pLoad("sparam2",0)
	senso3 = system.pLoad("senso3",0)
	senid3 = system.pLoad("senid3",0)
	senpa3 = system.pLoad("senpa3",0)
	sid3 = system.pLoad("sid3",0)
	sparam3 = system.pLoad("sparam3",0)
	time1 = system.pLoad("time1",0)
	time2 = system.pLoad("time2",0)
	time3 = system.pLoad("time3",0)
	alarm1 = system.pLoad("alarm1",0)
	alarm2 = system.pLoad("alarm2",0)
	alarm3 = system.pLoad("alarm3",0)
	vFile1 = system.pLoad("vFile1","...")
	vFile2 = system.pLoad("vFile2","...")
	vFile3 = system.pLoad("vFile3","...")
	repeat1 = system.pLoad("repeat1",1)
	repeat2 = system.pLoad("repeat2",1)
	repeat3 = system.pLoad("repeat3",1)
	table.insert(repeatlist,trans3.neg)
	table.insert(repeatlist,trans3.pos)
    collectgarbage()
end
----------------------------------------------------------------------
emptVersion = "1.3"
setLanguage()
collectgarbage()
return {init=init, loop=loop, author="RC-Thoughts", version=emptVersion, name=trans3.appName}