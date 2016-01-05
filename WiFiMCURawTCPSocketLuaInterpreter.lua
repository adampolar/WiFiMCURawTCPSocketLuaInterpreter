newline="\r\n";
linestart="$ ";

inputCommand = "";
skt = net.new(net.TCP,net.SERVER)

net.on(skt, "accept", 
	function(clt,ip,port)
		net.send(clt, mcu.ver() .. newline .. linestart);
	end
)

net.on(skt,"receive",
	function(clt,data)
		if string.find(data, "\n") then
			temp = inputCommand;
			tempprint = print;
			print = function(val) net.send(clt,tostring(val)) end;
			func, err = loadstring(temp);
			if func then
				status, err = pcall(func);
			end
			if err then
				print(err);
				err = nil;
			end
			net.send(clt, newline .. linestart);
			print = tempprint;
			inputCommand="";
		else
			inputCommand = inputCommand .. data;
		end
	end
)

net.start(skt,23);