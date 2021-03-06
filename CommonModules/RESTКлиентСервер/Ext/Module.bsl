﻿////////////////////////////////////////////////////////////////////////////////
// RESTКлиентСервер
//	Общий функционал работы с облачными REST-API, доступный на клиенте и на сервере
//
//
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняет HTTP-запрос по заданным парамметрам
//
//Параметры:
//	Метод - Строка - "GET", "POST" и т.д.
//	Сервер - Строка - имя сервера (хост) без указания протокола и пути к ресурсам
//	Адрес - Строка - путь к ресурсам на сервере
//	ТекстЗапроса - Строка - текст, который нужно поместить в тело запроса
//	Заголовки - Соответствие - заголовки запроса
//	Защищенный - булево - тип соединения
//	Порт - Строка или Неопределено
//	Логин - Строка или Неопределено
//	Пароль - Строка или Неопределено
//
//Возвращаемое значение
//	HTTP-ответ
//
Функция ВыполнитьHTTPЗапрос(Метод, Сервер, Адрес, ТекстЗапроса, ФайлТела = "", Заголовки, Защищенный = Истина, ИмяВыходногоФайла = "", 
	Порт = Неопределено, Логин = Неопределено, Пароль = Неопределено) Экспорт

	// Соединение с сервером
	Если Защищенный Тогда
		SSL = Новый ЗащищенноеСоединениеOpenSSL(Неопределено, Неопределено);
	Иначе
		SSL = Неопределено;
	КонецЕсли;
	
	ИнтернетПрокси = RESTКлиентСервер.ИнтернетПроксиПоНастройкам();
	СоединениеССервером = Новый HTTPСоединение(Сервер, Порт, Логин, Пароль, ИнтернетПрокси, 120, SSL);
	
	//Запрос на сервер
	Запрос = Новый HTTPЗапрос;
	Запрос.АдресРесурса = Адрес;
	Если ТипЗнч(Заголовки) = Тип("Соответствие") Тогда
		Запрос.Заголовки = Заголовки;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ФайлТела) Тогда
		
		Если ТипЗнч(ФайлТела) = Тип("ДвоичныеДанные") Тогда
			Запрос.УстановитьТелоИзДвоичныхДанных(ФайлТела);
		#Если МобильноеПриложениеСервер Тогда
		ИначеЕсли ЭтоАдресВременногоХранилища(ФайлТела) Тогда
			Запрос.УстановитьТелоИзДвоичныхДанных(ПолучитьИзВременногоХранилища(ФайлТела));
		#КонецЕсли 
		Иначе
			Запрос.УстановитьИмяФайлаТела(ФайлТела);
		КонецЕсли;
		
	ИначеЕсли ТекстЗапроса <> Неопределено Тогда 
		Запрос.УстановитьТелоИзСтроки(ТекстЗапроса);
	КонецЕсли;
	
	Попытка
	
		Если ВРег(Метод) = "GET" Тогда
			Ответ = СоединениеССервером.Получить(Запрос, ИмяВыходногоФайла);
		ИначеЕсли ВРег(Метод) = "POST" Тогда
			Ответ = СоединениеССервером.ОтправитьДляОбработки(Запрос, ИмяВыходногоФайла);
		Иначе
			Ответ = СоединениеССервером.ВызватьHTTPМетод(ВРег(Метод), Запрос, ИмяВыходногоФайла);
		КонецЕсли;
	
	Исключение
		
		Ответ = Неопределено;
		ТекстОписания = СтрШаблон(НСтр("ru='Ошибка при выполнении запроса %1 к серверу %2/%3. Текст запроса: %4'"), Метод, Сервер, Адрес, ТекстЗапроса);
		ТекстОписания = ТекстОписания + Символы.ПС + "Описание ошибки: " + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		RESTВызовСервера.ДобавитьОшибкуВЖурналРегистрации("Выполнение HTTP-запроса", ТекстОписания);
		
	КонецПопытки;
	
	Возврат Ответ;

КонецФункции

// Возвращает соответствие, полученное из HTTPОтвета
//
//Параметры:
//	ОтветСервера - HTTPОтвет
//
//Возвращаемое значение:
//	Соответствие
//
Функция СоответствиеИзHTTPОтвета(ОтветСервера) Экспорт

	Результат = Новый Соответствие;
	
	Если ТипЗнч(ОтветСервера) <> Тип("HTTPОтвет") Тогда
		Возврат Результат;
	КонецЕсли;
	
	ТекстОтвета = ОтветСервера.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
	Если ПустаяСтрока(ТекстОтвета) Или Лев(СокрЛ(ТекстОтвета), 1) <> "{" Тогда
		Результат.Вставить("ТекстОтвета", ТекстОтвета);
		Возврат Результат;
	КонецЕсли;
	
	#Если ВебКлиент Или МобильноеПриложениеКлиент Или МобильноеПриложениеСервер Тогда
		Возврат ПарсерJSON.РаспарситьJSON(ТекстОтвета, 0);
	#Иначе
		ЧтениеJSON = Новый ЧтениеJSON();
		ЧтениеJSON.УстановитьСтроку(ТекстОтвета);
		Возврат ПрочитатьJSON(ЧтениеJSON, Истина);
	#КонецЕсли 

КонецФункции

