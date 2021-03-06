﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


Процедура ПриЗаписи(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 
	
	ПрежняяВалютаУчета = ПараметрыСеанса.ВалютаУчета;
	
	Если ЗначениеЗаполнено(ЭтотОбъект.Значение) И ПрежняяВалютаУчета <> ЭтотОбъект.Значение Тогда
		
		// В регистре сведений "Курсы валют" устанавливаем курс новой базовой валюты самой к себе = 1
		МенеджерЗаписи = РегистрыСведений.КурсыВалют.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.БазоваяВалюта = ЭтотОбъект.Значение;
		МенеджерЗаписи.Валюта        = ЭтотОбъект.Значение;
		МенеджерЗаписи.Кратность     = 1;
		МенеджерЗаписи.Курс          = 1;
		МенеджерЗаписи.Период        = Дата(1980,1,1);
		МенеджерЗаписи.Записать(Истина);
		
		// Получаем список валют, чьи курсы следует пересчитать. 
		//Заодно проверяем курсы этих валют по отношении к новой валюте учета
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ВалютаУчета", ЭтотОбъект.Значение);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Валюты.Ссылка КАК Валюта,
		|	Валюты.Код,
		|	ЕСТЬNULL(КурсыВалютСрезПоследних.Кратность, 0) КАК Кратность
		|ИЗ
		|	Справочник.Валюты КАК Валюты
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(, БазоваяВалюта = &ВалютаУчета) КАК КурсыВалютСрезПоследних
		|		ПО (КурсыВалютСрезПоследних.Валюта = Валюты.Ссылка)";
		
		Выборка = Запрос.Выполнить().Выбрать();
		СписокВалютДляПересчета = Новый Массив;
		
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.Код <> "643" Тогда
				СписокВалютДляПересчета.Добавить(Новый Структура("Валюта,СтатусОперации", Выборка.Валюта, Истина));
			КонецЕсли; 
			
			Если НЕ ЗначениеЗаполнено(Выборка.Кратность) Тогда
				МенеджерЗаписи = РегистрыСведений.КурсыВалют.СоздатьМенеджерЗаписи();
				МенеджерЗаписи.БазоваяВалюта = ЭтотОбъект.Значение;
				МенеджерЗаписи.Валюта        = Выборка.Валюта;
				МенеджерЗаписи.Кратность     = 1;
				МенеджерЗаписи.Курс          = 1;
				МенеджерЗаписи.Период        = Дата(1980,1,1);
				МенеджерЗаписи.Записать(Истина);
			КонецЕсли; 
		
		КонецЦикла; 
		
		// Выполним пересчет из рублей в новую базовую валюту:
		Если ЗначениеЗаполнено(ПрежняяВалютаУчета) И ПрежняяВалютаУчета <> ЭтотОбъект.Значение Тогда
			РаботаСКурсамиВалют.ПересчитатьЗагруженныеКурсыВалют(СписокВалютДляПересчета, ПрежняяВалютаУчета, Дата(2000,1,1), КонецГода(ТекущаяДатаСеанса()));
			ОбщегоНазначенияДеньги.ПроверитьРазрывыКурсовВалют();
		КонецЕсли; 
		
		// Обновим связанные константы
		Константы.ВалютаИндикаторовРабочегоСтола.Установить(ЭтотОбъект.Значение);
		
		// Изменяем валюту в предопределенном элементе справочника финановых целей
		СправочникОбъект = Справочники.ФинансовыеЦели.ОбщиеНакопления.ПолучитьОбъект();
		СправочникОбъект.Валюта = ЭтотОбъект.Значение;
		СправочникОбъект.Записать();
		
		// Обновляем параметры сеанса
		ПараметрыСеанса.ВалютаУчета   = ЭтотОбъект.Значение;
		ПараметрыСеанса.ВалютаОтчетов = ЭтотОбъект.Значение;
		
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ПараметрыСеанса.ВалютаУчета) Тогда
		// Заполнение параметров сеанса при начале работы с пустой базой
		ПараметрыСеанса.ВалютаУчета   = ЭтотОбъект.Значение;
		ПараметрыСеанса.ВалютаОтчетов = ЭтотОбъект.Значение;
	КонецЕсли;
	
КонецПроцедуры



#КонецЕсли
