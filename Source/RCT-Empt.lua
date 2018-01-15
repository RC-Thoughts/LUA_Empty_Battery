--[[
	---------------------------------------------------------
	Empty Battery Alarm announces if you have an empty
	battery before flight. (Or other operation)
	
	Settings: Select sensor, working time, alarm-threshold 
	and audio-file to be played if battery is empty.
	
	Localization-file has to be as /Apps/Lang/RCT-Empt.jsn
	
	Spanish translation courtesy from César Casado
	Italian translation courtesy from Fabrizio Zaini
	---------------------------------------------------------
	Empty Battery Alarm is a part of RC-Thoughts Jeti Tools.
	---------------------------------------------------------
                Released under MIT-license
     Copyright Tero Salminen and RC-Thoughts.com 2016 - 2018
	---------------------------------------------------------
--]]
collectgarbage()
----------------------------------------------------------------------
-- Locals for the application
local time1, time2, time3, alarm1, alarm2, alarm3
local senid1, senid2, senid3, sparam1, sparam2, sparam3
local vFile1, vFile2, vfile3, repeat1, repeat2, repeat3
local vFile1Played, vFile2Played, vFile3Played
local sensorsAvailable = {"..."}
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
----------------------------------------------------------------------
-- Store settings when changed by user
local function sensor1Changed(value)
    senid1  = sensorsAvailable[value].id
	sparam1  = sensorsAvailable[value].param
	system.pSave("senid1", senid1)
	system.pSave("sparam1", sparam1)
end

local function sensor2Changed(value)
	senid2  = sensorsAvailable[value].id
	sparam2  = sensorsAvailable[value].param
	system.pSave("senid2", senid2)
	system.pSave("sparam2", sparam2)
end

local function sensor3Changed(value)
	senid3  = sensorsAvailable[value].id
	sparam3  = sensorsAvailable[value].param
	system.pSave("senid3", senid3)
	system.pSave("sparam3", sparam3)
end

local function batte1nameChanged(value)
    batte1name=value
    system.pSave("batte1name",value)
end

local function batte2nameChanged(value)
    batte2name=value
    system.pSave("batte2name",value)
end