// Проверяет авторизацию приложения у указанного провайдера
//
// Параметры:
//	Провайдер - ПеречислениеСсылка.ТипыПровайдеровREST - Провайдер, у которого проверяется авторизация
//	ПроверитьКодДоступаНаСервере - Булево - нужно ли проверять код доступа на сервере провайдера
//	КлючДоступа - Строка или Неопределено - ключ (токен) доступа провайдера (возвращаемое значение для уменьшеия количества серверных вызовов)
// 
// Возвращаемое значение:
//  Булево - Истина, если провайдер авторизован и Ложь в ином случае
//
Функция ПриложениеАвторизовано(Провайдер, ПроверитьКодДоступаНаСервере = Истина, СвойстваАккаунта = Неопределено) Экспорт
	
	// Приложение считаем авторизованным, если для него указан ключ (токен) доступа
	Если СвойстваАккаунта = Неопределено Тогда
		КлючДоступа = RESTВызовСервера.КлючДоступаПровайдера(Провайдер, СвойстваАккаунта);
	Иначе
		КлючДоступа = СвойстваАккаунта.КлючАвторизации;
	КонецЕсли;
	
	Если ПроверитьКодДоступаНаСервере И ЗначениеЗаполнено(КлючДоступа) Тогда
		Возврат КлючДоступаДействителен(Провайдер, КлючДоступа, СвойстваАккаунта);
	КонецЕсли;
	
	Возврат ЗначениеЗаполнено(КлючДоступа);
	
КонецФункции

// Выполняет запрос на сервер указанного провайдера для проверки ключа (токена) доступа
//	и возвращает результат проверки
//
//Параметры:
//	Провайдер - ПеречислениеСсылка.ТипыПровайдеровREST - Провайдер, у которого проверяется авторизация
//	КлючДоступа - Строка - ключ (токен) доступа, который нужно проверить на сервере провайдера
//
//Возвращаемое значение:
//	Булево или Неопределено - Истина, если токен действителен, Ложь если токен отменен и Неопределено в случае ошибки соединения или сервера
//
Функция КлючДоступаДействителен(Провайдер, КлючДоступа, СвойстваАккаунта) Экспорт

	Модуль = МодульПровайдераКлиентСервер(Провайдер);

	Если Модуль <> Неопределено Тогда
		Возврат Модуль.КлючДоступаДействителен(КлючДоступа, СвойстваАккаунта);
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Возвращает логин пользователя, под которым приложение авторизовано на сервере указанного провайдера
//
// Параметры:
//  Провайдер - Перечисление.ТипыПровайдеровREST - Провайдер услуг облачного хранилища
//	СвойстваАккаунта - Структура или Неопределено - логин и токен доступа к серверу провайдера (см. RESTВызовСервера.НоваяСтруктураПараметровREST())
//						Если Неопределено, заполняются авторматически как возвращаемый параметр для уменьшения серверных вызовов
// 
// Возвращаемое значение:
//  Строка - Представление авторизованного пользовательского аккаунта
//
Функция ПредставлениеАвторизованногоАккаунта(Провайдер = Неопределено, СвойстваАккаунта = Неопределено) Экспорт
	
	Если СвойстваАккаунта = Неопределено Тогда
		Если Провайдер = Неопределено Тогда
			СвойстваАккаунта = RESTВызовСервера.НастройкиАккаунтаИзПараметровСеанса();
		Иначе
			СвойстваАккаунта = RESTВызовСервера.НастройкиАккаунтаИзБезопасногоХранилища(Провайдер);
		КонецЕсли;
	КонецЕсли;
	
	Если СвойстваАккаунта = Неопределено Тогда
		Возврат "";
	Иначе 
		Возврат СвойстваАккаунта.ПредставлениеАккаунта;
	КонецЕсли;
	
КонецФункции

// Возвращает структуру свойств указанного провайдера, которые нужны для выполнения запросов
//	и авторизации приложения в сервисе провайдера
//
//Параметры:
//	Провайдер - ПеречислениеСсылка.ТипыПровайдеровREST - Провайдер облачного сервиса. 
//				Если не задан, будет использован токен из параметра сеанса
//
//Возвращаемое значение:
//	Структура
//
Функция СвойстваПровайдера(Провайдер = Неопределено) Экспорт

	Если Провайдер = Неопределено Тогда
		НастройкиПровайдера = RESTВызовСервера.НастройкиАккаунтаИзПараметровСеанса();
		Провайдер = НастройкиПровайдера.Провайдер;
	КонецЕсли;
	
	Если Провайдер = ПредопределенноеЗначение("Перечисление.ТипыПровайдеровREST.Dropbox") Тогда
		Возврат СвойстваПровайдераDropbox();
	ИначеЕсли Провайдер = ПредопределенноеЗначение("Перечисление.ТипыПровайдеровREST.Яндекс") Тогда
		Возврат СвойстваПровайдераЯндекс();
	ИначеЕсли Провайдер = ПредопределенноеЗначение("Перечисление.ТипыПровайдеровREST.Google") Тогда
		Возврат СвойстваПровайдераGoogle();
	КонецЕсли;
	
	Возврат Неопределено;

КонецФункции

// Получает настройки прокси сервера
//
Функция ИнтернетПроксиПоНастройкам() Экспорт
	
	НастройкаПроксиСервера = RESTВызовСервера.ПользовательскиеНастройкиПроксиСервера();
	
	Если НастройкаПроксиСервера <> Неопределено Тогда
		ИспользоватьПрокси = НастройкаПроксиСервера.Получить("ИспользоватьПрокси");
		ИспользоватьСистемныеНастройки = НастройкаПроксиСервера.Получить("ИспользоватьСистемныеНастройки");
		Если ИспользоватьПрокси Тогда
			Если ИспользоватьСистемныеНастройки Тогда
				// Системные настройки прокси-сервера
				Прокси = Новый ИнтернетПрокси(Истина);
			Иначе
				// Ручные настройки прокси-сервера
				Прокси = Новый ИнтернетПрокси;
				Прокси.Установить("ftp", НастройкаПроксиСервера["Сервер"], НастройкаПроксиСервера["Порт"]);
				Прокси.Пользователь = НастройкаПроксиСервера["Пользователь"];
				Прокси.Пароль       = НастройкаПроксиСервера["Пароль"];
				Прокси.НеИспользоватьПроксиДляЛокальныхАдресов = НастройкаПроксиСервера["НеИспользоватьПроксиДляЛокальныхАдресов"];
			КонецЕсли;
		Иначе
			// Не использовать прокси-сервер
			Прокси = Новый ИнтернетПрокси(Ложь);
		КонецЕсли;
	Иначе
		Прокси = Неопределено;
	КонецЕсли;
	
	Возврат Прокси;
	
