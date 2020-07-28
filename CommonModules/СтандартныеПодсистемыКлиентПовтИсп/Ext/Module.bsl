﻿#Область СлужебныеПроцедурыИФункции

Функция ТекущийБраузер()
	
	Результат = Новый Структура("Название,Версия", "Другой", "");
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Строка = СистемнаяИнформация.ИнформацияПрограммыПросмотра;
	Строка = СтрЗаменить(Строка, ",", ";");

	// Opera
	Идентификатор = "Opera";
	Позиция = СтрНайти(Строка, Идентификатор, НаправлениеПоиска.СКонца);
	Если Позиция > 0 Тогда
		Строка = Сред(Строка, Позиция + СтрДлина(Идентификатор));
		Результат.Название = "Opera";
		Идентификатор = "Version/";
		Позиция = СтрНайти(Строка, Идентификатор);
		Если Позиция > 0 Тогда
			Строка = Сред(Строка, Позиция + СтрДлина(Идентификатор));
			Результат.Версия = СокрЛП(Строка);
		Иначе
			Строка = СокрЛП(Строка);
			Если СтрНачинаетсяС(Строка, "/") Тогда
				Строка = Сред(Строка, 2);
			КонецЕсли;
			Результат.Версия = СокрЛ(Строка);
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;

	// IE
	Идентификатор = "MSIE"; // v11-
	Позиция = СтрНайти(Строка, Идентификатор);
	Если Позиция > 0 Тогда
		Результат.Название = "IE";
		Строка = Сред(Строка, Позиция + СтрДлина(Идентификатор));
		Позиция = СтрНайти(Строка, ";");
		Если Позиция > 0 Тогда
			Строка = СокрЛ(Лев(Строка, Позиция - 1));
			Результат.Версия = Строка;
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;

	Идентификатор = "Trident"; // v11+
	Позиция = СтрНайти(Строка, Идентификатор);
	Если Позиция > 0 Тогда
		Результат.Название = "IE";
		Строка = Сред(Строка, Позиция + СтрДлина(Идентификатор));
		
		Идентификатор = "rv:";
		Позиция = СтрНайти(Строка, Идентификатор);
		Если Позиция > 0 Тогда
			Строка = Сред(Строка, Позиция + СтрДлина(Идентификатор));
			Позиция = СтрНайти(Строка, ")");
			Если Позиция > 0 Тогда
				Строка = СокрЛ(Лев(Строка, Позиция - 1));
				Результат.Версия = Строка;
			КонецЕсли;
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;

	// Chrome
	Идентификатор = "Chrome/";
	Позиция = СтрНайти(Строка, Идентификатор);
	Если Позиция > 0 Тогда
		Результат.Название = "Chrome";
		Строка = Сред(Строка, Позиция + СтрДлина(Идентификатор));
		Позиция = СтрНайти(Строка, " ");
		Если Позиция > 0 Тогда
			Строка = СокрЛ(Лев(Строка, Позиция - 1));
			Результат.Версия = Строка;
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;

	// Safari
	Идентификатор = "Safari/";
	Если СтрНайти(Строка, Идентификатор) > 0 Тогда
		Результат.Название = "Safari";
		Идентификатор = "Version/";
		Позиция = СтрНайти(Строка, Идентификатор);
		Если Позиция > 0 Тогда
			Строка = Сред(Строка, Позиция + СтрДлина(Идентификатор));
			Позиция = СтрНайти(Строка, " ");
			Если Позиция > 0 Тогда
				Результат.Версия = СокрЛП(Лев(Строка, Позиция - 1));
			КонецЕсли;
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;

	// Firefox
	Идентификатор = "Firefox/";
	Позиция = СтрНайти(Строка, Идентификатор);
	Если Позиция > 0 Тогда
		Результат.Название = "Firefox";
		Строка = Сред(Строка, Позиция + СтрДлина(Идентификатор));
		Если Не ПустаяСтрока(Строка) Тогда
			Результат.Версия = СокрЛП(Строка);
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// См. СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске().
Функция ПараметрыРаботыКлиентаПриЗапуске() Экспорт
	
	ПроверитьПорядокЗапускаПрограммыПередНачаломРаботыСистемы();
	
	ПараметрыПриЗапускеПрограммы = ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыПриЗапускеПрограммы"];
	
	Параметры = Новый Структура;
	Параметры.Вставить("ПолученныеПараметрыКлиента", Неопределено);
	
	Если ПараметрыПриЗапускеПрограммы.Свойство("ПолученныеПараметрыКлиента")
	   И ТипЗнч(ПараметрыПриЗапускеПрограммы.ПолученныеПараметрыКлиента) = Тип("Структура") Тогда
		
		Параметры.Вставить("ПолученныеПараметрыКлиента",
			ПараметрыПриЗапускеПрограммы.ПолученныеПараметрыКлиента);
	КонецЕсли;
	
	Если ПараметрыПриЗапускеПрограммы.Свойство("ПропуститьОчисткуСкрытияРабочегоСтола") Тогда
		Параметры.Вставить("ПропуститьОчисткуСкрытияРабочегоСтола");
	КонецЕсли;
	
	#Если ВебКлиент Тогда
		ЭтоВебКлиент = Истина;
		КаталогПрограммы = "";
	#Иначе
		ЭтоВебКлиент = Ложь;
		КаталогПрограммы = КаталогПрограммы();
	#КонецЕсли
	
	ИспользуемыйКлиент = "";
	#Если ТонкийКлиент Тогда
		ИспользуемыйКлиент = "ТонкийКлиент";
	#ИначеЕсли ТолстыйКлиентУправляемоеПриложение Тогда
		ИспользуемыйКлиент = "ТолстыйКлиентУправляемоеПриложение";
	#ИначеЕсли ТолстыйКлиентОбычноеПриложение Тогда
		ИспользуемыйКлиент = "ТолстыйКлиентОбычноеПриложение";
	#ИначеЕсли ВебКлиент Тогда
		ОписаниеБраузера = ТекущийБраузер();
		Если ПустаяСтрока(ОписаниеБраузера.Версия) Тогда
			ИспользуемыйКлиент = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ВебКлиент.%1", ОписаниеБраузера.Название);
		Иначе
			ИспользуемыйКлиент = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ВебКлиент.%1.%2", ОписаниеБраузера.Название, СтрРазделить(ОписаниеБраузера.Версия, ".")[0]);
		КонецЕсли;
	#КонецЕсли
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ЭтоLinuxКлиент = СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86
		Или СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86_64;
	ЭтоOSXКлиент = СистемнаяИнформация.ТипПлатформы = ТипПлатформы.MacOS_x86
		Или СистемнаяИнформация.ТипПлатформы = ТипПлатформы.MacOS_x86_64;
	ЭтоWindowsКлиент = СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86
		Или СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86_64;
	
	Параметры.Вставить("ПараметрЗапуска",      ПараметрЗапуска);
	Параметры.Вставить("СтрокаСоединенияИнформационнойБазы", СтрокаСоединенияИнформационнойБазы());
	Параметры.Вставить("ЭтоВебКлиент",         ЭтоВебКлиент);
	Параметры.Вставить("ЭтоВебКлиентПодMacOS", ОбщегоНазначенияКлиентПовтИсп.ЭтоВебКлиентПодMacOS());
	Параметры.Вставить("ЭтоLinuxКлиент",       ЭтоLinuxКлиент);
	Параметры.Вставить("ЭтоOSXКлиент",         ЭтоOSXКлиент);
	Параметры.Вставить("ЭтоWindowsКлиент",     ЭтоWindowsКлиент);
	Параметры.Вставить("ИспользуемыйКлиент",   ИспользуемыйКлиент);
	Параметры.Вставить("КаталогПрограммы",     КаталогПрограммы);
	Параметры.Вставить("ИдентификаторКлиента", СистемнаяИнформация.ИдентификаторКлиента);
	Параметры.Вставить("СкрытьРабочийСтолПриНачалеРаботыСистемы", Ложь);
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ОперативнаяПамять = Окр(СистемнаяИнформация.ОперативнаяПамять / 1024, 1);
	Параметры.Вставить("ОперативнаяПамять", ОперативнаяПамять);
	
	// Установка даты клиента непосредственно перед вызовом, чтобы уменьшить погрешность.
	Параметры.Вставить("ТекущаяДатаНаКлиенте", ТекущаяДата()); // Для расчета ПоправкаКВремениСеанса.
	Параметры.Вставить("ТекущаяУниверсальнаяДатаВМиллисекундахНаКлиенте",
		ТекущаяУниверсальнаяДатаВМиллисекундах());
	
	ПараметрыКлиента = СтандартныеПодсистемыВызовСервера.ПараметрыРаботыКлиентаПриЗапуске(Параметры);
	
	Если ПараметрыПриЗапускеПрограммы.Свойство("ПолученныеПараметрыКлиента")
	   И ПараметрыПриЗапускеПрограммы.ПолученныеПараметрыКлиента <> Неопределено
	   И Не ПараметрыПриЗапускеПрограммы.Свойство("ОпцииИнтерфейса") Тогда
		
		ПараметрыПриЗапускеПрограммы.Вставить("ОпцииИнтерфейса", ПараметрыКлиента.ОпцииИнтерфейса);
		ПараметрыПриЗапускеПрограммы.ПолученныеПараметрыКлиента.Вставить("ОпцииИнтерфейса");
	КонецЕсли;
	
	СтандартныеПодсистемыКлиент.ЗаполнитьПараметрыКлиента(ПараметрыКлиента);
	
	// Обновление состояния скрытия рабочего стола на клиенте по состоянию на сервере.
	СтандартныеПодсистемыКлиент.СкрытьРабочийСтолПриНачалеРаботыСистемы(
		Параметры.СкрытьРабочийСтолПриНачалеРаботыСистемы, Истина);
	
	Возврат ПараметрыКлиента;
	
