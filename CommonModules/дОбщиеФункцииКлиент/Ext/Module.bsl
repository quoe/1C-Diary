
Функция ПолучитьТекПользователя() Экспорт
	
	//ТекПольз = Справочники.Пользователи.НайтиПоНаименованию(ПользователиИнформационнойБазы.ТекущийПользователь().ПолноеИмя);
	//ТекПольз = ПараметрыСеанса.ТекущийПользователь;
	
	Возврат "";
	
КонецФункции

Функция ПолучитьТекстБуфераОбмена() Экспорт
	
	лОбъект = Новый COMОбъект("htmlfile");
	Возврат лОбъект.ParentWindow.ClipboardData.Getdata("Text");
	
КонецФункции

Функция УстановитьТекстВБуферОбмена(Текст) Экспорт
	
	лОбъект = Новый COMОбъект("htmlfile");
	лОбъект.ParentWindow.ClipboardData.Setdata("Text", Текст);
	Возврат Текст;
	
КонецФункции   

Функция ВыполнитьЗамерПроизводительности() Экспорт
	
	Попытка
		
		ЗамерПроизводительностиКлиент();
		
	Исключение
	КонецПопытки; 
	
КонецФункции // ВыполнитьЗамерПроизводительности()

Процедура СформироватьДерево(ЧтениеJSON, Дерево)
	
	ИмяСвойства = Неопределено;
	
	Пока ЧтениеJSON.Прочитать() Цикл
		TипJSON = ЧтениеJSON.ТипТекущегоЗначения;
		
		Если TипJSON = ТипЗначенияJSON.НачалоОбъекта 
			ИЛИ TипJSON = ТипЗначенияJSON.НачалоМассива Тогда
			НовыйОбъект = ?(TипJSON = ТипЗначенияJSON.НачалоОбъекта, Новый Соответствие, Новый Массив);
			
			Если ТипЗнч(Дерево) = Тип("Массив") Тогда
				Дерево.Добавить(НовыйОбъект);
			ИначеЕсли ТипЗнч(Дерево) = Тип("Соответствие") И ЗначениеЗаполнено(ИмяСвойства) Тогда
				Дерево.Вставить(ИмяСвойства, НовыйОбъект);
			КонецЕсли;
			
			СформироватьДерево(ЧтениеJSON, НовыйОбъект);
			
			Если Дерево = Неопределено Тогда
				Дерево = НовыйОбъект;
			КонецЕсли;
		ИначеЕсли TипJSON = ТипЗначенияJSON.ИмяСвойства Тогда
			ИмяСвойства = ЧтениеJSON.ТекущееЗначение;
		ИначеЕсли TипJSON = ТипЗначенияJSON.Число 
			ИЛИ TипJSON = ТипЗначенияJSON.Строка 
			ИЛИ TипJSON = ТипЗначенияJSON.Булево 
			ИЛИ TипJSON = ТипЗначенияJSON.Null Тогда
			Если ТипЗнч(Дерево) = Тип("Массив") Тогда
				Дерево.Добавить(ЧтениеJSON.ТекущееЗначение);
			ИначеЕсли ТипЗнч(Дерево) = Тип("Соответствие") Тогда
				Дерево.Вставить(ИмяСвойства, ЧтениеJSON.ТекущееЗначение);
			КонецЕсли;
		Иначе
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ЧтениеJSON(пПутьКФайлу)
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.ОткрытьФайл(пПутьКФайлу);
	
	Результат = Неопределено;
	СформироватьДерево(ЧтениеJSON, Результат);
	
	ЧтениеJSON.Закрыть();
	
	Возврат Результат;
	
КонецФункции 