КонецФункции


#Область ФайловыеОперацииВОблаке

#Область ОписаниеОбласти

// Все функции этой области возвращают структуру, в которой содержится код состояния (по аналогии с состояниями HTTP),
// описание ошибки, если таковая возникла и произвольный результат.
// ВАЖНО! Только вызывающие процедуры анализируют результат и, при необходимости, вызвают исключения и делают записи в журнал.
// Подробное описание структуры см. в НоваяСтруктураОтвета().
// В отдельных случаях в структуру результата могут добавляться другие ключи и значения
// ---
// Каждая функция дополняется необязательными возвращаемыми параметрами:
//	* СвойстваАккаунта - см. RESTВызовСервера.НоваяСтруктураПараметровREST()
//	* СвойстваПровайдера - см. RESTКлиентСервер.СвойстваПровайдера()
// если данные параметры пустые, они будут заполнены с вызовом сервера.

#КонецОбласти 

// Выполняет запрос на сервер для получения токена по коду доступа
//
//Параметры:
//  Провайдер - Перечисление.ТипыПровайдеровREST - Провайдер услуг облачного хранилища
//	КодДоступа - Строка - временный код, который нужно заменить на токен
//	СвойстваПровайдера - Структура или Неопределено - сервера, адреса и другие свойства провайдера (см. RESTКлиентСервер.СвойстваПровайдера())
//						Если Неопределено, заполняется авторматически как возвращаемый параметр для уменьшения серверных вызовов
// 
// Возвращаемое значение:
//  Структура - результат НоваяСтруктураОтвета(), заполненный результатами выполнения функции
//		Значение токена записывается в структуру результата с ключем "Токен"
//
Функция ОбменятьКодДоступаНаТокен(Провайдер, КодДоступа, СвойстваПровайдера = Неопределено) Экспорт

	Результат = НоваяСтруктураОтвета("Обмен кода доступа на токен");
	Результат.Вставить("Токен", Неопределено);
	
	СвойстваАккаунта = Неопределено;
	Модуль = МодульПровайдераКлиентСервер(Провайдер, Неопределено);

	Если Модуль = Неопределено Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru='Обновление свойств провайдера: указан некорректный провайдер ""%1""'"), Строка(Провайдер));
	КонецЕсли;
	
	ПроверитьСвойстваАккаунтаИПровайдера(Провайдер, СвойстваАккаунта, СвойстваПровайдера);

	Модуль.ОбменятьКодДоступаНаТокен(Результат, КодДоступа, СвойстваПровайдера);
	
	Возврат Результат;
	
КонецФункции
 
// Выполняет запрос на сервер провайдера для получения информации об аккаунте
//	Результат сохраняется в СвойствахАккаунта
//
//Параметры:
//  Провайдер - Перечисление.ТипыПровайдеровREST - Провайдер услуг облачного хранилища
//	СвойстваАккаунта - Произвольный - логин и токен доступа к серверу провайдера (см. RESTВызовСервера.НоваяСтруктураПараметровREST())
//						Перезаполняются авторматически как возвращаемый параметр для уменьшения серверных вызовов
//
// Возвращаемое значение:
//  Структура - результат НоваяСтруктураОтвета(), заполненный результатами выполнения функции
//
Функция ОбновитьСвойстваАккаунта(Провайдер, СвойстваАккаунта) Экспорт
	
	Результат = НоваяСтруктураОтвета("Обновление свойств аккаунта");
	Модуль = МодульПровайдераКлиентСервер(Провайдер, СвойстваАккаунта);

	Если Модуль = Неопределено Тогда
		ДополнитьОтветОписаниемОшибки(Результат, -1, СтрШаблон(НСтр("ru='Указан неверный провайдер ""%1""'"), Строка(Провайдер)));
		Возврат Результат;
	КонецЕсли;
	
	СвойстваПровайдера = Неопределено;
	ПроверитьСвойстваАккаунтаИПровайдера(Провайдер, СвойстваАккаунта, СвойстваПровайдера);
	
	Если СвойстваАккаунта = Неопределено Или Не ЗначениеЗаполнено(СвойстваАккаунта.КлючАвторизации) Тогда
		ДополнитьОтветОписаниемОшибки(Результат, -1, СтрШаблон(НСтр("ru='Не задан ключ авторизации для провайдера ""%1""'"), Строка(Провайдер)));
		Возврат Результат;
	КонецЕсли;
	Если СвойстваПровайдера = Неопределено Тогда
		ДополнитьОтветОписаниемОшибки(Результат, -1, СтрШаблон(НСтр("ru='Не определены настройки для провайдера ""%1""'"), Строка(Провайдер)));
	КонецЕсли;
	
	Модуль.ОбновитьСвойстваАккаунта(Результат, СвойстваАккаунта, СвойстваПровайдера);
	
	Возврат Результат;
	
КонецФункции

