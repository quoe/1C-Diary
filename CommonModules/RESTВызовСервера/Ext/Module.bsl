﻿////////////////////////////////////////////////////////////////////////////////
// RESTВызовСервера
//	Серверный функционал для обслуживания REST-API облачных сервисов
//
//
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс


#Область НастройкиОблачныхПровайдеров

#Область ОписаниеОбласти
// Настройки провайдеров хранятся в безопасном хранилище. 
//	"Владельцем" записей является ИдентификаторОбъектаМетаданных("Справочник.ТранспортыОбменаДанными")
//	"Ключ" записи соответствует имени пользователя или строке "ВсеПользователи".
// Для каждого провайдера к ключу добавляется строковое представление провайдера, например, "ВсеПользователиDropbox"
// Настройки провайдера, выбранного пользователем в качестве основного, дублируются записью с ключем без указания провайдера
// Например, настройки с ключем "ВсеПользователи" будут относиться к провайдеру, заданному как основной для всех пользователей,
// они же будут продублированы в записи с ключем "ВсеПользователиDropbox"
#КонецОбласти 

// Очищает и удаляет параметры настроек REST-авторизации
//
// Параметры:
//  ПараметрыНастроек - Структура - результат функции НовыеКлючиДляЗаписиНастроек() для записи настроек в безопасное хранилище
//
Процедура ОчиститьПараметрыREST(ПараметрыНастроек = Неопределено) Экспорт
	
	Если ПараметрыНастроек = Неопределено Тогда
		ПараметрыНастроек = НовыеКлючиДляЗаписиНастроек();
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(ПараметрыНастроек.Владелец, ПараметрыНастроек.Ключ);
	
	ОбновитьПараметрСеанса(НоваяСтруктураПараметровREST());
	
КонецПроцедуры

// Записывает в защищенное хранилище настройки аккаунта и, при необходимости, обновляет значение параметра сеанса
//
//Параметры:
//	СвойстваАккаунта     - Структура - логин и токен доступа к серверу провайдера (см. RESTВызовСервера.НоваяСтруктураПараметровREST())
//
Процедура ОбновитьСвойстваАккаунта(СвойстваАккаунта) Экспорт
	
	Если ТипЗнч(СвойстваАккаунта) <> Тип("Структура") Тогда
		ВызватьИсключение "В обновление свойств аккаунта переданы некорректные параметры";
	КонецЕсли;
	
	Если СвойстваАккаунта.Провайдер = ПровайдерИзПараметраСеанса() Тогда
		СохранитьПараметрыREST(Истина);
	Иначе
		ЗаписатьНастройкиАккаунтаВБезопасномХранилище(СвойстваАккаунта);
	КонецЕсли;
	
КонецПроцедуры

// Сохраняет в безопасном хранилище параметры авторизации REST, заданные в параметре сеанса
//		при этом сохраняются настройки с ключем без указания провайдера и , если задано, настройки с ключем провайдера,
//		указанного в параметре сеанса
//
// Параметры:
//	ОбновитьНастройкиПровайдера - Булево - нужно ли перезаписывать настройки, сделанные для указанного провайдера
//
Процедура СохранитьПараметрыREST(ОбновитьНастройкиПровайдера = Истина) Экспорт	
	
	ТекущиеПараметры = НастройкиАккаунтаИзПараметровСеанса();
	
	// Сохраняем настройки по умолчанию
	КлючиЗаписи = НовыеКлючиДляЗаписиНастроек(Неопределено);
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(КлючиЗаписи.Владелец, ТекущиеПараметры, КлючиЗаписи.Ключ);
	
	Если ОбновитьНастройкиПровайдера И ЗначениеЗаполнено(ТекущиеПараметры.Провайдер) Тогда
		// Сохраняем настройки для конкретного провайдера, чтобы можно было восстановить при переключении провайдера
		ЗаписатьНастройкиАккаунтаВБезопасномХранилище(ТекущиеПараметры, КлючиЗаписи.Ключ);
	КонецЕсли;
	
КонецПроцедуры

// Восстанавливает параметры авторизации REST из настроек пользователя и иницализирует соответсвующий параметр сеанса
//
// Параметры:
//	Провайдер - ПеречислениеСсылка.ТипыПровайдеровREST - Провайдер облачного сервиса (не обязательно). 
//				Если не указан, считываются парамеетры прошлой успешной авторизации
// 
// Возвращаемое значение:
//  Булево - Истина, если настройки были успешно восстановлены
//
Процедура ВосстановитьПараметрыREST(Провайдер = Неопределено) Экспорт
	
	ОбновитьПараметрСеанса(НастройкиАккаунтаИзБезопасногоХранилища(Провайдер));
	
