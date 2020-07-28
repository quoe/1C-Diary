﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Владелец) Тогда
		ВладелецДополнительныхЗначений = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Владелец,
			"ВладелецДополнительныхЗначений");
		
		Если ЗначениеЗаполнено(ВладелецДополнительныхЗначений) Тогда
			ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Дополнительные значения для свойства ""%1"", созданного
				           |по образцу свойства ""%2"" нужно создавать для свойства-образца.'"),
				Владелец,
				ВладелецДополнительныхЗначений);
			
			Если ЭтоНовый() Тогда
				ВызватьИсключение ОписаниеОшибки;
			Иначе
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