// Загружает в облачное хранилище указанный файл из локальной файловой системы
//
// Параметры:
//  Провайдер            - Перечисление.ТипыПровайдеровREST Или неопределено - Провайдер услуг облачного хранилища
//  ИмяФайлаИсточника    - Строка - Путь к файлу, который надо закачать в облако (Источник)
//  ИмяФайлаНазначения   - Строка - Путь в облаке, куда следует записать файл (Приемник)
//	СвойстваАккаунта - Структура или Неопределено - логин и токен доступа к серверу провайдера (см. RESTВызовСервера.НоваяСтруктураПараметровREST())
//						Если Неопределено - заполнится авторматически как возвращаемый параметр для уменьшения серверных вызовов
//	СвойстваПровайдера - Структура или Неопределено - сервера, адреса и другие свойства провайдера (см. RESTКлиентСервер.СвойстваПровайдера())
//						Если Неопределено, заполняется авторматически как возвращаемый параметр для уменьшения серверных вызовов
// 
// Возвращаемое значение:
//  Структура - результат НоваяСтруктураОтвета(), заполненный результатами выполнения функции
//
Функция ЗагрузитьФайлВОблако(Провайдер, ИмяФайлаИсточника, ИмяФайлаНазначения, СвойстваАккаунта = Неопределено, СвойстваПровайдера = Неопределено) Экспорт
	
	// Подготовка структуры с результатом функции
	Результат = НоваяСтруктураОтвета("Загрузка файла в облако");
	Модуль    = Неопределено;
	Если Не ПровайдерГотовКВыполнениюЗапросов(Результат, Провайдер, СвойстваАккаунта, СвойстваПровайдера, Модуль) Тогда
		Возврат Результат;
	КонецЕсли;
	
	// Выполнение операции в общем модуле провайдера
	Модуль.ЗагрузитьФайлВОблако(Результат, ИмяФайлаИсточника, ИмяФайлаНазначения, СвойстваАккаунта, СвойстваПровайдера);
	
	Возврат Результат;
	
КонецФункции

// Скачивает указанный файл из облака указанного провайдера на локальный диск пользователя.
//
// Параметры:
//  Провайдер            - Перечисление.ТипыПровайдеровREST Или неопределено - Провайдер услуг облачного хранилища
//  ИмяФайлаИсточника    - Строка - Путь к файлу, который надо скачать из облака (Источник)
//  ИмяФайлаНазначения   - Строка - Путь в локальной файловой системе, куда следует записать файл (Приемник)
//	СвойстваАккаунта - Структура или Неопределено - логин и токен доступа к серверу провайдера (см. RESTВызовСервера.НоваяСтруктураПараметровREST())
//						Если Неопределено - заполнится авторматически как возвращаемый параметр для уменьшения серверных вызовов
//	СвойстваПровайдера - Структура или Неопределено - сервера, адреса и другие свойства провайдера (см. RESTКлиентСервер.СвойстваПровайдера())
//						Если Неопределено, заполняется авторматически как возвращаемый параметр для уменьшения серверных вызовов
// 
// Возвращаемое значение:
//  Структура - результат НоваяСтруктураОтвета(), заполненный результатами выполнения функции
//
Функция СкачатьФайлИзОблака(Провайдер, ИмяФайлаИсточника, ИмяФайлаНазначения, СвойстваАккаунта = Неопределено, СвойстваПровайдера = Неопределено) Экспорт
	
	// Подготовка структуры с результатом функции
	Результат = НоваяСтруктураОтвета("Получение файла из облака");
	Модуль    = Неопределено;
	Если Не ПровайдерГотовКВыполнениюЗапросов(Результат, Провайдер, СвойстваАккаунта, СвойстваПровайдера, Модуль) Тогда
		Возврат Результат;
	КонецЕсли;
	
	// Выполнение операции в общем модуле провайдера
	Модуль.СкачатьФайлИзОблака(Результат, ИмяФайлаИсточника, ИмяФайлаНазначения, СвойстваАккаунта, СвойстваПровайдера);
	
	Возврат Результат;
	
КонецФункции

// Удаляет указанный файл в облачном хранилище
//
// Параметры:
//  Провайдер            - Перечисление.ТипыПровайдеровREST Или неопределено - Провайдер услуг облачного хранилища
//  ИмяФайла    - Строка - Путь к файлу, который нужно удалить
//	СвойстваАккаунта - Структура или Неопределено - логин и токен доступа к серверу провайдера (см. RESTВызовСервера.НоваяСтруктураПараметровREST())
//						Если Неопределено - заполнится авторматически как возвращаемый параметр для уменьшения серверных вызовов
//	СвойстваПровайдера - Структура или Неопределено - сервера, адреса и другие свойства провайдера (см. RESTКлиентСервер.СвойстваПровайдера())
//						Если Неопределено, заполняется авторматически как возвращаемый параметр для уменьшения серверных вызовов
// 
// Возвращаемое значение:
//  Структура - результат НоваяСтруктураОтвета(), заполненный результатами выполнения функции
//
Функция УдалитьФайлИзОблака(Провайдер, ИмяФайла, СвойстваАккаунта = Неопределено, СвойстваПровайдера = Неопределено) Экспорт
	
	// Подготовка структуры с результатом функции
	Результат = НоваяСтруктураОтвета("Удаление файла из облака");
	Модуль    = Неопределено;
	Если Не ПровайдерГотовКВыполнениюЗапросов(Результат, Провайдер, СвойстваАккаунта, СвойстваПровайдера, Модуль) Тогда
		Возврат Результат;
	КонецЕсли;
	
	// Выполнение операции в общем модуле провайдера
	Модуль.УдалитьФайлИзОблака(Результат, ИмяФайла, СвойстваАккаунта, СвойстваПровайдера);
	
	Возврат Результат;
	
КонецФункции