КонецПроцедуры

// Возвращает структуру (обычную) из параметра сеанса АвторизацияREST или НоваяСтруктураПараметровREST(), если параметр сеанса не заполнен
Функция НастройкиАккаунтаИзПараметровСеанса() Экспорт

	ТекущееЗначение = ПараметрыСеанса.АвторизацияREST;
	Результат = НоваяСтруктураПараметровREST();
	
	Если ТипЗнч(ТекущееЗначение) = Тип("ФиксированнаяСтруктура") Тогда
		ЗаполнитьЗначенияСвойств(Результат, ТекущееЗначение);
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

// Возвращает ключ доступа (токен) для указанного провайдера
//		Если провайдер в параметре не задан, будет возвращен токен для провайдера, заданного в параметре сеанса
//		Если не провайдер по умолчанию не задан, будет возврашено Неопределено
//
//Параметры:
//	Провайдер - ПеречислениеСсылка.ТипыПровайдеровREST - Провайдер облачного сервиса. 
//				Если не задан, будет использован токен из параметра сеанса
//	НастройкиАккаунта - произвольный - возвращаемый параметр, который будет заполнен (или перезаполнен) текущим значением 
//						параметра сеанса "АвторизацияREST"
//
//Возвращаемое значение:
//	Строка или Неопределено
//
Функция КлючДоступаПровайдера(Провайдер = Неопределено, НастройкиАккаунта = Неопределено) Экспорт

	Результат = Неопределено;
	
	НастройкиАккаунта = НастройкиАккаунтаИзПараметровСеанса();
	Если Провайдер = Неопределено Или Провайдер = НастройкиАккаунта.Провайдер Тогда
		Результат = НастройкиАккаунта.КлючАвторизации;
		Провайдер = НастройкиАккаунта.Провайдер;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Результат) И ЗначениеЗаполнено(Провайдер) Тогда
		НастройкиАккаунта = НастройкиАккаунтаИзБезопасногоХранилища(Провайдер);
		Результат = НастройкиАккаунта.КлючАвторизации;
	КонецЕсли;
	
	Возврат ?(ЗначениеЗаполнено(Результат), Результат, Неопределено);

КонецФункции

// Возвращает провайдера, назначенного основным (сохраненного в параметре сеанса)
//
//Параметры:
//	НастройкиАккаунта - произвольный - возвращаемый параметр, который будет заполнен (или перезаполнен) текущим значением 
//						параметра сеанса "АвторизацияREST"
//
//Возвращаемое значение:
//	ПеречислениеСсылка.ТипыПровайдеровREST или Неопределено 
//
Функция ПровайдерИзПараметраСеанса(СвойствоАккаунта = Неопределено) Экспорт

	СвойствоАккаунта = НастройкиАккаунтаИзПараметровСеанса();
	Если СвойствоАккаунта <> Неопределено Тогда
		Возврат СвойствоАккаунта.Провайдер;
	КонецЕсли;
	
	Возврат Неопределено;

КонецФункции

// Возвращает настройки указанного провайдера, сохраненные в безопасном хранилище пользователя
//		Если провайдер в параметре не задан, будут возвращены настройки, записанные для пустого провайдера (настройки по умолчанию)
//
//Параметры:
//	Провайдер - ПеречислениеСсылка.ТипыПровайдеровREST - Провайдер облачного сервиса. 
//
//Возвращаемое значение:
//	Структура (см. НоваяСтруктураПараметровREST()) или Неопределено
//
Функция НастройкиАккаунтаИзБезопасногоХранилища(Провайдер) Экспорт

	КлючиНастроек        = НовыеКлючиДляЗаписиНастроек(Провайдер);
	СохраненныеПараметры = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(КлючиНастроек.Владелец, КлючиНастроек.Ключ);
	
	ПараметрыREST = НоваяСтруктураПараметровREST();
	Если ТипЗнч(СохраненныеПараметры) = Тип("Структура") Или ТипЗнч(СохраненныеПараметры) = Тип("ФиксированнаяСтруктура") Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыREST, СохраненныеПараметры);
	Иначе
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(КлючиНастроек.Владелец, ПараметрыREST, КлючиНастроек.Ключ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Провайдер) Тогда
		ПараметрыREST.Провайдер = Провайдер;
	КонецЕсли;
	
	Возврат ПараметрыREST;

