﻿
#Область ПрограммныйИнтерфейс

// Возвращает признак заполненности токена доступа.
//
// Параметры:
//  Данные	 - Структура - Поля соответствуют ресурсам регистра сведений CRM_СеансовыеДанныеGoogle.
// 
// Возвращаемое значение:
//  Булево - Ложь, когда переданный параметр является структурой, содержащей
//  заполненное свойство access_token, в противном случае возвращается Истина.
//
Функция НеЗаполненТокенДоступа(Данные) Экспорт
	
	Если ТипЗнч(Данные)<>Тип("Структура") Тогда
		Возврат Истина;
	КонецЕсли;
	
	ТокенДоступа = Неопределено;
	
	Данные.Свойство("access_token", ТокенДоступа);
	
	Возврат Не ЗначениеЗаполнено(ТокенДоступа);
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ОписанияОбластейДоступаКалендарь() Экспорт
	
	Результат = Новый Массив;
	
	Календарь = CRM_ОбменСGoogleКлиентСервер.НовоеОписаниеОбластиДоступа();
	Календарь.Представление = НСтр("ru='Календарь';en='Calendar'");
	Календарь.ОбластьДоступа = CRM_ОбменСGoogleКлиентСервер.ОбластьДоступа(
		ПредопределенноеЗначение("Перечисление.CRM_ОбластиДоступаGoogle.Календарь"));
	Результат.Добавить(Календарь);
	
	Возврат Результат;
	
КонецФункции

// Возвращает описание областей доступа для определения какие вызовы API можно
// будет выполнять от имени пользователя
// 
// Возвращаемое значение: Структура с ключами
//  * Представление -	Строка - представление области доступа
//  * ОбластьДоступа -	Строка - строка, которая будет передана в качестве
//                    	параметра scope в запросе подтверждения доступа у пользователя
//  * Использование -	Булево - использование области, включено по-умолчанию
//  * Редактирование -	Булево - использование области может переключать пользователь,
//                    	отключено по-умолчанию
//
Функция НовоеОписаниеОбластиДоступа() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Представление", "");
	Результат.Вставить("ОбластьДоступа", "");
	Результат.Вставить("Использование", Истина);
	Результат.Вставить("Редактирование", Ложь);
	Возврат Результат;
	
КонецФункции

Функция ОбластьДоступа(Вид) Экспорт
	
	Если Вид = ПредопределенноеЗначение("Перечисление.CRM_ОбластиДоступаGoogle.Календарь") Тогда
		Возврат "https://www.googleapis.com/auth/calendar";
	КонецЕсли;
	
КонецФункции

// Возвращает адрес перенаправления для подстановки в параметры запроса токена в Google
//
// Параметры:
//  ИдентификацияПриложения	 - Структура  - структура с параметрами из макета client_secret_json
// 
// Возвращаемое значение:
//  Строка - параметр redirect_uri
//
Функция АдресПеренаправления(ИдентификацияПриложения) Экспорт
	
	Если ЗначениеЗаполнено(ИдентификацияПриложения.redirect_uris) Тогда
		Возврат ИдентификацияПриложения.redirect_uris[0];
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

// Возвращает поддерживаемые виды идентификации приложения
// 
// Возвращаемое значение:
//  Массив - массив строк
//
Функция ВидыИдентификацииПриложения() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("installed");
	Результат.Добавить("web");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