// Возвращает указанного ресурса (файла/каталога) в облачном хранилище
//	Информация о ресурсе помещается в СтруктуруРезультата.ИнформацияОРесурсе
//
//  Провайдер            - Перечисление.ТипыПровайдеровREST Или неопределено - Провайдер услуг облачного хранилища
//  ИмяФайла    - Строка - Путь к файлу или папки, существование которого проверяется
//	СвойстваАккаунта - Структура или Неопределено - логин и токен доступа к серверу провайдера (см. RESTВызовСервера.НоваяСтруктураПараметровREST())
//						Если Неопределено - заполнится авторматически как возвращаемый параметр для уменьшения серверных вызовов
//	СвойстваПровайдера - Структура или Неопределено - сервера, адреса и другие свойства провайдера (см. RESTКлиентСервер.СвойстваПровайдера())
//						Если Неопределено, заполняется авторматически как возвращаемый параметр для уменьшения серверных вызовов
// 
// Возвращаемое значение:
//	Структура - результат НоваяСтруктураОтвета(), заполненный результатами выполнения функции
//
Функция ПолучитьИнформациюОРесурсе(Провайдер, ИмяФайла, СвойстваАккаунта = Неопределено, СвойстваПровайдера = Неопределено) Экспорт
	
	// Подготовка структуры с результатом функции
	Результат = НоваяСтруктураОтвета("Проверка существования файла");
	Модуль    = Неопределено;
	Если Не ПровайдерГотовКВыполнениюЗапросов(Результат, Провайдер, СвойстваАккаунта, СвойстваПровайдера, Модуль) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Результат.Результат = Новый Структура("Существует,ИнформацияОРесурсе", Ложь);
	
	// Выполнение операции в общем модуле провайдера
	Модуль.ПолучитьИнформациюОРесурсе(Результат, ИмяФайла, СвойстваАккаунта, СвойстваПровайдера);
	
	Возврат Результат;
	
КонецФункции

// Получает список файлов, существующих в каталоге облачного сервиса и соответствующих указанной маске 
//
//Параметры:
//  Провайдер            - Перечисление.ТипыПровайдеровREST Или неопределено - Провайдер услуг облачного хранилища
//  Маска                - Строка - часть имени или расширения. Символы подстановки не используются. Если пусто - все файлы и каталоги
//  Путь                 - Строка - каталог, в котором нужно выполнять проверку. Если пусто (по умолчанию) - каталог приложения
//  ВключаяПодчиненные   - Булево - искать ли в подчиненных каталогах или только в указанном
//	СвойстваАккаунта     - Структура или Неопределено - логин и токен доступа к серверу провайдера (см. RESTВызовСервера.НоваяСтруктураПараметровREST())
//						Если Неопределено - заполнится авторматически как возвращаемый параметр для уменьшения серверных вызовов
//	СвойстваПровайдера - Структура или Неопределено - сервера, адреса и другие свойства провайдера (см. RESTКлиентСервер.СвойстваПровайдера())
//						Если Неопределено, заполняется авторматически как возвращаемый параметр для уменьшения серверных вызовов
//
//Возвращаемое значение:
//	Структура - результат НоваяСтруктураОтвета(), заполненный результатами выполнения функции
//
Функция СисокФайловВОблаке(Провайдер, Маска, Путь = "", ВключаяПодчиненные = Истина, СвойстваАккаунта = Неопределено, СвойстваПровайдера = Неопределено) Экспорт

	// Подготовка структуры с результатом функции
	Результат = НоваяСтруктураОтвета("Получение списка имен файлов, находящихся в облаке");
	Модуль    = Неопределено;
	Если Не ПровайдерГотовКВыполнениюЗапросов(Результат, Провайдер, СвойстваАккаунта, СвойстваПровайдера, Модуль) Тогда
		Возврат Результат;
	КонецЕсли;
	
	// Выполнение операции в общем модуле провайдера
	Модуль.СисокФайловВОблаке(Результат, Маска, Путь, ВключаяПодчиненные, СвойстваАккаунта, СвойстваПровайдера);
	
	Возврат Результат;

КонецФункции

// Создает каталог в облаке, если он еще не существует
//
// Параметры:
//  Провайдер            - Перечисление.ТипыПровайдеровREST Или неопределено - Провайдер услуг облачного хранилища
//  ИмяКаталога          - Строка - Путь к создаваемому каталогу
//	СвойстваАккаунта - Структура или Неопределено - логин и токен доступа к серверу провайдера (см. RESTВызовСервера.НоваяСтруктураПараметровREST())
//						Если Неопределено - заполнится авторматически как возвращаемый параметр для уменьшения серверных вызовов
//	СвойстваПровайдера - Структура или Неопределено - сервера, адреса и другие свойства провайдера (см. RESTКлиентСервер.СвойстваПровайдера())
//						Если Неопределено, заполняется авторматически как возвращаемый параметр для уменьшения серверных вызовов
// 
// Возвращаемое значение:
//  Структура - результат НоваяСтруктураОтвета(), заполненный результатами выполнения функции
//
Функция СоздатьКаталогВОблаке(Провайдер, ИмяКаталога, СвойстваАккаунта = Неопределено, СвойстваПровайдера = Неопределено) Экспорт
	
	// Подготовка структуры с результатом функции
	Результат = НоваяСтруктураОтвета("Создание каталога в облаке");
	Модуль    = Неопределено;
	Если Не ПровайдерГотовКВыполнениюЗапросов(Результат, Провайдер, СвойстваАккаунта, СвойстваПровайдера, Модуль) Тогда
		Возврат Результат;
	КонецЕсли;
	
	// Выполнение операции в общем модуле провайдера
	Модуль.СоздатьКаталогВОблаке(Результат, ИмяКаталога, СвойстваАккаунта, СвойстваПровайдера);
	
	Возврат Результат;
	
КонецФункции