КонецФункции

// См. СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().
Функция ПараметрыРаботыКлиента() Экспорт
	
	ПроверитьПорядокЗапускаПрограммыПередНачаломРаботыСистемы();
	ПараметрыПриложения["СтандартныеПодсистемы.ЗапускПрограммыЗавершен"] = Истина; //+++
	ПроверитьПорядокЗапускаПрограммыПриНачалеРаботыСистемы();
	
	СвойстваКлиента = Новый Структура;
	
	// Установка даты клиента непосредственно перед вызовом, чтобы уменьшить погрешность.
	СвойстваКлиента.Вставить("ТекущаяДатаНаКлиенте", ТекущаяДата()); // Для расчета ПоправкаКВремениСеанса.
	СвойстваКлиента.Вставить("ТекущаяУниверсальнаяДатаВМиллисекундахНаКлиенте",
		ТекущаяУниверсальнаяДатаВМиллисекундах());
	
	Возврат СтандартныеПодсистемыВызовСервера.ПараметрыРаботыКлиента(СвойстваКлиента);
	
КонецФункции

Процедура ПроверитьПорядокЗапускаПрограммыПередНачаломРаботыСистемы()
	
	ИмяПараметра = "СтандартныеПодсистемы.ЗапускПрограммыЗавершен";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ВызватьИсключение
			НСтр("ru = 'Ошибка порядка запуска программы.
			           |Первой процедурой, которая вызывается из обработчика события ПередНачаломРаботыСистемы
			           |должна быть процедура БСП СтандартныеПодсистемыКлиент.ПередНачаломРаботыСистемы.'");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьПорядокЗапускаПрограммыПриНачалеРаботыСистемы()
	
	Если Не СтандартныеПодсистемыКлиент.ЗапускПрограммыЗавершен() Тогда 
		ВызватьИсключение
			НСтр("ru = 'Ошибка порядка запуска программы.
			           |Перед получением параметров работы клиента запуск программы должен быть завершен.'");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с предопределенными данными.

// См. СтандартныеПодсистемыПовтИсп.СсылкиПоИменамПредопределенных
Функция СсылкиПоИменамПредопределенных(ПолноеИмяОбъектаМетаданных) Экспорт
	
	Возврат СтандартныеПодсистемыВызовСервера.СсылкиПоИменамПредопределенных(ПолноеИмяОбъектаМетаданных);
	
КонецФункции

#КонецОбласти
