﻿////////////////////////////////////////////////////////////////////////////////
// ОбслуживаниеДокументов: 
//	* Обработка событий форм документов
//  
////////////////////////////////////////////////////////////////////////////////


#Область ПрограммныйИнтерфейс

// Общий для форм документов функционал, выполняемый по событию ПередЗакрытием
Процедура ПередЗакрытием(Форма, Отказ, ЗавершениеРаботы, ТекстПредупреждения, ПараметрыЗаписи) Экспорт
	
	//	Перед записью может потребоваться получить от пользователя ответы на вопросы.
	// Поскольку события записи могут возникнуть при закрытии формы, добавим отметку о 
	// необходимости закрыть форму после получения ответов
	Если Форма.ДополнительныеПараметрыНаКлиенте = Неопределено Тогда
		Форма.ДополнительныеПараметрыНаКлиенте = Новый Структура;
	КонецЕсли;
	Форма.ДополнительныеПараметрыНаКлиенте.Вставить("ЗакрытьФормуПослеДиалогов", Истина);
	
КонецПроцедуры

// Общий для форм документов функционал, выполняемый по событию ПередЗаписью
Процедура ПередЗаписью(Форма, Отказ, ПараметрыЗаписи) Экспорт
	
	// Проверка записи нового документа
	РежимЗаписи = Неопределено;
	ПараметрыЗаписи.Свойство("РежимЗаписи", РежимЗаписи);
	ИмяКоманды = Неопределено;
	ПараметрыЗаписи.Свойство("ИмяКоманды", ИмяКоманды);
	
	Если Форма.Объект.Ссылка.Пустая() И Не Форма.Объект.ПометкаУдаления 
		И РежимЗаписи = РежимЗаписиДокумента.Запись И Не ЗначениеЗаполнено(ИмяКоманды)
		И Не Форма.Объект.ЭтоШаблон Тогда
		// в новом документе выбрана команда "Записать" (Ctrl+S)
		
		Отказ = Истина;
		
		ТекстВопроса = НСтр("ru='Как записать новую операцию?'");
		
		Кнопки = Новый СписокЗначений();
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Учесть'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru='Записать как черновик'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Отмена'"));
		
		Оповещение = Новый ОписаниеОповещения("ПередЗаписьюЗавершениеВопроса", ЭтотОбъект, Форма);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки, , КодВозвратаДиалога.Да, НСтр("ru='Запись новой операции'"));
		
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ПередЗаписьюЗавершениеВопроса(Ответ, Форма) Экспорт

	ПараметрыЗаписи = Неопределено;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		ПараметрыЗаписи = Новый Структура("РежимЗаписи,ИмяКоманды", РежимЗаписиДокумента.Запись, "СохранитьКакЧерновик");
	КонецЕсли;
	
	Если ПараметрыЗаписи <> Неопределено Тогда
		ДокументЗаписан = Форма.Записать(ПараметрыЗаписи);
		// Если команда "Записать" была дана в перед закрытием формы и запись выполнена форму нужно закрыть
		Если ДокументЗаписан И Форма.Открыта() И ТипЗнч(Форма.ДополнительныеПараметрыНаКлиенте) = Тип("Структура") 
				И Форма.ДополнительныеПараметрыНаКлиенте.Свойство("ЗакрытьФормуПослеДиалогов")
				И Форма.ДополнительныеПараметрыНаКлиенте.Свойство("ЗакрытьФормуПослеДиалогов") = Истина Тогда
			Форма.Закрыть();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры
 

#КонецОбласти