// Отменяет авторизацию приложения в облаке
//
//Параметры:
//  Провайдер            - Перечисление.ТипыПровайдеровREST Или неопределено - Провайдер услуг облачного хранилища
//	СвойстваАккаунта     - Структура или Неопределено - логин и токен доступа к серверу провайдера (см. RESTВызовСервера.НоваяСтруктураПараметровREST())
//						Если Неопределено - заполнится авторматически как возвращаемый параметр для уменьшения серверных вызовов
//	СвойстваПровайдера - Структура или Неопределено - сервера, адреса и другие свойства провайдера (см. RESTКлиентСервер.СвойстваПровайдера())
//						Если Неопределено, заполняется авторматически как возвращаемый параметр для уменьшения серверных вызовов
//
//Возвращаемое значение:
//	Структура - результат НоваяСтруктураОтвета(), заполненный результатами выполнения функции
//
Функция ОтменитьАвторизациюВОблаке(Провайдер, СвойстваАккаунта = Неопределено, СвойстваПровайдера = Неопределено) Экспорт

	// Подготовка структуры с результатом функции
	Результат = НоваяСтруктураОтвета("Отмена авторизации в облаке");
	Модуль    = Неопределено;
	Если Не ПровайдерГотовКВыполнениюЗапросов(Результат, Провайдер, СвойстваАккаунта, СвойстваПровайдера, Модуль) Тогда
		Возврат Результат;
	КонецЕсли;
	
	// Выполнение операции в общем модуле провайдера
	Модуль.ОтменитьАвторизациюВОблаке(Результат, СвойстваАккаунта, СвойстваПровайдера);
	
	Если Результат.ВыполненоУспешно Тогда
		
		СвойстваАккаунта.КлючАвторизации = "";
		СвойстваАккаунта.ИДАккаунта = "";
		СвойстваАккаунта.ПредставлениеАккаунта = "";
		
		RESTВызовСервера.ОбновитьСвойстваАккаунта(СвойстваАккаунта);
		
	КонецЕсли;
	
	Возврат Результат;

КонецФункции
 

#КонецОбласти


#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

// Создает пустую структуру которая заполняется и возвращается функциями модулей обслуживания REST
//	Код состояния в большинстве случаев соответствует кодам состояния HTTP. Но только вызывыающие 
// функции должны определять, является ли тот или иной код ошибкой.
//	Например: при проверке подключения код 401 - не ошибка, а при попытке работы с файлами - ошибка
//	Вызывающие методы могут дополнить структуру другими ключами
//
//Параметры:
//	ИмяСобытия - Строка - имя события, под которым результаты могут быть записаны в журнал регистрации
//
//Возвращаемое значение:
//	Структура (описание полей в коде)
//
Функция НоваяСтруктураОтвета(ИмяСобытия = "") Экспорт

	Результат = Новый Структура;
	Результат.Вставить("ИмяСобытия", "REST" + ?(ЗначениеЗаполнено(ИмяСобытия), "." + Строка(ИмяСобытия), "")); // Строка, используется как одноименный параметр для записи в журнал регистрации
	Результат.Вставить("ВыполненоУспешно", Ложь); // булево, Истина, если функция выполнена успешно или Лож при наличии ошибок
	Результат.Вставить("КодСостояния", 0); // число, соответствует кодам состояния HTTP, дополненным "специальными" кодами
	Результат.Вставить("Результат", Неопределено); // произвольное значение - результат выполнения функции
	Результат.Вставить("ОписаниеОшибки", ""); // подробное описание ошибки или технологическая информация
	Результат.Вставить("ПредставлениеОшибки", ""); // пояснение для пользователя
	
	Возврат Результат;

КонецФункции

// Добавляет в структуру, возвращаемую функциями, определение и описание ошибки
//
//Параметры:
//	СтруктураОтвета - Структура - см. НоваяСтруктураОтвета()
//	КодСостояния - Число - отрицательные коды соответствуют внутренним ошибкам приложения, 
//					положительные - кодам состояния HTTP
//	Ошибка - произвольный - Описание ошибки (объект или строка), ответ HTTP или т.п.
//
Процедура ДополнитьОтветОписаниемОшибки(СтруктураОтвета, КодСостояния, Ошибка) Экспорт
	
	СтруктураОтвета.ВыполненоУспешно = Ложь;
	СтруктураОтвета.КодСостояния = КодСостояния;
	
	Если ТипЗнч(Ошибка) = Тип("Строка") Тогда
		СтруктураОтвета.ОписаниеОшибки = Ошибка;
	ИначеЕсли ТипЗнч(Ошибка) = Тип("ИнформацияОбОшибке") Тогда
		СтруктураОтвета.ОписаниеОшибки = ПодробноеПредставлениеОшибки(Ошибка);
	КонецЕсли;
	
	RESTВызовСервера.ОтметитьОшибкуВЖурналеРегистрации(СтруктураОтвета);
	
КонецПроцедуры

// Конвертирует строку из UTF-8 в строку вида "\u0410\u0440\..."
//	Символы с 1 по 127 не конветрируются
//
//Параметры:
//	Строка - Строка - конвертуруемый текст
//
//Возвращаемое значение:
//	Строка
//
Функция КодироватьСтрокуКакUnicode(Строка) Экспорт

	Результат = "";
	Для Счетчик = 1 по СтрДлина(Строка) Цикл
		Результат = Результат + СимволJSONEncode(Сред(Строка, Счетчик, 1));
	КонецЦикла;

	Возврат Результат;

КонецФункции

