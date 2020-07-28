﻿#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "Форма" Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "ОбщаяФорма.ФормаПоиска";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция ПараметрыПоиска() Экспорт 
	
	Параметры = Новый Структура;
	Параметры.Вставить("СтрокаПоиска", 0);
	Параметры.Вставить("НаправлениеПоиска", "ПерваяЧасть");
	Параметры.Вставить("ТекущаяПозиция", 0);
	Параметры.Вставить("ИскатьВРазделах", Ложь);
	Параметры.Вставить("ОбластиПоиска", Новый Массив);
	
	Возврат Параметры;
	
КонецФункции

Функция ВыполнитьПолнотекстовыйПоиск(ПараметрыПоиска) Экспорт 
	
	СтрокаПоиска    = ПараметрыПоиска.СтрокаПоиска;
	Направление     = ПараметрыПоиска.НаправлениеПоиска;
	ТекущаяПозиция  = ПараметрыПоиска.ТекущаяПозиция;
	ИскатьВРазделах = ПараметрыПоиска.ИскатьВРазделах;
	ОбластиПоиска   = ПараметрыПоиска.ОбластиПоиска;
	
	РазмерПорции = 10;
	ОписаниеОшибки = "";
	КодОшибки = "";
	
	СписокПоиска = ПолнотекстовыйПоиск.СоздатьСписок(СтрокаПоиска, РазмерПорции);
	
	Если ИскатьВРазделах И ОбластиПоиска.Количество() > 0 Тогда
		СписокПоиска.ИспользованиеМетаданных = ИспользованиеМетаданныхПолнотекстовогоПоиска.НеИспользовать;
		
		Для каждого Область Из ОбластиПоиска Цикл
			ОбъектМетаданных = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(Область.Значение);
			СписокПоиска.ОбластьПоиска.Добавить(ОбъектМетаданных);
		КонецЦикла;
	КонецЕсли;
	
	Попытка
		Если Направление = "ПерваяЧасть" Тогда
			СписокПоиска.ПерваяЧасть();
		ИначеЕсли Направление = "ПредыдущаяЧасть" Тогда
			СписокПоиска.ПредыдущаяЧасть(ТекущаяПозиция);
		ИначеЕсли Направление = "СледующаяЧасть" Тогда
			СписокПоиска.СледующаяЧасть(ТекущаяПозиция);
		Иначе 
			ВызватьИсключение НСтр("ru = 'Параметр НаправлениеПоиска задан неверно.'");
		КонецЕсли;
	Исключение
		ОписаниеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		КодОшибки = "ОшибкаПоиска";
	КонецПопытки;
	
	Если СписокПоиска.СлишкомМногоРезультатов() Тогда 
		ОписаниеОшибки = НСтр("ru = 'Слишком много результатов, уточните запрос'");
		КодОшибки = "СлишкомМногоРезультатов";
	КонецЕсли;
	
	ПолноеКоличество = СписокПоиска.ПолноеКоличество();
	
	Если ПолноеКоличество = 0 Тогда
		ОписаниеОшибки = НСтр("ru = 'По запросу ничего не найдено'");
		КодОшибки = "НичегоНеНайдено";
	КонецЕсли;
	
	Если ПустаяСтрока(КодОшибки) Тогда 
		РезультатыПоиска = РезультатыПолнотекстовогоПоиска(СписокПоиска);
	Иначе 
		РезультатыПоиска = Новый Массив;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ТекущаяПозиция", СписокПоиска.НачальнаяПозиция());
	Результат.Вставить("Количество", СписокПоиска.Количество());
	Результат.Вставить("ПолноеКоличество", ПолноеКоличество);
	Результат.Вставить("КодОшибки", КодОшибки);
	Результат.Вставить("ОписаниеОшибки", ОписаниеОшибки);
	Результат.Вставить("РезультатыПоиска", РезультатыПоиска);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция РезультатыПолнотекстовогоПоиска(СписокПоиска)
	
	// Разбор списка посредством выделения блока описания HTML.
	СтрокиПоискаHTML = СтрокиРезультатаПоискаHTML(СписокПоиска);
	
	Результат = Новый Массив;
	
	// Обход строк списка поиска.
	Для Индекс = 0 По СписокПоиска.Количество() - 1 Цикл
		
		ОписаниеHTML  = СтрокиПоискаHTML.ОписанияHTML.Получить(Индекс);
		Представление = СтрокиПоискаHTML.Представления.Получить(Индекс);
		СтрокаСпискаПоиска = СписокПоиска.Получить(Индекс);
		
		МетаданныеОбъекта = СтрокаСпискаПоиска.Метаданные;
		Значение          = СтрокаСпискаПоиска.Значение;
		
		Переопределяемый_ПриПолученииПолнотекстовымПоиском(МетаданныеОбъекта, Значение, Представление);
		
		Ссылка = "";
		Попытка
			Ссылка = ПолучитьНавигационнуюСсылку(Значение);
		Исключение
			Ссылка = "#"; // Непредусмотренное для открытия.
		КонецПопытки;
		
		СтрокаРезультата = Новый Структура;
		СтрокаРезультата.Вставить("Ссылка",        Ссылка);
		СтрокаРезультата.Вставить("ОписаниеHTML",  ОписаниеHTML);
		СтрокаРезультата.Вставить("Представление", Представление);
		
		Результат.Добавить(СтрокаРезультата);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция СтрокиРезультатаПоискаHTML(СписокПоиска)
	
	ОтображениеСпискаHTML = СписокПоиска.ПолучитьОтображение(ВидОтображенияПолнотекстовогоПоиска.HTMLТекст);
	
	// Получение DOM для отображения списка.
	// Нельзя выносить в отдельную функцию получения DOM из-за ошибки платформы в стеке вызовов потока чтения DOM.
	ЧтениеHTML = Новый ЧтениеHTML;
	ЧтениеHTML.УстановитьСтроку(ОтображениеСпискаHTML);
	ПостроительDOM = Новый ПостроительDOM;
	ОтображениеСпискаDOM = ПостроительDOM.Прочитать(ЧтениеHTML);
	ЧтениеHTML.Закрыть();
	
	СписокЭлементовDivDOM = ОтображениеСпискаDOM.ПолучитьЭлементыПоИмени("div");
	СтрокиОписанияHTML = СтрокиОписанияHTML(СписокЭлементовDivDOM);
	
	СписокЭлементовAnchorDOM = ОтображениеСпискаDOM.ПолучитьЭлементыПоИмени("a");
	СтрокиПредставления = СтрокиПредставления(СписокЭлементовAnchorDOM);
	
	Результат = Новый Структура;
	Результат.Вставить("ОписанияHTML", СтрокиОписанияHTML);
	Результат.Вставить("Представления", СтрокиПредставления);
	
	Возврат Результат;
	