КонецФункции

// Возвращает настройки указанного провайдера, сохраненные в безопасном хранилище пользователя
//		Если провайдер в параметре не задан, будут возвращены настройки, записанные для пустого провайдера (настройки по умолчанию)
//
//Параметры:
//	Провайдер - ПеречислениеСсылка.ТипыПровайдеровREST - Провайдер облачного сервиса. 
//
//Возвращаемое значение:
//	Структура (см. НоваяСтруктураПараметровREST()) или Неопределено
//
Процедура ЗаписатьНастройкиАккаунтаВБезопасномХранилище(НастройкиАккаунта, Пользователь = Неопределено) Экспорт

	КлючиЗаписи        = НовыеКлючиДляЗаписиНастроек(НастройкиАккаунта.Провайдер, Пользователь);
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(КлючиЗаписи.Владелец, НастройкиАккаунта, КлючиЗаписи.Ключ);

КонецПроцедуры

// Возвращает дополнительный параметр настроек обмена для указанного провайдера в безопасное хранилище
//	Например, записывает значение токена восстановления для Google Drive
//
//Параметры:
//	Провайдер - ПеречислениеСсылка.ТипыПровайдеровREST - Провайдер облачного сервиса. 
//	ИмяПараметра - Строка - имя дополнительного параметра
//	ЗначениеПоУмолчанию - Произвольное - значение дополнительного параметра, которое будет возвращено в случае отсутствия записанного значения
//
//Возвращаемое значение:
//	Произвольное - считанное из регистра значение или значение по умолчанию
//
Функция ДополнительныйПараметрНастройки(Провайдер, ИмяПараметра, ЗначениеПоУмолчанию = Неопределено) Экспорт

	КлючиЗаписи        = НовыеКлючиДляЗаписиНастроек(Провайдер, Неопределено);
	Значение = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(КлючиЗаписи.Владелец, КлючиЗаписи.Ключ + "_" + ИмяПараметра);
	Если Значение = Неопределено Тогда
		Значение = ЗначениеПоУмолчанию;
	КонецЕсли;
	
	Возврат Значение;

КонецФункции

// Записывает дополнительный параметр настроек обмена для указанного провайдера в безопасное хранилище
//	Например, записывает значение токена восстановления для Google Drive
//
//Параметры:
//	Провайдер - ПеречислениеСсылка.ТипыПровайдеровREST - Провайдер облачного сервиса. 
//	ИмяПараметра - Строка - имя дополнительного параметра
//	ЗначениеПараметра - Произвольное - значение дополнительного параметра
//
//
Процедура ЗаписатьДополнительныйПараметрНастройки(Провайдер, ИмяПараметра, ЗначениеПараметра) Экспорт

	КлючиЗаписи        = НовыеКлючиДляЗаписиНастроек(Провайдер, Неопределено);
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(КлючиЗаписи.Владелец, ЗначениеПараметра, КлючиЗаписи.Ключ + "_" + ИмяПараметра);

КонецПроцедуры


// Изменяет значение провайдера по умолчанию:
//	- из безопасного хранилища считываются настройки нового провайдера (если нет - заполняются по умолчанию)
//	- настройками нового провайдера заполняется параметр сеанса
//	- изменения сохраняются в 
//
//Параметры:
//	НовыйПровайдер - ПеречислениеСсылка.ТипыПровайдеровREST - Провайдер облачного сервиса. 
//
Процедура ПереключитьПровайдера(НовыйПровайдер) Экспорт
	
	ВосстановитьПараметрыREST(НовыйПровайдер);
	
КонецПроцедуры


#КонецОбласти



#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

// Возвращает структуру параметров REST для параметра сеанса
// 
// Возвращаемое значение:
//  Структура - данные о текущем состоянии REST
//
Функция НоваяСтруктураПараметровREST() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("КлючАвторизации", ""); // токен доступа
	Результат.Вставить("Провайдер", Неопределено);
	Результат.Вставить("ПредставлениеАккаунта", ""); // логин или e-mail
	Результат.Вставить("ИДАккаунта", ""); // идентификатор аккаунта (не у всех провайдеров!)
	
	Возврат Результат;
	
КонецФункции	