// Преобразует закодированную строку из Unicode в строку
//
// Параметры:
//  Данные	 - Строка - Закодированная строка
// 
// Возвращаемое значение:
//  Строка - Результирующая перекодированная строка
//
Функция UnicodeВСтроку(Знач Данные) Экспорт
	Результат = "";
	Маркер = 1;
	
	Пока Маркер <= СтрДлина(Данные) Цикл
		ТекСимвол = Сред(Данные, Маркер, 1);
		
		Если ТекСимвол=" " Тогда
			Результат = Результат + ТекСимвол;
			Маркер = Маркер + 1;
		ИначеЕсли ТекСимвол = "\" Тогда  //Нашли закодированный символ
			Маркер = Маркер + 2;
			Вес = 4096;
			ГотовыйКодСимвола = 0;
			Для Поз = 0 По 3 Цикл
				ТекущийКодСимвола = КодСимвола(Данные, Маркер + Поз);
				Если ТекущийКодСимвола > 96 Тогда // a-f
					ТекущийКодСимвола = ТекущийКодСимвола - 87;
				ИначеЕсли ТекущийКодСимвола > 64 Тогда // A-F
					ТекущийКодСимвола = ТекущийКодСимвола - 55;
				Иначе
					ТекущийКодСимвола = ТекущийКодСимвола - 48; // 0-9
				КонецЕсли;
				ГотовыйКодСимвола = ГотовыйКодСимвола + ТекущийКодСимвола*Вес;
				Вес = Вес / 16;
			КонецЦикла;
			Результат = Результат + Символ(ГотовыйКодСимвола);
			Маркер = Маркер + 4; // Смещаемся на след. символ
		Иначе
			Маркер = Маркер + 1;
			Результат = Результат + ТекСимвол;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

// Проверяет и при необходимости заполняет структуры свойств 
//
Процедура ПроверитьСвойстваАккаунтаИПровайдера(Провайдер, СвойстваАккаунта, СвойстваПровайдера) Экспорт
	
	Если Не ЗначениеЗаполнено(Провайдер) Тогда
		Провайдер = RESTВызовСервера.ПровайдерИзПараметраСеанса(СвойстваАккаунта);
	КонецЕсли;
	
	Если СвойстваАккаунта = Неопределено Тогда
		СвойстваАккаунта = RESTВызовСервера.НастройкиАккаунтаИзБезопасногоХранилища(Провайдер);
	КонецЕсли;
	
	Если СвойстваПровайдера = Неопределено Тогда
		СвойстваПровайдера = СвойстваПровайдера(Провайдер);
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// Общий функционал для методов выполнения запросов к облачным провайдерам
//
Функция ПровайдерГотовКВыполнениюЗапросов(СтруктураОтвета, Провайдер, СвойстваАккаунта, СвойстваПровайдера, Модуль) 

	// Проверка авторизации
	ПроверитьСвойстваАккаунтаИПровайдера(Провайдер, СвойстваАккаунта, СвойстваПровайдера);
	Если ТипЗнч(СвойстваАккаунта) <> Тип("Структура") Или Не ЗначениеЗаполнено(СвойстваАккаунта.КлючАвторизации) Тогда
		ДополнитьОтветОписаниемОшибки(СтруктураОтвета, -1, СтрШаблон(НСтр("ru='Для провайдера ""%1"" не задан ключ доступа (токен)'"), Строка(Провайдер)));
		Возврат Ложь;
	КонецЕсли;
	Если ТипЗнч(СвойстваПровайдера) <> Тип("Структура") Тогда
		ДополнитьОтветОписаниемОшибки(СтруктураОтвета, -1, СтрШаблон(НСтр("ru='Не удалось получить настройки провайдера ""%1""'"), Строка(Провайдер)));
		Возврат Ложь;
	КонецЕсли;
	
	// Определение общего модуля
	Модуль    = МодульПровайдераКлиентСервер(Провайдер, СвойстваАккаунта);
	Если Модуль = Неопределено Тогда
		ДополнитьОтветОписаниемОшибки(СтруктураОтвета, -1, СтрШаблон(НСтр("ru='Указан неверный провайдер ""%1""'"), Строка(Провайдер)));
		Возврат Ложь;
	КонецЕсли;

	Возврат Истина;
	
КонецФункции

// Возвращает общий модуль КлиентСервер, соответствующий указанному провайдеру
Функция МодульПровайдераКлиентСервер(Провайдер = Неопределено, НастройкиАккаунта = Неопределено) 

	Если Провайдер = Неопределено Тогда
		Провайдер = RESTВызовСервера.ПровайдерИзПараметраСеанса(НастройкиАккаунта);
	КонецЕсли;
	
	Если Провайдер = ПредопределенноеЗначение("Перечисление.ТипыПровайдеровREST.Яндекс") Тогда
		Возврат RESTЯндексКлиентСервер;
	ИначеЕсли Провайдер = ПредопределенноеЗначение("Перечисление.ТипыПровайдеровREST.Dropbox") Тогда
		Возврат RESTDropboxКлиентСервер;
	ИначеЕсли Провайдер = ПредопределенноеЗначение("Перечисление.ТипыПровайдеровREST.Google") Тогда
		Возврат RESTGoogleКлиентСервер;
	КонецЕсли;

	Возврат Неопределено;
	
КонецФункции

//Перевод чисел из десятичной в любую (с количеством цифр до 36) позиционную систему счисления
Функция ЧислоВДругойНотации(Знач Значение = 0, Нотация = 36)
	Если Нотация <= 0 Тогда
		Возврат("");
	КонецЕсли;
	Значение = Число(Значение);
	Если Значение <= 0 Тогда
		Возврат("0");
	КонецЕсли;
	Значение = Цел(Значение);
	Результат = "";
	Пока Значение > 0 Цикл
		Результат = Сред("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ", Значение % Нотация + 1, 1) + Результат;
		Значение = Цел(Значение / Нотация);
	КонецЦикла;
	Возврат Нрег(Результат);
КонецФункции

Функция СимволJSONEncode(СимволИзТекста) 

	Код = КодСимвола(СимволИзТекста);
	Если Код < 127 Тогда
		Возврат СимволИзТекста;
	КонецЕсли;
	
	Уникод = ЧислоВДругойНотации(Код, 16);
	Пока СтрДлина(Уникод) < 4 Цикл
		Уникод = "0" + Уникод;
	КонецЦикла;
	 
	Возврат "\u" + Уникод;