Процедура ЗамерПроизводительностиКлиент() Экспорт
	
	лТекДата 		= ТекущаяДата();
	
	ТекстовыйФайл 	= Новый ТекстовыйДокумент;
	
	ObjShell 		= Новый COMОбъект("WScript.Shell") ;
	
	//Производительность
	ПутьКФайлу 		= ПолучитьИмяВременногоФайла("json");
	ПутьКФайлуВКавычках = """" + ПутьКФайлу + """";
	Script 			= "/c typeperf ""\Процессор(_Total)\% загруженности процессора"" -sc 1 >> " + ПутьКФайлуВКавычках + " & typeperf ""\Память\% использования выделенной памяти"" -sc 1 >> " + ПутьКФайлуВКавычках + " & typeperf ""\Физический диск(_Total)\% активности диска"" -sc 1 >> " + ПутьКФайлуВКавычках + " & exit 1";
	ObjScriptExec 	= ObjShell.Run("cmd.exe " + Script, 0, True);
	ТекстовыйФайл.Прочитать(ПутьКФайлу, КодировкаТекста.OEM);
	лРезультатПроизводительностьСтроки 	= ТекстовыйФайл.ПолучитьТекст();
	
	//Удалим файл
	Файл 		= Новый Файл(ПутьКФайлу);
	Если Файл.Существует() Тогда
		УдалитьФайлы(ПутьКФайлу);
	КонецЕсли;
	
	//Процессы
	ПутьКФайлу 			= ПолучитьИмяВременногоФайла("json");
	Script 				= ПолучитьСкриптPowerShell_Процессы(ПутьКФайлу);
	ObjScriptExec 		= ObjShell.Run("Powershell.exe -windowstyle hidden -Executionpolicy Bypass -nologo -noninteractive -comand " + Script, 0, True);
	//ObjScriptExec 		= ObjShell.Run("Powershell.exe -comand """ + Script + "");
	
	//ТекстовыйФайл.Прочитать(ПутьКФайлу);
	//лРезультатПроцессы 	= ТекстовыйФайл.ПолучитьТекст();
	лРезультатПроцессы 	= ЧтениеJSON(ПутьКФайлу);
	
	//Удалим файл
	Файл 		= Новый Файл(ПутьКФайлу);
	Если Файл.Существует() Тогда
		УдалитьФайлы(ПутьКФайлу);
	КонецЕсли;
	
	//Парсим данные Производительности
	//01 56 1011
	лРезультатПроизводительность 	= СтрРазделить(лРезультатПроизводительностьСтроки, Символы.ПС, Ложь);
	
	лЦПСтрокаСДатой 	= СтрЗаменить(лРезультатПроизводительность[1], """", "");
	лЦП 				= Число(СтрРазделить(лЦПСтрокаСДатой, ",", Ложь)[1]);
	
	лПамятьСтрокаСДатой = СтрЗаменить(лРезультатПроизводительность[6], """", "");
	лПамять 			= Число(СтрРазделить(лПамятьСтрокаСДатой, ",", Ложь)[1]);
	
	лАктивностьДискаСтрокаСДатой 	= СтрЗаменить(лРезультатПроизводительность[11], """", "");
	лАктивностьДиска 	 			= Число(СтрРазделить(лАктивностьДискаСтрокаСДатой, ",", Ложь)[1]);
	
	лРезЗагруженность = Новый Структура("ЗагрузкаЦП, ЗагрузкаПамяти, АктивностьДиска", лЦП, лПамять, лАктивностьДиска);
	//Парсим данные Процессов
	
	//Общее
	лОбщее 			= лРезультатПроцессы["HostInfo"];
	
	лПроцентЦПУ 	= лОбщее["CPULoadPercent"];
	лСреднееЦПУ 	= лОбщее["CpuLoadAverage"];
	лПроцентПамяти 	= лОбщее["MemoryUsedPercent"];
	
	лРезWmiЗагруженность 		= Новый Структура("WmiCpuLoadPercentage, WmiCpuLoadPercentageAverage, WmiMemoryUsedPercentage", лПроцентЦПУ, лСреднееЦПУ, лПроцентПамяти); 
	
	лМестоНаДисках 				= лОбщее["usedDiskSpaceDrives"];
	
	лРезМестоНаДисках 	= Новый СписокЗначений;
	Для каждого лЭлем Из лМестоНаДисках Цикл
		
		лДискИмя 			= лЭлем["driveLetter"];
		лДискЕмкость 		= лЭлем["driveCapacity"];
		лДискЗанято 		= лЭлем["usedDiskSpace"];
		лДискПроцентЗанят 	= лЭлем["usedDiskSpacePct"];
		
		лРезМестоНаДисках.Добавить(Новый Структура("Диск, Емкость, Занято, ИспользованоПроцент", лДискИмя, лДискЕмкость, лДискЗанято, лДискПроцентЗанят) , лДискИмя);
		
	КонецЦикла; 
	//3-7
	
	//Разбираем процессы
	//"Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName"
	//-- Handles: количество дескрипторов, открытых текущим процессом.
	//-- NPM(K): объем невыгружаемой памяти, используемой процессом, в КБ.
	//-- PM(K): объем выгружаемой памяти, используемой процессом, в КБ.
	//-- WS(K): размер рабочего множества процесса, в КБ. Рабочее множество состоит из страниц памяти, к которым недавно обращался процесс.
	//-- VM(M): объем виртуальной памяти, используемой процессом, в МБ. Виртуальная память представляет собой хранилище файлов подкачки на диске.
	//-- CPU(s): объем процессорного времени, потраченного на выполнение процесса всеми процессорами, в секундах.
	//-- ID: идентификатор процесса (PID).
	//-- ProcessName: имя процесса.
	
	лПроцессыИнфо 	= лРезультатПроцессы["ProcessesInfo"];
	лРезПроцессы 	= Новый Массив;
	Для каждого лЭлем Из лПроцессыИнфо Цикл
		
		лПроцесс 		= Новый Структура(
		"Handles, NPM, PM, WS, CPU, Id, SI, ProcessName, НачалоПроцесса", 
		лЭлем["Handles"], 
		лЭлем["NPM"], 
		лЭлем["PM"], 
		лЭлем["WS"], 
		лЭлем["CPU"],
		лЭлем["Id"],
		лЭлем["SI"], 
		лЭлем["ProcessName"],
		Дата(лЭлем["StartTimeFormat"])); 
		
		лРезПроцессы.Добавить(лПроцесс);
		
	КонецЦикла; 
	
	//Загрузка памяти
	лЗагрузкаПамяти 	= лРезультатПроцессы["TopMemoryUsageInfo"];
	лРезЗагрузкаПамяти 	= Новый Массив;
	Для каждого лЭлем Из лЗагрузкаПамяти Цикл
		
		лПамять 		= Новый Структура(
		"ID, ProcessName, MemUsage, UserName", 
		лЭлем["ProcessID"], 
		лЭлем["ProcessName"], 
		лЭлем["Mem Usage(MB)"], 
		лЭлем["UserID"]); 
		
		лРезЗагрузкаПамяти.Добавить(лПамять);
		
	КонецЦикла;
	
	//Сетевая активность
	лСетеваяАктивность 		= лРезультатПроцессы["NetworkInterfaceInfo"];
	лРезСетеваяАктивность 	= Новый Массив;
	Для каждого лЭлем Из лСетеваяАктивность Цикл
		
		лСеть 		= Новый Структура(
		"ID, Наименование, БайтОтправлено, БайтПринято", 
		лЭлем["Id"], 
		лЭлем["Name"], 
		лЭлем["NetworkInterfaceBytesSent"], 
		лЭлем["NetworkInterfaceBytesReceived"]); 
		
		лРезСетеваяАктивность.Добавить(лСеть);
		
	КонецЦикла;
	
	лРезЗагруженностьИтог 			= Новый Структура("Загруженность, WmiЗагруженность", лРезЗагруженность, лРезWmiЗагруженность);
	
	лПроизводительностьПроцессы 	= Новый Структура(
	"Период, Загруженность, МестоНаДисках, Процессы, КомпИнфо, СетеваяАктивность, ЗагрузкаПамяти", 
	лТекДата, лРезЗагруженностьИтог, лРезМестоНаДисках, лРезПроцессы, Неопределено, лРезСетеваяАктивность, лРезЗагрузкаПамяти);
	
	дОбщиеФункцииСервер.ЗаписатьПроизводительность(лПроизводительностьПроцессы);
	//ЗаписатьПроизводительность(лПроизводительностьПроцессы);
	
КонецПроцедуры

//Функция, из вида, "CpuLoadAverage=18" взять число 18 
//-------------------------------------------------------------------------
//Параметры:
//		пСтрокаРавенства 	- Строка 	- вида, "CpuLoadAverage=18"
//		пРазделитель 	- Строка 	- Строка разделитель названия и числа 
//Возвращаемое значение:
//		Число 	- описание
//-------------------------------------------------------------------------
//автор: КучеровРМ 16.07.2019 
Функция ПолучитьЗначениеИзСтрРазделить(пСтрокаРавенства, пРазделитель = "=") Экспорт
	
	лРезультат 	= Неопределено;
	
	лМассив 	= СтрРазделить(пСтрокаРавенства, пРазделитель, Ложь);
	
	Если лМассив.Количество() > 1 Тогда 
		лРезультат 	= Число(лМассив[1]);
	Иначе //Т.е. только наименование, а число видать равно 0
		лРезультат 	= 0;
	КонецЕсли; 
	
	Возврат лРезультат;
	
КонецФункции // ПолучитьЗначениеИзСтрРазделить()

Функция ПолучитьСкриптPowerShell_Процессы(ПутьКФайлу, пЧислоВыводимыхПроцессов = 5)
	
	//Script = "
	//|$CpuLogFile = '" + ПутьКФайлу + "'
	//|$DateTime = (Get-Date -Format ""dd.MM.yyyy HH:mm:ss"")
	//|#$DateTime >> $CpuLogFile
	//|#$DateTime
	//|
	//|$CpuLoadAverage = (Get-WmiObject win32_processor | Measure-Object -property LoadPercentage -Average | Select Average ).Average
	//|
	//|$ProcessorStats = Get-WmiObject win32_processor
	//|$ComputerCpu = $ProcessorStats.LoadPercentage
	//|# Lets create a re-usable WMI method for memory stats
	//|$OperatingSystem = Get-WmiObject win32_OperatingSystem
	//|# Lets grab the free memory
	//|$FreeMemory = $OperatingSystem.FreePhysicalMemory
	//|# Lets grab the total memory
	//|$TotalMemory = $OperatingSystem.TotalVisibleMemorySize
	//|# Lets do some math for percent
	//|$MemoryUsed = ($FreeMemory/ $TotalMemory) * 100
	//|$PercentMemoryUsed = $MemoryUsed
	//
	//|# usedDiskSpaceDrives
	//|$usedDiskSpaceDrives = ''
	//|$driveLetters = Get-WmiObject Win32_Volume | select DriveLetter
	//|foreach ($driveLetter in $driveLetters)
	//|{
	//|$drive = Get-WmiObject Win32_Volume | where {$_.DriveLetter -eq $driveLetter.DriveLetter}
	//|
	//|if (-Not $drive.Capacity -eq 0)
	//|{
	//|$driveCapacity = $drive.Capacity
	//|$usedDiskSpace = $driveCapacity - $drive.FreeSpace
	//|$usedDiskSpacePct = [math]::Round(($usedDiskSpace / $drive.Capacity) * 100,1)
	//|$usedDiskSpaceValues = '^driveCapacity=' + $driveCapacity +'^usedDiskSpace=' + $usedDiskSpace + '^usedDiskSpacePct=' + $usedDiskSpacePct
	//|#$usedDiskSpacePct = ""{0:N2}"" -f $usedDiskSpacePct
	//|
	//|
	//|$usedDiskSpaceDrives = $usedDiskSpaceDrives + '^driveCaption=' + $drive.Caption + '=' + $usedDiskSpaceValues + '#'
	//|}
	//|}
	//
	//|# Lets throw them into an object for outputting
	//|$objHostInfo = New-Object System.Object
	//|$objHostInfo | Add-Member -MemberType NoteProperty -Name Name -Value $computer
	//|$objHostInfo | Add-Member -MemberType NoteProperty -Name CPULoadPercent -Value $ComputerCpu
	//|$objHostInfo | Add-Member -MemberType NoteProperty -Name CpuLoadAverage -Value $CpuLoadAverage
	//|$objHostInfo | Add-Member -MemberType NoteProperty -Name MemoryUsedPercent -Value $PercentMemoryUsed
	//|$objHostInfo | Add-Member -MemberType NoteProperty -Name usedDiskSpaceDrives -Value $usedDiskSpaceDrives
	//
	//|$objHostInfoStr = 'ComputerCpu=' + $ComputerCpu + ';CpuLoadAverage=' + $CpuLoadAverage + ';PercentMemoryUsed=' + $PercentMemoryUsed + ';usedDiskSpaceDrives={' + $usedDiskSpaceDrives + '}'
	//|$objHostInfoStr >> $CpuLogFile
	//|#$objHostInfoStr
	//|# Lets dump our info into an array
	//|#$objHostInfo >> $CpuLogFile
	//
	//|#'CPU LoadPercentage Average|' + $CpuLoad >> $CpuLogFile
	//|$Process = Get-Process | Sort-Object CPU -desc | Select-Object -first " + пЧислоВыводимыхПроцессов + "
	//|$Process >> $CpuLogFile
	//|#$Process
	//|exit 1";
	
	Script = "
	|$CpuLogFile = '" + ПутьКФайлу + "'
	|$CpuLogFile
	|'CpuLogFile' >> $CpuLogFile
	|$computer 	= 'LocalHost'
	|$namespace 	= 'root\CIMV2'
	|
	|$DateTime = (Get-Date -Format 'dd.MM.yyyy HH:mm:ss')
	|$objLogInfo = New-Object System.Object
	|$objLogInfo | Add-Member -MemberType NoteProperty -Name DateTime -Value $DateTime
	|
	|$CpuLoadAverage = (Get-WmiObject win32_processor | Measure-Object -property LoadPercentage -Average | Select Average ).Average
	|
	|$ProcessorStats = Get-WmiObject win32_processor
	|$ComputerCpu = $ProcessorStats.LoadPercentage
	|$ComputerCpu = $ComputerCpu
	|# Lets create a re-usable WMI method for memory stats
	|$OperatingSystem = Get-WmiObject win32_OperatingSystem
	|# Lets grab the free memory
	|$FreeMemory = $OperatingSystem.FreePhysicalMemory
	|# Lets grab the total memory
	|$TotalMemory = $OperatingSystem.TotalVisibleMemorySize
	|# Lets do some math for percent
	|$MemoryUsed = ($FreeMemory/ $TotalMemory) * 100
	|$PercentMemoryUsed = $MemoryUsed
	|
	|$objHostInfo = New-Object System.Object
	|$objHostInfo | Add-Member -MemberType NoteProperty -Name Name -Value $computer
	|$objHostInfo | Add-Member -MemberType NoteProperty -Name CPULoadPercent -Value $ComputerCpu
	|$objHostInfo | Add-Member -MemberType NoteProperty -Name CpuLoadAverage -Value $CpuLoadAverage
	|$objHostInfo | Add-Member -MemberType NoteProperty -Name MemoryUsedPercent -Value $PercentMemoryUsed
	|
	|$usedDiskSpaceDrives = ''
	|$driveLetters = Get-WmiObject Win32_Volume | select DriveLetter
	|
	|$usedDiskSpaceList = new-object 'System.Collections.Generic.List[System.Object]'
	|
	|foreach ($driveLetter in $driveLetters)
	|{
	|	$drive = Get-WmiObject Win32_Volume | where {$_.DriveLetter -eq $driveLetter.DriveLetter}
	|	
	|	if (-Not $drive.Capacity -eq 0)
	|	{
	|		$driveCapacity = $drive.Capacity
	|		$usedDiskSpace = $driveCapacity - $drive.FreeSpace
	|		$usedDiskSpacePct = [math]::Round(($usedDiskSpace / $drive.Capacity) * 100,1)
	|		$usedDiskSpaceDrives = $usedDiskSpaceDrives + $drive.Caption + '=' + $usedDiskSpacePct + '#'
	|		
	|		$objUsedDiskSpace = New-Object System.Object
	|		$objUsedDiskSpace | Add-Member -MemberType NoteProperty -Name driveLetter -Value $drive.Caption
	|		$objUsedDiskSpace | Add-Member -MemberType NoteProperty -Name usedDiskSpace -Value $usedDiskSpace
	|		$objUsedDiskSpace | Add-Member -MemberType NoteProperty -Name usedDiskSpacePct -Value $usedDiskSpacePct
	|		$objUsedDiskSpace | Add-Member -MemberType NoteProperty -Name driveCapacity -Value $driveCapacity
	|		$objUsedDiskSpaceSO = $objUsedDiskSpace | Select-Object driveLetter, driveCapacity, usedDiskSpace, usedDiskSpacePct
	|		$objUsedDiskSpaceElem = @{driveLetter=$drive.Caption;driveCapacity=$driveCapacity;usedDiskSpace=$usedDiskSpace;usedDiskSpacePct=$usedDiskSpacePct}
	|		$usedDiskSpaceList.Add($objUsedDiskSpaceElem)
	|	}
	|}
	|
	|# Lets throw them into an object for outputting
	|$objHostInfo | Add-Member -MemberType NoteProperty -Name usedDiskSpaceDrives -Value $usedDiskSpaceList
	|
	|$objHostInfoStr = 'ComputerCpu=' + $ComputerCpu + ';CpuLoadAverage=' + $CpuLoadAverage + ';PercentMemoryUsed=' + $PercentMemoryUsed + ';usedDiskSpaceDrives={' + $usedDiskSpaceDrives + '}'
	|
	|$Processes = Get-Process | Sort-Object CPU -desc | Select-Object Name, Id, Path, Handles, NPM, PM, WS, CPU, SI, ProcessName, StartTime, @{Name='StartTimeFormat'; Expression={$_.StartTime.ToString('yyyyMMddHHmmss')}} -first 5
	|
	|$TopMemoryUsage = get-wmiobject WIN32_PROCESS | Sort-Object -Property ws -Descending|select -first 5|Select processname, @{Name='Mem Usage(MB)';Expression={[math]::round($_.ws / 1mb)}},@{Name='ProcessID';Expression={[String]$_.ProcessID}},@{Name='UserID';Expression={$_.getowner().user}}
	|
	|$NetworkInterfaces = [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces()
	|$NetworkInterfacesList = new-object 'System.Collections.Generic.List[System.Object]'
	|foreach ($NetworkInterface in $NetworkInterfaces)
	|{
	|	
	|	$NetworkInterfaceBytesSent = $NetworkInterface.GetIPv4Statistics().BytesSent
	|	$NetworkInterfaceBytesReceived = $NetworkInterface.GetIPv4Statistics().BytesReceived
	|	$NetworkInterfaceBytesTotal = $NetworkInterfaceBytesSent + $NetworkInterfaceBytesReceived
	|	if (-Not $NetworkInterfaceBytesTotal -eq 0)
	|	{
	|		$objNetworkInterfaceInfo = New-Object System.Object
	|		$objNetworkInterfaceInfo | Add-Member -MemberType NoteProperty -Name Id -Value $NetworkInterface.Id
	|		$objNetworkInterfaceInfo | Add-Member -MemberType NoteProperty -Name Name -Value $NetworkInterface.Name
	|		$objNetworkInterfaceInfo | Add-Member -MemberType NoteProperty -Name NetworkInterfaceBytesSent -Value $NetworkInterfaceBytesSent
	|		$objNetworkInterfaceInfo | Add-Member -MemberType NoteProperty -Name NetworkInterfaceBytesReceived -Value $NetworkInterfaceBytesReceived
	|
	|		$objNetworkInterfaceInfo = $objNetworkInterfaceInfo | Select-Object Id, Name, NetworkInterfaceBytesSent, NetworkInterfaceBytesReceived
	|		$NetworkInterfacesList.Add($objNetworkInterfaceInfo)
	|	}
	|}
	|
	|$ProduceLog = @{LogInfo=$objLogInfo;HostInfo=$objHostInfo;ProcessesInfo=$Processes;TopMemoryUsageInfo=$TopMemoryUsage;NetworkInterfaceInfo=$NetworkInterfacesList}
	|$ProduceLog | ConvertTo-Json -Depth 4 | Out-File $CpuLogFile
	|exit 1";
	
	Возврат Script;
	
КонецФункции // ПолучитьСкриптPowerShell_Процессы()

Процедура СоздатьСоСсылкойНаВыбраннуюЗапись(пСсылка) Экспорт
	
	СписокТекущиеДанныеСсылка 	= пСсылка;
	
	ФормаОбъекта    = ПолучитьФорму("Документ.дДневник.Форма.ФормаДокумента");
	ДанныеФормы     = ФормаОбъекта.Объект;
	
	дОбщиеФункцииСервер.СоздатьДокументСоСсылкой(ДанныеФормы, СписокТекущиеДанныеСсылка);
	
	КопироватьДанныеФормы(ДанныеФормы, ФормаОбъекта.Объект);
	
	ФормаОбъекта.Открыть();

КонецПроцедуры

//Шифрование через архив в паролем
Функция ПолучитьЗашифрованныеДанныеBase64(ДанныеШифрования,КлючШифрования,ИдентификаторДанных = "0") Экспорт
    
    Попытка
        
        Путь = КаталогВременныхФайлов()+"\"+ИдентификаторДанных;
        ПутьФайла = Путь+".txt";
        ПутьАрхива = Путь+".zip";
        ЗаписьТекста = Новый ЗаписьТекста(ПутьФайла);
        ЗаписьТекста.Записать(ДанныеШифрования);
        ЗаписьТекста.Закрыть();
        ЗаписьАрхива = Новый ЗаписьZipФайла(ПутьАрхива,КлючШифрования,,,,МетодШифрованияZIP.AES256);
        ЗаписьАрхива.Добавить(ПутьФайла);
        ЗаписьАрхива.Записать();
        ДвоичныеДанные = Новый ДвоичныеДанные(ПутьАрхива);
        ХранилищеДанных = Base64Строка(ДвоичныеДанные);
        УдалитьФайлы(ПутьФайла);
        УдалитьФайлы(ПутьАрхива);
        Возврат ХранилищеДанных;
        
    Исключение
        Возврат Неопределено;
    КонецПопытки; 

КонецФункции

Функция ПолучитьЗашифрованныеДанные(ДанныеШифрования,КлючШифрования,ИдентификаторДанных = "0") Экспорт
    
	//Попытка
	//    
	//    Путь = КаталогВременныхФайлов()+"\"+ИдентификаторДанных;
	//    ПутьФайла = Путь+".txt";
	//    ПутьАрхива = Путь+".zip";
	//    ЗаписьТекста = Новый ЗаписьТекста(ПутьФайла);
	//    ЗаписьТекста.Записать(ДанныеШифрования);
	//    ЗаписьТекста.Закрыть();
	//    ЗаписьАрхива = Новый ЗаписьZipФайла(ПутьАрхива,КлючШифрования,,,,МетодШифрованияZIP.AES256);
	//    ЗаписьАрхива.Добавить(ПутьФайла);
	//    ЗаписьАрхива.Записать();
	//    ДвоичныеДанные = Новый ДвоичныеДанные(ПутьАрхива);
	//    ХранилищеДанных = Новый ХранилищеЗначения(ДвоичныеДанные,Новый СжатиеДанных(9));
	//    УдалитьФайлы(ПутьФайла);
	//    УдалитьФайлы(ПутьАрхива);
	//    Возврат ХранилищеДанных;
	//    
	//Исключение
	//    Возврат Неопределено;
	//КонецПопытки; 

КонецФункции

Функция ПолучитьРасшифрованныеДанныеBase64(Base64СтрокаДанных,КлючШифрования,ИдентификаторДанных = "0") Экспорт
    
    Попытка
        КаталогСохранения = КаталогВременныхФайлов();
        Путь = КаталогСохранения+"\"+ИдентификаторДанных;
        ПутьАрхива = Путь+".zip";
		//ХранилищеДанных.Получить().Записать(ПутьАрхива);
		Base64Значение(Base64СтрокаДанных).Записать(ПутьАрхива);
        ЧтениеАрхива = Новый ЧтениеZipФайла(ПутьАрхива,КлючШифрования);
        ЭлементАрхива = ЧтениеАрхива.Элементы[0];
        ЧтениеАрхива.Извлечь(ЭлементАрхива,КаталогСохранения);
        ЧтениеАрхива.Закрыть();
        ПутьФайла = КаталогСохранения+"\"+ЭлементАрхива.Имя;
        ЧтениеТекста = Новый ЧтениеТекста(ПутьФайла);
        Данные = ЧтениеТекста.Прочитать();
        ЧтениеТекста.Закрыть();
        УдалитьФайлы(ПутьАрхива);
        УдалитьФайлы(ПутьФайла);
        Возврат Данные;
        
    Исключение
        Возврат Неопределено;
    КонецПопытки; 

КонецФункции

Функция ПолучитьРасшифрованныеДанные(ХранилищеДанных,КлючШифрования,ИдентификаторДанных = "0") Экспорт
    
    Попытка
        КаталогСохранения = КаталогВременныхФайлов();
        Путь = КаталогСохранения+"\"+ИдентификаторДанных;
        ПутьАрхива = Путь+".zip";
        ХранилищеДанных.Получить().Записать(ПутьАрхива);
        ЧтениеАрхива = Новый ЧтениеZipФайла(ПутьАрхива,КлючШифрования);
        ЭлементАрхива = ЧтениеАрхива.Элементы[0];
        ЧтениеАрхива.Извлечь(ЭлементАрхива,КаталогСохранения);
        ЧтениеАрхива.Закрыть();
        ПутьФайла = КаталогСохранения+"\"+ЭлементАрхива.Имя;
        ЧтениеТекста = Новый ЧтениеТекста(ПутьФайла);
        Данные = ЧтениеТекста.Прочитать();
        ЧтениеТекста.Закрыть();
        УдалитьФайлы(ПутьАрхива);
        УдалитьФайлы(ПутьФайла);
        Возврат Данные;
        
    Исключение
        Возврат Неопределено;
    КонецПопытки; 

КонецФункции

Функция КодироватьСтрокуBase64(пОбычнаяСтрока)
	
	СтрокаКодирования 	= пОбычнаяСтрока;
	
	ПотокВПамяти 	= Новый ПотокВПамяти();
	ЗаписьДанных 	= Новый ЗаписьДанных(ПотокВПамяти);
	ЗаписьДанных.ЗаписатьСтроку(СтрокаКодирования);
	
	ДД 				= ПотокВпамяти.ЗакрытьИПолучитьДвоичныеДанные();
	лРезультат 		= Base64Строка(ДД);
	
	Возврат лРезультат;
	
КонецФункции // КодироватьСтрокуBase64
 
Функция ДекодироватьСтрокуBase64(пСтрокаBase64)
	
	ДД1 			= Base64Значение(пСтрокаBase64);
	ЧтениеДанных 	= Новый ЧтениеДанных(ДД1);
	СтрокаРаскодированная 	= ЧтениеДанных.ПрочитатьСтроку();
	ЧтениеДанных.Закрыть();
	
	лРезультат = СтрокаРаскодированная;
	
	Возврат лРезультат;
	
КонецФункции // ДекодироватьСтрокуBase64