// Обновляет значение параметра сеанса АвторизацияREST
//	
//Параметры
//	СвойстваАккаунта - Структура, см. НоваяСтруктураПараметровREST()
//
Процедура ОбновитьПараметрСеанса(СвойстваАккаунта) Экспорт
	
	ПараметрыСеанса.АвторизацияREST = Новый ФиксированнаяСтруктура(СвойстваАккаунта);
	
КонецПроцедуры

// Получает настройки прокси сервера
//
Функция ПользовательскиеНастройкиПроксиСервера() Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
		
		МодульПолучениеФайловИзИнтернета = ОбщегоНазначения.ОбщийМодуль("ПолучениеФайловИзИнтернета");
		НастройкаПроксиСервера = МодульПолучениеФайловИзИнтернета.НастройкиПроксиНаСервере();
		
	Иначе
		
		НастройкаПроксиСервера = Неопределено;
		
	КонецЕсли;
	
	Возврат НастройкаПроксиСервера;
	
КонецФункции

// Добавляет в журнал регистрации запись об ошибке, сформулированной из структуры результата
//
//Параметры:
//	СтруктураОтвета - Структура - см. RESTКлиентСервер.НоваяСтруктураОтвета()
//
Процедура ОтметитьОшибкуВЖурналеРегистрации(СтруктураОтвета, ОбъектМетаданных = Неопределено, Данные = Неопределено) Экспорт
	
	Если ТипЗнч(СтруктураОтвета) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(СтруктураОтвета.ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, ОбъектМетаданных, Данные, 
				?(СтруктураОтвета.КодСостояния > 0, Строка(СтруктураОтвета.КодСостояния) + ": ", "") 
				+ СтруктураОтвета.ОписаниеОшибки);
	
КонецПроцедуры

// Кодирует строуку с параметром КодировкаURL
//
//Параметры:
//	Строка - Строка - кодируемая строка
//
//Возвращаемое значение:
//	Строка
//
Функция КодироватьСтрокуКакURL(Строка) Экспорт

	Возврат КодироватьСтроку(Строка, СпособКодированияСтроки.КодировкаURL);

КонецФункции

// Кодирует строуку с параметром URLВКодировкеURL 
//
//Параметры:
//	Строка - Строка - кодируемая строка
//
//Возвращаемое значение:
//	Строка
//
Функция КодироватьURLКакURL(Строка) Экспорт

	Возврат КодироватьСтроку(Строка, СпособКодированияСтроки.URLВКодировкеURL);

КонецФункции

// Кодирует строуку с параметром КодировкаURL
//
//Параметры:
//	Строка - Строка - кодируемая строка
//
//Возвращаемое значение:
//	Строка
//
Функция РаскодироватьСтрокуИзURL(Строка) Экспорт

	Возврат РаскодироватьСтроку(Строка, СпособКодированияСтроки.КодировкаURL);

КонецФункции

// Кодирует строуку с параметром URLВКодировкеURL 
//
//Параметры:
//	Строка - Строка - кодируемая строка
//
//Возвращаемое значение:
//	Строка
//
Функция РаскодироватьURLИзURL(Строка) Экспорт

	Возврат РаскодироватьСтроку(Строка, СпособКодированияСтроки.URLВКодировкеURL);

КонецФункции

// Добавляет запись об ошибке в журнал регистрации - вызывается с клиента
//
Процедура ДобавитьОшибкуВЖурналРегистрации(ИмяСобытия, ТекстОписания) Экспорт
	
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , , ТекстОписания);
	
КонецПроцедуры


#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// Возвращает структуру с владельцем и ключем, используемыми для записи и чтения настроек транспорта REST
Функция НовыеКлючиДляЗаписиНастроек(Провайдер = Неопределено, Пользователь = Неопределено) 

	Результат = Новый Структура;
	Результат.Вставить("Владелец", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Справочник.ТранспортыОбменаДанными"));
	
	Если Пользователь = Неопределено Тогда
		Если Константы.ИндивидуальныеНастройкиОбменаREST.Получить() Тогда
			Результат.Вставить("Ключ", ДеньгиКлиентСервер.КлючИзСтроки(ИмяПользователя()));
		Иначе
			Результат.Вставить("Ключ", "ВсеПользователи");
		КонецЕсли;
	Иначе
		Результат.Вставить("Ключ", Пользователь);
	КонецЕсли;
	
	Если Провайдер <> Неопределено Тогда
		Результат.Ключ = Результат.Ключ + "_" + ДеньгиКлиентСервер.КлючИзСтроки(Строка(Провайдер));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции


#КонецОбласти