КонецФункции

#Область СвойстваПровайдеров

// Возвращает параметры авторизации Dropbox в виде структуры
// 
// Возвращаемое значение:
//  Структура - Параметры авторизации и работы с Dropbox
//
Функция СвойстваПровайдераDropbox() 
	
	Результат = Новый Структура;
	
	Результат.Вставить("ИмяПриложения", "1С Деньги 8");
	Результат.Вставить("Идентификатор", "q55jhq38gm74580"); // app key
	Результат.Вставить("Пароль",        "9f1h2fo2cizns74"); // App secret
	Результат.Вставить("CallbackURL", "https://us-central1-checkdb-93a67.cloudfunctions.net/addCodeDropbox");
	
	Результат.Вставить("СерверАвторизации", "api.dropbox.com");
	Результат.Вставить("СерверAPI", "api.dropboxapi.com");
	Результат.Вставить("СерверРаботыСКонтентом", "content.dropboxapi.com");
	
	
	Результат.Вставить("КаталогОбмена", "/"); //Каталог система создаст сама. Путь относительный	
	Результат.Вставить("КаталогРезервныхКопий", Результат.КаталогОбмена + "Backups"); //Путь относительный каталога приложений
	
	Возврат Результат;
	
КонецФункции

// Возвращает параметры авторизации яндекс
// 
// Возвращаемое значение:
//  Структура - Параметры авторизации REST API на Яндексе
//    * ИмяПриложения - Строка - Имя приложения, как оно задано в каталоге приложений Яндекс
//    * Идентификатор - Строка - Идентификатор приложения в каталоге приложений Яндекс
//    * Пароль - Строка - Пароль приложения в каталоге приложений Яндекс
//    * CallbackURL - Строка - URL на который будет редиректитьЯндекс, после авторизации пользователя
//    * URLАвторизации - Строка - URL авторизации по идентификатору приложения
//    * СерверAPI - Строка - Адрес (без протоколов) сервера REST API яндекса
//    * СерверАвторизации - Строка - Адрес (без протоколоа) авторизации яндекса
//    * АвторизацияУстройства - Булево - Флаг активности выдачи авторизации для текущего устройства
//    * КаталогОбмена - Строка - Имя каталога обмена данными на Яндекс.Диске
//
Функция СвойстваПровайдераЯндекс()
	
	Результат = Новый Структура();
	
	Результат.Вставить("ИмяПриложения", "1С Деньги 8"); //Имя приложения, как оно задано в Яндекс
	Результат.Вставить("Идентификатор", "6297da238ec445708e9652a480b7eec9"); 
	Результат.Вставить("Пароль",        "aa6590d87c9942919bcc99de5b1b3bb9");
	Результат.Вставить("CallbackURL", "https://us-central1-checkdb-93a67.cloudfunctions.net/addCodeYandex");
	
	Результат.Вставить("СерверАвторизации", "oauth.yandex.ru");
	Результат.Вставить("СерверAPI", "cloud-api.yandex.net");
	Результат.Вставить("СерверРаботыСКонтентом", "cloud-api.yandex.net");
	
	Результат.Вставить("КаталогОбмена", "app:/"); 
	Результат.Вставить("КаталогРезервныхКопий", Результат.КаталогОбмена + "Backups"); //Путь относительный каталога приложений
		
	Возврат Результат;	
	
КонецФункции

// Возвращает параметры авторизации яндекс
// 
// Возвращаемое значение:
//  Структура - Параметры авторизации REST API на Яндексе
//    * ИмяПриложения - Строка - Имя приложения, как оно задано в каталоге приложений Яндекс
//    * Идентификатор - Строка - Идентификатор приложения в каталоге приложений Яндекс
//    * Пароль - Строка - Пароль приложения в каталоге приложений Яндекс
//    * CallbackURL - Строка - URL на который будет редиректитьЯндекс, после авторизации пользователя
//    * URLАвторизации - Строка - URL авторизации по идентификатору приложения
//    * СерверAPI - Строка - Адрес (без протоколов) сервера REST API яндекса
//    * СерверАвторизации - Строка - Адрес (без протоколоа) авторизации яндекса
//    * АвторизацияУстройства - Булево - Флаг активности выдачи авторизации для текущего устройства
//    * КаталогОбмена - Строка - Имя каталога обмена данными на Яндекс.Диске
//
Функция СвойстваПровайдераGoogle()
	
	Результат = Новый Структура();
	
	Результат.Вставить("ИмяПриложения", "1С Деньги 8"); //Имя приложения, как оно задано в Яндекс
	Результат.Вставить("Идентификатор", "28080092540-27iq8ev5n73qf3prdur75cfenl485oje.apps.googleusercontent.com"); //Client ID
	Результат.Вставить("Пароль",        "cPqOJs2ieAtwZ4mwEw4Z9i5w"); //client_secret
	Результат.Вставить("CallbackURL", "https://us-central1-checkdb-93a67.cloudfunctions.net/addCodeGoogle"); //redirect_uris
	
	Результат.Вставить("СерверАвторизации", "accounts.google.com");
	Результат.Вставить("СерверAPI", "www.googleapis.com");
	Результат.Вставить("СерверРаботыСКонтентом", "www.googleapis.com");
	
	Результат.Вставить("КаталогОбмена", "app:/"); 
	Результат.Вставить("КаталогРезервныхКопий", Результат.КаталогОбмена + "Backups"); //Путь относительный каталога приложений
		
	Возврат Результат;	
	
КонецФункции


#КонецОбласти 


#КонецОбласти