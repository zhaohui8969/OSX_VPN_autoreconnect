on run {input, parameters}
--入口
	--变量
	global LOG_FILE
	set ifname to "L2BF"
	set LOG_FILE to "~/var/log/L2BF_monitor.log"
	
	logme(0, "Demon started.")
	beep
	beep
	beep
	set flag to 0
	--循环检测
	repeat
		try
			do shell script "ping -c 1 -W 3000 220.181.57.217"
			if flag = 0 then	--第一次连接成功
				beep
				beep
			else if flag = -1 then	--重连成功
				beep
				beep
				logme("Reconnected!")
			end if
			set flag to 1
			logme(1, "Connected.")
			delay 5
		on error		--挂了
			beep
			set flag to -1
			logme(2, "Connection error! Try reconnect...")
			--控制面板重连
			tell application "System Events"
				tell network preferences
					disconnect service ifname
					delay 1
					connect service ifname
				end tell
			end tell
			delay 5
		end try
	end repeat
	
	return input
end run

on logme(id, msg)
--记录日志用
	global LOG_FILE
	do shell script "date \"+[%D %T] " & id & " " & msg & "\" >> " & LOG_FILE
end logme