﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция СохранитьИзмененияЗаписейКалендарей(ОбрабатываемыеЭлементы) Экспорт
	
	НезависимыеЗаписи = Новый Массив;
	ПодчиненныеИсточнику = Новый Соответствие;
	
	Для Каждого ОбрабатываемыйЭлемент Из ОбрабатываемыеЭлементы Цикл
		Если ЗначениеЗаполнено(ОбрабатываемыйЭлемент.Источник) Тогда
			ЗаписиПоИсточнику = ПодчиненныеИсточнику.Получить(ОбрабатываемыйЭлемент.Источник);
			Если ЗаписиПоИсточнику = Неопределено Тогда
				ЗаписиПоИсточнику = Новый Массив;
				ЗаписиПоИсточнику.Добавить(ОбрабатываемыйЭлемент);
				ПодчиненныеИсточнику.Вставить(ОбрабатываемыйЭлемент.Источник, ЗаписиПоИсточнику);
			Иначе
				ЗаписиПоИсточнику.Добавить(ОбрабатываемыйЭлемент);
			КонецЕсли;
		Иначе
			НезависимыеЗаписи.Добавить(ОбрабатываемыйЭлемент);
		КонецЕсли;
	КонецЦикла;
	
	НачатьТранзакцию();
	
	Попытка
	
		Для Каждого КлючИЗначение Из ПодчиненныеИсточнику Цикл
			
			ИсточникОбъект = КлючИЗначение.Ключ.ПолучитьОбъект();
			
			Если ОбрабатываемыйЭлемент.Свойство("ПометкаУдаления") Тогда
				ИсточникОбъект.УстановитьПометкуУдаления(ОбрабатываемыйЭлемент.ПометкаУдаления);
				Продолжить;
			КонецЕсли;
			
			ИсточникОбъект.ОбновитьИсточникПриИзмененииЗаписиКалендаря(КлючИЗначение.Значение);
			ИсточникОбъект.Записать();
			
		КонецЦикла;
		
		Для Каждого ОбрабатываемыйЭлемент Из НезависимыеЗаписи Цикл
			
			ЗаписьОбъект = ОбрабатываемыйЭлемент.ЗаписьКалендаря.ПолучитьОбъект();
			
			Если ОбрабатываемыйЭлемент.Свойство("ПометкаУдаления") Тогда
				ЗаписьОбъект.УстановитьПометкуУдаления(ОбрабатываемыйЭлемент.ПометкаУдаления);
				Продолжить;
			КонецЕсли;
			
			ЗаписьОбъект.Начало		= ОбрабатываемыйЭлемент.Начало;
			ЗаписьОбъект.Окончание	= ОбрабатываемыйЭлемент.Конец;
			ЗаписьОбъект.Записать();
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		Успешно = Истина;
		
	Исключение
		
		ОтменитьТранзакцию();
		Успешно = Ложь;
		ВызватьИсключение СтрШаблон(НСтр("ru='Не удалось сохранить изменения в календаре по причине: %1'"), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
	Возврат Успешно;
	
КонецФункции

//+++ АйТи КучеровРМ 12.08.2019 ТЗ № 

#Область ИнтерфейсКалендаряСотрудника

// Функция определяет пиктограмму для элемента записи календаря
//
// Параметры:
//  Событие	 - ДокументСсылка.Событие	 - событие, для записи календаря которого подбирается картинка
// 
// Возвращаемое значение:
//  Картинка - пиктограмма записи календаря
//
Функция КартинкаЗаписиКалендаря(Событие) Экспорт
	
	Картинка = Неопределено;
	//ТипСобытия = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Событие, "ТипСобытия");
	//СоответствиеТиповКартинкам = ПолучитьСоответствиеТиповСобытийКартинкам();
	//Картинка = СоответствиеТиповКартинкам[ТипСобытия];
	Если Картинка = Неопределено Тогда
		Картинка = Новый Картинка;
	КонецЕсли;
	
	Возврат Картинка;
	
	//Возврат БиблиотекаКартинок.Изменить;
	
КонецФункции

// Функция определяет цвет текста для элемента записи календаря
//
// Параметры:
//  Событие	 - ДокументСсылка.Событие	 - событие, для записи календаря которого подбирается цвет
// 
// Возвращаемое значение:
//  Цвет - цвет текста записи календаря
//
Функция ЦветТекстаЗаписиКалендаря(Событие) Экспорт
	
	ЦветСостояния = Неопределено;
	//ЦветСостояния = Событие.Состояние.Цвет.Получить();
	Если ЦветСостояния = Неопределено Тогда
		ЦветСостояния = Новый Цвет;
	КонецЕсли;
	
	Возврат ЦветСостояния;
	
КонецФункции

Функция ПолучитьСоответствиеТиповСобытийКартинкам() Экспорт
	
	//СоответствиеТиповКартинкам = Новый Соответствие;
	//СоответствиеТиповКартинкам.Вставить(Перечисления.ТипыСобытий.ЛичнаяВстреча, БиблиотекаКартинок.КонтактнаяИнформацияАдрес);
	//СоответствиеТиповКартинкам.Вставить(Перечисления.ТипыСобытий.Прочее, БиблиотекаКартинок.КонтактнаяИнформацияДругое);
	//СоответствиеТиповКартинкам.Вставить(Перечисления.ТипыСобытий.СообщениеSMS, БиблиотекаКартинок.КонтактнаяИнформацияТелефон);
	//СоответствиеТиповКартинкам.Вставить(Перечисления.ТипыСобытий.ТелефонныйЗвонок, БиблиотекаКартинок.КонтактнаяИнформацияТелефон);
	//СоответствиеТиповКартинкам.Вставить(Перечисления.ТипыСобытий.ЭлектронноеПисьмо, БиблиотекаКартинок.КонтактнаяИнформацияЕмэйл);
	//СоответствиеТиповКартинкам.Вставить(Перечисления.ТипыСобытий.Запись, БиблиотекаКартинок.ТипСобытияЗапись);
	//
	//Возврат СоответствиеТиповКартинкам;
	
КонецФункции

// Процедура заполняет таблицу описаний расширенного ввода записи календаря
//
// Параметры:
//  ТаблицаОписаний	 - ТаблицаЗначений	 - описание колонок см. Справочник.ЗаписиКалендаряСотрудника.ПриЗаполненииРасширенногоВводаЗаписиКалендаря()
//
Процедура ПриЗаполненииРасширенногоВводаЗаписиКалендаря(ТаблицаОписаний) Экспорт
	
	НоваяСтрока = ТаблицаОписаний.Добавить();
	НоваяСтрока.ИмяФормы = "Справочник.ЗаписиКалендаряСотрудника.Форма.ФормаЭлемента";
	НоваяСтрока.ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", Новый Структура("ТипЗаписи"));
	НоваяСтрока.Представление = НСтр("ru='Календарь: Запись'");
	
КонецПроцедуры

#КонецОбласти

//--- АйТи КучеровРМ 12.08.2019 ТЗ № 

// Функция возвращает таблицу описаний возможных расширенных вводов записи календаря
// 
// Возвращаемое значение:
//  ТаблицаЗначений - таблица с колонками
//		ИмяФормы		- Строка - полный путь к форме для использования в ОтрытьФорму()
//		ПараметрыФормы	- Структура - параметры открываемой формы
//		Представление	- Строка - пользовательское представление расширенного ввода
//
Функция ОписаниеРасширенногоВводаЗаписей() Экспорт
	
	ТаблицаОписания = Новый ТаблицаЗначений;
	ТаблицаОписания.Колонки.Добавить("ИмяФормы",		Новый ОписаниеТипов("Строка"));
	ТаблицаОписания.Колонки.Добавить("ПараметрыФормы",	Новый ОписаниеТипов("Структура"));
	ТаблицаОписания.Колонки.Добавить("Представление",	Новый ОписаниеТипов("Строка"));
	
	ТипыЗаписей = Метаданные.ОпределяемыеТипы.ИсточникЗаписейКалендаря.Тип.Типы();
	
	Для Каждого ТипЗаписиКалендаря Из ТипыЗаписей Цикл
		
		//Если ТипЗаписиКалендаря = Тип("ДокументСсылка.ЗаказПокупателя")
		//	Или ТипЗаписиКалендаря = Тип("ДокументСсылка.ЗаказНаПроизводство")
		//	Тогда
		//	Продолжить
		//КонецЕсли;
		
		МетаданныеТипа = Метаданные.НайтиПоТипу(ТипЗаписиКалендаря);
		МенеджерТипа = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(МетаданныеТипа.ПолноеИмя());
		
		МенеджерТипа.ПриЗаполненииРасширенногоВводаЗаписиКалендаря(ТаблицаОписания);
		
	КонецЦикла;
	
	ТаблицаОписания.Сортировать("Представление УБЫВ");
	
	Возврат ТаблицаОписания;
	
КонецФункции

#КонецОбласти

#Область ИнтерфейсРабочегоПроцесса

Процедура СоставПолейЗаполненияДляРабочегоПроцесса(ТаблицаОписанияПолей, знач ТипДействия) Экспорт
	
	ЗаписиКалендаряМД = Метаданные.Справочники.ЗаписиКалендаряСотрудника;
	
	НовоеОписание = ТаблицаОписанияПолей.Добавить();
	НовоеОписание.ИмяРеквизита				= ЗаписиКалендаряМД.Реквизиты.Календарь.Имя;
	НовоеОписание.Заголовок					= ЗаписиКалендаряМД.Реквизиты.Календарь.Синоним;
	НовоеОписание.ВариантЗаполнения			= "Указанный";
	НовоеОписание.ТипЗначения				= ЗаписиКалендаряМД.Реквизиты.Календарь.Тип;
	НовоеОписание.ОбязательноеЗаполнение	= Истина;
	
	НовоеОписание = ТаблицаОписанияПолей.Добавить();
	НовоеОписание.ИмяРеквизита				= ЗаписиКалендаряМД.Реквизиты.Начало.Имя;
	НовоеОписание.Заголовок					= ЗаписиКалендаряМД.Реквизиты.Начало.Синоним;
	НовоеОписание.ВариантЗаполнения			= "Смещение";
	НовоеОписание.ТипЗначения				= ЗаписиКалендаряМД.Реквизиты.Начало.Тип;
	НовоеОписание.ОбязательноеЗаполнение	= Истина;
	
	НовоеОписание = ТаблицаОписанияПолей.Добавить();
	НовоеОписание.ИмяРеквизита				= ЗаписиКалендаряМД.Реквизиты.Окончание.Имя;
	НовоеОписание.Заголовок					= ЗаписиКалендаряМД.Реквизиты.Окончание.Синоним;
	НовоеОписание.ВариантЗаполнения			= "Смещение";
	НовоеОписание.ТипЗначения				= ЗаписиКалендаряМД.Реквизиты.Окончание.Тип;
	НовоеОписание.ОбязательноеЗаполнение	= Истина;
	
	НовоеОписание = ТаблицаОписанияПолей.Добавить();
	НовоеОписание.ИмяРеквизита				= "Наименование";
	НовоеОписание.Заголовок					= НСтр("ru='Представление'");
	НовоеОписание.ВариантЗаполнения			= "Указанный";
	НовоеОписание.ТипЗначения				= ОбщегоНазначения.ОписаниеТипаСтрока(ЗаписиКалендаряМД.ДлинаНаименования);
	НовоеОписание.ОбязательноеЗаполнение	= Истина;
	
	НовоеОписание = ТаблицаОписанияПолей.Добавить();
	НовоеОписание.ИмяРеквизита				= ЗаписиКалендаряМД.Реквизиты.Описание.Имя;
	НовоеОписание.Заголовок					= ЗаписиКалендаряМД.Реквизиты.Описание.Синоним;
	НовоеОписание.ВариантЗаполнения			= "Указанный";
	НовоеОписание.ТипЗначения				= ЗаписиКалендаряМД.Реквизиты.Описание.Тип;
	
КонецПроцедуры

#КонецОбласти

#Область Google

Функция ОбъектПоИдентификатору(Идентификатор, Календарь) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗаписиКалендаряСотрудника.Ссылка
	|ИЗ
	|	Справочник.ЗаписиКалендаряСотрудника КАК ЗаписиКалендаряСотрудника
	|ГДЕ
	|	ЗаписиКалендаряСотрудника.Ключ = &Ключ
	|	И ЗаписиКалендаряСотрудника.Календарь = &Календарь");
	Запрос.УстановитьПараметр("Ключ", ОбменСGoogle.КлючИзИдентификатора(Идентификатор, ТипЗнч(Справочники.ЗаписиКалендаряСотрудника)));
	Запрос.УстановитьПараметр("Календарь", Календарь);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Результат = Справочники.ЗаписиКалендаряСотрудника.СоздатьЭлемент();
		Результат.УстановитьНовыйКод();
		Возврат Результат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Ссылка.ПолучитьОбъект();
	
КонецФункции

#КонецОбласти

#КонецЕсли