local function batte3nameChanged(value)
    batte3name=value
    system.pSave("batte3name",value)
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
-- Draw the main form (Application interface)
local function initForm()
    -- List sensors only if menu is active to preserve memory at runtime 
    -- (measured up to 25% save if menu is not opened)
    sensorsAvailable = {}
    local sensors = system.getSensors();
    local list={}
    local curIndex1, curIndex2, curIndex3 = -1, -1, .1
    local descr = ""
    for index,sensor in ipairs(sensors) do 
        if(sensor.param == 0) then
            descr = sensor.label
            else
            list[#list + 1] = string.format("%s - %s", descr, sensor.label)
            sensorsAvailable[#sensorsAvailable + 1] = sensor
            if(sensor.id == senid1 and sensor.param == sparam1) then
                curIndex1 =# sensorsAvailable
            end
            if(sensor.id == senid2 and sensor.param == sparam2) then
                curIndex2 =# sensorsAvailable
            end
            if(sensor.id == senid3 and sensor.param == sparam3) then
                curIndex3 =# sensorsAvailable
            end
        end
    end 
    
	form.addRow(1)
	form.addLabel({label="---     RC-Thoughts Jeti Tools      ---",font=FONT_BIG})
	
	-- Battery 1
	form.addRow(1)
	form.addLabel({label=trans3.batte1,font=FONT_BOLD})
    
    form.addRow(2)
    form.addLabel({label=trans3.batteryName,width=140})
    form.addTextbox(batte1name,18,batte1nameChanged,{width=167})
	
	form.addRow(2)
	form.addLabel({label=trans3.sensorSelect})
	form.addSelectbox(list,curIndex1,true,sensor1Changed)
	
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
    form.addLabel({label=trans3.batteryName,width=140})
    form.addTextbox(batte2name,18,batte2nameChanged,{width=167})
	
	form.addRow(2)
	form.addLabel({label=trans3.sensorSelect})
	form.addSelectbox(list,curIndex2,true,sensor2Changed)
	
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
    form.addLabel({label=trans3.batteryName,width=140})
    form.addTextbox(batte3name,18,batte3nameChanged,{width=167})
	
	form.addRow(2)
	form.addLabel({label=trans3.sensorSelect})
	form.addSelectbox(list,curIndex3,true,sensor3Changed)
	
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
	local sense1 = system.getSensorByID(senid1, sparam1)
	if(sense1 and sense1.valid) then
		if(tInit1 and tInit1 > 1) then
			else
			tInit1 = system.getTime()
			tStart1 = (tInit1 + 3)
			tStop1 = (tStart1 + 60)
			tPlay1 = (tInit1 + time1)
		end
		if (tStart1 <= tCurrent and tStop1 >= tCurrent) then
			if(sense1.value <= (alarm1 / 10)) then
				if(tCurrent >= tPlay1 and vFile1played ~= 1) then
					if (repeat1 == 2) then
                        system.messageBox(trans3.sysWarn .. batte1name,5)
						system.playFile(vFile1,AUDIO_AUDIO_QUEUE)
						system.playFile(vFile1,AUDIO_AUDIO_QUEUE)
						system.playFile(vFile1,AUDIO_AUDIO_QUEUE)
						vFile1played = 1
						else
						system.messageBox(trans3.sysWarn .. batte1name,5)
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
	local sense2 = system.getSensorByID(senid2, sparam2)
	if(sense2 and sense2.valid) then
		if(tInit2 and tInit2 > 1) then
			else
			tInit2 = system.getTime()
			tStart2 = (tInit2 + 3)
			tStop2 = (tStart2 + 60)
			tPlay2 = (tInit2 + time2)
		end
		if (tStart2 <= tCurrent and tStop2 >= tCurrent) then
			if(sense2.value <= (alarm2 / 10)) then
				if(tCurrent >= tPlay2 and vFile2played ~= 1) then
					if (repeat2 == 2) then
                        system.messageBox(trans3.sysWarn .. batte2name,5)
						system.playFile(vFile2,AUDIO_AUDIO_QUEUE)
						system.playFile(vFile2,AUDIO_AUDIO_QUEUE)
						system.playFile(vFile2,AUDIO_AUDIO_QUEUE)
						vFile2played = 1
						else
                        system.messageBox(trans3.sysWarn .. batte2name,5)
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
	local sense3 = system.getSensorByID(senid3, sparam3)
	if(sense3 and sense3.valid) then
		if(tInit3 and tInit3 > 1) then
			else
			tInit3 = system.getTime()
			tStart3 = (tInit3 + 3)
			tStop3 = (tStart3 + 60)
			tPlay3 = (tInit3 + time3)
		end
		if (tStart3 <= tCurrent and tStop3 >= tCurrent) then
			if(sense3.value <= (alarm3 / 10)) then
				if(tCurrent >= tPlay3 and vFile3played ~= 1) then
					if (repeat3 == 2) then
						system.messageBox(trans3.sysWarn .. batte3name,5)
						system.playFile(vFile3,AUDIO_AUDIO_QUEUE)
						system.playFile(vFile3,AUDIO_AUDIO_QUEUE)
						system.playFile(vFile3,AUDIO_AUDIO_QUEUE)
						vFile3played = 1
						else
                        system.messageBox(trans3.sysWarn .. batte3name,5)
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
	senid1 = system.pLoad("senid1",0)
	sparam1 = system.pLoad("sparam1",0)
	senid2 = system.pLoad("senid2",0)
	sparam2 = system.pLoad("sparam2",0)
	senid3 = system.pLoad("senid3",0)
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
    batte1name = system.pLoad("batte1name",trans3.batte1name)
    batte2name = system.pLoad("batte2name",trans3.batte2name)
    batte3name = system.pLoad("batte3name",trans3.batte3name)
	table.insert(repeatlist,trans3.neg)
	table.insert(repeatlist,trans3.pos)
    collectgarbage()
end
----------------------------------------------------------------------
emptVersion = "1.5"
setLanguage()
collectgarbage()
return {init=init, loop=loop, author="RC-Thoughts", version=emptVersion, name=trans3.appName}