КонецФункции

Функция СтрокиОписанияHTML(СписокЭлементовDivDOM)
	
	СтрокиОписанияHTML = Новый Массив;
	Для каждого ЭлементDOM Из СписокЭлементовDivDOM Цикл 
		
		Если ЭлементDOM.ИмяКласса = "textPortion" Тогда 
			
			ЗаписьDOM = Новый ЗаписьDOM;
			ЗаписьHTML = Новый ЗаписьHTML;
			ЗаписьHTML.УстановитьСтроку();
			ЗаписьDOM.Записать(ЭлементDOM, ЗаписьHTML);
			
			ОписаниеHTMLСтрокиРезультата = ЗаписьHTML.Закрыть();
			
			СтрокиОписанияHTML.Добавить(ОписаниеHTMLСтрокиРезультата);
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтрокиОписанияHTML;
	
КонецФункции

Функция СтрокиПредставления(СписокЭлементовAnchorDOM)
	
	СтрокиПредставления = Новый Массив;
	Для каждого ЭлементDOM Из СписокЭлементовAnchorDOM Цикл
		
		Представление = ЭлементDOM.ТекстовоеСодержимое;
		СтрокиПредставления.Добавить(Представление);
		
	КонецЦикла;
	
	Возврат СтрокиПредставления;
	
КонецФункции

// Позволяет переопределить:
// - Значение
// - Представление
//
// См. тип данных ЭлементСпискаПолнотекстовогоПоиска 
//
Процедура Переопределяемый_ПриПолученииПолнотекстовымПоиском(МетаданныеОбъекта, Значение, Представление)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда 
		
		// Для дополнительных сведений открывается форма объекта, которому принадлежит значение,
		// а не формы записи в регистре сведений.
		
		Если МетаданныеОбъекта = Метаданные.РегистрыСведений["ДополнительныеСведения"] Тогда 
			
			Значение = Значение.Объект;
			
			МетаданныеОбъекта = Значение.Метаданные();
			
			Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1: %2'"), 
				МетаданныеОбъекта.ПредставлениеОбъекта, Строка(Значение));
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли