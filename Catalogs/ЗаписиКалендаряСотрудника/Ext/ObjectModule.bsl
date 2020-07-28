﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	ДозаполнитьПоУмолчанию();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Окончание < Начало Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		НСтр("ru='Дата окончания не может быть меньше даты начала.'"),
		ЭтотОбъект,
		"Окончание",
		,
		Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	ЗаполнитьКлючевыеПоля();
	
	ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
	ОбменДанными.Получатели.Очистить();
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЗарегистрироватьИзменениеВПланеОбмена();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДозаполнитьПоУмолчанию()
	
	Если ЗначениеЗаполнено(Календарь) Тогда
		Возврат;
	КонецЕсли;
	
	Календарь = ЗаполнениеОбъектовУНФ.ПолучитьКалендарьСотрудника();
	
КонецПроцедуры

Процедура ЗаполнитьКлючевыеПоля()
	
	Если ПометкаУдаления Тогда
		ETag = "";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Идентификатор) Тогда
		Ключ = ОбменСGoogle.КлючИзИдентификатора(Идентификатор, ТипЗнч(ЭтотОбъект));
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		СсылкаНаОбъект = Ссылка;
	Иначе
		СсылкаНаОбъект = ПолучитьСсылкуНового();
		Если Не ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
			СсылкаНаОбъект = Справочники.ЗаписиКалендаряСотрудника.ПолучитьСсылку();
			УстановитьСсылкуНового(СсылкаНаОбъект);
		КонецЕсли;
	КонецЕсли;
	
	Ключ = ОбменСGoogle.КлючИзИдентификатора(
	СтрЗаменить(СсылкаНаОбъект.УникальныйИдентификатор(), "-", ""),
	ТипЗнч(ЭтотОбъект));
	
	//+++
	//Сразу создадим запись дневника
	//Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
	//	лНовыйДокумент 	= Документы.дДневник.СоздатьДокумент();
	//	ЗаполнитьЗначенияСвойств(лНовыйДокумент, ЭтотОбъект);
	//	лНовыйДокумент.Дата 		= Начало;
	//	лНовыйДокумент.ДатаОкончание = Окончание;
	//	лНовыйДокумент.Основание 	= СсылкаНаОбъект;
	//	лНовыйДокумент.Заголовок 	= Наименование;
	//	лНовыйДокумент.Описание 	= Описание;
	//	
	//	лНовыйДокумент.Записать(РежимЗаписиДокумента.Проведение);
	//	
	//	Если НЕ ЗначениеЗаполнено(Источник) Тогда
	//		Источник 	= лНовыйДокумент.Ссылка;
	//	КонецЕсли; 
	//КонецЕсли;
	
	//Ссылку на самого себя ЗаписиКалендаряСотрудника
	//Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
	//	Если НЕ ЗначениеЗаполнено(Источник) Тогда
	//		Источник 	= СсылкаНаОбъект;
	//	КонецЕсли; 
	//КонецЕсли;
	
	//Ссылку на самого себя ЗаписиКалендаряСотрудника как Неопределено
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		Если НЕ ЗначениеЗаполнено(Источник) Тогда
			Источник 	= Неопределено; //Для этого источник должен быть нескольких типов!
		КонецЕсли; 
	КонецЕсли;
	//---
	
КонецПроцедуры

Процедура ЗарегистрироватьИзменениеВПланеОбмена()
	
	Если Не ЗначениеЗаполнено(Календарь) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Календарь, "СинхронизироватьСGoogle") Тогда
		Возврат;
	КонецЕсли;
	
	УзелДляКалендаряGoogle = ПланыОбмена.ОбменСGoogleCalendar.УзелДляКалендаряGoogle(Календарь);
	
	ОбменДанными.Получатели.Добавить(УзелДляКалендаряGoogle);
	
	УдалитьДублированиеРегистрацииИзменений(УзелДляКалендаряGoogle);
	
КонецПроцедуры

// Удаляет регистрацию изменений в случае, когда у объекта был изменен календарь перед выгрузкой
Процедура УдалитьДублированиеРегистрацииИзменений(УзелДляКалендаряGoogle)
	
	Если ЗначениеЗаполнено(Идентификатор) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЗаписиКалендаряСотрудникаИзменения.Узел
	|ИЗ
	|	Справочник.ЗаписиКалендаряСотрудника.Изменения КАК ЗаписиКалендаряСотрудникаИзменения
	|ГДЕ
	|	ЗаписиКалендаряСотрудникаИзменения.Ссылка = &Ссылка
	|	И ЗаписиКалендаряСотрудникаИзменения.Узел <> &Узел");
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Узел", УзелДляКалендаряGoogle);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ПланыОбмена.УдалитьРегистрациюИзменений(РезультатЗапроса.Выгрузить().ВыгрузитьКолонку(0), Ссылка);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли