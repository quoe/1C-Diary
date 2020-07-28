﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	//+++
	////Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Пользователи") Тогда
	//---	
		ВладелецКалендаря = ДанныеЗаполнения;
		Пользователь = РегистрыСведений.СотрудникиПользователя.ПолучитьПользователяПоСотруднику(ВладелецКалендаря);
		Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения, "Наименование");
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
	КонецЕсли;
	
	ДозаполнитьПоУмолчанию();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	ЗаполнитьКлюч();
	
	ДополнительныеСвойства.Вставить("ИзмененаОтметкаСинхронизироватьСGoogle", Ложь);
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	КоличествоЭлементовКоллекции = Доступ.Количество();
	Для ОбратныйИндекс = 1 По КоличествоЭлементовКоллекции Цикл
		Индекс = КоличествоЭлементовКоллекции - ОбратныйИндекс;
		Если Доступ[Индекс].Сотрудник = ВладелецКалендаря Тогда
			Доступ.Удалить(Индекс);
		КонецЕсли;
	КонецЦикла;
	
	Если ПометкаУдаления Тогда
		СинхронизироватьСGoogle = Ложь;
	КонецЕсли;
	
	ДополнительныеСвойства.ИзмененаОтметкаСинхронизироватьСGoogle = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "СинхронизироватьСGoogle") <> СинхронизироватьСGoogle;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.ИзмененаОтметкаСинхронизироватьСGoogle Тогда
		Возврат;
	КонецЕсли;
	
	Если СинхронизироватьСGoogle Тогда
		ДобавитьАктуальныеЗаписиВОчередьНаОтправкуВGoogle();
	Иначе
		ОчиститьОчередьНаОтправкуВGoogle();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДозаполнитьПоУмолчанию()
	
	Если Не ЗначениеЗаполнено(ВладелецКалендаря) Тогда
		
		СотрудникиПользователя = УправлениеНебольшойФирмойСервер.ПолучитьСотрудниковПользователя();
		
		//+++
		////Если СотрудникиПользователя.Количество() > 0 Тогда
		////	ВладелецКалендаря = СотрудникиПользователя[0];
		////КонецЕсли;
		Если ТипЗнч(СотрудникиПользователя) = Тип("СправочникСсылка.Пользователи") Тогда
			ВладелецКалендаря = СотрудникиПользователя;
		КонецЕсли;
		//---
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Пользователь) Тогда
		Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьКлюч()
	
	Если ЗначениеЗаполнено(id) Тогда
		key = ОбменСGoogle.КлючИзИдентификатора(
		id,
		ТипЗнч(ЭтотОбъект));
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		СсылкаНаОбъект = Ссылка;
	Иначе
		СсылкаНаОбъект = ПолучитьСсылкуНового();
		Если Не ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
			СсылкаНаОбъект = Справочники.КалендариСотрудников.ПолучитьСсылку();
			УстановитьСсылкуНового(СсылкаНаОбъект);
		КонецЕсли;
	КонецЕсли;
	
	key = ОбменСGoogle.КлючИзИдентификатора(
	СтрЗаменить(СсылкаНаОбъект.УникальныйИдентификатор(), "-", ""),
	ТипЗнч(ЭтотОбъект));
	
КонецПроцедуры

Процедура ДобавитьАктуальныеЗаписиВОчередьНаОтправкуВGoogle()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЗаписиКалендаряСотрудника.Ссылка
	|ИЗ
	|	Справочник.ЗаписиКалендаряСотрудника КАК ЗаписиКалендаряСотрудника
	|ГДЕ
	|	ЗаписиКалендаряСотрудника.Календарь = &Календарь
	|	И НЕ ЗаписиКалендаряСотрудника.ПометкаУдаления
	|	И ЗаписиКалендаряСотрудника.Начало >= &Период");
	Запрос.УстановитьПараметр("Календарь", Ссылка);
	Запрос.УстановитьПараметр("Период", НачалоДня(ТекущаяДатаСеанса()));
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	УзелДляКалендаряGoogle = ПланыОбмена.ОбменСGoogleCalendar.УзелДляКалендаряGoogle(Ссылка);
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ПланыОбмена.ЗарегистрироватьИзменения(УзелДляКалендаряGoogle, Выборка.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОчиститьОчередьНаОтправкуВGoogle()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОбменСGoogleCalendar.Ссылка
	|ИЗ
	|	ПланОбмена.ОбменСGoogleCalendar КАК ОбменСGoogleCalendar
	|ГДЕ
	|	НЕ ОбменСGoogleCalendar.ЭтотУзел
	|	И ОбменСGoogleCalendar.КалендарьСотрудника = &КалендарьСотрудника");
	Запрос.УстановитьПараметр("КалендарьСотрудника", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	ПланыОбмена.УдалитьРегистрациюИзменений(Выборка.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли